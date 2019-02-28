#include "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#include "dbtree.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIC006    ºAutor  ³Marcelo Myra        º Data ³  08/19/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela p/ Consulta de Histórico de Licitaçoes                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LIC006()

Local cProduto 	:= aCols[n][2]
Local _mArea     := {"SB1","SZL","SZM","SZN"}
Local _mAlias    := {}

_mAlias := U_SalvaAmbiente(_mArea)

dbselectarea("SZL")
szl->(dbclearfil())

DEFINE MSDIALOG oDlg2 FROM  23,181 TO 410,723 TITLE "Historico" PIXEL

@ 05,05 TO 035,270 TITLE "Produto"

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProduto)

@ 015,015 SAY "Codigo...: " + cProduto 	SIZE  150,7 COLOR CLR_BLUE
@ 025,015 SAY "Descricao: " + B1_DESC 	SIZE  150,7 COLOR CLR_BLUE

@ 040,05 SAY "Registros do produto:"

oTree := DbTree():New(50,05, 170, 260, oDlg2,,,.T.)

aItems := {}
nSeqTree := 1

dbSelectArea("SZM")
dbSetOrder(4)
dbSeek(xFilial("SZM")+cProduto)
while !SZM->(Eof()) .and. SZM->ZM_CODPRO==cProduto
	
	cLicitante	:= Posicione("SZL",1,xFilial("SZL")+SZM->ZM_NUMPRO,"ZL_LICITAN")
	dDataLic 	:= Posicione("SZL",1,xFilial("SZL")+SZM->ZM_NUMPRO,"ZL_DATA")
	
	cNomeLic := Posicione("SZP",1,xFilial("SZP")+cLicitante,"ZP_NOMLIC")

	_cItem 		:= dtoc(dDataLic) + " - " + cNomeLic
	_nPos 			:= U_VerPos(SZM->ZM_NUMPRO, SZM->ZM_CODPRO, GetNewPar("MV_LICONC","000001"))
	_cResource 	:= if(_nPos==1,"BMPCONS","BMPTABLE")
	
	DBADDTREE oTree PROMPT _cItem RESOURCE _cResource CARGO StrZero(nSeqTree++,4)
	
		dbSelectArea("SZN")
		dbSetOrder(3)
		dbSeek(xFilial("SZN")+SZM->ZM_NUMPRO+SZM->ZM_CODPRO)
		_c := 1
		while !SZN->(Eof()) .and. SZM->ZM_NUMPRO==SZN->ZN_NUMPRO .and. SZM->ZM_CODPRO==SZN->ZN_CODPRO
			_cConc := strzero(_c,3)+" - "+SZN->ZN_NOMCON+" => $" + TRANSFORM(SZN->ZN_PRECO,"@E 999.9999")
			_cResource 	:= if(SZN->ZN_CODCON==GetNewPar("MV_LICONC","000001") ,"CHECKED","BMPUSER")
			DBADDITEM oTree PROMPT _cConc RESOURCE _cResource CARGO StrZero(nSeqTree++,4)
			_c++
			SZN->(dbskip())
		enddo
	
	DBENDTREE oTree
	
	SZM->(dbSkip())
	
enddo
 
@ 180,200 BUTTON "_Sair" SIZE 55,10 ACTION Close(oDlg2)

ACTIVATE MSDIALOG oDlg2 CENTER

dbselectarea("SZL")
SZL->(DbSetFilter({|| SZL->ZL_PROPOS<>space(8)},"szl->zl_propos<>'        '"))

U_VoltaAmbiente(_mAlias)

Return(.T.)

// Função para trocar sinal X do LISTABOX
Static Function AOperTroca(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray
