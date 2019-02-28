/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT251   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 17/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Registro de Inventario                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit251()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="REGISTRO DE INVENTARIO"
cdesc1   :="Este programa ira emitir o registro de inventário"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT251"
wnrel    :="VIT251"+Alltrim(cusername)
aordem   :={}
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT251"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
nordem:=areturn[8]
if nlastkey==27
	set filter to
	return
endif
rptstatus({|| rptdetail()})
return

static function rptdetail()
cbcont:=0
m_pag :=mv_par15
li    :=80
cbtxt :=space(10)

titulo:="REGISTRO DE INVENTARIO"

_cfilct1:=xfilial("CT1")
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb9:=xfilial("SB9")
_cfilsbj:=xfilial("SBJ")
_cfilsd1:=xfilial("SD1")
_cfilsn1:=xfilial("SN1")
_cfilsn3:=xfilial("SN3")

processa({|| _geratmp()})

setprc(0,0)
_impcab()

setregua(0)

_ntotger:=0
_ntotest:=0
_ntotativo:=0
_ntotterc:=0
_ntotproc:=0

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	
	_tipo:= tmp1->tipo
		
	@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
	@ prow()+1,000 PSAY "|             |"
	if _tipo=="1"
		@ prow(),016   PSAY left("*********** EM ESTOQUE *************",36)
	elseif _tipo=="2"
		@ prow(),016   PSAY left("******* ESTOQUE EM ELABORACAO ******",36)
	elseif _tipo=="3"
		@ prow(),016   PSAY left("*** ESTOQUE EM PODER DE TERCEIROS **",36)
	elseif _tipo=="4"
		@ prow(),016   PSAY left("************** ATIVO ***************",36)
	endif		                                  
	
	@ prow(),053   PSAY "|    |    |              |                |                |                  |"
	@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
