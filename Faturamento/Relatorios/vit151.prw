#include "topconn.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT151   ³ Autor ³ FABRICIO F. SANTOS ³ Data ³  19/09/03   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatorio Curva ABC - Cliente em Html                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function VIT151

Private cPass     := GetMv("MV_RELPSW")
Private cAccount  := GetMv("MV_RELACNT")
Private cServer   := GetMv("MV_RELSERV")
Private cAssunto  := 'Curva ABC - Clientes'
Private cMSG := ""
Private cPara := Space(100)
//Verifica o e-mail do usuario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
	cAccount := AllTrim(aRet[1,14])
EndIf

cPerg:="PERGVIT151"
_Pergsx1()
pergunte(cPerg,.f.)


aOpPrc 	:= {"Vendedor  ","Tela",""}
nOpPrc	:= 1

@ 106,74 To 346,606 Dialog oDialog Title OemToAnsi("Relatorio -- Email")
@ 9,12 To 63,196 Title OemToAnsi(cAssunto) Object Quadro
@ 25,24 Say OemToAnsi("Este programa enviara o relatorio Curva Cliente") Size 150,8
@ 38,25 Say OemToAnsi("por e-mail no formato Html conforme os parametros") Size 150,8
@ 49,26 Say OemToAnsi("especificados.") Size 42,8

@ 67,25 Say OemToAnsi("Enviar Para:") Size 34,8
@ 77,25 Radio aOpPrc Var nOpPrc
@ 94,33 Get cPara Size 115,10

@ 13,207 Button OemToAnsi("_Confirma") Size 36,16 Action Processa({|| _ProcMail()})
@ 30,207 Button OemToAnsi("_Cancela") Size 36,16 Action Close(oDialog)
@ 47,207 Button OemToAnsi("_Parametros") Size 36,16 Action Pergunte(cPerg,.T.)
Activate Dialog oDialog
Return

//**************************
Static Function _ProcMail()
//**************************
Close(oDialog)
lcontinua:=.t.
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
_lEnviaVend := .F.
If nOpPrc == 1
	SA3->(dbSeek(xFilial()+MV_PAR13,.T.))
	While !SA3->(EOF()) .AND. SA3->A3_FILIAL == xFilial("SA3") .AND. SA3->A3_COD <= MV_PAR14
		If !Empty(MV_PAR15)
			If SA3->A3_GEREN <> MV_PAR15
				SA3->(dbSkip())
				Loop
			EndIf
		EndIf
		_lEnviaVend := .F.
		cPara := alltrim(SA3->A3_EMAIL)
		_MontaMail()
		SA3->(dbSkip())
	EndDo
Else
	_MontaMail()
EndIf
Return

Static Function _MontaMail()

_cfilsb1:=xfilial("SB1")
_cfilsa1:=xfilial("SA1")
_cfilsf2:=xfilial("SF2")
_cfilsd2:=xfilial("SD2")
_cfilsf4:=xfilial("SF4")

sb1->(dbsetorder(1))
sa1->(dbsetorder(1))
sf2->(dbsetorder(1))
sd2->(dbsetorder(5))
sf4->(dbsetorder(1))

_aestrut:={}

aadd(_aestrut,{"VEND" 		,"C",06,0})
aadd(_aestrut,{"CLIENTE"  	,"C",08,0})
aadd(_aestrut,{"NOME"  		,"C",30,0})
aadd(_aestrut,{"PRZMED"  	,"N",12,2})
aadd(_aestrut,{"CLPRMED"  	,"N",12,2})
aadd(_aestrut,{"VALOR"  	,"N",12,2})
_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="vend+cliente"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))
if MV_PAR16==1
	_cchave   :="vend+cliente"
elseif MV_PAR16==2
	_cchave   :="vend+nome+cliente"
elseif MV_PAR16==2
	_cchave   :="vend+strzero(przmed,12,2)+cliente"
elseif MV_PAR16==2
	_cchave   :="vend+strzero(valor,12,2)+cliente"
endif
_cindtmp12:=criatrab(,.f.)
tmp1->(indregua("TMP1",_cindtmp12,_cchave))
tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))
tmp1->(dbsetorder(1))

