/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT303   ³Autor ³ Reuber Abdias M. Jr.  ³Data ³ 12/02/08   ³±±
±±³          ³          ³      ³ Alex Junio de Miranda                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Gerenciamento de Previsao de Vendas por       ³±±
±±³          ³ Stored Procedure (Banco Oracle) - Tabela SZR               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit303()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="GERENCIAMENTO DE PREVISAO DE VENDAS"
cdesc1  :="Este programa ira emitir o relatorio para Gerenciamento"
cdesc2  :="do PCP baseado na Previsao de Vendas"
cdesc3  :=""
cstring :="SB1"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT303"
wnrel   :="VIT303"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT303"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
_cfilszr:=xfilial("SZR")
_cfilsbm:=xfilial("SBM")
szr->(dbsetorder(1))
sbm->(dbsetorder(1))

processa({|| _querys()})

titulo+=" -  PERIODO DE REFERENCIA: "+mv_par05+"/"+mv_par06
cabec1:="CODIGO DESCRICAO                                MES/ANO  ESTOQUE    PREVISAO  %EST.DISP  PREV.VENDAS  PREV.VENDAS  PREV.VENDAS     OP´s       OP´s   COBERTURA  %ESTOQ.   PEDIDOS   NECESSIDADE      LOTE "
cabec2:="                                                        DISPONIVEL   VENDAS     VENDAS    PLAN. (R$)  COMERC.(UN)  COMERC.(R$)    GERADAS   PROCESSO    DIAS   DESEJADO  PENDENTES                  PADRAO"

//CODIGO DESCRICAO                                MES/ANO  ESTOQUE    PREVISAO  %EST.DISP  PREV.VENDAS  PREV.VENDAS  PREV.VENDAS     OP´s       OP´s   COBERTURA  %ESTOQ.   PEDIDOS   NECESSIDADE      LOTE "
//                                                        DISPONIVEL   VENDAS     VENDAS    PLAN. (R$)  COMERC.(UN)  COMERC.(R$)    GERADAS   PROCESSO    DIAS   DESEJADO  PENDENTES                  PADRAO"
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/9999 9.999.999  9.999.999  9.999.999 9.999.999,99   99.999.999 9.999.999,99  9.999.999  9.999.999   99.99  9.999.999  9.999.999    9.999.999  9.999.999

setprc(0,0)
@ 000,000 PSAY avalimp(221)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())

if empty(tmp1->cod)
	msgstop("NAO EXISTE PREVISAO DE VENDAS CADASTRADAS!!!")
	eject
	lcontinua:=.f.
endif   

if prow()==0 .or. prow()>60
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
endif

