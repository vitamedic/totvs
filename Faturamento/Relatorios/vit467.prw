#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"
#include 'topconn.ch'
#include "TbiCode.ch"

//+--------------------------------------------------------------------+
//| Rotina | VERBAXCC | Autor | STEPHEN NOEL | Data | 15/01/2019 	   |
//+--------------------------------------------------------------------+
//| Descr. | Relatorio de Faturamento x periodo                  		   |
//+--------------------------------------------------------------------+
//| Uso | vitamedic/Inteligencia de Mercado                            |
//+--------------------------------------------------------------------+

User Function vit467()

	Private oExcel := FWMSEXCEL():New()
	Private cArquivo  := "vit467.XLS"
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

	Processa({||GERAEXCEL()}, "Gerando Relatório", "Aguarde...")
Return


Static Function GERAEXCEL()

	Local subtotal := 0

	oExcel:AddworkSheet("fat.periodo")
	oExcel:AddTable ("fat.periodo","Faturamento por Periodo")

	aadd(_verba, "cod")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","PRODUTO",1,1,.f.)
	aadd(_verba, "desc")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","DESCRIÇÃO",1,1,.f.)
	aadd(_verba, "quant")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","QUANTIDADE",1,2,.f.)
	aadd(_verba, "preco")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","PRECO",1,3,.f.)
	aadd(_verba, "total")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","TOTAL",1,3,.t.)
	aadd(_verba, "pedido")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","PEDIDO",1,1,.f.)
	aadd(_verba, "cliente")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","COD. CLIENTE",1,1,.f.)
	aadd(_verba, "nomecli")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","NOME CLIENTE",1,1,.f.)
	aadd(_verba, "est")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","ESTADO",1,1,.f.)
	aadd(_verba, "codrca")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","COD. RCA",1,1,.f.)
	aadd(_verba, "nomerca")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","NOME RCA",1,1,.f.)
	aadd(_verba, "gerente")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","COD.GERENTE",1,1,.f.)
	aadd(_verba, "codger")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","NOME GERENTE",1,1,.f.)
	aadd(_verba, "ANO")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","ANO",1,1,.f.)
	aadd(_verba, "MES")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","MES",1,1,.f.)
	aadd(_verba, "EMISSAO")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","EMISSAO",1,1,.f.)
	aadd(_verba, "LINHA")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","LINHA",1,1,.f.)
	aadd(_verba, "codrca2")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","COD.RCA ATUAL",1,1,.f.)
	aadd(_verba, "nomerca2")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","NOME RCA NOVO",1,1,.f.)
	aadd(_verba, "gerente2")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","COD.GERENTE ATUAL",1,1,.f.)
	aadd(_verba, "codger2")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","NOME GERENTE ATUAL",1,1,.f.)
	aadd(_verba, "condpag")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","COND.PAG",1,1,.f.)
	aadd(_verba, "condpa2")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","DESCRICAO COND. PAG",1,1,.f.)
	aadd(_verba, "tipo")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","TIPO",1,1,.f.)
	aadd(_verba, "tes")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","TES",1,1,.f.)
	aadd(_verba, "desctes")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","DESC TES",1,1,.f.)
	aadd(_verba, "LOTE")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","LOTE",1,1,.f.)
	aadd(_verba, "Pocket")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","PED. POCKET",1,1,.f.)
	aadd(_verba, "MSGPED")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","MARG PEDIDO",1,1,.f.)
	aadd(_verba, "MSGNOTA")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","MARG PRODUTO",1,1,.f.)
	aadd(_verba, "COMISS")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","COMISSAO",1,2,.f.)
	aadd(_verba, "cfop")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","CFOP",1,1,.f.)
	aadd(_verba, "desccf")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","DESC CFOP",1,1,.f.)
	aadd(_verba, "NFISCAL")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","NOTA FISCAL",1,1,.f.)
	aadd(_verba, "SERIE")
	oExcel:AddColumn("fat.periodo","Faturamento por Periodo","SERIE",1,1,.f.)

	criatmp1()
	dbSelectArea("TMP1")
	TMP1->(DbGotop())
	While TMP1->(!EOF())
		//	ITEM	PRODUTO	DESCRICAO	QUANTIDADE	PRECO	TOTAL	PEDIDO	TIPO	EMISSAO	COD_RCA	NOME_RCA	GERENTE	MARGEM_PED CLIENTE	DESC_CLI DIVISAO COMISSAO

		oExcel:AddRow("fat.periodo","Faturamento por Periodo",; 
		{TMP1->COD,; 
		TMP1->DESCRI,; 
		TMP1->QUANT,; 
		TMP1->PRECO,; 
		TMP1->TOTAL,;
		TMP1->PEDIDO,; 
		TMP1->CLIENTE,;
		TMP1->DESCCLI,; 
		TMP1->UF,; 
		TMP1->RCA,; 
		TMP1->NOMERCA,;
		TMP1->GERENTE,;
		TMP1->NGERENTE,;
		TMP1->ANO,;
		TMP1->MES,;
		TMP1->EMISSAO,;
		TMP1->LINHA,;
		TMP1->CODATU,;
		TMP1->RCAATU,;
		TMP1->GERNOVO,;
		TMP1->NGERATU,;
		TMP1->CONDPAG,;
		TMP1->DESCOND,;
		TMP1->TIPO,;
		TMP1->TES,;
		TMP1->DESCTES,;
		TMP1->LOTE,;
		TMP1->POCKET,;
		TMP1->MGPED,;
		TMP1->MGPROD,;
		TMP1->COMISSAO,;
		TMP1->CFOP,;
		TMP1->DESCCFOP,;
		TMP1->NOTA,;
		TMP1->SERIE})
		TMP1->(DbSkip())
	End
	oExcel:Activate()
	oExcel:GetXMLFile(cArquivo)
	CpyS2T("\SYSTEM\"+cArquivo, cPath)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
	oExcelApp:SetVisible(.T.)
	TMP1->(DbCloseArea())

Return

//*******************************************************************************************************************************************
static function criatmp1()
	//*******************************************************************************************************************************************

	mv_par01:= substr(DtoS(mv_par01),1,4)+ substr(DtoS(mv_par01),5,2)+ substr(DtoS(mv_par01),7,2) 
	mv_par02:= substr(Dtos(mv_par02),1,4)+ substr(DtoS(mv_par02),5,2)+ substr(DtoS(mv_par02),7,2)

	_cquery := " SELECT "
	_cquery += " D2_COD COD, B1_DESC DESCRI, SD2.D2_QUANT QUANT, SD2.D2_PRCVEN PRECO, D2_TOTAL TOTAL, "
	_cquery += " SD2.D2_PEDIDO PEDIDO, SD2.D2_CLIENTE||SD2.D2_LOJA CLIENTE, A1_NOME DESCCLI, D2_DOC NOTA, " 
	_cquery += " SA1.A1_EST UF, SF2.F2_VEND1 RCA, SA3.A3_NREDUZ NOMERCA, SA3.A3_SUPER GERENTE, D2_SERIE SERIE, "
	_cquery += " (SELECT SA33.A3_NREDUZ FROM SA3010 SA33 WHERE SA33.A3_COD = SA3.A3_SUPER AND SA33.D_E_L_E_T_ = ' ') NGERENTE, "
	_cquery += " SUBSTR(D2_EMISSAO,1,4) ANO, SUBSTR(D2_EMISSAO,5,2) MES, "
	_cquery += " SUBSTR(D2_EMISSAO,7,2)||'/'||SUBSTR(D2_EMISSAO,5,2)||'/'||SUBSTR(D2_EMISSAO,1,4) EMISSAO, "
	_cquery += " CASE " 
	_cquery += " SB1.B1_APREVEN WHEN '1' THEN 'FAMILIAR' " 
	_cquery += " WHEN '2' THEN 'HOSPITALAR' "
	_cquery += " WHEN ' ' THEN 'SEM DIV' "
	_cquery += " END LINHA, "
	_cquery += " SA34.A3_COD CODATU, "
	_cquery += " SA34.A3_NREDUZ RCAATU, "
	_cquery += " SA34.A3_SUPER GERNOVO, "
	_cquery += " (SELECT SA3.A3_NREDUZ FROM SA3010 SA3 WHERE SA3.A3_COD = SA34.A3_SUPER AND SA34.D_E_L_E_T_ = ' ') NGERATU, "
	_cquery += " SF2.F2_COND CONDPAG, "
	_cquery += " SE4.E4_COND DESCOND, "
	_cquery += " SD2.D2_TP TIPO, "
	_cquery += " SD2.D2_TES TES, "
	_cquery += " SF4.F4_DESC DESCTES, "
	_cquery += " SD2.D2_LOTECTL LOTE, "
	_cquery += " SC5.C5_POCKET POCKET, "
	_cquery += " SC5.C5_MARGEM MGPED, "
	_cquery += " ROUND((((SD2.D2_TOTAL - SD2.D2_VALPIS - SD2.D2_VALCOF - (D2_TOTAL * 0.12) - (SD2.D2_QUANT * SB1.B1_VLRCOMP ))) "
	_cquery += " /(SD2.D2_TOTAL - SD2.D2_VALPIS - SD2.D2_VALCOF - (D2_TOTAL * 0.12)))*100,2)  MGPROD, "
	_cquery += " SD2.D2_COMIS1 COMISSAO, "
	_cquery += " SD2.D2_CF CFOP, "
	_cquery += " SF4.F4_TEXTO DESCCFOP "
	_cquery += " FROM SD2010 SD2 "
	_cquery += " INNER JOIN SB1010 SB1 ON B1_COD = D2_COD "
	_cquery += " INNER JOIN SA1010 SA1 ON A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA "
	_cquery += " INNER JOIN SF2010 SF2 ON SF2.F2_DOC = D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE "
	_cquery += " LEFT JOIN SA3010 SA3 ON SA3.A3_COD = SF2.F2_VEND1 " 
	_cquery += " LEFT JOIN SA3010 SA34 ON SA34.A3_COD = SA1.A1_VEND "
	_cquery += " LEFT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SF2.F2_COND "
	_cquery += " INNER JOIN SF4010 SF4 ON SF4.F4_CODIGO = SD2.D2_TES "
	_cquery += " LEFT JOIN SC5010 SC5 ON SC5.C5_NUM = SD2.D2_PEDIDO "
	_cquery += " WHERE SD2.D_E_L_E_T_ = ' ' "
	_cquery += " AND SC5.D_E_L_E_T_ = ' ' "
	_cquery += " AND SF2.D_E_L_E_T_ = ' ' "
	_cquery += " AND SF4.D_E_L_E_T_ = ' ' "
	_cquery += " AND SF2.F2_TIPO IN ('N','C') "
	_cquery += " AND SD2.D2_EMISSAO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	_cquery += " AND D2_TP IN ('PA','PD','PL','PN','PM') "

	_cquery:=changequery(_cquery)
	TcQuery _cquery New Alias "TMP1"
	memowrite("C:/Stephen/FATEXCEL.txt",_cquery)

Return

//*******************************************************************************************************************************************
Static Function AjustaSX1()

	//Local := _agrpsx1:={}
	cPerg := "dispestoq"

	PutSx1(cPerg,"01","Da data"      ,"Competencia?","Competencia?","mv_ch1","D",08,0,0,"G","","","","S","mv_par01","","","","","","","","","","","","","","","","","",,)
	PutSx1(cPerg,"02","Até data"     ,"Competencia?","Competencia?","mv_ch2","D",08,0,0,"G","","","","S","mv_par02","","","","","","","","","","","","","","","","","",,)


Return

//*******************************************************************************************************************************************

