#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"
#include 'topconn.ch'
#include "TbiCode.ch"

user function vit466()
	
	Private oExcel := FWMSEXCEL():New()
	Private cArquivo  := "AuditoriaCT2.XLS"
	Private oExcelApp := Nil
	Private cPath     := "C:\WINDOWS\TEMP\"
	Private _verba:= {}
	Private cPerg := "dispestoq"


	AjustaSx1()
	pergunte(cPerg,.T.) //Chama a tela de parametros

	If !ApOleClient('MsExcel')
		MsgAlert("É necessário instalar o excel antes de exportar este relatório.")
		Return
	EndIf
	
	mv_par01:= DtoS(mv_par01) 
	mv_par02:= Dtos(mv_par02)

	Processa({||GERAREL()}, "Gerando Relatório", "Aguarde...")
Return

Static Function GERAREL()
	Local _data
	Local _nome1
	Local _nome2
	Local ndias1
	Local ndias2
	Local cNovaStr
	Local dNovaStr
	Local dData1
	Local dData2
	Local deletado
	oExcel:AddworkSheet("audit")
	oExcel:AddTable ("audit","Auditoria Contabilizacao")
	aadd(_verba, "lcto")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","DATA LCTO",1,4,.f.)
	aadd(_verba, "nlote")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","NUMERO LOTE",1,1,.f.)
	aadd(_verba, "slote")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","SUB LOTE",1,1,.f.)
	aadd(_verba, "ndoc")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","NUMERO DOC",1,1,.f.)
	aadd(_verba, "nlinha")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","NUMERO LINHA",1,1,.f.)
	aadd(_verba, "tlcto")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","TIPO LCTO",1,1,.f.)
	aadd(_verba, "debito")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","CTA DEBITO",1,1,.f.)
	aadd(_verba, "credit")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","CTA CREDITO",1,1,.f.)
	aadd(_verba, "valor")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","VALOR",1,3,.f.)
	aadd(_verba, "hist")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","HIST LANC",1,1,.f.)
	aadd(_verba, "cdebito")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","C CUSTO DEB",1,1,.f.)
	aadd(_verba, "ccredito")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","C CUSTO CRD",1,1,.f.)
	aadd(_verba, "sequen")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","SEQ CTK",1,1,.f.)
	aadd(_verba, "manual")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","LCTO MANUAL?",1,1,.f.)
	aadd(_verba, "origi")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","ORIGEM",1,1,.f.)
	aadd(_verba, "rot")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","ROTINA",1,1,.f.)
	aadd(_verba, "item")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","INCLUSÃO",1,1,.f.)
	aadd(_verba, "cod")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","ALTERAÇÃO",1,1,.f.)
	aadd(_verba, "datai")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","DT INCLUSÃO",1,4,.f.)
	aadd(_verba, "datai")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","DT ALTERAÇÃO",1,4,.f.)
	aadd(_verba, "delet")
	oExcel:AddColumn("audit","Auditoria Contabilizacao","DELETADO",1,1,.f.)
	
	dbSelectArea("CT2")
	CT2->(DbSetOrder(1))
	CT2->(dBseek("01"+ mv_par01))
	While CT2->(!EOF()) 
	if DtoS(CT2->CT2_data) <= mv_par02
		_Nome1:= USRFULLNAME(SUBSTR(EMBARALHA(ct2->CT2_USERGI,1),3,6))
		_Nome2:= USRFULLNAME(SUBSTR(EMBARALHA(ct2->CT2_USERGA,1),3,6))
		cNovaStr := Embaralha(ct2->CT2_USERGI, 1)
		dNovaStr := Embaralha(ct2->CT2_USERGA, 1)
		nDias1 := Load2in4(SubStr(cNovaStr,16))
		nDias2 := Load2in4(SubStr(dNovaStr,16))
		dData1 := CtoD("01/01/96","DDMMYY") + nDias1
		dData2 := CtoD("01/01/96","DDMMYY") + nDias2
		deletado:= IIF(DELETED(),"SIM","NAO")
		
		oExcel:AddRow("audit","Auditoria Contabilizacao",; 
		{CT2_DATA,CT2_LOTE, CT2_SBLOTE,CT2_DOC, CT2_LINHA,; 
		CT2_DC,CT2_DEBITO,CT2_CREDIT,ct2_valor,CT2_HIST,CT2_CCD,;
		CT2_CCC,CT2_SEQUEN, CT2_MANUAL,CT2_ORIGEM, CT2_ROTINA,;
		_nome1,_nome2,dData1,dData1,deletado})
	EndIf
	CT2->(DbSkip())
	End
	oExcel:Activate()
	oExcel:GetXMLFile(cArquivo)
	CpyS2T("\SYSTEM\"+cArquivo, cPath)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
	oExcelApp:SetVisible(.T.)
	CT2->(DbCloseArea())

Return

//*******************************************************************************************************************************************
Static Function AjustaSX1()

	//Local := _agrpsx1:={}
	cPerg := "dispestoq"

	PutSx1(cPerg,"01","Da data"      ,"Competencia?","Competencia?","mv_ch1","D",08,0,0,"G","","","","S","mv_par01","","","","","","","","","","","","","","","","","",,)
	PutSx1(cPerg,"02","Até data"     ,"Competencia?","Competencia?","mv_ch2","D",08,0,0,"G","","","","S","mv_par02","","","","","","","","","","","","","","","","","",,)


Return