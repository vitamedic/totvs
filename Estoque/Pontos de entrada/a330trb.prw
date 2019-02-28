#INCLUDE "Protheus.ch"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±³Fun‡„o	 ³ MA330TRB   ³ Autor ³ Claudio Ferreira    ³ Data ³ 26/12/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada para alterar o nivel das transferencias   ³±±
±±³            para considerar as entradas antes das saidas               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function __MA330TRB() 
Local cTRBDOC:='XXXXXXX'
Local cLocais:='40/41/92/93/95/17'
dbselectarea("TRB")
dbSetOrder(0)
dbGoTop()
while !Eof() 
    //Transferências de retorno de Armazenagem em Terceiros   
//	    ((TRB_CF = "RE4".and.(TRB_LOCAL$cLocais.OR.U_LocDesTrf(TRB_CF,TRB_SEQ)$cLocais).OR.TRB_LOCAL$U_LocDesTrf(TRB_CF,TRB_SEQ)).OR.(TRB_CF = "DE4".and.TRB_DOC==cTRBDOC)) .and.;
	If TRB_ALIAS == "SD3" .and.;
	    ((TRB_CF $ "RE4/DE4".and.(TRB_LOCAL$cLocais.OR.U_LocDesTrf(TRB_CF,TRB_SEQ)$cLocais).OR.TRB_LOCAL$U_LocDesTrf(TRB_CF,TRB_SEQ))) .and.;
	    TRB_ORDEM == "300" 
	    //if TRB_CF = "RE4"
	    //  cTRBDOC:=TRB_DOC
	    //else       
	    //  cTRBDOC:='XXXXXXX'
	    //endif       
	    cTipo:=Posicione('SB1',1,xFilial('SB1')+TRB->TRB_COD,'B1_TIPO')
		If reclock("TRB",.f.)  
			Replace TRB->TRB_NIVEL 	With if(cTipo='PA',"99y","99")
			Replace TRB->TRB_NIVSD3	With if(cTipo='PA',"z","4")
			msUnlock()
		EndIf
	EndIf   
    //Transferências de devoluções Vendas   
    nRecNo:=TRB->(Recno())
	If TRB_ALIAS == "SD1" .and. TRB_TIPONF = "D".and.TRB_LOCAL$'93/'  
		cTipo:=Posicione('SB1',1,xFilial('SB1')+TRB->TRB_COD,'B1_TIPO')
		If reclock("TRB",.f.)  
			Replace TRB->TRB_ORDEM 	With "300"
			Replace TRB->TRB_NIVEL 	With "99"  
			Replace TRB->TRB_NIVSD3	With if(cTipo='PA',"z","3")
			msUnlock()
		EndIf
	EndIf     
	TRB->(DbGoto(nRecNo))   
	//Transferências de devoluções Compras  
    nRecNo:=TRB->(Recno())
    cTipoNF:=Posicione('SF2',1,xFilial('SF2')+TRB->(TRB_DOC+TRB_SERIE),'F2_TIPO')
	If TRB_ALIAS == "SD2" .and. cTipoNF $ "B/D".and.TRB_LOCAL$cLocais
		If reclock("TRB",.f.)  
			Replace TRB->TRB_ORDEM 	With "300"
			Replace TRB->TRB_NIVEL 	With "99z"                   
			Replace TRB->TRB_NIVSD3	With "z"
			msUnlock()
		EndIf
	EndIf
	TRB->(DbGoto(nRecNo))   
	TRB->(DbSkip()) 
enddo	
Return                    

User Function LocDesTrf(cCF,cNumSeq) 
Local _cArea := GetArea()
Local cRet:='XX'
if !cCF$'RE4'
  Return 'XX'
endif
dbSelectArea("SD3")
dbSetOrder(4)  
MsSeek(xFilial("SD3")+cNumSeq)
While SD3->(D3_FILIAL+D3_NUMSEQ)==xFilial("SD3")+cNumSeq 
  if SD3->D3_CF=='DE4'
    cRet:=SD3->D3_LOCAL
    Exit
  endif
  DbSkip()
Enddo
RestArea(_cArea)
Return cRet    
