#INCLUDE "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"
#include 'topconn.ch'
#include "TbiCode.ch"

//+--------------------------------------------------------------------+
//| Rotina | VERBAXCC | Autor | STEPHEN NOEL | Data | 15/01/2019 	   |
//+--------------------------------------------------------------------+
//| Descr. | Relatorio de Pedidos x periodo                  		   |
//+--------------------------------------------------------------------+
//| Uso | vitamedic/Inteligencia de Mercado                            |
//+--------------------------------------------------------------------+

User Function vit465()

	Private oExcel := FWMSEXCEL():New()
	Private cArquivo  := "vit465.XLS"
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

	oExcel:AddworkSheet("ped.periodo")
	oExcel:AddTable ("ped.periodo","Pedidos por Periodo")

	aadd(_verba, "item")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","ITEM",1,1,.f.)
	aadd(_verba, "cod")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","PRODUTO",1,1,.f.)
	aadd(_verba, "desc")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","DESCRIÇÃO",1,1,.f.)
	aadd(_verba, "quant")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","QUANTIDADE",1,2,.f.)
	aadd(_verba, "preco")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","PRECO",1,3,.f.)
	aadd(_verba, "total")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","TOTAL",1,3,.t.)
	aadd(_verba, "pedido")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","PEDIDO",1,1,.f.)
	aadd(_verba, "Pocket")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","PED. POCKET",1,1,.f.)
	aadd(_verba, "tipo")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","TIPO",1,1,.f.)
	aadd(_verba, "emiss")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","DT. EMISSÃO",1,4,.f.)
	aadd(_verba, "codrca")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","COD. RCA",1,1,.f.)
	aadd(_verba, "nomerca")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","NOME RCA",1,1,.f.)
	aadd(_verba, "gerente")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","GERENTE",1,1,.f.)
	aadd(_verba, "margem")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","MARGEM PED.",1,2,.f.)
	aadd(_verba, "cliente")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","COD. CLIENTE",1,1,.f.)
	aadd(_verba, "nomecli")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","NOME CLIENTE",1,1,.f.)
	aadd(_verba, "est")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","ESTADO",1,1,.f.)
	aadd(_verba, "divisao")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","DIVISÃO",1,1,.f.)
	aadd(_verba, "comissao")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","COMISSAO",1,2,.f.)
	aadd(_verba, "tes")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","TES",1,1,.f.)
	aadd(_verba, "desctes")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","DESC TES",1,1,.f.)
	aadd(_verba, "cfop")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","CFOP",1,1,.f.)
	aadd(_verba, "desccf")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","DESC CFOP",1,1,.f.)
	aadd(_verba, "msgped")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","MENSAGEM DO PEDIDO",1,1,.f.)
	aadd(_verba, "msgnota")
	oExcel:AddColumn("ped.periodo","Pedidos por Periodo","MENSAGEM DA NOTA",1,1,.f.)

	criatmp1()
	dbSelectArea("TMP1")
	TMP1->(DbGotop())
	While TMP1->(!EOF())
		//	ITEM	PRODUTO	DESCRICAO	QUANTIDADE	PRECO	TOTAL	PEDIDO	TIPO	EMISSAO	COD_RCA	NOME_RCA	GERENTE	MARGEM_PED CLIENTE	DESC_CLI DIVISAO COMISSAO

		oExcel:AddRow("ped.periodo","Pedidos por Periodo",; 
		{TMP1->ITEM,TMP1->PRODUTO,TMP1->DESCRICAO,TMP1->QUANTIDADE,TMP1->PRECO,tmp1->TOTAL,;
		TMP1->PEDIDO,TMP1->POCKECT,TMP1->TIPO,TMP1->EMISSAO,TMP1->COD_RCA,TMP1->NOME_RCA,TMP1->GERENTE,;
		TMP1->MARGEM_PED,TMP1->CLIENTE,TMP1->DESC_CLI,TMP1->UF,TMP1->DIVISAO,TMP1->COMISSAO,;
		TMP1->TES, TMP1->TESDESC, TMP1->CFOP, TMP1->CFDESC,TMP1->MSGPED, TMP1->MSGNOTA})
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
	_cquery += " SC6.C6_ITEM ITEM, "
	_cquery += " TRIM(SC6.C6_PRODUTO) PRODUTO, "
	_cquery += " TRIM(SB1.B1_DESC) DESCRICAO, "
	_cquery += " SC6.C6_QTDVEN QUANTIDADE, "
	_cquery += " SC6.C6_PRCVEN PRECO, "
	_cquery += " SC6.C6_VALOR TOTAL, "
	_cquery += " SC5.C5_NUM PEDIDO, "
	_cquery += " SB1.B1_TIPO TIPO, "
	_cquery += " SUBSTR(SC5.C5_EMISSAO,7,2)||'/'||SUBSTR(SC5.C5_EMISSAO,5,2)||'/'||SUBSTR(SC5.C5_EMISSAO,1,4) EMISSAO, "
	_cquery += " SC5.C5_VEND1 COD_RCA, "
	_cquery += " SA3.A3_NREDUZ NOME_RCA, "
	_cquery += " SA33.A3_NREDUZ GERENTE, "
	_cquery += " SC5.C5_MARGEM MARGEM_PED, "
	_cquery += " SC5.C5_CLIENTE||SC5.C5_LOJACLI CLIENTE, "
	_cquery += " TRIM(SA1.A1_NOME) DESC_CLI, "
	_cquery += " CASE SB1.B1_APREVEN " 
	_cquery += "    WHEN '1' THEN 'FAMILIAR' "
	_cquery += "    WHEN '2' THEN 'HOSPITALAR' "
	_cquery += " END DIVISAO, "
	_cquery += " SC5.C5_COMIS1||'%' COMISSAO, "
	_cquery += " SC5.C5_POCKET POCKECT, "
	_cquery += " SA1.A1_EST UF, "
	_cquery += " SC6.C6_TES TES, "
	_cquery += " SF4.F4_DESC TESDESC, "
	_cquery += " SC6.C6_CF CFOP, "
	_cquery += " SF4.F4_TEXTO2 CFDESC, "
	_cquery += " TRIM(SC5.C5_MENPED) MSGPED, "
	_cquery += " TRIM(SC5.C5_MENNOTA) MSGNOTA " 
	_cquery += " FROM  SC5010 SC5 "
	_cquery += " INNER JOIN SC6010 SC6 ON SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' "
	_cquery += " INNER JOIN SB1010 SB1 ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	_cquery += " LEFT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	_cquery += " LEFT JOIN SA3010 SA33 ON SA33.A3_COD = SC5.C5_VEND2 AND SA33.D_E_L_E_T_ = ' ' "
	_cquery += " INNER JOIN SA1010 SA1 ON A1_COD||SA1.A1_LOJA = SC5.C5_CLIENTE||SC5.C5_LOJACLI "
	_cquery += " LEFT JOIN SF4010 SF4 ON SF4.F4_CODIGO = SC6.C6_TES AND SF4.D_E_L_E_T_ = ' ' "
	_cquery += " WHERE SC5.D_E_L_E_T_ = ' ' "
	_cquery += " AND C5_TIPO = 'N' "
	_cquery += " AND SC5.C5_EMISSAO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	_cquery += " AND SB1.B1_APREVEN <> ' ' "
	_cquery += " ORDER BY SC5.C5_NUM, SC6.C6_ITEM "

	_cquery:=changequery(_cquery)
	TcQuery _cquery New Alias "TMP1"
	memowrite("C:/Stephen/tmp1.txt",_cquery)

Return

//*******************************************************************************************************************************************
Static Function AjustaSX1()

	//Local := _agrpsx1:={}
	cPerg := "dispestoq"

	PutSx1(cPerg,"01","Da data"      ,"Competencia?","Competencia?","mv_ch1","D",08,0,0,"G","","","","S","mv_par01","","","","","","","","","","","","","","","","","",,)
	PutSx1(cPerg,"02","Até data"     ,"Competencia?","Competencia?","mv_ch2","D",08,0,0,"G","","","","S","mv_par02","","","","","","","","","","","","","","","","","",,)


Return

//*******************************************************************************************************************************************

