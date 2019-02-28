#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function vit051()


SetPrvt("TAMANHO,NHORA,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CBCONT,CBTXT,NORDEM,CPERG,CSTRING")
SetPrvt("NOMEPROG,ALINHA,M_PAG,WNREL,ARETURN,NTOTVEND,NTOT")
SetPrvt("NTOTBAL,NTOTPRO,NTOTRES,NTOTVEN,MV_PAR01,MV_PAR02")
SetPrvt("CENT,LI,CTOTPRIN,DDATEMIS,CSAI,CNUMDOC")
SetPrvt("CQUER1,CQUER2,CQUER3,CQUER4,CQUER5")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/04/02 ==> #INCLUDE "TOPCONN.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa  ³ VIT051   ³Autor ³Gardenia Ilany       ³Data ³ 05/04/2002   ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Relatorio Controle de Distribuicao de Produtos Por Lote    ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 6.09 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Tamanho    := "M"
nHora      := Time()
Limite     := 120
Titulo     := "Relatorio de Controle de Dist. de Produtos Por Lote"
cDesc1     := "Este programa ira emitir o relatorio das Distribuicoes dos"
cDesc2     := "Produtos por Lote de acordo com os parametros"
cDesc3     := ""
cbCont     := 0
cbTxt      := ""
nOrdem     := ""
cPerg      := "PERGVIT051"
cString    := "SB1"
NomeProg   := "VIT051"
aLinha     := {}
m_pag      := 0
wnRel      := "VIT051"+Alltrim(cusername)
aReturn    := {"Zebrado",1,"Administracao",1,2,1,"",0}
nTotVend   := 0
nTotdev    := 0
nTotBal    := 0
nTotPro    := 0
nTotRes    := 0
nTotVen    := 0
nTot       := 0
_pergsx1()
pergunte(cperg,.f.)

wnRel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastkey == 27 .Or. LastKey() == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

ntipo :=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptStatus({||Imptit2()})// Substituido pelo assistente de conversao do AP6 IDE em 12/04/02 ==> rptStatus({||Execute(Imptit2)})
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa  ³ IMPTIT2   ³Autor ³ Gardenia Ilany       ³Data ³ 05/04/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao dos Produtos Acabados                            ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 6.09 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/04/02 ==> Function ImpTit2
Static Function ImpTit2()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Do Produto         ³
//³mv_par02  := Do Lote            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Recno())
SeleTrab()
@ 00,00 PSAY AvalImp(Limite)

ImpCabec()

if mv_par04<>1
	// Come‡a as Entradas
	dbSelectArea("TRA1")
	dbGoTop()
	If !Eof()
		cEnt := 1
	EndIf
	dbSelectArea("TRA2")
	dbGoTop()
	If !Eof()
		cEnt := 1
	EndIf
	If cEnt == 1
		@ li,000 PSAY "E N T R A D A S "
		li := li + 1
	EndIf
	dbSelectArea("TRA1")
	dbGoTop()
	If !Eof()
		cTotPrin := 1
		//  @ li,009 PSAY "B a l a n c o - E n t r a d a s"
		//  @ li,009 PSAY " P r o d u c o e s"
