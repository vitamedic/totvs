/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT358    ³ Autor ³ Alex Júnio de Miranda³ Data ³ 18/08/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de etiquetas com codigo de barras - Recebimento  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit358()
_cfilsb1:=xfilial("SB1")
_cfilsd1:=xfilial("SD1")
_cfilsf1:=xfilial("SF1")

_danota    :=space(9)
_atenota   :="ZZZZZZZZZ"
_ddtdigit  :=ctod("  /  /  ")
_fdtdigit  :=ctod("  /  /  ")
_cdoprod   :=space(15)
_cateprod  :="ZZZZZZZZZZZZZZZ"
_cdolote   :=space(10)
_catelote  :="ZZZZZZZZZZ"
_arevalida :={"Nao","Sim"}
_crevalida :=""
_cqtetiq   := 0

_cporta    :=""
_aportas   :={"COM2:9600,N,8,2","LPT1","COM1:9600,N,8,2"}

@ 000,000 to 350,450 dialog odlg title "Impressao de Etiquetas Recebimento com Codigo de Barras"
@ 010,005 say "Da Nota Fiscal"
@ 010,050 get _danota size 50,8 f3 "SD1"
@ 020,005 say "Ate Nota Fiscal"
@ 020,050 get _atenota size 50,8 f3 "SD1"
@ 030,005 say "Da Dt. Digitacao"
@ 030,050 get _ddtdigit size 40,8
@ 040,005 say "Ate Dt. Digitacao"
@ 040,050 get _fdtdigit size 40,8
@ 050,005 say "Do Produto"
@ 050,050 get _cdoprod size 60,8 f3 "SB1"
@ 060,005 say "Ate o Produto"
@ 060,050 get _cateprod size 60,8 f3 "SB1"
@ 070,005 say "Do Lote"
@ 070,050 get _cdolote size 50,8
@ 080,005 say "Ate o Lote"
@ 080,050 get _catelote size 50,8
@ 090,005 say "Revalidacao"
@ 090,050 combobox _crevalida items _arevalida size 25,8
@ 100,005 say "Qtd. Etiquetas"
@ 100,050 get _cqtetiq picture "@E 9999" size 20,8

@ 120,005 say "Porta"
@ 120,050 combobox _cporta items _aportas size 70,8

@ 140,050 bmpbutton type 1 action _imprime()
@ 140,085 bmpbutton type 2 action close(odlg)

activate dialog odlg centered
return

static function _imprime()
_cfilsd1:=xfilial("SD1")
_cfilsb1:=xfilial("SB1")
_cfilsf4:=xfilial("SF4")
_cfilsb8:=xfilial("SB8")
sb8->(dbsetorder(3))

#IFDEF TOP
	lQuery  := .T.
	tmp1 := GetNextAlias()
	BeginSql Alias tmp1
		
		SELECT
		SD1.D1_COD COD,
		SB1.B1_DESC DESCRI, 
		SB1.B1_LOCPAD ARM,
		SD1.D1_DTVALID DTVALID,
		SD1.D1_DTFABR DTFABR,
		SD1.D1_NUMVOL NUMVOL,
		SB1.B1_TIPO TIPO,
		SD1.D1_LOTECTL LOTECTL
		FROM
		%Table:SD1% SD1
		INNER JOIN %Table:SB1% SB1 ON (SB1.%NotDel% AND B1_FILIAL=%Exp:_cfilsb1% AND B1_COD=D1_COD)
		INNER JOIN %Table:SF4% SF4 ON (SF4.%NotDel% AND F4_FILIAL=%Exp:_cfilsf4% AND F4_CODIGO=SD1.D1_TES AND F4_ESTOQUE='S')
		WHERE SD1.%NotDel%
		AND D1_FILIAL=%Exp:_cfilsd1%
		AND D1_DOC BETWEEN %Exp:_danota% AND %Exp:_atenota%
		AND D1_DTDIGIT BETWEEN %Exp:_ddtdigit% AND %Exp:_fdtdigit%
		AND D1_COD BETWEEN %Exp:_cdoprod% AND %Exp:_cateprod%
		AND D1_LOTECTL BETWEEN %Exp:_cdolote% AND %Exp:_catelote%
		AND D1_LOTECTL <> ' '
		AND D1_TIPO='N'
		AND D1_NUMVOL>0
		AND D1_TP IN ('EE','EN','MP')
		ORDER BY D1_DOC, D1_COD, D1_LOTECTL
		
	EndSql
	
#ENDIF

(tmp1)->(dbgotop())
_lok := .f.

_volume:=0

