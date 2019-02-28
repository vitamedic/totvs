/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT477   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 16/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Horas a trabalhar pela folha para conferencia de           ³±±
±±³          ³ MOD-Improdutiva e MO Indireta - Exporta para Excel.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit477()

_cfilsra:=xfilial("SRA")
_cfilsrd:=xfilial("SRD")
_cfilrcg:=xfilial("RCG")
_cfilctt:=xfilial("CTT")
_cfilct3:=xfilial("CT3")
sra->(dbsetorder(1))
srd->(dbsetorder(1))
rcg->(dbsetorder(1))
ctt->(dbsetorder(1))
ct3->(dbsetorder(1))

_dataini  := ctod("  /  /  ")
_datafim  := ctod("  /  /  ")

@ 000,000 to 130,200 dialog odlg1 title "Planilha Conferência MO (Custo por Absorção) - Excel"
@ 005,005 say "Da Data"
@ 005,045 get _dataini
@ 020,005 say "Ate a Data"
@ 020,045 get _datafim

@ 040,020 bmpbutton type 1 action TExcel2()
@ 040,055 bmpbutton type 2 action close(odlg1)

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

If (_dataini = ctod("  /  /  ")) .or. (_datafim = ctod("  /  /  "))
	MsgAlert("Informar Datas de Inicio e Fim do Período") 
	Return
endif                                          

