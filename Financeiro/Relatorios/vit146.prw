#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "ap5mail.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT146   ³ Autor ³ Gardenia Ilany     ³ Data ³  25/08/03   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Programa para Emissao do Relatorio de Titulos a Receber por³±±
±±³          ³ Representante por E-Mail                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function VIT146

SetPrvt("_CARQ,_LCONTINUA,_HDL,")

Private cPass     := GetMv("MV_RELPSW")
Private cAccount  := GetMv("MV_RELACNT")
Private cServer   := GetMv("MV_RELSERV")
Private _cfilsa1 := xFilial("SA1")
Private _cfilsa3 := xFilial("SA3")
Private _cfilse1 := xFilial("SE1")

Private cPara     := Space(100)
Private cMensagem := ""
Private cAssunto  := 'Títulos a Receber'
Private _CRLF := chr(13)+chr(10)
Private cMSG := ""

//Verifica o e-mail do usuario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
//	cAccount := AllTrim(aRet[1,14])
EndIf

//Verifica o e-mail do funcionario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
//	cAccount := AllTrim(aRet[1,14])
EndIf

cperg:="PERGVIT146"
_pergsx1()
pergunte(cperg,.f.)


aOpPrc 	:= {"Vendedor    ","Ger.Regional","Tela",""}
nOpPrc	:= 1

@ 106,74 To 360,606 Dialog oDialog Title OemToAnsi("Relatorio -- Email")
@ 9,12 To 63,196 Title OemToAnsi("Títulos a Receber") Object Quadro
@ 25,25 Say OemToAnsi("Este programa enviara o relatorio Títulos a Receber") Size 150,8
@ 35,25 Say OemToAnsi("por e-mail no formato Html conforme os parametros os") Size 150,8
@ 45,25 Say OemToAnsi("especificados.") Size 42,8

@ 67,25 Say OemToAnsi("Enviar Para:") Size 34,8
@ 77,25 Radio aOpPrc Var nOpPrc
@ 110,33 Get cPara Size 140,10

@ 13,207 Button OemToAnsi("_Confirma") Size 36,16 Action Processa({|| _ProcMail()})
@ 30,207 Button OemToAnsi("C_ancela") Size 36,16 Action Close(oDialog)
@ 47,207 Button OemToAnsi("_Parametros") Size 36,16 Action Pergunte(cPerg,.T.)
Activate Dialog oDialog
sysrefresh()	
Return

Static Function _ProcMail()
If nOpPrc == 4 .AND. Len(alltrim(cPara)) == 0
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
SE1->(dbSetOrder(1))

_geratmp(nOpPrc == 1)

ProcRegua(SE1->(LastRec()))

If (nOpPrc <> 1) .or. (nOpPrc <> 2)
//	_abremail()
EndIf         
_repvaltit:=0
_repvalpag:=0
_reppagtit:=0
_repjuros:= 0
_repareceb:=0

lEnvia := .F.
_nGerVen := 0
_nGerPen := 0
_nGerFat := 0
tmp1->(dbGoTop())

