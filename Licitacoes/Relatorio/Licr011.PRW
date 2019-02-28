#INCLUDE "rwmake.ch"
#include "ap5mail.ch"
#include "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR011  ³Autor³ Lucia Valeria        ³Data ³  05/08/02    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatorio - Proposta de Licitacao / Simples  		       ³±±
±±³          ³ Enviada pelo Workflow                                      ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Licitacoes                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LICR011()

Local aRadio := {"Tela      ","Representante", "Licitante","E-mail   "}

Private cPass     := GetMv("MV_RELPSW")
Private cAccount  := GetMv("MV_RELACNT")
Private cServer   := GetMv("MV_RELSERV")
Private cAssunto  := ""
Private _cAnexo := " "
PRIVATE _cPerg := "PERGLIC010"
Private cEMail := Space(70)
Private nRadio := 1

/*  Marcio David em 03/07/2018 - Não a necessidade de validar usuario, atualmente valida na conexão da conta (GMAIL).
//Verifica o e-mail do funcionario...
PswOrder(2)
PswSeek(cUserName,.T.)
aRet := PswRet()
If Len(AllTrim(aRet[1,14])) > 0
	cAccount := AllTrim(aRet[1,14])
	alert(cAccount +"teste1")
EndIf
*/

_pergsx1()
Pergunte(_cPerg,.F.)

//³ Montagem da tela de processamento.                                  ³
@ 200,1 TO 410,410 DIALOG oGeraTxt TITLE OemToAnsi("Envio da Proposta por e-mail")
@ 005,07 TO 100,200
@ 10,018 Say " Este programa enviar a propostar por e-mail conforme os parame-"
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de  "
@ 40,018 RADIO aRadio VAR nRadio
@ 62,050 Get cEMail 
@ 80,100 BMPBUTTON TYPE 01 ACTION OkTela()
@ 80,130 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 80,160 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return()

Static Function OkTela()
	RptStatus({|| RunReport()})
Return

Static Function RunReport()

Private _aProd := {}

SZL->(dbSetOrder(3))
SZL->(dbSeek(xFilial("SZL") + mv_par01))

SZP->(dbSetOrder(1))
SZP->(dbSeek(xFilial("SZP") + SZL->ZL_LICITAN))

SB1->(dbSetOrder(1))

	Do Case
	   Case nRadio = 2 // Posiciona E-mail do Representante
	   	cEMail := Posicione ("SA3",1,xFilial("SA3") + SZP->ZP_CODREP,"A3_EMAIL") 
	   	If Empty(cEmail)
				MsgStop("Não existe E-mail cadastrado para o Representante:" + SZP->ZP_CODREP)
				Return
	   	EndIf
	   Case nRadio = 3 // Posiciona E-mail do Licitante
	   	cEMail := Posicione ("SA1",1,xFilial("SA1") + SZP->ZP_CODCLI+SZP->ZP_LJCLI,"A1_EMAIL")
	   	If Empty(cEmail)
				MsgStop("Não existe E-mail cadastrado para o Licitante:" + SZL->ZL_LICITAN)
				Return
	   	EndIf
	   Case nRadio = 4 .and. Len(alltrim(cEmail)) == 0
			MsgStop("Informe o e-mail!!!")
			Return
	EndCase

nTotProp := 0
SZM->(dbSetOrder(2))
SZM->(dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO))

while !SZM->(Eof()) .and. SZL->ZL_NUMPRO==SZM->ZM_NUMPRO

	SB1->(dbSeek(xFilial("SB1")+SZM->ZM_CODPRO))

	// Imprime as descrições de produto e apresentação
	cDescProd := alltrim(SB1->B1_DESCCIE)+" "+alltrim(SB1->B1_APRES)
	cMarca    := alltrim(SB1->B1_MARCA)
	
	If mv_par02 == 1
		Sim_Det()
	Else
		Com_Det()
	EndIf
	SZM->(dbskip())
enddo	

If mv_par02 == 1 
	p_simples()
Else
	p_comp()
EndIf

Close(oGeraTxt)
Return

// Função para Montar array com o detalhe da proposta Simples
Static Function Sim_Det()

//Quantidade e Unidade de Medida solicitada na proposta
cQtde   := Right(TRANSFORM(SZM->ZM_QTDE2, "@E 999,999,999"),11)
cQtdeCx := Right(TRANSFORM(SZM->ZM_QTDE1, "@E 999,999,999.99"),11)

//Preço Unitário
If SZL->ZL_UMPROP = "1"
	cVlUCx   := Right(TRANSFORM(SZM->ZM_PRCUNI,"@E 999,999.99" ),8)
Else
	cCasas := Replicate("9",SZL->ZL_CASASD)
	cMascara := "@E 9,999"+"."+ cCasas
	cVlUCx   := TRANSFORM(SZM->ZM_PRCUN2,cMascara )
EndIf
//preço total
nPrcTotal := SZM->ZM_TOTITEM

aAdd(_aProd,{SZM->ZM_NUMITEM,cDescProd,cMarca,cQtde,cQtdeCx,cVlUCx,nPrcTotal})

