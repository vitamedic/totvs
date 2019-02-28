#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "ap5mail.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT143   ³ Autor ³ Fabricio F. Santos ³ Data ³  12/08/03   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Programa para Emissao do Relatorio de Pedidos x Nota       ³±±
±±³          ³ por Representante via E-Mail                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function VIT143

Private cPass     := GetMv("MV_RELPSW")
Private cAccount  := GetMv("MV_RELACNT")
Private cServer   := GetMv("MV_RELSERV")
Private _cfilsa1 := xFilial("SA1")
Private _cfilsa3 := xFilial("SA3")
Private _cfilsb1 := xFilial("SB1")
Private _cfilsc5 := xFilial("SC5")
Private _cfilsc6 := xFilial("SC6")
Private _cfilsf2 := xFilial("SF2")
Private _cfilsf4 := xFilial("SF4")

Private cPara     := Space(100)
Private cMensagem := ""
Private cAssunto  := 'Pedidos X Faturamento'
Private _CRLF := chr(13)+chr(10)
Private cMSG := ""

//Verifica o e-mail do usuario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
	cAccount := AllTrim(aRet[1,14])
EndIf

//Verifica o e-mail do funcionario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
	cAccount := AllTrim(aRet[1,14])
EndIf

cperg:="PERGVIT143"
_pergsx1()
pergunte(cperg,.f.)


aOpPrc 	:= {"Vendedor  ","Tela",""}
nOpPrc	:= 1

@ 106,74 To 346,606 Dialog oDialog Title OemToAnsi("Relatorio -- Email")
@ 9,12 To 63,196 Title OemToAnsi("Pedidos Pendentes") Object Quadro
@ 25,24 Say OemToAnsi("Este programa enviara o relatorio Pedidos X Faturamento") Size 150,8
@ 38,25 Say OemToAnsi("por e-mail no formato Html conforme os parametros os") Size 150,8
@ 49,26 Say OemToAnsi("especificados.") Size 42,8

@ 67,25 Say OemToAnsi("Enviar Para:") Size 34,8
@ 77,25 Radio aOpPrc Var nOpPrc
@ 94,33 Get cPara Size 115,10

@ 13,207 Button OemToAnsi("_Confirma") Size 36,16 Action Processa({|| _ProcMail()})
@ 30,207 Button OemToAnsi("_Cancela") Size 36,16 Action Close(oDialog)
@ 47,207 Button OemToAnsi("_Parametros") Size 36,16 Action Pergunte(cPerg,.T.)
Activate Dialog oDialog

Return

Static Function _ProcMail()
If nOpPrc == 3 .AND. Len(alltrim(cPara)) == 0
	MsgStop("Informe o e-mail!!!")
	Return
EndIf

cServer  := alltrim(cServer)
cAccount := alltrim(cAccount)
cPass    := alltrim(cPass)
cPara    := alltrim(cPara)

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass Result lResult

If !lResult
	MsgStop("Problemas na conexao com o servidor de e-mail!!!")
	Return
EndIf

cmsg := ""
SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
SC5->(dbSetOrder(1))
SD2->(dbSetOrder(8))

_geratmp(nOpPrc == 1)

ProcRegua(SC6->(LastRec()))

If nOpPrc <> 1
	_abremail()
