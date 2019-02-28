/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VIT336     ³ Autor ³ Alex Miranda        ³ Data ³ 16/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Horas a trabalhar pela folha para conferencia de           ³±±
±±³            MOD-Improdutiva e MO Indireta - Exporta para Excel.        ³±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico para VITAPAN                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Alterado por Cláudio Ferreira 16.02.17 para tratar as horas pela estimativa do setor devido a ausencia da Folha.

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch" 
#INCLUDE "PROTHEUS.CH"

user function vit336()

_cfilsra:=xfilial("SRA")
_cfilsrd:=xfilial("SRD")
_cfilrcg:=xfilial("RCG")
_cfilctt:=xfilial("CTT")
_cfilCQ2:=xfilial("CQ2")
sra->(dbsetorder(1))
srd->(dbsetorder(1))
rcg->(dbsetorder(1))
ctt->(dbsetorder(1))
CQ2->(dbsetorder(1))

_dataini  := ctod("  /  /  ")
_datafim  := ctod("  /  /  ")

@ 000,000 to 130,200 dialog odlg1 title "Planilha Conferência MO (Custo por Absorção) - Excel" 
//@ 005,005 say "Da Data"
//@ 005,045 get _dataini Size 060,009  
@ 005,005 Say "Da Data"      						Size  70,09 Of oDlg1 Pixel 
@ 005,045 MSGET oDtDe 	VAR _dataini	PICTURE "@D 99/99/99"  SIZE 040,4 OF oDlg1 PIXEL 
//@ 020,005 say "Ate a Data"
//@ 020,045 get _datafim Size 060,009
@ 020,005 Say "Ate a Data"      						Size  70,09 Of oDlg1 Pixel
@ 020,045 MSGET oDtate 	VAR _datafim	PICTURE "@D 99/99/99"  SIZE 040,4 OF oDlg1 PIXEL 

@ 040,020 bmpbutton type 1  action TExcel2()
@ 040,055 bmpbutton type 2  action close(odlg1)

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
   MsgAlert("Microsoft Excel nÃo instalado!")
   Return
EndIf

If (_dataini = ctod("  /  /  ")) .or. (_datafim = ctod("  /  /  "))
	MsgAlert("Informar Datas de Inicio e Fim do Periodo") 
	Return
endif                                          

_aCabec := {"C.Custo", "Classif. CC", "Descrição", "Hr a Trabalhar", "Vlr CC","MOD OPs","Vl MOD OPs","MOD Improd","Vl MOD Impr"}

processa({|| u__gerahoras(_dataini,_datafim)})
tmp1->(dbgotop())

while ! tmp1->(eof())  
	_cc:=tmp1->cc
	_tothrtrab=u__gerahrcc(_cc,_datafim)
	_hrsimprodut:=(_tothrtrab - tmp1->horasops)
	processa({|| _query2(_cc)})
	tmp2->(dbgotop())    
	_vlruncc:=(tmp2->debito - tmp2->credito)/_tothrtrab 
	
	if tmp1->clascc<>'1'
		_hrsimprodut:= 0
	endif
	
	AAdd(_aDados, {_cc,;
				   IIF(tmp1->clascc=='1',"Direto","Indireto"),;
				   posicione('CTT',1,xFilial('CTT')+_cc,'CTT_DESC01'),;
				   _tothrtrab,;
				   (tmp2->debito-tmp2->credito),;
				   IIF(tmp1->clascc=='1',tmp1->horasops," "),;
				   IIF(tmp1->clascc=='1',(tmp1->horasops*_vlruncc)," "),;
				   IIF(tmp1->clascc=='1',IIF(_hrsimprodut<0,0,_hrsimprodut)," "),;
				   IIF(tmp1->clascc=='1',IIF(_hrsimprodut<0,0,_hrsimprodut*_vlruncc)," ")})

	tmp2->(dbclosearea())
	tmp1->(dbSkip())
End

DlgToExcel({ {"ARRAY", "Planilha Conferência MO Custo por Absorção - Excel", _aCabec, _aDados} })
tmp1->(dbclosearea())
return


static function _query2(_cc)
_cquery2:=" SELECT "
_cquery2+=" CQ2_CCUSTO CC,"
_cquery2+=" Sum(CQ2_DEBITO) DEBITO,"
_cquery2+=" Sum(CQ2_CREDIT) CREDITO"
_cquery2+=" FROM "
_cquery2+=  retsqlname("CQ2")+" CQ2"
_cquery2+=" WHERE"
_cquery2+="     CQ2.D_E_L_E_T_ = ' '"
_cquery2+=" AND CQ2_FILIAL = '"+_cfilCQ2+"'"
_cquery2+=" AND CQ2_DATA BETWEEN '"+dtos(_dataini)+"' AND '"+dtos(_datafim)+"'"
_cquery2+=" AND CQ2_CCUSTO = '"+_cc+"'"
_cquery2+=" AND (CQ2_CONTA BETWEEN '35010103' AND '35010103ZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '35020103' AND '35020103ZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '350102'   AND '350102ZZZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '35010102' AND '35010102ZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '35010101' AND '35010101ZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '35020101' AND '35020101ZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '35020102' AND '35020102ZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '350198'   AND '350198ZZZZZZZ'"
_cquery2+=" OR CQ2_CONTA BETWEEN '350202'   AND '350202ZZZZZZZ')"
_cquery2+=" AND CQ2_TPSALD = '1'"
_cquery2+=" GROUP BY CQ2_CCUSTO"
_cquery2+=" ORDER BY CQ2_CCUSTO"

_cquery2:=changequery(_cquery2)
tcquery _cquery2 new alias "TMP2"    

tcsetfield("TMP2","DEBITO","N",15,2)
tcsetfield("TMP2","CREDITO","N",15,2)

return    

