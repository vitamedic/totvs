/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT152   ³ Autor ³ Aline                ³ Data ³ 23/09/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Ordens de Separacao Impressas Aptos a Faturar   ³±±
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
mv_par01 Do produto
mv_par02 Ate o produto
mv_par01 Do tipo
mv_par02 Ate o tipo
mv_par01 Do grupo
mv_par02 Ate a grupo
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT152()
nordem   :=""
tamanho  :="M"
limite   :=155
titulo   :="PEDIDOS LIBERADOS C/ORDEM DE SEPARACAO IMPRESSA"
cdesc1   :="Este programa ira emitir a relacao dos pedidos liberados"
cdesc2   :=""
cdesc3   :=""
cstring  :="SC9"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT152"
wnrel    :="VIT152"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.T.  
//lpara := .f.

cperg:="PERGVIT152"
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

_cestado :=getmv("MV_ESTADO")
_cnorte  :=getmv("MV_NORTE")
_nicmpad :=getmv("MV_ICMPAD")



_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsc9:=xfilial("SC9")
_cfilsc5:=xfilial("SC5")
_cfilsb1:=xfilial("SB1")
_cfilsf4:=xfilial("SF4")
_cfilsf7:=xfilial("SF7")
_cfilsc6:=xfilial("SC6")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sc5->(dbsetorder(1))
sb1->(dbsetorder(1))
sf4->(dbsetorder(1))
sf7->(dbsetorder(1))
sc6->(dbsetorder(1))


processa({|| _querys()})
cabec1:="Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
cabec2:="Pedido Tp Cliente                              Dt.Imp     C.Pgto       Suframa      GNR/DIFAL          Valor Pedido         Valor Desc   "
//Pedido Tp Cliente                              Dt.Imp       C.Pgto          Suframa         GNR             Valor Pedido            NF     "
//999999 X  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99     999 999,999.99 999,999.99 999,999.99 999,999.99 9,999,999.99 
                                                             

setprc(0,0)

setregua(sc9->(lastrec()))
@ 000,000 PSAY avalimp(132)

tmp1->(dbgotop())
_totalped :=0
_totalqtde :=0
_totval := 0
_totqte := 0
_mant := "  "
_ntped := 0 
_ncx :=0
_nun :=0
_totvaldes :=0

while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif 
   _totvaldes :=0
   _totdesc :=0
   _totqtde :=0
   _pedido :=tmp1->pedido
   _cliente := tmp1->cliente
   _licit :=tmp1->licitac
	_ncx :=0
	_nun :=0
	_nbase:="--"
	_ngnr :="--"
	_nsubst :=0
	_nsuframa :=0
	_totped :=0
	_npicm   :=0
	_nbaseicm:=0
	_nvalicm :=0
	_nbaseret:=0
	_nvalret :=0
	_nbasegnrp:=0
	_nbasegnr:=0
	_nvalgnr :=0
	_ndesczf :=0
	_nvalmerc:=0
	_nrepasse:=0
	_nprep   :=0
	while ! tmp1->(eof()) .and.;
			tmp1->pedido==_pedido .and.;
			lcontinua
		incregua()
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif                   
		sb1->(dbseek(_cfilsb1+tmp1->produto)) 
		_totdesc += (tmp1->qtdlib*tmp1->prcven)*(tmp1->pdesc/100)
		_totped += tmp1->qtdlib*tmp1->prcven
		_totalped += tmp1->qtdlib*tmp1->prcven
		_totqtde += tmp1->qtdlib
		_totalqtde += tmp1->qtdlib
		_ncx+=int(tmp1->qtdlib/sb1->b1_cxpad)
		_nun+=tmp1->qtdlib%sb1->b1_cxpad		                         
		_cliente := tmp1->cliente+"-"+tmp1->loja
		sc5->(dbseek(_cfilsc5+tmp1->pedido))
		sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))		
		sc6->(dbseek(_cfilsc6+tmp1->pedido+tmp1->item+tmp1->produto))
     	sf4->(dbseek(_cfilsf4+sc6->c6_tes)) 
		_nqtd  :=tmp1->qtdlib  
		
		_nvalor:=round(_nqtd*tmp1->prcven,2)
		_vericm() 
   		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
	@ prow()+1,000 PSAY _pedido
	if _licit= 'S'
	  @ prow(),07 PSAY 'H'
	else   
	  @ prow(),07 PSAY 'F'
	endif  
	//RICARDO FIUZA'S INICIO 19/01/2016
	if  sc5->c5_tipocli = "F" .and. sa1->a1_est <> "GO"
	_ngnr :="DIFAL"
	endif
		//RICARDO FIUZA'S FIM   
    if sc5->c5_geragnr=="S"	                                                                   
	   _nbase:="--"
	   _ngnr :="GNR"
	elseif  sc5->c5_tipocli="S"	
 	 	_nbase:=" "
		_nsubst :=" "
	endif
	@ prow(),09 PSAY _cliente+" "+SUBSTR(sa1->a1_nome,1,25)
	@ prow(),045 PSAY sc5->c5_emissao
	@ prow(),060 PSAY sc5->c5_condpag
	@ prow(),070 PSAY sa1->a1_suframa 	
	@ prow(),088 PSAY _ngnr   //picture "@E 999,999,999.99"
	@ prow(),095 PSAY _totped   picture "@E 999,999,999.99" 
	@ prow(),115 PSAY _totdesc   picture "@E 999,999,999.99"   
	_totval += _totped
	_totqte += _totqtde 
	_totvaldes += _totdesc
	_ntped ++
	@ prow()+1,000 PSAY replicate("-",155)
	lcontinua := .t.