If MV_PAR17 == 1
	_aestrut:={}
	aadd(_aestrut,{"VEND" 		,"C",06,0})
	aadd(_aestrut,{"CLIENTE"  	,"C",08,0})
	aadd(_aestrut,{"APRVEN"  	,"C",01,0})
	aadd(_aestrut,{"PRODUTO"  	,"C",15,0})
	aadd(_aestrut,{"DESCRICAO"	,"C",40,0})
	aadd(_aestrut,{"QUANT"    	,"N",09,0})
	aadd(_aestrut,{"PRCVEN"  	,"N",12,2})
	aadd(_aestrut,{"PRCMED"  	,"N",12,2})
	
	_carqtmp2:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp2,"TMP2",.f.)
	_cindtmp21:=criatrab(,.f.)
	_cchave   :="vend+cliente+produto"
	tmp2->(indregua("TMP2",_cindtmp21,_cchave))
	if MV_PAR16==1
		_cchave   :="vend+cliente+aprven+produto"
	elseif MV_PAR16==2
		_cchave   :="vend+cliente+aprven+descricao+produto"
	elseif MV_PAR16==3
		_cchave   :="vend+cliente+aprven+strzero(quant,09)+descricao+produto"
	elseif MV_PAR16==4
		_cchave   :="vend+cliente+aprven+strzero(prcven,12,2)+descricao+produto"
	endif
	_cindtmp22:=criatrab(,.f.)
	tmp2->(indregua("TMP2",_cindtmp22,_cchave))
	tmp2->(dbclearind())
	tmp2->(dbsetindex(_cindtmp21))
	tmp2->(dbsetindex(_cindtmp22))
	tmp2->(dbsetorder(1))
endif

_ntotvalor:=0
_nqtped := 0
_ntotquant:=0

Processa({|| _CalcMov()})

ProcRegua(tmp1->(lastrec()))
cMsg := ""
cMsg += '<html>'
cMsg += '<body>'
cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
cMsg += '  <tr>'
cMsg += '    <td width="21%" rowspan="2"><p align="center"><font face="Arial"><img border="0" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="121" height="33"></font></td>'
cMsg += '    <td width="59%" rowspan="2"><p align="center"><font face="Arial" size="4"><b>CURVA ABC - CLIENTE - '+IF(MV_PAR17==1,"ANALITICO","SINTETICO")+'</b></font></td>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2"><b>Emissão:</b></font></td>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2">'+dtoc(ddatabase)+'</font></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2"><b>Hora:</b></font></td>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2">'+time()+'</font></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
cMsg += '  <tr>'
cMsg += '    <td width="100%" colspan="3"><font size="2" face="Arial"><b>Período de </b>'+DToC(MV_PAR01)+'<b> à </b>'+DToC(MV_PAR02)+'</font></td>'
cMsg += '  </tr>'
If !empty(mv_par15)
	cMsg += '  <tr>'
	cMsg += '    <td width="100%"><b><font face="Arial" size="2">Gerente Regional.: </b>'+Posicione("SA3",1,xFilial("SA3")+MV_PAR15,"A3_NOME")+'</font></td>'
	cMsg += '  </tr>'
EndIf
cMsg += '</table>'

If MV_PAR17 == 1
	_analitic()
Else
	_sintetic()
EndIf


_cindtmp11+=tmp1->(ordbagext())
_cindtmp12+=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp11)
ferase(_cindtmp12)

If MV_PAR17 == 1
	_cindtmp21+=tmp2->(ordbagext())
	_cindtmp22+=tmp2->(ordbagext())
	tmp2->(dbclosearea())
	ferase(_carqtmp2+getdbextension())
	ferase(_cindtmp21)
	ferase(_cindtmp22)
endif
//cMsg += '</table>'
cMsg += '</body>'
cMsg += '</html>'
cPara := AllTrim(cPara)
If nOpPrc == 1 .and. Len(AllTrim(cPara)) > 0 .and. _lEnviaVend//Len(AllTrim(cMsg)) > 300
	SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
	If !lResult
		MsgStop("Problemas no envio do e-mail")
	EndIf
ElseIf nOpPrc == 2
	nHdl := fCreate("C:\WINDOWS\TEMP\VIT151.HTML")
	fWrite(nHdl,cMsg,Len(cMsg))
	fClose(nHdl)
	ExecArq()