//		li := li + 1
		SetRegua(Recno())
		Do While ! Eof()
			IncRegua()
			dDatEmis := CtoD(SubStr(TRA1->D3_EMISSAO,7,2)+"/"+SubStr(TRA1->D3_EMISSAO,5,2)+"/"+SubStr(TRA1->D3_EMISSAO,3,2))
			dbSelectArea("SF5")
			dbSetOrder(1)
			dbSeek(xFilial("SF5")+TRA1->D3_TM)
			If !Found()
				@ li,002 PSAY dDatEmis	
				If TRA1->D3_DOC == "INVENT"
					@ li,015 PSAY "INVENTARIO" Picture "@!"
				EndIf			
				@ li,030 PSAY TRA1->D3_DOC				
			Else
				if TRA1->D3_TM <> "104" 
					@ li,002 PSAY dDatEmis
					@ li,015 PSAY substr(SF5->F5_TEXTO,1,20)  Picture "@!"					
					@ li,038 PSAY TRA1->D3_DOC				
				elseif mv_par05==1         
					@ li,002 PSAY dDatEmis
					@ li,015 PSAY substr(SF5->F5_TEXTO,1,20)  Picture "@!"
					@ li,038 PSAY TRA1->D3_DOC				
				endif				
			EndIf
			if TRA1->D3_TM <> "104" 
				@ li,066 PSAY if(mv_par05==3,TRA1->D3_QUANT/2,TRA1->D3_QUANT) Picture "@E 999,999,999.99"
				li := li + 1
				nTotBal += if(mv_par05==3,TRA1->D3_QUANT/2,TRA1->D3_QUANT)		
			elseif mv_par05==1
				@ li,066 PSAY TRA1->D3_QUANT Picture "@E 999,999,999.99"
				li := li + 1
				nTotBal += if(mv_par05==3,TRA1->D3_QUANT/2,TRA1->D3_QUANT)
			endif
			If li >= 61
				ImpCabec()
			EndIf
			dbSelectArea("TRA1")
			dbSkip()
		EndDo
		
		@ li,066 PSAY nTotBal Picture "@E 999,999,999.99"
		li := li + 1
	EndIf
	dbSelectArea("TRA2")
	dbGoTop()
	If !Eof()
		cTotPrin := 1
  //		li := li + 1
		SetRegua(Recno())
		Do While ! Eof()
			IncRegua()
			dDatEmis := CtoD(SubStr(TRA2->D3_EMISSAO,7,2)+"/"+SubStr(TRA2->D3_EMISSAO,5,2)+"/"+SubStr(TRA2->D3_EMISSAO,3,2))
			dbSelectArea("SF5")
			dbSetOrder(1)
			dbSeek(xFilial("SF5")+TRA2->D3_TM)
			If !Found()
				@ li,002 PSAY dDatEmis
				If TRA1->D3_DOC == "INVENT"
					@ li,015 PSAY "INVENTARIO" Picture "@!"
				EndIf                                     
				@ li,038 PSAY TRA2->D3_DOC														
			Else
				if TRA2->D3_TM <> "104"   
					@ li,002 PSAY dDatEmis
					@ li,015 PSAY substr(SF5->F5_TEXTO,1,20)  Picture "@!"					
					@ li,038 PSAY TRA2->D3_DOC				
				elseif mv_par05==1
					@ li,002 PSAY dDatEmis
					@ li,015 PSAY substr(SF5->F5_TEXTO,1,20)  Picture "@!"
					@ li,038 PSAY TRA2->D3_DOC
					
				endif				
			EndIf
			if TRA2->D3_TM <> "104" 
				@ li,066 PSAY if(mv_par05==3,TRA2->D3_QUANT/2,TRA2->D3_QUANT) Picture "@E 999,999,999.99"
				nTotPro += if(mv_par05==3,TRA2->D3_QUANT/2,TRA2->D3_QUANT)
			elseif mv_par05==1
				@ li,066 PSAY TRA2->D3_QUANT Picture "@E 999,999,999.99"
				nTotPro += if(mv_par05==3,TRA2->D3_QUANT/2,TRA2->D3_QUANT)
			endif
			li := li + 1
			If li >= 61
				ImpCabec()
			EndIf
			dbSelectArea("TRA2")
			dbSkip()
		EndDo
		@ li,066 PSAY nTotPro Picture "@E 999,999,999.99"
		li := li + 1
	EndIf
	If cTotPrin == 1
		@ li,000 PSAY "T O T A L  E N T R A D A S --->"
		@ li,066 PSAY (nTotBal + nTotPro) Picture "@E 999,999,999.99"
		li := li + 1
	EndIf
endif


// Come‡a as Saidas
dbSelectArea("TRA3")
dbGoTop()
If !Eof()
	cSai := 1
EndIf
dbSelectArea("TRA4")
dbGoTop()
If !Eof()
	cSai := 1
EndIf
If cSai == 1
	li := li + 1
	@ li,000 PSAY "S A I D A S "
	li := li + 1
