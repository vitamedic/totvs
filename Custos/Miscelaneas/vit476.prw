#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT476  ³ Autor ³ Reuber A. Moura Jr.   ³ Data ³ 26/08/04  ³±±
±±³          ³                   Alex J. Miranda                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo / Atualização dos custos das OP´s                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gera os lancamentos de custos diretos improdutivos e       ³±±
±±³          ³ indiretos para cada OP                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

user function vit476()

cperg	:= "PERGVIT476"
_pergsx1()
pergunte(cperg,.f.)

@ 00,000 TO 227,463 DIALOG oDlg TITLE "Calculo / Atualização dos custos das OP´s"
@ 08,010 TO 84,222
@ 23,16 SAY OemToAnsi("Este programa Gera os lancamentos dos custos diretos improdu-")
@ 33,16 SAY OemToAnsi("tivos e indiretos para cada OP dentro do periodo (SD3)")
@ 91,140 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return



Static Function OkProc()
Processa( {|| RunProc() } )
Return


Static Function RunProc()

_dtfecha:= GETMV("MV_ULMES")
_dtini:=FirstDay(ctod('01/'+mv_par01+'/'+mv_par02))
_dtfim:=LastDay(ctod('01/'+mv_par01+'/'+mv_par02))

_opini:='            '
_opfim:='ZZZZZZZZZZZ '

_cfilct1:=xfilial("CT1")
_cfilct2:=xfilial("CT2")
_cfilctt:=xfilial("CTT")
_cfilsd3:=xfilial("SD3")
_cfilspj:=xfilial("SPJ")
_cfilsra:=xfilial("SRA")
_cfilsrd:=xfilial("SRD")
_cfilrcg:=xfilial("RCG")

ct1->(dbsetorder(1)) //Filial + Conta
ct2->(dbsetorder(1)) //Filial + Data
ctt->(dbsetorder(1)) //Filial + CC
sd3->(dbsetorder(7)) //Filial + Codigo + Local + Dt.Emissao + Num.Seq.
spj->(dbsetorder(1)) //Filial + Turno + Semana + Dia
sra->(dbsetorder(1)) //Filial + Matricula
srd->(dbsetorder(1)) //Filial + Matricula + Datarq + ...
rcg->(dbsetorder(1)) //Filial + Ano + Mes

if _dtfim < _dtfecha
	msgstop("Data para gerar Apropriação das MO é anterior a do ultimo fechamento!")
	return
endif

/*CASO JÁ EXISTA CÁLCULO EFETUADO, IRÁ EXCLUIR OS LANÇAMENTOS DO SD3 REFERENTE A MÃO DE OBRA IMPRODUTIVA E INDIRETA*/
#IFDEF TOP
	procregua(1)
	incproc("Excluindo lançamentos caso existam")
	cProcedure:="DELMODI"
	If ExistProc( cProcedure )
		TCSPEXEC( xProcedures(cProcedure),mv_par02+mv_par01)
	endif
#ENDIF

processa({|| _gerahoras()})
tmp1->(dbgotop())

