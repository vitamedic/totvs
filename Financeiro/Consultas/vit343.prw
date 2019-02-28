/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT343 ³ Autor ³ Alex Júnio de Miranda   ³ Data ³ 03/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Planilha Acompanhamento de Contas a Pagar no Modulo   ³±±
±±³          ³ Financeiro para Excel, Conforme Parametros Informados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"       
#include "topconn.ch"

User Function VIT343()     


Private _cperg := "PERGVIT343"

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

_cfilse1:=xfilial("SE1")
_cfilsa1:=xfilial("SA1")
_cfilsx5:=xfilial("SX5")
_cfilsed:=xfilial("SED")

se1->(dbsetorder(1))
sa1->(dbsetorder(1)) 
sx5->(dbsetorder(1)) 
sed->(dbsetorder(1)) 

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

_aCabec := {"Prefixo", "Numero", "Parcela", "Tipo","Descricao Tipo","Natureza","Descricao Natureza","Cod Cliente","Loja","Cliente","Emissao","Venc Real","Dt Baixa","Banco","Agencia","Bordero","Dt Bordero","Historico","Situacao","Descricao Situacao","Valor","Valor (R$)","Saldo","Desconto","Multa","Juros","Correcao","Valor Baixado","Representante","Ger Regional","Pref Fat","Num Fatura","Tipo Fat","Status","Num Liquidacao","Tipo Liq"}

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

	AAdd(_aDados, {tmp1->pref, tmp1->num, tmp1->parc, tmp1->tipo, tmp1->desc_tipo, tmp1->naturez, tmp1->desc_natur, tmp1->cod_cli, tmp1->loja,;
   				tmp1->cliente, tmp1->emissao, tmp1->venc_real, tmp1->dt_baixa, tmp1->banco, tmp1->ag_dep, tmp1->bordero, tmp1->dt_bordero, tmp1->historico,;
   				tmp1->sit, tmp1->desc_sit, tmp1->valor, tmp1->vlr_reais, tmp1->saldo, tmp1->desconto, tmp1->multa, tmp1->juros, tmp1->correcao, tmp1->vlr_liq,;
   				tmp1->rep, tmp1->ger_reg, tmp1->prf_fat, tmp1->num_fat, tmp1->tp_fat, tmp1->st, tmp1->num_liq, tmp1->tp_liq})

   tmp1->(dbSkip())
End

AAdd(_aSaldo,_aCabec)
DlgToExcel({ {"ARRAY", "Acompanhamento Contas Receber", _aCabec, _aDados} })
tmp1->(dbclosearea())
return


static function _querys()       


_cquery:=" SELECT"
_cquery+="     E1_PREFIXO PREF,"
_cquery+="     E1_NUM NUM,"
_cquery+="     E1_PARCELA PARC,"
_cquery+="     E1_TIPO TIPO,"
_cquery+="     SX5B.X5_DESCRI DESC_TIPO,"
_cquery+="     E1_NATUREZ NATUREZ,"
_cquery+="     ED_DESCRIC DESC_NATUR,"
_cquery+="     E1_CLIENTE COD_CLI,"
_cquery+="     E1_LOJA LOJA,"
_cquery+="     A1_NOME CLIENTE,"
_cquery+="     E1_EMISSAO EMISSAO,"
_cquery+="     E1_VENCREA VENC_REAL,"
_cquery+="     E1_BAIXA DT_BAIXA,"
_cquery+="     E1_PORTADO BANCO,"
_cquery+="     E1_AGEDEP AG_DEP,"
_cquery+="     E1_NUMBOR BORDERO,"
_cquery+="     E1_DATABOR DT_BORDERO,"
_cquery+="     E1_HIST HISTORICO,"
_cquery+="     E1_SITUACA SIT,"
_cquery+="     SX5A.X5_DESCRI DESC_SIT,"
_cquery+="     E1_VALOR VALOR,"
_cquery+="     E1_VLCRUZ VLR_REAIS,"
_cquery+="     E1_SALDO SALDO,"
_cquery+="     E1_DESCONT DESCONTO,"
_cquery+="     E1_MULTA MULTA,"
_cquery+="     E1_JUROS JUROS,"
_cquery+="     E1_CORREC CORRECAO,"
_cquery+="     E1_VALLIQ VLR_LIQ,"
_cquery+="     E1_VEND1 REP,"
_cquery+="     E1_VEND2 GER_REG,"
_cquery+="     E1_FATPREF PRF_FAT,"
_cquery+="     E1_FATURA NUM_FAT,"
_cquery+="     E1_TIPOFAT TP_FAT,"
_cquery+="     CASE"
_cquery+="       WHEN E1_STATUS='A' THEN 'ABERTO'"
_cquery+="       WHEN E1_STATUS='B' THEN 'BAIXADO'"
_cquery+="       WHEN E1_STATUS='R' THEN 'RELIQUIDADO'"
_cquery+="       ELSE ' '"
_cquery+="     END ST,"
_cquery+="     E1_NUMLIQ NUM_LIQ,"
_cquery+="     E1_TIPOLIQ TP_LIQ"


_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1, "
_cquery+=  retsqlname("SA1")+" SA1, "
_cquery+=  retsqlname("SX5")+" SX5A, "
_cquery+=  retsqlname("SX5")+" SX5B,"
_cquery+=  retsqlname("SED")+" SED "

_cquery+=" WHERE SE1.D_E_L_E_T_=' ' AND SA1.D_E_L_E_T_=' ' AND SX5A.D_E_L_E_T_=' ' AND SX5B.D_E_L_E_T_=' ' AND SED.D_E_L_E_T_=' '"
_cquery+=" AND SE1.E1_CLIENTE=SA1.A1_COD"
_cquery+=" AND SE1.E1_LOJA=SA1.A1_LOJA"
_cquery+=" AND SE1.E1_NATUREZ=ED_CODIGO"
_cquery+=" AND SE1.E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND SE1.E1_VENCREA BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"

if mv_par05==1
	_cquery+=" AND (SE1.E1_BAIXA=' ' OR SE1.E1_SALDO>0)"
endif

_cquery+=" AND SX5A.X5_TABELA='07'"
_cquery+=" AND E1_SITUACA=SX5A.X5_CHAVE"
_cquery+=" AND SX5B.X5_TABELA='05'"
_cquery+=" AND E1_TIPO=SX5B.X5_CHAVE"
_cquery+=" ORDER BY E1_EMISSAO, E1_TIPO, E1_PREFIXO, E1_NUM"


_cquery:=changequery(_cquery) 
tcquery _cquery new alias "TMP1"    

tcsetfield("TMP1","EMISSAO"   ,"D")
tcsetfield("TMP1","VENC_REAL" ,"D")
tcsetfield("TMP1","DT_BAIXA"  ,"D")
tcsetfield("TMP1","DT_BORDERO","D")
tcsetfield("TMP1","VALOR"     ,"N",15,2)
tcsetfield("TMP1","VLR_REAIS" ,"N",15,2)
tcsetfield("TMP1","SALDO"     ,"N",15,2)
tcsetfield("TMP1","DESCONTO"  ,"N",15,2)
tcsetfield("TMP1","MULTA"     ,"N",15,2)
tcsetfield("TMP1","JUROS"     ,"N",15,2)
tcsetfield("TMP1","CORRECAO"  ,"N",15,2)
tcsetfield("TMP1","VALOR_LIQ" ,"N",15,2)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da Emissao                   ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a Emissao                ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Da Baixa                     ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"04","Ate a Baixa                  ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"05","Considera Títulos            ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"1-Abertos"      ,space(30),space(15),"2-Todos"        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