EndIf
dbSelectArea("TRA4")
dbGoTop()
ntot := 0
If !Eof()
	cTotPrin := 1
	li := li + 1
	@ li,009 PSAY "V e n d a s "
	li := li + 1
	SetRegua(Recno())
	Do While ! Eof()
		IncRegua()
		if TRA4->D2_QUANT-TRA4->D2_QTDEDEV <=0
			dbSkip()
			loop
		endif
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+TRA4->D2_TES)
		if sf4->f4_duplic<>"S"
			dbSelectArea("TRA4")
			dbSkip()
			loop
		endif        		
		if (nTotVen >= (nTotBal + nTotPro) .and. mv_par05==2)
			dbSelectArea("TRA4")
			dbSkip()
			loop
		endif
		
		dDatEmis := CtoD(SubStr(TRA4->D2_EMISSAO,7,2)+"/"+SubStr(TRA4->D2_EMISSAO,5,2)+"/"+SubStr(TRA4->D2_EMISSAO,3,2))
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+TRA4->D2_CLIENTE+TRA4->D2_LOJA)
		if mv_par04<>1
			@ li,001 PSAY dDatEmis
			@ li,010 PSAY SubStr(SA1->A1_NOME,1,28) Picture "@!"
			if mv_par03 = 1
				@ li,040 PSAY TRA4->D2_PEDIDO Picture "@!"
				cNumDoc := (TRA4->D2_DOC + "-" + TRA4->D2_SERIE)
				@ li,047 PSAY cNumDoc
			endif
			_fatorpos:=0.7234
			if sa1->a1_est = "RJ"
				_fatorneg:=0.7523
			elseif sa1->a1_est = "SP#RS#MG#SC#PR"
				_fatorneg:=0.7519
			elseif sa1->a1_est = "AM#AC#AP#RO"
				_fatorneg:=0.7234
			else
				_fatorneg:=0.7516
			endif
			_nprmax := 0
			if sb1->b1_categ=="N  "
				_nprmax:=round(tra4->d2_prunit/_fatorneg,6)
			else
				_nprmax:=round(tra4->d2_prunit/_fatorpos,6)
			endif
			@ li,066 PSAY if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV) Picture "@E 999,999.99"
			@ li,077 PSAY TRA4->D2_PRCVEN Picture "@E 999,999.99"
			@ li,089 PSAY TRA4->D2_PRUNIT Picture "@E 999,999.99"
			@ li,100 PSAY _nprmax  Picture "@E 999,999.99"
		else
			@ li,001 PSAY sa1->a1_cgc Picture "@R 99.999.999/999-99"
			@ li,019 PSAY SubStr(SA1->A1_NOME,1,28) Picture "@!"
			cNumDoc := (TRA4->D2_DOC) // + "-" + TRA4->D2_SERIE)
			@ li,048 PSAY dDatEmis
			@ li,058 PSAY cNumDoc
			@ li,066 PSAY if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV) Picture "@E 999,999.99"
			@ li,077 PSAY TRA4->D2_PRCVEN Picture "@E 999,999.99"
			@ li,090 PSAY SUBSTR(sa1->a1_end,1,30)+" "+SUBSTR(sa1->a1_bairro,1,20)+" "+SUBSTR(sa1->a1_mun,1,20)+" "+sa1->a1_est
		endif
		li := li + 1
		If li >= 61
			ImpCabec()
		EndIf
		nTotVen += if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV)
		dbSelectArea("TRA4")
		dbSkip()
	EndDo
	if mv_par04 <> 1 .and. nTotVen > 0
		@ li,000 PSAY "T o t a l  V e n d a s --->"
		@ li,066 PSAY nTotVen Picture "@E 999,999,999.99"
		li := li + 1
	
	endif
EndIf

////

//bonificação
nTotbon := 0
_la := .t.

