#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MTA650I
	PE - Na geração das OP`s 
@author Microsiga
@since 06/02/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MTA650I()
Local cQry              := ""
Local i 				:= 0
Local cAliasTop         := GetNextAlias()
Local MV_XESPOP     	:= SuperGetMV("MV_XESPOP", .f., "N") //Trata copia das OP´s na explosao para o Evolutio
Local lConfirmaExplosao := .t. //Usado para inibir dialogo confirmando criação de OPs intermediárias e SCs.
                               //Para não gerar OPs e SCs retornar .F. (equivalente ao botão Não) ou .T. (equivalente ao botão Sim) para gerar.
                               //Se por acaso desejar exibir a dialog retorne qualquer valor não-lógico.
	
	If MV_XESPOP == "N"
		Return(lConfirmaExplosao)
	EndIf
	
	If Type("_aOPs") == "U"
		_SetNamedPrvt( "_aOPs" , {} , "MATA650" )               
	EndIf
	
	cQry := " SELECT SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN NUM_OP" +;
	        " FROM " + RetSqlName("SC2") + " SC2 " +; 
     		" WHERE SC2.D_E_L_E_T_  = ' ' " +;
            "   AND SC2.C2_FILIAL   = '" + xFilial("SC2") + "' " +; 
            "   AND SC2.C2_EMISSAO >= '"+GetMV("MV_XSC2COP")+"' " +;
            "   AND SC2.C2_XCOPIA  <> 'S' " 
    
    cQry := ChangeQuery(cQry)
    	
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasTop,.T.,.T.)
    	
    Do While (cAliasTop)->(!Eof())
		If AScan(_aOPs, {|x| x == (cAliasTop)->NUM_OP}) == 0
			AAdd(_aOPs, (cAliasTop)->NUM_OP )
		EndIf
		
		(cAliasTop)->(DbSkip())
	EndDo

	(cAliasTop)->(dbCloseArea())

Return(lConfirmaExplosao)