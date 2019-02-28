#include "rwmake.ch"      

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ ValCCNF  ¦ Utilizador ¦ Claudio Ferreira  ¦ Data ¦ 04/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Valida digitação do C.Custo no Doc de Entrada              ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ Utilizado no PE MT100TOK                          		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function ValCCNF2(aCols,aBackColsSDE)
Local lOk:=.t.
Local i,ii
Local nPosTES  := GDFieldPos("D1_TES")
Local nPosCC   := GDFieldPos("D1_CC")
Local lValSDE   :=.f.


if Len(aBackColsSDE)>0
	For i:=1 to Len(aBackColsSDE)
		if Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ESTOQUE')='N' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_DUPLIC')='S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ATUATF')<>'S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_REFATAN')<>'1'
			For ii:=1 to Len(aBackColsSDE[i][2])
				if empty(aBackColsSDE[i][2][ii][3])//Centro de Custo
					lOk:=.f.
				endif
				lValSDE   :=.t.
			Next ii
		endif
	Next i
	if !lOk
		msgbox("Informe os Centros de Custo no Rateio")
	endif
endif
if lOk .and. !lValSDE
	For i:=1 to Len(aCols)
		if !aCols[i,Len(aHeader) + 1] .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ESTOQUE')='N' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_DUPLIC')='S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ATUATF')<>'S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_REFATAN')<>'1'
			if empty(aCols[i][nPosCC])//Centro de Custo
				lOk:=.f.
			endif
		endif
	Next i
	if !lOk
		msgbox("Informe os Centros de Custo dos Itens ou Selecione um Rateio CC")
	endif
endif

Return lOk
