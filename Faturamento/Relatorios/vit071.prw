/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT071   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 24/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento das Metas por Vendedor                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit071()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="ACOMPANHAMENTO DAS METAS POR VENDEDOR"
cdesc1   :="Este programa ira emitir o relatorio de acompanhamento das metas por vendedor"
cdesc2   :=""
cdesc3   :=""
cstring  :="SCT"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT071"
wnrel    :="VIT071"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT071"
_pergsx1()
pergunte(cperg,.f.)
if mv_par12=="2"
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
   if mv_par12=="2"
		tcquit()
	endif	
   return
endif

setdefault(areturn,cstring)

ntipo:=18

if nlastkey==27
   set filter to
   if mv_par12=="2"
   	tcquit()
   endif 	
   return
endif
rptstatus({|| rptdetail()})
if mv_par12=="2"
  tcquit()
endif  
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

_cfilsa3:=xfilial("SA3")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsct:=xfilial("SCT")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")
_cfilsf4:=xfilial("SF4")
_cfilsbm:=xfilial("SBM")
_cfilsd5:=xfilial("SD5")
_cfilsd3:=xfilial("SD3")
sa3->(dbsetorder(1))
sb1->(dbsetorder(1))
sd5->(dbsetorder(1))
sd3->(dbsetorder(1))
sc6->(dbsetorder(1))
sct->(dbsetorder(1))
sd2->(dbsetorder(5))
sf2->(dbsetorder(1))
sf4->(dbsetorder(1))
sbm->(dbsetorder(1))
if mv_par12=="2"
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
//
_1metqtd1:=0
_1pedqtd1:=0
_1fatqtd1:=0
_1metqtd2:=0
_1pedqtd2:=0
_1fatqtd2:=0
_1metqtd3:=0
_1pedqtd3:=0
_1fatqtd3:=0
_1totped :=0
_1totfat :=0
_1totsgp :=0
_1totsgf :=0
_1prqtd1 :=0
_1totpro :=0
_1prqtd2 :=0
_1totpr2 :=0
_1prqtd3 :=0
_1totpr3 :=0
//
_carqtmp12:=""
_cindtmp12:=""
_carqtmp2:=""
_cindtmp2:=""
_carqtmp3:=""
_cindtmp3:=""
_carqtmp4:=""
_cindtmp4:=""
_carqtmp5:=""
_cindtmp5:=""
_carqtmp6:=""
_cindtmp6:=""
_carqtmp7:=""
_cindtmp7:=""
_carqtmp8:=""
_cindtmp8:=""
_carqtmp9:=""
_cindtmp9:=""


_ndiaini:=day(mv_par01)
_ndiafim:=day(mv_par02)
_nmesini:=month(mv_par01)
_nmesfim:=month(mv_par02)
_nanoini:=year(mv_par01)
_nanofim:=year(mv_par02)
if _nmesini>2
	_nmesini1:=_nmesini-2
	_nmesini2:=_nmesini-1
	_nanoini1:=_nanoini
	_nanoini2:=_nanoini
elseif _nmesini==2
	_nmesini1:=12
	_nmesini2:=_nmesini-1
	_nanoini1:=_nanoini-1
	_nanoini2:=_nanoini
else
	_nmesini1:=11
	_nmesini2:=12
	_nanoini1:=_nanoini-1
	_nanoini2:=_nanoini-1
endif
if _nmesfim>2
	_nmesfim1:=_nmesfim-2
	_nmesfim2:=_nmesfim-1
	_nanofim1:=_nanofim
	_nanofim2:=_nanofim
elseif _nmesfim==2
	_nmesfim1:=12
	_nmesfim2:=_nmesfim-1
	_nanofim1:=_nanofim-1
	_nanofim2:=_nanofim
else
	_nmesfim1:=11
	_nmesfim2:=12
	_nanofim1:=_nanofim-1
	_nanofim2:=_nanofim-1
endif  

_ddataini1:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini1,2)+"/"+strzero(_nanoini1,4))
if _ndiaini==1
	_ddatafim1:=lastday(_ddataini1)
else
	_ddatafim1:=ctod(strzero(_ndiafim,2)+"/"+strzero(_nmesfim1,2)+"/"+strzero(_nanofim1,4))
endif
_ddataini2:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini2,2)+"/"+strzero(_nanoini2,4))
if _ndiaini==1
	_ddatafim2:=lastday(_ddataini2)
else
	_ddatafim2:=ctod(strzero(_ndiafim,2)+"/"+strzero(_nmesfim2,2)+"/"+strzero(_nanofim2,4))
endif  

if mv_par13<>1
	cabec1:="                                                  PERIODO DE "+dtoc(_ddataini1)+" A "+dtoc(_ddatafim1)+"                   PERIODO DE "+dtoc(_ddataini2)+" A "+dtoc(_ddatafim2)+"                       PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)+"     
	cabec2:="CODIGO DESCRICAO                         META    (Pr)    %       (Pd)    %       (F)     %     META      (Pr)    %       (Pd)   %       (F)     %       META      (Pr)    %      (Pd)     %      (F)      %        M3"
	processa({|| _geratmp2()})
else
	cabec1:="                                                     PERIODO DE "+dtoc(_ddataini1)+" A "+dtoc(_ddatafim1)+"          PERIODO DE "+dtoc(_ddataini2)+" A "+dtoc(_ddatafim2)+"          PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)+"     MEDIA   MEDIA   META SUGERIDA(P) META SUGERIDA(F)"
	cabec2:="CODIGO DESCRICAO                                   META      (P)     %       (F)     %     META      (P)     %       (F)     %     META      (P)     %       (F)      %     (P)     (F)  (+ "+transform(mv_par11,"@E 999.99%")+")      (+ "+transform(mv_par11,"@E 999.99%")+")"
	processa({|| _geratmp()})
