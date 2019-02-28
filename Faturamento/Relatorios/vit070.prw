/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT070   ³ Autor ³ ALINE B. PEREIRA³ Data ³ 14/03/05       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento das Metas de Venda                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit070()
if mv_par11=="2"
if sm0->m0_codigo<>"02" .or.;
	(upper(alltrim(getenvserver()))<>"BACKUP" .and. upper(alltrim(getenvserver()))<>"BKP")
	msgstop("Programa não habilitado para esta filial!")		
	return
endif
if tclink("oracle/dadosadv","192.168.1.20")<>0
	msgstop("Falha de conexao com o banco!")
	tcquit()
	return
endif
endif
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="ACOMPANHAMENTO DAS METAS DE VENDA"
cdesc1   :="Este programa ira emitir o relatorio de acompanhamento das metas de venda"
cdesc2   :=""
cdesc3   :=""
cstring  :="SCT"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT070"
wnrel    :="VIT070"+Alltrim(cusername)
alinha   :={}
//aordem  :={"Gerente/Representante","Produto"}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT070"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   if mv_par11=="2"
		tcquit()
	endif	
   return
endif

setdefault(areturn,cstring)


ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

//ntipo:=18

if nlastkey==27
   set filter to
   if mv_par11=="2"   
		tcquit()
	endif	
   return
endif
rptstatus({|| rptdetail()})
if mv_par11=="2"
	tcquit()
endif	
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
titulo:="ACOMPANHAMENTO DAS METAS DE VENDA - DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)

cabec1:="                                                    P E D I D O                              F A T U R A M E N T O"
cabec2:="CODIGO DESCRICAO                M E T A   QUANTIDADE         VALOR  DIFERENCA  %META     QUANTIDADE       VALOR  DIFERENCA   %META"

_cfilsa3:=xfilial("SA3")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsct:=xfilial("SCT")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")
_cfilsf4:=xfilial("SF4")

sa3->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sct->(dbsetorder(1))
sd2->(dbsetorder(5))
sf2->(dbsetorder(1))
sf4->(dbsetorder(1))

if mv_par12=="2"
  _abretop("SD2010",5)
  _abretop("SC5010",1)
  _abretop("SC6010",1)
  _abretop("SCT010",1)
  _abretop("SF2010",1)
  _abretop("SF4010",1)
  _abretop("SA3010",1)
endif

_atot    :={}

_carqtmp2:=""
_cindtmp2:=""
_carqtmp3:=""
_cindtmp3:=""

processa({|| _geratmp()})

setprc(0,0)


