/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITTRAB   ³ Autor ³ Claudio Ferreira     ³ Data ³ 14/09/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar Arquivo de Trabalho com Saldos por Lote              ³±±
±±³          ³ na Data Informada                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vittrb()              
cperg:="PERGVITTRB"
_pergsx1()
pergunte(cperg,.t.)
	
Processa({|| _gera()})

return()

static function _gera()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb7:=xfilial("SB7")
_cfilsb8:=xfilial("SB8")

procregua(0)
aStru:={}
aAdd (aStru, {"TRB_COD",	"C",	015,	0})
aAdd (aStru, {"TRB_LOCAL",	"C",	002,	0})
aAdd (aStru, {"TRB_LOTE",	"C",	010,	0})
aAdd (aStru, {"TRB_QTDE",	"N",	016,	4})
aAdd (aStru, {"TRB_QTD2",	"N",	016,	4})
aAdd (aStru, {"TRB_EMPE",	"N",	016,	4})
aAdd (aStru, {"TRB_EMP2",	"N",	016,	4})
//
cArq:="Trab"
dbCreate(cArq,aStru,"DBFCDXADS")
DbUseArea (.T., "DBFCDXADS", cArq, "TRB")
_cindtrb:=criatrab(,.f.)
_cchave :="TRB_COD+TRB_LOCAL+TRB_LOTE"
trb->(indregua("trb",_cindtrb,_cchave))

incproc("Selecionando registros...")
_cquery:=" SELECT"
_cquery+=" B1_COD,"
_cquery+=" B1_TIPO,"
_cquery+=" B1_RASTRO "


_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"

_cquery+=" ORDER BY"
_cquery+=" B1_COD"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
u_setfield("TMP1")

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	incproc("Processando "+tmp1->b1_cod)
	
    if tmp1->b1_rastro=="L"
		sb8->(dbsetorder(3))
		sb8->(dbseek(_cfilsb8+tmp1->b1_cod,.t.))
		while ! sb8->(eof()) .and.;
			sb8->b8_filial==_cfilsb8 .and.;
			sb8->b8_produto==tmp1->b1_cod 
			if sb8->b8_data<=ctod('31/12/2006')
			  sb8->(dbskip())	
			  loop
			endif
			_nsaldo  :=0
			_nsaldo2 :=0
			_nemp    :=0
			_nemp2   :=0
			_clocal  :=sb8->b8_local
			_clotectl:=sb8->b8_lotectl
            aSaldo:=CalcEstL(tmp1->b1_cod,_clocal,mv_par01+1,_clotectl,NIL)
            _nsaldo := (aSaldo)[ 1 ]             
            _nsaldo2:= (aSaldo)[ 7 ]
            aEmpe:=CalcSD4(tmp1->b1_cod,_clocal,_clotectl,mv_par01,_cfilsb8)
            _nemp := (aEmpe)[ 1 ]             
            _nemp2:= (aEmpe)[ 2 ] 				
			if _nsaldo+_nsaldo2>0 .or. _nemp+_nemp2>0
					reclock("TRB",iif(TRB->(dbseek(tmp1->b1_cod+_clocal+_clotectl)),.f.,.t.))
					TRB_COD  :=tmp1->b1_cod
					TRB_LOCAL:=_clocal
                    TRB_QTDE :=_nsaldo 
                    TRB_QTD2 :=_nsaldo2
                    TRB_EMPE :=_nemp
                    TRB_EMP2 :=_nemp2
         			TRB_LOTE :=_clotectl
					msunlock()
			endif
			sb8->(dbskip())
		enddo
	else
		sb2->(dbsetorder(1))
		sb2->(dbseek(_cfilsb2+tmp1->b1_cod,.t.))
		while ! sb2->(eof()) .and.;
			sb2->b2_filial==_cfilsb2 .and.;
			sb2->b2_cod==tmp1->b1_cod 
			_nsaldo  :=0
			_nsaldo2 :=0
			_nemp    :=0
			_nemp2   :=0
			_clocal  :=sb2->b2_local
            aSaldo:=CalcEst(tmp1->b1_cod,_clocal,mv_par01+1,_cfilsb8)
            _nsaldo := (aSaldo)[ 1 ]             
            _nsaldo2:= (aSaldo)[ 7 ]
            aEmpe:=CalcSD4(tmp1->b1_cod,_clocal,nil,mv_par01,_cfilsb8)
            _nemp := (aEmpe)[ 1 ]             
            _nemp2:= (aEmpe)[ 2 ] 				
			if _nsaldo+_nsaldo2>0 .or. _nemp+_nemp2>0
					reclock("TRB",iif(TRB->(dbseek(tmp1->b1_cod+_clocal+_clotectl)),.f.,.t.))
					TRB_COD  :=tmp1->b1_cod
					TRB_LOCAL:=_clocal
                    TRB_QTDE :=_nsaldo 
                    TRB_QTD2 :=_nsaldo2
                    TRB_EMPE :=_nemp
                    TRB_EMP2 :=_nemp2
         			TRB_LOTE :=''
					msunlock()
			endif			
			sb2->(dbskip())
		end
	endif
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

