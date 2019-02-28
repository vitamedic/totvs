/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT367   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 03/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo do Lead Time de Producao Disposto em Planilha Excel³±±
±±³          ³ / Apontamento Final - Data Ini. Igual a 1º Apontamento da OP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "dialog.ch"

user function vit367()

_cfilsd3:=xfilial("SD3")
_cfilsb1:=xfilial("SB1")
_cfilsc2:=xfilial("SC2")
_cfilsh6:=xfilial("SH6")
_cfilsh1:=xfilial("SH1")

sb1->(dbsetorder(1))
sd3->(dbsetorder(3))
sc2->(dbsetorder(1))
sh6->(dbsetorder(1))
sh1->(dbsetorder(1))

_dataini  := ctod("  /  /  ")
_datafim  := ctod("  /  /  ")
_prodini  := Replicate(" ",15)
_prodfim  := Replicate("Z",15)
_opini    := Replicate(" ",13)
_opfim    := Replicate("Z",13)
_ctiporel :=""      
_atiporel :={"1-POR APONTAMENTO FINAL","2-POR FASE"}


@ 000,000 to 300,400 dialog odlg1 title "Lead Time Producao"
@ 005,005 say "Da Dt. Emissao OP"
@ 005,055 get _dataini 
@ 020,005 say "Ate a Dt. Emissao OP"
@ 020,055 get _datafim
@ 035,005 say "Do Produto"
@ 035,055 get _prodini  picture "@!" size 58,7 f3 "SB1"
@ 050,005 say "Ate o Produto"
@ 050,055 get _prodfim  picture "@!" size 58,7 f3 "SB1"
@ 065,005 say "Da OP"
@ 065,055 get _opini picture "@!" size 50,7 f3 "SC2"
@ 080,005 say "Ate a OP"
@ 080,055 get _opfim picture "@!" size 50,7 f3 "SC2"
@ 095,005 say "Tipo Relatorio"
@ 095,055 combobox _ctiporel items _atiporel size 80,8


@ 115,055 bmpbutton type 1 action TExcel2()
@ 115,090 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered

return()

static function TExcel2()
//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

