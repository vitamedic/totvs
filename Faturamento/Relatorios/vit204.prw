/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT204   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Saidas Diversas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterações³ ALEX JÚNIO ³04/09/06: Correções nas grades de demarcação   ³±±
±±³          ³            ³          das colunas.                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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

user function VIT204()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="SAIDAS DIVERSAS DE PRODUTOS"
cdesc1   :="Este programa ira emitir a relacao de saidas diversas  de produtos"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT204"
wnrel    :="VIT204"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT204"
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
_cfilsd2:=xfilial("SD2")
sd2->(dbsetorder(1))

_cfilsa1:=xfilial("SA1")
sa1->(dbsetorder(1))

_cfilsa2:=xfilial("SA2")
sa2->(dbsetorder(1))

_cfilsf4:=xfilial("SF4")
sf4->(dbsetorder(1))

processa({|| _querys()})

cabec1:= "Período:" +dtoc(mv_par01)+" a "+ dtoc(mv_par02)+"                                                                                 Remessa          Venda      Remessa    Remessa    Emprésti.   Venda ativo"
cabec2:="Data NF  Nº NF    CFOP Cliente                                                  Devoluçao   Bonificação     Brinde       Terceiros  Industrial.   conserto    Materias    imobilizado  Faturamento"

//99/99/99 999999-9 99999 999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99  999.999,99 999.999,99 999.999,99  999.999,99 999.999,99 999.999,99   999.999,99
//       999999   99   999.999.999,99    999.999.999,99   999.999.999,99    99/99/99

setprc(0,0)

setregua(sb8->(lastrec()))

tmp1->(dbgotop())
_tdevol:=0
_tbonific:=0
_tbrinde:=0
_tterceiros:=0
_tindust:=0
_tconserto:=0
_temprest:=0
_tativo:=0
_totfat:=0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	while ! tmp1->(eof())
		incregua()
		_emissao:=tmp1->emissao
		while ! tmp1->(eof()) .and.;
			tmp1->emissao==_emissao .and. lcontinua
			_doc:=tmp1->doc
			_serie:=tmp1->serie
			_devol:=0
			_bonific:=0
			_brinde:=0
			_terceiros:=0
			_indust:=0
			_conserto:=0
			_emprest:=0
			_ativo:=0
			if  ! tmp1->cf $ "6915 /5102 /5910 /5556 /5915 /5102 /6201 /5901 /6556 /6102 /6910 /5949 /6553 /5551 /6551 /6901 /5201 /5553 /5902 /5908 /5909 /6916 " 
				sf4->(dbseek(_cfilsf4+tmp1->tes))             
				if sf4->f4_duplic=="S"
					_totfat+=tmp1->total
				endif	
			endif	
			if  ! tmp1->cf $ "6915 /5102 /5910 /5556 /5915 /5102 /6201 /5901 /6556 /6102 /6910 /5949 /6553 /5551 /6551 /6901 /5201 /5553 /5902 /5908 /5909 /6916 " 
				tmp1->(dbskip())
			   loop
			endif   
			while ! tmp1->(eof()) .and.;
				tmp1->emissao==_emissao .and. _doc == tmp1->doc .and.;
				_serie==tmp1->serie .and. lcontinua
				_cfop:=tmp1->cf
				_cliente:=tmp1->cliente
				_loja:=tmp1->loja
				if tmp1->cf $ "5556 /6201 /6556 /6553 /5201 /5553 /5201 "
					_devol+=tmp1->total
				elseif tmp1->cf $"5910 /6910 " .and. (tmp1->tes=="526" .or. tmp1->tes=="597")
					_bonific+=tmp1->total
				elseif tmp1->cf $ "6910 /5910 "
					_brinde+=tmp1->total
				elseif tmp1->cf $ "5102 /6102 "
					_terceiros+=tmp1->total
				elseif tmp1->cf $ "5901 /6901 "
					_indust+=tmp1->total
				elseif tmp1->cf $ "6915 /5915 /6916 "
					_conserto+=tmp1->total
				elseif tmp1->cf $ "5949 /6949 "
					_emprest+=tmp1->total
				elseif tmp1->cf $ "5551 /6551 "
					_ativo+=tmp1->total
				endif							
				tmp1->(dbskip())
			end
