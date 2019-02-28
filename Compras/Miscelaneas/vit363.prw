/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT363   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 04/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Planilha Excel com Historico de Compras para Acompa-  ³±±
±±³          ³ nhamento de Indicadores                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit363()
_cperg:="PERGVIT363"
_pergsx1()

pergunte(_cperg,.t.) 

if msgyesno("Confirma Exportacao de Dados de "+dtoc(mv_par03)+" a "+dtoc(mv_par04)+" para Excel?")
	processa({|| _geraind()})	
endif

return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GERAIND  ³ Autor ³ Alex Junio de Miranda ³ Data ³ 04/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ EXECUTA QUERY PARA GERAR DADOS E EXPORTAR PARA EXCEL       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA VITAPAN                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function _geraind()
_cfilsd1:=xfilial("SD1")
_cfilsf4:=xfilial("SF4")
_cfilsb1:=xfilial("SB1")
_cfilsbm:=xfilial("SBM")
_cfilsc7:=xfilial("SC7")

procregua(1)
incproc("Executando Query para exportacao...")

#IFDEF TOP
	lQuery  := .T.
	tmp1 := GetNextAlias()
	BeginSql Alias tmp1
		SELECT
		SD1.D1_COD CODIGO, SB1.B1_DESC DESCRI, SD1.D1_GRUPO GRUPO, SBM.BM_DESC DESCGRUPO, SD1.D1_LOCAL ARM, SubStr(SD1.D1_DTDIGIT,1,4) ANO, 
		SubStr(SD1.D1_DTDIGIT,5,2) MES,Sum(SD1.D1_QUANT) QUANT, SD1.D1_UM UM, Sum(SD1.D1_TOTAL) VLRTOTAL, SC7.C7_MOEDA MOEDA, SB1.B1_UPRC ULTPRC
		FROM %Table:SD1% SD1
    		INNER JOIN %Table:SF4% SF4 ON (SF4.%NotDel% AND SF4.F4_FILIAL=%Exp:_cfilsf4% AND SF4.F4_CODIGO=SD1.D1_TES AND SF4.F4_DUPLIC='S' AND SF4.F4_ESTOQUE='S')
    		INNER JOIN %Table:SB1% SB1 ON (SB1.%NotDel% AND SB1.B1_FILIAL=%Exp:_cfilsb1% AND SB1.B1_COD=SD1.D1_COD)
    		INNER JOIN %Table:SBM% SBM ON (SBM.%NotDel% AND SBM.BM_FILIAL=%Exp:_cfilsbm% AND SD1.D1_GRUPO=SBM.BM_GRUPO)
    		LEFT JOIN  %Table:SC7% SC7 ON (SC7.%NotDel% AND SC7.C7_FILIAL=%Exp:_cfilsc7% AND SD1.D1_PEDIDO=SC7.C7_NUM AND SD1.D1_ITEMPC=SC7.C7_ITEM)
		WHERE 
		SD1.%NotDel%
		AND SD1.D1_COD BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND SD1.D1_DTDIGIT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND SD1.D1_TIPO='N'
		AND SD1.D1_GRUPO IN ('EA01','EA02','EA03','EA04','EA05','EA06','EE01','EE02','EE03','EE04','EE05','EE06','EE07','EN01','EN02','EN03','EN04','EN05','EN06','EN07','LA01','LA02','LA03','LA04','LA05','LA06','LA08','MA01','MA02','MA03','MA04','MA05','MA06','MK01','MK02','MK03','MP01','MP02','MP03')
		GROUP BY  SD1.D1_COD, SB1.B1_DESC, SD1.D1_GRUPO, SBM.BM_DESC, SD1.D1_LOCAL, SubStr(SD1.D1_DTDIGIT,1,4), SubStr(SD1.D1_DTDIGIT,5,2), SD1.D1_UM, SC7.C7_MOEDA, SB1.B1_UPRC
		ORDER BY SBM.BM_DESC, SB1.B1_DESC
	EndSql

#ENDIF

(tmp1)->(dbgotop())

procregua(1)
incproc("Exportando Dados para Excel...")

//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

_aCabec := {}
_aDados := {}
_aSaldo := {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

_aCabec := {"CODIGO","DESCRICAO","GRUPO","DESCRICAO GRUPO","ARMAZEM","MES","ANO","QUANT","UM", "VALOR TOTAL", "MOEDA", "ULTPRC"}

While !(tmp1)->(Eof())         
	AAdd(_aDados, {(tmp1)->codigo, (tmp1)->descri, (tmp1)->grupo, (tmp1)->descgrupo, (tmp1)->arm, (tmp1)->mes, (tmp1)->ano, (tmp1)->quant, (tmp1)->um, (tmp1)->vlrtotal, (tmp1)->moeda, (TMP1)->ULTPRC})
	(tmp1)->(dbSkip())
End
DlgToExcel({ {"ARRAY", "HISTORICO COMPRAS ENTRE "+dtoc(mv_par03)+" E "+dtoc(mv_par04), _aCabec, _aDados} })

(tmp1)->(dbclosearea())

return()



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do produto              ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"02","Ate o produto           ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"03","Da Data                 ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Ate a Data              ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
