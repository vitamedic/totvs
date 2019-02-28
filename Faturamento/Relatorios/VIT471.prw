/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VIT471 º Autor ³ Ricardo Moreira        º Data ³  22/09/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Acompanhamento de Fretes Notas Saidas		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic		                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

User Function VIT471() //U_VIT471()

_cfilsra:=xfilial("SF2")
_cfilsrd:=xfilial("SF8")

SF2->(dbsetorder(1))
SF8->(dbsetorder(5))


_dataini  := ctod("  /  /  ")
_datafim  := ctod("  /  /  ")

@ 000,000 to 130,200 dialog odlg1 title "Acompanhamento de Fretes Notas Saidas - Excel"
@ 005,005 say "Da Data"
@ 005,045 get _dataini size 040,10
@ 020,005 say "Ate a Data"
@ 020,045 get _datafim size 040,10

@ 040,020 bmpbutton type 1 action TExcel2()
@ 040,055 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered

return()

static function TExcel2()
//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//
Local Ftmes := "NAO"
Private _aCabec := {}
Private _aDados := {}
Private _aSaldo := {}
Private _RetNota := " "  
Private _RetData := " "
Private _RetUF   := " " 
Private _chegada
Private _entrega

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

If (_dataini = ctod("  /  /  ")) .or. (_datafim = ctod("  /  /  "))
	MsgAlert("Informar Datas de Inicio e Fim do Período") 
	Return
endif                                          

_aCabec :={"Cliente","Loja","Nome","Estado","Pedido","Data do Pedido","Data Faturamento","Nota Fiscal","Serie","Valor Nota","Peso Bruto", "Peso Liquido",;
	       "Volume","Transportadora","Transportadora_Opcional","Ped/Faturamento","Data Embarque","Faturamento/Expedicao"," Dias Previsao/Expedição","Previsao Entrega","Tabela Previsao",;
	       "Data Cheg Cidade","Cheg Cidade/Expedicao","Data Entrega","Data Entrega/Cheg Destino","Order Cycle","Tipo de Frete","Num Cte","Serie Cte","Fat. Entreg Mes","Observações"}
           

processa({|| _querys()})
TMP1->(dbgotop())

While !TMP1->(Eof())  

        _RetNota := TMP1->Danfe
        _RetUF   := TMP1->Uf
        _RetData := RetPed() 
        
        IF TMP1->MES_ENTREGA = TMP1->MES_EMISSAO        
         	 Ftmes := "SIM"
        ENDIF          
         IF stod(TMP1->ChegCid)-stod(TMP1->Expedicao)  < 0
            _TESTE := 0
         ELSE
            _TESTE := stod(TMP1->ChegCid)-stod(TMP1->Expedicao)
         END
		if empty(TMP1->ChegCid)
			_chegada:=  " "
		Else
		   _chegada:=  stod(TMP1->ChegCid) //"Data Cheg Cidade"
		EndIf 
		if empty(TMP1->Entrega)
		     _entrega:= " " 
		 Else
		     _entrega:= stod(TMP1->Entrega)
		Endif        
		AAdd(_aDados, {TMP1->Cliente,;  //"Cliente"
				   TMP1->Loja,; //"Loja"
				   POSICIONE("SA1",1,xFilial("SA1")+TMP1->Cliente+TMP1->Loja,"A1_NOME"),;//"Nome"
				   TMP1->Uf,; //"Estado"
				   RetPed(),; //"Pedido"
				   stod(RetData()),; //"Data do Pedido"
				   stod(TMP1->Emissao),; //"Data Faturamento"
				   TMP1->Danfe,; //"Nota Fiscal"
				   TMP1->Serie,;//"Serie"
				   TMP1->Valor,;//"Valor Nota"
				   TMP1->Peso_Bruto,;//"Peso Bruto"
				   TMP1->Peso_Liquido,;//"Peso Liquido"
				   TMP1->Volume,;//"Volume"
				   POSICIONE("SA4",1,xFilial("SA4")+TMP1->Transp,"A4_NOME"),; //"Transportadora"
				   POSICIONE("SA4",1,xFilial("SA4")+TMP1->Transp_opc,"A4_NOME"),; //"Transportadora_Opcional"
				   stod(TMP1->Emissao) - stod(RetData()),; //"Ped/Faturamento"
				   stod(TMP1->Expedicao),;  //"Data Embarque"
				   stod(TMP1->Expedicao)-stod(TMP1->Emissao),;//"Faturamento/Expedicao"
				   stod(TMP1->Previsao)-stod(TMP1->Expedicao),; //Expedicao/Previsao
				   stod(TMP1->Previsao),; //"Previsao Entrega"
				   DiaUF(),;//"Data Embarque + _Media"    //+ _Media
				   _chegada,;//"Data Cheg Cidade"
				   _TESTE,; //stod(TMP1->ChegCid)-stod(TMP1->Expedicao),; //"Entrega/Expedicao"
				   _entrega,; //"Data Entrega"
				   stod(TMP1->Entrega)- stod(TMP1->ChegCid),; //"Data Entrega/Cheg Destino"
				   stod(TMP1->Emissao)- stod(RetData())+stod(TMP1->Expedicao)-stod(TMP1->Emissao)+_TESTE+stod(TMP1->Entrega)-stod(TMP1->ChegCid),; //"Order Cycle"
				   TMP1->TipoFrete,; //"Tipo de Frete"                  
				   TMP1->Num_Cte,;  //"Num Cte"
     			   TMP1->Serie_Cte,; //"Serie Cte"   
     			   Ftmes,;  			      			   
				   TMP1->Obs})	   //"Observações"

	TMP1->(dbSkip())