Return()

// Função para Montar array com o detalhe da proposta Completa
Static Function Com_Det()

// Imprime as descrições de produto e apresentação
_mnum := SZM->ZM_NUMITEM
if SZL->ZL_PROPOS="00065/03"                                                                            
    Do Case
		Case SZM->ZM_NUMITEM = "001"
  			_mnum := "490"
 		Case SZM->ZM_NUMITEM = "002"
		   _mnum := "12.977"
		Case SZM->ZM_NUMITEM = "003"
		   _mnum := "4.675"
		Case SZM->ZM_NUMITEM = "004"
		   _mnum := "709"
		Case SZM->ZM_NUMITEM = "005"
		   _mnum := "712"
		Case SZM->ZM_NUMITEM = "006"
		   _mnum := "7.518"
		Case SZM->ZM_NUMITEM = "007"
		   _mnum := "719"
		Case SZM->ZM_NUMITEM = "008"
		   _mnum := "666"
	EndCase
elseif !empty(szm->ZM_OBS)
  _mnum := SUBSTR(SZM->ZM_OBS,1,6)
endif  

//  Imprime Num.Registro                           
_cReg   := alltrim(SB1->B1_ANVISA)
_cvalid := ALLTRIM(STR((SB1->B1_PRVALID/365)*12))+" meses"

// Imprime Quantidade e Unidade de Medida solicitada na proposta
if SZL->ZL_UMPROP=="1"
	nQtde := SZM->ZM_QTDE1
	cUM   := SZM->ZM_UM1
else
	nQtde := SZM->ZM_QTDE2
	cUM   := SZM->ZM_UM2
endif

cUm := Alltrim(Posicione("SAH",1,xFilial("SAH")+cUM,"AH_UMRES"))
if cUm == "COMPRIMID"
  cUm := "COMPRIMIDOS"
endif  

_cQtde :=  alltrim(TRANSFORM(nQtde, "@E 999,999,999,999"))
cQtd := Extenso(nQtde)
nPos := Rat("REA",cQtd)
cQtd := lower("(" + Alltrim(SubStr(cQtd,1,nPos-1)) + " " + Alltrim(cUm) + ")")

// Imprime Preço Unitário
cCasas := Replicate("9",SZL->ZL_CASASD)
cMascara := "@E 9,999"+"."+ cCasas

if SZL->ZL_UMPROP =="2"
	cValTxt := TRANSFORM(SZM->ZM_PRCUN2, cMascara)
else                                             
	cValTxt := TRANSFORM(SZM->ZM_PRCUNI, cMascara)
endif	

nPos := Rat(",",cValTxt)
cPartInt := SubStr(cValTxt,1,nPos-1)
nPartInt := Val(cPartInt)

cPartFrac := SubStr(cValTxt,nPos+1,SZL->ZL_CASASD)
if nPartInt <> 0
nCorte := 0              
for i := 1 to Len(cPartFrac)
	if SubStr(cPartFrac,Len(cPartFrac)-i+1,1)=="0"
		nCorte := nCorte + 1
	else
		i := Len(cPartFrac)
	endif
next i
cPartFrac := SubStr(cPartFrac,1,Len(cPartFrac)-nCorte)
endif

nPartFrac := Val(cPartFrac)

if Len(cPartFrac) ==4  .and. nPartInt <=1
	cFinal := "MILIONESIMOS"
elseif Len(cPartFrac) ==3 .and. nPartInt <=1
	cFinal := "MILESIMOS"
elseif Len(cPartFrac) ==2 .and. nPartInt <=1 //SZL->ZL_CASASD==2 // .or.  Len(cPartFrac)==1
	cFinal := "CENTAVOS"
elseif Len(cPartFrac) ==1 .and. nPartInt <=1 //SZL->ZL_CASASD==1
	cFinal := "DECIMOS"
else
   cFinal := ""
endif

If (Len(cPartFrac) <=2 .or.  Len(cPartFrac)==1 ) 
	cValExt  := Alltrim(Extenso(Val(cPartInt + "." + cPartFrac)))
   if SZL->ZL_CASASD==4
     cValExt := strtran(cValExt,"Centavos","Milionesimos",,,) 
   elseif SZL->ZL_CASASD==3
     cValExt := strtran(cValExt,"Centavos","Milesimos",,,)         
   endif 
	if nPartInt==1
		nPos := Rat("REA",cValExt)
		cValExt := SubStr(cValExt,1,nPos-1) + "REAL " + SubStr(cValExt,nPos+6,Len(cValExt))
	EndIf
Else            
	if nPartInt==1
		cExt1 := "Um Real"
	else
		cExt1 := Extenso(nPartInt)
	endif    
   cExt2 := Extenso(nPartFrac)  
	nPos := Rat("REA",cExt2)
	cExt2 := SubStr(cExt2,1,nPos-1) + " " + cFinal
	if nPartInt >=1  
     cExt2 := cExt2  
   endif 
	
	if !Empty(cExt1) .and. !Empty(cExt2)
		cValExt := cExt1 + " e " + cExt2 
	elseIf !Empty(cExt1)	
		cValExt := cExt1
	else
		cValExt := cExt2
	endif
