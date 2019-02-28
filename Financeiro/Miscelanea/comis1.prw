/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT357 ³ Autor ³ Andre Almeida Alves     ³ Data ³ 05/11/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza a Tabela SE1 com o Percentual de Comissão do      ³±±
±±³          ³ Pedido de Venda                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"       
#include "topconn.ch"

User Function comis1()

	cQUERY := "	SELECT *"
	cQUERY += " FROM "+RETSQLNAME("SE1")+ " SE1 "
	cQUERY += "	WHERE SE1.D_E_L_E_T_ = ' ' "
	cQUERY += "	AND E1_BAIXA BETWEEN '20121216' AND '20121231'"
	MEMOWRIT("\sql\COMISS.SQL",cQUERY)
	TCQUERY cQUERY NEW ALIAS "TMP"

	PROCREGUA(0)
    Dbselectarea('TMP')
	TMP->(DBGOTOP())	
	SE1->(Dbsetorder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	WHILE !TMP->(EOF())  
		INCPROC(TMP->E1_NUM) 
		IF SE1->(DBSEEK(xFILIAL("SE1")+TMP->E1_PREFIXO+TMP->E1_NUM+TMP->E1_PARCELA+TMP->E1_TIPO))  
			
			dQUERY := "	SELECT *"
			dQUERY += " FROM "+RETSQLNAME("SE1")+ " SE1 "
			dQUERY += "	WHERE SE1.D_E_L_E_T_ = ' ' "
			dQUERY += "	AND E1_FILIAL = '"+TMP->E1_FILIAL+"'"
			dQUERY += "	AND E1_PREFIXO = '2  '"
			dQUERY += "	AND E1_FATURA = '"+TMP->E1_NUM+"'"
			dQUERY += "	AND E1_PARCELA = '"+TMP->E1_PARCELA+"'"
			MEMOWRIT("\sql\COMISS1.SQL",dQUERY)
			TCQUERY dQUERY NEW ALIAS "TMP1"
	
		    Dbselectarea('TMP1')
			TMP1->(DBGOTOP())	
	
		    Dbselectarea('SC5')
			SC5->(Dbsetorder(1)) //C5_FILIAL+C5_NUM
	
			IF SC5->(DBSEEK(xFILIAL("SC5")+TMP1->E1_PEDIDO))  
				RECLOCK("SE1",.F.)
				SE1->E1_COMIS1 := SC5->C5_COMIS1
				SE1->E1_COMIS2 := SC5->C5_COMIS2
				SE1->E1_COMIS3 := SC5->C5_COMIS3
				MsUnlock()
			ENDIF
			TMP1->(DBCLOSEAREA())
		ENDIF
		TMP->(DBSKIP())
	 ENDDO             
	TMP->(DBCLOSEAREA())
Return