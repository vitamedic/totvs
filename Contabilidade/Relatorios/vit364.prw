/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT364   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 10/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Planilha Excel com Apuracao de Vendas ORP Conforme    ³±±
±±³          ³ IN SRF Nº 21/79                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit364()
_cperg:="PERGVIT364"
_pergsx1()

pergunte(_cperg,.t.) 

if msgyesno("Confirma Exportacao de Dados de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)+" para Excel?")
	processa({|| _geraorp()})	
endif

return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GERAORP  ³ Autor ³ Alex Junio de Miranda ³ Data ³ 10/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ EXECUTA QUERY PARA GERAR DADOS E EXPORTAR PARA EXCEL       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO PARA VITAPAN                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function _geraorp()
_cfilsd2:=xfilial("SD2")
_cfilsf4:=xfilial("SF4")
_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")

procregua(1)
incproc("Executando Query para exportacao...")

#IFDEF TOP
	lQuery  := .T.
	tmp1 := GetNextAlias()
	BeginSql Alias tmp1

		SELECT
  		TBAUX.SERIE, TBAUX.NOTA,
  		TBAUX.E1_EMISSAO EMISSAO,
  		TOTAL, CUSTO, TBAUX.E1_FATPREF FATPREF, 
  		TBAUX.E1_FATURA FATURA, SE1A.E1_PARCELA PARCELA, SE1A.E1_VALOR VALOR, SE1A.E1_VLCRUZ VLCRUZ,
  		SE1A.E1_BAIXA BAIXA,
  		SE1A.E1_VALLIQ VALLIQ
		FROM %Table:SE1% SE1A,
      		(SELECT E1_PREFIXO SERIE,E1_NUM NOTA, E1_PARCELA, E1_EMISSAO, E1_FATPREF, E1_FATURA, TOTAL, CUSTO
      		FROM
        		%Table:SE1% SE1,
        		(SELECT D2_SERIE, D2_DOC, D2_EMISSAO, Sum(D2_TOTAL) TOTAL, Sum(D2_CUSTO1) CUSTO, D2_CLIENTE, D2_LOJA
          		FROM %Table:SD2% SD2
                	INNER JOIN %Table:SA1% SA1 ON (SA1.%NotDel% AND SA1.A1_FILIAL=%Exp:_cfilsa1% AND A1_COD=SD2.D2_CLIENTE AND A1_LOJA=SD2.D2_LOJA AND A1_TIPO='F' AND A1_TPEMP IN ('M','E','F'))
                	INNER JOIN %Table:SF4% SF4 ON (SF4.%NotDel% AND SF4.F4_FILIAL=%Exp:_cfilsf4% AND F4_CODIGO=SD2.D2_TES AND F4_ESTOQUE='S' AND F4_DUPLIC='S')
          		WHERE SD2.%NotDel%                                                                   
          		AND SD2.D2_FILIAL=%Exp:_cfilsd2%
              	AND SD2.D2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
          		GROUP BY D2_SERIE, D2_DOC, D2_EMISSAO, D2_CLIENTE, D2_LOJA
          		ORDER BY D2_SERIE, D2_DOC) TABAUX
      		WHERE SE1.%NotDel%                 
      		AND SE1.E1_FILIAL=%Exp:_cfilse1%
      		AND SE1.E1_PREFIXO||SE1.E1_NUM = TABAUX.D2_SERIE||TABAUX.D2_DOC
      		AND SE1.E1_CLIENTE=TABAUX.D2_CLIENTE
      		AND SE1.E1_LOJA=TABAUX.D2_LOJA
      		ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA) TBAUX
		WHERE SE1A.%NotDel%               
		AND SE1A.E1_FILIAL=%Exp:_cfilse1%
		AND SE1A.E1_PREFIXO=TBAUX.E1_FATPREF
		AND SE1A.E1_NUM=TBAUX.E1_FATURA
		ORDER BY TBAUX.SERIE, TBAUX.NOTA, TBAUX.E1_FATPREF, TBAUX.E1_FATURA, SE1A.E1_PARCELA
	EndSql

#ENDIF

procregua(1)
incproc("Exportando Dados para Excel...")

//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

_aCabec := {}
_aDados := {}
_aSaldo := {}
_fatur  := {}
_custo  := {}
_resliq := {}
_perres := {}
_baixa  := {}
_recnrec:= {}
_exclu  := {}
_acumtri:= {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

_aCabec := {"","APURACAO CONFORME IN SRF nº 21/79","Jan/"+strzero(year(mv_par01),4),"Fev/"+strzero(year(mv_par01),4),"Mar/"+strzero(year(mv_par01),4),"Total 1o Trim.","Abr/"+strzero(year(mv_par01),4),"Mai/"+strzero(year(mv_par01),4),"Jun/"+strzero(year(mv_par01),4),"Total 2o Trim.","Jul/"+strzero(year(mv_par01),4),"Ago/"+strzero(year(mv_par01),4), "Set/"+strzero(year(mv_par01),4), "Total 3o Trim.", "Out/"+strzero(year(mv_par01),4), "Nov/"+strzero(year(mv_par01),4), "Dez/"+strzero(year(mv_par01),4),"Total 4o Trim."}
_fatura:=""          
_acumtri := array(4,4)
 
for _i:=1 to 12 
	(tmp1)->(dbgotop())
	aadd(_fatur, 0)
	aadd(_custo, 0)
	aadd(_baixa, 0)
	
	While !(tmp1)->(Eof())
		if substr((tmp1)->emissao,5,2)==strzero(_i,2)
			// Receita correspondente ao período base
			_fatur[_i] += round((tmp1)->total,2)
			// Custo incorrido no período
			_custo[_i] += round((tmp1)->custo,2)
		endif
		
		if substr((tmp1)->baixa,5,2) == strzero(_i,2) .and.;
			substr((tmp1)->baixa,1,4) == substr(dtos(mv_par01),1,4)
			// Receita recebida no período base a ele correspondente		
			_baixa[_i] += round((tmp1)->valliq,2)
		endif		         
		(tmp1)->(dbSkip())
	End
	
	if _i >= 1 .and. _i <= 3// Acumulado por trimestre
		_acumtri[1,1] += _fatur[_i]
		_acumtri[1,2] += _custo[_i]
		_acumtri[1,3] += _baixa[_i]
	elseif _i >= 4 .and. _i <= 6
		_acumtri[2,1] += _fatur[_i]
		_acumtri[2,2] += _custo[_i]
		_acumtri[2,3] += _baixa[_i]
	elseif _i >= 7 .and. _i <= 9
		_acumtri[3,1] += _fatur[_i]
		_acumtri[3,2] += _custo[_i]
		_acumtri[3,3] += _baixa[_i]
	else
		_acumtri[4,1] += _fatur[_i]
		_acumtri[4,2] += _custo[_i]
		_acumtri[4,3] += _baixa[_i]		
	endif  
	
	// Resultado computado na determinação do Lucro Líquido
	aadd(_resliq, (_fatur[_i] - _custo[_i]))
	aadd(_perres, 0)

	// % do resultado sobre a receita
	if _fatur[_i] > 0
		_perres[_i] := round(_resliq[_i]/_fatur[_i] * 100,2)
	endif

	aadd(_recnrec, (_fatur[_i] - _baixa[_i]))
	
	aadd(_exclu, round((_recnrec[_i] * (_perres[_i]/100)),2))
next
            

AAdd(_aDados, {"a","Receita correspondente ao periodo base"                      ,_fatur[1]  ,_fatur[2]  ,_fatur[3]  ,_acumtri[1,1]                ,_fatur[4]  ,_fatur[5]  ,_fatur[6]  ,_acumtri[2,1]                ,_fatur[7]  ,_fatur[8]  ,_fatur[9]  ,_acumtri[3,1]                ,_fatur[10]  ,_fatur[11]  ,_fatur[12],_acumtri[4,1]})
AAdd(_aDados, {"b","Custo incorrido no periodo"            						 ,_custo[1]  ,_custo[2]  ,_custo[3]  ,_acumtri[1,2]                ,_custo[4]  ,_custo[5]  ,_custo[6]  ,_acumtri[2,2]                ,_custo[7]  ,_custo[8]  ,_custo[9]  ,_acumtri[3,2]                ,_custo[10]  ,_custo[11]  ,_custo[12],_acumtri[4,2]})
AAdd(_aDados, {"c","Resultado computado na determinacao do Lucro Liquido [a - b]",_resliq[1] ,_resliq[2] ,_resliq[3] ,(_acumtri[1,1]-_acumtri[1,2]),_resliq[4], _resliq[5] ,_resliq[6] ,(_acumtri[2,1]-_acumtri[2,2]),_resliq[7] ,_resliq[8] ,_resliq[9] ,(_acumtri[3,1]-_acumtri[3,2]),_resliq[10] ,_resliq[11] ,_resliq[12],(_acumtri[4,1]-_acumtri[4,2])})
AAdd(_aDados, {"" ,"APURACAO DO DIFERIMENTO","","","","","","","","","","","","","","","","",""})
AAdd(_aDados, {"d","% do resultado sobre a receita [c/a]"						 ,_perres[1] ,_perres[2] ,_perres[3] ,round(((_acumtri[1,1]-_acumtri[1,2])/_acumtri[1,1]),2),_perres[4] ,_perres[5] ,_perres[6] ,0,_perres[7] ,_perres[8] ,_perres[9] ,0 ,_perres[10] ,_perres[11] ,_perres[12],0})
AAdd(_aDados, {"e","Receita recebida no período base a ele correspondente"		 ,_baixa[1]  ,_baixa[2]  ,_baixa[3]  ,_acumtri[1,3]                ,_baixa[4]  ,_baixa[5]  ,_baixa[6]  ,_acumtri[2,3]                ,_baixa[7]  ,_baixa[8]  ,_baixa[9]  ,_acumtri[2,3]                ,_baixa[10]  ,_baixa[11]  ,_baixa[12],_acumtri[4,3]})
AAdd(_aDados, {"f","Receita nao recebida [a - e]"								 ,_recnrec[1],_recnrec[2],_recnrec[3],0                            ,_recnrec[4],_recnrec[5],_recnrec[6],0                            ,_recnrec[7],_recnrec[8],_recnrec[9],0                            ,_recnrec[10],_recnrec[11],_recnrec[12],0})
AAdd(_aDados, {"g","Montante da exclusao [f x d]"								 ,_exclu[1]  ,_exclu[2]  ,_exclu[3]  ,0                            ,_exclu[4]  ,_exclu[5]  ,_exclu[6]  ,0                            ,_exclu[7]  ,_exclu[8]  ,_exclu[9]  ,0                            ,_exclu[10]  ,_exclu[11]  ,_exclu[12],0})

// Títulos Liquidados
_bxtit:=array(13,13)              
for _i:=1 to 13
	for _j:=1 to 13
		_bxtit[_i,_j]:=0
	next
next

(tmp1)->(dbgotop())

While !(tmp1)->(Eof())
	
	_mesemis  := val(substr((tmp1)->emissao,5,2))
	_mesbaixa := val(substr((tmp1)->baixa,5,2))
	_anobaixa := substr((tmp1)->baixa,1,4)
	
	if _anobaixa = substr(dtos(mv_par01),1,4)
		_bxtit[_mesbaixa,_mesemis] += (tmp1)->valliq
		_bxtit[13,_mesemis] += (tmp1)->valliq
		_bxtit[_mesbaixa,13] += (tmp1)->valliq
	endif
	
	(tmp1)->(dbskip())
end
                                        

AAdd(_aDados, {"","","","","","","","","","","","","","",""})
AAdd(_aDados, {"","TITULOS LIQUIDADOS","","","","","","","","","","","","",""})
AAdd(_aDados, {"Per. Liq.","Periodo de Emissao","","","","","","","","","","","","",""})
AAdd(_aDados, {"","Jan/"+strzero(year(mv_par01),4),"Fev/"+strzero(year(mv_par01),4),"Mar/"+strzero(year(mv_par01),4),"Abr/"+strzero(year(mv_par01),4),"Mai/"+strzero(year(mv_par01),4),"Jun/"+strzero(year(mv_par01),4),"Jul/"+strzero(year(mv_par01),4),"Ago/"+strzero(year(mv_par01),4), "Set/"+strzero(year(mv_par01),4), "Out/"+strzero(year(mv_par01),4), "Nov/"+strzero(year(mv_par01),4), "Dez/"+strzero(year(mv_par01),4),"TOTAL","ACUMULADO"})

_mes:=""
for _i:=1 to 13     
	do case
		case _i=1 
			_mes:="Jan/"+strzero(year(mv_par01),4)
		case _i=2 
			_mes:="Fev/"+strzero(year(mv_par01),4)
		case _i=3 
			_mes:="Mar/"+strzero(year(mv_par01),4)
		case _i=4 
			_mes:="Abr/"+strzero(year(mv_par01),4)
		case _i=5 
			_mes:="Mai/"+strzero(year(mv_par01),4)
		case _i=6 
			_mes:="Jun/"+strzero(year(mv_par01),4)
		case _i=7 
			_mes:="Jul/"+strzero(year(mv_par01),4)
		case _i=8 
			_mes:="Ago/"+strzero(year(mv_par01),4)
		case _i=9 
			_mes:="Set/"+strzero(year(mv_par01),4)
		case _i=10
			_mes:="Out/"+strzero(year(mv_par01),4)
		case _i=11
			_mes:="Nov/"+strzero(year(mv_par01),4)
		case _i=12
			_mes:="Dez/"+strzero(year(mv_par01),4)			
		case _i=13
			_mes:="Total"
	endcase
	if _i<13
		AAdd(_aDados, {_mes,_bxtit[_i,1],_bxtit[_i,2],_bxtit[_i,3],_bxtit[_i,4],_bxtit[_i,5],_bxtit[_i,6],_bxtit[_i,7],_bxtit[_i,8],_bxtit[_i,9],_bxtit[_i,10],_bxtit[_i,11],_bxtit[_i,12],_bxtit[_i,13],_baixa[_i]})	
	else
		AAdd(_aDados, {_mes,_bxtit[_i,1],_bxtit[_i,2],_bxtit[_i,3],_bxtit[_i,4],_bxtit[_i,5],_bxtit[_i,6],_bxtit[_i,7],_bxtit[_i,8],_bxtit[_i,9],_bxtit[_i,10],_bxtit[_i,11],_bxtit[_i,12],_bxtit[_i,13],""})	
	endif		
next

DlgToExcel({ {"ARRAY", "RELATORIO DIFERIDO PARA AS VENDAS ORP - Periodo "+dtoc(mv_par01)+" E "+dtoc(mv_par02), _aCabec, _aDados} })

(tmp1)->(dbclosearea())

return()



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da Data                 ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a Data              ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