EndIf
If nPartInt == 0
   cValExt += " de real"
EndIf      

_cPrUnit := "R$ " + Right(space(14) + alltrim(cValTxt),14) 
_cPrExt  := lower("(" + cValExt + ")")

// Imprime preço total
if SZL->ZL_UMPROP =="2"
	nPrcTotal :=  Round((SZM->ZM_PRCUN2 * nQtde),2)
else
	nPrcTotal :=  Round((SZM->ZM_PRCUNI * nQtde),2)
endif	

//_cVlTot := Right(space(14) + alltrim(TRANSFORM(nPrcTotal, "@E 999,999,999.99")),14) 
_nVlTot := nPrcTotal
_cVlExt := lower("(" + Extenso(nPrcTotal) + ")")

aAdd(_aProd,{ _mnum,cDescProd,cMarca,_cReg,_cvalid,cUM, _cQtde, cQtd,_cPrUnit,_cPrExt,_nVlTot,_cVlExt})

return()

Static Function p_simples()
	oProcess := "Proposta Simples Licitações"
	cSubject := "Vitamedic Indústria Farmacêutica - Proposta de Licitações"   //Guilherme Teodoro em 06/07/2016 - Correção da razão social.
cMSG := "<html>"
cMSG +="<head>"
cMSG +="<meta http-equiv='Content-Type' content='text/html; charset=windows-1252'>"
cMSG +="<meta name='GENERATOR' content='Microsoft FrontPage 4.0'>"
cMSG +="<meta name='ProgId' content='FrontPage.Editor.Document'>"
cMSG +="<title>Nova pagina 1</title>"
cMSG +="</head>"
cMSG +="<body style='line-height: 150%'>"
cMSG +="<table border='0' width='100%'><tr>"
cMSG +="    <td width='50%' ><font size='2'>Anápolis, "+U_DataExt(dDatabase)+"</font></td>"
cMSG +="    <td width='50%' ><p align='right'><font size='2'>Cotação: "+SZL->ZL_PROPOS+"</font></td>"
cMSG +="  </tr>"
cMSG +="</table>"
cMSG +="  <p><b><font size='2'>"+SZP->ZP_NOMLIC+"</font></b></p>"
cMSG +="  <p><font size='2'>Ref.: "+SZL->ZL_NUMEDI+"</font></p>"
cMSG +="  <p><font size='2'>Conforme solicitação, segue abaixo proposta de preços dos medicamentos da linha Vitamedic.</font></p>"  //Guilherme Teodoro em 06/07/2016 - Correção da razão social.
cMSG +="  <table border='1' width='100%' cellspacing='0'>"
cMSG +="    <tr>"
cMSG +="      <td width='05%'><b><font size='2'>Item</font></b></td>"
cMSG +="      <td width='35%'><b><font size='2'>Produto / Apresentação Vitamedic</font></b></td>"
cMSG +="      <td width='15%'><b><font size='2'>Marca</font></b></td>"
cMSG +="      <td width='13%'><b><font size='2'>Qtde. Unidade</font></b></td>"
cMSG +="      <td width='10%'><b><font size='2'>Qtde. Caixa</font></b></td>"
If SZL->ZL_UMPROP = "1"
	cMSG +="      <td width='10%'><b><font size='2'>Preço Caixa</font></b></td>"
Else
	cMSG +="      <td width='10%'><b><font size='2'>Preço Unidade</font></b></td>"
EndIf	
cMSG +="      <td width='12%'><b><font size='2'>Valor Total</font></b></td>"
cMSG +="    </tr>"

_nTotal := 0 
For i:=1 to len(_aProd)
	cMSG +="    <tr>"
	cMSG +="      <td width='05%'><font size='2'>"+_aProd[i,1]+"</font></td>"
	cMSG +="      <td width='35%'><font size='1'>"+_aProd[i,2]+"</font></td>"
	cMSG +="      <td width='15%'><font size='1'>"+_aProd[i,3]+"</font></td>"
	cMSG +="      <td width='13%' align='right'><font size='2'>"+_aProd[i,4]+"</font></td>"
	cMSG +="      <td width='10%' align='right'><font size='2'>"+_aProd[i,5]+"</font></td>"
	cMSG +="      <td width='10%' align='right'><font size='2'>"+_aProd[i,6]+"</font></td>"
	cMSG +="      <td width='12%' align='right'><font size='2'>"+TRANSFORM(_aProd[i,7], "@E 999,999,999.99")+"</font></td>"
	cMSG +="    </tr>"
	_nTotal += _aProd[i,7]
Next

