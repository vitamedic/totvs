/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT147   ³ Autor ³ Fabricio F. Santos    ³ Data ³ 26/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Html de Curva ABC - Pedidos                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "ap5mail.ch"

User Function VIT147()

Private cPass     := GetMv("MV_RELPSW")
Private cAccount  := GetMv("MV_RELACNT")
Private cServer   := GetMv("MV_RELSERV")
Private cAssunto  := 'Curva ABC - Pedidos'
Private cMSG := ""
Private cPara := Space(100)
//Verifica o e-mail do usuario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
	cAccount := AllTrim(aRet[1,14])
EndIf

cPerg:="PERGVIT147"
_Pergsx1()
pergunte(cPerg,.f.)


aOpPrc 	:= {"Vendedor  ","Tela",""}
nOpPrc	:= 1

@ 106,74 To 346,606 Dialog oDialog Title OemToAnsi("Relatorio -- Email")
@ 9,12 To 63,196 Title OemToAnsi(cAssunto) Object Quadro
@ 25,24 Say OemToAnsi("Este programa enviara o relatorio Curva ABC-Pedidos") Size 150,8
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
	SA3->(dbSeek(xFilial()+MV_PAR12,.T.))
	While !SA3->(EOF()) .AND. SA3->A3_FILIAL == xFilial("SA3") .AND. SA3->A3_COD <= MV_PAR13
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
_cfilsc6:=xfilial("SC6")
_cfilsf4:=xfilial("SF4")
_cfilsc5:=xfilial("SC5")
_cfilsa1:=xfilial("SA1")

sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(3))
sf4->(dbsetorder(1))
sa1->(dbsetorder(1))

_aestrut:={}
aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
aadd(_aestrut,{"DESCRICAO","C",40,0})
aadd(_aestrut,{"QUANT"    ,"N",09,0})
aadd(_aestrut,{"VALOR"    ,"N",12,2})
aadd(_aestrut,{"APRVEN"    ,"C",1,0})
aadd(_aestrut,{"CLIENTE"    ,"C",40,0})
aadd(_aestrut,{"UF"         ,"C",02,0})
aadd(_aestrut,{"QTENT"    ,"N",09,0})
aadd(_aestrut,{"VLLISTA"  ,"N",12,2})
aadd(_aestrut,{"QTPED"    ,"N",09,0})


_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="produto"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))
if MV_PAR14==1
	_cindtmp12:=criatrab(,.f.)
	_cchave   :="aprven+produto"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))
elseif MV_PAR14==2
	_cindtmp12:=criatrab(,.f.)
	_cchave   :="aprven+descricao+produto"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))
elseif MV_PAR14==3
	_cindtmp12:=criatrab(,.f.)
	_cchave   :="aprven+strzero(quant,09)+descricao+produto"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))
elseif MV_PAR14==4
	_cindtmp12:=criatrab(,.f.)
	_cchave   :="aprven+strzero(valor,12,2)+descricao+produto"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))
endif
tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))
tmp1->(dbsetorder(1))
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
cMsg += '    <td width="59%" rowspan="2"><p align="center"><font face="Arial" size="4"><b>CURVA ABC - PEDIDOS</b></font></td>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2"><b>Emissão:</b></font></td>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2">'+DToC(dDataBase)+'</font></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2"><b>Hora:</b></font></td>'
cMsg += '    <td width="11%" align="right"><font face="Arial" size="2">'+Time()+'</font></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
cMsg += '  <tr>'
cMsg += '    <td width="100%">&nbsp;</td>'
cMsg += '  </tr>'
If nOpPrc == 1
	cMsg += '  <tr>'
	cMsg += '    <td width="100%"><font size="2" face="Arial"><b>Vendedor.: </b>'+SA3->A3_COD+' - '+SA3->A3_NOME+'</font></td>'
	cMsg += '  </tr>'
EndIf
If !empty(mv_par09)
	cMsg += '  <tr>'
	cMsg += '    <td width="100%"><b><font face="Arial" size="2">Cliente.: </b>'+tmp1->cliente+'</font></td>'
	cMsg += '  </tr>'
EndIf
If !empty(mv_par11)
	cMsg += '  <tr>'
	cMsg += '    <td width="100%"><font size="2" face="Arial"><b>Estado.: </b>'+MV_PAR11+'</font></td>'
	cMsg += '  </tr>'
