#INCLUDE "RWMAKE.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITQ004  ³Autor ³ Marcelo Myra          ³Data ³ 14/02/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza a Duplicacao de Especificacoes de um Produto,      ³±±
±±³          ³ Aproveitando a Descricao do SB1 Quando o Campo com a Nova  ³±±
±±³          ³ Descricao e Deixado em Branco                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


User Function Vitq004()
Local _cMSG   := ""
Local nDias   := GetMv("MV_QDTDIAS")
Local cDescB1 := ""

Private aCampos := {}
Private aCamQE7 := {}
Private aCamQE8 := {}
Private aCamQE9 := {}

cperg := "PERGVIQ004"
_pergsx1()

if pergunte(cperg,.t.)
	dbSelectArea("QE6")
	dbSetOrder(1)
	// Não permite duplicação qdo destino já existe
	lDestExis := .f.
	if dbSeek(xFilial("QE6")+mv_par03+inverte(mv_par04))
		lDestExis := .t.
		_cMSG := "Produto Destino já CADASTRADO!"
	ElseIf dbSeek(xFilial("QE6")+mv_par03)
		If QE6->QE6_DTINI > dDataBase
			lDestExis := .t.
			_cMSG := "Não é possivel gerar Revisão a: "  + Alltrim(mv_par04)+ " para Produto:  " + Alltrim(mv_par03) + Chr(13) + Chr(13) + Chr(10) + "Revisão:  " + Alltrim(QE6->QE6_REVI) + " ainda NÃO ESTÁ VIGENTE"
		EndIf
	endif                                 
	dbSelectArea("SB1")
	dbSetOrder(1)
   dbSeek(xFilial("SB1")+ mv_par03)
   IF !found()
		lDestExis := .t.
		_cMSG := "Produto não existe, digite um produto válido!"
	endif	
	
//	if  mv_par05 == 1 
//		 cDescB1 := Posicione("SB1",1,xFilial("SB1") + mv_par01, "B1_DESC" )
//	elseIf mv_par05 == 2 
   cDescB1 := Posicione("SB1",1,xFilial("SB1") + mv_par03, "B1_DESC" )
//   If mv_par05 == 3 
//	   cDescB1 := Iif(Empty(mv_par06),Posicione("SB1",1,xFilial("SB1") + mv_par03, "B1_DESC" ) , mv_par06)
//   EndIf
   
