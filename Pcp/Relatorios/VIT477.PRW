#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "ap5mail.ch"   
#include 'tbiconn.ch'   //includes para uso do Prepare Environment
#include 'tbicode.ch'

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT477   ³ Autor ³ Luiz Fernando S    ³ Data ³  23/03/17   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Programa para Emissao do Relatorio de produtos vencidos    ³±±
±±³          ³ ou a vencer												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//Funçao criada para execuçao do workflow direto do smartclient para poder agendar execl
User Function VIT477JB
prepare environment empresa "01" filial "01" tables "SB1","SB8","SBM","DA1","SA1","SA3","SB1","SC5","SC6","SD2","SE1","SE4","SF2","SF4","SFM","SX5"
conout(dtoc(date())+" "+time()+" vit477 - Iniciando geracao do Relatorio de produtos vencidos e a vencer ate 45 dias")
U_VIT477(3)// tipo do relatorio 3 = envia EMAIL 2 = mostra na tela usuario
conout(dtoc(date())+" "+time()+" vit477 - Relatorio de produtos vencidos foi Enviado por email")
reset environment  
RETURN

User Function VIT477(_cTpRel)
Private cPass     := GetMv("MV_RELPSW")
Private cAccount  := GetMv("MV_RELACNT")
Private cServer   := GetMv("MV_RELSERV")
Private _cfilsb1 := xFilial("SB1")
Private _cfilsb8 := xFilial("SB8")
Private _cfilsb2 := xFilial("SB2")

Private cPara     := Space(100)
Private cMensagem := ""
Private cAssunto  := 'Produtos Vencidos e a Vencer em 45 dias'
Private _CRLF := chr(13)+chr(10)
Private cMSG := ""

aOpPrc := _cTpRel

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

if _cTpRel == 3 // envia autmaticamente por email
mv_par01 = '0' //do prod
mv_par02 = 'zz'//ate
mv_par03 = '0'//do tipo
mv_par04 = 'zz'//ate
mv_par05 = '0'//do grupo
mv_par06 = 'zz'//ate
mv_par07 = '01'//do armazem
mv_par08 = '03'//ate

else 
cperg:="PERGVIT477"
_pergsx1()
pergunte(cperg,.t.)
endif
/*
aOpPrc 	:= {"1    ","2   ",""}
nOpPrc	:= 1

@ 106,74 To 346,660 Dialog oDialog Title OemToAnsi("Relatorio -- Email")
@ 9,12 To 63,196 Title OemToAnsi("Produtos Vencidos ou A Vencer 45 dias") Object Quadro
@ 25,24 Say OemToAnsi("Este programa enviara o relatorio Produtos Vencidos ou A Vencer 45 dias") Size 150,8
@ 38,25 Say OemToAnsi("por e-mail no formato Html conforme os parametros os") Size 150,8
@ 49,26 Say OemToAnsi("especificados.") Size 42,8

@ 67,25 Say OemToAnsi("Enviar Para:") Size 34,8
@ 77,25 Radio aOpPrc Var nOpPrc
@ 94,33 Get cPara Size 115,10

@ 13,207 Button OemToAnsi("_Confirma") Size 36,16 Action Processa({|| _ProcMail()})
@ 30,207 Button OemToAnsi("_Cancela") Size 36,16 Action Close(oDialog)
@ 47,207 Button OemToAnsi("_Parametros") Size 36,16 Action Pergunte(cPerg,.T.)
Activate Dialog oDialog
  /*/
nOpPrc	:= iif(_cTpRel==3,3,2) //so manda no email se for 3 caso contrario mostra na tela
 cPara  := ";vit477@vitamedic.ind.br;"   
 _ProcMail()   
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

cMsg := ""
SB1->(dbSetOrder(1))
SB8->(dbSetOrder(1))
SBM->(dbSetOrder(1))

_geratmp()

ProcRegua(TMP1->(LastRec()))

If nOpPrc <> 1
	_abremail()
EndIf
lEnvia := .F.
_cProd   := TMP1->PRODUTO
_cGProd  := TMP1->GRUPO
_nGerVen := 0
_nGerPen := 0
_nGerFat := 0
_cNegr   := ""
_cDiasV  := ""
_nCusto  := 0

If nOpPrc == 1
	_abremail()
EndIf