endif	
if mv_par13 <>1  // relatorio p/ producao                
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
	  
	setprc(0,0)
	setregua(tmpf->(lastrec()))
	tmpf->(dbgotop())
	while ! tmpf->(eof()) .and.;
   	   lcontinua
		if prow()==0 .or. prow()>50 //.or. mv_par10==1
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                         
		incregua()
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif                                
		sb1->(dbseek(_cfilsb1+tmpf->produto))
		sct->(dbseek(_cfilsct+tmpf->produto))
		_nregsb1:=sb1->(recno())
		if mv_par13=2		
	  	   sbm->(dbseek(_cfilsbm+sb1->b1_grupo))
		   if _smtp <> sbm->bm_tipgru 
	     		_smtp := sbm->bm_tipgru   		
				_totsbm()
			endif
		else
		   if _smtp <> sb1->b1_apreven
	     		_smtp := sb1->b1_apreven
				_totsbm()
			endif			
		endif	
		sb1->(dbgoto(_nregsb1))
		_ntotped :=0
		_ntotfat :=0
		@ prow()+1,000 PSAY left(tmpf->produto,6)
		@ prow(),008   PSAY substr(sb1->b1_desc,1,28)		
		if tmp4->(dbseek(tmpf->produto))
			@ prow(),038 PSAY tmp4->quant picture "@E 999,999"
			_nmetqtd1+=tmp4->quant
			_ntmp4+=tmp4->quant
 			_ttmp4+=tmp4->quant
		endif
		if tmpA->(dbseek(tmpf->produto))
			@ prow(),046 PSAY tmpA->quant picture "@E 999,999"
			@ prow(),054 PSAY (tmpA->quant/tmp4->quant)*100 picture "@E 999.99"
			_nprqtd1+=tmpA->quant
			_ntotpro+=tmpA->quant
			_ntmpa += tmpA->quant			
 			_ttmpa+=tmpA->quant
		endif
		if tmp5->(dbseek(tmpf->produto))
			@ prow(),062 PSAY tmp5->quant picture "@E 999,999"
			@ prow(),070 PSAY (tmp5->quant/tmp4->quant)*100 picture "@E 999.99"
			_npedqtd1+=tmp5->quant
			_ntotped+=tmp5->quant
			_ntmp5 +=tmp5->quant
 			_ttmp5+=tmp5->quant
		endif
		if tmp6->(dbseek(tmpf->produto))
			@ prow(),078 PSAY tmp6->quant picture "@E 999,999"
			@ prow(),086 PSAY (tmp6->quant/tmp4->quant)*100 picture "@E 999.99"
			_nfatqtd1+=tmp6->quant
			_ntotfat+=tmp6->quant
			_ntmp6 +=tmp6->quant
 			_ttmp6+=tmp6->quant			
		endif	
		if tmp7->(dbseek(tmpf->produto))
			@ prow(),094 PSAY tmp7->quant picture "@E 999,999"
			_nmetqtd2+=tmp7->quant
			_ntmp7 +=tmp7->quant			
 			_ttmp7+=tmp7->quant			
		endif
		if tmpB->(dbseek(tmpf->produto))
			@ prow(),102 PSAY tmpB->quant picture "@E 999,999"
			@ prow(),110 PSAY (tmpB->quant/tmp7->quant)*100 picture "@E 999.99"
			_nprqtd2+=tmpB->quant
			_ntotpr2+=tmpB->quant
			_ntmpB +=tmpB->quant			
 			_ttmpB+=tmpb->quant			
		endif
		if tmp8->(dbseek(tmpf->produto))
			@ prow(),118 PSAY tmp8->quant picture "@E 999,999"
			@ prow(),126 PSAY (tmp8->quant/tmp7->quant)*100 picture "@E 999.99"
			_npedqtd2+=tmp8->quant
			_ntotped+=tmp8->quant
			_ntmp8 +=tmp8->quant			
 			_ttmp8+=tmp8->quant			
		endif
		if tmp9->(dbseek(tmpf->produto))
			@ prow(),134 PSAY tmp9->quant picture "@E 999,999"
			@ prow(),142 PSAY (tmp9->quant/tmp7->quant)*100 picture "@E 999.99"
			_nfatqtd2+=tmp9->quant
			_ntotfat+=tmp9->quant
			_ntmp9 +=tmp9->quant			
 			_ttmp9+=tmp9->quant			
		endif	
		if tmp1->(dbseek(tmpf->produto))
			@ prow(),149 PSAY tmp1->quant picture "@E 999,999"
			_nmetqtd1+=tmp1->quant
			_ntmp1 +=tmp1->quant			
 			_ttmp1+=tmp1->quant			
		endif
		if tmpC->(dbseek(tmpf->produto))
			@ prow(),159 PSAY tmpC->quant picture "@E 999,999"
			@ prow(),168 PSAY (tmpC->quant/tmp1->quant)*100 picture "@E 999.99"
 			_nprqtd3+=tmpC->quant
			_ntotpr3+=tmpC->quant
			_ntmpC +=tmpC->quant			
 			_ttmpc+=tmpc->quant			
		endif
		if tmp2->(dbseek(tmp1->produto))
			@ prow(),175 PSAY tmp2->quant picture "@E 999,999"
			@ prow(),184 PSAY (tmp2->quant/tmp1->quant)*100 picture "@E 999.99"
			_npedqtd3+=tmp2->quant
			_ntotped+=tmp2->quant
			_ntmp2 +=tmp2->quant			
 			_ttmp2+=tmp2->quant			
		endif
		if tmp3->(dbseek(tmp1->produto))
			@ prow(),191 PSAY tmp3->quant picture "@E 999,999"
			@ prow(),200 PSAY (tmp3->quant/tmp1->quant)*100 picture "@E 999.99"
			_nfatqtd3+=tmp3->quant
			_ntotfat+=tmp3->quant
			_ntmp3 +=tmp3->quant
 			_ttmp3+=tmp3->quant			
		endif
  		@ prow(),209   PSAY ((tmpa->quant+tmpb->quant+tmpc->quant)/(tmp4->quant+tmp7->quant+tmp1->quant))*100 picture "@E 999.99"		
		tmpf->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
endif             
if prow()>0 .and.;
	lcontinua
	_totsbm()
endif	
if prow()>0 .and.;
	lcontinua
	@ prow()+1,000 PSAY replicate("-",limite)	
	@ prow()+1,000 PSAY "TOTAL"
