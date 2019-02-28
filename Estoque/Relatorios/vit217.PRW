/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT217   ³ Autor ³ Gardenia              ³ Data ³ 28/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transp. / Documentos                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT217()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="Documentos Transportadoras"
cdesc1   :="Este programa ira emitir o relatorio de documentos "
cdesc2   :=""
cdesc3   :=""
cstring  :="SZC"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT217"
wnrel    :="VIT217"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="VIT217"
//_pergsx1()
//pergunte(cperg,.f.)

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
_cfilszc:=xfilial("SZC")
_cfilszd:=xfilial("SZD")
_cfilsa2:=xfilial("SA2")
szc->(dbsetorder(1))
szd->(dbsetorder(2))
sa2->(dbsetorder(1))

processa({|| _querys()})

cabec1:=""
//Matr.    Nome                                     C.C.                                Funcao"
cabec2:=""
//cabec2:="Data     Atividade                                          Hora Inicial   Hora Final   Total  Obs. "                                                        
//999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX"
//99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    99:99      99:99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 

setprc(0,0)                                   
szc->(dbgotop())
while ! szc->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif    
	_doc := ""
	_transp := ""
	_total :=0
/*	if SZC.D_E_L_E_T_=='*'
		szc->(dbskip())	
	endif*/
	if szc->zc_codigo <> _doc
	   @ prow()+1,000 PSAY " "
	   @ prow()+1,000 PSAY szc->zc_codigo+ " - "+ szc->zc_desc
   	_doc := szc->zc_codigo
   endif
	szd->(dbseek(_cfilszd+szc->zc_codigo+""))   
	while ! szd->(eof()) .and.;
	   szc->zc_codigo == szd->zd_documen .and.;
      lcontinua
		if prow()==0 .or. prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif    
		sa2->(dbseek(_cfilsa2+szd->zd_transp+""))
 		if sa2->a2_transp <> _transp
  			@ prow()+1,000 PSAY szd->zd_transp+" - "+sa2->a2_nome  
  			_transp := szd->zd_transp
 		endif	 		              
		szd->(dbskip())
	end	
		szc->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
//	end
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
_cquery+=" ZD_DOCUMEN DOC,ZD_TRANSP TRANSP,ZC_CODIGO COD,ZC_DESC DESCR"
_cquery+=" FROM "
_cquery+=  retsqlname("SZD")+" SZD,"
_cquery+=  retsqlname("SZC")+" SZC"
_cquery+=" WHERE"
_cquery+="     SZC.D_E_L_E_T_<>'*'"
_cquery+=" AND SZD.D_E_L_E_T_<>'*'"
_cquery+=" ORDER BY ZC_DESC"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
return
