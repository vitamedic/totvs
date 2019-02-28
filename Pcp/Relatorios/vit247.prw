/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT247   ³Autor ³ Gardenia              ³Data ³ 20/10/05   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao / OP / Lote                                        ³±±
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

user function VIT247()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="RELACAO /OP / LOTE"
cdesc1   :="Este programa ira emitir a relacao de OP/lote"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD5"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT247"
wnrel    :="VIT247"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT247"
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
_cfilsb1:=xfilial("SB1")
_cfilsd3:=xfilial("SD3")
_cfilsd5:=xfilial("SD5")
_cfilsc2:=xfilial("SC2")
sb1->(dbsetorder(1))
sd5->(dbsetorder(1))
sc2->(dbsetorder(1))

processa({|| _querys()})

cabec1:="OP           MOV PRODUTO     DESCRICAO                                 QUANTIDADE  CST. UNIT    CST.    TOTAL  DOCUMENTO  EMISSAO      LOTE"
//OP           MOV PRODUTO     DESCRICAO                                 QUANTIDADE  CST. UNIT CST.    TOTAL  DOCUMENTO  EMISSAO
//999999999999 XXX 99999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99,999,999.99  999.99999 999,999.99999 XXXXXXXXXX 99/99/99
//       999999   99   999.999.999,99    999.999.999,99   999.999.999,99    99/99/99
cabec2:=""



setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_op:=tmp1->op
	sc2->(dbseek(_cfilsc2+_op))		
	_codpa:= sc2->c2_produto
	sb1->(dbseek(_cfilsb1+_codpa))	
   _descpa:= sb1->b1_desc
	// Producao do Lote 
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D5_PRODUTO='"+_codpa+"'"
	_cquery+=" AND D5_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND D5_ORIGLAN<'500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
	_cquery+=" AND D5_OP ='"+_op+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	

	while ! tmp1->(eof()) .and.;
		tmp1->produto==_codpa .and.;
		lcontinua .and. _lote ==tmp1->lotectl .and. _op == tmp1->op
		_quant+=tmp1->quant
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end

	@ prow()+1,00 PSAY alltrim(_codpa) + " - " +_descpa
	@ prow()  ,60 PSAY " Data Abertura:
	
	while ! tmp1->(eof()) .and.;
		tmp1->produto==_codpa .and.;
		lcontinua .and. _lote ==tmp1->lotectl .and. _op == tmp1->op
		_quant+=tmp1->quant
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
	
	while ! tmp1->(eof()) .and.;
		tmp1->op==_op .and.;
		lcontinua                                                
		incregua()
		_produto:=tmp1->produto
		_lote :=tmp1->lotectl
      _local :=tmp1->local
      _quant:=0              
		_numseq:=tmp1->numseq		
		_quant:=0
		while ! tmp1->(eof()) .and.;
			tmp1->produto==_produto .and.;
			lcontinua .and. _lote ==tmp1->lotectl .and. _op == tmp1->op
			_quant+=tmp1->quant
			tmp1->(dbskip())
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				lcontinua:=.f.
			endif
		end
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		sb1->(dbseek(_cfilsb1+_produto))	
//999999999999 XXX 99999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99,999,999.99  9,999.99999 999,999.99999 XXXXXXXXXX 99/99/99		
		sd3->(dbsetorder(3))
		sd3->(dbseek(_cfilsd3+_produto+_local+_numseq))	
		@ prow()+1,000 PSAY _op 
		@ prow(),013   PSAY sd3->d3_cf
		@ prow(),017   PSAY substr(_produto,1,12)  
		@ prow(),029   PSAY sb1->b1_desc
		@ prow(),069   PSAY _quant   picture "@E 99,999,999.99"
		@ prow(),083   PSAY sd3->d3_custo1/_quant picture "@E 9,999.99999"
		@ prow(),095   PSAY sd3->d3_custo1 picture "@E 999,999.99999"
		@ prow(),112   PSAY sd3->d3_doc
		@ prow(),123   PSAY sd3->d3_emissao
		@ prow(),136   PSAY _lote
	end
	sd3->(dbsetorder(1))
	sd3->(dbseek(_cfilsd3+_op))	
	while ! sd3->(eof()) .and.	sd3->d3_op==_op .and.	lcontinua
		if substr(sd3->d3_cod,1,3) <> 'MOD'
			sd3->(dbskip())
   		loop
   	end	
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		@ prow()+1,000 PSAY _op 
		@ prow(),013   PSAY sd3->d3_cf
		sb1->(dbseek(_cfilsb1+sd3->d3_cod))	
		//msgstop("d3: "+sd3->d3_cod+" - b1: "+sb1->b1_cod+" - produto: "+_produto)
		@ prow(),017   PSAY substr(sd3->d3_cod,1,12)  
