/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT368    ³Autor ³ Alex Júnio de Miranda  ³Data ³ 09/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Etiquetas com Codigo de Barras - Produto Aca- ³±±
±±³          ³ bado - Identificação PA                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit368()
_cfilsb1:=xfilial("SB1")
_cfilsc2:=xfilial("SC2")

_cop     :=space(13)
_cproduto:=space(15)
_cdesc   :=space(40)
_ncxpad  :=0
_ddtvalid:=ctod("  /  /  ")
_nqtetiq :=0
_cporta  :=""
_aportas :={"COM2:9600,N,8,2","LPT1","COM1:9600,N,8,2"}

@ 000,000 to 220,450 dialog odlg title "Impressao de etiquetas com codigo de barras"
@ 010,005 say "OP"
@ 010,050 get _cop size 50,8 valid _valop() f3 "SC2"
@ 020,005 say "Produto"
@ 020,050 get _cproduto size 40,8 when .f.
@ 020,050 get _cdesc size 120,8 when .f.
@ 030,005 say "Validade"
@ 030,050 get _ddtvalid size 40,8 when .f.
@ 040,005 say "Caixa padrao"
@ 040,050 get _ncxpad size 15,8 picture "@E 9,999" valid naovazio() .and. positivo()
@ 050,005 say "Etiquetas"
@ 050,050 get _nqtetiq size 30,8 picture "@E 999,999" valid naovazio() .and. positivo()
@ 060,005 say "Porta"
@ 060,050 combobox _cporta items _aportas size 50,8

@ 080,050 bmpbutton type 1 action _imprime()
@ 080,085 bmpbutton type 2 action close(odlg)

activate dialog odlg centered
return

static function _imprime()

_ccodbar:="01" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
_ccodbar+="0000000000000" // CODIGO DE BARRAS DO PRODUTO
//_ccodbar+="0"+alltrim(substr((tmp1)->cod,1,6))+alltrim(substr((tmp1)->cod,1,6)) // CODIGO DE BARRAS DO PRODUTO
_ccodbar+="17" // IDENTIFICA A DATA DE VALIDADE
_ccodbar+="00/00/0000" // DATA DE VALIDADE (AAMMDD)
_ccodbar+="37" // IDENTIFICA A QUANTIDADE
_ccodbar+="0000" // QUANTIDADE DA CAIXA
_ccodbar+=">8" // IDENTIFICADOR DE FINALIZACAO DA QUANTIDADE
_ccodbar+="10" // IDENTIFICA O LOTE
_ccodbar+="000000"// NUMERO DO LOTE
_ccodimp:="(01)" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
_ccodimp+="0000000000000" // CODIGO DE BARRAS DO PRODUTO

_ccodimp+="(17)" // IDENTIFICA A DATA DE VALIDADE
_ccodimp+="00/00/0000" // DATA DE VALIDADE (AAMMDD)
_ccodimp+="(37)" // IDENTIFICA A QUANTIDADE
_ccodimp+="0000" // QUANTIDADE DA CAIXA
_ccodimp+="(10)" // IDENTIFICA O LOTE
_ccodimp+="000000" // NUMERO DO LOTE
	
mscbprinter("S600",_cporta,,62,.F.,,,,10240)
mscbchkstatus(.f.)
	
mscbbegin(1,6) 

//	mscbsay(06,44,sb1->b1_codres,"I","0","145,130") // CODIGO RESUMIDO
	//mscbsay(25,36,left(sb1->b1_cod,6)+"-"+substr(sb1->b1_desc,1,34),"I","0","050,030") // CODIGO + DESCRICAO DO PRODUTO
//	mscbsay(25,36,left(sb1->b1_cod,6)+"-"+sb1->b1_desc,"I","0","050,028") // CODIGO + DESCRICAO DO PRODUTO
//	mscbsay(08,36,left(_cop,6),"I","0","050,035") // LOTE
//	mscbsay(25,27,sb1->b1_apres,"I","0","050,022") // (34) APRESENTACAO
//	mscbsay(10,27,alltrim(str(_ncxpad,4)),"I","0","050,035") // CAIXA
//	mscbsay(87,18,_cdtfab,"I","0","050,035") // DATA DE FABRICACAO
//	mscbsay(87,09,_cdtval,"I","0","050,035") // DATA DE VALIDADE
//	mscbsaybar(08,07,_ccodbar,"I","C",18,.F.,.F.,.F.,,2,1,.T.,.F.,"1",.T.)
//	mscbsay(08,02,_ccodimp,"I","0","040,022")
	
	mscbsay(010,003,"Vitamedic","N","0","073,050") // LOGOMARCA
	mscbsay(009,010,left(sb1->b1_cod,6)+"-"+sb1->b1_desc,"N","0","050,035") // CODIGO + DESCRICAO DO PRODUTO
	mscbsay(009,016,"PRINCIPIO ATIVO 1 999MG","N","0","050,028") // PRINCIPIO ATIVO 1
	mscbsay(009,022,"PRINCIPIO ATIVO 2 888MG","N","0","050,028") // PRINCIPIO ATIVO 2
	mscbsay(009,028,"PRINCIPIO ATIVO 3 777MG","N","0","050,028") // PRINCIPIO ATIVO 3
	mscbsay(009,034,sb1->b1_apres,"N","0","050,028") // APRESENTACAO
	mscbsay(085,034,"CX: "+alltrim(strzero(_ncxpad,4)),"N","0","050,028") // CAIXA
//	mscbsay(085,034,"0000","N","0","050,028") // CAIXA
	mscbsay(009,040,"Lote: "+left(_cop,6),"N","0","050,035") // LOTE
	mscbsay(009,046,"Dt.Fab.: "+dtoc(_ddtvalid),"N","0","050,035") // DATA DE FABRICACAO
	mscbsay(055,046,"Dt.Val.: "+dtoc(_ddtvalid),"N","0","050,035") // DATA DE VALIDADE

	mscbsay(009,052,"Conservar em Temperatura Ambiente (15 e 30ºC).","N","0","050,022") // Dizeres 1
	mscbsay(009,058,"Proteger da Luz e Umidade","N","0","050,022") // Dizeres 2

	mscbsaybar(005,067,_ccodbar,"N","C",15,.F.,.F.,.F.,,2,1,.T.,.F.,"1",.T.)
	mscbsay(020,082,_ccodimp,"N","0","030,015")
mscbend()

mscbcloseprinter()
close(odlg)
return

/* Valida a Existência de um Nº OP existente */
static function _valop()
_lok:=.t.
sc2->(dbsetorder(1))
if ! sc2->(dbseek(_cfilsc2+_cop))
	msgstop("OP não encontrada!")
	_lok:=.f.
else
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+sc2->c2_produto))
	_cproduto:=sc2->c2_produto
	_cdesc   :=sb1->b1_desc
	_ddtvalid:=sc2->c2_dtvalid
	_ncxpad  :=sb1->b1_cxpad
endif
return(_lok)

