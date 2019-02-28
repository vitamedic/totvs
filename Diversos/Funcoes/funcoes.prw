/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FUNCOES  ³ Autor ³ Heraildo C. de Freitas³ Data ³ 14/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcoes de Uso Geral                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ SETFIELD ³ Autor ³ Heraildo C. de Freitas³ Data ³ 14/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Executa a Funcao TCSETFIELD para o Alias Informado para os ³±±
±±³          ³ Campos Presentes no Dicionario de Dados                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_SETFIELD(CALIAS)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ CALIAS - alias da tabela temporaria gerada pela TCQUERY    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "Ap5Mail.ch"
#include "tbicode.ch"
#include "dialog.ch"
#INCLUDE "protheus.ch"

user function setfield(_calias)
	local _ni
	local _ccampo

	if select(_calias)<>0
		for _ni:=1 to (_calias)->(fcount())
			_ccampo:=upper(alltrim((_calias)->(fieldname(_ni))))
			sx3->(dbsetorder(2))
			if sx3->(dbseek(_ccampo)) .and.;
					sx3->x3_tipo$"DN"
			
				tcsetfield(_calias,_ccampo,sx3->x3_tipo,sx3->x3_tamanho,sx3->x3_decimal)
			endif
		next
	endif
return()


user function pergsx1()
	local _ni

	for _ni:=1 to len(_agrpsx1)
		if ! sx1->(dbseek(padr(_agrpsx1[_ni,1],len(sx1->x1_grupo))+_agrpsx1[_ni,2]))
			sx1->(reclock("SX1",.t.))
			sx1->x1_grupo  :=_agrpsx1[_ni,01]
			sx1->x1_ordem  :=_agrpsx1[_ni,02]
			sx1->x1_pergunt:=_agrpsx1[_ni,03]
			sx1->x1_variavl:=_agrpsx1[_ni,04]
			sx1->x1_tipo   :=_agrpsx1[_ni,05]
			sx1->x1_tamanho:=_agrpsx1[_ni,06]
			sx1->x1_decimal:=_agrpsx1[_ni,07]
			sx1->x1_presel :=_agrpsx1[_ni,08]
			sx1->x1_gsc    :=_agrpsx1[_ni,09]
			sx1->x1_valid  :=_agrpsx1[_ni,10]
			sx1->x1_var01  :=_agrpsx1[_ni,11]
			sx1->x1_def01  :=_agrpsx1[_ni,12]
			sx1->x1_cnt01  :=_agrpsx1[_ni,13]
			sx1->x1_var02  :=_agrpsx1[_ni,14]
			sx1->x1_def02  :=_agrpsx1[_ni,15]
			sx1->x1_cnt02  :=_agrpsx1[_ni,16]
			sx1->x1_var03  :=_agrpsx1[_ni,17]
			sx1->x1_def03  :=_agrpsx1[_ni,18]
			sx1->x1_cnt03  :=_agrpsx1[_ni,19]
			sx1->x1_var04  :=_agrpsx1[_ni,20]
			sx1->x1_def04  :=_agrpsx1[_ni,21]
			sx1->x1_cnt04  :=_agrpsx1[_ni,22]
			sx1->x1_var05  :=_agrpsx1[_ni,23]
			sx1->x1_def05  :=_agrpsx1[_ni,24]
			sx1->x1_cnt05  :=_agrpsx1[_ni,25]
			sx1->x1_f3     :=_agrpsx1[_ni,26]
			sx1->(msunlock())
		endif
	next
return()