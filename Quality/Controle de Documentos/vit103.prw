#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT103   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 11/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Republicacao de Documentacao (Controle de Documentos) com  ³±±
±±³          ³ Alteracao nas Datas de Finalizacao e Distribuicao           ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function vit103()

cperg	:= "PERGVIT103"
_pergsx1()
pergunte(cperg,.f.)

@ 00,000 TO 227,463 DIALOG oDlg TITLE "Republicação de Documento Finalizado"
@ 08,010 TO 84,222
@ 23,16 SAY OemToAnsi("Este programa refaz a publicacao de um Documento ja finaliza-")
@ 33,16 SAY OemToAnsi("do a partir de uma nova data de Distribuicao informada.")
@ 91,140 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return



Static Function OkProc()
Processa( {|| RunProc() } )
Return


Static Function RunProc()

_cfilqdh:=xfilial("QDH")
_cfilqd1:=xfilial("QD1")
_cfilqd4:=xfilial("QD4")

qdh->(dbsetorder(1)) //Filial + Documento + Revisão
qd1->(dbsetorder(4)) //Filial + Documento + Revisão + Data Gera + Hora Gera
qd4->(dbsetorder(1)) //Filial + Documento + Revisão + Seqüência

qdh->(dbseek(xfilial("QDH")+ mv_par01 + mv_par02))
if alltrim(qdh->qdh_status)=="L"

	processa({|| _querys()})
	tmp1->(dbgotop())

	processa({|| _query2()})
	tmp2->(dbgotop())
	_numcriticas:=val(tmp2->numcriticas)
	tmp2->(dbclosearea())

	_novadtgera:=mv_par03
	_novadtbaix:=mv_par03
	
	_tppend:=""
	_tpdist:=""
	_dtgera:=ctod("  /  /  ")
	_dtbaix:=ctod("  /  /  ")

	while ! tmp1->(eof())

		if  (alltrim(tmp1->tppend)=="L" .or. alltrim(tmp1->tppend)=="I") .and.;
			tmp1->tpdist=="2"

			qd1->(dbseek(_cfilqd1+tmp1->docto+tmp1->rv+dtos(tmp1->dtgera)+tmp1->hrgera))

			qd1->(reclock("QD1",.f.))
			qd1->qd1_dtgera :=_novadtgera
			qd1->qd1_dtbaix :=_novadtbaix
			msunlock()       			

        elseif  alltrim(tmp1->tppend)=="L" .and.;
        		tmp1->tpdist=="1"

			qd1->(dbseek(_cfilqd1+tmp1->docto+tmp1->rv+dtos(tmp1->dtgera)+tmp1->hrgera))
			qd1->(reclock("QD1",.f.))
			qd1->qd1_dtgera :=_novadtgera
			msunlock()

        elseif  alltrim(tmp1->tppend)=="I" .and.;
        		tmp1->tpdist=="1"

			if  _tppend==tmp1->tppend .and.;
				_tpdist==tmp1->tpdist .and.;
				_dtgera==tmp1->dtgera .and.;
				_dtbaix==tmp1->dtbaix
				
				qd1->(dbseek(_cfilqd1+tmp1->docto+tmp1->rv+dtos(tmp1->dtgera)+tmp1->hrgera))
				qd1->(reclock("QD1",.f.))
				qd1->qd1_dtgera :=_novadtgera
				qd1->qd1_dtbaix :=_novadtbaix
				msunlock()       
			else
				_tppend:=tmp1->tppend
				_tpdist:=tmp1->tpdist
				_dtgera:=tmp1->dtgera
				_dtbaix:=tmp1->dtbaix
		
				_novadtgera:=_novadtgera-1
				qd1->(dbseek(_cfilqd1+tmp1->docto+tmp1->rv+dtos(tmp1->dtgera)+tmp1->hrgera))
				qd1->(reclock("QD1",.f.))
				qd1->qd1_dtgera :=_novadtgera
				qd1->qd1_dtbaix :=_novadtbaix
				msunlock()       
			endif
		else
			if  _tppend==tmp1->tppend .and.;
				_tpdist==tmp1->tpdist .and.;
				_dtgera==tmp1->dtgera .and.;
				_dtbaix==tmp1->dtbaix
	
				qd1->(dbseek(_cfilqd1+tmp1->docto+tmp1->rv+dtos(tmp1->dtgera)+tmp1->hrgera))		
				qd1->(reclock("QD1",.f.))
				qd1->qd1_dtgera :=_novadtgera
				qd1->qd1_dtbaix :=_novadtbaix
				msunlock()
			else			

				_tppend:=tmp1->tppend
				_tpdist:=tmp1->tpdist
				_dtgera:=tmp1->dtgera
				_dtbaix:=tmp1->dtbaix

				_novadtbaix:=_novadtbaix-1
				_novadtgera:=_novadtgera-1
        	
				if (alltrim(tmp1->tppend)=="EC" .or. alltrim(tmp1->tppend)=="DC")

					qd4->(dbseek(_cfilqd4+tmp1->docto+tmp1->rv+strzero(_numcriticas,20)))			
					qd4->(reclock("QD4",.f.))
					qd4->qd4_dtinic :=_novadtgera
					qd4->qd4_dtfim  :=_novadtbaix
					qd4->qd4_dtbaix :=_novadtbaix
					msunlock()				
					_numcriticas:=_numcriticas-1					
				endif

				qd1->(dbseek(_cfilqd1+tmp1->docto+tmp1->rv+dtos(tmp1->dtgera)+tmp1->hrgera))		
				qd1->(reclock("QD1",.f.))
				qd1->qd1_dtgera :=_novadtgera
				qd1->qd1_dtbaix :=_novadtbaix
				msunlock()
			endif
        endif
        		
		tmp1->(dbskip())
	end

	tmp1->(dbgotop())
                                                  
	if tmp1->rv > "000"                                 	
		_rvant:=strzero((val(tmp1->rv)-1),3)
		qdh->(dbseek(_cfilqdh+tmp1->docto+_rvant))		
		qdh->(reclock("QDH",.f.))
		qdh->qdh_dtlim := (mv_par03-1)
		msunlock()
	endif

	qdh->(dbseek(_cfilqdh+tmp1->docto+tmp1->rv))		
	qdh->(reclock("QDH",.f.))
	qdh->qdh_dtlim  := (mv_par03)+730
	qdh->qdh_dtvig  := mv_par03
	qdh->qdh_dtimpl := mv_par03		
	msunlock()
		
	tmp1->(dbclosearea())
	qd1->(dbclosearea())
	qdh->(dbclosearea())

