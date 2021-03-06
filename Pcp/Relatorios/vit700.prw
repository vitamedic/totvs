/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT700   � Autor � Henrique Correia/Totvs� Data � 24/08/17 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Impressao de Etiquetas com Codigo de Barras para Produtos  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitamedic                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vit700()
private cArC2_D1 := ''

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
@ 010,005 say "OP/Lote Controle"
@ 010,050 get _cop size 50,8 valid _vop() F3 "SC2"
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

if cArC2_D1 == 'SC2'
	//adequa莽茫o 脿 emiss茫o da etiqueta para Lote 006984 (gerado na virada do m锚s). 01/06/2006.
	if (sc2->c2_num=="006984")
		_cdtfab :=strzero(month(sc2->c2_emissao),2)+"/"+strzero(year(sc2->c2_datpri),4)
		_cdtval :=strzero(month(sc2->c2_emissao),2)+"/"+strzero(year(sc2->c2_dtvalid),4)
	else
		_cdtfab :=strzero(month(sc2->c2_datpri),2)+"/"+strzero(year(sc2->c2_datpri),4)
		_cdtval :=strzero(month(sc2->c2_dtvalid),2)+"/"+strzero(year(sc2->c2_dtvalid),4)
	endif
	
	_ccodbar:="01" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
	_ccodbar+="0"+alltrim(sb1->b1_codbar) // CODIGO DE BARRAS DO PRODUTO
	_ccodbar+="17" // IDENTIFICA A DATA DE VALIDADE
	_ccodbar+=right(dtoc(sc2->c2_dtvalid),2)+substr(dtoc(sc2->c2_dtvalid),4,2)+"00" // DATA DE VALIDADE (AAMMDD)
	_ccodbar+="37" // IDENTIFICA A QUANTIDADE
	_ccodbar+=strzero(_ncxpad,4) // QUANTIDADE DA CAIXA
	_ccodbar+=">8" // IDENTIFICADOR DE FINALIZACAO DA QUANTIDADE
	_ccodbar+="10" // IDENTIFICA O LOTE
	_ccodbar+=left(_cop,6) // NUMERO DO LOTE
	
	_ccodimp:="(01)" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
	_ccodimp+="0"+alltrim(sb1->b1_codbar) // CODIGO DE BARRAS DO PRODUTO
	_ccodimp+="(17)" // IDENTIFICA A DATA DE VALIDADE
	_ccodimp+=right(dtoc(sc2->c2_dtvalid),2)+substr(dtoc(sc2->c2_dtvalid),4,2)+"00" // DATA DE VALIDADE (AAMMDD)
	_ccodimp+="(37)" // IDENTIFICA A QUANTIDADE
	_ccodimp+=strzero(_ncxpad,4) // QUANTIDADE DA CAIXA
	_ccodimp+="(10)" // IDENTIFICA O LOTE
	_ccodimp+=left(_cop,6) // NUMERO DO LOTE
else
	_ccodimp:="(01)" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
	_ccodimp+="0"+alltrim(sb1->b1_codbar) // CODIGO DE BARRAS DO PRODUTO
	_ccodimp+="(17)" // IDENTIFICA A DATA DE VALIDADE
	_ccodimp+=right(dtoc(sd1->d1_dtvalid),2)+substr(dtoc(sd1->d1_dtvalid),4,2)+"00" // DATA DE VALIDADE (AAMMDD)
	_ccodimp+="(37)" // IDENTIFICA A QUANTIDADE
	_ccodimp+=strzero(_ncxpad,4) // QUANTIDADE DA CAIXA
	_ccodimp+="(10)" // IDENTIFICA O LOTE
	_ccodimp+=left(_cop,6) // NUMERO DO LOTE
endif
	
mscbprinter("S600",_cporta,,62,.F.,,,,10240)

mscbbegin(_nqtetiq,6,62)  

mscblineh(02,46,105,5,"B")   //96 > 76 mscblineh(02,13,96,3,"B")
//mscblinev(02,01,13)
             //Vitapan
mscbsay(60,52,"Vitamedic","I","0","070,090") //mscbsay(70,52,"Vitamedic","I","0","070,090") //  
mscbsay(68,49,"Industria Farmaceutica Ltda.","I","0","025,025") // 
mscbsay(96,42,"Produto:","I","0","020,020") // Produto

mscbsay(06,44,sb1->b1_codres,"I","0","145,130") // CODIGO RESUMIDO
//mscbsay(25,36,left(sb1->b1_cod,6)+"-"+substr(sb1->b1_desc,1,34),"I","0","050,030") // CODIGO + DESCRICAO DO PRODUTO
if len(alltrim(sb1->b1_desc))>40
	mscbsay(30,36,left(sb1->b1_cod,6)+"-"+alltrim(sb1->b1_desc),"I","0","050,022") // CODIGO + DESCRICAO DO PRODUTO
else
	mscbsay(30,36,left(sb1->b1_cod,6)+"-"+sb1->b1_desc,"I","0","050,028") // CODIGO + DESCRICAO DO PRODUTO
endif  
mscbsay(23,42,"Lote:","I","0","020,020") // Lote
mscbsay(08,36,left(_cop,6),"I","0","050,035") // LOTE  

mscbsay(90,31,"Apresentacao:","I","0","020,020") // Apresentacao
mscbsay(22,31,"Caixa:","I","0","020,020") // Caixa

mscbsay(40,27,sb1->b1_apres,"I","0","050,022") // (34) APRESENTACAO
mscbsay(10,27,alltrim(str(_ncxpad,4)),"I","0","050,035") // CAIXA 

mscbsay(85,23,"Data de Fabricacao","I","0","020,020") // DATA DE FABRICACAO
mscbsay(87,11,"Data de Validade","I","0","020,020") // DATA DE VALIDADE

mscbsay(87,15,_cdtfab,"I","0","050,035") // DATA DE FABRICACAO 87,18
mscbsay(87,04,_cdtval,"I","0","050,035") // DATA DE VALIDADE   87,09

mscbsaybar(08,07,_ccodbar,"I","C",18,.F.,.F.,.F.,,2,1,.T.,.F.,"1",.T.)
mscbsay(08,01,_ccodimp,"I","0","040,022")    //mscbsay(08,02

mscbend()
mscbcloseprinter()
close(odlg)
return

static function _vop()
cArC2_D1 := 'SC2'
_lok:=.t.
sc2->(dbsetorder(1))
if ! sc2->(dbseek(_cfilsc2+_cop))
	//msgstop("OP n茫o encontrada!")
	_lok:=.f.
	cArC2_D1 := ''
	if MsgYesNo("OP n鉶 encontrada. Deseja pesquisar em documentos de entrada?", "A t e n � � o")
		dbSelectArea("SD1")
		sd1->(dbOrderNickName("D1VALID")) //D1_FILIAL+D1_LOTECTL+D1_COD
		if sd1->(dbseek(xfilial("SD1")+pad(_cop,10)))
			_lok:=.t.
			cArC2_D1 := 'SD1'
			sb1->(dbsetorder(1))
			sb1->(dbseek(_cfilsb1+sd1->d1_cod))
			_cproduto:=sd1->d1_cod
			_cdesc   :=sb1->b1_desc
			_ddtvalid:=sd1->d1_dtvalid
			_ncxpad  :=sb1->b1_cxpad
		endif	
	endif
else
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+sc2->c2_produto))
	_cproduto:=sc2->c2_produto
	_cdesc   :=sb1->b1_desc
	_ddtvalid:=sc2->c2_dtvalid
	_ncxpad  :=sb1->b1_cxpad
endif
return(_lok)