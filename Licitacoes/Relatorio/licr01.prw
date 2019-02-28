/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR001    ³Autor ³ Aline B. Pereira     ³Data ³ 08/06/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Vendas por Representante                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"                          
#include "rwmake.ch"

user function licr01()   
nordem  :=""
tamanho :="G"
limite  :=132
titulo  :="RELATORIO DE VENDAS POR REPRESENTANTE "
cdesc1  :="Este programa ira emitir a relacao de Licitacoes por Cliente"
cdesc2  :=""
cdesc3  :=""
cstring :="SZL"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="LICR01"
wnrel   :="LICR01"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="LICR01"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)
ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

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
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
cabec1:="PERIODO DE "+dtoc(mv_par05)+" A "+dtoc(mv_par06)
cabec2:= "Proposta Forn.Meses Edital               Emissao  Abertura Validade  Produto   Descricao                    Quantidade CX  ($)Item     ($)Total"

_acom  :={}
_i := 0

_cfilszl:=xfilial("SZL")
_cfilsa3:=xfilial("SA3")
_cfilszm:=xfilial("SZM")
_cfilszp:=xfilial("SZP")

sa3->(dbsetorder(1))
szl->(dbsetorder(2))  
szm->(dbsetorder(1))                
szp->(dbsetorder(1))                

_cindszl:=criatrab(,.f.)
_cchave :="ZL_FILIAL+DTOS(ZL_DATA)"
_cfiltro:=""
szl->(indregua("SZL",_cindszl,_cchave,,_cfiltro))

setregua(szl->(lastrec()))
_mrepres := ""
_mlicit := ""
setprc(0,0)


szl->(dbseek(_cfilszl+dtos(mv_par05),.t.)) 
while ! szl->(eof()) .and.;
			szl->zl_filial==_cfilszl .and.;
			szl->zl_data<=mv_par06
	if SZL->ZL_REPRES < mv_par01 .or. SZL->ZL_REPRES > mv_par02 
		SZL->(dbSkip())
		Loop
	endif
	if SZL->ZL_LICITAN < mv_par03 .or. SZL->ZL_LICITAN > mv_par04
		SZL->(dbSkip())
		Loop
	endif
	aadd(_acom,{szl->zl_repres,szl->zl_licitan,szl->zl_propos,szl->zl_periodo,szl->zl_data,;
			szl->zl_numedi,szl->zl_diasval,szl->zl_numpro, szl->zl_dtaber})		
	dbSkip() 
enddo  
 _acomr:= asort(_acom,,,{|x,y| x[1]+x[2]+x[3]<y[1]+y[2]+y[3]})
 _nrepres :=""               
 _nlicit := ""  
 _na:=0
store 0 to _nqttot, _nvaltot, _nvalrep, _nqtrep, _nvallic, _nqtlic
for _i:=1 to len(_acomr)
	incregua()
 	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                
 	if _acomr[_i,1] <> _nrepres
	 	if !empty(_nvallic)
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                	
	   	@ Prow()+1,00 PSAY "Total Licitante"  	
			@ Prow(),107 PSAY TRANSFORM(_nqtlic,"@E 9,999,99999")
	  		@ Prow(),131 PSAY TRANSFORM(_nvallic,"@E 99,999,999.99")
	  		_nvalrep += _nvallic
	  		_nqtrep += _nqtlic
	  		store 0 to _nqtlic, _nvallic
		endif	
	 	
 	 	if !empty(_nvalrep)
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                
	   	@ Prow()+1,001 PSAY "Total Representante" 
			@ Prow(),107 PSAY TRANSFORM(_nqtrep,"@E 9,999,99999")
  			@ Prow(),131 PSAY TRANSFORM(_nvalrep,"@E 99,999,999.99")
	  		_nvaltot += _nvalrep
  			_nqttot += _nqtrep
  			store 0 to _nqtrep, _nvalrep
		endif	
 		sa3->(dbseek(_cfilsa3+_acomr[_i,1]))
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                 		
      @ prow()+1,000 PSAY "Representante: "+_acomr[_i,1]+" - " + sa3->a3_nome
      @ prow()+1,00 PSAY "" // Replicate("-",220)
      _nrepres := _acomr[_i,1]
 	endif
 	if _acomr[_i,2] <> _nlicit             
 		szp->(dbseek(_cfilszp+_acomr[_i,2]))
	 	if !empty(_nvallic)
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                	
	   	@ Prow()+1,001 PSAY "Total Licitante"  	
			@ Prow(),107 PSAY TRANSFORM(_nqtlic,"@E 9,999,99999")  
	  		@ Prow(),131 PSAY TRANSFORM(_nvallic,"@E 99,999,999.99")
	 	  	@ prow()+1,000 PSAY ""	  		
	  		_nvalrep += _nvallic
	  		_nqtrep += _nqtlic
	  		store 0 to _nqtlic, _nvallic,_na
		endif	
	 	if _na > 0	 		 
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                	 	
	 	  	@ prow()+2,000 PSAY ""
	 	  	_na := 0
	 	endif
	 	if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                	
 	   @ prow()+1,000 PSAY "Licitante :"+_acomr[_i,2]+" - "+substr(szp->zp_nomlic,1,40)		 		
      _nlicit := _acomr[_i,2]
 	endif        
