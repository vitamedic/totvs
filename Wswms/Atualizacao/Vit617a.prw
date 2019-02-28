#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Vit617a   บAutor  ณMicrosiga           บ Data ณ  19/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para importar registros do inventแio.               บฑฑ
ฑฑบ          ณ Execauto MATA270                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vitamedic                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Vit617a()

	Private cPerg := "Vit617a   "

	If !ValidPerg() .or. Empty(mv_Par01) .or. Empty(mv_Par02) .or. Empty(mv_Par03)
		MsgStop("Informe os parโmetros para a importa็ใo de planilha para invetแrio...", "Aten็ใo")
		Return()
	EndIf
	
	If !( ".CSV" $ Upper(mv_Par01) )
		MsgStop("Selecione um arquivo vแlido (extensใo .csv) para a importa็ใo da planilha...", "Aten็ใo")
		Return()
	EndIf
	
	Processa({|lEnd| ImpPlanilha()},"Importando de planilha para invetแrio...")
	
Return()

Static Function ImpPlanilha()
Local lOk       := .t.
Local cDir 		:= Left(mv_par01,RAt("\", mv_par01)-1)
Local cDoc      := Pad(Alltrim(mv_Par03), TamSX3("B7_COD")[1])
Local dDtMov    := mv_Par02
Local cLog		:= ""
Local aDados    := {}
Local aCampos   := {} 

Local nLin, nCtr

Local cError     := ""
Local oLastError := ErrorBlock({|e| cError := e:Description + e:ErrorStack})

Private lMsErroAuto := .F.

UDadosImp(mv_Par01, @aDados, @aCampos, /*lComCabec*/ )

If Len( aDados ) == 0
	MsgStop("Nใo existe informa็ใo no arquivo para a importa็ใo do cadastro...", "Aten็ใo")
	Return()
EndIf

nPosPrd  := AScan(aCampos, {|x| alltrim(x) == "PRODUTO"})
nPosArm  := AScan(aCampos, {|x| alltrim(x) == "ARMAZEM"})
nPosEnd  := AScan(aCampos, {|x| alltrim(x) == "ENDERECO"})
nPosLote := AScan(aCampos, {|x| alltrim(x) == "LOTE"})
nPosQtde := AScan(aCampos, {|x| alltrim(x) == "QUANTIDADE"})
nPosAcao := AScan(aCampos, {|x| alltrim(x) == "ACAO"})
nPosData := AScan(aCampos, {|x| alltrim(x) == "DATA"})

if nPosPrd == 0
	msgStop("Nใo achou a coluna dos produtos...")
	return
elseif nPosArm == 0
		msgStop("Nใo achou a coluna dos armazens...")
		return
elseif nPosQtde == 0
		msgStop("Nใo achou a coluna de quantidade...")
		return
endif

processa({|| Len(aDados) })                                                      

BeginTran()

ProcRegua(Len(aDados))

cLog := "Erros gerados na importa็ใo"    

For nLin := 1 to Len(aDados)
	cLinErr  := CRLF + "Erro Linha: " + StrZero(nLin, 5) +": "
	cProd    := PadL(Alltrim(aDados[nLin][nPosPrd]), 6 /*TamSX3("B7_COD")[1]*/, '0')
	cArmaz   := PadL(Alltrim(aDados[nLin][nPosArm]), TamSX3("B7_LOCAL")[1], '0')
	nQtde    := Iif(mv_Par04==2, 0, Val(Strtran(Strtran(aDados[nLin][nPosQtde],".", ""),",", ".")))
	
	if nPosLote > 0
		cLote    := Alltrim(aDados[nLin][nPosLote])
		cLote    := Pad(iif(len(alltrim(cLote)) < 6 .and. !empty(cLote), "0"+cLote, cLote), TamSX3("B7_LOTECTL")[1])
	else
		cLote    := Space(TamSX3("B7_LOTECTL")[1])
	endif                                        
	
	if nPosEnd > 0
		cEnder   := Pad(Alltrim(aDados[nLin][nPosEnd]), TamSX3("B7_LOCALIZ")[1])
	else            
		cEnder   := Space(TamSX3("B7_LOCALIZ")[1])
	endif
	
	IncRegua()

	dbSelectArea("SB1")
	dbSetOrder(1)
	if !dbSeek(XFilial("SB1")+cProd)
		cLog += cLinErr + "Produto (" + cProd + ") nใo localizado no cadastro..."
		loop
	elseif SB1->B1_LOCALIZ <> "S"
			cLog += cLinErr + "Produto (" + cProd + ") nใo controla endere็o..."
			loop
	endif

	dbSelectArea("SBE")
	dbSetOrder(1)
	if !dbSeek(XFilial("SBE")+cArmaz+cEnder)
		cLog += cLinErr + "Endere็o (" + cEnder + "), armaz้m ("+cArmaz+") nใo localizado no cadastro..."
		loop
	elseif SBE->BE_MSBLQL <> "2"
			cLog += cLinErr + "Endere็o (" + cEnder + "), armaz้m ("+cArmaz+") bloqueado no cadastro..."
			loop
	endif
	
	IncProc( "Atualizando registros..." )
    
	if nPosAcao <> 0  
		cAcao := Alltrim(aDados[nLin][nPosAcao]) 
		cAcao := "Inv"
	else
		cAcao := "Inv"
	endif

    if cAcao == "Inv"
		aVetor := { {"B7_FILIAL" 	, xFilial("SB7"), Nil},;
		            {"B7_COD"		, cProd			, Nil},;
		            {"B7_DOC"		, cDoc			, Nil},;
		            {"B7_QUANT"		, nQtde			, Nil},;
		            {"B7_LOCAL"		, cArmaz		, Nil},;
		            {"B7_LOTECTL"	, cLote			, Nil},;
		            {"B7_LOCALIZ"	, cEnder		, Nil},;
		            {"B7_DATA"		, dDtMov		, Nil} }
		
		if !( lOk := MyMata270(aVetor, @cLinErr) )
			cLog += cLinErr
		endif
	endif
	
	if cAcao == "SB8SB2"
		if nQtde <> 0
			ProcSD3(cProd, cArmaz, nQtde * (-1))
		endif
	endif
	
	if cAcao == "SBK" .or. cAcao == "SBKSBJ"
		cDtMov := DtoS(dDtMov)
		
		if nPosData > 0
			cDtMov := Alltrim(aDados[nLin][nPosData])
			
			if At("/", cDtMov) > 0
				cDtMov := DtoS(CtoD(cDtMov))
			endif 
		endif
		
    	cQry := " UPDATE " + RetSqlName("SBK") + " SET BK_QINI = 0 , BK_QISEGUM = 0 "
    	cQry += " WHERE BK_FILIAL  = '"+XFilial("SBK")+"'"
    	cQry += "   AND BK_COD     = '"+cProd+"'"
    	cQry += "   AND BK_LOCAL   = '"+cArmaz+"'"
    	cQry += "   AND BK_LOTECTL = '"+cLote+"'"
    	cQry += "   AND BK_LOCALIZ = '"+cEnder+"'"
    	cQry += "   AND BK_DATA    = '"+cData+"'"
	    
		if ( nRet := TCSqlExec(cQry) ) < 0
			cLog += cLinErr + "Tentativa de zerar os saldos residuais na tabela SBK..."
		endif
	endif

	if cAcao == "SBK" .or. cAcao == "SBKSBJ"
		cDtMov := DtoS(dDtMov)
		
		if nPosData > 0
			cDtMov := Alltrim(aDados[nLin][nPosData])
			
			if At("/", cDtMov) > 0
				cDtMov := DtoS(CtoD(cDtMov))
			endif 
		endif
		
    	cQry := " UPDATE " + RetSqlName("SBK") + " SET BK_QINI = 0 , BK_QISEGUM = 0 "
    	cQry += " WHERE BK_FILIAL  = '"+XFilial("SBK")+"'"
    	cQry += "   AND BK_COD     = '"+cProd+"'"
    	cQry += "   AND BK_LOCAL   = '"+cArmaz+"'"
    	cQry += "   AND BK_LOTECTL = '"+cLote+"'"
    	cQry += "   AND BK_LOCALIZ = '"+cEnder+"'"
    	cQry += "   AND BK_DATA    = '"+cData+"'"
	    
		if ( nRet := TCSqlExec(cQry) ) < 0
			cLog += cLinErr + "Tentativa de zerar os saldos residuais na tabela SBK..."
		endif
	endif
	
Next nLin

if lOk
	EndTran()
else
	DisarmTransaction()
endif

MemoWrite("c:\temp\log_inv"+DtoS(dDataBase)+"_"+StrTran(Time(),":")+".log", cLog)

Return()

Static Function ValidPerg()
Local aHelpPor := {}

PutSx1(cPerg,"01",OemToAnsi("Pasta\Arquivo .csv ?"),"","","mv_ch1","C",70,0,0,"G","","","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"02",OemToAnsi("Data do Inventแrio ?"),"","","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"03",OemToAnsi("Doc. do Inventแrio ?"),"","","mv_ch3","C",TamSX3("B7_DOC")[1],0,0,"G","","","","S","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"04",OemToAnsi("Zerar Inventแrio   ?"),"","","mv_ch4","N",01,0,0,"C","","","","S","mv_par04","Sim","","","2","Nใo","","","","","","","","","","","",aHelpPor,{},{})

//"Apaga","","","","Recupera,"","","","","","","","","","")

Return(Pergunte(cPerg,.T.))

/*
Static Function ErrorBlockExample()

Local cError      := ""

Local oLastError := ErrorBlock({|e| cError := e:Description + e:ErrorStack})

Local uTemp        := Nil

uTemp := "A" + 1

ErrorBlock(oLastError)

// Anota o erro no console.

ConOut(cError)
*/

Static Function RetRecno(cAlias, pQry)
Local aArea     := GetArea()
Local cQry 		:= " SELECT Q.R_E_C_N_O_ FROM " + RetSqlName(cAlias) + " Q WHERE Q.D_E_L_E_T_ = ' ' AND " + pQry
Local nRecno 	:= 0

if select("QREC") > 0
	dbSelectArea("QREC")
	dbCloseArea()
endif

TCQuery cQry New Alias "QREC"

if QREC->(!Eof())
	nRecno := QREC->R_E_C_N_O_
endif
                              
QREC->(dbCloseArea())       

RestArea(aArea)

Return(nRecno)

 
Static Function MyMata270(aVetor, cMsgErr)
Local lRet  := .t.
Local cErro := ""

PRIVATE lMsErroAuto := .F.

Default aVetor := {}

if len(aVetor) == 0
	return(.f.)
endif          

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// Abertura do ambiente
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ConOut(Repl("-",80))
ConOut(PadC(OemToAnsi("Teste de Inclusao MATA270"),80))
/*
PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'Administrador' PASSWORD '' MODULO "EST" TABLES "SB7"
		aVetor := { {"B7_FILIAL" 	, xFilial("SB7"), Nil},;
		            {"B7_COD"		, cProd			, Nil},;
		            {"B7_DOC"		, cDoc			, Nil},;
		            {"B7_QUANT"		, nQtde			, Nil},;
		            {"B7_LOCAL"		, cArmaz		, Nil},;
		            {"B7_LOTECTL"	, cLote			, Nil},;
		            {"B7_LOCALIZ"	, cEnder		, Nil},;
		            {"B7_DATA"		, dDtMov		, Nil} }

*/
dbSelectArea("SB7")
dbSetOrder(2)
//B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+B7_CONTAGE

nOpc := Iif(dbSeek(XFilial("SB7")+DtoS(aVetor[1,7])+aVetor[1,2]+aVetor[1,5]+aVetor[1,7]+Space(TamSX3("B7_NUMSERI")[1])+aVetor[1,6]+Space(TamSX3("B7_NUMLOTE")[1])), 4, 3)

MSExecAuto({|x,y,z| mata270(x,y,z)},aVetor,.T.,nOpc)
If lMsErroAuto   
	cErro := MostraErro("\temp")
	cErro := StrTran(cErro, "<","|")
	cErro := StrTran(cErro, ">","|")
	
	cMsgErr += cErro
	lRet 	:= .f.

    ConOut(OemToAnsi("Erro!"))
Else
    ConOut(OemToAnsi("Atualiza็ใo realizada com ๊xito!"))
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcSD3(cProd, cAlmox, nQuant, cLoteCtl)
Local aArSB8     := SB8->(GetArea())
Local lRet       := .T.
Local cDtValid   := CtoD('  /  /  ')
Local cNumLote   := Space(TamSX3("D3_NUMLOTE")[1])

Default cLoteCtl := Space(TamSX3("D3_LOTECTL")[1])

if !empty(cLoteCtl)
	dbSelectArea('SB8')
	dbSetOrder(3) //-- B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	If MsSeek(xFilial('SB8')+cProd+cAlmox+cLoteCtl+cNumLote, .F.)
		cDtValid := SB8->B8_DTVALID
	EndIf
	RestArea(aArSB8)
endif

RecLock('SD3',.T.)
Replace D3_FILIAL  With xFilial('SD3')
Replace D3_COD     With cProd
Replace D3_QUANT   With Abs(QtdComp(nQuant))
Replace D3_CF      With If(QtdComp(nQuant)<QtdComp(0),'RE0','DE0')
Replace D3_CHAVE   With If(QtdComp(nQuant)<QtdComp(0),'E0','E9')
Replace D3_LOCAL   With cAlmox
Replace D3_DOC     With 'EQUALIZA'
Replace D3_EMISSAO With dDataBase
Replace D3_UM      With SB1->B1_UM
Replace D3_GRUPO   With SB1->B1_GRUPO
Replace D3_NUMSEQ  With ProxNum()
Replace D3_QTSEGUM With ConvUm(cProd,Abs(QtdComp(nQuant)),0,2)
Replace D3_SEGUM   With SB1->B1_SEGUM
Replace D3_TM      With If(QtdComp(nQuant)<QtdComp(0),'999','499')
Replace D3_TIPO    With SB1->B1_TIPO
Replace D3_CONTA   With SB1->B1_CONTA
Replace D3_USUARIO With SubStr(cUsuario,7,15)
Replace D3_LOTECTL With cLoteCtl
Replace D3_LOCALIZ With ''
Replace D3_IDENT   With ''
Replace D3_DTVALID With cDtValid
MsUnLock()

Return(lRet)

Static Function UDadosImp(pArquivo, aDados, aCampos, lComCabec)

Local cLinha  := ""

Private aErro := {}

Default aCampos 	:= {}  //Campos da tabela, se for integrar a leitura do arquivo com o dicionแrio de dados.
Default aDados  	:= {}  //Dados a ser gravado na tabela.
Default lComCabec   := .T. //Primeira linha para nome dos campos.

If !File(pArquivo)
	MsgStop("O arquivo " + pArquivo + " nใo foi encontrado. A importa็ใo serแ abortada!","Aten็ใo")
	Return
EndIf

FT_FUSE(pArquivo)

ProcRegua(FT_FLASTREC())

FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo...")
	
	cLinha := FT_FREADLN()
	
	If lComCabec
		aCampos   := Separa(cLinha,";",.T.)
		lComCabec := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	
	FT_FSKIP()
EndDo

FT_FUSE()

Return(aDados)