Private _aCabec := {}
Private _aDados := {}
Private _aSaldo := {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

if substr(_ctiporel,1,1)=="1"  // POR APONTAMENTO FINAL
	_aCabec := {"OP", "CÓDIGO","DESCRIÇÃO", "EMISSÃO OP","DT.INÍCIO OP","ENCERRAMENTO OP","DT.ÚLTIMA PRODUÇÃO","TEMPO"}
	
	#IFDEF TOP
		lQuery  := .T.
		tmp1 := GetNextAlias()
		BeginSql Alias tmp1
	
			SELECT 
				DISTINCT(OP) OP, 
				CODIGO, 
				DESCRI, 
				EMISSAO, 
				DTINIOP, 
				FECHAMENTO, 
				PRODUCAO
			FROM (
			      SELECT
			        SD3.D3_COD CODIGO,
			        SB1.B1_DESC DESCRI,
			        SubStr(SD3.D3_OP,1,6) OP,
			        SC2.C2_EMISSAO EMISSAO,
			        SH6A.H6_DATAINI DTINIOP,
			        SC2.C2_DATRF FECHAMENTO,
			        SD3.D3_EMISSAO PRODUCAO
			      FROM 
			      	%Table:SD3% SD3
			        INNER JOIN %Table:SC2% SC2 
			        	ON (SC2.%NotDel% AND SC2.C2_FILIAL=%Exp:_cfilsc2% AND SC2.C2_NUM=SubStr(SD3.D3_OP,1,6) 
			        		AND SC2.C2_EMISSAO BETWEEN %Exp:_dataini% AND %Exp:_datafim% 
			        		AND SC2.C2_PRODUTO<='009999' 
			        		AND SC2.C2_DATRF<>' ')
			        LEFT JOIN %Table:SH6% SH6A ON (SH6A.%NotDel% AND SH6A.H6_FILIAL=%Exp:_cfilsh6% AND SH6A.H6_OP=SD3.D3_OP AND SH6A.H6_OPERAC='01')
			        LEFT JOIN %Table:SB1% SB1 ON (SB1.%NotDel% AND SB1.B1_FILIAL=%Exp:_cfilsb1% AND SB1.B1_COD=SD3.D3_COD)
			      WHERE SD3.%NotDel%
			      AND SD3.D3_FILIAL=%Exp:_cfilsd3% 
			      AND SD3.D3_CF='PR0'
				  AND SD3.D3_COD BETWEEN %Exp:_prodini% AND %Exp:_prodfim% 
				  AND SD3.D3_OP BETWEEN %Exp:_opini% AND %Exp:_opfim%
			      AND SD3.D3_ESTORNO<>'S'
			      AND SD3.D3_QUANT>0
			      AND SD3.D3_EMISSAO = (SELECT Max(SD3A.D3_EMISSAO) FROM %Table:SD3% SD3A WHERE SD3A.D_E_L_E_T_=' ' AND SD3A.D3_OP=SD3.D3_OP AND SD3A.D3_QUANT>0 AND SD3A.D3_ESTORNO<>'S' AND SD3A.D3_CF='PR0')
			     )
			ORDER BY CODIGO, OP, EMISSAO
	
		EndSql
	
	#ENDIF
	
	(tmp1)->(dbgotop())
	
	While !(tmp1)->(Eof())         
	   AAdd(_aDados, {(tmp1)->op, (tmp1)->codigo, (tmp1)->descri, stod((tmp1)->emissao), stod((tmp1)->dtiniop),stod((tmp1)->fechamento),stod((tmp1)->producao), (stod((tmp1)->producao) - stod((tmp1)->dtiniop))})
	   (tmp1)->(dbSkip())
	End

else //POR FASE (ROTEIRO DE OPERAÇÕES)

	_aCabec := {"CÓDIGO", "DESCRIÇÃO", "OP","OPERAÇÃO","RECURSO","DESC.RECURSO","EMISSÃO OP","DT.INÍCIO OP","ENCERRAMENTO OP","INICIO OPERAÇÃO", "HR INICIO OPERAÇÃO", "FIM OPERAÇÃO", "HR FIM OPERAÇÃO", "TEMPO OPERAÇÃO"}
	
	#IFDEF TOP
		lQuery  := .T.
		tmp1 := GetNextAlias()
		BeginSql Alias tmp1
	
			SELECT 
			  H6_PRODUTO CODIGO,
			  SB1.B1_DESC DESCRI,
			  H6_OP OP,
			  H6_OPERAC OPERAC,
			  H6_RECURSO RECURSO,
			  SH1.H1_DESCRI DESC_REC,
			  SC2.C2_EMISSAO EMISSAO,
			  (SELECT Max(SH6A.H6_DATAINI) FROM %Table:SH6% SH6A WHERE SH6A.%NotDel% AND SH6A.H6_FILIAL=%Exp:_cfilsh6% AND SH6A.H6_OP=SH6.H6_OP AND SH6A.H6_OPERAC='01') DTINIOP,
			  SC2.C2_DATRF DATRF,
			  H6_DATAINI DATAINI,
			  H6_HORAINI HORAINI,
			  H6_DATAFIN DATAFIN,
			  H6_HORAFIN HORAFIN,
			  H6_TEMPO TEMPO
			FROM %Table:SH6% SH6
			    INNER JOIN %Table:SC2% SC2 ON (SC2.%NotDel% AND SC2.C2_FILIAL=%Exp:_cfilsc2% AND SC2.C2_NUM=SubStr(SH6.H6_OP,1,6) AND SC2.C2_EMISSAO BETWEEN '20111201' AND '20111231' AND SC2.C2_PRODUTO<='009999' AND SC2.C2_DATRF<>' ')
			    LEFT JOIN %Table:SB1% SB1 ON (SB1.%NotDel% AND SB1.B1_FILIAL=%Exp:_cfilsb1% AND SB1.B1_COD=SH6.H6_PRODUTO)
			    LEFT JOIN %Table:SH1% SH1 ON (SH1.%NotDel% AND SH1.H1_FILIAL=%Exp:_cfilsh1% AND SH1.H1_CODIGO=SH6.H6_RECURSO)			
			WHERE SH6.%NotDel% AND SH6.H6_FILIAL=%Exp:_cfilsh6%
			ORDER BY SH6.H6_PRODUTO, SH6.H6_OP, SH6.H6_OPERAC, SH6.H6_DATAFIN
	
		EndSql
	
	#ENDIF
	
	(tmp1)->(dbgotop())
	
	While !(tmp1)->(Eof())         
	   AAdd(_aDados, {(tmp1)->codigo, (tmp1)->descri, (tmp1)->op, (tmp1)->operac, (tmp1)->recurso, (tmp1)->desc_rec, stod((tmp1)->emissao), stod((tmp1)->dtiniop),stod((tmp1)->datrf), stod((tmp1)->dataini),(tmp1)->horaini,stod((tmp1)->datafin), (tmp1)->horafin, (tmp1)->tempo})
	   (tmp1)->(dbSkip())
	End

endif
	
AAdd(_aSaldo,_aCabec)
DlgToExcel({ {"ARRAY", "Lead Time de Ordens de Produção", _aCabec, _aDados} })

(tmp1)->(dbclosearea())
close(odlg1)
return