//_ddataini1:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini1,2)+"/"+strzero(_nanoini1,4))
 	if prow()>58
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif        
 	if _na > 0	
		@ prow()+2,000 PSAY _acomr[_i,3] //proposta	
	else 
		@ prow()+1,000 PSAY _acomr[_i,3] //proposta
	endif
	@ prow()  ,010 PSAY _acomr[_i,4] //periodo fornecimento
	@ prow()  ,020 PSAY _acomr[_i,6]	// edital
	@ prow()  ,040 PSAY _acomr[_i,5]	//	 emissao
	@ prow()  ,050 PSAY _acomr[_i,9]	//	 ABERTURA
	@ prow()  ,060 PSAY _acomr[_i,9]+60 ///_acomr[_i,7]	//	 validade	   
	_nqtde := 0
	_nvalor := 0   	     
	_cproposta :=_acomr[_i,8]
	_na ++
	dbSelectArea("SZM")
	dbSetOrder(1)
	dbSeek(xFilial("SZM")+_cProposta)
	while !Eof() .and. SZM->ZM_NUMPRO==_cProposta
	 	if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                
	  if _nqtde > 0
   	@ Prow()+1,000 PSAY ""
     endif	
 		_nPrcUni := SZM->ZM_PRCUNI
 		
		@ Prow(),070  PSAY substr(SZM->ZM_CODPRO,1,6)
		@ Prow(),077 PSAY substr(SZM->ZM_DESC,1,30)
		@ Prow(),106 PSAY TRANSFORM(SZM->ZM_QTDE1,"@E 9,999,99999")
		@ Prow(),121 PSAY TRANSFORM(_nPrcUni,"@E 9,999.99")
		@ Prow(),130 PSAY TRANSFORM(_nPrcUni*SZM->ZM_QTDE1,"@E 99,999,999.99")
		_nqtde += SZM->ZM_QTDE1
		_nvalor += _nPrcUni*SZM->ZM_QTDE1
		szm->(dbSkip())
	enddo
 	if !empty(_nvalor)
	 	if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                	
   	@ Prow()+1,001 PSAY "Total Proposta" 
		@ Prow(),107 PSAY TRANSFORM(_nqtde,"@E 9,999,99999")
  		@ Prow(),131 PSAY TRANSFORM(_nvalor,"@E 99,999,999.99")
  		_nvallic+= _nvalor
  		_nqtlic += _nqtde
  		store 0 to _nqtde, _nvalor
	endif	
next	
if !empty(_nvallic)
 	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                	
  	@ Prow()+1,001 PSAY "Total Licitante"  	
	@ Prow(),107 PSAY TRANSFORM(_nqtlic,"@E 9,999,99999")
	@ Prow(),131 PSAY TRANSFORM(_nvallic,"@E 99,999,999.99")
	_nvalrep += _nvallic
	_nqtrep += _nqtlic
	store 0 to _nqtlic, _nvallic
endif	
	
if !empty(_nvalrep)
 	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                
  	@ Prow()+1,001 PSAY "Total Representante" 
	@ Prow(),107 PSAY TRANSFORM(_nqtrep,"@E 9,999,99999")
	@ Prow(),131 PSAY TRANSFORM(_nvalrep,"@E 99,999,999.99")
	_nvaltot += _nvalrep
	_nqttot += _nqtrep
	store 0 to _nqtrep, _nvalrep
endif	
if !empty(_nvaltot)
 	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                
  	@ Prow()+1,001 PSAY "Total Geral" 
	@ Prow(),107 PSAY TRANSFORM(_nqttot,"@E 9,999,99999")
	@ Prow(),131 PSAY TRANSFORM(_nvaltot,"@E 99,999,999.99")
	store 0 to _nqttot, _nvaltot
endif	

/*	@ PROW(),00 PSAY "TOTAL: "
	@ PROW(),150 PSAY TRANSFORM(_nqtde,"@E 999,999,999.999")
	@ PROW(),180 PSAY TRANSFORM(_nvalor,"@E 999,999,999.99")

//   nLin := nLin + 1 // Avanca a linha de impressao
//endDo
  	
//enddo              */
roda(cbcont,cbtxt)         	

_cindszl+=szl->(ordbagext())

szl->(retindex("SZL"))
ferase(_cindszl)    

szl->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return
  
static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Representante   ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"02","Ate Representante  ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"03","Do Licitante       ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SZP"})
aadd(_agrpsx1,{cperg,"04","Ate o Licitante    ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SZP"})
aadd(_agrpsx1,{cperg,"05","Data Inicial       ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Data Final         ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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


Static Function ImpProds(_cProposta,dDataProp)
Local _mArea     := {"SZM"}
Local _mAlias    := {}
_mAlias := U_SalvaAmbiente(_mArea)
dbSelectArea("SZM")
dbSetOrder(1)
dbSeek(xFilial("SZM")+_cProposta)
while !Eof() .and. SZM->ZM_NUMPRO==_cProposta
	_nPrcUni := if(mv_par05<>1,xMoeda(SZM->ZM_PRCUNI,1,mv_par05,dDataProp,4),SZM->ZM_PRCUNI)
	@ Prow() ,80  PSAY SZM->ZM_CODPRO
	@ Prow(),100 PSAY SZM->ZM_DESC
	@ Prow(),150 PSAY TRANSFORM(SZM->ZM_QTDE1,"@E 9,999,999.99")
	@ Prow(),170 PSAY TRANSFORM(_nPrcUni,"@E 9,999.99")
	@ Prow(),180 PSAY TRANSFORM(_nPrcUni*SZM->ZM_QTDE1,"@E 99,999,999.99")
	@ Prow()+1,00 PSAY ""
	_nqtde += SZM->ZM_QTDE1
	_nvalor += _nPrcUni*SZM->ZM_QTDE1
	SZM->(dbSkip())
enddo
U_VoltaAmbiente(_mAlias)
Return()