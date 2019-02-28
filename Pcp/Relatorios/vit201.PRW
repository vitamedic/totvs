/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT201   ³Autor ³ Aline B. Pereira      ³Data ³ 09/05/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento de Producao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "topconn.ch"
#include "rwmake.ch"

user function vit201()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="ACOMPANHAMENTO DE PRODUCAO"
cdesc1   :="Este programa ira emitir o relatorio de acompanhamento das metas por vendedor"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT201"
wnrel    :="VIT201"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT201"
_pergsx1()
pergunte(cperg,.f.)
if mv_par05=="2"
  if sm0->m0_codigo<>"02" .or.;
     (upper(alltrim(getenvserver()))<>"BACKUP" .and. upper(alltrim(getenvserver()))<>"BKP")
	     msgstop("Programa não habilitado para esta filial!")			
	     return
  endif
  if tclink("oracle/dadosadv","192.168.1.20")<>0
	  msgstop("Falha de conexao com o banco!")
	  tcquit()
	  return
  endif
endif
wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   if mv_par05=="2"
		tcquit()
	endif	
   return
endif

setdefault(areturn,cstring)

ntipo:=18

if nlastkey==27
   set filter to
   if mv_par05=="2"
   	tcquit()
   endif 	
   return
endif
rptstatus({|| rptdetail()})
if mv_par05=="2"
  tcquit()
endif  
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsct:=xfilial("SCT")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")
_cfilsf4:=xfilial("SF4")
_cfilsbm:=xfilial("SBM")
_cfilsd5:=xfilial("SD5")

sb1->(dbsetorder(1))
sd5->(dbsetorder(1))
sc6->(dbsetorder(1))
sct->(dbsetorder(1))
sd2->(dbsetorder(5))
sf2->(dbsetorder(1))
sf4->(dbsetorder(1))
sbm->(dbsetorder(1))
if mv_par05=="2"
_abretop("SD2010",5)
_abretop("SF2010",1)
_abretop("SF4010",1)
endif
_nmetqtd1:=0
_npedqtd1:=0
_nfatqtd1:=0
_nmetqtd2:=0
_npedqtd2:=0
_nfatqtd2:=0
_nmetqtd3:=0
_npedqtd3:=0
_nfatqtd3:=0
_ntotped :=0
_ntotfat :=0
_ntotsgp :=0
_ntotsgf :=0
_nprqtd1 :=0
_ntotpro :=0
_nprqtd2 :=0
_ntotpr2 :=0
_nprqtd3 :=0
_ntotpr3 :=0

_carqtmp1:=""
_cindtmp1:=""
_carqtmp2:=""
_cindtmp2:=""
_carqtmp3:=""
_cindtmp3:=""
_carqtmp4:=""
_cindtmp4:=""

cabec1:="                                                  PERIODO DE "+dtoc(MV_PAR01)+" A "+dtoc(MV_PAR02)
cabec2:="CODIGO DESCRICAO                         META    (Pr)    %    Unidades   (Pd)    %       (F)     %     "
processa({|| _geratmp2()})