_aCabec := {"C.Custo", "Classif. CC", "Descrição", "Hr a Trabalhar", "Vlr CC","MOD OPs","Vl MOD OPs","MOD Improd","Vl MOD Impr"}

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

	processa({|| _query2(tmp1->cc)})
	tmp2->(dbgotop())    
	_vlruncc:=(tmp2->debito - tmp2->credito)/tmp1->hrsatrab

	if tmp1->clascc='1'
		_hrsimprodut:= (tmp1->hrsatrab - tmp1->horasops)
	else 
		_hrsimprodut:= 0
	endif
	
	AAdd(_aDados, {tmp1->cc,;
				   IIF(tmp1->clascc=='1',"Direto","Indireto"),;
				   tmp1->descricc,;
				   tmp1->hrsatrab,;
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


static function _querys()       
_cquery:=" SELECT CC,"
_cquery+=" CLASCC,"
_cquery+=" DESCRICC,"
_cquery+=" Sum(HORASATRAB) HRSATRAB,"
_cquery+=" (SELECT Sum(SD3.D3_QUANT) FROM SD3010 SD3"
_cquery+="   WHERE SD3.D_E_L_E_T_ = ' ' AND SD3.D3_FILIAL='01'"
_cquery+="   AND SD3.D3_COD = 'MOD'||CC AND SD3.D3_LOCAL='80'"
_cquery+="   AND SD3.D3_EMISSAO BETWEEN '"+dtos(_dataini)+"' AND '"+dtos(_datafim)+"'"
_cquery+="   AND SD3.D3_OP BETWEEN '            ' AND 'ZZZZZZZZZZZZ' AND SD3.D3_ESTORNO <> 'S') HORASOPS"
_cquery+=" FROM ("
_cquery+=" SELECT DISTINCT(SRD.RD_MAT) MAT,"
_cquery+="        SRA.RA_ADMISSA ADMISSAO,"
_cquery+="        SRA.RA_TNOTRAB TURNO,"
_cquery+="        SRD.RD_CC CC,"
_cquery+="        CTT.CTT_CLASCC CLASCC,"
_cquery+="        CTT.CTT_DESC01 DESCRICC,"
_cquery+="        RCG_DIAMES ANOMESDIA,"
_cquery+="        To_Char(To_Date(RCG_DIAMES,'YYYYMMDD'),'D') DIASEMANA,"
_cquery+="        RCG_TIPDIA TIPODIA,"
_cquery+="        CASE"
_cquery+="          WHEN RCG_TIPDIA = 4 THEN 0"
_cquery+="        ELSE"
_cquery+="          (SELECT SPJ1.PJ_HRTOTAL-SPJ1.PJ_HRSINT1 FROM SPJ010 SPJ1"
_cquery+="           WHERE SPJ1.D_E_L_E_T_ = ' ' AND SPJ1.PJ_DIA = To_Char(To_Date(RCG_DIAMES,'YYYYMMDD'),'D')"
_cquery+="           AND SPJ1.PJ_TURNO = SRA.RA_TNOTRAB AND SPJ1.PJ_SEMANA = '01')"
_cquery+="        END HORASATRAB"
_cquery+=" FROM "
_cquery+=  retsqlname("SRD")+" SRD,"
_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=  retsqlname("RCG")+" RCG,"
_cquery+=  retsqlname("CTT")+" CTT"
_cquery+=" WHERE"
_cquery+="     RCG.D_E_L_E_T_ = ' '"
_cquery+=" AND SRA.D_E_L_E_T_ = ' '"
_cquery+=" AND SRD.D_E_L_E_T_ = ' '"
_cquery+=" AND CTT.D_E_L_E_T_ = ' '"     
_cquery+=" AND RCG.RCG_FILIAL = '"+_cfilrcg+"'"
_cquery+=" AND SRA.RA_FILIAL = '"+_cfilsra+"'"
_cquery+=" AND SRD.RD_FILIAL = '"+_cfilsrd+"'"
_cquery+=" AND CTT.CTT_FILIAL = '"+_cfilctt+"'"
_cquery+=" AND CTT.CTT_CLASCC BETWEEN '1' AND '2'"
_cquery+=" AND SRD.RD_MAT = SRA.RA_MAT"
_cquery+=" AND CTT.CTT_CUSTO = SRD.RD_CC"
_cquery+=" AND SRD.RD_DATARQ = '"+substr(dtos(_dataini),1,6)+"'"
_cquery+=" AND RCG.RCG_DIAMES >= SRA.RA_ADMISSA"
_cquery+=" AND RCG.RCG_MES = '"+substr(dtos(_dataini),5,2)+"' AND RCG.RCG_ANO = '"+substr(dtos(_dataini),1,4)+"'"
_cquery+=" ORDER BY SRD.RD_MAT,RCG.RCG_DIAMES)"
_cquery+=" GROUP BY CLASCC, CC, DESCRICC"
_cquery+=" ORDER BY CLASCC, CC, DESCRICC"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"    

tcsetfield("TMP1","HRSATRAB","N",15,2)
tcsetfield("TMP1","HORASOPS","N",15,2)
 
return    


static function _query2(_cc)
_cquery2:=" SELECT "
_cquery2+=" CT3_CUSTO CC,"
_cquery2+=" Sum(CT3_DEBITO) DEBITO,"
_cquery2+=" Sum(CT3_CREDIT) CREDITO"
_cquery2+=" FROM "
_cquery2+=  retsqlname("CT3")+" CT3"
_cquery2+=" WHERE"
_cquery2+="     CT3.D_E_L_E_T_ = ' '"
_cquery2+=" AND CT3_FILIAL = '"+_cfilct3+"'"
_cquery2+=" AND CT3_DATA BETWEEN '"+dtos(_dataini)+"' AND '"+dtos(_datafim)+"'"
_cquery2+=" AND CT3_CUSTO = '"+_cc+"'"
_cquery2+=" AND (CT3_CONTA BETWEEN '35010103' AND '35010103ZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '35020103' AND '35020103ZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '350102'   AND '350102ZZZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '35010102' AND '35010102ZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '35010101' AND '35010101ZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '35020101' AND '35020101ZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '35020102' AND '35020102ZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '350198'   AND '350198ZZZZZZZ'"
_cquery2+=" OR CT3_CONTA BETWEEN '350202'   AND '350202ZZZZZZZ')"
_cquery2+=" AND CT3_TPSALD = '1'"
_cquery2+=" GROUP BY CT3_CUSTO"
_cquery2+=" ORDER BY CT3_CUSTO"

_cquery2:=changequery(_cquery2)
tcquery _cquery2 new alias "TMP2"    

tcsetfield("TMP2","DEBITO","N",15,2)
tcsetfield("TMP2","CREDITO","N",15,2)

return    