//	@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"

	while ! tmp1->(eof()) .and.;
		tmp1->tipo==_tipo .and.;
		lcontinua
		
		if prow()>56
			@ prow()+1,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
			@ 66,00 PSAY " "
				
			if mv_par21 == 1
				eject      // esta linha deve ser incluída para emissão do relatório em imp. jato de tinta ou laser
			endif
				
			setprc(0,0)
			_impcab()
		endif

		ct1->(dbsetorder(1))
		ct1->(dbseek(_cfilct1+tmp1->conta))
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		if !empty(ct1->ct1_desc01)
			@ prow(),016   PSAY left(ct1->ct1_desc01,36)
		else
			@ prow(),016   PSAY left("MAO DE OBRA",36)
		endif
		@ prow(),053   PSAY "|    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		
		_limpconta:=.f.
		_ntotconta:=0
		_cconta   :=tmp1->conta
		while ! tmp1->(eof()) .and.;
			tmp1->conta==_cconta .and.;
			lcontinua
			
			incregua()
			
	/*
			if tmp1->tipo=="3"
				msgstop("teste")
			endif
	*/
			_nqtdori:=tmp1->quant
			if tmp1->tipo=="1" // PRODUTOS
				_asaldodt:=saldoterc(tmp1->cod,mv_par01,"D",mv_par11,mv_par02)
				_nquant:=tmp1->quant-_asaldodt[1]
			else
				_nquant:=tmp1->quant
			endif
			
			if _nquant>0 .or. tmp1->tipo=="4"
				
				_nvalor:=tmp1->valor
				
				if tmp1->tipo=="1" .and.;
					mv_par22==1 .and.;
					mv_par23<>3 // CONSIDERA IMPORTACAO APENAS QUANDO FOR PRODUTO E O SALDO A CONSIDERAR FOR PELO FECHAMENTO (SB9)
					
					_cquery:=" SELECT"
					_cquery+=" SUM(BJ_QINI) BJ_QINI"
					
					_cquery+=" FROM "
					_cquery+=  retsqlname("SBJ")+" SBJ"
					
					_cquery+=" WHERE"
					_cquery+="     SBJ.D_E_L_E_T_=' '"
					_cquery+=" AND BJ_FILIAL='"+_cfilsbj+"'"
					_cquery+=" AND BJ_DATA='"+dtos(mv_par11)+"'"
					_cquery+=" AND BJ_COD='"+tmp1->cod+"'"
					_cquery+=" AND BJ_QINI>0"
					_cquery+=" AND EXISTS ("
					_cquery+="     SELECT"
					_cquery+="     D1_LOTECTL"
					_cquery+="     FROM "
					_cquery+=      retsqlname("SD1")+" SD1"
					_cquery+="     WHERE"
					_cquery+="         SD1.D_E_L_E_T_=' '"
					_cquery+="     AND D1_FILIAL='"+_cfilsd1+"'"
					_cquery+="     AND D1_COD=BJ_COD"
					_cquery+="     AND D1_TIPO='N'"
					_cquery+="     AND D1_LOTECTL=BJ_LOTECTL"
					_cquery+="     AND SUBSTR(D1_CF,1,1)='3')"
					
					_cquery:=changequery(_cquery)
					
					tcquery _cquery new alias "TMP2"
					u_setfield("TMP2")
					
					tmp2->(dbgotop())
					_nqinibj:=tmp2->bj_qini
					tmp2->(dbclosearea())
					
					dbselectarea("TMP1")
				endif
				
				if mv_par23==1 // SOMENTE IMPORTACAO
					_nquant:=_nqinibj
					_nvalor:=round((tmp1->valor/_nqtdori)*_nquant,2)
				elseif mv_par23==2 // SEM IMPORTACAO
					_nquant-=_nqinibj
					_nvalor:=round((tmp1->valor/_nqtdori)*_nquant,2)
				endif
				
				if _nquant>0
					
					_limpconta:=.t.
					
					if prow()>56
						@ prow()+1,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
						@ 66,00 PSAY " "
						
						if mv_par21 == 1
							eject      // esta linha deve ser incluída para emissão do relatório em imp. jato de tinta ou laser
						endif
						
						setprc(0,0)
						_impcab()
					endif
					
					@ prow()+1,000 PSAY "|"
					if mv_par24 == 2  // TIPO DE CODIGO (1-Código / 2-Pos IPI/NCM)
						@ prow(),002   PSAY tmp1->posipi
					else 		
						@ prow(),002   PSAY substr(tmp1->cod,1,10)// CODIGO DO SB1 e SN3
					endif
					@ prow(),014   PSAY "|"
					@ prow(),016   PSAY left(tmp1->descri,36)
					@ prow(),053   PSAY "|"
					@ prow(),055   PSAY tmp1->tipoprod
					@ prow(),058   PSAY "|"
					@ prow(),060   PSAY tmp1->um
					@ prow(),063   PSAY "|"
					@ prow(),064   PSAY _nquant picture "@E 999,999,999.99"
					@ prow(),078   PSAY "|"
					@ prow(),079   PSAY _nvalor/_nquant picture "@E 999,999,999.9999"
					@ prow(),095   PSAY "|"
					@ prow(),096   PSAY _nvalor picture "@E 9,999,999,999.99"
					@ prow(),112   PSAY "|                  |"
					_ntotconta+=_nvalor
		    		if tmp1->tipo="1"
		    			_ntotest+=_nvalor
					elseif tmp1->tipo="2"   // Estoque em Elaboração
						_ntotproc+=_nvalor
					elseif tmp1->tipo="3"   // Poder de Terceiros
						_ntotterc+=_nvalor
					elseif tmp1->tipo=="4"  // ATIVO
						_ntotativo+=_nvalor
					endif
				endif
			endif
			
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
			
			tmp1->(dbskip())
		end
		
		if lcontinua .and.;
			_limpconta
			
			if prow()>56
				@ prow()+1,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
				@ 66,00 PSAY " "
					
				if mv_par21 == 1
					eject      // esta linha deve ser incluída para emissão do relatório em imp. jato de tinta ou laser
				endif
					
				setprc(0,0)
				_impcab()
			endif

			@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
			@ prow()+1,000 PSAY "|             |"
			ct1->(dbseek(_cfilct1+_cconta))
			
			if !empty(ct1->ct1_desc01)
				@ prow(),016   PSAY left("TOTAL "+ct1->ct1_desc01,36)
			else
				@ prow(),016   PSAY left("TOTAL MAO DE OBRA",36)
			endif
			@ prow(),053   PSAY "|    |    |              |                |                |"
			@ prow(),113   PSAY _ntotconta picture "@E 999,999,999,999.99"
			@ prow(),131   PSAY "|"
			@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
			@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
			_ntotger+=_ntotconta
		endif               
	end