_smtp := "  "	
_sbmt := "      "
_ntmp1:=0
_ntmp2:=0
_ntmp3:=0			  
_ntmp4:=0
_ntmp5:=0
_ntmp6:=0		
_ntmp7:=0		
_ntmp8:=0			  	  
_ntmp9:=0			  	  
_ntmpA:=0			  	  
_ntmpB:=0			  	  
_ntmpC:=0			  	  
_ttmp1:=0
_ttmp2:=0
_ttmp3:=0			  
_ttmp4:=0
_ttmp5:=0
_ttmp6:=0		
_ttmp7:=0		
_ttmp8:=0			  	  
_ttmp9:=0			  	  
_ttmpA:=0			  	  
_ttmpB:=0			  	  
_ttmpC:=0			  	  
_nunid := 0 
setprc(0,0)
setregua(tmp1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
  	   lcontinua
		if prow()==0 .or. prow()>50 //.or. mv_par10==1
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                         
		incregua()
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                                
		sb1->(dbseek(_cfilsb1+tmp1->produto))
		sct->(dbseek(_cfilsct+tmp1->produto))
		_nregsb1:=sb1->(recno())
  	   sbm->(dbseek(_cfilsbm+sb1->b1_grupo))
	   if _smtp <> sbm->bm_tipgru 
     		_smtp := sbm->bm_tipgru   		
			_totsbm()
		endif
		sb1->(dbgoto(_nregsb1))
		_ntotped :=0
		_ntotfat :=0
		if mv_par06==1 .and. !empty(tmp2->quant+tmp3->quant)
			@ prow()+1,000 PSAY left(tmp1->produto,6)
			@ prow(),008 PSAY substr(sb1->b1_desc,1,40)		
	 		if tmp2->(dbseek(tmp1->produto))
				@ prow(),050 PSAY tmp2->quant picture "@E 999,999,999"
				@ prow(),062 PSAY tmp2->quant*sb1->b1_conv picture "@E 999,999,999.99"
			endif	                          
	 		if tmp2->(dbseek(tmp1->produto))
				@ prow(),077 PSAY tmp3->quant picture "@E 999,999,999"
			endif	
	 		if tmp2->(dbseek(tmp1->produto))	
				@ prow(),090 PSAY tmp4->quant picture "@E 999,999,999"
			endif	
      endif
	   _nprqtd1+=tmp2->quant
		_ntotpro+=tmp3->quant
		_ntmpa += tmp4->quant			
		_ttmpa+=tmp4->quant
 		_nunid += tmp2->quant*sb1->b1_conv
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
end
if prow()>0 .and.;
	lcontinua
	_totsbm()
endif	
roda()
_cindtmp1+=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp1)

_cindtmp2+=tmp2->(ordbagext())
tmp2->(dbclosearea())
ferase(_carqtmp2+getdbextension())
ferase(_cindtmp2)

_cindtmp3+=tmp3->(ordbagext())
tmp3->(dbclosearea())
ferase(_carqtmp3+getdbextension())
ferase(_cindtmp3)

_cindtmp4+=tmp4->(ordbagext())
tmp4->(dbclosearea())
ferase(_carqtmp4+getdbextension())
ferase(_cindtmp4)

if mv_par05=="2"
  sd2010->(dbclosearea())
  sf2010->(dbclosearea())
  sf4010->(dbclosearea())
endif           
set device to screen
if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endif

ms_flush()
return

// p/ industria
static function _geratmp2()
procregua(12)
	incproc("Selecionando produtos...")
	_cquery:=" SELECT"
	_cquery+=" B1_COD PRODUTO"
	_cquery+=" FROM "
   _cquery+=  retsqlname("SB1")+" SB1,"
	_cquery+=  retsqlname("SBM")+" SBM"
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"
	_cquery+=" AND B1_GRUPO=BM_GRUPO"
	_cquery+=" AND B1_TIPO='PA'" 
	_cquery+=" ORDER BY BM_TIPGRU,B1_DESC,B1_COD"
	
	_cquery:=changequery(_cquery)      
	tcquery _cquery new alias "TMP1"
	
//cria indice para tmp4 - faturamento
_aestrut:={}
aadd(_aestrut,{"PRODUTO" ,"C",15,0})
aadd(_aestrut,{"QUANT"   ,"N",18,2})

_carqtmp4:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp4,"TMP4",.f.,.f.)
_cindtmp4:=criatrab(,.f.)
_cchave  :="PRODUTO"
tmp4->(indregua("TMP4",_cindtmp4,_cchave,,,"Selecionando registros..."))


//
	_ddataini:= mv_par01
	_ddatafim:= mv_par02
