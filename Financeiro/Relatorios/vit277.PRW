/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT277   � Autor � Alex J鷑io            � Data � 10/10/06 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Carta de Notificacao Extra Judicial de Cobranca a Clientes 潮�
北�          � em Atraso                                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitamedic                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "topconn.ch"
#include "rwmake.ch"
#INCLUDE "avprint.ch"

user function VIT277()


rptstatus({|| RunReport()})
return

static function RunReport()

SetPrvt("oFontA10,oFontA10B,oFontA12,oFontA12B,oFontA12BS,oFontA14,oFontA14B,oFontA16,oFontA16B")
SetPrvt("oFontT10,oFontT1BB,oFontT12,oFontT12B,oFontT14,oFontT14B,oPrn")

//----------------------------------------------------------------------------//
// Defini珲es do objeto de impress鉶 AVPRINT
//----------------------------------------------------------------------------//
/*
#xcommand AVPRINT [ <oPrint> ] ;
[ <name:TITLE,NAME,DOC> <cDocument> ] ;
[ <user: FROM USER> ] ;
[ <prvw: PREVIEW> ] ;
[ TO  <xModel> ] ;
=> ;
[ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPRINTER [ <oPrint> ] ;
[ <name:NAME,DOC> <cDocument> ] ;
[ <user: FROM USER> ] ;
[ <prvw: PREVIEW> ] ;
[ TO  <xModel> ] ;
=> ;
[ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPAGE       => AvPageBegin()
#xcommand AVENDPAGE    => AvPageEnd()
#xcommand AVNEWPAGE    => AvPageEnd()  ; AvPageBegin()
#xcommand AVENDPRINT   => AvPrintEnd() ; //AvSetPortrait()
#xcommand AVENDPRINTER => AvPrintEnd() ; //AvSetPortrait()
*/

//------------------------------------------------------------------------------//

AVPRINT oPrn NAME "Carta de Notifica玢o Extrajudicial"

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矰efini珲es de Fontes que ser鉶 utilizadas pelo relat髍io�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

oFontA10  	:=  oSend(TFont(),"New","Courier New"    ,0,10,,.F.,,,,,,,,,,,oPrn )
oFontA10B 	:=  oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )
oFontA12 	:=  oSend(TFont(),"New","Courier New"    ,0,12,,.F.,,,,,,,,,,,oPrn )
oFontA12B 	:=  oSend(TFont(),"New","Courier New"    ,0,12,,.T.,,,,,,,,,,,oPrn )
oFontA12BS 	:=  oSend(TFont(),"New","Courier New"    ,0,12,,.T.,,,,,.T.,,,,,,oPrn )
oFontA14 	:=  oSend(TFont(),"New","Courier New"    ,0,14,,.F.,,,,,,,,,,,oPrn )
oFontA14B 	:=  oSend(TFont(),"New","Courier New"    ,0,14,,.T.,,,,,,,,,,,oPrn )
oFontA16 	:=  oSend(TFont(),"New","Courier New"    ,0,16,,.F.,,,,,,,,,,,oPrn )
oFontA16B 	:=  oSend(TFont(),"New","Courier New"    ,0,16,,.T.,,,,,,,,,,,oPrn )

oFontT10 	:= oSend(TFont(),"New","Times New Roman"          ,0,10,,.F.,,,,,,,,,,,oPrn )
oFontT10B 	:= oSend(TFont(),"New","Times New Roman"          ,0,10,,.T.,,,,,,,,,,,oPrn )
oFontT12 	:= oSend(TFont(),"New","Times New Roman"          ,0,12,,.F.,,,,,,,,,,,oPrn )
oFontT12B 	:= oSend(TFont(),"New","Times New Roman"          ,0,12,,.T.,,,,,,,,,,,oPrn )
oFontT14 	:= oSend(TFont(),"New","Times New Roman"          ,0,14,,.F.,,,,,,,,,,,oPrn )
oFontT14B 	:= oSend(TFont(),"New","Times New Roman"          ,0,14,,.T.,,,,,,,,,,,oPrn )
oFontT16 	:= oSend(TFont(),"New","Times New Roman"          ,0,16,,.F.,,,,,,,,,,,oPrn )
oFontT16B 	:= oSend(TFont(),"New","Times New Roman"          ,0,16,,.T.,,,,,,,,,,,oPrn )
oFontT18 	:= oSend(TFont(),"New","Times New Roman"          ,0,18,,.F.,,,,,,,,,,,oPrn )
oFontT18B 	:= oSend(TFont(),"New","Times New Roman"          ,0,18,,.T.,,,,,,,,,,,oPrn )