ElseIf nOpPrc == 3
	SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
	If !lResult
		MsgStop("Problemas no envio do e-mail")
	EndIf
EndIf

//***********************
Static Function ExecArq()
//***********************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

cPathFile := "C:\WINDOWS\TEMP\VIT151.HTML"
SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)
nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)
If nRet <= 32
	cCompl := ""
	If nRet == 31
		cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
	EndIf
	Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
EndIf
Return


Return

static function _analitic()
tmp2->(dbsetorder(2))

_nVlVF := 0
_nVlVH := 0

_nVlCF := 0
_nVlCH := 0

_nVlGF := 0
_nVlGH := 0

_nQtVF := 0
_nQtVH := 0

_nQtCF := 0
_nQtCH := 0

_nQtGF := 0
_nQtGH := 0

_cCli 	:= ""
_cVend	:= ""
//cMsg += '<table border="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" cellspacing="0" cellpadding="2" height="76">'
While !TMP1->(EOF())
	incproc()
	If _cVend <> TMP1->VEND
		cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
		cMsg += '  <tr>'
		cMsg += '    <td width="100%"><font size="2" face="Arial"><b>Vendedor.: </b>'+tmp1->vend+' - '+Posicione("SA3",1,xFilial("SA3")+tmp1->vend,"A3_NOME")+'</font></td>'
		cMsg += '  </tr>'
		cMsg += '</table>'
		_cVend := TMP1->VEND
	EndIf
	
	If _cCli <> TMP1->CLIENTE
		cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
		cMsg += '  <tr>'
		cMsg += '    <td width="50%"><font size="2" face="Arial"><b>Cliente: </b>'+subs(tmp1->cliente,1,6)+'/'+subs(tmp1->cliente,7)+' - '+tmp1->nome+'</font></td>'
		cMsg += '    <td width="25%"><font face="Arial" size="2"><b>Prz. Medio: </b>'+Transform(tmp1->przmed,"@E 999")+'</font></td>'
		cMsg += '    <td width="25%"><font face="Arial" size="2"><b>Prc. Medio: </b>'+Transform(tmp1->clprmed,"@E 999,999,999.99")+'</font></td>'
		cMsg += '  </tr>'
		cMsg += '</table>'
		_cVend := TMP1->VEND
	EndIf
	cMsg += '<table border="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" cellspacing="0" cellpadding="2" height="76">'
	cMsg += '  <tr>'
	cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Ordem</font></b></td>'
	cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Código</font></b></td>'
	cMsg += '    <td width="30%" align="center" height="36"><b><font size="1" face="Arial">Descrição</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="36"><b><font size="1" face="Arial">Quantidade</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="36"><b><font size="1" face="Arial">Valor Vendido</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="36"><b><font size="1" face="Arial">Preço Médio</font></b></td>'
	cMsg += '  </tr>'
	tmp2->(dbseek(tmp1->vend+tmp1->cliente))
	_nOrd := 0
	cAPRVEN := tmp2->aprven
	While !tmp2->(eof()) .and. tmp1->(vend+cliente) == tmp2->(vend+cliente)
		_nOrd++
		cMsg += '  <tr>'
		cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(_nOrd,"@E 999999")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+tmp2->produto+'</font></td>'
		cMsg += '    <td width="30%" align="left" height="9"><font size="1" face="Arial">'+tmp2->descricao+'</font></td>'
		cMsg += '    <td width="10%" align="right" height="9"><font size="1" face="Arial">'+Transform(tmp2->quant,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="right" height="9"><font size="1" face="Arial">'+Transform(tmp2->prcven,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="right" height="9"><font size="1" face="Arial">'+Transform(tmp2->prcmed,"@E 999,999.99")+'</font></td>'
		cMsg += '  </tr>'
		
		If tmp2->aprven  == "1"
			_nVlCF += tmp2->prcven
			_nQtCF += tmp2->quant
		Else
			_nVlCH += tmp2->prcven
			_nQtCH += tmp2->quant
		EndIF
		
		tmp2->(dbskip())
		If tmp1->(vend+cliente) == tmp2->(vend+cliente) .and. cAPRVEN <> tmp2->aprven
			cMsg += '</table>
			cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
			cMsg += '  <tr>'
			cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
			cMsg += '    <font size="2" face="Arial">Total linha'+if(cAPRVEN=="1"," Farma:"," Hospitalar:")+' Cliente</font></b></td>'
			cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(if(cAPRVEN=="1",_nQtCF,_nQtCH), "@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(if(cAPRVEN=="1",_nVlCF,_nVlCH), "@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
			cMsg += '  </tr>'
			cMsg += '</table>
			cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
			cAPRVEN := tmp2->aprven
		EndIf
	enddo
	cMsg += '</table>
	cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
	cMsg += '  <tr>'
	cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
	cMsg += '    <font size="2" face="Arial">Total linha'+if(cAPRVEN=="1"," Farma:"," Hospitalar:")+' Cliente</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(if(cAPRVEN=="1",_nQtCF,_nQtCH), "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(if(cAPRVEN=="1",_nVlCF,_nVlCH), "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
	cMsg += '    <font size="2" face="Arial">Total Cliente</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nQtCF+_nQtCH, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nVlCF+_nVlCH, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
	cMsg += '  </tr>'
	
	_nVlVF += _nVlCF
	_nVlVH += _nVlCH
	_nVlCF := 0
	_nVlCH := 0
	_nQtVF += _nQtCF
	_nQtVH += _nQtCH
	_nQtCF := 0
	_nQtCH := 0
	
	tmp1->(dbskip())
	
	If _cVend <> TMP1->VEND
		cMsg += '  <tr>'
		cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
		cMsg += '    <font size="2" face="Arial">Total linha Farma Vendedor</font></b></td>'
		cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nQtVF, "@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nVlVF, "@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
		cMsg += '  </tr>'
		
		cMsg += '  <tr>'
		cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
		cMsg += '    <font size="2" face="Arial">Total linha Hospitalar Vendedor</font></b></td>'
		cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nQtVH, "@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nVlVH, "@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
		cMsg += '  </tr>'
		
		cMsg += '  <tr>'
		cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
		cMsg += '    <font size="2" face="Arial">Total Vendedor</font></b></td>'
		cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nQtVF+_nQtVH, "@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nVlVF+_nVlVH, "@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
		cMsg += '  </tr>'
		_nVlGF += _nVlVF
		_nVlGH += _nVlVH
		_nVlVF := 0
		_nVlVH := 0
		_nQtGF += _nQtVF
		_nQtGH += _nQtVH
		_nQtVF := 0
		_nQtVH := 0
	EndIf
EndDo
If nOpPrc <> 1
	cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
	cMsg += '  <tr>'
	cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
	cMsg += '    <font size="2" face="Arial">Total linha Farma Geral</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nQtGF, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nVlGF, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
	cMsg += '    <font size="2" face="Arial">Total linha Hospitalar Geral</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nQtGH, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nVlGH, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b>'
	cMsg += '    <font size="2" face="Arial">Total Geral</font></b></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nQtGF+_nQtGH, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="right" height="19"><font size="1" face="Arial">'+Transform(_nVlGF+_nVlGH, "@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">&nbsp;</font></td>'
	cMsg += '  </tr>'
	cMsg += '</table>
EndIf
return

//************************
static function _sintetic()
//************************
tmp1->(dbsetorder(2))
_cVend := ""
_nOrd := 0
_ntotvalv := 0
_ntotvalg := 0
while !tmp1->(eof())
	If _cVend <> tmp1->vend
		If _ntotvalv > 0
			cMsg += '  <tr>'
			cMsg += '    <td width="30%" colspan="3" height="19"><p align="left"><b>'
			cMsg += '    <font size="2" face="Arial">Total Vendedor:</font></b></td>'
			cMsg += '    <td width="10%" <u></u><p align="center"><font size="1" face="Arial"> '+Transform(_ntotvalv,"@E 999,999.99")+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="19">&nbsp;</td>'
			cMsg += '    <td width="10%" align="center" height="19">&nbsp;</td>'
			cMsg += '  </tr>'
			cMsg += '</table>'
			_ntotvalg+=_ntotvalv
			_ntotvalv:=0
		endif
		cMsg += '<table border="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" cellspacing="0" cellpadding="2">'// height="76">'
		cMsg += '  <tr>'
		cMsg += '    <td width="100%"><font size="2" face="Arial"><b>Vendedor.: </b>'+TMP1->VEND+' - '+Posicione("SA3",1,xFilial("SA3")+TMP1->VEND,"A3_NOME")+'</font></td>'
		cMsg += '  </tr>'
		cMsg += '</table>'
		cMsg += '<table border="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" cellspacing="0" cellpadding="2" height="76">'
		cMsg += '  <tr>'
		cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Ordem</font></b></td>'
		cMsg += '    <td width="10%" align="center" height="36"><b><font face="Arial" size="1">Cliente</font></b></td>'
		cMsg += '    <td width="50%" align="center" height="36"><b><font face="Arial" size="1">Nome</font></b></td>'
		cMsg += '    <td width="10%" align="center" height="36"><b><font face="Arial" size="1">Valor</font></b></td>'
		cMsg += '    <td width="10%" align="center" height="36"><b><font face="Arial" size="1">Prc. Medio</font></b></td>'
		cMsg += '    <td width="10%" align="center" height="36"><b><font face="Arial" size="1">Prz. Medio</font></b></td>'
		cMsg += '  </tr>'
		_cvend := tmp1->vend
	endif
	_lEnviaVend	:= .T.
	incproc()
	_nOrd++
	cMsg += '  <tr>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(_nOrd,"@E 999999")+'</font></td>'
	cMsg += '    <td width="10%" align="left" height="9"><font face="Arial" size="1">'+subs(tmp1->cliente,1,6)+'/'+subs(tmp1->cliente,7)+'</font></td>'
	cMsg += '    <td width="50%" align="center" height="9"><font face="Arial" size="1">'+tmp1->nome+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(tmp1->valor,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(tmp1->CLPRMED,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(tmp1->przmed,"@E 999,999.99")+'</font></td>'
	cMsg += '  </tr>'
	_ntotvalv += tmp1->valor
	tmp1->(dbskip())
enddo
cMsg += '  <tr>'
cMsg += '    <td width="30%" colspan="3" height="19"><p align="left"><b>'
cMsg += '    <font size="2" face="Arial">Total Vendedor:</font></b></td>'
cMsg += '    <td width="10%" <u></u><p align="center"><font size="1" face="Arial"> '+Transform(_ntotvalv,"@E 999,999.99")+'</font></td>'
cMsg += '    <td width="10%" align="center" height="19">&nbsp;</td>'
cMsg += '    <td width="10%" align="center" height="19">&nbsp;</td>'
cMsg += '  </tr>'
_ntotvalg+=_ntotvalv
If nOpPrc <> 1
	cMsg += '  <tr>'
	cMsg += '    <td width="30%" colspan="3" height="19"><p align="left"><b>'
	cMsg += '    <font size="2" face="Arial">Total :</font></b></td>'
	cMsg += '    <td width="10%" <u></u><p align="center"><font size="1" face="Arial"> '+Transform(_ntotvalg,"@E 999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19">&nbsp;</td>'
	cMsg += '    <td width="10%" align="center" height="19">&nbsp;</td>'
	cMsg += '  </tr>'
	cMsg += '</table>'
EndIF
return

//************************
static function _calcmov()
//************************
procregua(sd2->(lastrec()))

sd2->(dbseek(_cfilsd2+dtos(mv_par01),.t.))
while ! sd2->(eof()) .and.;
	sd2->d2_filial==_cfilsd2 .and.;
	sd2->d2_emissao<=mv_par02
	
	if sd2->d2_cliente+sd2->d2_loja < mv_par09+mv_par10 .or.;
		sd2->d2_cliente+sd2->d2_loja > mv_par11+mv_par12
		sd2->(dbskip())
		loop
	endif
	
	
	sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
	If nOpPrc == 1
		incproc("Vendedor.:"+SA3->A3_COD+" Data.:"+dtoc(sd2->d2_emissao))
	Else
		incproc("Processando pedidos : "+dtoc(sd2->d2_emissao))
	EndIf
	If nOpPrc == 1
		If sf2->f2_vend1 <> SA3->A3_COD
			sd2->(dbskip())
			loop
		EndIf
	Else
		If sf2->f2_vend1 < MV_PAR13 .OR. sf2->f2_vend1 > MV_PAR14
			sd2->(dbskip())
			loop
		EndIf
		If !Empty(MV_PAR15)
			SA3->(dbSeek(xFilial()+SF2->F2_VEND1))
			If SA3->A3_GEREN <> MV_PAR15
				sd2->(dbskip())
				Loop
			EndIf
		EndIf
	EndIf
	
	
	if sd2->d2_cod>=mv_par03 .and.;
		sd2->d2_cod<=mv_par04 .and.;
		sd2->d2_tipo=="N"
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		if sf4->f4_estoque=="S" .and.;
			sf4->f4_duplic=="S"
			sb1->(dbseek(_cfilsb1+sd2->d2_cod))
			if sb1->b1_tipo>=mv_par05 .and.;
				sb1->b1_tipo<=mv_par06 .and.;
				sb1->b1_grupo>=mv_par07 .and.;
				sb1->b1_grupo<=mv_par08
				
				sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
				
				_nprzmedio := 0
				_aparc := Condicao(1,SF2->F2_COND,,SF2->F2_EMISSAO)
				for _I := 1 To Len(_aparc)
					_nprzmedio +=(_aparc[_I,1]-SF2->F2_EMISSAO)
				next
				_nprzmedio := NoRound(_nprzmedio/Len(_aparc),0)
				
				if !tmp1->(dbseek(sf2->f2_vend1+sf2->f2_cliente+sf2->f2_loja+sd2->d2_cod))
					tmp1->(dbappend())
					tmp1->vend  	:=sf2->f2_vend1
					tmp1->cliente 	:=sd2->d2_cliente+sd2->d2_loja
					tmp1->nome		:=sa1->a1_nome
					tmp1->przmed 	:=_nprzmedio
					tmp1->clprmed	:=sd2->d2_prunit
					tmp1->valor		:=sd2->d2_total
				else
					tmp1->przmed :=(tmp1->przmed+_nprzmedio)/2
					tmp1->clprmed	:=(tmp1->clprmed+sd2->d2_prunit)/2
					tmp1->valor		+=sd2->d2_total
				endif
				
				If MV_PAR17 == 1
					if !tmp2->(dbseek(sf2->f2_vend1+sf2->f2_cliente+sf2->f2_loja+sd2->d2_cod))
						tmp2->(dbappend())
						tmp2->vend  	:=sf2->f2_vend1
						tmp2->cliente 	:=sd2->d2_cliente+sd2->d2_loja
						tmp2->aprven   :=sb1->b1_apreven
						tmp2->produto  :=sd2->d2_cod
						tmp2->descricao:=sb1->b1_desc
						tmp2->quant    :=sd2->d2_quant
						tmp2->prcven   :=sd2->d2_total
						tmp2->prcmed   :=sd2->d2_prunit
					else
						tmp2->quant    +=sd2->d2_quant
						tmp2->prcven   +=sd2->d2_total
						tmp2->prcmed   :=(tmp1->clprmed+sd2->d2_prunit)/2
					endif
				endif
				_ntotvalor+=sd2->d2_total
			endif
		endif
	endif
	sd2->(dbskip())
end
return



//************************
Static Function _Pergsx1()
//************************
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Do cliente         ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"10","Da Loja            ?","mv_chA","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Ate o cliente      ?","mv_chB","C",06,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"12","Ate a Loja         ?","mv_chC","C",02,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Do Vendedor        ?","mv_chD","C",06,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"14","Ate o Vendedor     ?","mv_chE","C",06,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"15","Gerente Regional   ?","mv_chF","C",06,0,0,"G",space(60),"mv_par15"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"16","Ordem              ?","mv_chG","N",01,0,0,"C",space(60),"mv_par16"       ,"Codigo"         ,space(30),space(15),"Descrição/Nome"	,space(30),space(15),"Quant./Prz.Med.",space(30),space(15),"Valor"          ,space(30),space(15),space(15)      	,space(30),"   "})
aadd(_agrpsx1,{cperg,"17","Modelo             ?","mv_chH","N",01,0,0,"C",space(60),"mv_par17"       ,"Analitico"      ,space(30),space(15),"Sintetico"     	,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)       	,space(30),"   "})
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
