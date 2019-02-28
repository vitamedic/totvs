/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT160   ³ Autor ³ Gardenia              ³ Data ³ 10/11/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos Liberados                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da data
mv_par02 Ate a data
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT160()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="PEDIDOS LIBERADOS - EXPEDIÇÃO"
cdesc1   :="Este programa ira emitir a relacao dos pedidos liberados para expedição"
cdesc2   :=""
cdesc3   :=""
cstring  :="SC9"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT160"
wnrel    :="VIT160"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT160"
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
_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsc9:=xfilial("SC9")
_cfilsc5:=xfilial("SC5")
_cfilsf2:=xfilial("SF2")
_cfilsa4:=xfilial("SA4")
sa1->(dbsetorder(1))
sa4->(dbsetorder(1))
sa3->(dbsetorder(1))
sc5->(dbsetorder(1))
sf2->(dbsetorder(1))



processa({|| _querys()})

cabec1:="Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
cabec2:="Pedido Nota Ser    Cliente                                  UF   Data lib        Peso   Volume          Valor"  
//Pedido   Nota   Ser  Cliente                                  UF   Data Ped        Peso   Volume          Valor  
//999999 999999-999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX   99/99/99  999,999.99  999.999 999,999,999.99  



setprc(0,0)

setregua(sc9->(lastrec()))
@ 000,000 PSAY avalimp(132)

tmp1->(dbgotop())
_totgerped :=0
_ttotvol:=0
_ttotpeso:=0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif             
	_transp:=tmp1->transp
	@ prow()+2,00 PSAY _transp +"  "+ tmp1->nometra
	@ prow()+1,00 PSAY " "
   _ttotped :=0
   _totvol:=0
   _totpeso:=0
	while ! tmp1->(eof()) .and.;
		tmp1->transp==_transp .and.;
		lcontinua
 	   _cliente := tmp1->cliente
 	   _loja:=tmp1->loja
		while ! tmp1->(eof()) .and.;
			tmp1->cliente==_cliente .and.;
			lcontinua
			_pedido :=tmp1->pedido
		   _totped :=0                 
		   _datalib:=tmp1->datalib
		   _passou1:=.t.
			incregua()
			while ! tmp1->(eof()) .and. tmp1->cliente==_cliente .and.;
				tmp1->pedido==_pedido  .and.;
				lcontinua
				if prow()>53
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
				endif                   
			   _nfiscal :=tmp1->nfiscal
			   _serie:=tmp1->serie
				while ! tmp1->(eof()) .and. tmp1->cliente==_cliente .and.;
					tmp1->pedido==_pedido .and. tmp1->nfiscal==_nfiscal .and. tmp1->serie==_serie .and.;
					lcontinua
					if prow()>53
						cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
					endif  
					if labortprint
						@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
						lcontinua:=.f.
					endif
					_totped += tmp1->qtdlib*tmp1->prcven
					tmp1->(dbskip())
				end		
				if _passou1                 
					@ prow()+1,000 PSAY _pedido
					_passou1:=.f.
					_passou2:=.t.
				endif	          
				if !empty(_nfiscal) .and. _passou2
				  @ prow(),07 PSAY _nfiscal+"-"+_serie
				  _passou2:=.f.
				elseif !empty(_nfiscal) 
				  @ prow()+1,07 PSAY _nfiscal+"-"+_serie
				endif  
				sa1->(dbseek(_cfilsa1+_cliente+_loja))
				sc5->(dbseek(_cfilsc5+_pedido))
				sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
				@ prow(),019 PSAY sa1->a1_nome
				@ prow(),060 PSAY sa1->a1_est
				@ prow(),065 PSAY _datalib // sc5->c5_emissao
				sf2->(dbseek(_cfilsf2+_nfiscal+_serie))
				if _nfiscal ==sf2->f2_doc .and. _serie == sf2->f2_serie .and. !empty(_nfiscal)
					@ prow(),075 PSAY sf2->f2_pbruto picture "@E 999,999.99"
					@ prow(),087 PSAY sf2->f2_volume1 picture "@E 999,999"
					@ prow(),095 PSAY sf2->f2_valmerc   picture "@E 999,999,999.99"
					_ttotped += sf2->f2_valmerc
					_totvol+=sf2->f2_volume1
					_totpeso+=sf2->f2_pbruto
					_totgerped += sf2->f2_valmerc
					_ttotvol+=sf2->f2_volume1
					_ttotpeso+=sf2->f2_pbruto
				else	
					@ prow(),095 PSAY _totped   picture "@E 999,999,999.99"
					_ttotped += _totped
					_totgerped += _totped
				endif
			end	
		end	
	end	
	@ prow()+1,00 PSAY "Total transportadora =====>"
	@ prow(),075 PSAY _totpeso picture "@E 999,999.99"
	@ prow(),087 PSAY _totvol picture "@E 999,999"
	@ prow(),095 PSAY _ttotped   picture "@E 999,999,999.99"
end         
if lcontinua .and. !empty(_totgerped) 
      @ prow()+1,00 PSAY "Total geral ==============>"
		@ prow(),075 PSAY _ttotpeso picture "@E 999,999.99"
		@ prow(),087 PSAY _ttotvol picture "@E 999,999"
		@ prow(),095 PSAY _totgerped   picture "@E 999,999,999.99"
endif
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
_cquery+=" C9_DATALIB DATALIB,C9_QTDLIB QTDLIB,C9_CLIENTE CLIENTE,C9_LOJA LOJA,"
_cquery+=" C9_PRCVEN PRCVEN,C9_NFISCAL NFISCAL,C9_SERIENF SERIE,C9_PEDIDO PEDIDO," 
_cquery+=" A4_NOME NOMETRA,C5_VEND1 VEND,C5_TRANSP TRANSP"
_cquery+=" FROM "
_cquery+=  retsqlname("SC9")+" SC9,"
_cquery+=  retsqlname("SC5")+" SC5,"
_cquery+=  retsqlname("SA4")+" SA4"
_cquery+=" WHERE"
_cquery+="     SC9.D_E_L_E_T_<>'*'"
_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND SA4.D_E_L_E_T_<>'*'"
_cquery+=" AND C9_FILIAL='"+_cfilsc9+"'"
_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
_cquery+=" AND A4_FILIAL='"+_cfilsa4+"'"
_cquery+=" AND C9_PEDIDO=C5_NUM"
_cquery+=" AND C5_TRANSP=A4_COD"
//_cquery+=" AND C5_TIPO='N'"
_cquery+=" AND C9_DATALIB BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND C5_TRANSP BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" ORDER BY A4_NOME,C9_CLIENTE,C9_PEDIDO,C9_NFISCAL,C9_SERIENF"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DATALIB","D")
tcsetfield("TMP1","QTDLIB"  ,"N",15,3)
tcsetfield("TMP1","PRCVEN","N",15,6)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da Transport.      ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"04","Ate a Transport.   ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
	
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