//
			// ENTRADA NO MES      
	incproc("Calculando Produções...")			
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT,B1_COD PRODUTO"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5,"    
	_cquery+=  retsqlname("SB1")+" SB1"     
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND D5_PRODUTO=B1_COD"
	_cquery+=" AND D5_LOCAL=B1_LOCPAD"
	_cquery+=" AND D5_ORIGLAN<'500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
	_cquery+=" AND D5_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"		
	_cquery+=" GROUP BY"
	_cquery+=" B1_COD"
	_cquery+=" ORDER BY"
	_cquery+=" B1_COD"

	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",12,0)
	_carqtmp2:=criatrab(,.f.)
	copy to &_carqtmp2
	tmp2->(dbclosearea())
	
	dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
	_cindtmp2:=criatrab(,.f.)
	_cchave  :="PRODUTO"
	tmp2->(indregua("TMP2",_cindtmp2,_cchave,,,"Selecionando registros..."))
//
	incproc("Calculando pedidos...")
	_cquery:=" SELECT"
	_cquery+=" C6_PRODUTO PRODUTO,"
	_cquery+=" SUM(C6_QTDVEN) QUANT,' ' D_E_L_E_T_"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC5")+" SC5,"
	_cquery+=  retsqlname("SC6")+" SC6,"
	_cquery+=  retsqlname("SF4")+" SF4"
	_cquery+=" WHERE"
	_cquery+="     SC5.D_E_L_E_T_<>'*'"
	_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
	_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
	_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
	_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
	_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
	_cquery+=" AND C6_NUM=C5_NUM"
	_cquery+=" AND C6_TES=F4_CODIGO"
	_cquery+=" AND F4_DUPLIC='S'"
	_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
	_cquery+=" AND C6_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" GROUP BY"
	_cquery+=" C6_PRODUTO"
	_cquery+=" ORDER BY"
	_cquery+=" C6_PRODUTO"

	tcquery _cquery new alias "TMP3"
	tcsetfield("TMP3","QUANT","N",12,0)
	
	_carqtmp3:=criatrab(,.f.)
	copy to &_carqtmp3
	tmp3->(dbclosearea())
	
	dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)
	_cindtmp3:=criatrab(,.f.)
	_cchave  :="PRODUTO"
	tmp3->(indregua("TMP3",_cindtmp3,_cchave,,,"Selecionando registros..."))
   if mv_par05 == "2"
   	incproc("Calculando faturamento...")
		sd2010->(dbseek(_cfilsd2+dtos(_ddataini),.t.))
		while ! sd2010->(eof()) .and.;
			sd2010->d2_filial==_cfilsd2 .and.;
			sd2010->d2_emissao<=_ddatafim
		if sd2010->d2_cod>=mv_par03 .and.;
			sd2010->d2_cod<=mv_par04
			sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
			if sf4010->f4_duplic=="S"
				sf2010->(dbseek(_cfilsf2+sd2010->d2_doc+sd2010->d2_serie))
						if tmp4->(dbseek(sd2010->d2_cod))
							tmp4->quant+=sd2010->d2_quant
						else
							tmp4->(dbappend())
							tmp4->produto :=sd2010->d2_cod
							tmp4->quant   :=sd2010->d2_quant
						endif
			endif
		endif
		sd2010->(dbskip())
	end
	endif
	incproc("Calculando faturamento...")
	sd2->(dbseek(_cfilsd2+dtos(_ddataini),.t.))
	while ! sd2->(eof()) .and.;
			sd2->d2_filial==_cfilsd2 .and.;
			sd2->d2_emissao<=_ddatafim
		if sd2->d2_cod>=mv_par03 .and.;
			sd2->d2_cod<=mv_par04
			sf4->(dbseek(_cfilsf4+sd2->d2_tes))
			if sf4->f4_duplic=="S"
				sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
						if tmp4->(dbseek(sd2->d2_cod))
							tmp4->quant+=sd2->d2_quant
						else
							tmp4->(dbappend())
							tmp4->produto :=sd2->d2_cod
							tmp4->quant   :=sd2->d2_quant
						endif

			endif
		endif
		sd2->(dbskip())
	end
return