//
  	  @ prow(),036   PSAY _ttmp4 picture "@E 9999,999"
	  @ prow(),045   PSAY _ttmpA picture "@E 9999,999"					
	  @ prow(),054   PSAY (_ttmpA/_ttmp4)*100 picture "@E 999.99"					
	  @ prow(),061   PSAY _ttmp5 picture "@E 9999,999"                   
	  @ prow(),070   PSAY (_ttmp5/_ttmp4)*100 picture "@E 999.99"						  
	  @ prow(),076   PSAY _ttmp6 picture "@E 9999,999"
	  @ prow(),085   PSAY (_ttmp6/_ttmp4)*100 picture "@E 999.99"
	  @ prow(),092   PSAY _ttmp7  picture "@E 9999,999"
	  @ prow(),101   PSAY _ttmpB picture "@E  9999,999"
	  @ prow(),110   PSAY (_ttmpB/_ttmp7)*100 picture "@E 999.99"
	  @ prow(),117   PSAY _ttmp8 picture "@E 9999,999"	//
	  @ prow(),126   PSAY (_ttmp8/_ttmp7)*100 picture "@E 999.99"	
	  @ prow(),133   PSAY _ttmp9 picture "@E 9999,999"	
	  @ prow(),142   PSAY (_ttmp9/_ttmp7)*100 picture "@E 999.99"	
	  @ prow(),149   PSAY _ttmp1 picture "@E 9999,999"	
	  @ prow(),159   PSAY _ttmpC picture "@E 9999,999"	         
	  @ prow(),168   PSAY (_ttmpC/_ttmp1)*100 picture "@E 999.99"		  
	  @ prow(),175   PSAY _ttmp2 picture "@E 9999,999"	
	  @ prow(),184   PSAY (_ttmp2/_ttmp1)*100 picture "@E 999.99"	
	  @ prow(),191   PSAY _ttmp3 picture "@E 9999,999"	
	  @ prow(),200   PSAY (_ttmp3/_ttmp1)*100 picture "@E 999.99"	
	  @ prow(),209   PSAY ((_ttmpA+_ttmpB+_ttmpC)/(_ttmp4+_ttmp7+_ttmp1))*100 picture "@E 999.99"	
	  @ prow()+1,000 PSAY " "
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
	
//  
	roda(cbcont,cbtxt)