_acom  :={}
setregua(tmp1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua             
      if !empty(tmp1->produto) .and. tmp1->vendedor <> "002000"
			aadd(_acom,{tmp1->produto,tmp1->supervisor,tmp1->vendedor,tmp1->quant})		
		endif	
		tmp1->(dbskip())           
end      
 _acomr:= asort(_acom,,,{|x,y| x[1]+x[2]+x[3]<y[1]+y[2]+y[3]})
_nprod := ""
_nger := ""  

store 0 to _ntqt1,_ntqt2,_ntval2,_ntqt3,_ntval3
store 0 to _nqt1,_nqt2,_nval2,_nqt3,_nval3
store 0 to _ngqt1,_ngqt2,_ngval2,_ngqt3,_ngval3
for _i:=1 to len(_acomr)
	incregua()
	if prow()==0 .or. prow()>58
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif  
  	if _acomr[_i,1] <> _nprod
  	   _nprod:= _acomr[_i,1]
   	if prow()>58
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif         	  	 
   	if !empty(_ngqt1)
	  		@ prow()+1,000 PSAY "TOTAL GERENTE"
			@ prow(),031   PSAY _ngqt1 picture "@E 99999,999"
		   @ prow(),041   PSAY _ngqt2 picture "@E 99999,999"		
		   @ prow(),051   PSAY _ngval2 picture "@E 999,999,999.99"
		   @ prow(),066   PSAY _ngqt2-_ngqt1 picture "@E 99999,999"		
		   @ prow(),084   PSAY _ngqt3 picture "@E 99999,999"		
		   @ prow(),095   PSAY _ngval3 picture "@E 999,999,999.99"
		   @ prow(),110   PSAY _ngqt3-_ngqt1 picture "@E 99999,999"				   
		 	store 0 to _ngqt1,_ngqt2,_ngval2,_ngqt3,_ngval3
		endif
		if prow()>58
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
  	   if !empty(_nqt1)
	   	@ prow()+1,000 PSAY "TOTAL PRODUTO"
			@ prow(),031   PSAY _nqt1 picture "@E 99999,999"
		   @ prow(),041   PSAY _nqt2 picture "@E 99999,999"		
		   @ prow(),051   PSAY _nval2 picture "@E 999,999,999.99"
		   @ prow(),066   PSAY _nqt2-_nqt1 picture "@E 99999,999"		
		   @ prow(),084   PSAY _nqt3 picture "@E 99999,999"		
		   @ prow(),095   PSAY _nval3 picture "@E 999,999,999.99"
		   @ prow(),110   PSAY _nqt3-_nqt1 picture "@E 99999,999"		
		 	store 0 to _nqt1,_nqt2,_nval2,_nqt3,_nval3
		endif
		if prow()>58
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		sb1->(dbseek(_cfilsb1+_acomr[_i,1]))
		@ prow()+2,000 PSAY substr(_acomr[_i,1],1,6)+" - "+left(sb1->b1_desc,40)
   endif  
  	if _acomr[_i,2] <> _nger
  	   _nger:= _acomr[_i,2]
		if prow()>58
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif  	   
  	   if !empty(_ngqt1)
	  		@ prow()+1,000 PSAY "TOTAL GERENTE" 	   
			@ prow(),031   PSAY _ngqt1 picture "@E 99999,999"
		   @ prow(),041   PSAY _ngqt2 picture "@E 99999,999"		
		   @ prow(),051   PSAY _ngval2 picture "@E 999,999,999.99"
		   @ prow(),066   PSAY _ngqt2-_ngqt1 picture "@E 99999,999"		
		   @ prow(),084   PSAY _ngqt3 picture "@E 99999,999"		
		   @ prow(),095   PSAY _ngval3 picture "@E 999,999,999.99"
		   @ prow(),110   PSAY _ngqt3-_ngqt1 picture "@E 99999,999"		

		 	store 0 to _ngqt1,_ngqt2,_ngval2,_ngqt3,_ngval3
	   endif
	   sa3->(dbseek(_cfilsa3+_acomr[_i,2]))	
		@ prow()+2,000 PSAY _acomr[_i,2]+" - "+sa3->a3_nome			
   endif  	
   sa3->(dbseek(_cfilsa3+_acomr[_i,3]))	
	@ prow()+1,000 PSAY _acomr[_i,3]+" - "+substr(sa3->a3_nome,1,20) // vendedor
	@ prow(),031   PSAY _acomr[_i,4]picture "@E 99999,999" //meta
	_nqt1 += _acomr[_i,4]
	_ngqt1 += _acomr[_i,4]
	_ntqt1 += _acomr[_i,4]
	if tmp2->(dbseek(_acomr[_i,2]+_acomr[_i,3]+_acomr[_i,1]))
		@ prow(),041 PSAY tmp2->quant picture "@E 9999,999"
		@ prow(),051 PSAY tmp2->valor picture "@E 999,999,999.99"
		@ prow(),066 PSAY (tmp2->quant-_acomr[_i,4]) picture "@E 99999,999"
		@ prow(),074 PSAY (tmp2->quant/_acomr[_i,4])*100 picture "@E 9999.99"		
		_nqt2 += tmp2->quant
		_nval2 += tmp2->valor
		_ngqt2 += tmp2->quant
		_ngval2 += tmp2->valor
		_ntqt2 += tmp2->quant
		_ntval2 += tmp2->valor
	endif
	if tmp3->(dbseek(_acomr[_i,2]+_acomr[_i,3]+_acomr[_i,1]))
		@ prow(),084 PSAY tmp3->quant picture "@E 99999,999"
		@ prow(),095 PSAY tmp3->valor picture "@E 999,999,999.99"
		@ prow(),110 PSAY (tmp3->quant-_acomr[_i,4]) picture "@E 999999.99"
		@ prow(),123 PSAY (tmp3->quant/_acomr[_i,4])*100 picture "@E 9999.99"
		_nqt3 += tmp3->quant
		_nval3 += tmp3->valor		
		_ngqt3 += tmp3->quant
		_ngval3 += tmp3->valor		
		_ntqt3 += tmp3->quant
		_ntval3 += tmp3->valor		
	endif              
next       
if prow()>58
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif
if !empty(_ngqt1)
	@ prow()+1,000 PSAY "TOTAL GERENTE" 	   
	@ prow(),031   PSAY _ngqt1 picture "@E 99999,999"
   @ prow(),041   PSAY _ngqt2 picture "@E 99999,999"		
   @ prow(),051   PSAY _ngval2 picture "@E 999,999,999.99"
   @ prow(),066   PSAY _ngqt2-_ngqt1 picture "@E 99999,999"		
   @ prow(),084   PSAY _ngqt3 picture "@E 99999,999"		
   @ prow(),095   PSAY _ngval3 picture "@E 999,999,999.99"
   @ prow(),110   PSAY _ngqt3-_ngqt1 picture "@E 99999,999"		
 	store 0 to _ngqt1,_ngqt2,_ngval2,_ngqt3,_ngval3
endif
if prow()>58
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif
if !empty(_nqt1)
	@ prow()+1,000 PSAY "TOTAL PRODUTO" 	   
	@ prow(),031   PSAY _nqt1 picture "@E 99999,999"
   @ prow(),041   PSAY _nqt2 picture "@E 99999,999"		
   @ prow(),051   PSAY _nval2 picture "@E 999,999,999.99"
   @ prow(),066   PSAY _nqt2-_nqt1 picture "@E 99999,999"		
   @ prow(),084   PSAY _nqt3 picture "@E 99999,999"		
   @ prow(),095   PSAY _nval3 picture "@E 999,999,999.99"
   @ prow(),110   PSAY _nqt3-_nqt1 picture "@E 99999,999"		
 	store 0 to _nqt1,_nqt2,_nval2,_nqt3,_nval3
endif
if prow()>58
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif
if !empty(_nqt1)
	@ prow()+1,000 PSAY "TOTAL GERAL" 	   
	@ prow(),031   PSAY _ntqt1 picture "@E 99999,999"
   @ prow(),041   PSAY _ntqt2 picture "@E 99999,999"		
   @ prow(),051   PSAY _ntval2 picture "@E 999,999,999.99"
   @ prow(),066   PSAY _ntqt2-_ntqt1 picture "@E 99999,999"		
   @ prow(),084   PSAY _ntqt3 picture "@E 99999,999"		
   @ prow(),095   PSAY _ntval3 picture "@E 999,999,999.99"
   @ prow(),110   PSAY _ntqt3-_ntqt1 picture "@E 99999,999"		
 	store 0 to _ntqt1,_ntqt2,_ntval2,_ntqt3,_ntval3
endif
roda(cbcont,cbtxt)
set device to screen

tmp1->(dbclosearea())
_cindtmp2+=tmp2->(ordbagext())
tmp2->(dbclosearea())
ferase(_carqtmp2+getdbextension())
ferase(_cindtmp2)
_cindtmp3+=tmp3->(ordbagext())
tmp3->(dbclosearea())
ferase(_carqtmp3+getdbextension())
ferase(_cindtmp3)

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endif

ms_flush()
return


static function _geratmp()
procregua(3)
	incproc("Calculando metas...")
	_cquery:=" SELECT"
	_cquery+=" A3_SUPER SUPERVISOR,CT_VEND VENDEDOR,CT_PRODUTO PRODUTO,"
	_cquery+=" SUM(CT_QUANT) QUANT,SUM(CT_VALOR) VALOR"
	_cquery+=" FROM "
	_cquery+=" SA3010 SA3,"
	_cquery+=" SCT010 SCT"
	_cquery+=" WHERE"
	_cquery+="     SA3.D_E_L_E_T_<>'*'"
	_cquery+=" AND SCT.D_E_L_E_T_<>'*'"
	_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
	_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"
	_cquery+=" AND CT_VEND=A3_COD"
	_cquery+=" AND CT_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	_cquery+=" AND A3_SUPER BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND CT_VEND BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND CT_PRODUTO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND CT_DOC BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	_cquery+=" GROUP BY"
	_cquery+=" A3_SUPER,CT_VEND,CT_PRODUTO"
	_cquery+=" ORDER BY"
	_cquery+=" A3_SUPER,CT_VEND,CT_PRODUTO"
	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","QUANT","N",08,0)
	tcsetfield("TMP1","VALOR","N",12,2)


incproc("Calculando pedidos...")
_cquery:=" SELECT"
_cquery+=" A3_SUPER SUPERVISOR,C5_VEND1 VENDEDOR,C6_PRODUTO PRODUTO,"
_cquery+=" SUM(C6_QTDVEN) QUANT,SUM(C6_VALOR) VALOR"
_cquery+=" FROM "
_cquery+=" SA3010 SA3,"
_cquery+=" SC5010 SC5,"
_cquery+=" SC6010 SC6,"
_cquery+=" SF4010 SF4"
_cquery+=" WHERE"
_cquery+="     SA3.D_E_L_E_T_<>'*'"
_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND C6_NUM=C5_NUM"
_cquery+=" AND C5_VEND1=A3_COD"
_cquery+=" AND C6_TES=F4_CODIGO"
_cquery+=" AND F4_DUPLIC='S'"
_cquery+=" AND C6_ENTREG BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND A3_SUPER BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND C5_VEND1 BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND C6_PRODUTO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" GROUP BY"
_cquery+=" A3_SUPER,C5_VEND1,C6_PRODUTO"
_cquery+=" ORDER BY"
_cquery+=" A3_SUPER,C5_VEND1,C6_PRODUTO"

//_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"

tcquery _cquery new alias "TMP2"
tcsetfield("TMP2","QUANT","N",08,0)
tcsetfield("TMP2","VALOR","N",12,2)

_carqtmp2:=criatrab(,.f.)
copy to &_carqtmp2
tmp2->(dbclosearea())

dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
_cindtmp2:=criatrab(,.f.)
_cchave  :="SUPERVISOR+VENDEDOR+PRODUTO"
tmp2->(indregua("TMP2",_cindtmp2,_cchave,,,"Selecionando registros..."))

incproc("Calculando faturamento...")
_cquery:=" SELECT"
_cquery+=" A3_SUPER SUPERVISOR,F2_VEND1 VENDEDOR,D2_COD PRODUTO,"
_cquery+=" SUM(D2_QUANT) QUANT,SUM(D2_TOTAL) VALOR"
_cquery+=" FROM "
_cquery+=" SA3010 SA3,"
_cquery+=" SD2010 SD2,"
_cquery+=" SF2010 SF2,"
_cquery+=" SF4010 SF4"
_cquery+=" WHERE"
_cquery+="     SA3.D_E_L_E_T_<>'*'"
_cquery+=" AND SD2.D_E_L_E_T_<>'*'"
_cquery+=" AND SF2.D_E_L_E_T_<>'*'"
_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND D2_DOC=F2_DOC"
_cquery+=" AND D2_SERIE=F2_SERIE"
_cquery+=" AND F2_VEND1=A3_COD"
_cquery+=" AND D2_TES=F4_CODIGO"
_cquery+=" AND F4_DUPLIC='S'"
_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND A3_SUPER BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND F2_VEND1 BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND D2_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" GROUP BY"
_cquery+=" A3_SUPER,F2_VEND1,D2_COD"
_cquery+=" ORDER BY"
_cquery+=" A3_SUPER,F2_VEND1,D2_COD"

tcquery _cquery new alias "TMP3"
tcsetfield("TMP3","QUANT","N",08,0)
tcsetfield("TMP3","VALOR","N",12,2)

_carqtmp3:=criatrab(,.f.)
copy to &_carqtmp3
tmp3->(dbclosearea())

dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)
_cindtmp3:=criatrab(,.f.)
_cchave  :="SUPERVISOR+VENDEDOR+PRODUTO"
tmp3->(indregua("TMP3",_cindtmp3,_cchave,,,"Selecionando registros..."))