EndIf
lEnvia := .F.
_nGerVen := 0
_nGerPen := 0
_nGerFat := 0
While !TMP1->(EOF())
	If !SD2->(dbSeek(xFilial()+TMP1->C5_NUM))
		IncProc()
		TMP1->(dbSkip())
		Loop
	EndIf
	_cVend := TMP1->C5_VEND1
	_nRepVen := 0
	_nRepPen := 0
	_nRepFat := 0
	SA3->(dbSeek(xFilial()+_cVend))
	If nOpPrc == 1
		_abremail()
	EndIf
	cMsg += '<p><b><font size="2">Representante..:</font></b> <font size="2">'+SA3->A3_COD+" "+AllTrim(SA3->A3_NOME)+'</font></p>'
	cMsg += '<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="101">'
	cMsg += '  <tr>'
	cMsg += '    <td width="33%" align="left" height="19"><b><font size="2">&nbsp</font></b></td>'
	cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">&nbsp</font></b></td>'
	cMsg += '    <td width="5%" align="center" height="19"><b><font size="2">&nbsp</font></b></td>'
	cMsg += '    <td width="9%" align="center" height="19"><b><font size="2">R$</font></b></td>'
	cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">&nbsp</font></b></td>'
	cMsg += '    <td width="9%" align="center" height="19"><b><font size="2">R$</font></b></td>'
	cMsg += '    <td width="9%" align="center" height="19"><b><font size="2">R$</font></b></td>'
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp</font></b></td>'
	cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">PZ</font></b></td>'
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp</font></b></td>'
	cMsg += '  </tr>'
	cMsg += '  <tr>'
	cMsg += '    <td width="33%" align="left" height="19"><b><font size="2">CLIENTE</font></b></td>'
	cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">DT</font></b></td>'
	cMsg += '    <td width="5%" align="center" height="19"><b><font size="2">TP</font></b></td>'
	cMsg += '    <td width="9%" align="center" height="19"><b><font size="2">PEDIDO</font></b></td>'
	cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">DT</font></b></td>'
	cMsg += '    <td width="9%" align="center" height="19"><b><font size="2">FAT</font></b></td>'
	cMsg += '    <td width="9%" align="center" height="19"><b><font size="2">PENDEN</font></b></td>'
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">DESC</font></b></td>'
	cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">MEDIO</font></b></td>'
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">COMIS</font></b></td>'
	cMsg += '  </tr>'
	While !TMP1->(EOF()) .AND. _cVend == TMP1->C5_VEND1
		_cCli := TMP1->(C5_CLIENTE+C5_LOJACLI)
		_nCliVen := 0
		_nCliPen := 0
		_nCliFat := 0
		SA1->(dbSeek(xFilial()+_cCli))
		lPriCli := .T.
		While !TMP1->(EOF()) .AND. _cVend == TMP1->C5_VEND1 .AND. _cCli == TMP1->(C5_CLIENTE+C5_LOJACLI)
			_cPed := TMP1->C5_NUM
			SC5->(dbSeek(xFilial()+_cPed))
			_nPrazo := _PrzMed(SC5->C5_CONDPAG)
			lPriPed := .T.
			If geratmp2()
				lEnvia := .T.
				If lPriCli
					cMsg += '  <tr>'
					cMsg += '    <td width="33%" align="left" height="19"><font size="2">'+Substr(SA1->A1_NOME,1,30)+'</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">'+DToC(SC5->C5_EMISSAO)+'</font></td>'
					cMsg += '    <td width="5%" align="center" height="19"><font size="2">'+If(TMP1->C5_LICITAC=="S","L","F")+'</font></td>'
					cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP1->VALVEN,"@E 99,999,999.99")+'</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">'+DToC(TMP2->F2_EMISSAO)+'</font></td>'
					cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP2->VALMERC,"@E 99,999,999.99")+'</font></td>'
					cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP1->VALPEN,"@E 99,999,999.99")+'</font></td>'
					cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_DESCIT,"@E 999.99")+'</font></td>'
					cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(_nPrazo,"@E 999")+'</font></td>'
					cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_COMIS1,"@E 999.99")+'</font></td>'
					cMsg += '  </tr>'
					lPriCli := .F.
					lPriPed := .F.
					_nCliFat += TMP2->VALMERC
					TMP2->(dbSkip())
				EndIf
				If lPriPed
					cMsg += '  <tr>'
					cMsg += '    <td width="33%" align="center" height="19"><font size="2">&nbsp</td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">'+DToC(SC5->C5_EMISSAO)+'</font></td>'
					cMsg += '    <td width="5%" align="center" height="19"><font size="2">'+If(TMP1->C5_LICITAC=="S","L","F")+'</font></td>'
					cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP1->VALVEN,"@E 99,999,999.99")+'</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">'+DToC(TMP2->F2_EMISSAO)+'</font></td>'
					cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP2->VALMERC,"@E 99,999,999.99")+'</font></td>'
					cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP1->VALPEN,"@E 99,999,999.99")+'</font></td>'
					cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_DESCIT,"@E 999.99")+'</font></td>'
					cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(_nPrazo,"@E 999")+'</font></td>'
					cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_COMIS1,"@E 999.99")+'</font></td>'
					cMsg += '  </tr>'
					_nCliFat += TMP2->VALMERC
					TMP2->(dbSkip())
					lPriPed := .F.
				EndIf
				_nCliVen += TMP1->VALVEN
				_nCliPen += TMP1->VALPEN
				While !TMP2->(EOF())
					cMsg += '  <tr>'
					cMsg += '    <td width="33%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '    <td width="5%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '    <td width="9%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">'+DToC(TMP2->F2_EMISSAO)+'</font></td>'
					cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP2->VALMERC,"@E 99,999,999.99")+'</font></td>'
					cMsg += '    <td width="9%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '    <td width="7%" align="center" height="19"><font size="2">&nbsp</font></td>'
					cMsg += '  </tr>'
					_nCliFat += TMP2->VALMERC
					TMP2->(dbskip())
				EndDo
			EndIf
			TMP2->(dbclosearea())
			TMP1->(dbskip())
			IncProc()
		EndDo
		_nRepVen += _nCliVen
		_nRepPen += _nCliPen
		_nRepFat += _nCliFat
		If _nCliVen + _nCliPen + _nCliFat > 0 
			cMsg += '  <tr>
			cMsg += '    <td width="45%" align="left" colspan="3" height="19"><p align="left"><b><font size="2">Total do Cliente ===&gt;&gt;&gt;</font></b></td>
			cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nCliVen,"@E 99,999,999.99")+'</font></b></td>
			cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
			cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nCliFat,"@E 99,999,999.99")+'</font></b></td>
			cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nCliPen,"@E 99,999,999.99")+'</font></b></td>
			cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
			cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
			cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
			cMsg += '  </tr>'
		EndIf
	EndDo
	_nGerVen += _nRepVen
	_nGerPen += _nRepPen
	_nGerFat += _nRepFat
	cMsg += '  <tr>
	cMsg += '    <td width="45%" align="left" colspan="3" height="19"><p align="left"><b><font size="2">Total do Representante ===&gt;&gt;&gt;</font></b></td>
	cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nRepVen,"@E 99,999,999.99")+'</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nRepFat,"@E 99,999,999.99")+'</font></b></td>
	cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nRepPen,"@E 99,999,999.99")+'</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</b></td>
	cMsg += '  </tr>
	cMsg += '</table>'
	If nOpPrc == 1
		_Envia()
		cPara := SA3->A3_EMAIL
	EndIf