AVPAGE

_page:=1

_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
sa1->(dbsetorder(1))
se1->(dbsetorder(1))

processa({|| _geratmp()})

tmp1->(dbgotop())

while ! tmp1->(eof())

	if _page>1
		AVNEWPAGE
	endif

	nLinAtual := oDesCabec(.t.)				// Monta o cabe鏰lho da Carta de Notifica玢o
	
	_cliente :=tmp1->cliente
	_loja    :=tmp1->loja               
	while ! tmp1->(eof()) .and.;
			tmp1->cliente==_cliente .and.;
			tmp1->loja==_loja

		if nLinAtual > 3000
			oPrn:Say( 3100,350, "**** CONTINUA ****" ,oFontA10)
			AVNEWPAGE
		endif

		nLinAtual := oDesLinha(nLinAtual)
		
		tmp1->(dbskip())
	end

	nLinAtual:=nLinAtual + 250
	oPrn:Say(nLinAtual, 350, "     Prezado  Senhores,  pelo  presente  instrumento  particular,",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "vimos  comunicar  que  ap髎  diversas  infrut韋eras  tentativas  de",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "contato,  restando  a  dificuldade  de  recebimento  pelos  meios",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "regulares, serve-se esta para:",oFontA12)
	nLinAtual:=nLinAtual + 100
	oPrn:Say(nLinAtual, 800, "NOTIFICAR EXTRAJUDICIALMENTE",oFontA14)
	nLinAtual:=nLinAtual + 100
	oPrn:Say(nLinAtual, 350, "ao  senhor  e  sucessores,  a  repeito  do  d閎ito  acima  descrito,",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "aberto  at�  a  presente  data  em  nossos  registros,  que  efetue  o",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "pagamento  da  pend阯cia  no",oFontA12)
	oPrn:Say(nLinAtual, 1150, "PRAZO  IMPRORROG罺EL  DE  CINCO  DIAS,",oFontA12BS)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "contados  do  recebimento  desta,  e  pronuncie-se  oficialmente  com",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "nosso  departamento  Financeiro,  sem  preju韟o  das  medidas  legais",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "cab韛eis,  sob  pena  de  n鉶  o  fazendo,  ser  interpretado  como",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "concord鈔cia  do  esgotamento  das  in鷐eras  tentativas  amig醰eis  de",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "negocia玢o  e  de  sujeitar-se  鄐  provid阯cias  judiciais.",oFontA12)
 
	nLinAtual:=nLinAtual + 200

	oPrn:Say(nLinAtual, 350, "Atenciosamente,",oFontA12)
	nLinAtual:=nLinAtual + 200

	oPrn:Say(nLinAtual, 600, "OBS: Caso os t韙ulos em quest鉶 j� tenham sido quitados, favor",oFontA10)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 600, "desconsiderar a presente notifica玢o e entrar em contato para",oFontA10)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 600, "apresenta玢o da devida comprova玢o junto ao departamento Financeiro",oFontA10)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 600, "para a devida e definitiva baixa.",oFontA10)
	nLinAtual:=nLinAtual + 300
	
	oPrn:Say(nLinAtual, 350, "Vitamedic Ind鷖tria Farmac陁tica Ltda.",oFontA12)
   _page++
end

set device to screen

tmp1->(dbclosearea())

AVENDPAGE

AVENDPRINT

MS_FLUSH()

return


/******************************************************************************************
/** MONTA CABE茿LHO DAS P罣INAS
/******************************************************************************************/

Static Function oDesCabec(lProd)

oPrn:Say(350, 960, "NOTIFICA敲O EXTRAJUDICIAL DE COBRAN茿",oFontA14B)
oPrn:Say(450, 1300, "An醦olis, " + U_DataExt(dDatabase),oFontA12)

oPrn:Say(700, 350, "NOTIFICANTE: Vitamedic Ind鷖tria Farmac陁tica Ltda." ,oFontA12,100)

sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
oPrn:Say(750, 350, "NOTIFICADO(S): "+sa1->a1_nome,oFontA12,100)