else // relatorio p/ Dir. comercial
_cvend :="   "
setprc(0,0)  
_mtp:=""
setregua(tmp1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>50 .or. mv_par10==1
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                                     
	_cvend:=tmp1->vendedor
	_mtp := tmp1->apres
	sa3->(dbseek(_cfilsa3+_cvend))
	@ prow()+2,000 PSAY "VENDEDOR: "+_cvend+" - "+sa3->a3_nome
	while ! tmp1->(eof()) .and.;
			tmp1->vendedor==_cvend .and.;
			lcontinua
		incregua()
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		//
	   if _mtp <> tmp1->apres 
     		_mtp := tmp1->apres
     		
			@ prow()+1,000 PSAY "TOTAL LINHA:"
			@ prow(),048   PSAY _1metqtd1 picture "@E 9999999"
			if _1pedqtd1>0
				@ prow(),056 PSAY _1pedqtd1 picture "@E 9999999"
				@ prow(),064 PSAY (_1pedqtd1/_1metqtd1)*100 picture "@E 9999.9"
			endif
			if _1fatqtd1>0
				@ prow(),072 PSAY _1fatqtd1 picture "@E 9999999"
				@ prow(),080 PSAY (_1fatqtd1/_1metqtd1)*100 picture "@E 9999.9"
			endif
			@ prow(),088   PSAY _1metqtd2 picture "@E 9999999"
			if _1pedqtd2>0
				@ prow(),096 PSAY _1pedqtd2 picture "@E 9999999"
				@ prow(),104 PSAY (_1pedqtd2/_1metqtd2)*100 picture "@E 9999.9"
			endif
			if _1fatqtd2>0
				@ prow(),112 PSAY _1fatqtd2 picture "@E 9999999"
				@ prow(),120 PSAY (_1fatqtd2/_1metqtd2)*100 picture "@E 9999.9"
			endif
			@ prow(),128   PSAY _1metqtd3 picture "@E 9999999"
			if _1pedqtd3>0
				@ prow(),136 PSAY _1pedqtd3 picture "@E 9999999"
				@ prow(),144 PSAY (_1pedqtd3/_1metqtd3)*100 picture "@E 9999.9"
			endif
			if _1fatqtd3>0
				@ prow(),152 PSAY _1fatqtd3 picture "@E 9999999"
				@ prow(),160 PSAY (_1fatqtd3/_1metqtd3)*100 picture "@E 9999.9"
			endif
			@ prow(),186 PSAY _1totsgp picture "@E 9999,999"
		   @ prow(),203 PSAY _1totsgf picture "@E 9999,999"    	  		
  			@ prow()+1,000 PSAY ""
			_1metqtd1:=0
			_1pedqtd1:=0
			_1fatqtd1:=0                     
			
			_1metqtd2:=0
			_1pedqtd2:=0
			_1fatqtd2:=0
			_1metqtd3:=0
			_1pedqtd3:=0
			_1fatqtd3:=0
			_1totped :=0
			_1totfat :=0
			_1totsgp :=0
			_1totsgf :=0
			_1prqtd1 :=0
			_1totpro :=0
			_1prqtd2 :=0
			_1totpr2 :=0
			_1prqtd3 :=0
			_1totpr3 :=0 			
  			
		endif
		//
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		_ntotped :=0
		_ntotfat :=0
		sb1->(dbseek(_cfilsb1+tmp1->produto))
		@ prow()+1,000 PSAY left(tmp1->produto,6)
		@ prow(),007   PSAY left(sb1->b1_desc,40)
		if tmp4->(dbseek(_cvend+tmp1->produto))
			@ prow(),048 PSAY tmp4->quant picture "@E 999,999"
			_nmetqtd1+=tmp4->quant		
			_1metqtd1+=tmp4->quant
		endif
		if tmp5->(dbseek(_cvend+tmp1->produto))
			@ prow(),056 PSAY tmp5->quant picture "@E 999,999"
			@ prow(),064 PSAY (tmp5->quant/tmp4->quant)*100 picture "@E 9999.9"
			_npedqtd1+=tmp5->quant
			_ntotped+=tmp5->quant
			_1pedqtd1+=tmp5->quant
			_1totped+=tmp5->quant
		endif
		if tmp6->(dbseek(_cvend+tmp1->produto))
			@ prow(),072 PSAY tmp6->quant picture "@E 999,999"
			@ prow(),080 PSAY (tmp6->quant/tmp4->quant)*100 picture "@E 9999.9"
			_nfatqtd1+=tmp6->quant
			_ntotfat+=tmp6->quant
			_1fatqtd1+=tmp6->quant
			_1totfat+=tmp6->quant
		endif		
		if tmp7->(dbseek(_cvend+tmp1->produto))
			@ prow(),088 PSAY tmp7->quant picture "@E 999,999"
			_nmetqtd2+=tmp7->quant			
			_1metqtd2+=tmp7->quant
		endif
		if tmp8->(dbseek(_cvend+tmp1->produto))
			@ prow(),096 PSAY tmp8->quant picture "@E 999,999"
			@ prow(),104 PSAY (tmp8->quant/tmp7->quant)*100 picture "@E 9999.9"
			_npedqtd2+=tmp8->quant
			_ntotped+=tmp8->quant
			_1pedqtd2+=tmp8->quant
			_1totped+=tmp8->quant
		endif
		if tmp9->(dbseek(_cvend+tmp1->produto))
			@ prow(),112 PSAY tmp9->quant picture "@E 999,999"
			@ prow(),120 PSAY (tmp9->quant/tmp7->quant)*100 picture "@E 9999.9"
			_nfatqtd2+=tmp9->quant
			_ntotfat+=tmp9->quant
			_1fatqtd2+=tmp9->quant
			_1totfat+=tmp9->quant
		endif	
		@ prow(),128   PSAY tmp1->quant picture "@E 999,999"
		_nmetqtd3+=tmp1->quant	
		_1metqtd3+=tmp1->quant
		if tmp2->(dbseek(_cvend+tmp1->produto))
			@ prow(),136 PSAY tmp2->quant picture "@E 999,999"
			@ prow(),144 PSAY (tmp2->quant/tmp1->quant)*100 picture "@E 9999.9"
			_npedqtd3+=tmp2->quant
			_ntotped+=tmp2->quant
			_1pedqtd3+=tmp2->quant
			_1totped+=tmp2->quant
		endif
		if tmp3->(dbseek(_cvend+tmp1->produto))
			@ prow(),152 PSAY tmp3->quant picture "@E 999,999"
			@ prow(),160 PSAY (tmp3->quant/tmp1->quant)*100 picture "@E 9999.9"
			_nfatqtd3+=tmp3->quant
			_ntotfat+=tmp3->quant
			_1fatqtd3+=tmp3->quant
			_1totfat+=tmp3->quant
		endif
		@ prow(),168 PSAY _ntotped/3 picture "@E 999,999"
		@ prow(),176 PSAY _ntotfat/3 picture "@E 999,999"
		@ prow(),187 PSAY (_ntotped/3)*(1+(mv_par11/100)) picture "@E 999,999"
		@ prow(),204 PSAY (_ntotfat/3)*(1+(mv_par11/100)) picture "@E 999,999"
	   _ntotsgp += (_ntotped/3)*(1+(mv_par11/100))
	   _ntotsgf += (_ntotfat/3)*(1+(mv_par11/100))
	   _1totsgp += (_ntotped/3)*(1+(mv_par11/100))
	   _1totsgf += (_ntotfat/3)*(1+(mv_par11/100))
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	@ prow()+1,000 PSAY replicate("-",limite)
end
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		//
	   if _mtp <> tmp1->apres      	   
     	   _mtp:= tmp1->apres
			@ prow()+1,000 PSAY "TOTAL LINHA:"
			@ prow(),048   PSAY _1metqtd1 picture "@E 9999999"
			if _1pedqtd1>0
				@ prow(),056 PSAY _1pedqtd1 picture "@E 9999999"
				@ prow(),064 PSAY (_1pedqtd1/_1metqtd1)*100 picture "@E 9999.9"
			endif
			if _1fatqtd1>0
				@ prow(),072 PSAY _1fatqtd1 picture "@E 9999999"
				@ prow(),080 PSAY (_1fatqtd1/_1metqtd1)*100 picture "@E 9999.9"
			endif
			@ prow(),088   PSAY _1metqtd2 picture "@E 9999999"
			if _1pedqtd2>0
				@ prow(),096 PSAY _1pedqtd2 picture "@E 9999999"
				@ prow(),104 PSAY (_1pedqtd2/_1metqtd2)*100 picture "@E 9999.9"
			endif
			if _1fatqtd2>0
				@ prow(),112 PSAY _1fatqtd2 picture "@E 9999999"
				@ prow(),120 PSAY (_1fatqtd2/_1metqtd2)*100 picture "@E 9999.9"
			endif
			@ prow(),128   PSAY _1metqtd3 picture "@E 9999999"
			if _1pedqtd3>0
				@ prow(),136 PSAY _1pedqtd3 picture "@E 9999999"
				@ prow(),144 PSAY (_1pedqtd3/_1metqtd3)*100 picture "@E 9999.9"
			endif
			if _1fatqtd3>0
				@ prow(),152 PSAY _1fatqtd3 picture "@E 9999999"
				@ prow(),160 PSAY (_1fatqtd3/_1metqtd3)*100 picture "@E 9999.9"
			endif
			@ prow(),186 PSAY _1totsgp picture "@E 9999,999"
		   @ prow(),203 PSAY _1totsgf picture "@E 9999,999"    	  		
		endif
//
if prow()>0 .and.;
	lcontinua
	@ prow()+1,000 PSAY "TOTAL"
	@ prow(),048   PSAY _nmetqtd1 picture "@E 9999999"
	if _npedqtd1>0
		@ prow(),056 PSAY _npedqtd1 picture "@E 9999999"
		@ prow(),064 PSAY (_npedqtd1/_nmetqtd1)*100 picture "@E 9999.9"
	endif
	if _nfatqtd1>0
		@ prow(),072 PSAY _nfatqtd1 picture "@E 9999999"
		@ prow(),080 PSAY (_nfatqtd1/_nmetqtd1)*100 picture "@E 9999.9"
	endif
	@ prow(),088   PSAY _nmetqtd2 picture "@E 9999999"
	if _npedqtd2>0
		@ prow(),096 PSAY _npedqtd2 picture "@E 9999999"
		@ prow(),104 PSAY (_npedqtd2/_nmetqtd2)*100 picture "@E 9999.9"
	endif
	if _nfatqtd2>0
		@ prow(),112 PSAY _nfatqtd2 picture "@E 9999999"
		@ prow(),120 PSAY (_nfatqtd2/_nmetqtd2)*100 picture "@E 9999.9"
	endif
	@ prow(),128   PSAY _nmetqtd3 picture "@E 9999999"
	if _npedqtd3>0
		@ prow(),136 PSAY _npedqtd3 picture "@E 9999999"
		@ prow(),144 PSAY (_npedqtd3/_nmetqtd3)*100 picture "@E 9999.9"
	endif
	if _nfatqtd3>0
		@ prow(),152 PSAY _nfatqtd3 picture "@E 9999999"
		@ prow(),160 PSAY (_nfatqtd3/_nmetqtd3)*100 picture "@E 9999.9"
	endif
	@ prow(),186 PSAY _ntotsgp picture "@E 9999,999"
   @ prow(),203 PSAY _ntotsgf picture "@E 9999,999"
	roda(cbcont,cbtxt)
endif
endif
tmp1->(dbclosearea())
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
_cindtmp5+=tmp5->(ordbagext())
tmp5->(dbclosearea())
ferase(_carqtmp5+getdbextension())
ferase(_cindtmp5)
_cindtmp6+=tmp6->(ordbagext())
tmp6->(dbclosearea())
ferase(_carqtmp6+getdbextension())
ferase(_cindtmp6)
_cindtmp7+=tmp7->(ordbagext())
tmp7->(dbclosearea())
ferase(_carqtmp7+getdbextension())
ferase(_cindtmp7)
_cindtmp8+=tmp8->(ordbagext())
tmp8->(dbclosearea())
ferase(_carqtmp8+getdbextension())
ferase(_cindtmp8)
_cindtmp9+=tmp9->(ordbagext())
tmp9->(dbclosearea())
ferase(_carqtmp9+getdbextension())
ferase(_cindtmp9)
if mv_par12=="2"
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

// comercial 
static function _geratmp() 
procregua(12)

_aestrut:={}
aadd(_aestrut,{"VENDEDOR","C",06,0})
aadd(_aestrut,{"PRODUTO" ,"C",15,0})
aadd(_aestrut,{"QUANT"   ,"N",18,2})
aadd(_aestrut,{"APRES"   ,"C",1,0})

_carqtmp3:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)
_cindtmp3:=criatrab(,.f.)
_cchave  :="VENDEDOR+PRODUTO"
tmp3->(indregua("TMP3",_cindtmp3,_cchave,,,"Selecionando registros..."))