while ! (tmp1)->(eof()) 
	
	_lok := .t.	
	_ntitulo :=""
	
	if (tmp1)->tipo=="MP"
		_ntitulo := "MATERIA PRIMA"
	else
		_ntitulo := "MATERIAL DE EMBALAGEM"
	endif

	sb8->(dbseek(_cfilsb8+(tmp1)->cod+(tmp1)->arm+(tmp1)->lotectl,.t.))		

	if alltrim(_crevalida)=="Nao"
		_volume:=(tmp1)->numvol
	else                       
		_volume:=_cqtetiq
	endif
	
	_ccodbar:="01" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
	_ccodbar+="0"+alltrim(substr((tmp1)->cod,1,6))+alltrim(substr((tmp1)->cod,1,6)) // CODIGO DE BARRAS DO PRODUTO
	_ccodbar+="17" // IDENTIFICA A DATA DE VALIDADE
	_ccodbar+=dtoc(stod((tmp1)->dtvalid)) // DATA DE VALIDADE (AAMMDD)
	_ccodbar+="37" // IDENTIFICA A QUANTIDADE
	_ccodbar+=strzero(_volume,4) // QUANTIDADE DA CAIXA
	_ccodbar+=">8" // IDENTIFICADOR DE FINALIZACAO DA QUANTIDADE
	_ccodbar+="10" // IDENTIFICA O LOTE
	_ccodbar+=(tmp1)->lotectl // NUMERO DO LOTE
	_ccodimp:="(01)" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
	_ccodimp+="0"+alltrim(substr((tmp1)->cod,1,6))+alltrim(substr((tmp1)->cod,1,6)) // CODIGO DE BARRAS DO PRODUTO

	if alltrim(_crevalida)=="Nao"
		_ccodimp+="(17)" // IDENTIFICA A DATA DE VALIDADE
		_ccodimp+=dtoc(stod((tmp1)->dtvalid)) // DATA DE VALIDADE (AAMMDD)
	else
		_ccodimp+="(17)" // IDENTIFICA A DATA DE VALIDADE
		_ccodimp+=dtoc(sb8->b8_dtvalid) // DATA DE VALIDADE (AAMMDD)
	endif
	_ccodimp+="(37)" // IDENTIFICA A QUANTIDADE
	_ccodimp+=strzero(_volume,4) // QUANTIDADE DA CAIXA
	_ccodimp+="(10)" // IDENTIFICA O LOTE
	_ccodimp+=(tmp1)->lotectl // NUMERO DO LOTE
	
	mscbprinter("S600",_cporta,,62,.F.,,,,10240)
	mscbchkstatus(.f.)
	
	if (tmp1)->tipo=="MP"
		
		for _i:=1 to _volume
			
			mscbbegin(1,6)
			mscbsay(010,003,"VITAMEDIC IND. FARMACEUTICA LTDA","N","0","050,028") // TÍTULO
//			mscbsay(085,003,alltrim(strzero(_i,3))+"/"+alltrim(strzero((tmp1)->numvol,3)),"N","0","050,028") // CAIXA
			mscbsay(085,003,alltrim(strzero(_i,3))+"/"+alltrim(strzero(_volume,3)),"N","0","050,028") // CAIXA
			mscbsay(009,010,alltrim(_ntitulo),"N","0","050,028") // TÍTULO
			mscbsay(011,017,left((tmp1)->cod,6)+"-"+(tmp1)->descri,"N","0","050,035") // CODIGO + DESCRICAO DO PRODUTO
			mscbsay(010,023,"Lote: "+(tmp1)->lotectl,"N","0","050,035") // LOTE

			if alltrim(_crevalida)=="Nao"
				mscbsay(055,023,"Dt.Val.: "+dtoc(stod((tmp1)->dtvalid)),"N","0","050,035") // DATA DE VALIDADE
				mscbsay(009,029,"Dt.Fab.: "+dtoc(stod((tmp1)->dtfabr)),"N","0","050,022") // DATA DE FABRICACAO
				mscbsay(055,029,"Dt.Reanalise: "+dtoc(stod((tmp1)->dtvalid)-180),"N","0","050,022") // REANÁLISE
			else
				mscbsay(055,023,"Dt.Val.: "+dtoc(sb8->b8_dtvalid),"N","0","050,035") // DATA DE VALIDADE
				mscbsay(009,029,"Dt.Fab.: "+dtoc(stod((tmp1)->dtfabr)),"N","0","050,022") // DATA DE FABRICACAO
				mscbsay(055,029,"Dt.Reanalise: "+dtoc(sb8->b8_dtvalid-180),"N","0","050,022") // REANÁLISE
			endif			
			mscbsaybar(005,040,_ccodbar,"N","C",15,.F.,.F.,.F.,,2,1,.T.,.F.,"1",.T.)
			mscbbox(067,043,105,046,60,"B")
			mscbsay(074,045,"QUARENTENA","N","0","050,035",.T.)
			mscbsay(020,055,_ccodimp,"N","0","030,015")
			mscbend()
		next
	else
		mscbbegin(_volume,6)
		mscbsay(010,003,"VITAMEDIC IND. FARMACEUTICA LTDA","N","0","050,028") // TÍTULO
		mscbsay(009,010,alltrim(_ntitulo),"N","0","050,028") // TÍTULO
		mscbsay(011,017,left((tmp1)->cod,6)+"-"+(tmp1)->descri,"N","0","050,035") // CODIGO + DESCRICAO DO PRODUTO
		mscbsay(009,023,"Lote: "+(tmp1)->lotectl,"N","0","050,035") // LOTE
		if alltrim(_crevalida)=="Nao"
			mscbsay(055,023,"Dt.Val.: "+dtoc(stod((tmp1)->dtvalid)),"N","0","050,035") // DATA DE VALIDADE
		else
			mscbsay(055,023,"Dt.Val.: "+dtoc(sb8->b8_dtvalid),"N","0","050,035") // DATA DE VALIDADE
		endif
		mscbsay(009,031,"Dt.Fab.: "+dtoc(stod((tmp1)->dtfabr)),"N","0","050,028") // DATA DE FABRICACAO
		mscbsaybar(005,040,_ccodbar,"N","C",15,.F.,.F.,.F.,,2,1,.T.,.F.,"1",.T.)
		mscbsay(020,055,_ccodimp,"N","0","030,015")
		mscbend()
	endif
	
	mscbcloseprinter()
	(tmp1)->(dbskip())
end

if !_lok
	msgstop("Dados inválidos! NF não encontrada!")
endif

close(odlg)
return