dbSelectArea("TRA4")
dbGoTop()
If !Eof()
	cTotPrin := 1
	SetRegua(Recno())
	Do While ! Eof()
		IncRegua()
		if TRA4->D2_QUANT-TRA4->D2_QTDEDEV <=0
			dbSkip()
			loop
		endif
		if ((nTotVen+nTotbon >= nTotBal + nTotPro) .and. mv_par05==2)
			dbSkip()
			loop
		endif
		
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+TRA4->D2_TES)
		if sf4->f4_duplic=="S"
			dbSelectArea("TRA4")
			dbSkip()
			loop
		endif
		if sf4->f4_tpmov=="V"
			dbSelectArea("TRA4")
			dbSkip()
			loop
		endif
		dDatEmis := CtoD(SubStr(TRA4->D2_EMISSAO,7,2)+"/"+SubStr(TRA4->D2_EMISSAO,5,2)+"/"+SubStr(TRA4->D2_EMISSAO,3,2))
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+TRA4->D2_CLIENTE+TRA4->D2_LOJA)
		if mv_par04<>1
			if _la
				li := li + 1
				@ li,009 PSAY "B o n i f i c a c a o "
				li := li + 1
				_la := .f.
			endif
			@ li,001 PSAY dDatEmis
			@ li,010 PSAY SubStr(SA1->A1_NOME,1,28) Picture "@!"
			if mv_par03 = 1
				@ li,040 PSAY TRA4->D2_PEDIDO Picture "@!"
				cNumDoc := (TRA4->D2_DOC + "-" + TRA4->D2_SERIE)
				@ li,047 PSAY cNumDoc
			endif
			@ li,066 PSAY if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV) Picture "@E 999,999.99"
			li := li + 1

		else
			@ li,001 PSAY sa1->a1_cgc Picture "@R 99.999.999/999-99"
			@ li,019 PSAY SubStr(SA1->A1_NOME,1,28) Picture "@!"
			cNumDoc := (TRA4->D2_DOC) // + "-" + TRA4->D2_SERIE)
			@ li,048 PSAY dDatEmis
			@ li,058 PSAY cNumDoc
			@ li,066 PSAY if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV) Picture "@E 999,999.99"
			li := li + 1
			
		endif
			If li >= 61
			ImpCabec()
		EndIf
		nTotbon += if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV)
		dbSelectArea("TRA4")
		dbSkip()
	EndDo
	if mv_par04 <> 1 .and. nTotbon > 0
		@ li,000 PSAY "T o t a l  B o n i f i c a c a o --->"
		@ li,066 PSAY nTotbon Picture "@E 999,999,999.99"
		li := li + 1
		ntot += nTotbon
	endif
EndIf

//
_m := .t.

dbSelectArea("TRA3")
dbGoTop()
If !Eof()
	cTotPrin := 1
	SetRegua(Recno())
	Do While ! Eof()
		IncRegua()
		if ((nTotVen+nTotbon+nTotRes) >= (nTotBal + nTotPro) .and. mv_par05==2)
			dbSelectArea("TRA3")		
			dbSkip()
			loop
		endif
		if _m
 			@ li,009 PSAY " S a i d a s "
			li := li + 1
			_m := .f.
		endif	
		
		
		dDatEmis := CtoD(SubStr(TRA3->C9_DATALIB,7,2)+"/"+SubStr(TRA3->C9_DATALIB,5,2)+"/"+SubStr(TRA3->C9_DATALIB,3,2))
		@ li,001 PSAY dDatEmis
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+TRA3->C9_CLIENTE+TRA3->C9_LOJA)
		If !Found()
			If TRA1->D3_DOC == "INVENT"
				@ li,010 PSAY "INVENTARIO" Picture "@!"
			EndIf
		Else
			@ li,010 PSAY SA1->A1_NOME  Picture "@!"
		EndIf
		@ li,066 PSAY if(mv_par05==3,TRA3->C9_QTDLIB/2,TRA3->C9_QTDLIB) Picture "@E 999,999.99"
		li := li + 1
		If li >= 61
			ImpCabec()
		EndIf
		nTotRes += if(mv_par05==3,TRA3->C9_QTDLIB/2,TRA3->C9_QTDLIB)
		dbSelectArea("TRA3")
		dbSkip()
	EndDo
	if nTotRes > 0
		@ li,000 PSAY "T o t a l  S a i d a s --->"
		@ li,066 PSAY nTotRes Picture "@E 999,999,999.99"
		li := li + 1
		ntot += nTotRes
	endif	
EndIf

//// doações
nTotdoa := 0
_la := .t.