cMSG +="  </table>"
cMSG +="  <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'>&nbsp;</p>"
cMSG +="  <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'>&nbsp;</p>"
cMSG +="  <table border='1' width='100%' cellspacing='0'>"
cMSG +="    <tr>"
cMSG +="      <td width='17%'><b><font size='2'>Total Proposta</font></b></td>"
cMSG +="      <td width='83%'><p align='right'><b><font size='3'>"+ALLTRIM(TRANSFORM(_nTotal,"@E 999,999,999.99" ))+"</font></b></td>"
cMSG +="    </tr>"
cMSG +="  </table>"
cMSG +="  <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'>&nbsp;</p>"
cMSG +="  <table border='0' width='100%' >"
cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Pagamento:</font></b></td>"
cMSG +="      <td width='75%'><font size='2'>"+Alltrim(Posicione("SE4",1,xFilial("SE4")+SZL->ZL_PRAZO,"E4_DESCRI")) + " dia(s)</font></td>"
cMSG +="      </td>"
cMSG +="    </tr>"
cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Entrega:</font></b></td>"
If SZL->ZL_DIASENT == 1
	cMSG +="      <td width='75%'><font size='2'>Imediata</font></td>"
Else
	cMSG +="      <td width='75%'><font size='2'>"+Alltrim(Str(SZL->ZL_DIASENT)) + " dia(s)</font></td>"
EndIf

cMSG +="      </td>"
cMSG +="    </tr>"

cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Tipo Fornecimento:</font></b></td>"
If SZL->ZL_TIPOFOR == "U"
	cMSG +="      <td width='75%'><font size='2'>Único</font></td>"
Else
	cMSG +="      <td width='75%'><font size='2'>Parcelado em " + Alltrim(Str(SZL->ZL_PERIODO)) + " vezes</font></td>"
EndIf

cMSG +="      </td>"
cMSG +="    </tr>"

cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Frete:</font></b></td>"
cMSG +="      <td width='75%'><font size='2'>CIF</font></td>"
cMSG +="    </tr>"
cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Validade da Proposta:</font></b></td>"
cExt := lower(Extenso(SZL->ZL_DIASVAL,.t.))
cMSG +="      <td width='75%'><font size='2'>"+alltrim(str(SZL->ZL_DIASVAL)) + " (" +cExt +") dia(s) - (Pedidos não confirmados neste prazo estarão sujeitos a nova cotação)</font></td>"
cMSG +="      </td>"
cMSG +="    </tr>"
cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Pedido Minimo:</font></b></td>"

cExt := lower(GetNewPar("MV_LVLMIN","1200"))
cMSG +="      <td width='75%'><font size='2'>R$ "+ALLTRIM(TRANSFORM( Val(cExt),"@E 999,999,999.99" ))+"</font></td>"
cMSG +="      </td>"
cMSG +="    </tr>"
/*cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Garantia de Preço:</font></b></td>"
// Alteração solicitada em 01/2011 pelo Comercial.
//cMSG +="      <td width='75%'><font size='2'>Preços sujeitos a realinhamento sempre que houver reajustes autorizados pelo Governo Federal.</font></td>"
cMSG +="      <td width='75%'><font size='2'>Garantia Máxima de preço - 06 meses.</font></td>"
*/cMSG +="    </tr>"
cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Observação:</font></b></td>"
cMSG +="      <td width='75%'><font size='2'>Preços cotados para fornecimento das quantidades totais dos itens</font></td>"
IF !EMPTY(SZL->ZL_OBS1)   
	cMSG +="    </td>"
	cMSG +="    </tr>"
	cMSG +="    <tr>"
	cMSG +="    <td width='25%'><b><font size='2'></font></b></td>"
	cMSG +="    <td width='75%'><font size='2'>"+Alltrim(substr(SZL->ZL_obs1,1,200)) + "</font></td>"
/*   cMSG +="    </td>"
	cMSG +="    </tr>"
	cMSG +="    <tr>"	
	cMSG +="    <td width='25%'><b><font size='2'></font></b></td>"	
	cMSG +="    <td width='75%'><font size='2'>"+Alltrim(substr(SZL->ZL_obs1,56,55)) + "</font></td>"
	cMSG +="    </td>"
	cMSG +="    </tr>"
	cMSG +="    <tr>"		
	cMSG +="    <td width='25%'><b><font size='2'></font></b></td>"	
	cMSG +="    <td width='75%'><font size='2'>"+Alltrim(substr(SZL->ZL_obs1,111,55)) + "</font></td>"
	cMSG +="    </td>"
	cMSG +="    </tr>"
	cMSG +="    <tr>"		
	cMSG +="      <td width='75%'><font size='2'>"+Alltrim(substr(SZL->ZL_obs1,166,55)) + "</font></td>"*/