_carqtmp6:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp6,"tmp6",.f.,.f.)
_cindtmp6:=criatrab(,.f.)
_cchave  :="VENDEDOR+PRODUTO"
tmp6->(indregua("tmp6",_cindtmp6,_cchave,,,"Selecionando registros..."))

_carqtmp9:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp9,"tmp9",.f.,.f.)
_cindtmp9:=criatrab(,.f.)
_cchave  :="VENDEDOR+PRODUTO"
tmp9->(indregua("tmp9",_cindtmp9,_cchave,,,"Selecionando registros..."))
for _i:=1 to 3 
	if _i==1
		_ddataini:=_ddataini1
		_ddatafim:=_ddatafim1
	elseif _i==2
		_ddataini:=_ddataini2
		_ddatafim:=_ddatafim2
	else
		_ddataini:=mv_par01
		_ddatafim:=mv_par02
	endif
	//
	incproc("Calculando metas...")
	_cquery:=" SELECT"
	_cquery+=" CT_VEND VENDEDOR,CT_PRODUTO PRODUTO,SUM(CT_QUANT) QUANT,"
	_cquery+=" B1_DESC DESCRICAO,B1_APREVEN APRES,' ' D_E_L_E_T_"
	_cquery+=" FROM "
	_cquery+=" SB1010 SB1,"
	_cquery+=" SCT010 SCT"
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SCT.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"
	_cquery+=" AND CT_PRODUTO=B1_COD"
	_cquery+=" AND CT_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
	_cquery+=" AND CT_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND CT_PRODUTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND CT_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" GROUP BY"
	_cquery+=" CT_VEND,B1_APREVEN,B1_DESC,CT_PRODUTO"
	_cquery+=" ORDER BY"
	_cquery+=" CT_VEND,B1_APREVEN,B1_DESC,CT_PRODUTO"
	if _i==1
		tcquery _cquery new alias "TMP4"
		tcsetfield("TMP4","QUANT","N",12,0)		
		
		_carqtmp4:=criatrab(,.f.)          
		copy to &_carqtmp4
		tmp4->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp4,"TMP4",.f.,.f.)
		_cindtmp4:=criatrab(,.f.)
		_cchave  :="VENDEDOR+PRODUTO"
		tmp4->(indregua("TMP4",_cindtmp4,_cchave,,,"Selecionando registros..."))
	elseif _i==2
		tcquery _cquery new alias "TMP7"
		tcsetfield("TMP7","QUANT","N",12,0)
		
		_carqtmp7:=criatrab(,.f.)
		copy to &_carqtmp7
		tmp7->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp7,"TMP7",.f.,.f.)
		_cindtmp7:=criatrab(,.f.)
		_cchave  :="VENDEDOR+PRODUTO"
		tmp7->(indregua("TMP7",_cindtmp7,_cchave,,,"Selecionando registros..."))
	else
		tcquery _cquery new alias "TMP1"
		tcsetfield("TMP1","QUANT","N",12,0)
	endif
	incproc("Calculando pedidos...")
	_cquery:=" SELECT"
	_cquery+=" C5_VEND"+alltrim(str(mv_par09,1))+" VENDEDOR,C6_PRODUTO PRODUTO,"
	_cquery+=" SUM(C6_QTDVEN) QUANT,' ' D_E_L_E_T_"
	_cquery+=" FROM "
	_cquery+=" SC5010 SC5,"
	_cquery+=" SC6010 SC6,"
	_cquery+=" SF4010 SF4"
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
	_cquery+=" AND C5_VEND"+alltrim(str(mv_par09,1))+" BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND C6_PRODUTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" GROUP BY"
	_cquery+=" C5_VEND"+alltrim(str(mv_par09,1))+",C6_PRODUTO"
	_cquery+=" ORDER BY"
	_cquery+=" C5_VEND"+alltrim(str(mv_par09,1))+",C6_PRODUTO"
	if _i==1
		tcquery _cquery new alias "TMP5"
		tcsetfield("TMP5","QUANT","N",12,0)
		_carqtmp5:=criatrab(,.f.)
		copy to &_carqtmp5
		tmp5->(dbclosearea())
		dbusearea(.t.,,_carqtmp5,"TMP5",.f.,.f.)
		_cindtmp5:=criatrab(,.f.)
		_cchave  :="VENDEDOR+PRODUTO"
		tmp5->(indregua("TMP5",_cindtmp5,_cchave,,,"Selecionando registros..."))
	elseif _i==2
		tcquery _cquery new alias "TMP8"
		tcsetfield("TMP8","QUANT","N",12,0)
		_carqtmp8:=criatrab(,.f.)
		copy to &_carqtmp8
		tmp8->(dbclosearea())
		dbusearea(.t.,,_carqtmp8,"TMP8",.f.,.f.)
		_cindtmp8:=criatrab(,.f.)
		_cchave  :="VENDEDOR+PRODUTO"
		tmp8->(indregua("TMP8",_cindtmp8,_cchave,,,"Selecionando registros..."))
	else
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","QUANT","N",12,0)
	
		_carqtmp2:=criatrab(,.f.)
		copy to &_carqtmp2
		tmp2->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
		_cindtmp2:=criatrab(,.f.)
		_cchave  :="VENDEDOR+PRODUTO"
		tmp2->(indregua("TMP2",_cindtmp2,_cchave,,,"Selecionando registros..."))
	endif
	if mv_par12 == "2"
		incproc("Calculando faturamento...")
		sd2010->(dbseek(_cfilsd2+dtos(_ddataini),.t.))
		while ! sd2010->(eof()) .and.;
			sd2010->d2_filial==_cfilsd2 .and.;
			sd2010->d2_emissao<=_ddatafim
		if sd2010->d2_cod>=mv_par05 .and.;
			sd2010->d2_cod<=mv_par06
			sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
			if sf4010->f4_duplic=="S"
				sf2010->(dbseek(_cfilsf2+sd2010->d2_doc+sd2010->d2_serie))
				sb1010->(dbseek(_cfilsd2+sd2010->d2_cod))				
				_cvend:=sf2010->(fieldget(fieldpos("F2_VEND"+alltrim(str(mv_par09,1)))))
				if _cvend>=mv_par03 .and.;
					_cvend<=mv_par04
					if _i==1
						if tmp6->(dbseek(_cvend+sd2010->d2_cod))
							tmp6->quant+=sd2010->d2_quant
						else
							tmp6->(dbappend())
							tmp6->vendedor:=_cvend
							tmp6->apres := sb1010->b1_apreven           
							tmp6->produto :=sd2010->d2_cod
							tmp6->quant   :=sd2010->d2_quant
						endif
					elseif _i==2
						if tmp9->(dbseek(_cvend+sd2010->d2_cod))
							tmp9->quant+=sd2010->d2_quant
						else
							tmp9->(dbappend())
							tmp9->vendedor:=_cvend              
							tmp9->apres   :=sb1010->sb1_apreven
							tmp9->produto :=sd2010->d2_cod
							tmp9->quant   :=sd2010->d2_quant
						endif
					else
						if tmp3->(dbseek(_cvend+sd2010->d2_cod))
							tmp3->quant+=sd2010->d2_quant
						else
							tmp3->(dbappend())
							tmp3->vendedor:=_cvend
							tmp3->produto :=sd2010->d2_cod
							tmp3->quant   :=sd2010->d2_quant    
							tmp3->apres   :=sb1010->b1_apreven
						endif
					endif
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
		if sd2->d2_cod>=mv_par05 .and.;
			sd2->d2_cod<=mv_par06
			sf4->(dbseek(_cfilsf4+sd2->d2_tes))
			if sf4->f4_duplic=="S"
				sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
				sb1->(dbseek(_cfilsb1+sd2->d2_cod))				
				_cvend:=sf2->(fieldget(fieldpos("F2_VEND"+alltrim(str(mv_par09,1)))))
				if _cvend>=mv_par03 .and.;
					_cvend<=mv_par04
					if _i==1
						if tmp6->(dbseek(_cvend+sd2->d2_cod))
							tmp6->quant+=sd2->d2_quant
						else
							tmp6->(dbappend())
							tmp6->vendedor:=_cvend              
							tmp6->apres   :=sb1->b1_apreven
							tmp6->produto :=sd2->d2_cod
							tmp6->quant   :=sd2->d2_quant
						endif
					elseif _i==2
						if tmp9->(dbseek(_cvend+sd2->d2_cod))
							tmp9->quant+=sd2->d2_quant
						else
							tmp9->(dbappend())
							tmp9->vendedor:=_cvend
							tmp9->produto :=sd2->d2_cod
							tmp9->apres   :=sb1->b1_apreven
							tmp9->quant   :=sd2->d2_quant
						endif
					else
						if tmp3->(dbseek(_cvend+sd2->d2_cod))
							tmp3->quant+=sd2->d2_quant
						else
							tmp3->(dbappend())
							tmp3->vendedor:=_cvend
							tmp3->produto :=sd2->d2_cod         
							tmp3->apres   :=sb1->b1_apreven
							tmp3->quant   :=sd2->d2_quant
						endif
					endif
				endif
			endif
		endif
		sd2->(dbskip())
	end