else
	msgstop("O Documento: "+ mv_par01+" Rev.: "+ mv_par02+" nao foi Finalizado. Execute esta rotina somente apos a Distribuicao")
endif
	
return


/*BUSCA DADOS DAS FINALIZAÇÕES */
static function _querys()
procregua(1)

incproc("Selecionando Dados de Finalizacao...")

_cquery:=" SELECT"
_cquery+=" QD1_DOCTO DOCTO,"
_cquery+=" QD1_RV RV,"
_cquery+=" QD1_MAT MAT,"
_cquery+=" QD1_DTGERA DTGERA,"
_cquery+=" QD1_HRGERA HRGERA,"
_cquery+=" QD1_DTBAIX DTBAIX,"
_cquery+=" QD1_HRBAIX HRBAIX,"
_cquery+=" QD1_TPPEND TPPEND,"
_cquery+=" QD1_PENDEN PENDEN,"
_cquery+=" QD1_TPDIST TPDIST"
_cquery+=" FROM"
_cquery+="   "+retsqlname("QD1")+" QD1"
_cquery+=" WHERE"
_cquery+="   QD1.D_E_L_E_T_=' '"
_cquery+=" AND QD1_DOCTO='"+mv_par01+"'"
_cquery+=" AND QD1_RV='"+mv_par02+"'"
_cquery+=" ORDER BY QD1_DTGERA DESC, QD1_HRGERA DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DTGERA","D")
tcsetfield("TMP1","DTBAIX","D")

return()



static function _query2()
procregua(1)

incproc("Selecionando Criticas...")

_cquer2:=" SELECT Max(QD4_SEQ) NUMCRITICAS"
_cquer2+=" FROM "+retsqlname("QD4")+" QD4"
_cquer2+=" WHERE QD4.D_E_L_E_T_=' '"
_cquer2+=" AND QD4_DOCTO='"+mv_par01+"'"
_cquer2+=" AND QD4_RV='"+mv_par02+"'"

_cquer2:=changequery(_cquer2)

tcquery _cquer2 new alias "TMP2"

return()



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Documento          ?","mv_ch1","C",16,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QDH"})
aadd(_agrpsx1,{cperg,"02","Revisao            ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Nova Dt.Publicacao ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

