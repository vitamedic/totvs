/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  VIT478   ?Autor ?Luiz Fernando S    ?Data ? 07/04/17   ³±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±³Descricao ?Programa para Emissao do Relatorio de produtos vencidos    ³±?
±±?         ?ou a vencer em Excel 										  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Vitamedic                                  ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±³Versao    ?1.0                                                        ³±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
*/
//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
 
//Constantes
#Define STR_PULA    Chr(13)+Chr(10)
 
User Function vit478
    Local aArea     := GetArea()
    Local cQuery        := ""
    Local oFWMsExcel
    Local oExcel
    Local cArquivo  := GetTempPath()+'vit478.xls'  
    
	Local cTitulo := " Produtos Vencidos ou a Vencer em 45 dias        Emissao: " +dtoc(Date())+" Hrs :" + Time() + " "
	Private aDados[15]
	
	cperg:="PERGVIT478"
	_pergsx1()
	pergunte(cperg,.t.)

 
    //Pegando os dados
    cQuery := " SELECT "                                                    + STR_PULA
    cQuery += "    B8_PRODUTO PRODUTO, "                                           + STR_PULA
    cQuery += "    B1_DESC DESCRI, "                                      + STR_PULA
    cQuery += "    B1_TIPO TIPO, "                                      + STR_PULA
    cQuery += "    B1_GRUPO GRUPO, "                                      + STR_PULA
    cQuery += "    B8_DTVALID DTVALID, "                                     + STR_PULA
    cQuery += "    B1_UM UM,"                                      + STR_PULA
    cQuery += "    B8_SALDO SALDO,"											+ STR_PULA
    cQuery += "    B8_EMPENHO EMPENHO,"									+ STR_PULA
    cQuery += "    B8_LOTECTL LOTECTL,"								+ STR_PULA
    cQuery += "    B2_COD CODIGO, "                                    + STR_PULA//Adiciona CUSTO
    cQuery += "    B2_LOCAL LOCAL, "                                    + STR_PULA//Adiciona CUSTOB2_CMFIM1
    cQuery += "    B2_CMFIM1 CMF, "                                    + STR_PULA//Adiciona CUSTO
    cQuery += "    B2_CM1 CM1, "                                    + STR_PULA//Adiciona CUSTO
    cQuery += "    B8_LOCAL LOCPAD "                                    + STR_PULA
    cQuery += " FROM "                                                  + STR_PULA
    cQuery += "     "+retsqlname("SB1")+" SB1,"                          + STR_PULA
    cQuery += "     "+retsqlname("SB2")+" SB2,"                          + STR_PULA//Adiciona CUSTO
    cQuery += "     "+retsqlname("SB8")+" SB8"								+ STR_PULA
    cQuery += " WHERE "                                                 + STR_PULA
 	cQuery += "     SB1.D_E_L_E_T_<>'*'"+ STR_PULA
	cQuery += " AND SB8.D_E_L_E_T_<>'*'"+ STR_PULA
	cQuery += " AND B1_FILIAL='"+xfilial("SB1")+"'"+ STR_PULA
	cQuery += " AND B2_FILIAL='"+xfilial("SB2")+"'"+ STR_PULA//Adiciona CUSTO
	cQuery += " AND B8_FILIAL='"+xfilial("SB8")+"'"+ STR_PULA//Adiciona CUSTO
	cQuery += " AND B8_PRODUTO=B1_COD"+ STR_PULA
	cQuery += " AND B8_LOCAL=B2_LOCAL"+ STR_PULA
	cQuery += " AND B8_PRODUTO=B2_COD"+ STR_PULA
	cQuery += " AND B8_SALDO > 0 "+ STR_PULA
	cquery += " AND B8_PRODUTO BETWEEN '"+mv_par01+"' and '"+mv_par02+"' "//+mv_par01+"' AND '"+mv_par02+"'"
	cquery += " AND B8_DTVALID <= '"+dtos(DaySum(dDataBase,45))+"'" //BETWEEN '"+dtos(dDataBase)+"' and '"+dtos(DaySum(dDataBase,45))+"'"
	cquery += " AND B8_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"//Emerson 11/04/2017 apenas armazens que e usados
	cquery += " AND B1_TIPO BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "//+mv_par03+"' AND '"+mv_par04+"'"
	cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND B8_DTVALID <= '"+dtos(DaySum(dDataBase,45))+"'" + STR_PULA//BETWEEN '"+dtos(dDataBase)+"' and '"+dtos(DaySum(dDataBase,45))+"'"
	cQuery += " ORDER BY B1_GRUPO,B8_PRODUTO,B1_DESC,B8_LOCAL,B2_LOCAL,B8_DTVALID,B8_LOTECTL,B2_COD"+ STR_PULA//Adiciona CUSTO
    TCQuery cQuery New Alias "TEMP1"
     
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
     
    //Aba 01 - VIT478
    oFWMsExcel:AddworkSheet("VIT478") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("VIT478",cTitulo)
        //Criando Colunas
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Grupo/Produto",1,1) //1 = Modo Texto
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Descricao",1,1) //1 = Modo Texto
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Saldo",2,2) //3 = Valor com R$
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Custo Total",3,2) //3 = Valor com R$
        oFWMsExcel:AddColumn("VIT478",cTitulo,"UM",1,1) //1 = Modo Texto 
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Lote",1,1) //1 = Modo Texto
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Armazem",1,1) //1 = Modo Texto
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Vencimento",1,1) //1 = Modo Texto
        oFWMsExcel:AddColumn("VIT478",cTitulo,"Dias p/Vencer",1,1) //1 = Modo Texto
     
   	 	//Aba 02 - Produtos  Criar nova aba
   		// oFWMsExcel:AddworkSheet("Aba 2 Produtos")
        //Criando a Tabela
     
        //Criando as Linhas... Enquanto não for fim da query
        While !TEMP1->(EOF()) //.AND. _cGProd == TMP1->GRUPO
			_cGrupo  := Posicione("SBM",1,xFilial("SBM")+TEMP1->GRUPO,"BM_DESC")
			_cGP     :=	TEMP1->GRUPO	
				oFWMsExcel:AddRow("VIT478",cTitulo,{;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ";
            })
			oFWMsExcel:AddRow("VIT478",cTitulo,{;
                                                                    _cGP,;
                                                                    _cGrupo,;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ",;
                                                                    "  ";
            })
         
			While !(TEMP1->(EoF())) .AND. 	_cGP ==	TEMP1->GRUPO	
            	oFWMsExcel:AddRow("VIT478",cTitulo,{;
                                                                    TEMP1->PRODUTO,;
                                                                    TEMP1->DESCRI,;
                                                                    TEMP1->SALDO,;
                                                                    iif(TEMP1->TIPO $ "PA,PN,PD",TEMP1->SALDO*TEMP1->CMF,TEMP1->SALDO*TEMP1->CM1),;
                                                                    TEMP1->UM,;
                                                                    TEMP1->LOTECTL,;
                                                                    TEMP1->LOCPAD,;
                                                                    STOD(TEMP1->DTVALID),;
                                                                    Iif(dDataBase > STOD(TEMP1->DTVALID), 'VENCIDO', cValtoChar(DateDiffDay(STOD(TEMP1->DTVALID),dDataBase)));
   	        	 })
         
            	//Pulando Registro
        	    TEMP1->(DbSkip())
        	EndDo  
  		ENDDO   
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()           //Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)              //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
     
    TEMP1->(DbCloseArea())
    RestArea(aArea)
Return

static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazems           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"09","De Validade        ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"10","Ate Validade       ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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