/*
	if _tipo=="1"  //Saldo em Estoque
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		@ prow(),016   PSAY "TOTAL EM ESTOQUE"
		@ prow(),053   PSAY "|    |    |              |                |                |"
		@ prow(),113   PSAY _ntotest picture "@E 999,999,999,999.99"
		@ prow(),131   PSAY "|"
	endif
*/
	if _tipo=="2" .and. mv_par26==1 //Imprime Sld.Processo?
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		@ prow(),016   PSAY "TOTAL ESTOQUE EM ELABORACAO"
		@ prow(),053   PSAY "|    |    |              |                |                |"
		@ prow(),113   PSAY _ntotproc picture "@E 999,999,999,999.99"
		@ prow(),131   PSAY "|"
	endif	

	if _tipo=="3" .and. mv_par25==1 //Imprime Sld.Poder 3º?
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		@ prow(),016   PSAY "TOTAL ESTOQUE EM PODER DE TERCEIROS"
		@ prow(),053   PSAY "|    |    |              |                |                |"
		@ prow(),113   PSAY _ntotterc picture "@E 999,999,999,999.99"
		@ prow(),131   PSAY "|"
	endif
	if _tipo=="4" .and. mv_par16==1 //Imprime ativo fixo ?
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		@ prow(),016   PSAY "TOTAL DO ATIVO"
		@ prow(),053   PSAY "|    |    |              |                |                |"
		@ prow(),113   PSAY _ntotativo picture "@E 999,999,999,999.99"
		@ prow(),131   PSAY "|"
	endif
end

if lcontinua

	@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
	@ prow()+1,000 PSAY "|             |"
	@ prow(),016   PSAY "********** RESUMO **********"
	@ prow(),053   PSAY "|    |    |              |                |                |                  |"

	@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
	@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
	@ prow()+1,000 PSAY "|             |"
	@ prow(),016   PSAY "TOTAL EM ESTOQUE"
	@ prow(),053   PSAY "|    |    |              |                |                |"
	@ prow(),113   PSAY _ntotest picture "@E 999,999,999,999.99"
	@ prow(),131   PSAY "|"

	if mv_par26==1 .and. _ntotproc>0 //Imprime Sld.Processo?
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		@ prow(),016   PSAY "TOTAL ESTOQUE EM ELABORACAO"
		@ prow(),053   PSAY "|    |    |              |                |                |"
		@ prow(),113   PSAY _ntotproc picture "@E 999,999,999,999.99"
		@ prow(),131   PSAY "|"
	endif
	if mv_par25==1 .and. _ntotterc>0 //Imprime Sld.Poder 3º?
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		@ prow(),016   PSAY "TOTAL ESTOQUE EM PODER DE TERCEIROS"
		@ prow(),053   PSAY "|    |    |              |                |                |"
		@ prow(),113   PSAY _ntotterc picture "@E 999,999,999,999.99"
		@ prow(),131   PSAY "|"
	endif
	if mv_par16==1 //Imprime ativo fixo ?
		@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
		@ prow()+1,000 PSAY "|             |"
		@ prow(),016   PSAY "TOTAL DO ATIVO"
		@ prow(),053   PSAY "|    |    |              |                |                |"
		@ prow(),113   PSAY _ntotativo picture "@E 999,999,999,999.99"
		@ prow(),131   PSAY "|"
	endif
	@ prow()+1,000 PSAY "|             |                                      |    |    |              |                |                |                  |"
	@ prow()+1,000 PSAY "|             |"
	@ prow(),016   PSAY "TOTAL GERAL DO INVENTARIO"
	@ prow(),053   PSAY "|    |    |              |                |                |"
	@ prow(),113   PSAY _ntotger picture "@E 999,999,999,999.99"
	@ prow(),131   PSAY "|"
	@ prow()+1,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
endif
tmp1->(dbclosearea())

set device to screen

setpgeject(.f.)
if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return()

