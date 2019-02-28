/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Programa  ³ FA280    ³ Autor ³ Heraildo C. de Freitas³ Data ³ 08/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para Atualizar os Dados das Faturas a     ³±±
±±³          ³ Receber                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function fa280()
_cfilse1:=xfilial("SE1")

_cquery:=" SELECT"
_cquery+=" E1_VEND1 VEND1,E1_VEND2 VEND2,E1_VEND3 VEND3,E1_VEND4 VEND4,"
_cquery+=" E1_VEND5 VEND5,E1_COMIS1 COMIS1,E1_COMIS2 COMIS2,E1_COMIS3 COMIS3,"
_cquery+=" E1_COMIS4 COMIS4,E1_COMIS5 COMIS5,E1_PORCJUR PORCJUR,"
_cquery+=" SUM(E1_BASCOM1) BASCOM1,SUM(E1_BASCOM2) BASCOM2,"
_cquery+=" SUM(E1_BASCOM3) BASCOM3,SUM(E1_BASCOM4) BASCOM4,"
_cquery+=" SUM(E1_BASCOM5) BASCOM5,SUM(E1_VALCOM1) VALCOM1,"
_cquery+=" SUM(E1_VALCOM2) VALCOM2,SUM(E1_VALCOM3) VALCOM3,"
_cquery+=" SUM(E1_VALCOM4) VALCOM4,SUM(E1_VALCOM5) VALCOM5"
_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_FATPREF='"+se1->e1_prefixo+"'"
_cquery+=" AND E1_FATURA='"+se1->e1_num+"'"
/*_cquery+=" AND E1_PARCELA='"+se1->e1_parcela+"'"*/
_cquery+=" AND E1_TIPOFAT='"+se1->e1_tipo+"'"
_cquery+=" GROUP BY "
_cquery+=" E1_VEND1,E1_VEND2,E1_VEND3,E1_VEND4,E1_VEND5,E1_COMIS1,E1_COMIS2,"
_cquery+=" E1_COMIS3,E1_COMIS4,E1_COMIS5,E1_PORCJUR"
	
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","COMIS1" ,"N",05,2)
tcsetfield("TMP1","COMIS2" ,"N",05,2)
tcsetfield("TMP1","COMIS3" ,"N",05,2)
tcsetfield("TMP1","COMIS4" ,"N",05,2)
tcsetfield("TMP1","COMIS5" ,"N",05,2)
tcsetfield("TMP1","PORCJUR","N",05,2)
tcsetfield("TMP1","BASCOM1","N",15,2)
tcsetfield("TMP1","BASCOM2","N",15,2)
tcsetfield("TMP1","BASCOM3","N",15,2)
tcsetfield("TMP1","BASCOM4","N",15,2)
tcsetfield("TMP1","BASCOM5","N",15,2)
tcsetfield("TMP1","VALCOM1","N",15,2)
tcsetfield("TMP1","VALCOM2","N",15,2)
tcsetfield("TMP1","VALCOM3","N",15,2)
tcsetfield("TMP1","VALCOM4","N",15,2)
tcsetfield("TMP1","VALCOM5","N",15,2)

tmp1->(dbgotop())
se1->(reclock("SE1",.f.))
se1->e1_vend1  :=tmp1->vend1  
se1->e1_vend2  :=tmp1->vend2  
se1->e1_vend3  :=tmp1->vend3  
se1->e1_vend4  :=tmp1->vend4  
se1->e1_vend5  :=tmp1->vend5  
se1->e1_comis1 :=tmp1->comis1 
se1->e1_comis2 :=tmp1->comis2 
se1->e1_comis3 :=tmp1->comis3 
se1->e1_comis4 :=tmp1->comis4 
se1->e1_comis5 :=tmp1->comis5 
se1->e1_porcjur:=tmp1->porcjur
se1->e1_bascom1:=tmp1->bascom1
se1->e1_bascom2:=tmp1->bascom2
se1->e1_bascom3:=tmp1->bascom3
se1->e1_bascom4:=tmp1->bascom4
se1->e1_bascom5:=tmp1->bascom5
se1->e1_valcom1:=tmp1->valcom1
se1->e1_valcom2:=tmp1->valcom2
se1->e1_valcom3:=tmp1->valcom3
se1->e1_valcom4:=tmp1->valcom4
se1->e1_valcom5:=tmp1->valcom5
se1->(msunlock())
tmp1->(dbclosearea())
return