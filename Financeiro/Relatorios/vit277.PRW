/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT277   ³ Autor ³ Alex Júnio            ³ Data ³ 10/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carta de Notificacao Extra Judicial de Cobranca a Clientes ³±±
±±³          ³ em Atraso                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
// Definições do objeto de impressão AVPRINT
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

AVPRINT oPrn NAME "Carta de Notificação Extrajudicial"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definições de Fontes que serão utilizadas pelo relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

	nLinAtual := oDesCabec(.t.)				// Monta o cabeçalho da Carta de Notificação
	
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
	oPrn:Say(nLinAtual, 350, "vimos  comunicar  que  após  diversas  infrutíferas  tentativas  de",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "contato,  restando  a  dificuldade  de  recebimento  pelos  meios",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "regulares, serve-se esta para:",oFontA12)
	nLinAtual:=nLinAtual + 100
	oPrn:Say(nLinAtual, 800, "NOTIFICAR EXTRAJUDICIALMENTE",oFontA14)
	nLinAtual:=nLinAtual + 100
	oPrn:Say(nLinAtual, 350, "ao  senhor  e  sucessores,  a  repeito  do  débito  acima  descrito,",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "aberto  até  a  presente  data  em  nossos  registros,  que  efetue  o",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "pagamento  da  pendência  no",oFontA12)
	oPrn:Say(nLinAtual, 1150, "PRAZO  IMPRORROGÁVEL  DE  CINCO  DIAS,",oFontA12BS)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "contados  do  recebimento  desta,  e  pronuncie-se  oficialmente  com",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "nosso  departamento  Financeiro,  sem  prejuízo  das  medidas  legais",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "cabíveis,  sob  pena  de  não  o  fazendo,  ser  interpretado  como",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "concordância  do  esgotamento  das  inúmeras  tentativas  amigáveis  de",oFontA12)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 350, "negociação  e  de  sujeitar-se  às  providências  judiciais.",oFontA12)
 
	nLinAtual:=nLinAtual + 200

	oPrn:Say(nLinAtual, 350, "Atenciosamente,",oFontA12)
	nLinAtual:=nLinAtual + 200

	oPrn:Say(nLinAtual, 600, "OBS: Caso os títulos em questão já tenham sido quitados, favor",oFontA10)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 600, "desconsiderar a presente notificação e entrar em contato para",oFontA10)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 600, "apresentação da devida comprovação junto ao departamento Financeiro",oFontA10)
	nLinAtual:=nLinAtual + 50
	oPrn:Say(nLinAtual, 600, "para a devida e definitiva baixa.",oFontA10)
	nLinAtual:=nLinAtual + 300
	
	oPrn:Say(nLinAtual, 350, "Vitamedic Indústria Farmacêutica Ltda.",oFontA12)
   _page++
end

set device to screen

tmp1->(dbclosearea())

AVENDPAGE

AVENDPRINT

MS_FLUSH()

return


/******************************************************************************************
/** MONTA CABEÇALHO DAS PÁGINAS
/******************************************************************************************/

Static Function oDesCabec(lProd)

oPrn:Say(350, 960, "NOTIFICAÇÃO EXTRAJUDICIAL DE COBRANÇA",oFontA14B)
oPrn:Say(450, 1300, "Anápolis, " + U_DataExt(dDatabase),oFontA12)

oPrn:Say(700, 350, "NOTIFICANTE: Vitamedic Indústria Farmacêutica Ltda." ,oFontA12,100)

sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
oPrn:Say(750, 350, "NOTIFICADO(S): "+sa1->a1_nome,oFontA12,100)

oPrn:Box(850, 350, 900, 2100)  // Constrói quadro para tabela
oPrn:Line(850, 650, 900, 650)  // Linha de divisão entre coluna 01 e 02
oPrn:Line(850, 1000, 900, 1000)  // Linha de divisão entre coluna 02 e 03
oPrn:Line(850, 1350, 900, 1350)  // Linha de divisão entre coluna 03 e 04
oPrn:Line(850, 1700, 900, 1700)  // Linha de divisão entre coluna 04 e 05
oPrn:Say( 850, 360, "NOTA FISCAL",oFontA12)
oPrn:Say( 850, 660, "FATURA Nº",oFontA12)
oPrn:Say( 850, 1010, "VALOR R$",oFontA12)
oPrn:Say( 850, 1360, "DATA EMISSÃO",oFontA12)
oPrn:Say( 850, 1710, "VENCIMENTO",oFontA12)

nRet:=900

Return(nRet)

                                   

/******************************************************************************************
/** MONTA LINHAS DE ITENS DA TABELA
/******************************************************************************************/

Static Function oDesLinha(nLin)
// Desenha linhas da tabelas de Faturas e retorna o valor da linha onde terminou o box

oPrn:Box( nLin, 0350, nLin+50, 2100)  // Constrói quadro para tabela
oPrn:Line(nLin, 0650, nLin+50, 0650)  // Linha de divisão entre coluna 01 e 02
oPrn:Line(nLin, 1000, nLin+50, 1000)  // Linha de divisão entre coluna 02 e 03
oPrn:Line(nLin, 1350, nLin+50, 1350)  // Linha de divisão entre coluna 03 e 04
oPrn:Line(nLin, 1700, nLin+50, 1700)  // Linha de divisão entre coluna 04 e 05
oPrn:Say( nLin, 360, "XXXXXXXXX 1",oFontA12)
oPrn:Say( nLin, 660, "XXXXXXXXX 2",oFontA12)
oPrn:Say( nLin, 1010, "999.999,99",oFontA12)
oPrn:Say( nLin, 1360, "99/99/9999",oFontA12)
oPrn:Say( nLin, 1710, "99/99/9999",oFontA12)


Return(nLin+50)



//*******************************************************************************
//* FUNÇÕES DE APOIO
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
/** GERA ARQUIVO TEMPORÁRIO COM DADOS PARA O RELATÓRIO
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