End
				  
DlgToExcel({ {"ARRAY", "Acompanhamento de Fretes Notas Saidas - Excel", _aCabec, _aDados} })
TMP1->(dbclosearea())  
close(odlg1)
return


static function _querys()       
_cQry := " "
_cQry += "SELECT  DISTINCT SF2.F2_CLIENTE Cliente,SF2.F2_LOJA Loja,SF2.F2_EST Uf ,SF2.F2_EMISSAO Emissao, SF2.F2_DOC Danfe,SF2.F2_SERIE Serie, SF2.F2_VALBRUT Valor,SF2.F2_PBRUTO Peso_Bruto,SF2.F2_PLIQUI Peso_Liquido, "      
_cQry += " SF2.F2_VOLUME1 Volume,SF2.F2_TRANSP Transp,SF2.F2_TRANOPC Transp_opc,SF8.F8_DTPREV Previsao,SF2.F2_DATAEMB Expedicao,SF2.F2_DTENTCD ChegCid,SF2.F2_DTENTRG Entrega, SF8.F8_TPFRETE TipoFrete, "      
_cQry += " SF8.F8_NFDIFRE Num_Cte, SF8.F8_SEDIFRE Serie_Cte, SF2.F2_OBSTRAN Obs, to_char(to_date(SF2.F2_EMISSAO,'YYYY/MM/DD'),'MM') MES_EMISSAO, 
_cQry += " CASE SF2.F2_DTENTRG  "
_cQry += " WHEN ' ' THEN '00'   "
_cQry += " ELSE TO_CHAR(TO_DATE(SF2.F2_DTENTRG,'YYYY/MM/DD'),'MM') END  MES_ENTREGA "
_cQry += "FROM " + retsqlname("SF8")+" SF8 "
_cQry += "INNER JOIN " + retsqlname("SF2")+" SF2 ON F2_DOC = F8_NFORIG AND F2_SERIE = F8_SERORIG AND F2_CLIENTE = F8_FORNECE AND F2_LOJA = F8_LOJA "  
_cQry += "WHERE SF2.D_E_L_E_T_ <> '*' "
_cQry += "AND SF8.D_E_L_E_T_ <> '*' " 
_cQry += "AND F8_TIPONF = 'S' " 
_cQry += "AND F2_EMISSAO BETWEEN '" + DTOS(_dataini)  + "' AND '" + DTOS(_datafim)  + "' "
_cQry += "ORDER BY  SF2.F2_DOC,SF2.F2_SERIE "
                                              

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP1"
 
return                         



//Vitamedic
//Data: 03/11/2016
//Retorna O Numero de Pedido de Venda
//Autor: Ricardo Moreira                                        

Static Function RetPed()    
                                                   
Private _Pedido := " "

If Select("TMP2") > 0
	TMP2->(dbCloseArea())
EndIf

_cQry := " " 
_cQry += "SELECT  C6_NUM Pedido "  
_cQry += "FROM " + retsqlname("SC6")+" SC6 "   
_cQry += "WHERE ROWNUM = 1 "
_cQry += "AND D_E_L_E_T_ <> '*' "
_cQry += "AND C6_NOTA	= '" + _RetNota + "'

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP2"

dbselectarea("TMP2") 
	_Pedido := TMP2->Pedido

Return _Pedido      



//Vitamedic
//Data: 03/11/2016
//Retorna a data do Pedido de Venda
//Autor: Ricardo Moreira                                        

Static Function RetData()    
                                                   
Private _PedData := " "

If Select("TMP3") > 0
	TMP3->(dbCloseArea())
EndIf

_cQry := " " 
_cQry += "SELECT  C5_EMISSAO DtEmissao "  
_cQry += "FROM " + retsqlname("SC5")+" SC5 "   
_cQry += "WHERE ROWNUM = 1 "
_cQry += "AND D_E_L_E_T_ <> '*' "
_cQry += "AND C5_NUM	= '" + _RetData + "'

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP3"

dbselectarea("TMP3") 
	_PedData := TMP3->DtEmissao

Return _PedData      

//Vitamedic
//Data: 11/11/2016
//Retorna A tABELA DE PREVISAO ESTADO
//Autor: Ricardo Moreira                                        
                   
Static Function DiaUF()    
                                                   
Private _UfDias := " "

If Select("TMP4") > 0
	TMP4->(dbCloseArea())
EndIf

_cQry := " " 
_cQry += "SELECT  ZUF_MEDDIA Dias "  
_cQry += "FROM " + retsqlname("ZUF")+" ZUF "   
_cQry += "WHERE D_E_L_E_T_ <> '*' "
_cQry += "AND ZUF_UF = '" + _RetUF + "'

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP4"

dbselectarea("TMP4") 
	_UfDias := TMP4->Dias

Return _UfDias      







