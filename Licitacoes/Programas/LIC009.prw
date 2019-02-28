#include "rwmake.ch"
#include "colors.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIC009    ºAutor  ³Marcelo Myra Martinsº Data ³  25/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verifica pendências no modulo de licitacoes para o usuario
±±º          ³  logado                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de Licitacoes                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function LIC009()

LOCAL lAchou := .f.

SetPrvt("cHist, aHist, oHist")

aHist := {}
cHist := ""

aHist := CarregaArray()

if !Empty(aHist) .and. MsgYesNo("Existem tarefas pendentes para você. "+CHR(13)+"Deseja visualizá-las agora?")

DEFINE MSDIALOG oDlgPend FROM  23,181 TO 410,723 TITLE "Controle de Pendências" PIXEL

	@ 05,05 TO 025,250 TITLE "Proprietário:"

	@ 012,015 SAY SRA->RA_NOME SIZE  150,7 COLOR CLR_BLUE

	@ 030,10 SAY "Pendências:"

	@ 3,1 LISTBOX oHist VAR cHist Fields HEADER "Tipo Pendência","Descrição" SIZE 250,120 ON DBLCLICK (aHist := U_LICBxPend(oHist:nAt,aHist),oHist:Refresh())

	oHist:SetArray(aHist)
	if !Empty(aHist)
		oHist:bLine := { || {aHist[oHist:nAt,1],aHist[oHist:nAt,2]}}
	endif

	DEFINE SBUTTON FROM 175,200 TYPE 2  ACTION Close(oDlgPend) ENABLE OF oDlgPend
	DEFINE SBUTTON FROM 175,230 TYPE 1  ACTION Close(oDlgPend) ENABLE OF oDlgPend

	ACTIVATE MSDIALOG oDlgPend CENTER
	
endif

Return(.t.)

User Function LICBxPend(nItem, aPend)

LOCAL aCores
PRIVATE cCadastro

if aPend[nItem][3]=="D"
	dbSelectArea("SZO")
	dbSetOrder(1)
	dbSeek(xFilial("SZO")+aPend[nItem][4])
	AxVisual("SZO",recno(),2)

else

	dbSelectArea("SZL")
	dbSetOrder(1)
	dbSeek(xFilial("SZL")+aPend[nItem][4])
	if aPend[nItem][3]=="P"
	   U_EnvProp()
	elseif aPend[nItem][3]=="F"
		U_FormPreco()
	elseif aPend[nItem][3]=="G"
		U_Grade(3)
	endif
endif
	              
aPend := CarregaArray()

if oHist:nAt > len(aPend)
	oHist:nAt := Len(aPend)
endif

SysRefresh()
	
return(aPend)


// Carrega array de pendencias
Static Function CarregaArray()

aRet := {}

dbSelectArea("SRA")
dbSetOrder(10)
dbSeek(UPPER(alltrim(cUserName)))
  	
dbSelectArea("SZL")
dbSetOrder(1)
dbGotop()
while !SZL->(Eof())

	cLicitante := alltrim(Posicione("SZP",1,xFilial("SZP")+SZL->ZL_LICITAN,"ZP_NOMLIC"))

	if Empty(SZL->ZL_PROPOS)
		cTexto := cLicitante + " / Grade num:" + SZL->ZL_NUMPRO + " - Data: "+dtoc(SZL->ZL_DATA)
	else
		cTexto := cLicitante + " / Proposta:" + SZL->ZL_PROPOS + " - Data: "+dtoc(SZL->ZL_DATA)
	endif
		
	if SZL->ZL_STATUS=="1" .and. ("F" $ SRA->RA_LIC)		
		AADD(aRet,{"Formação de Preço", cTexto,"F",SZL->ZL_NUMPRO })
	elseif SZL->ZL_STATUS=="2" .and. ("P" $ SRA->RA_LIC)
		AADD(aRet,{"Enviar Proposta", cTexto,"P",SZL->ZL_NUMPRO})
	elseif SZL->ZL_STATUS=="3" .and. ("G" $ SRA->RA_LIC)
		AADD(aRet,{"Preencher Grade", cTexto,"G",SZL->ZL_NUMPRO})
	endif	
		
	SZL->(dbSkip())
enddo

dbSelectArea("SZO")
dbSetOrder(1)
dbGotop()
while !SZO->(Eof())

	if SZO->ZO_DT_VENC < DDATABASE .and. ("D" $ SRA->RA_LIC)		
		AADD(aRet,{"Documento vencido", "Cod.Docto: " + SZO->ZO_CODDOC + " - "+SZO->ZO_DESCR,"D",SZO->ZO_CODDOC})
		lAchou := .t.
	elseif (SZO->ZO_DT_VENC > DDATABASE) .AND. ((SZO->ZO_DT_VENC - SZO->ZO_DIASALE) <= DDATABASE) .and. ("D" $ SRA->RA_LIC)		
		AADD(aRet,{"Documento a vencer", "Cod.Docto: " + SZO->ZO_CODDOC + " - "+SZO->ZO_DESCR,"D",SZO->ZO_CODDOC})
		lAchou := .t.
	endif

	SZO->(dbskip())
enddo

return(aRet)