EndIf	
cMSG +="      </td>"
cMSG +="    </tr>"
cMSG +="    <tr>"
cMSG +="      </td>"
cMSG +="      <td width='25%'><b><font size='2'></font></b></td>"
cMSG +="      <td width='75%'><font size='2'><b><i>Favor mencionar no seu pedido de compra o número desta cotação.</i></b></font></td>"
cMSG +="      </td>"
cMSG +="    </tr>"
cMSG +="  </table>"
cMSG +="  <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'>&nbsp;</p>"
cMSG +="  <table border='0' width='100%' >"
cMSG +="    <tr>"
cMSG +="      <td width='100%' >"
cMSG +="        <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'><font size='2'><b>Atenciosamente,</b></font></p>"
cMSG +="        <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'>&nbsp;</p>"
cMSG +="        <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'><b><font size='2'>Departamento Comercial.</b></font></p>"
cMSG +="        <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'><font size='2'><a href='mailto:licitacoes@vitamedic.ind.br'>licitacoes@vitamedic.ind.br</a></font></td>" // Marcio David em 03/07/2018 alterado email licitacoes@vitamedic.ind.br para licitacoes@vitamedic.ind.br 
cMSG +="    </tr>"
cMSG +="  </table>"
cMSG +="</body> "
cMSG +="</html>"
EnviEmail()
Return()

Static Function p_comp()
	oProcess := "Proposta Composta Licitação"
	cSubject := "Vitamedic Indústria Farmacêutica - Proposta de Licitações" //Guilherme Teodoro em 06/07/2016 - Correção da razão social.

cMSG := "<html>"
cMSG += "<head>"
cMSG += "<meta http-equiv='Content-Language' content='pt-br'>"
cMSG += "<meta http-equiv='Content-Type' content='text/html; charset=windows-1252'>"
cMSG += "<meta name='GENERATOR' content='Microsoft FrontPage 4.0'>"
cMSG += "<meta name='ProgId' content='FrontPage.Editor.Document'>"
cMSG += "<title>Anápolis</title>"
cMSG += "</head>"
cMSG += "<body style='line-height: 100%; margin-top: 6; margin-bottom: 6'>"
cMSG += "<table border='0' width='100%' cellspacing='0' cellpadding='0'>"
cMSG += "  <tr>"
cMSG += "    <td width='50%'><font size='2'>Anápolis, " +  U_DataExt(dDatabase)+ "&nbsp;&nbsp;&nbsp;</font></td>"
cMSG += "    <td width='50%'>"
cMSG += "      <p align='right'><font size='2'>Cotação: " + SZL->ZL_PROPOS + "</font></td>"
cMSG += "  </tr>"
cMSG += "</table>"
cMSG += "<p style='line-height: 100%; margin-top: 6; margin-bottom: 6'>&nbsp;</p>"
cMSG += "<table border='0' width='100%'>"
cMSG += "  <tr><td width='100%'><b> <font size='2'>"+SZP->ZP_NOMLIC+"</font></b></td></tr>"
cMSG += "  <tr><td width='100%'><font size='2'>"+Alltrim(mv_par03)+"</font></td></tr>"
cMSG += "  <tr><td width='100%'><font size='2'>"+Alltrim(mv_par04)+"</font></td></tr>"
cMSG += "</table>"
cMSG += "<p style='line-height: 100%; margin-top: 6; margin-bottom: 6'>&nbsp;</p>"
cMSG += "<table border='0' width='100%'>"
cMSG += "  <tr>"
cMSG += "    <td width='100%' colspan='4'> <b><font size='2'>PROPOSTA DE PREÇOS</font></b></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='16%'><font size='2'><b>Proponente :&nbsp;&nbsp; </b> </font></td>"
cMSG += "    <td width='84%' colspan='3'><font size='2'>"+GetNewPar("MV_LICRAZ","Vitamedic Ind.Farmaceutica Ltda")+"</font></td>" // Proponente //Guilherme Teodoro em 06/07/2016 - Correção da razão social.
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='16%'><font size='2'><b>Endereço:</b></font></td>"
cMSG += "    <td width='84%' colspan='3'><font size='2'>"+Alltrim(SM0->M0_ENDENT) + ", "+Alltrim(SM0->M0_COMPENT) + " - " + Alltrim(SM0->M0_BAIRENT) + ", " + Alltrim(SM0->M0_CIDENT) + "-" + Alltrim(SM0->M0_ESTENT)+"</font></td>" // Endereço
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='16%'><font size='2'><b>CNPJ :&nbsp;</b> </font></td>"
_nCGC := Val(GetNewPar("MV_LICCGC",SM0->M0_CGC))
cMSG += "    <td width='34%'><font size='2'>"+TRANSFORM(_nCGC, "@E 99,999,999/9999-99")+"</font></td>"
cMSG += "    <td width='15%'><font size='2'>&nbsp;<b>I.E.: </b>"
cMSG += " </font></td>"
cMSG += "    <td width='35%'><font size='2'>"+"      10.197.801-4"+"</font></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='16%'><font size='2'><b>Edital :&nbsp; </b>"
cMSG += " </font></td>"
cMSG += "    <td width='84%' colspan='3'><font size='2'>"+RetModal(SZL->ZL_MODAL)+" n° "+SZL->ZL_NUMEDI+"</font></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='16%'><font size='2'>"
cMSG += "<b>Data&nbsp; :&nbsp; </b>"
cMSG += " </font></td>"
cMSG += "    <td width='84%' colspan='3'><font size='2'>"+dtoc(SZL->ZL_DTABER)+"</font></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='16%'><font size='2'>"
cMSG += "<b>Hora :&nbsp;&nbsp;&nbsp; </b>"
cMSG += " </font></td>"
cMSG += "    <td width='84%' colspan='3'><font size='2'>"+Transform(SZL->ZL_HRABER,"@R 99:99")+"</font></td>"

