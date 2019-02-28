/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITGSB7   ³ Autor ³ Claudio Ferreira     ³ Data ³ 14/09/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Analisa Arquivo de Trabalho Compara com Saldos por Lote    ³±±
±±³          ³ e Gera Invetario de Ajuste                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vitgsb7()              
cperg:="PERGVITGB7"
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

dData:=mv_par01

//
cArq:="Trab"
DbUseArea (.T., "DBFCDXADS", cArq, "TRB")
_cindtrb:=criatrab(,.f.)
_cchave :="TRB_COD+TRB_LOCAL+TRB_LOTE"
trb->(indregua("trb",_cindtrb,_cchave))


_cindsb7:=criatrab(,.f.)
_cchave :="B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOTECTL"
sb7->(indregua("SB7",_cindsb7,_cchave))

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
			
			if sb7->(dbseek(_cfilsb7+dtos(dData)+tmp1->b1_cod+_clocal+_clotectl))
			  sb8->(dbskip())	
			  loop			  
			endif   
			
			//Verifica se tem saldo no TRB
			if TRB->(dbseek(tmp1->b1_cod+_clocal+_clotectl))
				reclock("SB7",.t.)
				sb7->b7_filial :=_cfilsb7
				sb7->b7_cod    :=tmp1->b1_cod
				sb7->b7_local  :=_clocal
				sb7->b7_tipo   :=tmp1->b1_tipo
				sb7->b7_doc    :='IV'+substr(dtoc(dData),1,2)+substr(dtoc(dData),4,2)
				sb7->b7_quant  :=TRB->TRB_QTDE + TRB->TRB_EMPE
				sb7->b7_qtsegum:=TRB->TRB_QTD2 + TRB->TRB_EMP2
				sb7->b7_data   :=dData
				sb7->b7_lotectl:=_clotectl				
			else
				reclock("SB7",.t.)
				sb7->b7_filial :=_cfilsb7
				sb7->b7_cod    :=tmp1->b1_cod
				sb7->b7_local  :=_clocal
				sb7->b7_tipo   :=tmp1->b1_tipo
				sb7->b7_doc    :='IV'+substr(dtoc(dData),1,2)+substr(dtoc(dData),4,2)
				sb7->b7_quant  :=0
				sb7->b7_qtsegum:=0
				sb7->b7_data   :=dData
				sb7->b7_lotectl:=_clotectl
			endif  
			msunlock()          
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
			
			if sb7->(dbseek(_cfilsb2+dtos(dData)+tmp1->b1_cod+_clocal))
			  sb2->(dbskip())	
			  loop			  
			endif 
			
			//Verifica se tem saldo no TRB
			if TRB->(dbseek(tmp1->b1_cod+_clocal))
				reclock("SB7",.t.)
				sb7->b7_filial :=_cfilsb7
				sb7->b7_cod    :=tmp1->b1_cod
				sb7->b7_local  :=_clocal
				sb7->b7_tipo   :=tmp1->b1_tipo
				sb7->b7_doc    :='IV'+substr(dtoc(dData),1,2)+substr(dtoc(dData),4,2)
				sb7->b7_quant  :=TRB->TRB_QTDE + TRB->TRB_EMPE
				sb7->b7_qtsegum:=TRB->TRB_QTD2 + TRB->TRB_EMP2
				sb7->b7_data   :=dData
				sb7->b7_lotectl:=''				
			else
				reclock("SB7",.t.)
				sb7->b7_filial :=_cfilsb7
				sb7->b7_cod    :=tmp1->b1_cod
				sb7->b7_local  :=_clocal
				sb7->b7_tipo   :=tmp1->b1_tipo
				sb7->b7_doc    :='IV'+substr(dtoc(dData),1,2)+substr(dtoc(dData),4,2)
				sb7->b7_quant  :=0
				sb7->b7_qtsegum:=0
				sb7->b7_data   :=dData
				sb7->b7_lotectl:=''
			endif
			msunlock()		
			sb2->(dbskip())
		end
	endif
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

TRB->(DbCloseArea ())

ferase(_cindtrb+ordbagext())
sb7->(retindex("SB7"))
ferase(_cindsb7+ordbagext())

return()


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