dbSelectArea("TRA4")
dbGoTop()
If !Eof()
	cTotPrin := 1
	SetRegua(Recno())
	Do While ! Eof()
		IncRegua()
		if TRA4->D2_QUANT-TRA4->D2_QTDEDEV <=0
			dbSkip()
			loop
		endif
		if ((nTotVen+nTotdoa >= nTotBal + nTotPro) .and. mv_par05==2)
			dbSkip()
			loop
		endif
		
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+TRA4->D2_TES)
		if sf4->f4_duplic=="S"
			dbSelectArea("TRA4")
			dbSkip()
			loop
		endif
		if sf4->f4_tpmov<>"V"
			dbSelectArea("TRA4")
			dbSkip()
			loop
		endif
		dDatEmis := CtoD(SubStr(TRA4->D2_EMISSAO,7,2)+"/"+SubStr(TRA4->D2_EMISSAO,5,2)+"/"+SubStr(TRA4->D2_EMISSAO,3,2))
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+TRA4->D2_CLIENTE+TRA4->D2_LOJA)
		if mv_par04<>1
			if _la
				li := li + 1
				@ li,009 PSAY "D o a c o e s "
				li := li + 1
				_la := .f.
			endif
			@ li,001 PSAY dDatEmis
			@ li,010 PSAY SubStr(SA1->A1_NOME,1,28) Picture "@!"
			if mv_par03 = 1
				@ li,040 PSAY TRA4->D2_PEDIDO Picture "@!"
				cNumDoc := (TRA4->D2_DOC + "-" + TRA4->D2_SERIE)
				@ li,047 PSAY cNumDoc
			endif
			@ li,066 PSAY if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV) Picture "@E 999,999.99"
			li := li + 1

		else
			@ li,001 PSAY sa1->a1_cgc Picture "@R 99.999.999/999-99"
			@ li,019 PSAY SubStr(SA1->A1_NOME,1,28) Picture "@!"
			cNumDoc := (TRA4->D2_DOC) // + "-" + TRA4->D2_SERIE)
			@ li,048 PSAY dDatEmis
			@ li,058 PSAY cNumDoc
			@ li,066 PSAY if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV) Picture "@E 999,999.99"
			li := li + 1
			
		endif
			If li >= 61
			ImpCabec()
		EndIf
		nTotdoa += if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV)
		dbSelectArea("TRA4")
		dbSkip()
	EndDo
	if mv_par04 <> 1 .and. nTotdoa > 0
		@ li,000 PSAY "T o t a l  D o a c o e s --->"
		@ li,066 PSAY nTotdoa Picture "@E 999,999,999.99"
		li := li + 1
		ntot += nTotdoa
	endif
EndIf



//// devolução

_ndev := 0
_cfilsf4:=xfilial("SF4")
sf4->(dbsetorder(1))

dbSelectArea("tra5")
dbGoTop()
If !Eof()
	cTotPrin := 1
	
	//	  ntotdev:=0
	SetRegua(Recno())
	_ndev := 0
	_m :=.t.
	
	Do While ! Eof()
		IncRegua()
		sf4->(dbseek(_cfilsf4+tra5->d1_tes))
		If sf4->f4_estoque =='N' .and. tra5->d1_doc<>"065308" // nota de devolução com TES errada. // .or. sf4->f4_duplic =='N'
			dbSelectArea("TRA5")
			dbSkip()
			Loop
		EndIf
		if _m 
			@ li,009 PSAY " D e v o l u c o e s"
			li := li + 1
			_m :=.f.
      endif
		
		dDatEmis := CtoD(SubStr(TRA5->D1_EMISSAO,7,2)+"/"+SubStr(TRA5->D1_EMISSAO,5,2)+"/"+SubStr(TRA5->D1_EMISSAO,3,2))
		@ li,009 PSAY dDatEmis
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+tra5->d1_FORNECE+tra5->d1_LOJA)
		@ li,018 PSAY substr(SA1->A1_NOME,1,28)  Picture "@!"
		@ li,048 PSAY tra5->d1_doc
		@ li,056 PSAY tra5->d1_nfori+tra5->d1_seriori
		@ li,079 PSAY if(mv_par05==3,tra5->d1_QUANT/2,tra5->d1_QUANT) Picture "@E 999,999,999.99"
		li := li + 1
		If li >= 61
			ImpCabec()
		EndIf
		_ndev += if(mv_par05==3,tra5->d1_QUANT/2,tra5->d1_QUANT)
		dbSelectArea("tra5")
		dbSkip()
	EndDo   
	if _ndev > 0
		@ li,000 PSAY "T o t a l  D e v o l u c a o --->"
		@ li,066 PSAY _ndev Picture "@E 999,999,999.99"
		li := li + 1
		ntot += _ndev
	endif	
EndIf


if mv_par04<>1
	If cTotPrin == 1
		@ li,000 PSAY "T O T A L  G E R A L  D E  S A I D A S --->"