cMsg += '<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="101">'
cMsg += '  <tr>'
cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">GRUPO/PRODUTO</font></b></td>'
cMsg += '    <td width="36%" align="center" height="19"><b><font size="2">DESCRICAO</font></b></td>'
cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">SALDO</font></b></td>'
cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">CUSTO TOTAL</font></b></td>'
cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">UM</font></b></td>'
cMsg += '    <td width="14%" align="right" height="19"><b><font size="2">LOTE</font></b></td>'
cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">ARMAZEM</font></b></td>'
cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">VENCIMENTO</font></b></td>'
cMsg += '    <td width="7%" align="center" height="19"><b><font size="2">DIAS P/VENC</font></b></td>'
//cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">EMPENHO</font></b></td>'
cMsg += '  </tr>'
While !TMP1->(EOF()) //.AND. _cGProd == TMP1->GRUPO
	_nCliVen := 0
	_nCliPen := 0
	_nCliFat := 0
	lPriGru  := .T.
	_cGrupo  := Posicione("SBM",1,xFilial("SBM")+TMP1->GRUPO,"BM_DESC")
	_cGP     :=	TMP1->GRUPO	
	While !TMP1->(EOF()) .AND. _cGP == TMP1->GRUPO// .AND. _cProd == TMP1->PRODUTO
		lPriProd := .T.
		lEnvia := .T.
		if dDataBase > STOD(TMP1->DTVALID)
			_cDiasV := 'color="red"><b>VENCIDO'
		else
			_cNegr := ""
			_cDiasV := '>' + cValtoChar(DateDiffDay(STOD(TMP1->DTVALID),dDataBase))
		endif 
		
		if TMP1->TIPO $ "PA,PN,PD"
			_nCusto := TMP1->CMF*TMP1->SALDO
		else
			_nCusto := TMP1->CM1*TMP1->SALDO
		endif
		
		If lPriGru
			cMsg += '  <tr>'     // separa por uma tr o grupo do produto
			cMsg += '    <td width="7%" align="left" height="19"><b><font size="2">&nbsp;</font></td>'
			cMsg += '    <td width="36%" align="center" height="19"><b><font size="2">&nbsp;</font></td>'
			cMsg += '  </tr>'
			cMsg += '  <tr>'
			cMsg += '    <td width="7%" align="left" height="19"><b><font size="2">'+Substr(SBM->BM_GRUPO,1,30)+'</font></td>'
			cMsg += '    <td width="36%" align="center" height="19"><b><font size="2">'+ Alltrim(SBM->BM_DESC)+'</font></td>'
			//cMsg += '    <td width="5%" align="center" height="19"><font size="2">'+If(TMP1->C5_LICITAC=="S","L","F")+'</font></td>'
			//cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP1->VALVEN,"@E 99,999,999.99")+'</font></td>'
			//cMsg += '    <td width="7%" align="center" height="19"><font size="2">'+DToC(TMP2->F2_EMISSAO)+'</font></td>'
			//cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP2->VALMERC,"@E 99,999,999.99")+'</font></td>'
			//cMsg += '    <td width="9%" align="right" height="19"><font size="2">'+Transform(TMP1->VALPEN,"@E 99,999,999.99")+'</font></td>'
			//cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_DESCIT,"@E 999.99")+'</font></td>'
			//cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(_nPrazo,"@E 999")+'</font></td>'
			//cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_COMIS1,"@E 999.99")+'</font></td>'
			cMsg += '  </tr>'
			lPriGru := .F.
		Else
			cMsg += '  <tr>'
			//cMsg += '    <td width="33%" align="center" height="19"><font size="2">&nbsp</td>'
			cMsg += '    <td width="7%" align="center" height="19">'+_cNegr+'<font size="2">'+Substr(TMP1->PRODUTO,1,30)+'</font></td>'
			cMsg += '    <td width="36%" align="center" height="19">'+_cNegr+'<font size="2">'+Substr(TMP1->DESCRI,1,30)+'</font></td>'
			cMsg += '    <td width="9%" align="right" height="19">'+_cNegr+'<font size="2">'+Transform(TMP1->SALDO,"@E 99,999,999.99")+'</font></td>'
			cMsg += '    <td width="9%" align="right" height="19">'+_cNegr+'<font size="2">'+Transform(_nCusto,"@E 99,999,999.99")+'</font></td>'
			cMsg += '    <td width="9%" align="right" height="19">'+_cNegr+'<font size="2">'+Alltrim(TMP1->UM)+'</font></td>'
			//cMsg += '    <td width="7%" align="center" height="19"><font size="2">'+DToC(TMP2->F2_EMISSAO)+'</font></td>'
			cMsg += '    <td width="14%" align="right" height="19">'+_cNegr+'<font size="2">'+Alltrim(TMP1->LOTECTL)+'</font></td>'
			cMsg += '    <td width="7%" align="right" height="19">'+_cNegr+'<font size="2">'+Alltrim(TMP1->LOCPAD)+'</font></td>'
			cMsg += '    <td width="7%" align="center" height="19">'+_cNegr+'<font size="2">'+DTOC(STOD(TMP1->DTVALID))+'</font></td>'
			cMsg += '    <td width="7%" align="center" height="19">'+_cNegr+'<font size="2"'+Alltrim(_cDiasV)+'</font></td>'
			//cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_DESCIT,"@E 999.99")+'</font></td>'
			//	cMsg += '    <td width="7%" align="right" height="19">'+_cNegr+'<font size="2">'+Transform(TMP1->EMPENHO,"@E 99,999,999.99")+'</font></td>'
			 //	cMsg += '    <td width="7%" align="right" height="19"><font size="2">'+Transform(SC5->C5_COMIS1,"@E 999.99")+'</font></td>'
			cMsg += '  </tr>'
			TMP1->(dbskip())
		EndIf
	EndDo