next
return

// p/ industria linha producao
static function _geratmp2()
procregua(12)                  
// linha producao        
if mv_par13=2
	incproc("Selecionando produtos...")
	_cquery:=" SELECT"
	_cquery+=" B1_COD PRODUTO"
	_cquery+=" FROM "
	_cquery+="SB1010 SB1,"
	_cquery+="SBM010 SBM"
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"
	_cquery+=" AND B1_GRUPO=BM_GRUPO"
	_cquery+=" AND B1_TIPO='PA'" 
	_cquery+=" ORDER BY"
	_cquery+=" BM_TIPGRU,B1_DESC,B1_COD"
	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMPF"
else 
	incproc("Selecionando produtos...")
	_cquery:=" SELECT"
	_cquery+=" B1_COD PRODUTO"
	_cquery+=" FROM "
	_cquery+="SB1010 SB1,"
	_cquery+="SBM010 SBM"
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"
	_cquery+=" AND B1_GRUPO=BM_GRUPO"
	_cquery+=" AND B1_TIPO='PA'" 
	_cquery+=" ORDER BY"
	_cquery+=" B1_APREVEN,B1_DESC,B1_COD"
	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMPF"

endif	

_aestrut:={}
aadd(_aestrut,{"PRODUTO" ,"C",15,0})
aadd(_aestrut,{"GRUPO" ,"C",4,0})
aadd(_aestrut,{"QUANT"   ,"N",18,2})

_carqtmp3:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)
_cindtmp3:=criatrab(,.f.)
_cchave  :="PRODUTO"
tmp3->(indregua("TMP3",_cindtmp3,_cchave,,,"Selecionando registros..."))

_carqtmp6:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp6,"tmp6",.f.,.f.)
_cindtmp6:=criatrab(,.f.)
_cchave  :="PRODUTO"
tmp6->(indregua("tmp6",_cindtmp6,_cchave,,,"Selecionando registros..."))

