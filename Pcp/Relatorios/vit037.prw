/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT037   � Autor � Gardenia              � Data � 07/03/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Relacao de Producao                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


/*
�������������������������������������������������������������������������Ĵ��
���Revisao   � 02/12/05: Alteracao da Mascara do Total Geral (Aumento no   ��
���          �           n� de Digitos.										  ��
���          � 08/12/05: Inclus�o de Totalizador de Producao por Grupo e	  ��	
���          �           Correcoes na Coluna de Quantidade 2a. um          ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
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

user function VIT037()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="RELACAO DE PRODUCAO"
cdesc1   :="Este programa ira emitir a relacao de producao"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT037"
wnrel    :="VIT037"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT037"
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
_cfilsbm:=xfilial("SBM")
sb1->(dbsetorder(1))
sd3->(dbsetorder(1))    
sbm->(dbsetorder(1))    

processa({|| _querys()})
processa({|| _query2()})

cabec1:="Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
cabec2:="  Data        Quantidade UM Ordem de producao Quantidade Seg. UM"

setprc(0,0)

setregua(sd3->(lastrec()))

tmp1->(dbgotop()) 
tmp2->(dbgotop()) 

_totgrupo :={}
_ntotal   :=0
_ntotsegum:=0
_nquant   :=0
_nqtsegum :=0       

while ! tmp2->(eof()) .and.;
		lcontinua
		
   if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
   aadd(_totgrupo,{tmp2->grupo,tmp2->descgru,_ntotal,tmp1->um,_ntotal,tmp1->segum})//aqui
	tmp2->(dbskip())   
end

while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	if (mv_par09 = "N" .and. tmp1->quant >0) .or. mv_par09 ="S"
		@ prow()+2,000 PSAY left(tmp1->produto,10)+" - "+left(tmp1->descri,58)
		@ prow()+1,000 PSAY " "
		_qtsegum:=0
		_nquant  :=0
		_nqtsegum:=0
		_cproduto:=tmp1->produto
		while ! tmp1->(eof()) .and.;
				tmp1->produto==_cproduto .and.;
				lcontinua
			incregua()
			if prow()>53
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
			endif                            
			_qtsegum:=(tmp1->quant*tmp1->conv)
			@ prow()+1,000 PSAY tmp1->emissao
			@ prow(),009   PSAY tmp1->quant   picture "@E 999,999,999.999"
			@ prow(),025   PSAY tmp1->um
			@ prow(),031   PSAY tmp1->op
			@ prow(),046   PSAY _qtsegum picture "@E 999,999,999.999"
			@ prow(),062   PSAY tmp1->segum
			_nquant  +=tmp1->quant
			_nqtsegum+=_qtsegum
			_ntotal  +=tmp1->quant
			_ntotsegum+=_qtsegum 
	
			// Atualiza os totais de produ��o por grupo
			_i:=1
			while (tmp1->grupo<>_totgrupo[_i,1]) .and. lcontinua 
			   if labortprint
				   @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				   lcontinua:=.f.
				endif
				_i++
			end                        
	
			_totgrupo[_i,3]+=tmp1->quant         
			_totgrupo[_i,4]:=tmp1->um
			_totgrupo[_i,5]+=_qtsegum
			_totgrupo[_i,6]:=tmp1->segum
	
			tmp1->(dbskip())
		end
		if lcontinua
			@ prow()+2,000 PSAY "Totais"
			@ prow(),009   PSAY _nquant   picture "@E 9,999,999,999.999"
			@ prow(),046   PSAY _nqtsegum picture "@E 9,999,999,999.999"
			@ prow()+1,000 PSAY replicate("-",limite)
		endif
	else
		tmp1->(dbskip())
	endif

end
if lcontinua
	if prow()>48
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif

	@ prow()+2,000 PSAY "Totais Por Grupo"
	for _i:=1 to len(_totgrupo)
		@ prow()+1,000 PSAY _totgrupo[_i,1]+" - "+left(_totgrupo[_i,2],25)
		@ prow(),034   PSAY _totgrupo[_i,3] picture "@E 999,999,999.999"
		@ prow(),051   PSAY _totgrupo[_i,4]
		@ prow(),055   PSAY _totgrupo[_i,5] picture "@E 9,999,999,999.999"
		@ prow(),073   PSAY _totgrupo[_i,6]
	next

	@ prow()+2,000 PSAY "Tot.Geral"
	@ prow(),012   PSAY _ntotal   picture "@E 9,999,999,999.999"
	@ prow(),049   PSAY _ntotsegum picture "@E 9,999,999,999.999"
	@ prow()+1,000 PSAY replicate("-",limite)
	endif

if prow()>0 .and.;
	lcontinua
   roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())
tmp2->(dbclosearea())

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
_cquery+=" D3_COD PRODUTO,B1_DESC DESCRI,B1_GRUPO GRUPO,D3_EMISSAO EMISSAO,D3_QUANT QUANT,"
_cquery+=" B1_UM UM,D3_OP OP, B1_SEGUM SEGUM, B1_CONV CONV"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SD3")+" SD3"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND D3_COD=B1_COD"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND D3_CF='PR0'"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" ORDER BY B1_DESC,D3_EMISSAO,D3_OP"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","QUANT"  ,"N",15,3)
tcsetfield("TMP1","QTSEGUM","N",15,3)
return

//���������������������������������������������//
//  Captura dos grupos que est�o no par�metro  //
//���������������������������������������������//

static function _query2()
_cquery:=" SELECT"
_cquery+=" B1_GRUPO GRUPO,BM_DESC DESCGRU"
_cquery+=" FROM "
_cquery+=  retsqlname("SBM")+" SBM,"
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SD3")+" SD3"
_cquery+=" WHERE"
_cquery+="     SBM.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND BM_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND BM_GRUPO=B1_GRUPO" 
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND D3_COD=B1_COD"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND D3_CF='PR0'"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" GROUP BY B1_GRUPO,BM_DESC"
_cquery+=" ORDER BY B1_GRUPO,BM_DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP2"
return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Imprime Qtde.zero  ?","mv_ch9","C",01,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})	
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