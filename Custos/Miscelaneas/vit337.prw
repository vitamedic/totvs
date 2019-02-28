/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT337   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 10/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Estrutura de produto com Custo Standart exportada para     ³±±
±±³          ³ Excel                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit337()

_cfilsb1:=xfilial("SB1")
_cfilsg1:=xfilial("SG1")
sb1->(dbsetorder(1))
sg1->(dbsetorder(1))

_prodini  := Replicate(" ",15)
_prodfim  := Replicate(" ",15)
_tipoini  := "  "
_tipofim  := "  "
_grupoini  := "    "
_grupofim  := "    "


@ 000,000 to 250,600 dialog odlg1 title "Estrutura Produtos - Excel"
@ 005,005 say "Do Produto"
@ 005,045 get _prodini  picture "@!" f3 "SB1"
@ 020,005 say "Ate o Produto"
@ 020,045 get _prodfim  picture "@!" f3 "SB1"
@ 035,005 say "Do Tipo"
@ 035,045 get _tipoini  picture "@!"
@ 050,005 say "Ate Tipo"
@ 050,045 get _tipofim  picture "@!"
@ 065,005 say "Do Grupo"
@ 065,045 get _grupoini picture "@!" f3 "SBM"
@ 080,005 say "Ate Grupo"
@ 080,045 get _grupofim picture "@!" f3 "SBM"

@ 110,055 bmpbutton type 1 action TExcel2()
@ 110,090 bmpbutton type 2 action close(odlg1)

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

_aCabec := {"Codigo", "Descrição","Componente", "Descricao Componente","Dt Cst Std","Qtde","Cst Std Unit","Cst Total","%"}

processa({|| _querys()})
tmp1->(dbgotop())

_subtotal:=0
_produto:= tmp1->cod

_regatu:=0
_regini:=1 
_somaperc:=0

While !tmp1->(Eof())         

	AAdd(_aDados, {tmp1->cod, tmp1->descri, tmp1->codcomp, tmp1->descomp,tmp1->dtctsta,tmp1->qtde,tmp1->custd,round((tmp1->qtde*tmp1->custd),5),0})
	_regatu++
	tmp1->(dbSkip())

	if _produto=tmp1->cod
	   _subtotal:= _subtotal + round((tmp1->qtde*tmp1->custd),5)
	else        
		_somaperc:=0                                       
		for _i:=_regini to _regatu
			if _subtotal>0     
				_aDados[_i,9]:=round((_aDados[_i,8]/_subtotal)*100,5)
				_somaperc:=_somaperc + round((_aDados[_i,8]/_subtotal)*100,5)
			endif
		next		                                                   		
		AAdd(_aDados, {"", "SUB-TOTAL "+_produto, "", "","","","",_subtotal,_somaperc})	
		_regatu++
		_regini:=_regatu + 1
		_produto:=tmp1->cod
		_subtotal:= round((tmp1->qtde*tmp1->custd),5)                                   
	endif
End

DlgToExcel({ {"ARRAY", "Exportacao de Estruturas para o Excel", _aCabec, _aDados} })
tmp1->(dbclosearea())
return


static function _querys()       
_cquery:=" SELECT"
_cquery+=" G1_COD COD,"
_cquery+=" SB1A.B1_DESC DESCRI,"
_cquery+=" G1_COMP CODCOMP,"
_cquery+=" SB1B.B1_DESC DESCOMP," 
_cquery+=" SB1B.B1_DTCTSTA DTCTSTA," 
_cquery+=" SB1B.B1_CUSTD CUSTD," 
_cquery+=" Sum(G1_QUANT) QTDE"
_cquery+=" FROM "
_cquery+= retsqlname("SG1")+" SG1," 
_cquery+= retsqlname("SB1")+" SB1A," 
_cquery+= retsqlname("SB1")+" SB1B"
_cquery+=" WHERE"
_cquery+=" SG1.D_E_L_E_T_=' '"
_cquery+=" AND SB1A.D_E_L_E_T_=' '"
_cquery+=" AND SB1B.D_E_L_E_T_=' '"
_cquery+=" AND G1_COD BETWEEN '"+_prodini+"' AND '"+_prodfim+"'" 
_cquery+=" AND G1_COD=SB1A.B1_COD"
_cquery+=" AND SB1A.B1_TIPO BETWEEN '"+_tipoini+"' AND '"+_tipofim+"'"
_cquery+=" AND SB1A.B1_GRUPO BETWEEN '"+_grupoini+"' AND '"+_grupofim+"'"
_cquery+=" AND G1_COMP=SB1B.B1_COD"
_cquery+=" GROUP BY G1_COD, SB1A.B1_DESC, G1_COMP, SB1B.B1_DESC,SB1B.B1_DTCTSTA, SB1B.B1_CUSTD"
_cquery+=" ORDER BY G1_COD, G1_COMP"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"    

tcsetfield("TMP1","CUSTD","N",12,5)
tcsetfield("TMP1","QTDE","N",12,2)
tcsetfield("TMP1","DTCTSTA","D")

return
