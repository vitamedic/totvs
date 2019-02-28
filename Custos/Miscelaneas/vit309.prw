#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VIT309     ³ Autor ³ Claudio Ferreira    ³ Data ³ 12/12/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Nova rotina de apropriação das MO´s                        ³±±
±±³            Foi eliminado tratamento redundante de apropriação das     ³±±
±±³            MO´s improdutivas. Mantido apenas a apropiação MO Indiretas³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico para VITAPAN                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function vit309()
Private oDlg
cperg	:= "PERGVIT309"
_pergsx1()
pergunte(cperg,.f.)

@ 00,000 TO 227,463 DIALOG oDlg TITLE "Calculo / Atualização dos custos das OP´s (Novo)"
@ 08,010 TO 84,222
@ 23,16 SAY OemToAnsi("Este programa Gera os lancamentos dos indiretos para cada OP")
@ 33,16 SAY OemToAnsi("dentro do periodo (SD3)")
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

ct1->(dbsetorder(1)) //Filial + Conta
ct2->(dbsetorder(1)) //Filial + Data
ctt->(dbsetorder(1)) //Filial + CC
sd3->(dbsetorder(7)) //Filial + Codigo + Local + Dt.Emissao + Num.Seq.

if _dtfim < _dtfecha
	msgstop("Data para gerar Apropriação das Mão anterior a do ultimo fechamento!")
	return
endif

/*CASO JA EXISTA CALCULO EFETUADO IRA EXCLUIR OS LANCAMENTOS DO SD3 REFERENTE A MAO DE OBRA IMPRODUTIVA E INDIRETA*/
#IFDEF TOP
	procregua(1)
	incproc("Excluindo lançamentos caso existam")
	cProcedure:="DELMODI"
	If ExistProc( cProcedure )
		TCSPEXEC( xProcedures(cProcedure),mv_par02+mv_par01)
	endif
#ENDIF
                        
processa({|| u__gerahoras(_dtini,_dtfim)})
tmp1->(dbgotop())

while ! tmp1->(eof())  
	_cc:=tmp1->cc
	_tothrtrab=u__gerahrcc(_cc,_dtfim)
	_hrimprod:=(_tothrtrab - tmp1->horasops)
	if tmp1->clascc='1' .and. _hrimprod > 0
		
		procregua(1)
		incproc("Somando OP por CC - "+_cc)
		
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
				RecLock("SD3",.f.)
				replace d3_qtsegum  with (d3_quant/tmp1->horasops)*_hrimprod
				MSUnlock()
			endif
			tmp3->(dbskip())
		end
		
		sd3->(dbclosearea())
		
		tmp3->(dbclosearea())
	endif
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

// PROCESSA MAO DE OBRA INDIRETA

procregua(1)
incproc("Somando HR MOD ...")

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
_cquery+=" (SELECT SD3.D3_OP OP, Sum(SD3.D3_QUANT+SD3.D3_QTSEGUM) TOTHORA"
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
	_tothrpi+=tmp4->tothora //Total de Hora 
	tmp4->(dbskip())
end

dbSelectArea('CTT')
procregua(CTT->(RecCount()))
CTT->(dbgotop())
_tothrtrab:=0
_vlrcc:=0
_cc:=''
while !CTT->(eof()) 
	if CTT->CTT_CLASCC=='2'
	    _cc:=CTT->CTT_CUSTO 
		incproc("Somando HR MOD ..."+_cc)
		_tothrtrab=u__gerahrcc(_cc,_dtfim)
				
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
				
				cmov:= "610" //Mov.int nao valorizada
				RecLock("SD3",.t.)
				
				for i:=1 to FCount()
					fieldput(i,aSD3[i])
				next
				replace d3_cod      with "MOD"+_cc
				replace d3_obs      with "MO Indireta "+_cc
				replace d3_tm       with cmov
				replace d3_um       with "HR"
				replace d3_quant    with (tmp4->tothora/_tothrpi)*_tothrtrab
				replace d3_cf       with "RE0" 
				replace d3_ident    with " "
				replace d3_nivel    with " "
				replace d3_stserv   with "1"					
				replace d3_custo1   with 0
				replace d3_parctot  with " "
				replace d3_tipo     with "MO"
				replace d3_chave    with "E0"
				replace d3_segum    with "HR"
				replace d3_qtsegum  with 0
				MSUnlock()
			endif
			tmp4->(dbskip())
		end
	else
	  incproc("Somando HR MOD ..."+_cc)	
	endif
	CTT->(dbskip())
end

tmp4->(dbclosearea())
Close(oDlg)
return        

/*GERANDO HORAS POR CENTRO DE CUSTOS*/
User function _gerahoras(_dtini,_dtfim) 
Local _cfilsd3:=xfilial("SD3")
procregua(1)

incproc("Selecionando Horas por CC...")

_cquery:=" SELECT CTT_CUSTO CC,CTT_CLASCC CLASCC,"
_cquery+=" (SELECT Sum(SD3.D3_QUANT) FROM "+ retsqlname("SD3")+" SD3 "
_cquery+="   WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_FILIAL='"+_cfilsd3+"'"
_cquery+="   AND SD3.D3_COD = 'MOD'||CTT_CUSTO AND SD3.D3_LOCAL='80'"
_cquery+="   AND SD3.D3_EMISSAO BETWEEN '"+dtos(_dtini)+"' AND '"+dtos(_dtfim)+"'"
//_cquery+="   AND SD3.D3_OP BETWEEN '"+_opini+"' AND '"+_opfim+"' AND SD3.D3_ESTORNO <> 'S') HORASOPS"      
_cquery+="   AND SD3.D3_ESTORNO <> 'S') HORASOPS"      
_cquery+=" FROM "+retsqlname("CTT")+" CTT"
_cquery+=" WHERE"
_cquery+=" CTT.D_E_L_E_T_ = ' ' AND CTT.CTT_BLOQ<>'1' "
_cquery+=" AND CTT.CTT_CLASCC BETWEEN '1' AND '2'  "
_cquery+=" GROUP BY CTT_CLASCC, CTT_CUSTO "
_cquery+=" ORDER BY CTT_CLASCC, CTT_CUSTO "

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
memowrit("/sql/vit309.sql",_cquery)
tcsetfield("TMP1","HORASOPS","N",8,2)

return()

/*GERANDO HORAS POR CENTRO DE CUSTOS*/
User function _gerahrcc(_cc,_dtRef)
procregua(1)

incproc("Selecionando Horas por CC...")

_cquery:=" SELECT Sum(HORASATRAB) HRSATRAB"
_cquery+=" FROM ("
_cquery+=" SELECT DISTINCT(SRA.RA_MAT) MAT,"
_cquery+="        220 HORASATRAB"
_cquery+=" FROM "+retsqlname("SRA")+" SRA "
_cquery+=" WHERE  SRA.D_E_L_E_T_ = ' '" 
_cquery+=" AND RA_ADMISSA<='"+dtos(_dtRef)+"' "
_cquery+=" AND (RA_DEMISSA=' ' OR RA_DEMISSA>'"+dtos(_dtRef)+"') "
_cquery+=" AND SRA.RA_CC = '"+_cc+"') "

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP6"
memowrit("/sql/vit309.sql",_cquery)   
nHoras:=tmp6->HRSATRAB
tmp6->(dbclosearea())
return(nHoras)


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