EndDo
cMsg += '</table>'
If nOpPrc == 1
	_Envia()
EndIf
If nOpPrc <> 1
	cMsg += '<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="101">'
	cMsg += '  <tr>'
	cMsg += '    <td width="45%" align="left" colspan="3" height="19"><p align="left"><b><font size="2"> Esse Relatorio e Emitido Automaticamente pelo sistema Protheus - TOTVS | Foi desenvolvido para Atender especificamente a VITAMEDIC (VIT477)</font></b></td>
	//cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nGerVen,"@E 99,999,999.99")+'</font></b></td>
	//cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	//cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nGerFat,"@E 99,999,999.99")+'</font></b></td>
	//cMsg += '    <td width="9%" align="right" height="19"><b><font size="2">'+Transform(_nGerPen,"@E 99,999,999.99")+'</font></b></td>
	//cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	//cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</font></b></td>
	//cMsg += '    <td width="7%" align="right" height="19"><b><font size="2">&nbsp;</b></td>
	cMsg += '  </tr>
	cMsg += '</table>'
	_Envia()
EndIf
TMP1->(dbclosearea())
DISCONNECT SMTP SERVER
//Close(oDialog)
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
cPathFile := "C:\WINDOWS\TEMP\VIT477.HTML"

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
	nHdl := fCreate("C:\WINDOWS\TEMP\VIT477.HTML")
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
cMsg += '<head><title>Produtos Vencidos ou a Vencer em 45 dias</title></head>'
cMsg += '<body>'
cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="118%" id="AutoNumber2">'
cMsg += '  <tr>'
cMsg += '    <td width="19%" rowspan="3">'
cMsg += '    <img border="0" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="121" width="121" height="33"></td>'
cMsg += '    <td width="51%" rowspan="3"><p align="center"><b>Produtos Vencidos ou a vencer</b></p></td>'
cMsg += '    <td width="50%"><font size="2"><b>Emissão.: '+DToC(dDataBase)+'</b></font></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="50%"><font size="2"><b>Hora.......: '+Time()+'</b></font></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="50%"><b><font size="1">Vencimento</font></b><font size="1"> '+DToC(dDataBase)+' <b>à</b> '+DToC(DaySum(dDataBase,45))+'</font></td>'
cMsg += '  </tr>'
cMsg += '  </table>'
cMsg += '<p><b><font size="3">&nbsp</font></p>'
return       

static function _geratmp()   
procregua(1)
incproc("Selecionando Produtos...")
_cquery:=" SELECT"
_cquery+=" B8_PRODUTO PRODUTO,B1_DESC DESCRI,B1_GRUPO GRUPO,B8_DTVALID DTVALID,"
_cquery+=" B1_UM UM,B1_TIPO TIPO,B8_SALDO SALDO,B8_EMPENHO EMPENHO,B8_LOTECTL LOTECTL,B2_COD,B2_LOCAL,B2_CM1 CM1,B2_CMFIM1 CMF,B8_LOCAL LOCPAD"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SB2")+" SB2,"
_cquery+=  retsqlname("SB8")+" SB8"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SB8.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B2_FILIAL='"+_cfilsb2+"'"
_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
_cquery+=" AND B8_PRODUTO=B1_COD"
_cquery+=" AND B8_PRODUTO=B2_COD" 
_cquery+=" AND B8_LOCAL=B2_LOCAL" 
_cquery+=" AND B8_SALDO > 0 "
_cquery+=" AND B8_PRODUTO BETWEEN '"+mv_par01+"' and '"+mv_par02+"' "//+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B8_DTVALID <= '"+dtos(DaySum(dDataBase,45))+"'" //BETWEEN '"+dtos(dDataBase)+"' and '"+dtos(DaySum(dDataBase,45))+"'"
if aOpPrc == 3 // envia autmaticamente por email
_cquery+=" AND B1_TIPO IN('MP','EE','EN','PA','PN','PD','ES','IS')"//TIPO PRODUTO
_cquery+=" AND B8_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"//Emerson 11/04/2017 apenas armazens que e usados
else
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "//+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B8_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"//Emerson 11/04/2017 apenas armazens que e usados
endif
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY B1_GRUPO,B8_PRODUTO,B1_DESC,B8_LOCAL,B8_DTVALID,B8_LOTECTL"
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
//tcsetfield("TMP1","VALVEN" ,"N",14,2)
//tcsetfield("TMP1","VALPEN" ,"N",14,2)
tmp1->(dbGoTop())
return


static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazems           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"09","De Validade        ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"10","Ate Validade       ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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