While !TMP1->(EOF())  
	_cGerente :=  tmp1->vend2      
	SA3->(dbSeek(xFilial()+_cGerente))
	_emailger:=sa3->a3_email
	
	_cVend := TMP1->VEND1
	_nRepVen := 0
	_nRepPen := 0
	_nRepFat := 0
	SA3->(dbSeek(xFilial()+_cVend))
	If (nOpPrc == 1) .or. (nOpPrc == 2)
		_abremail()
	EndIf
	_repvaltit:=0
	_repvalpag:=0
	_reppagtit:=0
	_repjuros:= 0
	_repareceb:=0

	cMsg :='<p><b><font size="4">Representante..:</font></b> <font size="4">'+sa3->a3_nome+'</font></p>'
	fwrite(_hdl,cMsg)
	While !TMP1->(EOF()) .AND. _cVend == TMP1->VEND1
		_cCli := TMP1->(cliente+loja)
		_nCliVen := 0
		_nCliPen := 0
		_nCliFat := 0
		SA1->(dbSeek(xFilial()+_cCli))
		lPriCli := .T.
		_clivaltit:=0
		_clivalpag:=0
		_clipagtit:=0
		_clijuros:= 0
		_cliareceb:=0
	
		cMsg :='<p><font face="Arial" size="1">'+tmp1->cliente+" - "+sa1->a1_nome+"         "+sa1->a1_ddd+" "+sa1->a1_tel+'</font></td>
		_conta:=0
		While !TMP1->(EOF()) .AND. _cVend == TMP1->VEND1 .AND. _cCli == TMP1->(CLIENTE+LOJA)
			lenvia:=.T.
			cMsg +='<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" id="AutoNumber3" width="100%" height="19">'
			cMsg += '  <tr>'
			cMsg += '    <td width="5%"  align="left" height="9"><font size="1" face="Arial">'+tmp1->prefixo+'</font></td>'
			cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">'+tmp1->num+'</font></td>'
			cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">'+tmp1->parcela+'</font></td>'
			cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">'+tmp1->tipo+'</font></td>'
			cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">'+dtoc(tmp1->emissao)+'</font></td>'
			cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">'+dtoc(tmp1->vencto)+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(tmp1->valor,"@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">'+tmp1->portado+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(tmp1->valor+tmp1->juros-tmp1->saldo,"@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform((tmp1->valor-tmp1->saldo),"@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(tmp1->juros,"@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="5%"  align="center" height="9"><font face="Arial" size="1">'+dtoc(tmp1->baixa)+'</font></td>'
			cMsg += '    <td width="10%" align="right" height="9"><font face="Arial" size="1">'+transform(tmp1->saldo,"@E 999,999,999.99")+'</font></td>'
			cMsg += '  </tr>'
			cMsg +='</table>'
			_clivaltit+=tmp1->valor
			_clivalpag+=(tmp1->valor+tmp1->juros-tmp1->saldo)
			_clipagtit+=(tmp1->valor-tmp1->saldo)
			_clijuros+=tmp1->juros
			_cliareceb+=tmp1->saldo
			
			_repvaltit+=tmp1->valor
			_repvalpag+=(tmp1->valor+tmp1->juros-tmp1->saldo)
			_reppagtit+=(tmp1->valor-tmp1->saldo)
			_repjuros+=tmp1->juros
			_repareceb+=tmp1->saldo
					
			tmp1->(dbSkip())
			IncProc()
		enddo	
		cMsg +='<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" id="AutoNumber3" width="100%" height="19">'
		cMsg += '  <tr>'
		cMsg += '    <td width="33.5%"  align="left" height="9"><font size="1" face="Arial">Total Cliente =></font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_clivaltit,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">   </font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_clivalpag,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_clipagtit,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_clijuros,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="5%"  align="center" height="9"><font face="Arial" size="1">        </font></td>'
		cMsg += '    <td width="10%" align="right" height="9"><font face="Arial" size="1">'+transform(_cliareceb,"@E 999,999,999.99")+'</font></td>'
		cMsg += '  </tr>'
		cMsg +='</table>'
		fwrite(_hdl,cMsg)
	EndDo

		cMsg :='<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" id="AutoNumber3" width="100%" height="19">'
		cMsg += '  <tr>'
		cMsg += '    <td width="33.5%"  align="left" height="9"><font size="1" face="Arial">Total Representante =></font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_repvaltit,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">   </font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_repvalpag,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_reppagtit,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+transform(_repjuros,"@E 999,999,999.99")+'</font></td>'
		cMsg += '    <td width="5%"  align="center" height="9"><font face="Arial" size="1">        </font></td>'
		cMsg += '    <td width="10%" align="right" height="9"><font face="Arial" size="1">'+transform(_repareceb,"@E 999,999,999.99")+'</font></td>'
		cMsg += '  </tr>'
		cMsg +='</table>'
		fwrite(_hdl,cMsg)

	If nOpPrc == 1
		cpara:="gti@vitamedic.ind.br"
//		cPara := SA3->A3_EMAIL
		_Envia()
	EndIf
	If nOpPrc == 2
		cpara:="gti@vitamedic.ind.br"	
//		cPara := _emailger
		_Envia()
	EndIf
EndDo

If nOpPrc <> 1 .and. nOpPrc <> 2
	_Envia()
EndIf
tmp1->(dbclosearea())
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
cPathFile := "c:\windows\temp\vit146.html"

SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)

