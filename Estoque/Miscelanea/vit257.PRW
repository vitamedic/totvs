/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ geraarq74³ Autor ³ Aline b. Pereira      ³ Data ³ 10/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do Sintegra para Tratamento do                     ³±±
±±³          ³ Registro 74                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit257(_lSc)
_cperg := "PERGvit257"

_pergsx1()

if pergunte(_cPerg,.t.)
	processa({|| _geraarq()})
	msginfo("Arquivos gerados com sucesso!")
endif
return

//

Static function _geraarq()
procregua(sb9->(lastrec()))

_carq:="reg74.txt"
_nhandle:=fcreate("\temp\"+_carq,0)
if _nhandle<0
	msginfo("Erro na criacao do arquivo "+_carq)
	_lcontinua:=.f.
else
	_lcontinua:=.t.
endif

if _lcontinua
	
	_cfilsb9:=xfilial("SB9")
	_cfilsb1:=xfilial("SB1")
	_cfilszz:=xfilial("SZZ")
	
	_cquery:=" SELECT "
	_cquery+=" CODPROD,"
	_cquery+=" TIPO,"
	_cquery+=" SUM(QINI) QINI,"
	_cquery+=" SUM(VINI1) VINI1"
	_cquery+=" FROM ("
	
	_cquery+=" SELECT"						// ESTOQUE 
	_cquery+=" B9_COD CODPROD,"
	_cquery+=" '1' TIPO,"
	_cquery+=" SUM(B9_QINI) QINI,"
	_cquery+=" SUM(B9_VINI1) VINI1"
	_cquery+=" FROM "      
	_cquery+=  retsqlname("SB9")+" SB9"
	_cquery+=" WHERE"
	_cquery+="     SB9.D_E_L_E_T_<>'*'"
	_cquery+=" AND B9_FILIAL='"+_cfilsb9+"'"
	_cquery+=" AND B9_LOCAL BETWEEN '  ' AND 'ZZ'"
	_cquery+=" AND B9_QINI>0"
	_cquery+=" AND B9_DATA='"+dtos(mv_par01)+"'"
	_cquery+=" GROUP BY B9_COD, 2"

	_cquery+=" 	UNION ALL "  		

	_cquery+=" SELECT"						// ESTOQUE EM ELABORACAO
	_cquery+=" ZZ_PRODUTO CODPROD,"
	_cquery+=" '1' TIPO,"
	_cquery+=" SUM(ZZ_QTPROC) QINI,"
	_cquery+=" SUM(ZZ_VLPROC) VINI1"
	_cquery+=" FROM "      
	_cquery+=  retsqlname("SZZ")+" SZZ"
	_cquery+=" WHERE"
	_cquery+="     SZZ.D_E_L_E_T_<>'*'"
	_cquery+=" AND ZZ_FILIAL='"+_cfilszz+"'"
	_cquery+=" AND ZZ_QTPROC>0"
	_cquery+=" AND ZZ_DATA='"+dtos(mv_par01)+"'"
	_cquery+=" GROUP BY ZZ_PRODUTO, 2"


	_cquery+=" 	UNION ALL "  		

	_cquery+=" SELECT"						// ESTOQUE EM ELABORACAO
	_cquery+=" ZZ_PRODUTO CODPROD,"
	_cquery+=" '2' TIPO,"
	_cquery+=" SUM(ZZ_QTTERC) QINI,"   
	_cquery+=" SUM(ZZ_VLTERC) VINI1"
	_cquery+=" FROM "      
	_cquery+=  retsqlname("SZZ")+" SZZ"
	_cquery+=" WHERE"
	_cquery+="     SZZ.D_E_L_E_T_<>'*'"
	_cquery+=" AND ZZ_FILIAL='"+_cfilszz+"'"
	_cquery+=" AND ZZ_QTTERC>0"
	_cquery+=" AND ZZ_DATA='"+dtos(mv_par01)+"'"
	_cquery+=" GROUP BY ZZ_PRODUTO, 2"

	_cquery+=" )"
	_cquery+=" GROUP BY CODPROD, TIPO"
	_cquery+=" ORDER BY CODPROD, TIPO"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","QINI" ,"N",13,3)
	tcsetfield("TMP1","VINI1","N",13,2)
	
	tmp1->(dbgotop())
	while ! tmp1->(eof())
		incproc("Processando produto "+tmp1->codprod)
		
		_ncnpj :=strzero(0,14,0)
		_ddata:=dtos(mv_par01)
		fwrite(_nhandle,"74")
		fwrite(_nhandle,_ddata)
		fwrite(_nhandle,left(tmp1->codprod,14))
		fwrite(_nhandle,strzero(tmp1->qini*1000,13))
		fwrite(_nhandle,strzero(tmp1->vini1*100,13))
		fwrite(_nhandle,left(tmp1->tipo,1))
		fwrite(_nhandle,_ncnpj)
		fwrite(_nhandle,space(14))
		fwrite(_nhandle,"GO")
		fwrite(_nhandle,space(45))
		fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
		tmp1->(dbskip())
	end     
	tmp1->(dbgotop())    
	_produto:=""
	while ! tmp1->(eof())

		if _produto<>tmp1->codprod 
					
			_produto:=tmp1->codprod

			incproc("Processando produto "+tmp1->codprod)
			
			_ncnpj :=strzero(0,14,0)
			
			_ddata:=dtos(mv_par01)
	
		    _dia:=val("01")
	    	_mes:=month(mv_par01)
			_ano:=year(mv_par01)           
			_dataini:=strzero(_ano,4)+strzero(_mes,2)+strzero(_dia,2)
	    
			fwrite(_nhandle,"75")
			fwrite(_nhandle,_dataini)
			fwrite(_nhandle,_ddata)
			sb1->(dbseek(_cfilsb1+tmp1->codprod))
			fwrite(_nhandle,left(tmp1->codprod,14))
			fwrite(_nhandle,left(sb1->b1_posipi,8))
			fwrite(_nhandle,substr(sb1->b1_desc,1,40)+space(13))
			fwrite(_nhandle,sb1->b1_um+space(04))
			fwrite(_nhandle,strzero(0,27))
			fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
		endif
		tmp1->(dbskip())
	end     
endif
fclose(_nhandle)
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Data de fechamento ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return