end


 if lcontinua .and. _ntped > 0
	@ prow()+2,000 PSAY "Totais"
	@ prow()  ,047 PSAY _ntped picture "@E 999999"
	@ prow(),093 PSAY _totalped   picture "@E 999,999,999.99"
	@ prow(),113 PSAY _totvaldes picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY replicate("-",limite)
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
_cquery+=" C9_DATASEP DATASEP,C9_QTDLIB QTDLIB,C9_CLIENTE CLIENTE,C9_LOJA LOJA,"
_cquery+=" C9_PRCVEN PRCVEN,C9_NFISCAL NFISCAL,C9_PEDIDO PEDIDO,C9_PRODUTO PRODUTO,C9_ITEM ITEM,C5_VEND1 VEND,C5_LICITAC LICITAC,"  
_cquery+=" C5_LOJACLI,C6_NUM PEDC6, C6_DESCONT PORC,C6_VALDESC DESCONT,C5_PDESCAB PDESC"
_cquery+=" FROM "
_cquery+=  retsqlname("SC9")+" SC9 "
_cQuery  += "INNER JOIN " + retsqlname("SC5")+ " SC5 ON SC9.C9_PEDIDO = SC5.C5_NUM AND SC9.C9_CLIENTE = SC5.C5_CLIENTE AND SC9.C9_LOJA = SC5.C5_LOJACLI "     
_cQuery  += "INNER JOIN " + retsqlname("SC6")+ " SC6 ON SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_CLIENTE = SC6.C6_CLI AND SC9.C9_LOJA = SC6.C6_LOJA AND SC9.C9_PRODUTO = SC6.C6_PRODUTO AND SC9.C9_ITEM = SC6.C6_ITEM "   
_cquery+=" WHERE"
_cquery+="     SC9.D_E_L_E_T_<>'*'" 
_cquery+=" AND SC6.D_E_L_E_T_<>'*'" 
_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND C9_FILIAL='"+_cfilsc9+"'"
_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
_cquery+=" AND C9_NFISCAL='     '"
_cquery+=" AND C9_DATASEP BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" ORDER BY C9_CLIENTE,C5_VEND1,C9_PEDIDO,C6_PRODUTO,C6_ITEM"

Memowrite('C:\TOTVS\VIT152.txt', _cquery)

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DATASEP","D")
tcsetfield("TMP1","QTDLIB"  ,"N",15,3)
tcsetfield("TMP1","PRCVEN","N",15,6)
return

static function _vericm()
_nbaseicmp:=0
_nvalicmp :=0
if sf4->f4_icm=="S"
	if sc5->c5_tipocli=="F" .and.;
		empty(sa1->a1_inscr)
		_npicm:=if(sb1->b1_picm>0,sb1->b1_picm,_nicmpad)
	elseif sa1->a1_est==_cestado
		_npicm:=if(sb1->b1_picm>0,sb1->b1_picm,_nicmpad)
	elseif sa1->a1_est$_cnorte .and.;
			 at(_cestado,_cnorte)==0
		_npicm:=7
	elseif sc5->c5_tipocli=="X"
		_npicm:=13
	else
		_npicm:=12
	endif
	_nbaseicmp+=_nvalor
	if sf4->f4_baseicm>0
		_nbaseicmp:=noround(_nbaseicmp*(sf4->f4_baseicm/100),2)
	endif
	_nvalicmp:=noround(_nbaseicmp*(_npicm/100),2)
	if sa1->a1_calcsuf=="S" .and.;
		! empty(sa1->a1_suframa) .and.;
		sc5->c5_tipocli<>"F"
		_ndesczf+=_nvalicmp
	else
		_nbaseicm+=_nbaseicmp
		_nvalicm +=_nvalicmp
	endif	
	if sc5->c5_tipocli=="S" .and.;
		sf4->f4_incsol=="S"
		sf7->(dbseek(_cfilsf7+sb1->b1_grtrib+sa1->a1_grptrib))
		_lok:=.f.
		while ! sf7->(eof()) .and.;
				sf7->f7_filial==_cfilsf7 .and.;
				alltrim(sf7->f7_grtrib)==alltrim(sb1->b1_grtrib) .and.;
				sf7->f7_grpcli==sa1->a1_grptrib .and.;
				! _lok
			if sf7->f7_est==sa1->a1_est
				_lok:=.t.
				_nbaseretp:=noround(_nvalor*(1+sf7->f7_margem/100),2)
				if sf4->f4_bsicmst>0
					_nbaseretp:=noround(_nbaseretp*(sf4->f4_bsicmst/100),2)
				endif
				_nvalretp:=noround(_nbaseretp*(sf7->f7_aliqdst/100),2)-_nvalicmp
				_nbaseret+=_nbaseretp
				_nvalret +=_nvalretp
			endif
			sf7->(dbskip())
		end
	elseif sc5->c5_geragnr=="S"
		sf7->(dbseek(_cfilsf7+sb1->b1_grtrib+sa1->a1_grptrib))
		_lok:=.f.
		while ! sf7->(eof()) .and.;
				sf7->f7_filial==_cfilsf7 .and.;
				alltrim(sf7->f7_grtrib)==alltrim(sb1->b1_grtrib) .and.;
				sf7->f7_grpcli==sa1->a1_grptrib .and.;
				! _lok
			if sf7->f7_est==sa1->a1_est
				_lok:=.t.
				_nbasegnrp:=noround(_nvalor*(1+sf7->f7_margem/100),2)
				if sf7->f7_bsicmst>0
					_nbasegnrp:=noround(_nbasegnrp*(sf7->f7_bsicmst/100),2)
				endif
				_nvalgnrp:=noround(_nbasegnrp*(sf7->f7_aliqdst/100),2)-_nvalicmp
				_nbasegnr+=_nbasegnrp
				_nvalgnr +=_nvalgnrp
			endif
			sf7->(dbskip())
		end
	endif
endif
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
