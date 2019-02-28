#include "rwmake.ch"  
#include "dbtree.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIC012    ºAutor  ³Marcelo Myra Martinsº Data ³  22/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para consulta de resultados em DBTREE                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LIC012(_cProp, _cProd)

Local _mArea     := {"SB1","SZL","SZM","SZN"}
Local _mAlias    := {}

_mAlias := U_SalvaAmbiente(_mArea)

if !Empty(_cProp)
	dbSelectArea("SZL")
	dbSetOrder(1)
	dbSeek(xFilial("SZL")+_cProp)
endif

DEFINE MSDIALOG oDlg FROM 0,0 TO 394,634 PIXEL TITLE "Consulta de Resultados"
  
oTree := DbTree():New(15, 3, 197, 315, oDlg,,,.T.)
  
nSeqTree := 1
 
@ 3,3 BUTTON "_Sair" SIZE 55,10 ACTION Close(oDlg)

DBADDTREE oTree PROMPT "Data:" + DTOC(SZL->ZL_DATA) + " - Licitante: " +Posicione("SZP",1,xFilial("SZP")+SZL->ZL_LICITAN,"ZP_NOMLIC")  RESOURCE "BMPTABLE" CARGO StrZero(nSeqTree++,4)

dbSelectArea("SZM")
dbSetOrder(3)
dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO)
while !SZM->(Eof()) .and. SZL->ZL_NUMPRO==SZM->ZM_NUMPRO
	if !empty(_cProd) .and. SZM->ZM_CODPRO<>_cProd
		SZM->(dbSkip())
		Loop
	endif
	cProduto := SZM->ZM_CODPRO + " - " + SZM->ZM_DESC
	nPos := U_VerPos(SZM->ZM_NUMPRO, SZM->ZM_CODPRO, GetNewPar("MV_LICONC","000001"))
	do case
		case nPos==0
			_cResource := "BMPTABLE"
		case nPos==1
			_cResource := "BMPCONS"
		otherwise
			_cResource := ""
	endcase
	DBADDTREE oTree PROMPT cProduto RESOURCE _cResource CARGO StrZero(nSeqTree++,4)
		dbSelectArea("SZN")
		dbSetOrder(3)
		dbSeek(xFilial("SZN")+SZL->ZL_NUMPRO+SZM->ZM_CODPRO)
		_c := 1
		while !SZN->(Eof()) .and. SZL->ZL_NUMPRO==SZN->ZN_NUMPRO .and. SZM->ZM_CODPRO==SZN->ZN_CODPRO
			cConc := strzero(_c,3)+" - "+SZN->ZN_NOMCON+" => $" + TRANSFORM(SZN->ZN_PRECO,"@E 999.9999")
			_cResource := if(SZN->ZN_CODCON==GetNewPar("MV_LICONC","000001"),"CHECKED","BMPUSER")
			DBADDITEM oTree PROMPT cConc RESOURCE _cResource CARGO StrZero(nSeqTree++,4)
			_c++
			SZN->(dbskip())
		enddo
	DBENDTREE oTree
	SZM->(dbSkip())
enddo
                    
DBENDTREE oTree

ACTIVATE MSDIALOG oDlg CENTER

U_VoltaAmbiente(_mAlias)

Return(.t.)