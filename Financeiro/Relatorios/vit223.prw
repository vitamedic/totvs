/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT223   ³ Autor ³ Gardenia Ilany        ³ Data ³ 12/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo Posicao de Cliente                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT223()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="POSICAO DE CLIENTE"
cdesc1   :="Este programa ira emitir o relatório de posição de clientes"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT223"
wnrel    :="VIT223"+Alltrim(cusername)
aordem  :={"Descricao","Inadimplencia"}
m_pag    :=1
li       :=132
alinha   :={}
nlastkey :=0
lcontinua:=.t.
cperg:="PERGVIT223"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

nordem:=areturn[8]
ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
   set filter to
   return
endif
rptstatus({|| rptdetail()})
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=200
cbtxt :=space(10)

//if nordem ==1
// _mtipo:= "Descricao"
//elseif nordem==2
// _mtipo:= "Ranking"
//elseif nordem==3
// _mtipo:="Giro"
//endif 



titulo:="POSICAO DE CLIENTE"
cabec1:="Data Ref.: " +dtoc(mv_par09)
cabec2:="Cliente                                            UF        Titulos        Vl Pago       Vencidos   Não Vencidos  Inad.(%)"
//Cliente                                        UF     Tit.Aberto        Vl Pago       Vencidos   Não Vencidos  Inad.
//999999-99-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999.99
_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilse1:=xfilial("SE1")
_cfilse5:=xfilial("SE5")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
se1->(dbsetorder(1))
se5->(dbsetorder(1))
_acom    :={}


processa({|| _geratmp()})