while ! tmp1->(eof())
	_hrimprod:=(tmp1->hrsatrab - tmp1->horasops)
	if tmp1->clascc='1' .and. _hrimprod > 0
		_cc:=tmp1->cc
		_vlrcc:= _somact2(_cc)
		//_csthoraunit:=iif(tmp1->horasops>tmp1->hrsatrab,(_vlrcc/tmp1->horasops),(_vlrcc/tmp1->hrsatrab))
		//_csthoraunit:=_vlrcc/tmp1->horasops
		_csthoraunit:=_vlrcc/tmp1->hrsatrab
		
		procregua(1)
		incproc("Somando CT2 por CC - "+_cc)
		
		_cquery:=" SELECT D3_FILIAL FILIAL, D3_COD COD, D3_LOCAL LOCAL, D3_EMISSAO EMISSAO, D3_NUMSEQ NUMSEQ, D3_OP OP"
		_cquery+=" FROM "+retsqlname("SD3")+" SD3"
		_cquery+=" WHERE SD3.D_E_L_E_T_=' '"
		_cquery+=" AND SD3.D3_COD = 'MOD"+_cc+"'"
		_cquery+=" AND SD3.D3_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
		_cquery+=" AND SD3.D3_OP BETWEEN '"+_opini+"' AND '"+_opfim+"'"
		_cquery+=" AND SD3.D3_TM='999'"
		_cquery+=" AND SD3.D3_ESTORNO<>'S'"
		
		memowrit("/sql/vit309c.sql",_cquery)
		tcquery _cquery new alias "TMP3"
		tcsetfield("TMP3","EMISSAO","D")
		
		tmp3->(dbgotop())
		
		dbselectarea("SD3")
		while !tmp3->(eof())
			sd3->(dbsetorder(7)) //Filial + Codigo + Local + Dt.Emissao + Num.Seq.
			if sd3->(dbseek(_cfilsd3+tmp3->cod+tmp3->local+dtos(tmp3->emissao)+tmp3->numseq))
				// Lanca Mao de Obra Direta Improdutiva
				// Cria Array com todos os campos do SD3
				aSD3 := array(fCount())
				for i:=1 to FCount()
					aSD3[i] := fieldget(i)
				next
				
				cmov:= "610" //Mov.int
				
				for i:=1 to FCount()
					if upper(fieldname(i))=='D3_QUANT'
						qdtmod:=fieldget(i)
					endif
				next
				RecLock("SD3",.t.)
				
				for i:=1 to FCount()
					fieldput(i,aSD3[i])
				next
				
				replace d3_cod      with "MOD"+_cc
				replace d3_tm       with cmov
				replace d3_um       with "HR"
				replace d3_quant    with (qdtmod/tmp1->horasops)*_hrimprod
				replace d3_cf       with "RE0"
				replace d3_ident    with " "
				replace d3_nivel    with " "
				replace d3_stserv   with "1"	
				replace d3_custo1   with ((qdtmod/tmp1->horasops)*_hrimprod)*_csthoraunit
				replace d3_parctot  with " "
				replace d3_tipo     with "MO"
				replace d3_chave    with "E0"
				replace d3_segum    with "HR"
				replace d3_qtsegum  with (qdtmod/tmp1->horasops)*_hrimprod
				replace d3_obs	  with "MODIMP"
				MSUnlock()
			endif
			tmp3->(dbskip())
		end
		
		sd3->(dbclosearea())
		
		tmp3->(dbclosearea())
	endif
	
	tmp1->(dbskip())
end

// PROCESSA MAO DE OBRA INDIRETA

procregua(1)
incproc("Somando HR MOD e MOD Improdutiva...")

_cquery:=" SELECT"
_cquery+=" OP,"
_cquery+=" TOTHORA,"
_cquery+=" (SELECT SD31.D3_NUMSEQ"
_cquery+=" FROM "+retsqlname("SD3")+" SD31"
_cquery+=" WHERE SD31.D_E_L_E_T_=' '"
_cquery+=" AND SD31.D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND SD31.D3_LOCAL='80'"
_cquery+=" AND SD31.D3_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+=" AND SD31.D3_COD LIKE 'MOD%'"
_cquery+=" AND SD31.D3_ESTORNO<>'S'"
_cquery+=" AND SD31.D3_OP= OP"
_cquery+=" AND ROWNUM = 1 AND SD31.D3_OBS=' ') NUMSEQ"
_cquery+=" FROM"
_cquery+=" (SELECT SD3.D3_OP OP, Sum(SD3.D3_QUANT) TOTHORA"
_cquery+=" FROM "+retsqlname("SD3")+" SD3"
_cquery+=" WHERE SD3.D_E_L_E_T_=' '"
_cquery+=" AND SD3.D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND SD3.D3_LOCAL='80'"
_cquery+=" AND ((SD3.D3_TM='610' AND SD3.D3_OBS LIKE ('MODIMP%')) OR (SD3.D3_TM='999'))"
_cquery+=" AND SD3.D3_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+=" AND SD3.D3_COD LIKE 'MOD%'"
_cquery+=" AND SD3.D3_ESTORNO<>'S'"
_cquery+=" AND SD3.D3_OP BETWEEN '"+_opini+"' AND '"+_opfim+"'"
_cquery+=" GROUP BY SD3.D3_OP"
_cquery+=" ORDER BY SD3.D3_OP)"