EndIf
cMsg += '</table>'
cMsg += '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">'
cMsg += '  <tr>'
cMsg += '    <td width="100%"><font size="2" face="Arial"><b>Período de </b>'+DToC(MV_PAR01)+'<b> à </b>'+DToC(MV_PAR02)+'</font></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<table border="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" cellspacing="0" cellpadding="2" height="76">'
cMsg += '  <tr>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Ordem</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Código</font></b></td>'
cMsg += '    <td width="30%" align="center" height="36"><b><font size="1" face="Arial">Descrição</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Qtd. Pedido</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Qtd. Ent.</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Valor</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">Preço Médio</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">%</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">% Acum.</font></b></td>'
cMsg += '    <td width="10%" align="center" height="36"><b><font size="1" face="Arial">% Desc. Médio</font></b></td>'
cMsg += '  </tr>'

tmp1->(dbsetorder(2))

_i     :=1
_npacum:=0
_caprven :=" "
_ntotlin := 0
_ntotvlin :=0
_ntotquant:=0
_nvalor := 0
_ntentlin := 0
_ntotent := 0
_ndscmed := 0
_j :=1
if MV_PAR14>2
	tmp1->(dbgobottom())
else
	tmp1->(dbgotop())
endif
while if(MV_PAR14>2,! tmp1->(bof()),! tmp1->(eof())) .and. lcontinua
	incproc()
	_nprmed:=round(tmp1->valor/tmp1->quant,2)
	_ndscmed:=round(((tmp1->vllista/tmp1->qtped))*100,2)
	_nperc :=round((tmp1->valor/_ntotvalor)*100,2)
	_npacum+=_nperc
	if _caprven<>tmp1->aprven
		if _ntotquant>0
			cMsg += '  <tr>'
			cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b><font size="2">'+"Total linha"+if(_caprven="1"," Farma:"," Hospitalar:")+'</font></b></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_ntotquant,"@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_ntotent,"@E 999,999,999.99")+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_nvalor,"@E 999,999,999,.99")+'</font></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font size="1">&nbsp;</font></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
			cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
			cMsg += '  </tr>'
			_ntentlin += _ntotent
			_ntotlin +=_ntotquant
			_ntotvlin += _nvalor
			_ntotent:=0
			_ntotquant:=0
			_nvalor := 0
			_i:=0
		endif
		_caprven:=tmp1->aprven
	endif
	_lEnviaVend := .T.
	cMsg += '  <tr>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(_i,"@E 999999")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+left(tmp1->produto,6)+'</font></td>'
	cMsg += '    <td width="30%" align="left" height="9"><font size="1" face="Arial">'+tmp1->descricao+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(tmp1->quant,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(tmp1->qtent,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font size="1" face="Arial">'+Transform(tmp1->valor,"@E 999,999,999,.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+Transform(_nprmed,"@E 999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+Transform(_nperc,"@E 999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+Transform(_npacum,"@E 999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="9"><font face="Arial" size="1">'+Transform(0,"@E 999.99")+'</font></td>'
	cMsg += '  </tr>'
	_ntotquant+=tmp1->quant
	_ntotent += tmp1->qtent
	_nvalor +=tmp1->valor
	_i++
	_j++
	if MV_PAR14>2
		tmp1->(dbskip(-1))
	else
		tmp1->(dbskip())
	endif
end
if _ntotquant>0
	cMsg += '  <tr>'
	cMsg += '    <td width="50%" colspan="3" height="19"><p align="left"><b><font size="2">'+"Total linha"+if(_caprven="1"," Farma:"," Hospitalar:")+'</font></b></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_ntotquant,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_ntotent,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_nvalor,"@E 999,999,999,.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1">&nbsp;</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
	cMsg += '  </tr>'
	_ntentlin += _ntotent
	_ntotlin +=_ntotquant
	_ntotvlin+=_nvalor
	_ntotent:=0
	_ntotquant:=0
	_nvalor := 0
endif

if lcontinua
	cMsg += '  <tr>'
	cMsg += '    <td width="30%" colspan="3" height="19"><p align="left"><b><font size="2">Total</font></b></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_ntotlin,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_ntentlin,"@E 999,999,999.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1" face="Arial">'+Transform(_ntotvlin,"@E 999,999,999,.99")+'</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font size="1">&nbsp;</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
	cMsg += '    <td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>'
	cMsg += '  </tr>'
endif

_cindtmp11+=tmp1->(ordbagext())
if mv_par14>1
	_cindtmp12+=tmp1->(ordbagext())
endif
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp11)
if mv_par14>1
	ferase(_cindtmp12)
endif
cMsg += '</table>'
cMsg += '</body>'
cMsg += '</html>'
cPara := AllTrim(cPara)
If nOpPrc == 1 .and. Len(AllTrim(cPara)) > 0 .and. _lEnviaVend//Len(AllTrim(cMsg)) > 300
	SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
	If !lResult
		MsgStop("Problemas no envio do e-mail")
	EndIf
ElseIf nOpPrc == 2
	nHdl := fCreate("C:\WINDOWS\TEMP\VIT147.HTML")
	fWrite(nHdl,cMsg,Len(cMsg))
	fClose(nHdl)
	ExecArq()
ElseIf nOpPrc == 3
	SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY cMsg Result lResult
	If !lResult
		MsgStop("Problemas no envio do e-mail")
	EndIf
EndIf

Return

//************************
static function _calcmov()
//************************
ProcRegua(SC6->(LastRec()))
SC6->(dbSeek(_cfilsc6+dtos(mv_par01),.t.))
While ! sc6->(eof()) .and.;
	sc6->c6_filial==_cfilsc6 .and.;
	sc6->c6_entreg<=mv_par02
	sc5->(dbseek(_cfilsc5+sc6->c6_num,.t.))
	If nOpPrc == 1
		incproc("Vendedor.:"+SA3->A3_COD+" Data.:"+dtoc(sc6->c6_entreg))
	Else
		incproc("Processando pedidos : "+dtoc(sc6->c6_entreg))
	EndIf
	If nOpPrc == 1
		If SC5->C5_VEND1 <> SA3->A3_COD
			sc6->(dbskip())
			loop
		EndIf
	Else
		If SC5->C5_VEND1 < MV_PAR12 .OR. SC5->C5_VEND1 > MV_PAR13
			sc6->(dbskip())
			loop
		EndIf
	EndIf
	if sc6->c6_produto>=mv_par03 .and.;
		sc6->c6_produto<=mv_par04 .and.;
		sc5->c5_tipo=="N"
		sf4->(dbseek(_cfilsf4+sc6->c6_tes))
		if sf4->f4_estoque=="S" .and.;
			sf4->f4_duplic=="S"
			sb1->(dbseek(_cfilsb1+sc6->c6_produto))
			if sb1->b1_tipo>=mv_par05 .and.;
				sb1->b1_tipo<=mv_par06 .and.;
				sb1->b1_grupo>=mv_par07 .and.;
				sb1->b1_grupo<=mv_par08
				if !empty(mv_par09)
					sc5->(dbseek(_cfilsc5+sc6->c6_num))
					sa1->(dbseek(_cfilsa1+sc5->c5_cliente+sc5->c5_lojacli))
					if sc5->c5_cliente== mv_par09	.and. sc5->c5_lojacli == mv_par10
						if ! tmp1->(dbseek(sc6->c6_produto))
							tmp1->(dbappend())
							tmp1->produto  :=sc6->c6_produto
							tmp1->descricao:=sb1->b1_desc
							tmp1->quant    :=sc6->c6_qtdven
							tmp1->valor    :=sc6->c6_valor
							tmp1->aprven   :=sb1->b1_apreven
							tmp1->cliente  :=substr(sa1->a1_nome,1,40)
							tmp1->qtent    :=sc6->c6_qtdent
							tmp1->vllista  :=sc6->c6_prunit
							tmp1->qtped    :=1
						else
							tmp1->quant    +=sc6->c6_qtdven
							tmp1->valor    +=sc6->c6_valor
							tmp1->qtent    +=sc6->c6_qtdent
							if !empty(sc6->c6_descont)
								tmp1->vllista  +=sc6->c6_prunit
								tmp1->qtped    +=1
							endif
						endif
					endif
				elseif !empty(mv_par11)
					sa1->(dbseek(_cfilsa1+sc5->c5_cliente+sc5->c5_lojacli))
					if sa1->a1_est== alltrim(mv_par11)
						if ! tmp1->(dbseek(sc6->c6_produto))
							tmp1->(dbappend())
							tmp1->produto  :=sc6->c6_produto
							tmp1->descricao:=sb1->b1_desc
							tmp1->quant    :=sc6->c6_qtdven
							tmp1->qtent    :=sc6->c6_qtdent
							tmp1->valor    :=sc6->c6_valor
							tmp1->aprven   :=sb1->b1_apreven
							tmp1->uf       :=sa1->a1_est
							tmp1->vllista  :=sc6->c6_prunit
							tmp1->qtped    :=1
						else
							tmp1->quant    +=sc6->c6_qtdven
							tmp1->qtent    +=sc6->c6_qtdent
							tmp1->valor    +=sc6->c6_valor
							if !empty(sc6->c6_descont)
								tmp1->vllista  +=sc6->c6_prunit
								tmp1->qtped    +=1
							endif
						endif
					endif
				else
					if ! tmp1->(dbseek(sc6->c6_produto))
						tmp1->(dbappend())
						tmp1->produto  :=sc6->c6_produto
						tmp1->descricao:=sb1->b1_desc
						tmp1->quant    :=sc6->c6_qtdven
						tmp1->valor    :=sc6->c6_valor
						tmp1->aprven   :=sb1->b1_apreven
						tmp1->qtent    :=sc6->c6_qtdent
						tmp1->vllista  :=sc6->c6_prunit
						tmp1->qtped    :=1
					else
						tmp1->quant    +=sc6->c6_qtdven
						tmp1->valor    +=sc6->c6_valor
						tmp1->qtent    +=sc6->c6_qtdent
						if !empty(sc6->c6_descont)
							tmp1->vllista  +=sc6->c6_prunit
							tmp1->qtped    +=1
						endif
					endif
				endif
				_ntotvalor+=sc6->c6_valor
			endif
		endif
	endif
	sc6->(dbskip())
end
return

//***********************
Static Function ExecArq()
//***********************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := "C:\WINDOWS\TEMP\VIT147.HTML"

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
aadd(_agrpsx1,{cperg,"10","Loja               ?","mv_chA","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Do estado          ?","mv_chB","C",02,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"12","Do Vendedor        ?","mv_chC","C",06,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"13","Ate o Vendedor     ?","mv_chD","C",06,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"14","Ordem              ?","mv_chE","N",01,0,0,"C",space(60),"mv_par14"       ,"Codigo"         ,space(30),space(15),"Descrição"     	,space(30),space(15),"Quantidade"     ,space(30),space(15),"Valor"        ,space(30),space(15),space(15)        	,space(30),"   "})
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



/*
<html>
<body>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
<tr>
<td width="21%" rowspan="2"><p align="center"><font face="Arial"><img border="0" src="http://www.vitapan.com.br/images/logo.jpg" width="121" height="33"></font></td>
<td width="59%" rowspan="2"><p align="center"><font face="Arial" size="4"><b>CURVA ABC - PEDIDOS</b></font></td>
<td width="11%" align="right"><font face="Arial" size="2"><b>Emissão:</b></font></td>
<td width="11%" align="right"><font face="Arial" size="2">99/99/99</font></td>
</tr>
<tr>
<td width="11%" align="right"><font face="Arial" size="2"><b>Hora:</b></font></td>
<td width="11%" align="right"><font face="Arial" size="2">99:99:99</font></td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
<tr>
<td width="100%">&nbsp;</td>
</tr>
<tr>
<td width="100%"><font size="2" face="Arial"><b>Vendedor.: </b>XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</font></td>
</tr>
<tr>
<td width="100%"><b><font face="Arial" size="2">Cliente</font></b><font size="2" face="Arial"><b>.: </b>&nbsp;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</font></td>
</tr>
<tr>
<td width="100%"><font size="2" face="Arial"><b>Estado.: </b>XX</font></td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
<tr>
<td width="100%"><font size="2" face="Arial"><b>Período de </b>99/99/99<b> à </b>99/99/99</font></td>
</tr>
</table>
<table border="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" cellspacing="0" cellpadding="2" height="76">
<tr>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">Ordem</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">Código</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">Descrição</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">Qtd. Pedido</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">Qtd. Ent.</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">Valor</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">Preço Médio</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">%</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">% Acum.</font></b></td>
<td width="10%" align="center" height="36"><b><font size="1" face="Arial">% Desc. Médio</font></b></td>
</tr>
<tr>
<td width="10%" align="center" height="9"><font size="1" face="Arial">999999</font></td>
<td width="10%" align="center" height="9"><font size="1" face="Arial">999999</font></td>
<td width="10%" align="center" height="9"><font size="1" face="Arial">XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</font></td>
<td width="10%" align="center" height="9"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="9"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="9"><font size="1" face="Arial">999,999,999,.99</font></td>
<td width="10%" align="center" height="9"><font face="Arial" size="1">999,999.99</font></td>
<td width="10%" align="center" height="9"><font face="Arial" size="1">999.99</font></td>
<td width="10%" align="center" height="9"><font face="Arial" size="1">999.99</font></td>
<td width="10%" align="center" height="9"><font face="Arial" size="1">999.99</font></td>
</tr>
<tr>
<td width="30%" colspan="3" height="19"><p align="left"><b><font size="2">Total linha Farma :</font></b></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999,.99</font></td>
<td width="10%" align="center" height="19"><font size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
</tr>
<tr>
<td width="30%" colspan="3" height="19"><p align="left"><b><font size="2">Total linha Hospitalar :</font></b></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999,.99</font></td>
<td width="10%" align="center" height="19"><font size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
</tr>
<tr>
<td width="30%" colspan="3" height="19"><p align="left"><b><font size="2">Total :</font></b></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999.99</font></td>
<td width="10%" align="center" height="19"><font size="1" face="Arial">999,999,999,.99</font></td>
<td width="10%" align="center" height="19"><font size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
<td width="10%" align="center" height="19"><font face="Arial" size="1">&nbsp;</font></td>
</tr>
</table>

</body>

</html>
*/
