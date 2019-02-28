/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR02   ³Autor ³ Aline B. Pereira        ³Data ³ 02/03/05 ³±±
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

user function licr02()   
nordem  :=""
tamanho :="G"
limite  :=132
titulo  :="RELATORIO DE COTACOES POR PRODUTOS "
cdesc1  :="Este programa ira emitir a relacao de Cotacoes por Produto"
cdesc2  :=""
cdesc3  :=""
cstring :="SZM"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="LICR02"
wnrel   :="LICR02"
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGLICR02"
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
cabec2:= "Proposta Forn.Meses Edital               Emissao  Abertura  Validade  Licitante                               Quantidade CX  ($)Item     ($)Total"

_acom  :={}
_i := 0

_cfilszl:=xfilial("SZL")
_cfilsb1:=xfilial("SB1")
_cfilsa3:=xfilial("SA3")
_cfilszm:=xfilial("SZM")
_cfilszp:=xfilial("SZP")


sa3->(dbsetorder(1))
sb1->(dbsetorder(1))
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

//dbGoTop()

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

	dbSelectArea("SZM")
	dbSetOrder(1)
	dbSeek(xFilial("SZM")+szl->zl_numpro)
	while !Eof() .and. SZM->ZM_NUMPRO==szl->zl_numpro
			if SZM->ZM_CODPRO < mv_par07 .or. SZM->ZM_CODPRO > mv_par08
				SZM->(dbSkip())
				Loop
			endif        

			aadd(_acom,{szl->zl_repres,szl->zl_licitan,szl->zl_propos,szl->zl_periodo,szl->zl_data,;
				szl->zl_numedi,szl->zl_diasval,szl->zl_numpro,szm->zm_codpro,szm->zm_qtde1,szm->zm_prcuni,szl->zl_dtaber,szm->zm_gerapv})						
			SZM->(dbSkip())
	enddo     
	dbSelectArea("SZL")		 
	SZL->(dbSkip())	
enddo  
	
 _acomr:= asort(_acom,,,{|x,y| x[1]+x[9]+x[2]+x[8]<y[1]+y[9]+y[2]+y[8]})
 _nrepres :=""               

 _nprod := ""  
 _na:=0