static function _impcab()
@ 000,000      PSAY avalimp(limite)
@ prow()+1,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
@ prow()+1,000 PSAY "|                                                     REGISTRO DE INVENTARIO                                                       |"
@ prow()+1,000 PSAY "|                                                                                                                                  |"
@ prow()+1,000 PSAY "| FIRMA: "+sm0->m0_nomecom
@ prow(),131   PSAY "|"
@ prow()+1,000 PSAY "|                                                                                                                                  |"
@ prow()+1,000 PSAY "| INSC.EST.: "+sm0->m0_insc
@ prow(),032   PSAY "C.N.P.J.: "+transform(sm0->m0_cgc,"@R 99.999.999/9999-99")
@ prow(),131   PSAY "|"
@ prow()+1,000 PSAY "|                                                                                                                                  |"
@ prow()+1,000 PSAY "| FOLHA: "+strzero(m_pag,3)
@ prow(),032   PSAY "ESTOQUES EXISTENTES EM: "+dtoc(mv_par11)
@ prow(),131   PSAY "|"
@ prow()+1,000 PSAY "|                                                                                                                                  |"
@ prow()+1,000 PSAY "|----------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "|             |                                      |    |    |              |                       VALORES                      |"
@ prow()+1,000 PSAY "|CLASSIFICACAO|                                      |    |    |              |---------------------------------+------------------|"
@ prow()+1,000 PSAY "|    FISCAL   |     D I S C R I M I N A C A O        |TIPO|UNID|  QUANTIDADE  |   UNITARIO     |   PARCIAL      |     TOTAL        |"
@ prow()+1,000 PSAY "|-------------+--------------------------------------+----+----+--------------+----------------+----------------+------------------|"
m_pag++
return()

static function _geratmp()
procregua(1)

incproc("Selecionando produtos...")

_cquery:=" SELECT"
_cquery+=" B1_CONTA CONTA,"
_cquery+=" B1_COD COD,"
_cquery+=" B1_POSIPI POSIPI,"
_cquery+=" B1_DESC DESCRI,"
_cquery+=" B1_UM UM,"
_cquery+=" B1_TIPO TIPOPROD,"
_cquery+=" '1' TIPO,"
if mv_par22==1 // FECHAMENTO SB9
	_cquery+=" SUM(B9_QINI) QUANT,"
	_cquery+=" SUM(B9_VINI1) VALOR"
else // FIM DO MES SB2
	_cquery+=" SUM(B2_QFIM) QUANT,"
	_cquery+=" SUM(B2_VFIM1) VALOR"
endif

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
if mv_par22==1
	_cquery+=  retsqlname("SB9")+" SB9"
else
	_cquery+=  retsqlname("SB2")+" SB2"
endif

_cquery+=" WHERE"

if mv_par22==1
	_cquery+="     SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SB9.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND B9_FILIAL='"+_cfilsb9+"'"
	_cquery+=" AND B9_COD=B1_COD"
	_cquery+=" AND B9_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	_cquery+=" AND B9_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND B9_CONTA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	_cquery+=" AND B9_DATA='"+dtos(mv_par11)+"'"
	_cquery+=" AND (B9_QINI<>0 OR B9_VINI1<>0) "
	if mv_par12==2 // Prod.c/saldo negat.?
		_cquery+=" AND B9_QINI>=0"
	endif
	if mv_par13==2 // Prod.c/saldo zerado?
		_cquery+=" AND B9_QINI>0"
	endif
	if mv_par14==2 // Prod.c/custo zerado?
		_cquery+=" AND B9_VINI1>0"
	endif
else
	_cquery+="     SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SB2.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND B2_FILIAL='"+_cfilsb2+"'"
	_cquery+=" AND B2_COD=B1_COD"
	_cquery+=" AND B2_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	_cquery+=" AND B2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND B1_CONTA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	_cquery+=" AND (B2_QFIM<>0 OR B2_VFIM1<>0) "

	if mv_par12==2 // Prod.c/saldo negat.?
		_cquery+=" AND B2_QFIM>=0"
	endif
	if mv_par13==2 // Prod.c/saldo zerado?
		_cquery+=" AND B2_QFIM>0"
	endif
	if mv_par14==2 // Prod.c/custo zerado?
		_cquery+=" AND B2_VFIM1>0"
	endif