//      msgstop(tmp1->produto+"  "+_produto+"  "+sb1->b1_cod)
		@ prow(),029   PSAY sb1->b1_desc
		@ prow(),069   PSAY sd3->d3_quant   picture "@E 99,999,999.99"
		@ prow(),083   PSAY sd3->d3_custo1 picture "@E 9,999.99999"
		@ prow(),095   PSAY sd3->d3_quant*sd3->d3_custo1 picture "@E 999,999.99999"
		@ prow(),112   PSAY sd3->d3_doc
		@ prow(),123   PSAY sd3->d3_emissao
		sd3->(dbskip())
	end
//	if lcontinua
//		@ prow()+1,000 PSAY "Totais"
//		@ prow(),015   PSAY _nquant  picture "@E 999,999,999.99"
//   	@ prow(),033   PSAY _nempenho picture "@E 999,999,999.99"
//		@ prow(),050   PSAY _nquant-_nempenho   picture "@E 999,999,999.99"
//		@ prow()+1,000 PSAY replicate("-",limite)
//	endif
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
/*
_cquery:=" SELECT"
_cquery+=" D5_PRODUTO PRODUTO,B1_DESC DESCRI,D5_DATA DATA,D5_NUMSEQ NUMSEQ,D5_QUANT QUANT,"
_cquery+=" B1_UM UM,D3_LOCAL LOCAL,D5_OP OP,D5_LOTECTL LOTECTL"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SD5")+" SD5"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SD5.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
_cquery+=" AND D5_PRODUTO=B1_COD"
_cquery+=" AND D5_ESTORNO<>'S'"
_cquery+=" AND D5_OP  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" ORDER BY D5_OP,B1_DESC,D5_LOCAL,D5_LOTECTL"

*/
_cquery:=" SELECT"
_cquery+=" D5_PRODUTO PRODUTO,D5_DATA DATA,D5_NUMSEQ NUMSEQ,D5_QUANT QUANT,"
_cquery+=" D5_OP OP,D5_LOTECTL LOTECTL,D5_LOCAL LOCAL"
_cquery+=" FROM "
_cquery+=  retsqlname("SD5")+" SD5"
_cquery+=" WHERE"
_cquery+="     SD5.D_E_L_E_T_<>'*'"
_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
_cquery+=" AND D5_ESTORNO<>'S'"
_cquery+=" AND D5_ORIGLAN<>'001'"
_cquery+=" AND D5_OP  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" ORDER BY D5_OP,D5_PRODUTO,D5_LOCAL,D5_LOTECTL"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","QUANT"  ,"N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da O.P             ?","mv_ch1","C",11,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate O.P            ?","mv_ch2","C",11,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"03","Qual a Moeda       ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Moeda1"         ,space(30),space(15),"Moeda2"         ,space(30),space(15),"Moeda3"         ,space(30),space(15),"Moeda4"         ,space(30),space(15),"Moeda5"         ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","De Data Movimento  ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate Data Movimento ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Total.Qtde.por O.P ?","mv_ch6","N",08,0,0,"C",space(60),"mv_par06"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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