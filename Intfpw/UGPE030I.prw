#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"

#include "Fileio.ch"

#define F_BLOCK  512

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UGPE030I º Autor ³ Henrique Corrêa 	  º Data³ 01/02/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação de Cadastro de Funções    			      	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UGPE030I()

	Private cPerg := "UGPE030I  "
	
	Public Inclui := .f.

	If !ValidPerg() .or. Empty(mv_Par01)
		MsgStop("Informe os parâmetros para a importação do cadastro...", "Atenção")
		Return()
	EndIf
	
	If !( ".CSV" $ Upper(mv_Par01) )
		MsgStop("Selecione um arquivo válido (extensão .csv) para a importação do cadastro...", "Atenção")
		Return()
	EndIf
	
	Processa({|lEnd| ImpForn()},"Importando cadastro de Fornecedores...")
	
Return()

Static Function ValidPerg()
Local aHelpPor := {"Selecione o arquivo que deseja importar/atualizar", "será gerado um arquivo de log erros", "no fim da importação com as funções", "não importadas/atualizadas."}

PutSx1(cPerg,"01",OemToAnsi("Pasta\Arquivo .csv ?"),"","","mv_ch1","C",70,0,0,"G","","SELCSV","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})

Return(Pergunte(cPerg,.T.))

Static Function ImpForn()
Local aCPOs 	:= {}
Local nOpc 		:= 3
Local cDir 		:= Left(mv_par01,RAt("\", mv_par01)-1)
Local cLog		:= ""
Local aDados    := {}
Local aCampos   := {} 
Local cSeqLog   := "A" //Sequencia do arquivo de log
Local nLin, nCtr, aLog, nY

Local cCod      := ""
Local cDesc     := ""

Private lMsErroAuto := .F. // variável de controle interno da rotina automatica que informa se houve erro durante o processamento
Private lMsHelpAuto	:= .T. // variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
Private lAutoErrNoFile := .T. // força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário

u_UDadosImp(mv_Par01, @aDados, /*@aCampos*/, /*lComCabec*/ )

If Len( aDados ) == 0
	MsgStop("Não existe informação no arquivo para a importação do cadastro...", "Atenção")
	Return()
EndIf

For nLin := 1 to Len(aDados)
	Inclui 	:= .f.
	cLinErr := "Erro Linha: " + StrZero(nLin,5) +": "
	
	If Len(aDados[nLin]) <> 2
		cLog += cLinErr + "Número de colunas diferente do Layout;" + CRLF
		Loop
	EndIf
	
	cCod  := AllTrim(aDados[nLin][1])
	cDesc := AllTrim(Pad(aDados[nLin][2], TamSX3("RJ_DESC")[1]))
	
	If Empty( cCod )
		cLog += cLinErr + "Código não informado (Campo Obrigatório);" + CRLF
		Loop
	ElseIf Empty( cDesc )
		cLog += cLinErr + "Descrição da Função não informada (Campo Obrigatório);" + CRLF
		Loop
	EndIf
	
	BeginTran()
		dbSelectArea("SRJ")
		dbSetOrder(1)
		
        //Se existir um registro correspondente os dados serão alterados.
		lExiste := MsSeek(XFilial("SRJ")+cCod)			
		If SRJ->(RecLock("SRJ", !lExiste))
			SRJ->RJ_FILIAL 	:= XFilial("SRJ")
			SRJ->RJ_FUNCAO 	:= cCod
			SRJ->RJ_DESC 	:= cDesc
			SRJ->(MsUnlock())
		EndIf
		
	EndTran()                                                   

Next nLin
	
MemoWrite(cDir + "\importação_funcoes"+cSeqLog+".log", cLog)

MsgAlert("Funções importadas com sucesso!!!", "Atenção")

Return()

User Function SELDIR(cMascara)

Local cDir := ""        

Local XX_SELDIR := SuperGetMV("XX_SELDIR", .F., "c:\")

Default cMascara := ""

	cDir := cGetFile( cMascara, 'Selecione o diretório\Arquivo', 1, XX_SELDIR, .T., GETF_LOCALHARD ,.T., .T. )
	
	PutMV("XX_SELDIR", cDir)
	
Return(.T.)

User Function UDadosImp(pArquivo, aDados, aCampos, lComCabec)

Local cLinha  := ""

Private aErro := {}

Default aCampos 	:= {}  //Campos da tabela, se for integrar a leitura do arquivo com o dicionário de dados.
Default aDados  	:= {}  //Dados a ser gravado na tabela.
Default lComCabec   := .F. //Primeira linha para nome dos campos.

If !File(pArquivo)
	MsgStop("O arquivo " + pArquivo + " não foi encontrado. A importação será abortada!","Atenção")
	Return
EndIf

FT_FUSE(pArquivo)

ProcRegua(FT_FLASTREC())

FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo...")
	
	cLinha := FT_FREADLN()
	cLinha := FwNoAccent(UPPER(cLinha))
	
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

Static Function Exporta()

LOCAL cBuffer  := SPACE(F_BLOCK)

LOCAL nInfile    := FOPEN("Temp.txt", FO_READ)

LOCAL nOutfile := FCREATE("Newfile.txt", FC_NORMAL)

LOCAL lDone    := .F.

LOCAL nBytesR := 0

WHILE !lDone

        nBytesR := FREAD(nInfile, @cBuffer, F_BLOCK)

 

        IF FWRITE(nOutfile, cBuffer, nBytesR) < nBytesR

                    MsgAlert("Erro de gravação: " + STR(FERROR()))

 

                    lDone := .T.

        ELSE

                    lDone := (nBytesRead == 0)

        ENDIF

ENDDO

FCLOSE(nInfile)

FCLOSE(nOutfile)

RETURN NIL