endif

	_cquery+=" GROUP BY"
	_cquery+=" B1_CONTA,B1_COD,B1_POSIPI,B1_DESC,B1_UM,B1_TIPO,'P'"

//	_cquery+=" GROUP BY"
//	_cquery+=" B9_CONTA,B9_COD,B1_POSIPI,B1_DESC,B1_UM,B9_TIPO,'P'"
                
if mv_par16==1 // Imprime ativo fixo ?
	_cquery+=" UNION ALL"
	_cquery+=" SELECT"
	_cquery+=" N3_CCONTAB CONTA,"
	_cquery+=" N3_CBASE||N3_ITEM COD,"
	_cquery+=" '          ' POSIPI,"
	_cquery+=" N3_HISTOR DESCRI,"
	_cquery+=" '  ' UM,"
	_cquery+=" 'PT' TIPOPROD,"
	_cquery+=" '4' TIPO,"
	_cquery+=" N1_QUANTD QUANT,"
	_cquery+=" N3_VORIG1 VALOR"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SN1")+" SN1,"
	_cquery+=  retsqlname("SN3")+" SN3"
	
	_cquery+=" WHERE"
	_cquery+="     SN1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SN3.D_E_L_E_T_<>'*'"
	_cquery+=" AND N1_FILIAL='"+_cfilsn1+"'"
	_cquery+=" AND N3_FILIAL='"+_cfilsn3+"'"
	_cquery+=" AND N3_CBASE=N1_CBASE"
	_cquery+=" AND N3_ITEM=N1_ITEM"
	_cquery+=" AND N3_CCONTAB BETWEEN '"+mv_par17+"' AND '"+mv_par18+"'"
	//	_cquery+=" AND N3_AQUISIC BETWEEN '"+dtos(mv_par19)+"' AND '"+dtos(mv_par20)+"'"
	_cquery+=" AND (N3_DTBAIXA='        ' OR N3_DTBAIXA>'"+dtos(mv_par11)+"')"
	_cquery+=" AND N3_AQUISIC<='"+dtos(mv_par11)+"'"
	
endif

if mv_par25==1 // Imprime Saldo Poder 3º ?
	_cquery+=" UNION ALL"
	_cquery+=" SELECT"
	_cquery+=" '1102130112901' CONTA,"
	_cquery+=" ZZ_PRODUTO COD,"
	_cquery+=" B1_POSIPI POSIPI,"
	_cquery+=" B1_DESC DESCRI,"
	_cquery+=" B1_UM UM,"
	_cquery+=" B1_TIPO TIPOPROD,"
	_cquery+=" '3' TIPO,"
	_cquery+=" ZZ_QTTERC QUANT,"
	_cquery+=" ZZ_VLTERC VALOR"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SZZ")+" SZZ,"
	_cquery+=  retsqlname("SB1")+" SB1"
	
	_cquery+=" WHERE"
	_cquery+="     SZZ.D_E_L_E_T_<>'*'"
	_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND B1_COD=ZZ_PRODUTO"
	_cquery+=" AND ZZ_DATA = '"+dtos(mv_par11)+"'" 	
	_cquery+=" AND (ZZ_QTTERC>0 OR ZZ_VLTERC>0)" 	
	
endif

if mv_par26==1 // Imprime Saldo Processo ?
	_cquery+=" UNION ALL"
	_cquery+=" SELECT"
	_cquery+=" ZZ_CONTA CONTA,"
	_cquery+=" ZZ_PRODUTO COD,"
	_cquery+=" B1_POSIPI POSIPI,"
	_cquery+=" B1_DESC DESCRI,"
	_cquery+=" B1_UM UM,"
	_cquery+=" B1_TIPO TIPOPROD,"
	_cquery+=" '2' TIPO,"
	_cquery+=" ZZ_QTPROC QUANT,"
	_cquery+=" ZZ_VLPROC VALOR"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SZZ")+" SZZ,"
	_cquery+=  retsqlname("SB1")+" SB1"
	
	_cquery+=" WHERE"
	_cquery+="     SZZ.D_E_L_E_T_<>'*'"
	_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND B1_COD=ZZ_PRODUTO"
	_cquery+=" AND ZZ_DATA = '"+dtos(mv_par11)+"'"
	_cquery+=" AND (ZZ_QTPROC>0 OR ZZ_VLPROC>0)"
