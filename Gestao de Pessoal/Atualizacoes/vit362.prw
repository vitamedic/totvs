/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT362   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 23/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calcula Indicadores Sobre Horas na Administracao de        ³±±
±±³          ³ Pessoal Gerando a Tabela SZV                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vit362()
cperg:="PERGVIT362"
_pergsx1()

pergunte(cperg,.t.) 

_folmes:=getmv("MV_FOLMES")
_periodo:=mv_par02+mv_par01

if mv_par03==1 
	if _periodo<_folmes	
		if msgyesno("Confirma Processamento para Gerar Dados para "+mv_par01+"/"+mv_par02+" ?")
			processa({|| _gerszv()})
		endif	
	else 
		msgstop("O Periodo "+mv_par01+"/"+mv_par02+" ainda nao foi encerrado. Providenciar fechamento da folha antes de executar a rotina!")
	endif
else
	if msgyesno("Confirma Exportacao de Dados "+mv_par01+"/"+mv_par02+" para Excel?")
		processa({|| _expszv()})	
	endif
endif                          

return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GERSZV   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 23/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ EXECUTA STORED PROCEDURE PARA GERAR DADOS NA TABELA        ³±±
±±³          ³ SZV CONFORME PARAMETROS                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA VITAPAN                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function _gerszv()
_cfilszv:=xfilial("SZV")

procregua(1)
incproc("Executando Procedure para Calculo...")

_panome:=mv_par02+mv_par01
_anomes:=mv_par01+"/"+mv_par02

#IFDEF TOP
	lQuery  := .T.
	tmp2 := GetNextAlias()
	BeginSql Alias tmp2
		SELECT
		ZV_MESANO MESANO, ZV_CC CC, ZV_DESCCC DESCCC, ZV_HRPREVI HRPREVI, ZV_HRFALTA HRFALTA, ZV_HREXTRA HREXTRA, ZV_HRTRABA HRTRABA, ZV_HRABONA HRABONA,
		ZV_HRFERIA HRFERIA, ZV_HRAFAST HRAFAST, ZV_CODGER CODGER, ZV_GERENC GERENC, ZV_HRATEST HRATEST, ZV_HRAFEMP HRAFEMP, ZV_HRAFINS HRAFINS		
		FROM  %Table:SZV% SZV
		WHERE
		SZV.%NotDel%
  		AND ZV_FILIAL=%Exp:_cfilszv%
		AND SZV.ZV_MESANO IN (%Exp:_anomes%)
		ORDER BY SZV.ZV_CC
	EndSql

#ENDIF

(tmp2)->(dbgotop())

if !empty((tmp2)->mesano)
	if !msgyesno("O periodo informado ja foi processado. Deseja reprocessar "+mv_par01+"/"+mv_par02+" ?")
		return()
	endif
endif

#IFDEF TOP
	cProcedure:="GERARSZV"
	If ExistProc( cProcedure )
		TCSPEXEC( xProcedures(cProcedure),"01",_panome)
		msgstop("Processo Finalizado")
	endif
#ENDIF

return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ EXPSZV   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 23/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ ORGANIZA DADOS DA TABELA SZV PARA GERAR PLANILHA COM OS    ³±±
±±³          ³ INDICADORES EM EXCEL                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA VITAPAN                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function _expszv()
_cfilszv:=xfilial("SZV")

procregua(1)
incproc("Exportando Dados SZV para Excel...")

//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

_aCabec := {}
_aDados := {}
_aSaldo := {}
_anomes:=mv_par01+"/"+mv_par02

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

_aCabec := {"PERIODO","CC","DESCRICAO CC","PREVISTAS","FALTAS (H)","EXTRAS","TRABALHADAS","ABONADAS","FERIAS (H)", "AFASTAM.(H)", "AFASTAM. (H EMP)", "AFASTAM. (H INSS)","ATESTADOS (H)", "GERENCIA", "DESCRICAO GERENCIA"}

#IFDEF TOP
	lQuery  := .T.
	tmp1 := GetNextAlias()
	BeginSql Alias tmp1
		SELECT
		ZV_MESANO MESANO, ZV_CC CC, ZV_DESCCC DESCCC, ZV_HRPREVI HRPREVI, ZV_HRFALTA HRFALTA, ZV_HREXTRA HREXTRA, ZV_HRTRABA HRTRABA, ZV_HRABONA HRABONA,
		ZV_HRFERIA HRFERIA, ZV_HRAFAST HRAFAST, ZV_CODGER CODGER, ZV_GERENC GERENC, ZV_HRATEST HRATEST, ZV_HRAFEMP HRAFEMP, ZV_HRAFINS HRAFINS		
		FROM  %Table:SZV% SZV
		WHERE
		SZV.%NotDel%
  		AND ZV_FILIAL=%Exp:_cfilszv%
		AND SZV.ZV_MESANO IN (%Exp:_anomes%)
		ORDER BY SZV.ZV_CC
	EndSql

#ENDIF

(tmp1)->(dbgotop())

if !empty((tmp1)->mesano)
	While !(tmp1)->(Eof())         
		AAdd(_aDados, {(tmp1)->mesano, (tmp1)->cc, (tmp1)->desccc, (tmp1)->hrprevi, (tmp1)->hrfalta, (tmp1)->hrextra, (tmp1)->hrtraba, (tmp1)->hrabona, (tmp1)->hrferia, (tmp1)->hrafast, (tmp1)->hrafemp, (tmp1)->hrafins, (tmp1)->hratest, (tmp1)->codger, (tmp1)->gerenc})
		(tmp1)->(dbSkip())
	End
	DlgToExcel({ {"ARRAY", "INDICADORES HORAS "+mv_par01+"/"+mv_par02, _aCabec, _aDados} })
else
	msgstop("Dados nao gerados para periodo "+mv_par01+"/"+mv_par02+". Execute novamente a rotina com opcao Gerar Dados!")
endif

(tmp1)->(dbclosearea())

return()



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Mes de referencia  ?","mv_ch1","C",02,0,0,"G",'pertence("01#02#03#04#05#06#07#08#09#10#11#12")',"mv_par01" ,space(15)         ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ano de referencia  ?","mv_ch2","C",04,0,0,"G",space(60)                                        ,"mv_par02" ,space(15)         ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Processamento      ?","mv_ch3","N",01,0,0,"C",space(60)                                        ,"mv_par03" ,"Processar Dados" ,space(30),space(15),"Exportar Dados" ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
return()