/*/   IF !dbSeek(xFilial("SB1")+ mv_par03)
   	MsgStop("Para produtos novos, utilize a duplicação padrão.")
		return(nil)
	endif /*/
	
	SX3->(dbSeek("QE6"))
	While !SX3->(EOF()) .and. SX3->X3_ARQUIVO <= "QE9"
		If SX3->X3_CONTEXT <> "V"
			Do Case
				Case SX3->X3_ARQUIVO == "QE6"
					aAdd(aCampos,{SX3->X3_CAMPO,SX3->X3_ORDEM,""})
				Case SX3->X3_ARQUIVO == "QE7"
					aAdd(aCamQE7,{SX3->X3_CAMPO,""})
				Case SX3->X3_ARQUIVO == "QE8"
					aAdd(aCamQE8,{SX3->X3_CAMPO,""})
				Case SX3->X3_ARQUIVO == "QE9"
					aAdd(aCamQE9,{SX3->X3_CAMPO,""})
			EndCase
		EndIf
		SX3->(dbSkip())
	EndDo
	
	dbSelectArea("QE6")                           
	MSGSTOP(inverte(mv_par02))
	if dbSeek(xFilial("QE6")+mv_par01+inverte(mv_par02)) .and. !lDestExis
		for i:= 1 to Len(aCampos)
			Do Case
				Case Alltrim(aCampos[i,1]) == "QE6_DTINI"
					aCampos[i,3] := FieldGet(FieldPos(aCampos[i,1])) + nDias //&aCampos[i][1]
					
				Case Alltrim(aCampos[i,1]) == "QE6_PRODUT"
					aCampos[i,3] := mv_par03 // FieldGet(FieldPos(aCampos[i,1] ) ) + 365//&aCampos[i][1]
					
				Case Alltrim(aCampos[i,1]) == "QE6_REVI"
					aCampos[i,3] := mv_par04 // FieldGet(FieldPos(aCampos[i,1] ) ) + 365//&aCampos[i][1]
					
				Case Alltrim(aCampos[i,1]) == "QE6_REVINV"
					aCampos[i,3] := Inverte(mv_par04) //FieldGet(FieldPos(aCampos[i,1] ) ) + 365//&aCampos[i][1]
					
				Case Alltrim(aCampos[i,1]) == "QE6_DESCPO"
					aCampos[i,3] := cDescB1
					
				OtherWise // Validacao da linha digitavel de concessionarias
					aCampos[i,3] := FieldGet( FieldPos(aCampos[i,1]) ) //&aCampos[i][1]
			EndCase
		Next
		
		// Inclui o novo produto
		QE6->(Reclock("QE6",.t.))
		for i:= 1 to Len(aCampos)
			FieldPut(FieldPos(aCampos[i,1]),aCampos[i,3])
		Next
		QE6->(MsUnlock())
		
		aQE7 := {}
		dbSelectArea("QE7")
		dbSetOrder(1)
		if dbSeek(xFilial("QE7")+mv_par01+mv_par02,.t.)
			while !QE7->(Eof()) .and. QE7->QE7_PRODUT==mv_par01 .and. QE7->QE7_REVI==mv_par02
				aAdd(aQE7,Array(Len(aCamQe7) ))
				
				for i:= 1 to Len(aCamQE7)
					if Alltrim(aCamQE7[i,1]) == "QE7_PRODUT"
						aQE7[Len(aQE7),i] := mv_par03
					Elseif Alltrim(aCamQE7[i,1]) == "QE7_REVI"
						aQE7[Len(aQE7),i] := mv_par04
					Else
						aQE7[Len(aQE7),i] := FieldGet( FieldPos(aCamQE7[i,1]) )
					EndIf
				Next
				
				QE7->(dbSkip())
			enddo
			
			// Grava os ensaios mensuráveis
			dbSelectArea("QE7")
			For j := 1 to Len(aQE7)
				QE7->(Reclock("QE7",.t.))
				for i := 1 to Len(aCamQE7)
					FieldPut(FieldPos(aCamQE7[i,1]),aQE7[j,i])
				Next
				QE7->(MsUnlock())
			Next 
		endif
		
		//Guarda os ensaios tipo texto
		aQE8 := {}
		dbSelectArea("QE8")
		dbSetOrder(1)
		if dbSeek(xFilial("QE8")+mv_par01+mv_par02,.t.)
			while !QE8->(Eof()) .and. QE8->QE8_PRODUT==mv_par01 .and. QE8->QE8_REVI==mv_par02
				aAdd(aQE8,Array(Len(aCamQe8) ))
				
				for i:= 1 to Len(aCamQE8)
					if Alltrim(aCamQE8[i,1]) == "QE8_PRODUT"
						aQE8[Len(aQE8),i] := mv_par03
					Elseif Alltrim(aCamQE8[i,1]) == "QE8_REVI"
						aQE8[Len(aQE8),i] := mv_par04
					Else
						aQE8[Len(aQE8),i] := FieldGet( FieldPos(aCamQE8[i,1]) )
					EndIf
				Next
				QE8->(dbSkip())
			enddo
			
			// Grava os ensaios tipo texto
			dbSelectArea("QE8")
			For j := 1 to Len(aQE8)
				QE8->(Reclock("QE8",.t.))
				for i := 1 to Len(aCamQE8)
					FieldPut(FieldPos(aCamQE8[i,1]),aQE8[j,i])
				Next
				QE8->(MsUnlock())
			Next 
			
		endif
		
		// Guarda as NCs dos ensaios
		aQE9 := {}
		dbSelectArea("QE9")
		dbSetOrder(1)
		if dbSeek(xFilial("QE9")+mv_par01+mv_par02,.t.)
			while !QE9->(Eof()) .and. QE9->QE9_PRODUT==mv_par01 .and. QE9->QE9_REVI==mv_par02
				aAdd(aQE9,Array(Len(aCamQE9) ))
				
				for i:= 1 to Len(aCamQE9)
					if Alltrim(aCamQE9[i,1]) == "QE9_PRODUT"
						aQE9[Len(aQE9),i] := mv_par03
					Elseif Alltrim(aCamQE9[i,1]) == "QE9_REVI"
						aQE9[Len(aQE9),i] := mv_par04
					Else
						aQE9[Len(aQE9),i] := FieldGet( FieldPos(aCamQE9[i,1]) )
					EndIf
				Next
				QE9->(dbSkip())
			enddo

			// Grava os ensaios tipo texto
			dbSelectArea("QE9")
			For j := 1 to Len(aQE9)
				QE9->(Reclock("QE9",.t.))
				for i := 1 to Len(aCamQE9)
					FieldPut(FieldPos(aCamQE9[i,1]),aQE9[j,i])
				Next
				QE9->(MsUnlock())
			Next 
		endif
		MsgInfo("Especificação Duplicada com SUCESSO!")
	else
		if lDestExis
			MsgStop(_cMsg)
		else
			MsgStop("Produto/Revisao de origem NÃO ENCONTRADO!")
		endif
		
	endif
endif

Return(nil)


Static Function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Produto Origem     ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QE6"})
aadd(_agrpsx1,{cperg,"02","Revisao Origem     ?","mv_ch2","C",02,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Produto Destino    ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Revisao Destino    ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"05","Descrição          ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Origem"         ,space(30),space(15),"Destino"        ,space(30),space(15),"Outra"        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"06","Nova Descrição     ?","mv_ch6","C",30,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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