endif

_cquery+=" ORDER BY"
_cquery+=" 7,1,3,4"

/*
if mv_par25==1 // Imprime Saldo Poder 3º ?
	
	nOpcao := Aviso("Query",_cquery, {"Ok"})      
	Memowrite("c:\query.XML", _cquery)
endif
*/
_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT","N",12,2)
tcsetfield("TMP1","VALOR","N",12,2)

return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do armazem         ?","mv_ch1","C",02,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o armazem      ?","mv_ch2","C",02,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Da conta contabil  ?","mv_ch9","C",20,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"10","Ate conta contabil ?","mv_cha","C",20,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"11","Data do fechamento ?","mv_chb","D",08,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Prod.c/saldo negat.?","mv_chc","N",01,0,0,"C",space(60),"mv_par12"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Prod.c/saldo zerado?","mv_chd","N",01,0,0,"C",space(60),"mv_par13"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Prod.c/custo zerado?","mv_che","N",01,0,0,"C",space(60),"mv_par14"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"15","Pagina inicial     ?","mv_chf","N",03,0,0,"G",space(60),"mv_par15"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"16","Imprime ativo fixo ?","mv_chg","N",01,0,0,"C",space(60),"mv_par16"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"17","Da conta do ativo  ?","mv_chh","C",20,0,0,"G",space(60),"mv_par17"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"18","Ate conta do ativo ?","mv_chi","C",20,0,0,"G",space(60),"mv_par18"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"19","Da Data Aquisição  ?","mv_chj","D",08,0,0,"G",space(60),"mv_par19"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"20","Ate Data Aquisição ?","mv_chl","D",08,0,0,"G",space(60),"mv_par20"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"21","Tipo impressora    ?","mv_chm","N",01,0,0,"C",space(60),"mv_par21"       ,"Laser/Desk Jet" ,space(30),space(15),"Matricial"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"22","Saldo a considerar ?","mv_chn","N",01,0,0,"C",space(60),"mv_par22"       ,"Fechamento SB9" ,space(30),space(15),"Fim do mes SB2" ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"23","Considerar import. ?","mv_cho","N",01,0,0,"C",space(60),"mv_par23"       ,"Somente import.",space(30),space(15),"Sem importacao" ,space(30),space(15),"Total"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"24","Codigo a Imprimir  ?","mv_chp","N",01,0,0,"C",space(60),"mv_par24"       ,"Codigo"         ,space(30),space(15),"Pos IPI/NCM"    ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"25","Imprime estoque 3º ?","mv_chq","N",01,0,0,"C",space(60),"mv_par25"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"26","Imprime Sld.Proces.?","mv_chr","N",01,0,0,"C",space(60),"mv_par26"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return

/*
------------------------------------------------------------------------------------------------------------------------------------
|                                                     REGISTRO DE INVENTARIO                                                       |
|                                                                                                                                  |
| FIRMA:VITAPAN INDUSTRIA FARMACEUTICA LTDA.                                                                                       |
|                                                                                                                                  |
| INSC.EST.: 101978014          C.N.P.J.  : 30.222.814/0001-31                                                                     |
|                                                                                                                                  |
| FOLHA: 000.001                ESTOQUES EXISTENTES EM: 31/03/05                                                                   |
|                                                                                                                                  |
|----------------------------------------------------------------------------------------------------------------------------------|
|             |                                      |    |    |              |                       VALORES                      |
|CLASSIFICACAO|                                      |    |    |              |---------------------------------+------------------|
|    FISCAL   |     D I S C R I M I N A C A O        |TIPO|UNID|  QUANTIDADE  |   UNITARIO     |   PARCIAL      |     TOTAL        |
|-------------+--------------------------------------+----+----+--------------+----------------+----------------+------------------|
|             | *********** EM ESTOQUE ************  |    |    |              |                |                |                  |
|             |                                      |    |    |              |                |                |                  |
|             | ********* BENEFICIAMENTO **********  |    |    |              |                |                |                  |
|             |                                      |    |    |              |                |                |                  |
| 9999999999  | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XX | XX |999.999.999,99|999.999.999,9999|9.999.999.999,99|999.999.999.999,99|
------------------------------------------------------------------------------------------------------------------------------------
*/