while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	
	sbm->(dbseek(_cfilsbm+tmp1->grupo))
	
	_grupo:=tmp1->grupo
	
	@ prow()+1,000 PSAY "LINHA: "+sbm->bm_grupo+" - "+sbm->bm_desc
	@ prow()+1,000 PSAY replicate("-",limite)
	
	while ! tmp1->(eof()) .and.;
		tmp1->grupo==_grupo
		
		_cod:=tmp1->cod
		_pregprod:=.t.
				
		while ! tmp1->(eof()) .and.;
			tmp1->cod==_cod
			
			if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
			endif
			if _pregprod
				@ prow()+1,000 PSAY substr(tmp1->cod,1,6)
				@ prow(),007   PSAY substr(tmp1->descpro,1,40)
				_pregprod:=.f.
			else
				@ prow()+1,000 PSAY " "
			endif
		
			@ prow(),048   PSAY tmp1->mesano
			@ prow(),056   PSAY tmp1->estdisp picture "@E 9,999,999"
			@ prow(),067   PSAY tmp1->pvp     picture "@E 9,999,999"
			@ prow(),078   PSAY tmp1->percdv  picture "@E 9,999,999"
			@ prow(),088   PSAY tmp1->pvpvlr  picture "@E 9,999,999.99"
			@ prow(),103   PSAY tmp1->pvc     picture "@E 9,999,999"
			@ prow(),114   PSAY tmp1->pvcvlr  picture "@E 9,999,999.99"
			@ prow(),128   PSAY tmp1->opger   picture "@ZE 9,999,999"
			@ prow(),139   PSAY tmp1->opproce picture "@ZE 9,999,999"
			@ prow(),150   PSAY tmp1->cobdias picture "@E 999.99"
			@ prow(),158   PSAY tmp1->estdese picture "@E 9,999,999"
			@ prow(),169   PSAY tmp1->pedpend picture "@ZE 9,999,999"
			@ prow(),182   PSAY tmp1->necess  picture "@E 9,999,999"
			@ prow(),193   PSAY tmp1->lotepad picture "@ZE 9,999,999"
			
			tmp1->(dbskip())
			
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end   

		@ prow()+1,000 PSAY replicate("-",limite)
	end
	
	
	/******TOTAIS POR GRUPO*****/
	processa({|| _qrys(_grupo)})
	
	sbm->(dbseek(_cfilsbm+_grupo))
	tmp2->(dbgotop())

	_preggrupo:=.t.
	
	while ! tmp2->(eof())	
		
		if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
		endif
		
		if _preggrupo
			@ prow()+1,000 PSAY "TOTAIS DA LINHA DE "+rtrim(sbm->bm_desc)+" ("+sbm->bm_grupo+")"
			_preggrupo:=.f.
		else
			@ prow()+1,000 PSAY " "
		endif
		
		@ prow(),048   PSAY tmp2->mesano
		@ prow(),056   PSAY tmp2->estdisp picture "@E 9,999,999"
		@ prow(),067   PSAY tmp2->pvp     picture "@E 9,999,999"
		@ prow(),078   PSAY tmp2->percdv  picture "@E 9,999,999"
		@ prow(),088   PSAY tmp2->pvpvlr  picture "@E 9,999,999.99"
		@ prow(),103   PSAY tmp2->pvc     picture "@E 9,999,999"
		@ prow(),114   PSAY tmp2->pvcvlr  picture "@E 9,999,999.99"
		@ prow(),128   PSAY tmp2->opger   picture "@ZE 9,999,999"
		@ prow(),139   PSAY tmp2->opproce picture "@ZE 9,999,999"

		_diaval:=day(lastday(ctod('01/'+tmp2->mesano)))        
		@ prow(),150   PSAY ((tmp2->estdisp+tmp2->opger+tmp2->opproce)/tmp2->pvc)*_diaval picture "@E 999.99"	
		@ prow(),158   PSAY tmp2->estdese picture "@E 9,999,999"
		@ prow(),169   PSAY tmp2->pedpend picture "@ZE 9,999,999"
		@ prow(),182   PSAY tmp2->necess  picture "@E 9,999,999"
		
		tmp2->(dbskip())
		
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	@ prow()+2,000 PSAY replicate("*",limite)
	
	tmp2->(dbclosearea())
end


/******TOTAIS GERAIS*****/
processa({|| _qrys2()})

tmp3->(dbgotop())
_pregtot:=.t.

while ! tmp3->(eof())
	
	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
	
	if _pregtot
		@ prow()+1,000 PSAY replicate("*",limite)
		@ prow()+1,000 PSAY "TOTAIS GERAIS "
		_pregtot:=.f.
	else
		@ prow()+1,000 PSAY " "
	endif
	
	@ prow(),048   PSAY tmp3->mesano
	@ prow(),056   PSAY tmp3->estdisp picture "@E 9,999,999"
	@ prow(),067   PSAY tmp3->pvp     picture "@E 9,999,999"
	@ prow(),078   PSAY tmp3->percdv  picture "@E 9,999,999"
	@ prow(),088   PSAY tmp3->pvpvlr  picture "@E 9,999,999.99"
	@ prow(),103   PSAY tmp3->pvc     picture "@E 9,999,999"
	@ prow(),114   PSAY tmp3->pvcvlr  picture "@E 9,999,999.99"
	@ prow(),128   PSAY tmp3->opger   picture "@ZE 9,999,999"
	@ prow(),139   PSAY tmp3->opproce picture "@ZE 9,999,999"

	_diaval:=day(lastday(ctod('01/'+tmp3->mesano)))        
	@ prow(),150   PSAY ((tmp3->estdisp+tmp3->opger+tmp3->opproce)/tmp3->pvc)*_diaval picture "@E 999.99"	
	@ prow(),158   PSAY tmp3->estdese picture "@E 9,999,999"
	@ prow(),169   PSAY tmp3->pedpend picture "@ZE 9,999,999"
	@ prow(),182   PSAY tmp3->necess  picture "@E 9,999,999"
	
	tmp3->(dbskip())
	
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