setprc(0,0)
_tgeral:=0
_tpago:=0
_tvenc:=0
_tnvenc:=0
_tmedia:=0
setregua(sb1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	incregua() 
   dbselectarea("SA1")
	sa1->(dbsetorder(1))
	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
   _saldocli:=sldcliente(tmp1->cliente+tmp1->loja,mv_par09)
	sa3->(dbseek(_cfilsa3+tmp1->vend))
//	msgstop(sa3->a3_super)
//	msgstop(tmp1->vend)
//	msgstop(mv_par07)
   if sa3->a3_super < mv_par07 .or. sa3->a3_super > mv_par08 
		tmp1->(dbskip())
		loop
	endif	
   
//	incproc("Selecionando titulos em geral...")

	_cquery :=" SELECT "
	_cquery +=" SUM(E1_VALOR) VALOR"
	_cquery +=" FROM "+retsqlname("SE1")+" SE1"
	_cquery +=" WHERE E1_FILIAL='"+_cfilse1+"'"
	_cquery +=" AND SE1.D_E_L_E_T_<>'*'"
	_cquery +=" AND E1_CLIENTE='"+tmp1->cliente+"'"   
	_cquery +=" AND E1_LOJA='"+tmp1->loja+"'"   
	_cquery +=" AND E1_TIPOFAT <>'FT'"   
	_cquery +=" AND E1_TIPO <>'NCC'"   
   _cquery +=" AND E1_EMISSAO <='"+dtos(mv_par09)+"'"
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","VALOR","N",15,2)
	
	tmp2->(dbgotop())
	_valger:=tmp2->valor
	tmp2->(dbclosearea())         


//	incproc("Selecionando notas de credito...")


	_cquery :=" SELECT "    
	_cquery +=" SUM(E1_VALOR) VALOR"
	_cquery +=" FROM "+retsqlname("SE1")+" SE1"
	_cquery +=" WHERE E1_FILIAL='"+_cfilse1+"'"
	_cquery +=" AND SE1.D_E_L_E_T_<>'*'"
	_cquery +=" AND E1_CLIENTE='"+tmp1->cliente+"'"   
	_cquery +=" AND E1_LOJA='"+tmp1->loja+"'"   
	_cquery +=" AND E1_TIPO ='NCC'"   
   _cquery +=" AND E1_VENCREA <'"+dtos(mv_par09)+"'"
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP3"
	tcsetfield("TMP3","VALOR","N",15,2)
	
	tmp3->(dbgotop())
	_valncc:=tmp3->valor
	tmp3->(dbclosearea())         



//	incproc("Selecionando titulos vencidos...")

	_cquery :=" SELECT "
	_cquery +=" SUM(E5_VALOR) VALOR"
	_cquery +=" FROM "+retsqlname("SE5")+" SE5"
	_cquery +=" WHERE E5_FILIAL='"+_cfilse5+"'"
	_cquery +=" AND SE5.D_E_L_E_T_<>'*'"
	_cquery +=" AND E5_CLIFOR='"+tmp1->cliente+"'"   
	_cquery +=" AND E5_LOJA='"+tmp1->loja+"'"   
	_cquery +=" AND E5_MOTBX ='NOR'"   
	_cquery +=" AND E5_RECPAG ='R'"   
	_cquery +=" AND E5_TIPODOC NOT IN ('JR','J2','TR','BA','DC')"
   _cquery +=" AND E5_DTDISPO <'"+dtos(mv_par09)+"'"
                                                            
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP4"
	tcsetfield("TMP4","VALOR","N",15,2)
	
	tmp4->(dbgotop())
	_valpago:=tmp4->valor
	tmp4->(dbclosearea())         

	
//	incproc("Selecionando titulos não vencidos...")

	_cquery :=" SELECT "
	_cquery +=" SUM(E1_VALOR) VALOR"
	_cquery +=" FROM "+retsqlname("SE1")+" SE1"
	_cquery +=" WHERE E1_FILIAL='"+_cfilse1+"'"
	_cquery +=" AND SE1.D_E_L_E_T_<>'*'"
	_cquery +=" AND E1_CLIENTE='"+tmp1->cliente+"'"   
	_cquery +=" AND E1_LOJA='"+tmp1->loja+"'"   
	_cquery +=" AND E1_TIPOFAT <>'FT'"   
	_cquery +=" AND E1_TIPO <>'NCC'"   
   _cquery +=" AND E1_EMISSAO <='"+dtos(mv_par09)+"'"
   _cquery +=" AND E1_VENCREA >='"+dtos(mv_par09)+"'"
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP5"
	tcsetfield("TMP5","VALOR","N",15,2)
	tmp5->(dbgotop())
	_valnvenc:=tmp5->valor

	tmp5->(dbclosearea())

   _valatraso:=_saldocli-_valnvenc
   if _valatraso <0
   	_valatraso:=0
   endif	                         
   if _valatraso+_valnvenc >0
		aadd(_acom,{tmp1->cliente+"-"+tmp1->loja,tmp1->nome,tmp1->est,_valger-_valncc,_valpago,_valatraso,_valnvenc,(_valatraso/(_valatraso+_valnvenc)*100)})
	endif	
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if lcontinua
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
   _tqtdent:=0
	_tqtdsai:=0
	_nest :=0
	_nemp :=0
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif       
	if nordem==1	
		 _acom:= asort(_acom,,,{|x,y| x[2]<y[2]})
	elseif nordem==2	
		 _acom:= asort(_acom,,,{|x,y| y[8]<x[8]})
	endif	 
//   msgstop(len(_acom))
	for _i:=1 to len(_acom)
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif       
//999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999.99
//		if (_acom[_i,6]+_acom[_i,6]) > 0
			@ prow()+1,000 PSAY _acom[_i,1]
			@ prow() ,010  PSAY left(_acom[_i,2],40)
			@ prow() ,051  PSAY _acom[_i,3]
			@ prow() ,054  PSAY _acom[_i,4] picture "@E 999,999,999.99"
			@ prow() ,070  PSAY _acom[_i,5] picture "@E 999,999,999.99"
			@ prow() ,084  PSAY _acom[_i,6] picture "@E 999,999,999.99"
			@ prow() ,099  PSAY _acom[_i,7] picture "@E 999,999,999.99"
			@ prow() ,117  PSAY _acom[_i,8] picture "@E 999.99"
			_tgeral+=_acom[_i,4]
			_tpago+=_acom[_i,5]
			_tvenc+=_acom[_i,6]
			_tnvenc+=_acom[_i,7]                                       
			_tmedia+=_acom[_i,8]
//		endif	
	next
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif       
   @ prow()+1,000 PSAY "TOTAL "
	@ prow() ,054  PSAY _tgeral picture "@E 999,999,999.99"
	@ prow() ,070  PSAY _tpago picture "@E 999,999,999.99"
	@ prow() ,084  PSAY _tvenc picture "@E 999,999,999.99"
	@ prow() ,099  PSAY _tnvenc picture "@E 999,999,999.99"
	@ prow() ,117  PSAY _tmedia/len(_acom) picture "@E 999.99"
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

static function _geratmp()
procregua(1)
incproc("Selecionando clientes...")
_cquery:=" SELECT"
_cquery+=" A1_COD CLIENTE,A1_LOJA LOJA,A1_NOME NOME,A1_EST EST,A1_VEND VEND"
_cquery+=" FROM "
_cquery+=  retsqlname("SA1")+" SA1"
_cquery+=" WHERE"
_cquery+="     SA1.D_E_L_E_T_<>'*'"
_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
_cquery+=" AND A1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"  
_cquery+=" AND A1_LOJA BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"  
_cquery+=" AND A1_EST BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"  
_cquery+=" ORDER BY"
_cquery+=" A1_NOME"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do cliente         ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"02","Da loja            ?","mv_ch1","C",02,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Ate o cliente      ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"04","Ate a loja         ?","mv_ch1","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do estado          ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o estado       ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do gerente         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"08","Ate o gerente      ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"09","Sld. ate a data    ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
                                                        S A I D A S                        E S T O Q U E
Codigo Descricao                                Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo  Empenho    Saldo Pendencia Dias Quarentena          Valor
XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999  9999.999 9999   9999.999 999.999.999,99
*/