memowrit("/sql/vit309d.sql",_cquery)
tcquery _cquery new alias "TMP4"
tcsetfield("TMP4","TOTHORA","N",11,2)

tmp4->(dbgotop())
_tothrpi:=0

while !tmp4->(eof())
	_tothrpi+=tmp4->tothora //Total de Hora Produtiva + Hora Improdutiva
	tmp4->(dbskip())
end
//alert(_tothrpi)

tmp1->(dbgotop())
_tothrtrab:=0
_vlrcc:=0

while !tmp1->(eof())
	if tmp1->clascc=='2'
		_cc:=tmp1->cc
		_vlrcc=_somact2(_cc)
		_tothrtrab=tmp1->hrsatrab
		
		/*apropriando as horas por centro de custo indireto
		  alterado em 29/09/08 por Reuber - Há um backup com
		  a forma anterior*/
		  
		_vlunhrind:= (_vlrcc/_tothrtrab) //Valor Unitario Hora Indireta
		
		tmp4->(dbgotop())
		dbselectarea("SD3")
		while !tmp4->(eof())
			
			sd3->(dbordernickname("SD3VIT03")) // Filial + OP + Local + Num.Seq.
			if sd3->(dbseek(_cfilsd3+tmp4->op+"80"+tmp4->numseq))
				
				// Lanca Mao de Obra Indireta
				// Cria Array com todos os campos do SD3
				aSD3 := array(fCount())
				for i:=1 to FCount()
					aSD3[i] := fieldget(i)
				next
				
//				cmov:= "611" //Mov.int valorizada
				cmov:= "610" //Mov.int nao valorizada
				RecLock("SD3",.t.)
				
				for i:=1 to FCount()
					fieldput(i,aSD3[i])
				next
//				replace d3_cod      with "MODI-PRODUCAO"
				replace d3_cod      with "MOD"+_cc
				replace d3_obs      with "MO Indireta "+_cc
				replace d3_tm       with cmov
				replace d3_um       with "HR"
				replace d3_quant    with (tmp4->tothora/_tothrpi)*_tothrtrab
//				replace d3_cf       with "RE6" 
				replace d3_cf       with "RE0" 
				replace d3_ident    with " "
				replace d3_nivel    with " "
				replace d3_stserv   with "1"					
				replace d3_custo1   with ((tmp4->tothora/_tothrpi)*_tothrtrab)*_vlunhrind
				replace d3_parctot  with " "
				replace d3_tipo     with "MO"
				replace d3_chave    with "E0"
				replace d3_segum    with "HR"
				replace d3_qtsegum  with (tmp4->tothora/_tothrpi)*_tothrtrab
//				replace d3_obs	  with "MODI-PROD"
				MSUnlock()
			endif
			tmp4->(dbskip())
		end
	endif
	tmp1->(dbskip())
end

tmp4->(dbclosearea())
tmp1->(dbclosearea())
sd3->(dbclosearea())

return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Mes                ?","mv_ch1","C",02,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ano                ?","mv_ch2","C",04,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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



/*GERANDO HORAS POR CENTRO DE CUSTOS*/
static function _gerahoras()
procregua(1)

incproc("Selecionando Horas por CC...")

