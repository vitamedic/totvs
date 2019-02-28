/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR12   ³ Autor ³ Aline B. Pereira      ³ Data ³ 08/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Licitacoes Pendentes por Representante         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"                          
#include "rwmake.ch"

user function licr12()   
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="RELATORIO LICITACOES PENDENTES POR REPRESENTANTE "
cdesc1  :="Este programa ira emitir a relacao de Licitacoes Pendentes por representante / Cliente"
cdesc2  :=""
cdesc3  :=""
cstring :="SZL"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="LICR12"
wnrel   :="LICR12"
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGLICR12"
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
//cabec1:="PERIODO DE "+dtoc(mv_par05)+" A "+dtoc(mv_par06)
cabec1:= "Proposta Edital               Licitante                                                Fornc.        Emissao Abertura Validade "
cabec2:= ""
_acom  :={}
_i := 0

_cfilszl:=xfilial("SZL")
_cfilsa3:=xfilial("SA3")
_cfilszm:=xfilial("SZM")
_cfilszp:=xfilial("SZP")
_cfilsa1:=xfilial("SA1")

sa3->(dbsetorder(1))
sa1->(dbsetorder(1))
szl->(dbsetorder(2))  
szm->(dbsetorder(1))                
szp->(dbsetorder(1))                


setregua(szl->(lastrec()))
_mrepres := ""
_mlicit := ""
setprc(0,0)
szl->(dbseek(_cfilszl+mv_par01,.t.)) 
while ! szl->(eof()) .and.;
			szl->zl_filial==_cfilszl .and.;
			szl->zl_repres<=mv_par02
			
	if SZL->ZL_LICITAN < mv_par03 .or. SZL->ZL_LICITAN > mv_par04 .OR. SZL->ZL_STATUS<>"3" 
		SZL->(dbSkip())
		Loop
	endif
	szp->(dbseek(_cfilszp+szl->zl_licitan))
	sa1->(dbseek(_cfilsa1+szp->zp_codcli+szp->zp_ljcli)) 	
	if sa1->a1_tipo=="F"
		aadd(_acom,{szl->zl_repres,szl->zl_licitan,szl->zl_propos,szl->zl_periodo,szl->zl_data,;
				szl->zl_numedi,szl->zl_diasval,szl->zl_numpro, szl->zl_dtaber})		
	endif			
	dbSkip() 
enddo  
 _acomr:= asort(_acom,,,{|x,y| x[1]+x[3]+x[2]<y[1]+y[3]+y[2]})
 _nrepres :=""               
 _nlicit := ""  
for _i:=1 to len(_acomr)
	incregua()
 	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                
 	if _acomr[_i,1] <> _nrepres
 		sa3->(dbseek(_cfilsa3+_acomr[_i,1]))
	 	if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                 		
      @ prow()+1,000 PSAY "Representante: "+_acomr[_i,1]+" - " + sa3->a3_nome
      @ prow()+1,00 PSAY "" // Replicate("-",220)
      _nrepres := _acomr[_i,1]
  endif
	if prow()>58
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif        
	szp->(dbseek(_cfilszp+_acomr[_i,2]))
	@ prow()+1,000 PSAY _acomr[_i,3] //proposta
	@ prow()  ,010 PSAY _acomr[_i,6]	// edital
	@ prow()  ,030 PSAY _acomr[_i,2]+" - "+substr(szp->zp_nomlic,1,40)		 		
	@ prow()  ,090 PSAY _acomr[_i,4] //periodo fornecimento
	@ prow()  ,100 PSAY _acomr[_i,5]	//	 DT. emissao
	@ prow()  ,110 PSAY _acomr[_i,9]	//	DT.ABERTURA
	@ prow()  ,120 PSAY _acomr[_i,9]+60 ///_acomr[_i,7]	//	 validade	   
next	
roda(cbcont,cbtxt)         	
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
//aadd(_agrpsx1,{cperg,"05","Data Inicial       ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"06","Data Final         ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
Return()*/