/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT342 ³ Autor ³ Alex Júnio de Miranda   ³ Data ³ 17/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ GERA PLANILHA ACOMPANHAMENTO DE COMPRAS EXPORTANDO PARA    ³±±
±±³          ³ EXCEL, CONFORME PARÂMETROS INFORMADOS                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"       
#include "topconn.ch"

User Function VIT342()     


Private _cperg := "PERGVIT342"

_pergsx1()

pergunte(_cPerg,.t.)

_passou:=.t.

processa({|| _TExcel2()})

return



static function _TExcel2()
//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

Private _aCabec := {}
Private _aDados := {}
Private _aSaldo := {}

_cfilsd1:=xfilial("SD1")
_cfilsf1:=xfilial("SF1")

sd1->(dbsetorder(1))
sf1->(dbsetorder(1)) //filial + doc + serie + fornecedor + loja + tipo_nf

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

//_aCabec := {"Sol Compras", "Item SC","Cod Produto", "Descrição","Arm","Qt SC","Qt Atend (SC)","Sld Pend SC","UM","Dt Neces","Obs","Solicitante","Dt Emissão","Aprov","Reemis","Num PC","Item PC","Qt PC","Qt Atend (PC)","UM","Vlr UN PC","Vlr Total PC","IPI","Emiss PC","Prev Fat","Fornecedor","Loja","Razão Social","CC","Cond","Desc Condição","Emitido","Tipo Frete","Reem PC","Resíduo","Controle","Encer PC","Vlr Desconto","Usuário","Vlr IPI","Vlr ICMS","Alq ICMS","Base ICMS","Base IPI"}
_aCabec := {"Sol Compras", "Item SC","Cod Produto", "Descrição","Arm","Qt SC","Qt Atend (SC)","Sld Pend SC","UM","Dt Neces","Obs","Solicitante","Dt Emissão","Dt Liberação 1","Dt Liberação 2","Dt Liberação 3","Aprov","Reemis","Num PC","Item PC","Qt PC","Qt Atend (PC)","Sld Pend PC","UM","Vlr UN PC","Vlr Total PC","Ult Preco","IPI","Emiss PC","Prev Fat","Recebimento","Fornecedor","Loja","Razão Social","CC","Cond","Desc Condição","Emitido","Tipo Frete","Reem PC","Resíduo","Controle","Encer PC","Vlr Desconto","Usuário","Vlr IPI","Vlr ICMS","Alq ICMS","Base ICMS","Base IPI"}

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

	_dtrecbmto:=ctod("  /  /  ")

	if !Empty(tmp1->num_pc)
		_cquery2:=" SELECT"
		_cquery2+="   F1_RECBMTO RECBMTO"
		_cquery2+=" FROM "
		_cquery2+=  retsqlname("SF1")+" SF1, "
		_cquery2+=  retsqlname("SD1")+" SD1 "
		_cquery2+=" WHERE SF1.D_E_L_E_T_=' ' AND SD1.D_E_L_E_T_=' '" 	
		_cquery2+=" AND D1_COD='"+tmp1->prod+"'"
		_cquery2+=" AND D1_PEDIDO='"+tmp1->num_pc+"'"
		_cquery2+=" AND D1_ITEMPC='"+tmp1->it_pc+"'"
		_cquery2+=" AND D1_DOC=F1_DOC"
		_cquery2+=" AND D1_SERIE=F1_SERIE"
		_cquery2+=" AND D1_FORNECE=F1_FORNECE"
		_cquery2+=" AND D1_LOJA=F1_LOJA"
		_cquery2+=" ORDER BY F1_RECBMTO"				
		
		_cquery2:=changequery(_cquery2) 
		tcquery _cquery2 new alias "TMP2"    
	
		tcsetfield("TMP2","RECBMTO" ,"D")
	
		tmp2->(dbgotop())     
		_dtrecbmto:=tmp2->recbmto

	    tmp2->(dbclosearea())
	endif
		
	AAdd(_aDados, {tmp1->numsc, tmp1->itsc, tmp1->prod, tmp1->descri,tmp1->arm,tmp1->qt_sc,tmp1->qt_at_sc,(tmp1->qt_sc-tmp1->qt_at_sc),;
   				tmp1->umsc,tmp1->dt_necess,tmp1->obs_sc,tmp1->solicit,tmp1->emiss_sc,tmp1->dtlib1,tmp1->dtlib2,tmp1->dtlib3,tmp1->aprov,;
   				tmp1->reem_sc,tmp1->num_pc,tmp1->it_pc,tmp1->qt_pc,tmp1->qt_at_pc,(tmp1->qt_pc-tmp1->qt_at_pc),tmp1->um_pc,tmp1->vlr_pc,tmp1->vlrtot_pc,tmp1->ultprc,;
   				tmp1->ipi,tmp1->emiss_pc,tmp1->prev_fat,_dtrecbmto,tmp1->fornece,tmp1->loja,tmp1->razao,tmp1->cc,tmp1->cond,tmp1->desc_cond,tmp1->emitido,;
				tmp1->tp_frete,tmp1->reem_pc,tmp1->residuo,tmp1->controle,tmp1->encer_pc,tmp1->vlrdesc_pc,tmp1->usuario,tmp1->vlr_ipi,;
				tmp1->vlr_icm,tmp1->alq_icm,tmp1->base_icm,tmp1->base_ipi})

   tmp1->(dbSkip())