_cquery:=" SELECT CC,"
_cquery+=" CLASCC,"
_cquery+=" Sum(HORASATRAB) HRSATRAB,"
_cquery+=" (SELECT Sum(SD3.D3_QUANT) FROM "+ retsqlname("SD3")+" SD3 "
_cquery+="   WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_FILIAL='"+_cfilsd3+"'"
_cquery+="   AND SD3.D3_COD = 'MOD'||CC AND SD3.D3_LOCAL='80'"
_cquery+="   AND SD3.D3_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+="   AND SD3.D3_OP BETWEEN '"+_opini+"' AND '"+_opfim+"' AND SD3.D3_ESTORNO <> 'S') HORASOPS"
_cquery+=" FROM ("
_cquery+=" SELECT DISTINCT(SRD.RD_MAT) MAT,"
_cquery+="        SRA.RA_ADMISSA ADMISSAO,"
_cquery+="        SRA.RA_TNOTRAB TURNO,"
_cquery+="        SRD.RD_CC CC,"
_cquery+="        CTT.CTT_CLASCC CLASCC,"
_cquery+="        RCG_DIAMES ANOMESDIA,"
_cquery+="        To_Char(To_Date(RCG_DIAMES,'YYYYMMDD'),'D') DIASEMANA,"
_cquery+="        RCG_TIPDIA TIPODIA,"
_cquery+="        CASE"
_cquery+="          WHEN RCG_TIPDIA = 4 THEN 0"
_cquery+="        ELSE"
_cquery+="          (SELECT SPJ1.PJ_HRTOTAL-SPJ1.PJ_HRSINT1 FROM "+ retsqlname("SPJ")+" SPJ1"
_cquery+="           WHERE SPJ1.D_E_L_E_T_ = ' ' AND SPJ1.PJ_DIA = To_Char(To_Date(RCG_DIAMES,'YYYYMMDD'),'D')"
_cquery+="           AND SPJ1.PJ_TURNO = SRA.RA_TNOTRAB AND SPJ1.PJ_SEMANA = '01')"
_cquery+="        END HORASATRAB"
_cquery+=" FROM "+retsqlname("SRD")+" SRD,"
_cquery+="      "+retsqlname("SRA")+" SRA,"
_cquery+="      "+retsqlname("RCG")+" RCG,"
_cquery+="      "+retsqlname("CTT")+" CTT"
_cquery+=" WHERE"
_cquery+="     RCG.D_E_L_E_T_ = ' '"
_cquery+=" AND SRA.D_E_L_E_T_ = ' '"
_cquery+=" AND SRD.D_E_L_E_T_ = ' '"
_cquery+=" AND CTT.D_E_L_E_T_ = ' '"
_cquery+=" AND CTT.CTT_CLASCC BETWEEN '1' AND '2'"
_cquery+=" AND SRD.RD_MAT = SRA.RA_MAT"
_cquery+=" AND CTT.CTT_CUSTO = SRD.RD_CC"
_cquery+=" AND SRD.RD_DATARQ = '"+mv_par02+mv_par01+"'"
_cquery+=" AND RCG.RCG_DIAMES >= SRA.RA_ADMISSA"
_cquery+=" AND RCG.RCG_MES = '"+mv_par01+"' AND RCG.RCG_ANO = '"+mv_par02+"'"
//_cquery+=" AND SRA.RA_CC IN ('29050101 ','29050000 ')"
_cquery+=" ORDER BY SRD.RD_MAT,RCG.RCG_DIAMES)"
_cquery+=" GROUP BY CLASCC, CC"
_cquery+=" ORDER BY CLASCC, CC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
memowrit("/sql/vit309.sql",_cquery)
tcsetfield("TMP1","HRSATRAB","N",8,2)
tcsetfield("TMP1","HORASOPS","N",8,2)

return()




/*GERA SOMA CT2 POR CENTRO DE CUSTO*/
static function _somact2(_ct2cc)

procregua(1)
incproc("Somando CT2 por CC...")