EndDo
If nOpPrc <> 1
	cMsg += '<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="101">'
	cMsg += '  <tr>'
	cMsg += '    <td width="45%" align="left" colspan="3" height="19"><p align="left"><b><font size="2">Total Geral ===&gt;&gt;&gt;</font></b></td>
	cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nGerVen,"@E 99,999,999.99")+'</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nGerFat,"@E 99,999,999.99")+'</font></b></td>
	cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nGerPen,"@E 99,999,999.99")+'</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</b></td>
	cMsg += '  </tr>
	cMsg += '</table>'
	_Envia()
EndIf
TMP1->(dbclosearea())
DISCONNECT SMTP SERVER
Close(oDialog)
Return

//***********************************************************************
Static Function ExecArq()
//***********************************************************************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := "C:\WINDOWS\TEMP\VIT143.HTML"

SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)

//³ Faz a chamada do aplicativo associado                                  ³
nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

If nRet <= 32
	cCompl := ""
	If nRet == 31
		cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
	EndIf
	Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
EndIf

Return

//***********************************************************************
Static Function _Envia()
//***********************************************************************
If !lEnvia
	Return
EndIf
cMsg += '</body>'
cMsg += '</html>'
cPara := AllTrim(cPara)
If nOpPrc == 1 .and. Len(AllTrim(cPara)) > 0 .and. Len(AllTrim(cMsg)) > 300
	SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
	If !lResult
		MsgStop("Problemas no envio do e-mail")
	EndIf
ElseIf nOpPrc == 2
	nHdl := fCreate("C:\WINDOWS\TEMP\VIT143.HTML")
	fWrite(nHdl,cMsg,Len(cMsg))
	fClose(nHdl)
	ExecArq()
ElseIf nOpPrc == 3
	SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
	If !lResult
		MsgStop("Problemas no envio do e-mail")
	EndIf
EndIf
cMsg := ""
Return


static function _PrzMed(_cCond)
_aparc := Condicao(1,_cCond,,dDataBase)
_nQtPar := Len(_aParc)
nRet := NoRound((_aParc[_nQtPar,1]-dDataBase)/_nQtPar,0)
return(nRet)

static function _abremail()
cMsg += '<html>'
cMsg += '<head><title>Pedidos X Faturamento</title></head>'
cMsg += '<body>'
cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="118%" id="AutoNumber2">'
cMsg += '  <tr>'
cMsg += '    <td width="19%" rowspan="3">'
cMsg += '    <img border="0" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="121" width="121" height="33"></td>'
cMsg += '    <td width="51%" rowspan="3"><p align="center"><b>Pedidos X Faturamento</b></p></td>'
cMsg += '    <td width="50%"><font size="2"><b>Emissão.: '+DToC(dDataBase)+'</b></font></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="50%"><font size="2"><b>Hora.......: '+Time()+'</b></font></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="50%"><b><font size="1">Período</font></b><font size="1"> '+DToC(MV_PAR01)+' <b>à</b> '+DToC(MV_PAR02)+'</font></td>'
cMsg += '  </tr>'
cMsg += '  </table>'
cMsg += '<p><b><font size="3">&nbsp</font></p>'
return