TRB->(DbCloseArea ())
//COPY FILE "\"+cArq+".dbf" to "c:\"
//Ferase (cArq+GetDBExtension())    
ferase(_cindtrb+ordbagext())

return()

Static Function CalcSD4(xProd,xDep,xLote,xData,xFilial)
LOCAL XAREA
Local _ret,cQuery
XAREA=ALIAS()
cQuery := "SELECT SUM(D4_QUANT) AS QTDEMP,SUM(D4_QTSEGUM) AS QTDEMP2  "
cQuery += "FROM "+RetSqlName("SD4")+" A"
cQuery += " WHERE A.D_E_L_E_T_<>'*'"
cQuery += " AND D4_COD='"+xProd+"'"
cQuery += " AND D4_LOCAL='"+xDep+"'"
if xLote<>nil
  cQuery += " AND D4_LOTECTL='"+xLote+"'"
endif  
cQuery += " AND D4_DATA<='"+DTOS(xData)+"'"
cQuery += " AND D4_FILIAL='"+xFilial+"'"
TCQUERY cQuery NEW ALIAS "_PRO"
dbSelectArea("_PRO")
_ret:={0,0}
if !eof()
  _Ret:={_PRO->QTDEMP,_PRO->QTDEMP2}
endif
dbCloseArea()
SELE &XAREA
RETURN _Ret 

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Data referencia              ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Do produto                   ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Ate o produto                ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})

for _ni:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_ni,1]+_agrpsx1[_ni,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_ni,01]
		sx1->x1_ordem  :=_agrpsx1[_ni,02]
		sx1->x1_pergunt:=_agrpsx1[_ni,03]
		sx1->x1_variavl:=_agrpsx1[_ni,04]
		sx1->x1_tipo   :=_agrpsx1[_ni,05]
		sx1->x1_tamanho:=_agrpsx1[_ni,06]
		sx1->x1_decimal:=_agrpsx1[_ni,07]
		sx1->x1_presel :=_agrpsx1[_ni,08]
		sx1->x1_gsc    :=_agrpsx1[_ni,09]
		sx1->x1_valid  :=_agrpsx1[_ni,10]
		sx1->x1_var01  :=_agrpsx1[_ni,11]
		sx1->x1_def01  :=_agrpsx1[_ni,12]
		sx1->x1_cnt01  :=_agrpsx1[_ni,13]
		sx1->x1_var02  :=_agrpsx1[_ni,14]
		sx1->x1_def02  :=_agrpsx1[_ni,15]
		sx1->x1_cnt02  :=_agrpsx1[_ni,16]
		sx1->x1_var03  :=_agrpsx1[_ni,17]
		sx1->x1_def03  :=_agrpsx1[_ni,18]
		sx1->x1_cnt03  :=_agrpsx1[_ni,19]
		sx1->x1_var04  :=_agrpsx1[_ni,20]
		sx1->x1_def04  :=_agrpsx1[_ni,21]
		sx1->x1_cnt04  :=_agrpsx1[_ni,22]
		sx1->x1_var05  :=_agrpsx1[_ni,23]
		sx1->x1_def05  :=_agrpsx1[_ni,24]
		sx1->x1_cnt05  :=_agrpsx1[_ni,25]
		sx1->x1_f3     :=_agrpsx1[_ni,26]
		sx1->(msunlock())
	endif
next
return()