oPrn:Box(850, 350, 900, 2100)  // Constr骾 quadro para tabela
oPrn:Line(850, 650, 900, 650)  // Linha de divis鉶 entre coluna 01 e 02
oPrn:Line(850, 1000, 900, 1000)  // Linha de divis鉶 entre coluna 02 e 03
oPrn:Line(850, 1350, 900, 1350)  // Linha de divis鉶 entre coluna 03 e 04
oPrn:Line(850, 1700, 900, 1700)  // Linha de divis鉶 entre coluna 04 e 05
oPrn:Say( 850, 360, "NOTA FISCAL",oFontA12)
oPrn:Say( 850, 660, "FATURA N�",oFontA12)
oPrn:Say( 850, 1010, "VALOR R$",oFontA12)
oPrn:Say( 850, 1360, "DATA EMISS肙",oFontA12)
oPrn:Say( 850, 1710, "VENCIMENTO",oFontA12)

nRet:=900

Return(nRet)

                                   

/******************************************************************************************
/** MONTA LINHAS DE ITENS DA TABELA
/******************************************************************************************/

Static Function oDesLinha(nLin)
// Desenha linhas da tabelas de Faturas e retorna o valor da linha onde terminou o box

oPrn:Box( nLin, 0350, nLin+50, 2100)  // Constr骾 quadro para tabela
oPrn:Line(nLin, 0650, nLin+50, 0650)  // Linha de divis鉶 entre coluna 01 e 02
oPrn:Line(nLin, 1000, nLin+50, 1000)  // Linha de divis鉶 entre coluna 02 e 03
oPrn:Line(nLin, 1350, nLin+50, 1350)  // Linha de divis鉶 entre coluna 03 e 04
oPrn:Line(nLin, 1700, nLin+50, 1700)  // Linha de divis鉶 entre coluna 04 e 05
oPrn:Say( nLin, 360, "XXXXXXXXX 1",oFontA12)
oPrn:Say( nLin, 660, "XXXXXXXXX 2",oFontA12)
oPrn:Say( nLin, 1010, "999.999,99",oFontA12)
oPrn:Say( nLin, 1360, "99/99/9999",oFontA12)
oPrn:Say( nLin, 1710, "99/99/9999",oFontA12)


Return(nLin+50)



//*******************************************************************************
//* FUN钦ES DE APOIO
//*******************************************************************************

Static Function oSomaLinha(nLin,nTam,lProd)

nRet := nLin + nTam

if nRet > 3000
	oPrn:Say( 3100,350, "**** CONTINUA ****" ,oFontT10)
	AVENDPAGE
	AVPAGE
	nPag := nPag + 1
	nRet := 350
endif

Return(nRet)



Static Function oDesBox(nLin)

nLin := oSomaLinha(nLin,050,.t.)

oPrn:Box(  nLin-050, 350, nLin, 2100 )
oPrn:Line( nLin-050, 700, nLin, 700 )//1

return(nLin)



/******************************************************************************************
/** GERA ARQUIVO TEMPOR罵IO COM DADOS PARA O RELAT覴IO
/******************************************************************************************/

static function _geratmp()
procregua(1)

incproc("Selecionando titulos vencidos...")
_cquery:=" SELECT"
_cquery+=" E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_PREFIXO PREFIXO,E1_NUM NUMERO,"
_cquery+=" E1_PARCELA PARCELA,E1_TIPO TIPO,E1_EMISSAO EMISSAO,"
_cquery+=" E1_VENCTO VENCTO,E1_SALDO SALDO,E1_PORTADO PORTADOR,E1_VALOR VALOR,E1_JUROS JUROS"
_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_VENCTO <= '20060813'"
_cquery+=" AND E1_TIPO NOT IN ('RA ','NCC','PR ')"
_cquery+=" AND SUBSTR(E1_TIPO,3,1)<>'-'"
_cquery+=" AND E1_SALDO>0"
_cquery+=" ORDER BY"
_cquery+=" E1_CLIENTE,E1_LOJA,E1_VENCTO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VENCTO" ,"D")
tcsetfield("TMP1","SALDO"  ,"N",15,2)
tcsetfield("TMP1","VALOR"  ,"N",15,2)
tcsetfield("TMP1","JUROS"  ,"N",15,2)
return