#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/11/99

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ QDOM700  ³Autor ³ Newton R. Ghiraldelli ³Data ³ 14/09/99   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


User Function Qdom700()        // incluido pelo assistente de conversao do AP5 IDE em 26/11/99
Local cTpDoc := GetMV("MV_QTPDOC")
Local dDtVig := "" // ctod("//")
Local	cRevi := StrZero(Val(M->QDH_RV),2) // Codigo da Revisão da Especificacaod de Entrada
Local cMacro := GetMV("MV_QNMAC")

SetPrvt("CEDIT,CEDITOR,")
// O valor do cEdit e montado pelo parametro MV_QDTIPED e devera
//	conter um dos parametros abaixo
//cEdit:=Alltrim( cEdit )
//If cEdit == "WORD95"
//	cEditor := "TMsOleWord95"
//Elseif cEdit == "WORD97"
//ElseIf cEdit == "..."
//   cEditor := "..."       
//   Aqui deve-se colocar os elseif necessarios para determinar
//   qual o editor de texto deve-se usar.  Em 14 Set 1999 estao
//   disponiveis apenas no Word7(Office95) e Word8(Office97).
//EndIf

cEditor := "TMsOleWord97"

If Alltrim(M->QDH_CODTP) $ cTpDoc  
	QZ1->(DBSetOrder(2)) //  Order 2 = Documento + Produto
	QZ1->(DBSeek(xFilial("QZ1") + M->QDH_DOCTO)) // Busca pelo Documento no Cadastro de amarraçao Produto x Documento
	dDtVig := Posicione("QE6",1,xfilial("QE6") +  QZ1->QZ1_PROD + Inverte(cRevi),"QE6_DTINI")

   If Funname() <> "QDOA110" .and. ProcName(12) <> "QDOA110"
		_aArea:= QDH->(GetArea())
			U_Vitq002(M->QDH_DOCTO, M->QDH_RV)
		RestArea(_aArea)
	ElseIf dDtVig <> M->QDH_DTVIG // Grava data de Validacao 
		_aArea:= QDH->(GetArea())
			U_Vitq002(M->QDH_DOCTO, M->QDH_RV)
		RestArea(_aArea)

		//Gravar data de Vigencia no Inspeção de Entrada
		QE6->(DBSetOrder(1))
		If QE6->(DBSeek(xFilial("QE6") + QZ1->QZ1_PROD + Inverte(cRevi))) // Posiciona na Inspecificacao de Entrada
			QE6->(RecLock("QE6",.f.))
				QE6->QE6_DTINI := M->QDH_DTVIG // Grava data de Validacao 
			QE6->(MsUnlock())
		Else
			MsgAlert("Documento/Revisão: " + Alltrim(QDH->QDH_DOCTO) + " / " +QDH->QDH_RV + chr(13)  + chr(13) + Chr(10)+ "Não existe Amarração Produto x Documento " + chr(13)  + chr(13) + Chr(10)+ "Ou Revisão da Especificação está INCORRETA.")
		EndIf
	endIf
endif
Return Alltrim( cEditor )