End

AAdd(_aSaldo,_aCabec)
DlgToExcel({ {"ARRAY", "Exportacao para o Excel", _aCabec, _aDados} })
tmp1->(dbclosearea())
return


static function _querys()       


_cquery:=" SELECT"
_cquery+="   SC1.C1_NUM NUMSC,"
_cquery+="   SC1.C1_ITEM ITSC,"
_cquery+="   SC1.C1_PRODUTO PROD,"
_cquery+="   SC1.C1_DESCRI DESCRI,"
_cquery+="   SC1.C1_LOCAL ARM,"
_cquery+="   SC1.C1_QUANT QT_SC,"
_cquery+="   SC1.C1_QUJE QT_AT_SC,"
_cquery+="   SC1.C1_UM UMSC,"
_cquery+="   SC1.C1_DATPRF DT_NECESS,"
_cquery+="   SC1.C1_OBS OBS_SC,"
_cquery+="   SC1.C1_EMISSAO EMISS_SC,"
_cquery+="   SC1.C1_SOLICIT SOLICIT,"
_cquery+="   SC1.C1_DTLIB1 DTLIB1,"
_cquery+="   SC1.C1_DTLIB2 DTLIB2,"
_cquery+="   SC1.C1_DTLIB3 DTLIB3,"
_cquery+="   SC1.C1_APROV APROV,"
_cquery+="   SC1.C1_QTDREEM REEM_SC,"
_cquery+="   C7_QUANT QT_PC,"
_cquery+="   C7_QUJE QT_AT_PC,"
_cquery+="   C7_UM UM_PC,"
_cquery+="   C7_PRECO VLR_PC,"
_cquery+="   C7_TOTAL VLRTOT_PC,"
_cquery+="   B1_UPRC ULTPRC,"
_cquery+="   C7_IPI IPI,"
_cquery+="   C7_DATPRF PREV_FAT,"
_cquery+="   C7_FORNECE FORNECE,"
_cquery+="   C7_LOJA LOJA,"
_cquery+="   A2_NOME RAZAO,"
_cquery+="   C7_CC CC,"
_cquery+="   C7_COND COND,"
_cquery+="   E4_COND DESC_COND,"
_cquery+="   C7_EMISSAO EMISS_PC,"
_cquery+="   C7_NUM NUM_PC,"
_cquery+="   C7_ITEM IT_PC,"
_cquery+="   C7_EMITIDO EMITIDO,"
_cquery+="   C7_TPFRETE TP_FRETE,"
_cquery+="   C7_QTDREEM REEM_PC,"
_cquery+="   C7_RESIDUO RESIDUO,"
_cquery+="   C7_CONTROL CONTROLE,"
_cquery+="   C7_ENCER ENCER_PC,"
_cquery+="   C7_VLDESC VLRDESC_PC,"
_cquery+="   C7_USER USUARIO,"
_cquery+="   C7_VALIPI VLR_IPI,"
_cquery+="   C7_VALICM VLR_ICM,"
_cquery+="   C7_PICM ALQ_ICM,"
_cquery+="   C7_BASEICM BASE_ICM,"
_cquery+="   C7_BASEIPI BASE_IPI"
_cquery+=" FROM "
_cquery+=  retsqlname("SC1")+" SC1, "
_cquery+=  retsqlname("SC7")+" SC7, "
_cquery+=  retsqlname("SA2")+" SA2, "
_cquery+=  retsqlname("SE4")+" SE4,"
_cquery+=  retsqlname("SB1")+" SB1 "

_cquery+=" WHERE SC1.D_E_L_E_T_=' ' AND SC7.D_E_L_E_T_=' ' AND SA2.D_E_L_E_T_=' ' AND SE4.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' '"
_cquery+=" AND SC1.C1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND SC1.C1_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND SC1.C1_NUM=C7_NUMSC"
_cquery+=" AND SC1.C1_ITEM=C7_ITEMSC"

if mv_par05==1
	_cquery+=" AND C7_QUANT>C7_QUJE"
	_cquery+=" AND C7_RESIDUO<>'S'"
endif

_cquery+=" AND C7_FORNECE=A2_COD"
_cquery+=" AND C7_LOJA=A2_LOJA"
_cquery+=" AND C7_COND=E4_CODIGO"
_cquery+=" AND C1_PRODUTO=B1_COD"

_cquery+=" UNION ALL"