static function _geratmp(lPar)
procregua(1)
incproc("Selecionando pedidos...")
_cquery:=" SELECT"
_cquery+=" C5_VEND1, A1_NOME, C5_CLIENTE, C5_LOJACLI, C5_LICITAC, C5_NUM,"
_cquery+=" SUM(C6_VALOR) VALVEN, SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) VALPEN"
_cquery+=" FROM "
_cquery+=" "+RetSqlName("SA1")+" SA1,"
_cquery+=" "+RetSqlName("SA3")+" SA3,"
_cquery+=" "+RetSqlName("SC5")+" SC5,"
_cquery+=" "+RetSqlName("SC6")+" SC6,"
_cquery+=" "+RetSqlName("SF4")+" SF4"
_cquery+=" WHERE"
_cquery+="     SA1.D_E_L_E_T_<>'*' AND SA3.D_E_L_E_T_<>'*' AND SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND SC6.D_E_L_E_T_<>'*' AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND A1_FILIAL='"+_cFilSA1+"'"
_cquery+=" AND A3_FILIAL='"+_cFilSA3+"'"
_cquery+=" AND C5_FILIAL='"+_cFilSC5+"'"
_cquery+=" AND C6_FILIAL='"+_cFilSC6+"'"
_cquery+=" AND F4_FILIAL='"+_cFilSF4+"'"
_cquery+=" AND C6_NUM=C5_NUM"
_cquery+=" AND C6_TES=F4_CODIGO"
_cquery+=" AND C5_CLIENTE=A1_COD"
_cquery+=" AND C5_LOJACLI=A1_LOJA"
_cquery+=" AND C5_VEND1=A3_COD"
_cquery+=" AND C5_TIPO='N'"
_cquery+=" AND C6_BLQ<>'R '"
_cquery+=" AND C5_EMISSAO 	BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND C5_VEND1 	BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND C5_CLIENTE 	BETWEEN '"+mv_par05+"' AND '"+mv_par07+"'"
_cquery+=" AND C5_LOJACLI 	BETWEEN '"+mv_par06+"' AND '"+mv_par08+"'"
_cquery+=" AND C5_NUM 		BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
If lPar
	_cquery+=" AND A3_EMAIL <> '"+space(30)+"'"
EndIf
if mv_par11==1
	_cquery+=" AND F4_DUPLIC='S'"
elseif mv_par11==2
	_cquery+=" AND F4_DUPLIC='N'"
endif
if mv_par12==1
	_cquery+=" AND F4_ESTOQUE='S'"
elseif mv_par12==2
	_cquery+=" AND F4_ESTOQUE='N'"
endif
if mv_par13==1
	_cquery+=" AND C5_LICITAC<>'S'"
elseif mv_par13==2
	_cquery+=" AND C5_LICITAC='S'"
endif
_cquery+=" GROUP BY C5_VEND1, A1_NOME, C5_CLIENTE, C5_LOJACLI, C5_LICITAC, C5_NUM"
_cquery+=" ORDER BY C5_VEND1, A1_NOME, C5_LICITAC, C5_NUM"
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","VALVEN" ,"N",14,2)
tcsetfield("TMP1","VALPEN" ,"N",14,2)
tmp1->(dbGoTop())
return


static function geratmp2()
cQry := " select"
cQry += " f2_emissao, sum(d2_total) valmerc"
cQry += " from "
cQry += " "+RetSqlName("SD2")+" sd2,"
cQry += " "+RetSqlName("SF2")+" sf2"
cQry += " where sd2.d_e_l_e_t_ = ' ' and sf2.d_e_l_e_t_ = ' '"
cQry += " and d2_filial = '"+xFilial("SD2")+"'"
cQry += " and f2_filial = '"+xFilial("SF2")+"'"
cQry += " and d2_doc = f2_doc"
cQry += " and d2_serie = f2_serie"
cQry += " and d2_pedido = '"+TMP1->C5_NUM+"'"
cQry += " group by f2_emissao"//, f2_valmerc"
cQry += " order by f2_emissao"
TcQuery cQry  New Alias "TMP2"
TcSetField("TMP2","F2_EMISSAO","D")
TcSetField("TMP2","VALMERC","N",14,2)
TMP2->(dbGoTop())
lRet := !TMP2->(EOF())
Return(lRet)

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do vendedor        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o vendedor     ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Do cliente         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Da loja            ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Ate o cliente      ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Ate a loja         ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do pedido          ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o pedido       ?","mv_chA","C",06,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","TES qto. duplicata ?","mv_chB","N",01,0,0,"C",space(60),"mv_par11"       ,"Gera"           ,space(30),space(15),"Nao gera"       ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","TES qto. estoque   ?","mv_chC","N",01,0,0,"C",space(60),"mv_par12"       ,"Movimenta"      ,space(30),space(15),"Nao movimenta"  ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Tipo Pedido        ?","mv_chC","N",01,0,0,"C",space(60),"mv_par13"       ,"Normal"         ,space(30),space(15),"Licitações"     ,space(30),space(15),"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return