_carqtmp9:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp9,"tmp9",.f.,.f.)
_cindtmp9:=criatrab(,.f.)
_cchave  :="PRODUTO"
tmp9->(indregua("tmp9",_cindtmp9,_cchave,,,"Selecionando registros..."))

for _i:=1 to 3 
	if _i==1
		_ddataini:=_ddataini1
		_ddatafim:=_ddatafim1
	elseif _i==2
		_ddataini:=_ddataini2
		_ddatafim:=_ddatafim2
	else
		_ddataini:=mv_par01
		_ddatafim:=mv_par02
	endif
	incproc("Calculando metas...")
	_cquery:=" SELECT"
	_cquery+=" CT_PRODUTO PRODUTO,SUM(CT_QUANT) QUANT,"
	_cquery+=" B1_DESC DESCRICAO,' ' D_E_L_E_T_,"
	_cquery+=" BM_TIPGRU TIPGRU"
	_cquery+=" FROM "
	_cquery+=" SB1010 SB1,"
	_cquery+=" SBM010 SBM,"		
	_cquery+=" SCT010 SCT"
	_cquery+=" WHERE"     
	_cquery+="     SB1.D_E_L_E_T_<>'*'"     
	_cquery+=" AND SCT.D_E_L_E_T_<>'*'"
	_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"  
  	_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"	
	_cquery+=" AND BM_GRUPO=B1_GRUPO"   	
	_cquery+=" AND CT_PRODUTO=B1_COD"   	
	_cquery+=" AND CT_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
	_cquery+=" AND CT_PRODUTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND CT_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND CT_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" GROUP BY"
	_cquery+=" BM_TIPGRU,B1_DESC,CT_PRODUTO"
	_cquery+=" ORDER BY"
	_cquery+=" BM_TIPGRU,B1_DESC,CT_PRODUTO"
	if _i==1
		tcquery _cquery new alias "TMP4"
		tcsetfield("TMP4","QUANT","N",12,0)
		
		_carqtmp4:=criatrab(,.f.)
		copy to &_carqtmp4
		tmp4->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp4,"TMP4",.f.,.f.)
		_cindtmp4:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmp4->(indregua("TMP4",_cindtmp4,_cchave,,,"Selecionando registros..."))
	elseif _i==2
		tcquery _cquery new alias "TMP7"
		tcsetfield("TMP7","QUANT","N",12,0)
		
		_carqtmp7:=criatrab(,.f.)
		copy to &_carqtmp7
		tmp7->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp7,"TMP7",.f.,.f.)
		_cindtmp7:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmp7->(indregua("TMP7",_cindtmp7,_cchave,,,"Selecionando registros..."))
	else
		tcquery _cquery new alias "TMP1"
		tcsetfield("TMP1","QUANT","N",12,0)
		
		_carqtmp1:=criatrab(,.f.)
		copy to &_carqtmp1
		tmp1->(dbclosearea())    	

		dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)
		_cindtmp1:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmp1->(indregua("TMP1",_cindtmp1,_cchave,,,"Selecionando registros..."))
		
/*		// indice 2
		_carqtmp12:=criatrab(,.f.)
		copy to &_carqtmp12
		tmp1->(dbclosearea())

		dbusearea(.t.,,_carqtmp12,"TMP1",.f.,.f.)
		_cindtmp12:=criatrab(,.f.)
		_cchave  :="APRES+PRODUTO"
		tmp1->(indregua("TMP1",_cindtmp12,_cchave,,,""))
		
		tmp1->(dbclearind())
		tmp1->(dbsetindex(_cindtmp11))
		tmp1->(dbsetindex(_cindtmp12))
		tmp1->(dbsetorder(1))*/
	
	endif

//
			// ENTRADA NO MES     
			 
	incproc("Calculando Produções...")			
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT,B1_COD PRODUTO"
	_cquery+=" FROM "
	_cquery+=" SD5010 SD5,"    
	_cquery+=" SB1010 SB1"     
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

/*	_cquery:=" SELECT"
	_cquery+=" sum(D3_QUANT) QUANT,B1_COD PRODUTO"
	_cquery+=" FROM "
	_cquery+=" SD3010 SD3,"    
	_cquery+=" SB1010 SB1"     
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SD3.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
	_cquery+=" AND D3_COD=B1_COD"
	_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"		
	_cquery+=" AND D3_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND D3_CF IN ('PR0')" //,'RE0','RE1','RE2','RE4')"
	_cquery+=" AND D3_TM<>'508'"
	_cquery+=" AND D3_ESTORNO<>'S'"
	_cquery+=" GROUP BY"
	_cquery+=" B1_COD"
	_cquery+=" ORDER BY"
	_cquery+=" B1_COD"*/
	
	if _i==1
		tcquery _cquery new alias "TMPA"
		tcsetfield("TMPA","QUANT","N",12,0)
		_carqtmpA:=criatrab(,.f.)
		copy to &_carqtmpA
		tmpA->(dbclosearea())
	
		dbusearea(.t.,,_carqtmpA,"TMPA",.f.,.f.)
		_cindtmpA:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmpA->(indregua("TMPA",_cindtmpA,_cchave,,,"Selecionando registros..."))
	elseif _i==2
		tcquery _cquery new alias "TMPB"
		tcsetfield("TMPB","QUANT","N",12,0)
		
		_carqtmpB:=criatrab(,.f.)
		copy to &_carqtmpB
		tmpB->(dbclosearea())
	
		dbusearea(.t.,,_carqtmpB,"TMPB",.f.,.f.)
		_cindtmpB:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmpB->(indregua("TMPB",_cindtmpB,_cchave,,,"Selecionando registros..."))
	else
		tcquery _cquery new alias "TMPC"
		tcsetfield("TMPC","QUANT","N",12,0)
		
		_carqtmpC:=criatrab(,.f.)
		copy to &_carqtmpC
		tmpC->(dbclosearea())
	
		dbusearea(.t.,,_carqtmpC,"TMPC",.f.,.f.)
		_cindtmpC:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmpC->(indregua("TMPC",_cindtmpC,_cchave,,,"Selecionando registros..."))
	endif            
	