//³ Faz a chamada do aplicativo associado  ³
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
	cMsg := '</body>'
	cMsg += '</html>'
	fwrite(_hdl,cMsg)

	fclose(_hdl)

	_cFile :="/temp/vit146.html"

	cPara := AllTrim(cPara)
	If nOpPrc == 1 .and. Len(AllTrim(cPara)) > 0 .and. Len(AllTrim(cMsg)) > 300
		SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY "Titulos Vencidos e a Vencer" Attachment _cFile Result lResult
		If !lResult
			MsgStop("Problemas no envio do e-mail")
		EndIf
	ElseIf nOpPrc == 2 .and. Len(AllTrim(cPara)) > 0 .and. Len(AllTrim(cMsg)) > 300
		SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY "Titulos Vencidos e a Vencer" Attachment _cFile Result lResult
		If !lResult
			MsgStop("Problemas no envio do e-mail")
		EndIf
	ElseIf nOpPrc == 3
		__CopyFile(_cFile, "c:\windows\temp\vit146.html" ) // Copia arquivos do cliente para o Servidor     
		ExecArq()
	ElseIf nOpPrc == 4
		SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY "Titulos Vencidos e a Vencer" Attachment _cFile Result lResult
		If !lResult
			MsgStop("Problemas no envio do e-mail")
		EndIf
	EndIf
	cMsg := ""
Return


static function _abremail()
	
	_carq:="/temp/vit146.html"
	if file(_carq)
		ferase(_carq)
	endif                                    
	_hdl:=fcreate(_carq,0)
 
	if _hdl<0	
		msginfo("Erro na criacao do arquivo "+_carq)
	endif
	cMsg += '<html>'
	cMsg += '<head><title>Titulos vencidos e a vencer</title></head>'
	cMsg += '<body>'
	cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="118%" id="AutoNumber2">'
	cMsg += '  <tr>'
	cMsg += '    <td width="19%" rowspan="3">'
	cMsg += '    <img border="0" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="121" width="121" height="33"></td>'
	cMsg += '    <td width="51%" rowspan="3"><p align="center"><b>Titulos a Receber</b></p></td>'
	cMsg += '    <td width="50%"><font size="2"><b>Emissão.: '+DToC(dDataBase)+'</b></font></td>'
	cMsg += '  </tr>'
	cMsg += '  <tr>'
	cMsg += '    <td width="50%"><font size="2"><b>Hora.......: '+Time()+'</b></font></td>'
	cMsg += '  </tr>'
	cMsg += '  <tr>'
	cMsg += '    <td width="50%"><b><font size="1">Período</font></b><font size="1"> '+DToC(MV_PAR03)+' <b>à</b> '+DToC(MV_PAR04)+'</font></td>'
	cMsg += '  </tr>'
	cMsg += '  </table>'
	cMsg += '<p><b><font size="3">&nbsp</font></p>'

	cMsg +='<table border="0" cellpadding="3" style="border-collapse: collapse" bordercolor="#111111" id="AutoNumber3" width="100%" height="19">
	cMsg += '  <tr>'
	cMsg += '    <td width="5%"  align="left" height="9"><font size="1" face="Arial">Pfx</font></td>'
	cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">titulo</font></td>'
	cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">P</font></td>'
	cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">Tp</font></td>'
	cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">Emissao</font></td>'
	cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">Vencto</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">Vl.Titulo</font></td>'
	cMsg += '    <td width="5%"  align="center" height="9"><font size="1" face="Arial">Bco</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">Vl.Pago</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">Vl.Pago Tit.</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">Juros</font></td>'
	cMsg += '    <td width="5%"  align="center" height="9"><font face="Arial" size="1">Baixa</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">A receber</font></td>'
	cMsg += '  </tr>'
	cMsg +='</table>

	fwrite(_hdl,cMsg)               					
	fwrite(_hdl,chr(13)+chr(10))               					// MUDANCA DE LINHA