//		@ li,079 PSAY nTot Picture "@E 999,999,999.99"
		@ li,066 PSAY (nTotRes+nTotbon + nTotVen + _ndev) Picture "@E 999,999,999.99"
		li := li + 1
		
	EndIf
endif
dbSelectArea("TRA1")
dbCloseArea("TRA1")
dbSelectArea("TRA2")
dbCloseArea("TRA2")
dbSelectArea("TRA3")
dbCloseArea("TRA3")
dbSelectArea("TRA4")
dbCloseArea("TRA4")
dbSelectArea("TRA5")
dbCloseArea("TRA5")
Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnRel)
EndIf
ms_Flush()
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa  ³ IMPCABEC  ³Autor ³ Gardenia Ilany       ³Data ³ 31/03/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                        ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 6.09 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/04/02 ==> Function ImpCabec

Static Function ImpCabec()
m_Pag := m_Pag + 1
@ 00,001 PSAY "VITAMEDIC INDUSTRIA FARMACEUTICA LTDA"
@ 01,000 PSAY "Controle de Estoque de Produtos Acabados"
@ 01,106 PSAY "Folha...:"
@ 01,116 PSAY StrZero(m_Pag,4)
@ 02,000 PSAY "Ficha do Lote"
@ 03,000 PSAY "Produto.................: "

// buscando a descricao do produto
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+mv_par01)
@ 03,026 PSAY Alltrim(mv_par01)+"-"+SB1->B1_DESC Picture "@!"
@ 04,000 PSAY "Lote....................: "+mv_par02

IF mv_par04 <> 1  // SOMENTE SAIDAS
	// Buscando a ordem de producao
	dbSelectArea("SC2")
	_cfilsc2:=xfilial("SC2")
	_cfilsb8:=xfilial("SB8")
	_cindsc2 :=criatrab(,.f.)
	_cchave :="C2_FILIAL+c2_PRODUTO+C2_LOTECTL"
	sc2->(indregua("SC2 ",_cindsc2,_cchave))
	sc2->(dbseek(_cfilsc2+mv_par01+mv_par02))
	dbSelectArea("SB8")
	dbSetOrder(3)
	//dbSeek(xFilial("SB8")+mv_par01+"01"+mv_par02)
	set softseek  on
	sb8->(dbseek(_cfilsb8+mv_par01+"01"+mv_par02))
	set softseek off
	_qtdlote :=0                   
	_nempenho :=0
	_saldo :=0
	while sb8->(!eof()) .and.  substr(mv_par01,1,6)==substr(sb8->b8_produto,1,6) .and. substr(sb8->b8_lotectl,1,6)==substr(mv_par02,1,6)
		_saldo:= SB8->B8_SALDO - SB8->B8_EMPENHO
		if _saldo < 0
			_saldo :=0
		endif
		_qtdlote += _saldo
		_nempenho += SB8->B8_EMPENHO
		dbskip()
	end	
	//dbSeek(xFilial("SC2")+mv_par01+mv_par02)
	set softseek  on
	sb8->(dbseek(_cfilsb8+mv_par01+"01"+mv_par02))
	set softseek off

	@ 05,000 PSAY "Inicio da Producao......: "
	@ 05,027 PSAY DtoC(SC2->C2_DATPRI)
	@ 05,060 PSAY "Validade: "
	@ 05,070 PSAY DtoC(SB8->B8_DTVALID)
	@ 06,000 PSAY "Final da Producao.......: "
	@ 06,027 PSAY DtoC(SC2->C2_DATRF)
	@ 06,060 PSAY "Tp: "+str(mv_par05)
	@ 07,000 PSAY "Quantidade Prevista.....:"
	@ 07,027 PSAY if(mv_par05==3,sb1->b1_le,SC2->C2_QUANT) Picture "@E 99999999999"
	@ 08,000 PSAY "Quantidade Produzida....: "
	@ 08,027 PSAY if(mv_par05==3,SC2->C2_QUJE/2,SC2->C2_QUJE) Picture "@E 99999999999"
	@ 09,000 PSAY "Diferenca...............: "
	@ 09,027 PSAY if(mv_par05==3,(SC2->C2_QUANT - SC2->C2_QUJE)/2,(SC2->C2_QUANT - SC2->C2_QUJE)) Picture "@E 99999999999"
	@ 10,000 PSAY "Quantidade Vendida......: "
	if mv_par05==2
		@ 10,027 PSAY SC2->C2_QUJE-_qtdlote Picture "@E 99999999999"
	else 
		@ 10,027 PSAY if(mv_par05==3,nTotVend/2,nTotVend) Picture "@E 99999999999"	
	endif	
	@ 11,000 PSAY "Quantidade Devolucao....: "
	@ 11,027 PSAY if(mv_par05==3,nTotDev/2,nTotDev)  Picture "@E 99999999999"
	@ 12,000 PSAY "Estoque Atual...........: "
	@ 12,027 PSAY if(mv_par05==3,_qtdlote/2,_qtdlote) Picture "@E 99999999999"
	@ 12,060 PSAY "Empenho :" +transform(if(mv_par05==3,_nempenho/2,_nempenho),"@E 99999999999")
	sc2->(retindex("SC2"))
	ferase(_cindsc2+sc2->(ordbagext()))