//
static function _abretop(_carq,_nordem)
_calias:=left(_carq,3)
dbusearea(.t.,"TOPCONN",_carq,_carq,.t.,.f.)
six->(dbseek(_calias))
while ! six->(eof()) .and.;
		six->indice==_calias
	dbsetindex(_carq+six->ordem)
	six->(dbskip())
end
dbsetorder(_nordem)
return

static function _totsbm()
  if !empty(_ntmp5+_ntmp6)  
  	  @ prow()+1,000 PSAY "TOTAL DA LINHA "+tabela("V0",_sbmt+"    ")
/*	  @ prow(),036   PSAY _ntmp1 picture "@E 9999,999"
	  @ prow(),045   PSAY _ntmp2 picture "@E 9999,999"					
	  @ prow(),054   PSAY (_ntmp2/_ntmp4)*100 picture "@E 999.99"					
	  @ prow(),061   PSAY _ntmp3 picture "@E 9999,999"                   
	  @ prow(),070   PSAY (_ntmp3/_ntmp4)*100 picture "@E 999.99"						  
	  @ prow(),076   PSAY _ntmp4 picture "@E 9999,999"
	  @ prow(),085   PSAY (_ntmp6/_ntmp4)*100 picture "@E 999.99"
	  @ prow(),092   PSAY _ntmp7  picture "@E 9999,999"
	  @ prow(),101   PSAY _ntmpB picture "@E  9999,999"
	  @ prow(),110   PSAY (_ntmpB/_ntmp7)*100 picture "@E 999.99"
	  @ prow(),117   PSAY _ntmp8 picture "@E 9999,999"	//
	  @ prow(),126   PSAY (_ntmp8/_ntmp7)*100 picture "@E 999.99"	
	  @ prow(),133   PSAY _ntmp9 picture "@E 9999,999"	
	  @ prow(),142   PSAY (_ntmp9/_ntmp7)*100 picture "@E 999.99"	
	  @ prow(),149   PSAY _ntmp1 picture "@E 9999,999"	
	  @ prow(),159   PSAY _ntmpC picture "@E 9999,999"	         
	  @ prow(),168   PSAY (_ntmpC/_ntmp1)*100 picture "@E 999.99"		  
	  @ prow(),175   PSAY _ntmp2 picture "@E 9999,999"	
	  @ prow(),184   PSAY (_ntmp2/_ntmp1)*100 picture "@E 999.99"	
	  @ prow(),191   PSAY _ntmp3 picture "@E 9999,999"	
	  @ prow(),200   PSAY (_ntmp3/_ntmp1)*100 picture "@E 999.99"	
	  @ prow(),209   PSAY ((_ntmpA+_ntmpB+_ntmpC)/(_ntmp4+_ntmp7+_ntmp1))*100 picture "@E 999.99"	*/
	  @ prow()+1,000 PSAY " "
	  _ntmp1:=0
	  _ntmp2:=0
	  _ntmp3:=0			  
	  _ntmp4:=0
	  _ntmp5:=0
	  _ntmp6:=0		
	  _ntmp7:=0		
	  _ntmp8:=0			  	  
	  _ntmp9:=0			  	  
	  _ntmpA:=0			  	  
	  _ntmpB:=0			  	  
	  _ntmpC:=0			  	  
  endif	
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Grade              ?","mv_ch5","C",01,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Tipo               ?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,"1-Analitico"    ,space(30),space(15),"2-Sintetico"    ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
UF
DESCRICAO                                         99/99 A 99/99   99/99 A 99/99   99/99 A 99/99   99/99 A 99/99   99/99 A 99/99   99/99 A 99/99   % Est   %Ger
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.9999.999,99 999.9999.999,99 999.9999.999,99 999.9999.999,99 999.9999.999,99 999.9999.999,99  999,99 999,99
TOTAL UF                                        999.9999.999,99 999.9999.999,99 999.9999.999,99 999.9999.999,99 999.9999.999,99 999.9999.999,99  999,99 999,99
*/