_cquery:=" SELECT CLASCC, CC, Sum(VALOR) TOTCC FROM ("
_cquery+=" SELECT CT2_CREDIT CONTA,"
_cquery+=" VLRCREDITO VALOR,CT2_CCC CC,CLASCRED CLASCC FROM (SELECT"
_cquery+=" CT2.CT2_DC,"
_cquery+=" CT2.CT2_DEBITO,"
_cquery+=" CT2.CT2_CREDIT,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END VLRCREDITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END VLRDEBITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END +"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END SALDO,"
_cquery+=" CT2.CT2_CCC,"
_cquery+=" CTTA.CTT_CLASCC CLASCRED,"
_cquery+=" CT2.CT2_CCD,"
_cquery+=" CTTB.CTT_CLASCC CLASDEB"
_cquery+=" FROM CT2010 CT2"
_cquery+=" LEFT JOIN CTT010 CTTA ON  CT2.CT2_CCC    = CTTA.CTT_CUSTO"
_cquery+=" LEFT JOIN CTT010 CTTB ON  CT2.CT2_CCD    = CTTB.CTT_CUSTO"
_cquery+=" WHERE CT2.CT2_DATA BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+=" AND CT2.D_E_L_E_T_ = ' '"
_cquery+=" AND CT2.CT2_LOTE NOT IN ('311206')"
//_cquery+=" AND CT2.CT2_LOTE NOT IN ('311206','008840')"
_cquery+=" AND CT2.CT2_CCC='"+_ct2cc+"'"
_cquery+=" AND CTTA.D_E_L_E_T_ = ' ')"
//_cquery+=" AND CTTB.D_E_L_E_T_ = ' ')"
_cquery+=" WHERE CT2_CREDIT LIKE '3%'"

_cquery+=" UNION ALL"

_cquery+=" SELECT CT2_DEBITO CONTA,"
_cquery+="        VLRDEBITO VALOR,CT2_CCD CC,CLASDEB CLASCC FROM (SELECT"
_cquery+=" CT2.CT2_DC,"
_cquery+=" CT2.CT2_DEBITO,"
_cquery+=" CT2.CT2_CREDIT,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END VLRCREDITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END VLRDEBITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END +"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END SALDO,"
_cquery+=" CT2.CT2_CCC,"
_cquery+=" CTTA.CTT_CLASCC CLASCRED,"
_cquery+=" CT2.CT2_CCD,"
_cquery+=" CTTB.CTT_CLASCC CLASDEB"
_cquery+=" FROM CT2010 CT2"
_cquery+=" LEFT JOIN CTT010 CTTA ON  CT2.CT2_CCC    = CTTA.CTT_CUSTO"
_cquery+=" LEFT JOIN CTT010 CTTB ON  CT2.CT2_CCD    = CTTB.CTT_CUSTO"
_cquery+=" WHERE CT2.CT2_DATA BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+=" AND CT2.D_E_L_E_T_ = ' '"
_cquery+=" AND CT2.CT2_LOTE NOT IN ('311206')"
//_cquery+=" AND CT2.CT2_LOTE NOT IN ('311206','008840')"
_cquery+=" AND CT2.CT2_CCD='"+_ct2cc+"'"
_cquery+=" AND CTTA.D_E_L_E_T_ = ' ')"
//_cquery+=" AND CTTB.D_E_L_E_T_ = ' ')"
_cquery+=" WHERE CT2_DEBITO LIKE '3%'"

_cquery+=" AND VLRDEBITO > 0"
_cquery+=" ORDER BY CC,CONTA"
_cquery+=" )"
_cquery+=" WHERE CLASCC IN ('1','2')"
_cquery+=" GROUP BY CLASCC,CC"
_cquery+=" ORDER BY CLASCc,CC"

_cquery:=changequery(_cquery)
memowrit("/sql/vit309a.sql",_cquery)
tcquery _cquery new alias "TMP2"
tcsetfield("TMP2","TOTCC","N",15,2)

tmp2->(dbgotop())
_totcc:=tmp2->totcc

tmp2->(dbclosearea())

return(_totcc)

/*********************************************************************************************/
static function lanc_erro()

procregua(1)
incproc("Verificando Inconsistências")