endif
if mv_par03 == 1 .and. mv_par04<>1
	@ 13,000 PSAY "-----------------------------------------------------------------------------------------------------------"
	@ 14,000 PSAY "Data     Historico                    Ped/Nf.Dev   N.Fiscal/Nf.Orig   Quantidade Vl.Liq.   Pr.Fab.   Pr.Max"
	@ 15,000 PSAY "-----------------------------------------------------------------------------------------------------------"
	li := 16
elseif mv_par04 == 1
	@ 05,000 PSAY replicate("-",220)
	@ 06,000 PSAY "CNPJ           Cliente                               Data   N.Fiscal   Vl.Liq  Quantidade Endereco "
	@ 07,000 PSAY replicate("-",220)
	li := 08
else
	@ 13,000 PSAY "--------------------------------------------------------------------------------"
	@ 14,000 PSAY "Data     Historico                                                    Quantidade"
	@ 15,000 PSAY "--------------------------------------------------------------------------------"
	li := 16
	
endif
Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa  ³ SELETRAB  ³Autor ³ Gardenia Ilany       ³Data ³ 31/03/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Funcao de Selecionar os Dados para a Gravacao no Arquivo   ³ÛÛ
ÛÛ³          ³ Trabalho                                                   ³ÛÛ   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 6.09 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/04/02 ==> Function SeleTrab
Static Function SeleTrab()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Entradas                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer1:=" SELECT * "
cQuer1+=" FROM "
cQuer1+= retsqlname("SD3")+" SD3"
cQuer1+=" WHERE"
cQuer1+="     SD3.D_E_L_E_T_ =' '"
cQuer1+=" AND D3_FILIAL= '"+xFilial("SD3")+"'"
cQuer1+=" AND D3_CF<>'DE6'"
cQuer1+=" AND D3_TM>='002'"
cQuer1+=" AND D3_TM<='499'"
cQuer1+=" AND D3_TM<>'999'"
cQuer1+=" AND D3_LOCAL in ('01','15')"                                           //Guilherme Teodoro - 17/07/2016 - Contemplar armazem nutraceutico (15) 
cQuer1+=" AND D3_ESTORNO<>'S'"
cQuer1+=" AND D3_COD='"+mv_par01+"'"
cQuer1+=" AND D3_LOTECTL='"+mv_par02+"'"
cQuer1+=" ORDER BY D3_TM, D3_COD, D3_LOTECTL, D3_EMISSAO, D3_DOC"