//+----------------------------------------------------------------------------- +-----------+------------+------------+------------+------------+------------+------------+------------+
//|99/99/99 999999-999 99999 999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  |999.999,99 | 999.999,99 | 999.999,99 | 999.999,99 | 999.999,99 | 999.999,99 | 999.999,99 | 999.999,99 |

			@ prow()+1,000 PSAY "+----------------------------------------------------------------------------- +-----------+------------+------------+------------+------------+------------+------------+------------+-----------+"
			@ PROW()+1,000 PSAY "|"
	      @ prow(),001 PSAY _emissao
			@ prow(),010   PSAY _doc+"-"+_serie 
			@ prow(),021   PSAY _cfop   
			@ prow(),027   PSAY _cliente+"-"+_loja 
			sa1->(dbseek(_cfilsa1+_cliente+_loja))             
			_nomecli:=sa1->a1_nome	
			if !found() .and. empty(_nomecli)
				sa2->(dbseek(_cfilsa2+_cliente+_loja))             
				_nomecli:=sa2->a2_nome	
			endif	
         @ prow(),037 PSAY substr(_nomecli,1,35)
			@ prow(),79 PSAY "|"
			if !empty(_devol)
				@ prow(),080   PSAY _devol picture "@E 999,999.99"
				_tdevol+=_devol	
			endif
			@ prow(),91 PSAY "|"
			if !empty(_bonific)	
				@ prow(),093   PSAY _bonific picture "@E 999,999.99"
				_tbonific+=_bonific
	      endif
			@ prow(),104 PSAY "|"
			if !empty(_brinde)	
				@ prow(),106   PSAY _brinde picture "@E 999,999.99"
				_tbrinde+=_brinde
	      endif
			@ prow(),117 PSAY "|"
			if !empty(_terceiros)	
				@ prow(),119   PSAY _terceiros picture "@E 999,999.99"
				_tterceiros+=_terceiros
	      endif
			@ prow(),130 PSAY "|"
			if !empty(_indust)	
				@ prow(),132   PSAY _indust picture "@E 999,999.99"
				_tindust+=_indust
	      endif
			@ prow(),143 PSAY "|"
			if !empty(_conserto)	
				@ prow(),145   PSAY _conserto picture "@E 999,999.99"
				_tconserto+=_conserto
	      endif
			@ prow(),156 PSAY "|"
			if !empty(_emprest)	
				@ prow(),158   PSAY _emprest picture "@E 999,999.99"
				_temprest+=_emprest
	      endif
			@ prow(),169 PSAY "|"
			if !empty(_ativo)	
				@ prow(),171   PSAY _ativo picture "@E 999,999.99"
				_tativo+=_ativo
	      endif
			@ prow(),182 PSAY "|"
			@ prow(),194 PSAY "|"
			if prow()>53
				@ prow()+1,000 PSAY "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
			endif
		end
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
//99/99/99 999999-9 9999 999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99  999.999,99 999.999,99 999.999,99  999.999,99 999.999,99 999.999,99   999.999,99
	end                      
	@ prow()+1,000 PSAY "+----------------------------------------------------------------------------- +-----------+------------+------------+------------+------------+------------+------------+------------+-----------+"
	@ prow()+1,00 PSAY "| Totais ================>"
	@ prow(),79 PSAY "|"
	if !empty(_tdevol)
		@ prow(),080   PSAY _tdevol picture "@E 999,999.99"
	endif
	@ prow(),91 PSAY "|"
	if !empty(_tbonific)	
		@ prow(),093   PSAY _tbonific picture "@E 999,999.99"
   endif
	@ prow(),104 PSAY "|"
	if !empty(_tbrinde)	
		@ prow(),106   PSAY _tbrinde picture "@E 999,999.99"
	endif
	@ prow(),117 PSAY "|"
	if !empty(_tterceiros)	
		@ prow(),119   PSAY _tterceiros picture "@E 999,999.99"
	endif
	@ prow(),130 PSAY "|"
	if !empty(_tindust)	
		@ prow(),132   PSAY _tindust picture "@E 999,999.99"
	endif
	@ prow(),143 PSAY "|"
	if !empty(_tconserto)	
		@ prow(),145   PSAY _tconserto picture "@E 999,999.99"
   endif
	@ prow(),156 PSAY "|"
	if !empty(_temprest)	
		@ prow(),158   PSAY _temprest picture "@E 999,999.99"
   endif
	@ prow(),169 PSAY "|"
	if !empty(_tativo)	
		@ prow(),171   PSAY _tativo picture "@E 999,999.99"
   endif
	@ prow(),182 PSAY "|"
//	@ prow()+1,00 PSAY "Total saidas extras  ==>"
	@ prow(),184  PSAY _tdevol+_tbonific+_tbrinde+_tterceiros+_tindust+_tconserto+_temprest+_tativo picture "@E 999,999.99|"
   @ prow()+1,000 PSAY "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
	@ prow()+1,000 PSAY "| Total Faturamento    ==>"
	@ prow(),183  PSAY _totfat picture "@E 9999,999.99|"
	@ prow()+1,000 PSAY "| Total Geral          ==>"
	@ prow(),183  PSAY _tdevol+_tbonific+_tbrinde+_tterceiros+_tindust+_tconserto+_temprest+_tativo+_totfat picture "@E 9999,999.99|"
end
@ prow()+1,000 PSAY "+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"

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
_cquery+=" D2_EMISSAO EMISSAO,D2_DOC DOC,D2_SERIE SERIE,D2_TES TES,D2_CF CF,"
_cquery+=" D2_CLIENTE CLIENTE,D2_LOJA LOJA,D2_TOTAL TOTAL"
_cquery+=" FROM "
_cquery+=  retsqlname("SD2")+" SD2"
_cquery+=" WHERE"
_cquery+="     SD2.D_E_L_E_T_<>'*'"
_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" ORDER BY D2_EMISSAO,D2_DOC,D2_CLIENTE,D2_CF"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","TOTAL"  ,"N",15,3)

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
*/