_cquery:=" SELECT CLASCC, CC, Sum(VALOR) TOTCC FROM ("
_cquery+=" SELECT CT2_CREDIT CONTA,"
_cquery+=" VLRCREDITO VALOR,CT2_CCC CC,CLASCRED CLASCC FROM (SELECT"
_cquery+=" CT2.CT2_DC,"
_cquery+=" CT2.CT2_DEBITO,"
_cquery+=" CT2.CT2_CREDIT,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END VLRCREDITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END VLRDEBITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END +"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END SALDO,"
_cquery+=" CT2.CT2_CCC,"
_cquery+=" CTTA.CTT_CLASCC CLASCRED,"
_cquery+=" CT2.CT2_CCD,"
_cquery+=" CTTB.CTT_CLASCC CLASDEB"
_cquery+=" FROM CT2010 CT2"
_cquery+=" LEFT JOIN CTT010 CTTA ON  CT2.CT2_CCC    = CTTA.CTT_CUSTO"
_cquery+=" LEFT JOIN CTT010 CTTB ON  CT2.CT2_CCD    = CTTB.CTT_CUSTO"
_cquery+=" WHERE CT2.CT2_DATA BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+=" AND CT2.D_E_L_E_T_ = ' '"
_cquery+=" AND CT2.CT2_LOTE <> '311206'"
_cquery+=" AND CTTA.D_E_L_E_T_ = ' '"
_cquery+=" AND CTTB.D_E_L_E_T_ = ' ')"
_cquery+=" WHERE CT2_CREDIT LIKE '35%'"

_cquery+=" UNION ALL"

_cquery+=" SELECT CT2_DEBITO CONTA,"
_cquery+="        VLRDEBITO VALOR,CT2_CCD CC,CLASDEB CLASCC FROM (SELECT"
_cquery+=" CT2.CT2_DC,"
_cquery+=" CT2.CT2_DEBITO,"
_cquery+=" CT2.CT2_CREDIT,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END VLRCREDITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END VLRDEBITO,"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('2','3') THEN CT2_VALOR*(-1)"
_cquery+="   ELSE"
_cquery+="   0 END +"
_cquery+=" CASE"
_cquery+="   WHEN CT2_DC IN ('1','3') THEN CT2_VALOR"
_cquery+="   ELSE"
_cquery+="   0 END SALDO,"
_cquery+=" CT2.CT2_CCC,"
_cquery+=" CTTA.CTT_CLASCC CLASCRED,"
_cquery+=" CT2.CT2_CCD,"
_cquery+=" CTTB.CTT_CLASCC CLASDEB"
_cquery+=" FROM CT2010 CT2"
_cquery+=" LEFT JOIN CTT010 CTTA ON  CT2.CT2_CCC    = CTTA.CTT_CUSTO"
_cquery+=" LEFT JOIN CTT010 CTTB ON  CT2.CT2_CCD    = CTTB.CTT_CUSTO"
_cquery+=" WHERE CT2.CT2_DATA BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
_cquery+=" AND CT2.D_E_L_E_T_ = ' '"
_cquery+=" AND CT2.CT2_LOTE <> '311206'"
_cquery+=" AND CTTA.D_E_L_E_T_ = ' '"
_cquery+=" AND CTTB.D_E_L_E_T_ = ' ')"
_cquery+=" WHERE CT2_DEBITO LIKE '35%'"

_cquery+=" AND VLRDEBITO > 0"
_cquery+=" ORDER BY CC,CONTA"
_cquery+=" )"
_cquery+=" WHERE CLASCC NOT IN ('1','2')"
_cquery+=" GROUP BY CLASCC,CC"
_cquery+=" ORDER BY CLASCc,CC"

_cquery:=changequery(_cquery)
memowrit("/sql/vit309b.sql",_cquery)
tcquery _cquery new alias "TMP5"
tcsetfield("TMP5","TOTCC","N",15,2)

vhalanc:=.f.
tmp5->(dbgotop())
do while !eof() 
	if tmp5->cc <> ' ' .and. totcc <> 0
	   if vhalanc = .f.
		  alert("Há lançamento(s) no grupo 35 de centro de custo não classificado como Direto ou Indireto")
		  vhalanc :=.t.
	   endif	  
	endif   
    alert("Centro de custo "+tmp5->cc+" não está classificado como Custo Direto ou Custo Indireto")
    dbskip()
enddo
tmp5->(dbclosearea())
return(!vhalanc)
/*********************************************************************************************/