//oPrn:Say( 550, 350, mv_par02,oFontT12)
//oPrn:Say( 600, 350, mv_par03,oFontT12)
cMSG += "  </tr>"
cMSG += "</table>"
cMSG +="  <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'>&nbsp;</p>"
cMSG += "<table border='0' width='100%'>"
cMSG += "  <tr>"
cMSG += "    <td width='100%'><b><font size='2'>Oferecemos a seguir os produtos de nossa fabricação e procedência nacional:</font></b></td>"
cMSG += "  </tr>"
cMSG += "</table>"

_nTotal := 0 
For i:=1 to len(_aProd)
	cMSG +="  <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'>&nbsp;</p>"
	cMSG += "<table border='0' width='100%'>"
	cMSG += "  <tr>"
	cMSG += "    <td width='100%'><b><font size='2'>Item: "+_aProd[i,1]+"</font></b></td>"
	cMSG += "  </tr>"
	cMSG += "</table>"
	cMSG += "<table border='1' width='100%' cellspacing='0'>"
	cMSG += "  <tr>"
	cMSG += "    <td width='19%'><font size='2'><b>Produto:</b></font></td>"
	cMSG += "    <td width='81%' colspan='3'><font size='1'>"+_aProd[i,2]+";</font></td>"
	cMSG += "  </tr>"
	cMSG += "  <tr>  "
	cMSG += "    <td width='19%'><font size='2'><b>Marca:</b></font></td>"
	cMSG += "    <td width='81%' colspan='3'><font size='1'>"+_aProd[i,3]+"</font></td>"
	cMSG += "  </tr>"
	cMSG += "  <tr>"
	cMSG += "    <td width='19%'><b><font size='2'>Nº Reg.MS:</font></b></td>"
	cMSG += "    <td width='18%'><font size='2'>"+_aProd[i,4]+"&nbsp;&nbsp;</font></td>"
	cMSG += "    <td width='63%'><font size='2'><b>Validade Produto:</b> "+_aProd[i,5]+"</font></td>"
	cMSG += "    </td>"
	cMSG += "  </tr>"
	cMSG += "  <tr> "
	cMSG += "    <td width='19%'><b><font size='2'>Unidade:&nbsp;</font></b></td>"
	cMSG += "    <td width='81%' colspan='3'><font size='1'>"+_aProd[i,6]+"</font></td>"
	cMSG += "  </tr>"
	cMSG += "  <tr>"
	cMSG += "    <td width='19%'><b><font size='2'><b><font size='2'>Quantidade:</font></b></td>"
	cMSG += " 	 <td width='81%' colspan='3' height='12'>"
	cMSG += "    <table border='0' cellspacing='1' width='100%' id='AutoNumber1'>"
	cMSG += "      <tr>"
	cMSG += "        <td width='22%'><p align='right'><font size='2'>"+_aProd[i,7]+"</font></td>"
	cMSG += "        <td width='78%'><font size='2'>"+_aProd[i,8]+"</font></td>"
	cMSG += "      </tr>"
	cMSG += "    </table>"
	cMSG += "  </tr>"
	cMSG += "  <tr>"
	cMSG += "    <td width='19%'><b><font size='2'>Preço Unitário:</font></b></td>"
	cMSG += " 	 <td width='81%' colspan='3' height='12'>"
	cMSG += "    <table border='0' cellspacing='1' width='100%' id='AutoNumber2'>"
	cMSG += "      <tr>"
	cMSG += "        <td width='22%'><p align='right'><font size='2'>"+_aProd[i,9]+"</font></td>"
	cMSG += "        <td width='78%'><font size='2'>"+_aProd[i,10]+"</font></td>"
	cMSG += "      </tr>"
	cMSG += "    </table>"
	cMSG += "  </tr>"
	cMSG += "  <tr>  "
	cMSG += "    <td width='19%' ><b><font size='2'>Valor Total:</font></b></td>"
	cMSG += " 	 <td width='81%' colspan='3' height='12'>"
	cMSG += "    <table border='0' cellspacing='1' width='100%' id='AutoNumber3'>"
	cMSG += "      <tr>"
	cMSG += "        <td width='22%'><p align='right'><font size='2'>R$ "+alltrim(TRANSFORM(_aProd[i,11], "@E 999,999,999.99"))+"</font></td>"
	cMSG += "        <td width='78%'><font size='2'>"+_aProd[i,12]+"</font></td>"
	cMSG += "      </tr>"
	cMSG += "    </table>"
	cMSG += "    </td>"
	cMSG += "  </tr>"
	cMSG += "</table>"
	_nTotal += _aProd[i,11]
 Next                                                 