return

static function _geratmp(lPar)
//procregua(1)
incproc("Selecionando títulos...")                        
_cquery:=" SELECT"
_cquery+=" E1_PORTADO PORTADO,E1_PREFIXO PREFIXO,E1_NUM NUM,E1_PARCELA PARCELA,E1_TIPO TIPO,"
_cquery+=" E1_EMISSAO EMISSAO,E1_VENCTO VENCTO,E1_BAIXA BAIXA,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_SITUACA SITUACA,"
_cquery+=" E1_VALOR VALOR,E1_DESCONT DESCONT,E1_SALDO SALDO,E1_JUROS JUROS,E1_VEND1 VEND1,E1_VEND2 VEND2,E1_NATUREZ NATUREZ,"
_cquery+=" A1_NOME NOME,A1_DDD DDD,A1_TEL TEL"
_cquery+=" FROM "
_cquery+=" "+RetSqlName("SA1")+" SA1,"
_cquery+=" "+RetSqlName("SA3")+" SA3,"
_cquery+=" "+RetSqlName("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SA1.D_E_L_E_T_<>'*' AND SA3.D_E_L_E_T_<>'*' AND SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND A1_FILIAL='"+_cFilSA1+"'"
_cquery+=" AND A3_FILIAL='"+_cFilSA3+"'"
_cquery+=" AND E1_FILIAL='"+_cFilSE1+"'"
_cQuery+=" AND E1_CLIENTE = A1_COD"
_cQuery+=" AND E1_LOJA = A1_LOJA"
_cQuery+=" AND E1_VEND1 = A3_COD"
_cQuery+=" AND E1_SALDO    <> 0"
_cQuery+=" AND E1_TIPO NOT IN ('RA ','AB-','NCC')"
_cquery+= " AND E1_PORTADO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cQuery+= " AND E1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cQuery+= " AND E1_VENCTO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
_cQuery+= " AND E1_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par09+"'"
_cQuery+= " AND E1_LOJA BETWEEN '"+mv_par08+"' AND '"+mv_par10+"'"
_cQuery+= " AND E1_VEND1 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"                                      
_cQuery+= " AND A3_SUPER BETWEEN '"+mv_par15+"' AND '"+mv_par16+"'"
_cQuery+= " AND E1_NATUREZ BETWEEN '"+mv_par13+"' AND '"+mv_par14+"'"
If lPar
	_cquery+=" AND A3_EMAIL <> '"+space(30)+"'"
EndIf
_cQuery+= " ORDER BY A3_SUPER,E1_VEND1,A1_NOME,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
_cquery:=changequery(_cquery) 
memowrit("/sql/vit146.sql",_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","VALOR" ,"N",14,2)
tcsetfield("TMP1","DESCONT" ,"N",14,2)
tcsetfield("TMP1","SALDO" ,"N",14,2)
tcsetfield("TMP1","JUROS" ,"N",14,2)
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VENCTO","D")
tcsetfield("TMP1","BAIXA" ,"D")

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Banco           ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"02","Ate o Banco        ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"03","Da Emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do Vencimento      ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o Vencimento   ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do Cliente         ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Da Loja            ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Ate o Cliente      ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"10","Ate a Loja         ?","mv_ch10","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Do Representante   ?","mv_ch11","C",06,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"12","Ate o Representante?","mv_ch12","C",06,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"13","Da Natureza        ?","mv_ch13","C",10,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"14","Ate a Natureza     ?","mv_ch14","C",10,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"15","Do Gerente Regional?","mv_ch15","C",06,0,0,"G",space(60),"mv_par15"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"16","Ate o Gerente Reg. ?","mv_ch16","C",06,0,0,"G",space(60),"mv_par16"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
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