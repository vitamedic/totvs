/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT370   ³Autor ³ Alex Júnio de Miranda   ³Data ³ 23/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo do Rendimento Medio das Ordens de Produção em      ³±±
±±³          ³ Planilha de Excel                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "dialog.ch"

user function vit370()

_cfilsb1:=xfilial("SB1")
_cfilsc2:=xfilial("SC2")

sb1->(dbsetorder(1))
sc2->(dbsetorder(1))

_dataini  := ctod("  /  /  ")
_datafim  := ctod("  /  /  ")
_prodini  := Replicate(" ",15)
_prodfim  := Replicate("Z",15)
_opini    := Replicate(" ",13)
_opfim    := Replicate("Z",13)


@ 000,000 to 300,400 dialog odlg1 title "Rendimento Medio OP"
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


@ 100,055 bmpbutton type 1 action TExcel2()
@ 100,090 bmpbutton type 2 action close(odlg1)

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


_aCabec := {"CÓDIGO", "DESCRIÇÃO", "RENDIMENTO MEDIO","QTD TEORICA","QTD PRODUZIDA","Nº OP'S"}
	
#IFDEF TOP
	lQuery  := .T.
	tmp1 := GetNextAlias()
	BeginSql Alias tmp1

		SELECT
		  CODIGO,
		  DESCRI,
		  CAST((Sum(QUJE)/Sum(TEORICO))*100 AS NUMERIC(15,2)) REND,
		  Sum(TEORICO) TEORICO,
		  Sum(QUJE) QUJE,
		  Count(CODIGO) NUM_OPS
		
		FROM
   			(SELECT
       			SC2.C2_PRODUTO CODIGO,
       			SB1.B1_DESC DESCRI,
       			SC2.C2_QUANT TEORICO,
       			SC2.C2_QUJE QUJE
   			FROM %Table:SC2% SC2
       			LEFT JOIN %Table:SB1% SB1 ON (SB1.%NotDel% AND SB1.B1_FILIAL=%Exp:_cfilsb1% AND SC2.C2_PRODUTO=SB1.B1_COD)
   			WHERE SC2.%NotDel%  
	   			AND SC2.C2_FILIAL=%Exp:_cfilsc2%
   				AND SC2.C2_EMISSAO BETWEEN %Exp:_dataini% AND %Exp:_datafim%
				AND SC2.C2_PRODUTO BETWEEN %Exp:_prodini% AND %Exp:_prodfim%
				AND SC2.C2_NUM BETWEEN %Exp:substr(_opini,1,6)% AND %Exp:substr(_opfim,1,6)%
   				AND SC2.C2_PRODUTO <='009999'
	   			AND SC2.C2_DATRF<>' ')
		GROUP BY CODIGO, DESCRI
		ORDER BY CODIGO
	
	EndSql

#ENDIF
	
(tmp1)->(dbgotop())
	
While !(tmp1)->(Eof())         
   AAdd(_aDados, {(tmp1)->codigo, (tmp1)->descri, (tmp1)->rend, (tmp1)->teorico, (tmp1)->quje, (tmp1)->num_ops})
   (tmp1)->(dbSkip())
End

	
AAdd(_aSaldo,_aCabec)
DlgToExcel({ {"ARRAY", "Rendimento Médio de Ordens de Produção", _aCabec, _aDados} })

(tmp1)->(dbclosearea())
close(odlg1)
return