tmp3->(dbclosearea())

if prow()>0 .and. lcontinua
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return


static function _querys()                                                                             

_dataini:=mv_par06+mv_par05+"01"


#IFDEF TOP
	cProcedure:="SZRGERV"
	If ExistProc( cProcedure )
		TCSPEXEC( xProcedures(cProcedure),_cfilszr,mv_par01,mv_par02,mv_par03,mv_par04,_dataini,mv_par07)
	endif
#ENDIF


_cquery:=" SELECT"
_cquery+="   ZR_GRUPO GRUPO,"
_cquery+="   ZR_COD COD,"
_cquery+="   ZR_DESCPRO DESCPRO,"
_cquery+="   ZR_MESANO MESANO,"
_cquery+="   ZR_ESTDISP ESTDISP,"
_cquery+="   ZR_PVP PVP,"
_cquery+="   ZR_PERCDV PERCDV,"
_cquery+="   ZR_PVPVLR PVPVLR,"
_cquery+="   ZR_PVC PVC,"
_cquery+="   ZR_PVCVLR PVCVLR,"
_cquery+="   ZR_OPGER OPGER,"
_cquery+="   ZR_OPPROCE OPPROCE,"
_cquery+="   ZR_COBDIAS COBDIAS,"
_cquery+="   ZR_ESTDESE ESTDESE,"
_cquery+="   ZR_PEDPEND PEDPEND,"
_cquery+="   ZR_NECESS NECESS,"
_cquery+="   ZR_LOTEPAD LOTEPAD"
_cquery+=" FROM"
_cquery+=  retsqlname("SZR")+" SRZ"
_cquery+=" WHERE"
_cquery+="     SRZ.D_E_L_E_T_=' '"
_cquery+=" ORDER BY ZR_GRUPO, ZR_COD, ZR_MESANO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","ESTDISP","N",15,3)
tcsetfield("TMP1","PVP"    ,"N",15,3)
tcsetfield("TMP1","PERCDV" ,"N",07,2)
tcsetfield("TMP1","PVPVLR" ,"N",15,2)
tcsetfield("TMP1","PVC"    ,"N",15,3)
tcsetfield("TMP1","PVCVLR" ,"N",15,2)
tcsetfield("TMP1","OPGER"  ,"N",15,3)
tcsetfield("TMP1","OPPROCE","N",15,3)
tcsetfield("TMP1","COBDIAS","N",05,2)
tcsetfield("TMP1","ESTDESE","N",15,3)
tcsetfield("TMP1","PEDPEND","N",15,3)
tcsetfield("TMP1","NECESS" ,"N",15,3)
tcsetfield("TMP1","LOTEPAD","N",15,3)

return


///////////////////////////////////////////////////
//           TOTALIZADOR POR GRUPO               //
/////////////////////////////////////////////////// 
static function _qrys(_grupo)

_cqry:="SELECT"
_cqry+="  ZR_MESANO MESANO,"
_cqry+="  Sum(ZR_ESTDISP) ESTDISP,"
_cqry+="  Sum(ZR_PVP) PVP,"
_cqry+="  Sum(ZR_PERCDV) PERCDV,"
_cqry+="  Sum(ZR_PVPVLR) PVPVLR,"
_cqry+="  Sum(ZR_PVC) PVC,"
_cqry+="  Sum(ZR_PVCVLR) PVCVLR,"
_cqry+="  Sum(ZR_OPGER) OPGER,"
_cqry+="  Sum(ZR_OPPROCE) OPPROCE,"
_cqry+="  Sum(ZR_ESTDESE) ESTDESE,"
_cqry+="  Sum(ZR_PEDPEND) PEDPEND,"
_cqry+="  Sum(ZR_NECESS) NECESS"
_cqry+=" FROM "
_cqry+= retsqlname("SZR")+" SRZ"
_cqry+=" WHERE"
_cqry+=" SRZ.D_E_L_E_T_=' '
_cqry+=" AND ZR_GRUPO='"+_grupo+"'"
_cqry+=" GROUP BY ZR_MESANO"
_cqry+=" ORDER BY ZR_MESANO"

