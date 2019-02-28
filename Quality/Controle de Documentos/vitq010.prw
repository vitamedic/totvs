/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITQ010   ³Autor ³ Gardenia               ³Data ³ 24/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Protocolo de Distribuicao de Documentos                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Do documento
mv_par02 Ate o documento
mv_par03 Da revisao 
mv_par04 Ate a revisao 
mv_par05 Do depto
mv_par06 Ate o depto
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VITQ010()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="PROTOCOLO DE DISTRIBUIÇÃO DE  DOCUMENTOS"
cdesc1   :="Este programa ira emitir o protocolo de entrega de documentos"
cdesc2   :=""
cdesc3   :=""
cstring  :="QD1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VITQ010"
wnrel    :="VITQ010"
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVITQ10"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
   set filter to
   return
endif

rptstatus({|| rptdetail()})
return

static function rptdetail()
_cfilqdh:=xfilial("QDH")
_cfilqd1:=xfilial("QD1")
_cfilqdg:=xfilial("QDG")
_cfilqdc:=xfilial("QDC")
_cfilqaa:=xfilial("QAA")
qdg->(dbsetorder(6))
qd1->(dbsetorder(1))
qdh->(dbsetorder(1))
qdc->(dbsetorder(1))
qaa->(dbsetorder(1))






processa({|| _querys()})

cabec1:="USUARIO/PASTA                             COPIAS  TIPO    RECEBIDO POR                   DATA            RECOL.REV.ANT."
//USUARIO/PASTA                             COPIAS  TIPO    RECEBIDO POR                   DATA            RECOL.REV.ANT."
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999    XXXXX   ______________________________ ____/____/____  (  )Sim  (  )Não  (  )N/A
cabec2:=''


setprc(0,0)

setregua(sb8->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	qdh->(dbseek(_cfilqdh+tmp1->docto+tmp1->rv,.t.))	
	if prow()==0 .or. prow()>54
		cabec1:="Documento: "+qdh->qdh_titulo
		cabec2:="Nº Doc...: "+tmp1->docto  + "                          Revisão: "+ tmp1->rv
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		@ prow()+2,00 PSAY  "USUARIO/PASTA                                       COP. TIPO   RECEBIDO POR                      DATA            RECOL.REV.ANT."	
		_cdocto:=tmp1->docto
	endif                            
	incregua()
	qdg->(dbseek(_cfilqdg+tmp1->docto+tmp1->rv,.t.))	
	_aestrut :={}
	aadd(_aestrut,{"MAT","C",06,0})
	aadd(_aestrut,{"NOME","C",50,0})
	aadd(_aestrut,{"NCOP"     ,"N",3,0})
	aadd(_aestrut,{"TPRCBT" ,"C",1,0})
	aadd(_aestrut,{"CODMAN" ,"C",40,0})
	_carqtmp2:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
	_cindtmp11:=criatrab(,.f.)

	_cchave  := "tprcbt+nome"
	tmp2->(indregua("TMP2",_cindtmp11,_cchave))
	tmp2->(dbclearind())
	tmp2->(dbsetindex(_cindtmp11))
	tmp2->(dbsetorder(1))
	while ! qdg->(eof()) .and. qdg->qdg_docto==tmp1->docto .and. tmp1->rv == qdg->qdg_rv .and. lcontinua
	   if qdg->qdg_receb <> "S" .or.;
	    	qdg->qdg_sit == "I" .or.;
	    	qdg->qdg_tprcbt = ' ' .or.;
	    	qdg->qdg_tprcbt=="4"
			qdg->(dbskip())  
			loop
	   endif              
	   if mv_par07 == 1
	      if qdg->qdg_tprcbt = '2' 
				qdg->(dbskip())  
				loop
	      endif
	   elseif mv_par07 == 2
	      if qdg->qdg_tprcbt = '1' 
				qdg->(dbskip())  
				loop
	      endif                  
	   endif   
	   _nome:=""
		if qdg->qdg_tprcbt == "1" .or. qdg->qdg_tprcbt == "3"
			qaa->(dbseek(_cfilqaa+qdg->qdg_mat,.t.))	
 			_nome:=qaa->qaa_nome
		elseif qdg->qdg_tprcbt == "2" 	  
			qdc->(dbseek(_cfilqdc+qdg->qdg_codman,.t.))	
			_nome:=qdc->qdc_desc
		endif	
  		tmp2->(dbappend())
		tmp2->nome  :=_nome
		tmp2->ncop  :=qdg->qdg_ncop
		tmp2->tprcbt:=qdg->qdg_tprcbt
		qdg->(dbskip())  
	end			
	tmp2->(dbgotop())
	while ! tmp2->(eof())
		if prow()==0 .or. prow()>54
			cabec1:="Documento: "+qdh->qdh_titulo
			cabec2:="Nº Doc...: "+tmp1->docto  + "                          Revisão: "+ tmp1->rv
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
			@ prow()+2,00 PSAY  "USUARIO/PASTA                                       COP. TIPO   RECEBIDO POR                      DATA            RECOL.REV.ANT."	
			_cdocto:=tmp1->docto
		endif                            
		@ prow()+2, 000 PSAY tmp2->nome
		@ prow(),052 PSAY strzero(tmp2->ncop,3)
		if tmp2->tprcbt = "1" 
			@ prow(),057  PSAY "Elet."
		elseif tmp2->tprcbt = "2" 	   
			@ prow(),057  PSAY "Papel"
		elseif tmp2->tprcbt = "3" 	   	
			@ prow(),057  PSAY "El/Pap"
		endif	
		@ prow (),064 PSAY "______________________________ ____/____/____ ( )Sim ( )Não ( )N/A" 
 		tmp2->(dbskip())  
 	end
	tmp2->(dbclosearea())
	tmp1->(dbskip())	
end

if prow()>0 .and.;
	lcontinua
   roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf

ms_flush()
return

static function _querys()
_cquery:=" SELECT"
_cquery+=" QDH_DOCTO DOCTO,QDH_RV RV"
_cquery+=" FROM "
_cquery+=  retsqlname("QDH")+" QDH,"
_cquery+=" WHERE"
_cquery+="     QDH.D_E_L_E_T_<>'*'"
_cquery+=" AND QDH_FILIAL='"+_cfilqd1+"'"
_cquery+=" AND QDH_DOCTO  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND QDH_RV BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
//_cquery+=" AND QDH_DEPTOE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY QDH_DOCTO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
//tcsetfield("TMP1","DTVALID","D")
//tcsetfield("TMP1","SALDO"  ,"N",15,3)
//tcsetfield("TMP1","EMPENHO","N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do documento       ?","mv_ch1","C",16,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QD1"})
aadd(_agrpsx1,{cperg,"02","Ate o documento    ?","mv_ch2","C",16,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QD1"})
aadd(_agrpsx1,{cperg,"03","Da revisao         ?","mv_ch3","C",03,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a revisao      ?","mv_ch4","C",03,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do depto           ?","mv_ch5","C",09,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"06","Ate o depto        ?","mv_ch6","C",09,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"07","Tipo copia         ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Eletronica"     ,space(30),space(15),"Papel"          ,space(30),space(15),"Ambas"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/