//
	incproc("Calculando pedidos...")
	_cquery:=" SELECT"
	_cquery+=" C6_PRODUTO PRODUTO,"
	_cquery+=" SUM(C6_QTDVEN) QUANT,' ' D_E_L_E_T_"
	_cquery+=" FROM "
	_cquery+=" SC5010 SC5,"
	_cquery+=" SC6010 SC6,"
	_cquery+=" SF4010 SF4"
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
	_cquery+=" AND C6_PRODUTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" GROUP BY"
	_cquery+=" C6_PRODUTO"
	_cquery+=" ORDER BY"
	_cquery+=" C6_PRODUTO"
	if _i==1
		tcquery _cquery new alias "TMP5"
		tcsetfield("TMP5","QUANT","N",12,0)
		
		_carqtmp5:=criatrab(,.f.)
		copy to &_carqtmp5
		tmp5->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp5,"TMP5",.f.,.f.)
		_cindtmp5:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmp5->(indregua("TMP5",_cindtmp5,_cchave,,,"Selecionando registros..."))
	elseif _i==2
		tcquery _cquery new alias "TMP8"
		tcsetfield("TMP8","QUANT","N",12,0)
		
		_carqtmp8:=criatrab(,.f.)
		copy to &_carqtmp8
		tmp8->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp8,"TMP8",.f.,.f.)
		_cindtmp8:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmp8->(indregua("TMP8",_cindtmp8,_cchave,,,"Selecionando registros..."))
	else
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","QUANT","N",12,0)
		
		_carqtmp2:=criatrab(,.f.)
		copy to &_carqtmp2
		tmp2->(dbclosearea())
	
		dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
		_cindtmp2:=criatrab(,.f.)
		_cchave  :="PRODUTO"
		tmp2->(indregua("TMP2",_cindtmp2,_cchave,,,"Selecionando registros..."))
	endif
		if mv_par12 == "2"
		incproc("Calculando faturamento...")
		sd2010->(dbseek(_cfilsd2+dtos(_ddataini),.t.))
		while ! sd2010->(eof()) .and.;
			sd2010->d2_filial==_cfilsd2 .and.;
			sd2010->d2_emissao<=_ddatafim
		if sd2010->d2_cod>=mv_par05 .and.;
			sd2010->d2_cod<=mv_par06
			sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
			if sf4010->f4_duplic=="S"
				sf2010->(dbseek(_cfilsf2+sd2010->d2_doc+sd2010->d2_serie))
				_cvend:=sf2010->(fieldget(fieldpos("F2_VEND"+alltrim(str(mv_par09,1)))))
				if _cvend>=mv_par03 .and.;
					_cvend<=mv_par04
					if _i==1
						if tmp6->(dbseek(_cvend+sd2010->d2_cod))
							tmp6->quant+=sd2010->d2_quant
						else
							tmp6->(dbappend())
							tmp6->vendedor:=_cvend
							tmp6->produto :=sd2010->d2_cod
							tmp6->quant   :=sd2010->d2_quant
						endif
					elseif _i==2
						if tmp9->(dbseek(_cvend+sd2010->d2_cod))
							tmp9->quant+=sd2010->d2_quant
						else
							tmp9->(dbappend())
							tmp9->vendedor:=_cvend
							tmp9->produto :=sd2010->d2_cod
							tmp9->quant   :=sd2010->d2_quant
						endif
					else
						if tmp3->(dbseek(_cvend+sd2010->d2_cod))
							tmp3->quant+=sd2010->d2_quant
						else
							tmp3->(dbappend())
							tmp3->vendedor:=_cvend
							tmp3->produto :=sd2010->d2_cod
							tmp3->quant   :=sd2010->d2_quant
						endif
					endif
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
		if sd2->d2_cod>=mv_par05 .and.;
			sd2->d2_cod<=mv_par06
			sf4->(dbseek(_cfilsf4+sd2->d2_tes))
			if sf4->f4_duplic=="S"
				sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
					if _i==1
						if tmp6->(dbseek(sd2->d2_cod))
							tmp6->quant+=sd2->d2_quant
						else
							tmp6->(dbappend())
							tmp6->produto :=sd2->d2_cod
							tmp6->quant   :=sd2->d2_quant
						endif
					elseif _i==2
						if tmp9->(dbseek(sd2->d2_cod))
							tmp9->quant+=sd2->d2_quant
						else
							tmp9->(dbappend())
							tmp9->produto :=sd2->d2_cod
							tmp9->quant   :=sd2->d2_quant
						endif
					else
						if tmp3->(dbseek(sd2->d2_cod))
							tmp3->quant+=sd2->d2_quant
						else
							tmp3->(dbappend())
							tmp3->produto :=sd2->d2_cod
							tmp3->quant   :=sd2->d2_quant
						endif
					endif

			endif
		endif
		sd2->(dbskip())
	end
next
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
  if !empty(_ntmp4+_ntmp5+_ntmp6+_ntmp7+_ntmp8+_ntmp9)  
  	  @ prow()+1,000 PSAY "TOTAL DA LINHA " //+tabela("V0",_sbmt+"    ")
  	  @ prow(),036   PSAY _ntmp4 picture "@E 9999,999"
	  @ prow(),045   PSAY _ntmpA picture "@E 9999,999"					
	  @ prow(),054   PSAY (_ntmpA/_ntmp4)*100 picture "@E 999.99"					
	  @ prow(),061   PSAY _ntmp5 picture "@E 9999,999"                   
	  @ prow(),070   PSAY (_ntmp5/_ntmp4)*100 picture "@E 999.99"						  
	  @ prow(),076   PSAY _ntmp6 picture "@E 9999,999"
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
	  @ prow(),209   PSAY ((_ntmpA+_ntmpB+_ntmpC)/(_ntmp4+_ntmp7+_ntmp1))*100 picture "@E 999.99"	
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
aadd(_agrpsx1,{cperg,"03","Do vendedor        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o vendedor     ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Do produto         ?","mv_ch5","C",15,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"06","Ate o produto      ?","mv_ch6","C",15,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"07","Do documento       ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o documento    ?","mv_ch8","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Considera vendedor ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"Vendedor 1"     ,space(30),space(15),"Vendedor 2"     ,space(30),space(15),"Vendedor 3"     ,space(30),space(15),"Vendedor 4"     ,space(30),space(15),"Vendedor 5"     ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Salta pagina       ?","mv_chA","N",01,0,0,"C",space(60),"mv_par10"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","% sugerido p/ meta ?","mv_chB","N",06,2,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Grade              ?","mv_chC","C",01,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Considera sistema  ?","mv_chD","N",01,0,0,"C",space(60),"mv_par13"       ,"1-Comercial"    ,space(30),space(15),"2-Estoque"      ,space(30),space(15),"3-Apresentação" ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
