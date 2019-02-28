/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DEPARACC ³ Autor ³ Heraildo C. de Freitas³ Data ³ 30/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alteracao dos codigos dos centros de custo                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function deparacc()
if msgyesno("Confirma alteração do código dos centros de custo?")
	
	processa({|| _altera()})
	
	msginfo("Alteração concluída com sucesso!")
endif
return()

static function _altera()

dbusearea(.t.,,"\temp\deparacc","TMP1",.f.,.f.)

// CAMPOS DOS MODULOS DE QUALIDADE
_acampos:={}
aadd(_acampos,"QAA_CC    ")
aadd(_acampos,"QAB_CCD   ")
aadd(_acampos,"QAB_CCP   ")
aadd(_acampos,"QAD_CUSTO ")
aadd(_acampos,"QAE_DEPTO ")
aadd(_acampos,"QAF_DEPTO ")
aadd(_acampos,"QAG_DEPTO ")
aadd(_acampos,"QD0_DEPTO ")
aadd(_acampos,"QD1_DEPTO ")
aadd(_acampos,"QD1_DEPBX ")
aadd(_acampos,"QD2_DEPTO ")
aadd(_acampos,"QD4_DEPBX ")
aadd(_acampos,"QD8_DEPTO ")
aadd(_acampos,"QDD_DEPTOA")
aadd(_acampos,"QDG_DEPTO ")
aadd(_acampos,"QDH_DEPTOD")
aadd(_acampos,"QDH_DEPTOE")
aadd(_acampos,"QDJ_DEPTO ")
aadd(_acampos,"QDL_DEPTO ")
aadd(_acampos,"QDM_DEPTO ")
aadd(_acampos,"QDP_DEPTO ")
aadd(_acampos,"QDP_DEPBX ")
aadd(_acampos,"QDR_DEPRES")
aadd(_acampos,"QDR_DEPDE ")
aadd(_acampos,"QDR_DEPPAR")
aadd(_acampos,"QDS_DEPTO ")
aadd(_acampos,"QDS_DEPBX ")
aadd(_acampos,"QDT_DEPTO ")
aadd(_acampos,"QDU_DEPTO ")
aadd(_acampos,"QDU_DEPBX ")
aadd(_acampos,"QDZ_DEPTO ")
aadd(_acampos,"QF3_DEPTO ")
aadd(_acampos,"QI2_ORIDEP")
aadd(_acampos,"QI2_DESDEP")
aadd(_acampos,"QI2_MATDEP")
aadd(_acampos,"QM1_DISTR ")
aadd(_acampos,"QM2_DEPTO ")
aadd(_acampos,"QM9_DEPTO ")
aadd(_acampos,"QML_DEPTO ")
aadd(_acampos,"QMZ_LOCAL ")
aadd(_acampos,"QUH_CCUSTO")
aadd(_acampos,"QUM_CCUSTO")

procregua(0)

sx3->(dbsetorder(3))
sx3->(dbseek("004")) // GRUPO DE CAMPOS DO CENTRO DE CUSTO
while ! sx3->(eof()) .and.;
	sx3->x3_grpsxg=="004"
	
	_ctabela:=retsqlname(sx3->x3_arquivo)
	
	if sx3->x3_arquivo<>"CTT" .and.;
		tccanopen(_ctabela)
	
		tmp1->(dbgotop())
		while ! tmp1->(eof())
			
			incproc(alltrim(tmp1->decc)+" -> "+alltrim(tmp1->paracc)+" - "+_ctabela+" - "+sx3->x3_campo)
			
			_cupdate:=" UPDATE "
			_cupdate+=  _ctabela
			_cupdate+=" SET "
			_cupdate+=  alltrim(sx3->x3_campo)+"='"+tmp1->paracc+"'"
			_cupdate+=" WHERE "
			_cupdate+=" D_E_L_E_T_=' ' AND "
			_cupdate+=  alltrim(sx3->x3_campo)+"='"+tmp1->decc+"'"
			
			tcsqlexec(_cupdate)
			
			tmp1->(dbskip())
		end
	endif
	
	sx3->(dbskip())
end

for _ni:=1 to len(_acampos)
	
	sx3->(dbsetorder(2))
	sx3->(dbseek(_acampos[_ni]))
	
	_ctabela:=retsqlname(sx3->x3_arquivo)
	
	if tccanopen(_ctabela)
	
		tmp1->(dbgotop())
		while ! tmp1->(eof())
			
			incproc(alltrim(tmp1->decc)+" -> "+alltrim(tmp1->paracc)+" - "+_ctabela+" - "+sx3->x3_campo)
			
			_cupdate:=" UPDATE "
			_cupdate+=  _ctabela
			_cupdate+=" SET "
			_cupdate+=  alltrim(sx3->x3_campo)+"=SUBSTR("+alltrim(sx3->x3_campo)+",1,4)||'"+tmp1->paracc+"'"
			_cupdate+=" WHERE "
			_cupdate+=" D_E_L_E_T_=' ' AND "
			_cupdate+=  alltrim(sx3->x3_campo)+"=SUBSTR("+alltrim(sx3->x3_campo)+",1,4)||'"+tmp1->decc+"'"
			
			tcsqlexec(_cupdate)
			
			tmp1->(dbskip())
		end
	endif
next

// ARQUIVOS DE FECHAMENTO DA FOLHA DE PAGAMENTO
_nano:=2001
_nmes:=12
while _nano<=year(ddatabase)
	
	_ctabela:="RC"+sm0->m0_codigo+substr(strzero(_nano,4),3,2)+strzero(_nmes,2)
	
	if tccanopen(_ctabela)
		
		tmp1->(dbgotop())
		while ! tmp1->(eof())
			
			incproc(alltrim(tmp1->decc)+" -> "+alltrim(tmp1->paracc)+" - "+_ctabela+" - RC_CC")
			
			_cupdate:=" UPDATE "
			_cupdate+=  _ctabela
			_cupdate+=" SET "
			_cupdate+=" RC_CC='"+tmp1->paracc+"'"
			_cupdate+=" WHERE "
			_cupdate+=" D_E_L_E_T_=' ' AND "
			_cupdate+=" RC_CC='"+tmp1->decc+"'"
			
			tcsqlexec(_cupdate)
			
			tmp1->(dbskip())
		end
	endif
	
	if _nmes==12
		_nmes:=1
		_nano++
	else
		_nmes++
	endif
end

tmp1->(dbclosearea())
return()