TCQuery cQuer1 NEW ALIAS "TRA1"
dbSelectArea("TRA1")
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Producoes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer2:=" SELECT * "
cQuer2+=" FROM "
cQuer2+= RetSqlName("SD3")+" SD3"
cQuer2+=" WHERE"
cQuer2+="     SD3.D_E_L_E_T_=' '"
cQuer2+=" AND D3_FILIAL='"+xFilial("SD3")+"'"
cQuer2+=" AND D3_CF='DE6'"
cQuer2+=" AND D3_TM='499'"
cQuer2+=" AND D3_LOCAL in ('01','15')"                                          //Guilherme Teodoro - 17/07/2016 - Contemplar armazem nutraceutico (15)    
cQuer2+=" AND D3_COD='"+mv_par01+"'"
cQuer2+=" AND D3_LOTECTL='"+mv_par02+"'"
cQuer2+=" ORDER BY D3_TM, D3_COD, D3_LOTECTL, D3_EMISSAO, D3_DOC"
TCQuery cQuer2 NEW ALIAS "TRA2"
dbSelectArea("TRA2")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Saida                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer3:=" SELECT * "
cQuer3+=" FROM "
cQuer3+= RetSqlName("SC9")+" SC9"
cQuer3+=" WHERE"
cQuer3+="     SC9.D_E_L_E_T_=' '"
cQuer3+=" AND C9_FILIAL='"+xFilial("SC9")+"'"
cQuer3+=" AND C9_LOCAL  in ('01','15')"                                        //Guilherme Teodoro - 17/07/2016 - Contemplar armazem nutraceutico (15)
cQuer3+=" AND C9_PRODUTO='"+mv_par01+"'"
cQuer3+=" AND C9_LOTECTL='"+mv_par02+"'"
cQuer3+=" AND C9_SERIENF='R'"
cQuer3+=" ORDER BY C9_PRODUTO,C9_DATALIB,C9_CLIENTE,C9_LOJA"

TCQuery cQuer3 NEW ALIAS "TRA3"
dbSelectArea("TRA3")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Vendas                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer4:=" SELECT * "
cQuer4+=" FROM "
cQuer4+= RetSqlName("SD2")+" SD2"
cQuer4+=" WHERE"
cQuer4+="     SD2.D_E_L_E_T_=' '"
cQuer4+=" AND D2_FILIAL='"+xFilial("SD2")+"'"
cQuer4+=" AND D2_LOCAL in ('01','15')"                                        //Guilherme Teodoro - 17/07/2016 - Contemplar armazem nutraceutico (15)
cQuer4+=" AND D2_COD='"+mv_par01+"'"
cQuer4+=" AND D2_LOTECTL='"+mv_par02+"'"  
//cQuer4+=" AND D2_EST='PA'"
cQuer4+=" ORDER BY D2_COD"
TCQuery cQuer4 NEW ALIAS "TRA4"
_cfilsf4:=xfilial("SF4")
sf4->(dbsetorder(1))
dbSelectArea("TRA4")
dbGoTop()
Do While !Eof()
	sf4->(dbseek(_cfilsf4+tra4->d2_tes))
	If sf4->f4_estoque =='N' // .or. sf4->f4_duplic =='N'
		dbSelectArea("TRA4")
		dbSkip()
		Loop
	EndIf
	nTotVend += TRA4->D2_QUANT-TRA4->D2_QTDEDEV
	dbSelectArea("TRA4")
	dbSkip()
EndDo
dbSelectArea("TRA4")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Devolução                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuer5:=" SELECT * "
cQuer5+=" FROM "
cQuer5+= RetSqlName("SD1")+" SD1"
cQuer5+=" WHERE"
cQuer5+="     SD1.D_E_L_E_T_=' '"
cQuer5+=" AND D1_FILIAL='"+xFilial("SD1")+"'"
cQuer5+=" AND D1_LOCAL='93'"
cQuer5+=" AND D1_COD='"+mv_par01+"'"
cQuer5+=" AND D1_LOTECTL='"+mv_par02+"'"
cQuer5+=" ORDER BY D1_COD"
TCQuery cQuer5 NEW ALIAS "TRA5"
_cfilsf4:=xfilial("SF4")
sf4->(dbsetorder(1))

dbSelectArea("TRA5")
dbGoTop()
Do While !Eof()
	sf4->(dbseek(_cfilsf4+tra5->d1_tes))
	If sf4->f4_estoque =='N' // .or. sf4->f4_duplic =='N'
		dbSelectArea("TRA5")
		dbSkip()
		Loop
	EndIf
	nTotDev := nTotdev + TRA5->D1_QUANT
	dbSelectArea("TRA5")
	dbSkip()
EndDo
dbSelectArea("TRA5")
dbGoTop()
Return


Static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Do Lote            ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Coluna de notas    ?","mv_ch3","N",01,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Somente saidas     ?","mv_ch4","N",08,0,0,"C",space(60),"mv_par04"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Tipo Rel.          ?","mv_ch5","N",15,0,0,"C",space(60),"mv_par05"       ,"1-OPFirme"      ,space(30),space(15),"2-OPPrev(*+)"   ,space(30),space(15),"3-OPPrev(*/)"   ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
