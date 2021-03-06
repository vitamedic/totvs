#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/11/99

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � QDOM700  矨utor � Newton R. Ghiraldelli 矰ata � 14/09/99   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       �                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


User Function Qdom700()        // incluido pelo assistente de conversao do AP5 IDE em 26/11/99
Local cTpDoc := GetMV("MV_QTPDOC")
Local dDtVig := "" // ctod("//")
Local	cRevi := StrZero(Val(M->QDH_RV),2) // Codigo da Revis鉶 da Especificacaod de Entrada
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
	QZ1->(DBSeek(xFilial("QZ1") + M->QDH_DOCTO)) // Busca pelo Documento no Cadastro de amarra鏰o Produto x Documento
	dDtVig := Posicione("QE6",1,xfilial("QE6") +  QZ1->QZ1_PROD + Inverte(cRevi),"QE6_DTINI")

   If Funname() <> "QDOA110" .and. ProcName(12) <> "QDOA110"
		_aArea:= QDH->(GetArea())
			U_Vitq002(M->QDH_DOCTO, M->QDH_RV)
		RestArea(_aArea)
	ElseIf dDtVig <> M->QDH_DTVIG // Grava data de Validacao 
		_aArea:= QDH->(GetArea())
			U_Vitq002(M->QDH_DOCTO, M->QDH_RV)
		RestArea(_aArea)

		//Gravar data de Vigencia no Inspe玢o de Entrada
		QE6->(DBSetOrder(1))
		If QE6->(DBSeek(xFilial("QE6") + QZ1->QZ1_PROD + Inverte(cRevi))) // Posiciona na Inspecificacao de Entrada
			QE6->(RecLock("QE6",.f.))
				QE6->QE6_DTINI := M->QDH_DTVIG // Grava data de Validacao 
			QE6->(MsUnlock())
		Else
			MsgAlert("Documento/Revis鉶: " + Alltrim(QDH->QDH_DOCTO) + " / " +QDH->QDH_RV + chr(13)  + chr(13) + Chr(10)+ "N鉶 existe Amarra玢o Produto x Documento " + chr(13)  + chr(13) + Chr(10)+ "Ou Revis鉶 da Especifica玢o est� INCORRETA.")
		EndIf
	endIf
endif
Return Alltrim( cEditor )