incproc("Calculando faturamento teste...")
sd2->(dbseek(_cfilsd2+dtos(mv_par01),.t.))
while ! sd2->(eof()) .and.;
		sd2->d2_filial==_cfilsd2 .and.;
		sd2->d2_emissao<=mv_par02
	if sd2->d2_cod>=mv_par07 .and.;
		sd2->d2_cod<=mv_par08
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		if sf4->f4_duplic=="S"
			sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
			if sf2->f2_vend1>=mv_par05 .and.;
				sf2->f2_vend1<=mv_par06
				sa3->(dbseek(_cfilsa3+sf2->f2_vend1))
				if sa3->a3_super>=mv_par03 .and.;
					sa3->a3_super<=mv_par04
					if tmp3->(dbseek(sa3->a3_super+sf2->f2_vend1+sd2->d2_cod))
						tmp3->quant+=sd2->d2_quant
						tmp3->valor+=sd2->d2_total
					else
						tmp3->(dbappend())
						tmp3->supervisor:=sa3->a3_super
						tmp3->vendedor  :=sf2->f2_vend1
						tmp3->produto   :=sd2->d2_cod
						tmp3->quant     :=sd2->d2_quant
						tmp3->valor     :=sd2->d2_total
					endif
				endif
			endif
		endif
	endif
	sd2->(dbskip())
end
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do supervisor      ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o supervisor   ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Do vendedor        ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"06","Ate o vendedor     ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"07","Do produto         ?","mv_ch7","C",15,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"08","Ate o produto      ?","mv_ch8","C",15,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"09","Do documento       ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o documento    ?","mv_chA","C",06,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Grade              ?","mv_chB","C",01,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

static function _abretop(_carq,_nordem)
_calias:=left(_carq,3)
dbusearea(.t.,"TOPCONN",_carq,_carq,.t.,.f.)
six->(dbseek(_calias))
while ! six->(eof()) .and.;
		six->indice==_calias
	dbsetindex(_carq+six->ordem)
	six->(dbskip())
end
dbsetorder(_nordem)
return     

/*
SUPERVISOR: 999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VENDEDOR: 999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                        M E T A              P E D I D O               F A T U R A M E N T O
CODIGO DESCRICAO                                 QUANT.          VALOR  QUANT.          VALOR  % META  QUANT.          VALOR  % META
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999 999.999.999,99 999.999 999.999.999,99 9999,99 999.999 999.999.999,99 9999,99
*/