cMSG += "<p style='line-height: 100%; margin-top: 6; margin-bottom: 6'>&nbsp;</p>"
cMSG += "<table border='1' width='100%' cellspacing='0'>"
cMSG += "  <tr>"
cMSG += "    <td width='19%'><b><font size='2'>Total da Proposta:</font></b></td>"
cMSG += " 	 <td width='81%' colspan='3' height='12'>"
cMSG += "    <table border='0' cellspacing='1' width='100%' id='AutoNumber2'>"
cMSG += "      <tr>"
cMSG += "        <td width='22%'><p align='right'><font size='2'><b>R$ "+ALLTRIM(TRANSFORM(_nTotal,"@E 999,999,999.99" ))+"</b></font></b></td>"
cMSG += "        <td width='78%'><font size='2'><b>("+lower(Extenso(_nTotal))+")</b></font></td>"
cMSG += "      </tr>"
cMSG += "    </table>"
cMSG += "  </tr>"
cMSG += "</table>"

cExt := lower(Extenso(SZL->ZL_DIASVAL,.t.))
cMSG += "<p style='line-height: 100%; margin-top: 6; margin-bottom: 6'>&nbsp;</p>"
cMSG += "<table border='0' width='100%'>"
cMSG += "  <tr>"
cMSG += "    <td width='20%'><font size='2'><b>Validade da Proposta:</b></font></td>"
//cMSG += "    <td width='80%'><font size='2'>"+alltrim(str(SZL->ZL_DIASVAL)) + " (" + cExt + ") dia(s)</font></td>"
cMSG +="      <td width='80%'><font size='2'>"+alltrim(str(SZL->ZL_DIASVAL)) + " (" +cExt +") dia(s) - (Pedidos não confirmados neste prazo estarão sujeitos a nova cotação)</font></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='20%'><font size='2'><b>Frete:</b> </font> </td>"
cMSG += "    <td width='80%'><font size='2'>CIF</font></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"                            
cMSG += "    <td width='20%'><font size='2'><b>Impostos:</b> </font> </td>"
cMSG += "    <td width='80%'><font size='2'>Inclusos</font></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='20%'><font size='2'><b>Entregas:</b> </font> </td>"
cMSG += "    <td width='80%'><font size='2'>"+alltrim(str(SZL->ZL_DIASENT))+" dia(s)</font></td>"
cMSG += "  </tr>"

cMSG +="    <tr>"
cMSG +="      <td width='20%'><b><font size='2'>Tipo Fornecimento:</font></b></td>"
If SZL->ZL_TIPOFOR == "U"
	cMSG +="      <td width='80%'><font size='2'>Único</font></td>"
Else
	cMSG +="      <td width='80%'><font size='2'>Parcelado em " + Alltrim(Str(SZL->ZL_PERIODO)) + " vezes</font></td>"
EndIf
cMSG +="    </tr>"
cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Pedido Minimo:</font></b></td>"

cExt := lower(GetNewPar("MV_LVLMIN","1200"))
cMSG +="      <td width='75%'><font size='2'>R$ "+ALLTRIM(TRANSFORM( Val(cExt),"@E 999,999,999.99" ))+"</font></td>"
cMSG +="      </td>"
cMSG +="    </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='20%'><font size='2'><b>Processo: </b> </font> </td>"
cMSG += "    <td width='80%'><font size='2'>"+AllTrim(SZL->ZL_PROCESS)+"</font></td>"
cMSG += "  </tr>"
cMSG += "  <tr>"
cMSG += "    <td width='20%'><font size='2'><b>Dados Bancários: </b> </font> </td>"
cMSG += "    <td width='80%'><font size='2'>"+"Banco do Brasil - Agência: 3388-X c/c: 6040-2"+"</font></td>"
cMSG += "  </tr>"
/*cMSG +="    <tr>"
cMSG +="      <td width='25%'><b><font size='2'>Garantia de Preço:</font></b></td>"
// Alteração solicitada em 01/2011 pelo Comercial.
//cMSG +="      <td width='75%'><font size='2'>Preços sujeitos a realinhamento sempre que houver reajustes autorizados pelo Governo Federal.</font></td>"
cMSG +="      <td width='75%'><font size='2'>Garantia Máxima de preço - 06 meses.</font></td>"
cMSG += "  </tr>"*/
cMSG += "<p style='line-height: 100%; margin-top: 6; margin-bottom: 6'> <font size='2'>&nbsp;&nbsp;</font> </p>"
cMSG += "<table border='0' width='100%'>"
cMSG += "</table>"
cMSG += "  <tr>"
IF !EMPTY(SZL->ZL_OBS1)   
	cMSG += "    <td width='20%'><font size='2'><b>Observação: </b> </font> </td>"
	cMSG += "    <td width='90%'>"+AllTrim(SUBSTR(SZL->ZL_OBS1,01,55))+"</td>"
	cMSG += "  </tr>"
	cMSG += "    <td width='90%'>"+AllTrim(SUBSTR(SZL->ZL_OBS1,56,055))+"</td>"
	cMSG += "  </tr>"
	cMSG += "    <td width='90%'>"+AllTrim(SUBSTR(SZL->ZL_OBS1,111,055))+"</td>"
	cMSG += "  </tr>"
	cMSG += "    <td width='90%'>"+AllTrim(SUBSTR(SZL->ZL_OBS1,166,055))+"</td>"