_cquery+=" SELECT"
_cquery+="   SC1A.C1_NUM NUMSC,"
_cquery+="   SC1A.C1_ITEM ITSC,"
_cquery+="   SC1A.C1_PRODUTO PROD,"
_cquery+="   SC1A.C1_DESCRI DESCRI,"
_cquery+="   SC1A.C1_LOCAL ARM,"
_cquery+="   SC1A.C1_QUANT QT_SC,"
_cquery+="   SC1A.C1_QUJE QT_AT_SC,"
_cquery+="   SC1A.C1_UM UM,"
_cquery+="   SC1A.C1_DATPRF DT_NECESS,"
_cquery+="   SC1A.C1_OBS OBS_SC,"
_cquery+="   SC1A.C1_EMISSAO EMISS_SC,"
_cquery+="   SC1A.C1_SOLICIT SOLICITANTE,"
_cquery+="   SC1A.C1_DTLIB1 DTLIB1,"
_cquery+="   SC1A.C1_DTLIB2 DTLIB2,"
_cquery+="   SC1A.C1_DTLIB3 DTLIB3,"
_cquery+="   SC1A.C1_APROV APROV,"
_cquery+="   SC1A.C1_QTDREEM REEM_SC,"
_cquery+="   0 QT_PC,"
_cquery+="   0 QT_AT_PC,"
_cquery+="   ' ' UM_PC,"
_cquery+="   0.00 VLR_PC,"
_cquery+="   0.00 VLRTOT_PC,"
_cquery+="   SB1A.B1_UPRC ULTPRC,"
_cquery+="   0.00 IPI,"
_cquery+="   ' ' PREV_FAT,"
_cquery+="   ' ' FORNECE,"
_cquery+="   ' ' LOJA,"
_cquery+="   ' ' RAZAO,"
_cquery+="   ' ' CC,"
_cquery+="   ' ' COND,"
_cquery+="   ' ' DESC_COND,"
_cquery+="   ' ' EMISS_PC,"
_cquery+="   ' ' NUM_PC,"
_cquery+="   ' ' IT_PC,"
_cquery+="   ' ' EMITIDO,"
_cquery+="   ' ' TP_FRETE,"
_cquery+="   0 REEM_PC,"
_cquery+="   ' ' RESIDUO,"
_cquery+="   ' ' CONTROLE,"
_cquery+="   ' ' ENCER_PC,"
_cquery+="   0 VLRDESC_PC,"
_cquery+="   ' ' USUARIO,"
_cquery+="   0.00 VLR_IPI,"
_cquery+="   0.00 VLR_ICM,"
_cquery+="   0 ALQ_ICM,"
_cquery+="   0.00 BASE_ICM,"
_cquery+="   0.00 BASE_IPI"

_cquery+=" FROM "
_cquery+=retsqlname("SC1")+" SC1A,"
_cquery+=retsqlname("SB1")+" SB1A "
_cquery+=" WHERE SC1A.D_E_L_E_T_=' ' AND SB1A.D_E_L_E_T_=' '"
_cquery+=" AND SC1A.C1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND SC1A.C1_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND SC1A.C1_QUJE=0"
_cquery+=" AND SC1A.C1_PRODUTO=SB1A.B1_COD"
_cquery+=" ORDER BY 1,2"

_cquery:=changequery(_cquery) 
tcquery _cquery new alias "TMP1"    

tcsetfield("TMP1","QT_SC"     ,"N",12,2)
tcsetfield("TMP1","QT_AT_SC"  ,"N",12,2)
tcsetfield("TMP1","DT_NECESS" ,"D")
tcsetfield("TMP1","EMISS_SC"  ,"D")
tcsetfield("TMP1","QT_PC"     ,"N",12,2)
tcsetfield("TMP1","QT_AT_PC"  ,"N",12,2)
tcsetfield("TMP1","VLR_PC"    ,"N",12,2)
tcsetfield("TMP1","VLRTOT_PC" ,"N",12,2)
tcsetfield("TMP1","ULTPRC"    ,"N",12,2)
tcsetfield("TMP1","IPI"       ,"N",12,0)
tcsetfield("TMP1","PREV_FAT"  ,"D")
tcsetfield("TMP1","EMISS_PC"  ,"D")
tcsetfield("TMP1","REEM_PC"   ,"N",12,0)
tcsetfield("TMP1","VLRDESC_PC","N",12,2)
tcsetfield("TMP1","VLR_IPI"   ,"N",12,2)
tcsetfield("TMP1","VLR_ICM"   ,"N",12,2)
tcsetfield("TMP1","ALQ_ICM"   ,"N",12,0)
tcsetfield("TMP1","BASE_ICM"  ,"N",12,2)
tcsetfield("TMP1","BASE_IPI"  ,"N",12,2)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da Data Emissao da SC        ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a Data Emissao da SC     ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Do Produto                   ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"04","Ate o Produto                ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"05","Considera SCs                ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"1-Abertas"      ,space(30),space(15),"2-Todas"        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return
