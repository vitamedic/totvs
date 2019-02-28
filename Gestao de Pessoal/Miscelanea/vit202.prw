/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT202   ³ Autor ³ Gardenia              ³ Data ³ 18/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza Cadastro o SQL para DBF                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit202()
_cperg:="PERGVIT202"
_pergsx1()
if pergunte(_cperg,.t.) .and.;
	msgbox("Confirma o reajuste salarial?","Atencao","YESNO")
	processa({|| _converte()})
	msgstop("Reajuste efetuado com sucesso.")
endif
return

static function _converte()
//_cfiltro:=sx2->(dbfilter())
//sx2->(dbclearfil())
procregua(sx2->(lastrec()))
//sx2->(dbseek(mv_par01,.t.))
_cfilsrj:=xfilial("SRJ")
srj->(dbsetorder(1))

_cfilsra:=xfilial("SRA")
sra->(dbsetorder(7))
_cfilsr7:=xfilial("SR7")
sr7->(dbsetorder(1))
srj->(dbgotop())
while ! srj->(eof()) 
	if srj->rj_funcao <mv_par01 .or. srj->rj_funcao >mv_par02
		srj->(dbskip())
		loop
	endif	                                           
//	msgstop(srj->rj_funcao)
	_funcao:= srj->rj_funcao
	_salario:=srj->rj_salario
	_descfunc:=srj->rj_desc
	sra->(dbseek(_cfilsra+_funcao))
	while ! sra->(eof()) .and. sra->ra_codfunc == _funcao
		if sra->ra_sitfolh=="D" 
			sra->(dbskip())
		endif
		_mat:=sra->ra_mat
		sra->(reclock("SRA",.f.))
		sra->ra_salario:=_salario
		msgstop:=sra->ra_salario
		_mat:=sra->ra_mat
		sra->(msunlock())
		dbselectarea("SR7")
 		sr7->(dbappend())
      sr7->r7_filial:="01"
      sr7->r7_mat:=_mat
      sr7->r7_data:=ddatabase
      sr7->r7_funcao:=_funcao
      sr7->r7_descfun:=_descfunc
      sr7->r7_tipo:="003"    
      sr7->r7_tipopgt:="M"
      sr7->r7_catfunc:="M"	
      sr7->r7_usuario:="Sistema"	
	   sr7->(dbclosearea())
		dbselectarea("SR3")
 		sr3->(dbappend())
      sr3->r3_filial:="01"
      sr3->r3_mat:=_mat
      sr3->r3_data:=ddatabase
      sr3->r3_tipo:="003"    
      sr3->r3_pd:="000"
      sr3->r3_descpd:="SALARIO BASE"	
      sr3->r3_valor:=_salario	
	   sr3->(dbclosearea())
		dbselectarea("SRA")
		sra->(dbskip())
	end	
	srj->(dbskip())
end
//sx2->(dbsetfilter({|| _cfiltro},_cfiltro))
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da funcao          ?","mv_ch1","C",04,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a funcao       ?","mv_ch2","C",04,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