EndIf	
cMSG += "  </tr>"
cMSG += "</table>"
cMSG += "<p style='line-height: 100%; margin-top: 6; margin-bottom: 6'>&nbsp;</p>"
cMSG += "<table border='0' width='100%'>"
cMSG += "  <tr>"
cMSG += "    <td width='100%'><font size='2'>Declaramos que concordamos com as"
cMSG += "normas do presente edital, bem como as Leis Federais&nbsp;nº 8.66/93"
cMSG += "e nº 8.883/94&nbsp;&nbsp; e&nbsp; Lei Estadual nº 6.544/89 bem como as"
cMSG += "demais; leis, decretos, portarias e resoluções cujas normas regem a presente Licitação.</font></td>"
cMSG += "  </tr>"
cMSG += "</table>"
cMSG += "<p style='line-height: 100%; margin-top: 6; margin-bottom: 6'>&nbsp;</p>"
cMSG += "<table border='0' width='100%'>"
cMSG += "  <tr>"
cMSG += "    <td width='100%'>"
cMSG +="        <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'><font size='2'>"+Alltrim(mv_par05)+"</font></p>"
cMSG +="        <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'><font size='2'>"+Alltrim(mv_par06)+"</font></p>"
cMSG +="        <p style='line-height: 100%; word-spacing: 0; margin-top: 0; margin-bottom: 0'><font size='2'>"+Alltrim(mv_par07)+"</font></p>"
cMSG += "      </u></font></p>"
cMSG += "    </td>"
cMSG += "  </tr>"
cMSG += "</table>"
cMSG += "</body>"
cMSG += "</html>"

EnviEmail()
Return()

Static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{_cperg,"01","Proposta           ?","mv_ch1","C",08,0,1,"G",space(60),"mv_par01"       ,space(15),space(30),space(15),space(15) ,space(30),space(15),space(15)       ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SZL"})
aadd(_agrpsx1,{_cperg,"02","Simples/Completa   ?","mv_ch2","N",01,0,1,"C",space(60),"mv_par02"       ,"Simples",space(30),space(15),"Completa",space(30),space(15),space(1)        ,space(30),space(15),space(01)        ,space(30),space(15),space(15)        ,space(30),""})
aadd(_agrpsx1,{_cperg,"03","Referencia 1       ?","mv_ch3","C",30,0,1,"G",space(30),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Referencia 2       ?","mv_ch4","C",30,0,1,"G",space(30),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Assinatura         ?","mv_ch5","C",30,0,1,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"06","Cargo              ?","mv_ch6","C",30,0,1,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"07","CPF e/ou RG        ?","mv_ch7","C",30,0,1,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return


Static Function RetModal(cCod)

Local cRet := " " 

SX5->(DBSeek(xFilial("SX5") + "74" + cCod))
cRet := Alltrim(SX5->X5_DESCRI)

return(cRet)

Static Function EnviEmail() 

	nHdl := fCreate("\LICR011.HTML")
	fWrite(nHdl,cMSG,Len(cMSG))
	fClose(nHdl)
	
If nRadio == 1
	nHdl := fCreate("C:\WINDOWS\TEMP\LICR011.HTML")
	fWrite(nHdl,cMSG,Len(cMSG))
	fClose(nHdl)
	ExecArq()
Else
	cAssunto  := "Proposta licitacao nº " + mv_par01 + " - Vitamedic" //Guilherme Teodoro em 06/07/2016 - Correção da razão social.
	cServer  := alltrim(cServer)
	cAccount := alltrim(cAccount)
	cPass    := alltrim(cPass)
	cEMail   := alltrim(cEMail)
	cAnexo  := "\LICR011.HTML" 
	cCorpo  := "Segue em anexo a proposta de licitação de número: " + mv_par01 + "."

   CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass Result lResult
   MailAuth(cAccount, cPass) // Marcio David em 03/07/2018 acrescentado para conexão com o Gmail.
      
   	If !lResult
		MsgStop("Problemas na conexao com o servidor de e-mail!!!")
		Return
	EndIf
	
	SEND MAIL FROM cAccount TO cEMail SUBJECT cAssunto BODY cCorpo ATTACHMENT cAnexo Result lResult
	
	If !lResult
		MsgStop("Problemas no envio da Proposta de Licitação "+SZL->ZL_LICITAN)
	EndIf
	
	Msginfo("O e-mail foi enviado com sucesso!!", "Enviado")
	
	DISCONNECT SMTP SERVER

EndIf

Return

Static Function ExecArq()
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := "C:\WINDOWS\TEMP\LICR011.HTML"

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

Return(.t.)
