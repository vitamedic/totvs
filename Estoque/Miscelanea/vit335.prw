/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT335   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 10/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³descricao ³ Saldos Kardex em uma determinada data informada para Excel ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit335()

_cfilsb1:=xfilial("SB1")
_cfilsb9:=xfilial("SB9")
_cfilsb2:=xfilial("SB2")
sb1->(dbsetorder(1))
sb9->(dbsetorder(1))
sb2->(dbsetorder(1))

_prodini  := Replicate(" ",15)
_prodfim  := Replicate(" ",15)
_localini := "  "
_localfim := "  "
_tipoini  := "  "
_tipofim  := "  "
_datafim  := ctod("  /  /  ")

@ 000,000 to 300,600 dialog odlg1 title "Saldo Fechamento Estoque - Excel"
@ 005,005 say "Do Produto"
@ 005,045 get _prodini  picture "@!" f3 "SB1"
@ 020,005 say "Ate o Produto"
@ 020,045 get _prodfim  picture "@!" f3 "SB1"
@ 035,005 say "Do Tipo"
@ 035,045 get _tipoini  picture "@!"
@ 050,005 say "Ate Tipo"
@ 050,045 get _tipofim  picture "@!"
@ 065,005 say "Do Armazem"
@ 065,045 get _localini picture "@E 99"
@ 080,005 say "Ate Armazem"
@ 080,045 get _localfim picture "@E 99"
@ 095,005 say "Sld. na Data"
@ 095,045 get _datafim  

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

_aCabec := {"Codigo", "Descrição","Local", "Data","Qtd Kardex","Sld(R$) Kardex","Qtd 2a UM","Qtd SB2","Sld(R$) SB2"}

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

	_aSaldo := CalcEst(tmp1->cod,tmp1->locpad,_datafim)                                                             
	if sb2->(dbseek(_cfilsb2+tmp1->cod+tmp1->locpad))
	   AAdd(_aDados, {tmp1->cod, tmp1->descri, tmp1->locpad, _datafim,_aSaldo[1],_aSaldo[2],_aSaldo[7],sb2->b2_qatu,sb2->b2_vatu1})
	else
	   AAdd(_aDados, {tmp1->cod, tmp1->descri, tmp1->locpad, _datafim,_aSaldo[1],_aSaldo[2],_aSaldo[7],0,0})
	endif
   tmp1->(dbSkip())
End

AAdd(_aSaldo,_aCabec)
DlgToExcel({ {"ARRAY", "Exportacao para o Excel", _aCabec, _aDados} })
tmp1->(dbclosearea())
return


static function _querys()       


_cquery:=" SELECT"
_cquery+=" DISTINCT(B9_LOCAL) LOCPAD,"
_cquery+=" B1_COD COD," 
_cquery+=" B1_DESC DESCRI," 
_cquery+=" B1_TIPO TIPO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB9")+" SB9, "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE" 
_cquery+=" 	SB9.D_E_L_E_T_=' '" 
_cquery+=" AND SB1.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'" 
_cquery+=" AND B9_FILIAL='"+_cfilsb9+"'" 
_cquery+=" AND B9_COD BETWEEN '"+_prodini+"' AND '"+_prodfim+"'" 
_cquery+=" AND B9_LOCAL BETWEEN '"+_localini+"' AND '"+_localfim+"'"
_cquery+=" AND B9_COD=B1_COD"
_cquery+=" AND B1_TIPO BETWEEN '"+_tipoini+"' AND '"+_tipofim+"'"
//_cquery+=" AND B9_LOCAL=B1_LOCPAD"
_cquery+=" ORDER BY B1_DESC,B1_COD"

/*
_cquery:=" SELECT"
_cquery+=" B1_COD COD,"
_cquery+=" B1_DESC DESCRI," 
_cquery+=" B1_TIPO TIPO,"
_cquery+=" B1_LOCPAD LOCPAD"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"                   
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+_prodini+"' AND '"+_prodfim+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+_tipoini+"' AND '"+_tipofim+"'"
_cquery+=" AND B1_LOCPAD BETWEEN '"+_localini+"' AND '"+_localfim+"'"
_cquery+=" AND B1_COD IN (SELECT DISTINCT(B9_COD) FROM "+retsqlname("SB9")+" SB9 WHERE SB9.D_E_L_E_T_<>'*')"
_cquery+=" ORDER BY B1_DESC, B1_COD"
*/
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"    
return