_cqry:=changequery(_cqry)

tcquery _cqry new alias "TMP2"
tcsetfield("TMP2","ESTDISP","N",15,3)
tcsetfield("TMP2","PVP"    ,"N",15,3)
tcsetfield("TMP2","PERCDV" ,"N",07,2)
tcsetfield("TMP2","PVPVLR" ,"N",15,2)
tcsetfield("TMP2","PVC"    ,"N",15,3)
tcsetfield("TMP2","PVCVLR" ,"N",15,2)
tcsetfield("TMP2","OPGER"  ,"N",15,3)
tcsetfield("TMP2","OPPROCE","N",15,3)
tcsetfield("TMP2","ESTDESE","N",15,3)
tcsetfield("TMP2","PEDPEND","N",15,3)
tcsetfield("TMP2","NECESS" ,"N",15,3)
return



///////////////////////////////////////////////////
//             TOTALIZADOR GERAL                 //
/////////////////////////////////////////////////// 
static function _qrys2()

_cqry2:="SELECT"
_cqry2+="  ZR_MESANO MESANO,"
_cqry2+="  Sum(ZR_ESTDISP) ESTDISP,"
_cqry2+="  Sum(ZR_PVP) PVP,"
_cqry2+="  Sum(ZR_PERCDV) PERCDV,"
_cqry2+="  Sum(ZR_PVPVLR) PVPVLR,"
_cqry2+="  Sum(ZR_PVC) PVC,"
_cqry2+="  Sum(ZR_PVCVLR) PVCVLR,"
_cqry2+="  Sum(ZR_OPGER) OPGER,"
_cqry2+="  Sum(ZR_OPPROCE) OPPROCE,"
_cqry2+="  Sum(ZR_ESTDESE) ESTDESE,"
_cqry2+="  Sum(ZR_PEDPEND) PEDPEND,"
_cqry2+="  Sum(ZR_NECESS) NECESS"
_cqry2+=" FROM "
_cqry2+=retsqlname("SZR")+" SRZ"
_cqry2+=" WHERE"
_cqry2+=" SRZ.D_E_L_E_T_=' '
_cqry2+="   GROUP BY ZR_MESANO"
_cqry2+="   ORDER BY ZR_MESANO"

_cqry2:=changequery(_cqry2)

tcquery _cqry2 new alias "TMP3"
tcsetfield("TMP3","ESTDISP","N",15,3)
tcsetfield("TMP3","PVP"    ,"N",15,3)
tcsetfield("TMP3","PERCDV" ,"N",07,2)
tcsetfield("TMP3","PVPVLR" ,"N",15,2)
tcsetfield("TMP3","PVC"    ,"N",15,3)
tcsetfield("TMP3","PVCVLR" ,"N",15,2)
tcsetfield("TMP3","OPGER"  ,"N",15,3)
tcsetfield("TMP3","OPPROCE","N",15,3)
tcsetfield("TMP3","ESTDESE","N",15,3)
tcsetfield("TMP3","PEDPEND","N",15,3)
tcsetfield("TMP3","NECESS" ,"N",15,3)
return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60)   ,"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60)   ,"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do grupo           ?","mv_ch3","C",04,0,0,"G",space(60)   ,"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"04","Ate o grupo        ?","mv_ch4","C",04,0,0,"G",space(60)   ,"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"05","Mes de referencia  ?","mv_ch5","C",02,0,0,"G",'pertence("01#02#03#04#05#06#07#08#09#10#11#12")',"mv_par05"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ano de referencia  ?","mv_ch6","C",04,0,0,"G",space(60)   ,"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Quantos meses      ?","mv_ch7","N",02,0,0,"G",'naovazio()',"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