store 0 to _nqttot, _nvaltot, _nvalrep, _nqtrep, _nvallic, _nqtlic, _nqtde, _nvalor 
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
	   	@ Prow()+1,00 PSAY "Total produto"  	
			@ Prow(),121 PSAY TRANSFORM(_nqtlic,"@E 9,999,99999")
	  		@ Prow(),142 PSAY TRANSFORM(_nvallic,"@E 99,999,999.99")
	  		_nvalrep += _nvallic
	  		_nqtrep += _nqtlic
	  		store 0 to _nqtlic, _nvallic
		endif	
	 	
 	 	if !empty(_nvalrep)
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                
	   	@ Prow()+1,001 PSAY "Total Representante" 
			@ Prow(),121 PSAY TRANSFORM(_nqtrep,"@E 9,999,99999")
  			@ Prow(),142 PSAY TRANSFORM(_nvalrep,"@E 99,999,999.99")
	   	@ Prow()+1,001 PSAY "" 

	  		_nvaltot += _nvalrep
  			_nqttot += _nqtrep
  			store 0 to _nqtrep, _nvalrep
		endif	
 		sa3->(dbseek(_cfilsa3+_acomr[_i,1]))
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                	
      @ prow()+1,000 PSAY "Representante: "+_acomr[_i,1]+" - " + sa3->a3_nome
      _nrepres := _acomr[_i,1]
 	endif 
 	if _acomr[_i,9] <> _nprod             
	 	if !empty(_nvallic)
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                	
	   	@ Prow()+1,001 PSAY "Total Produto"  	
			@ Prow(),121 PSAY TRANSFORM(_nqtlic,"@E 9,999,99999")  
	  		@ Prow(),142 PSAY TRANSFORM(_nvallic,"@E 99,999,999.99")
	  		@ Prow()+1,001 PSAY ""
	  		_nvalrep += _nvallic	  		
	  		_nqtrep += _nqtlic
	  		store 0 to _nqtlic, _nvallic,_na
		endif	
 		if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                	
		sb1->(dbseek(_cfilsb1+_acomr[_i,9],.t.)) 
 	   @ prow()+1,000 PSAY "Produto :"+substr(_acomr[_i,9],1,6)+" - "+substr(sb1->b1_desc,1,40)		 		
      _nprod := _acomr[_i,9]
 	endif        
 	if prow()>58
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif        
	@ prow()+1,000 PSAY _acomr[_i,3] //proposta
	szp->(dbseek(_cfilszp+_acomr[_i,2],.t.)) 
	@ prow()  ,010 PSAY _acomr[_i,4] //periodo fornecimento
	@ prow()  ,020 PSAY _acomr[_i,6]	// edital
	@ prow()  ,040 PSAY _acomr[_i,5]	//	 emissao
	@ prow()  ,050 PSAY _acomr[_i,12]	//	 abertura
	@ prow()  ,060 PSAY _acomr[_i,12]+60 ///_acomr[_i,7]	//	 validade	   
	@ prow()  ,070 PSAY _acomr[_i,2]+" - "+substr(szp->zp_nomlic,1,40)
	@ Prow()  ,121 PSAY TRANSFORM(_acomr[_i,10],"@E 9,999,99999")
	@ Prow()  ,133 PSAY TRANSFORM(_acomr[_i,11],"@E 9,999.99")
	@ Prow()  ,142 PSAY TRANSFORM(_acomr[_i,10]*_acomr[_i,11],"@E 99,999,999.99")
	@ Prow()  ,160 PSAY _acomr[_i,13]
	if !empty(_acomr[_i,13])
		dbSelectArea("SZM")
		dbSetOrder(1)
		dbSeek(xFilial("SZM")+szl->zl_numpro)
		while !Eof() .and. SZM->ZM_NUMPRO==szl->zl_numpro
			if SZM->ZM_CODPRO < mv_par07 .or. SZM->ZM_CODPRO > mv_par08
				SZM->(dbSkip())
				Loop
			endif        
			SZM->(dbSkip())
	enddo     
	
	  
	  
	endif
	_nqtlic += _acomr[_i,10]
	_nvallic += _acomr[_i,10]*_acomr[_i,11]
//	_cproposta :=_acomr[_i,8]
	_na ++                 
next	
if !empty(_nvallic)
 	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                	
  	@ Prow()+1,001 PSAY "Total produto  "  	
	@ Prow(),121 PSAY TRANSFORM(_nqtlic,"@E 9,999,99999")
	@ Prow(),142 PSAY TRANSFORM(_nvallic,"@E 99,999,999.99")
	_nvalrep += _nvallic
	_nqtrep += _nqtlic
	store 0 to _nqtlic, _nvallic
endif	
	
if !empty(_nvalrep)
 	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                
  	@ Prow()+1,001 PSAY "Total Representante" 
	@ Prow(),121 PSAY TRANSFORM(_nqtrep,"@E 9,999,99999")
	@ Prow(),142 PSAY TRANSFORM(_nvalrep,"@E 99,999,999.99")
	_nvaltot += _nvalrep
	_nqttot += _nqtrep
	store 0 to _nqtrep, _nvalrep
endif	
if !empty(_nvaltot)
 	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                
  	@ Prow()+1,001 PSAY "Total Geral" 
	@ Prow(),121 PSAY TRANSFORM(_nqttot,"@E 99,999,99999")
	@ Prow(),142 PSAY TRANSFORM(_nvaltot,"@E 999,999,999.99")
	store 0 to _nqttot, _nvaltot
endif	
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
aadd(_agrpsx1,{cperg,"07","Do Produto         ?","mv_ch7","C",15,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"08","Ate Produto        ?","mv_ch8","C",15,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
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

