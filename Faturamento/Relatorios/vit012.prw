/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT012   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 21/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao da Pre-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit012()
titulo  := "EMISSAO DA PRE-NOTA"
cdesc1  := "Este programa ira emitir a pre-nota"
cdesc2  := ""
cdesc3  := ""
tamanho := "M"
limite  := 132
cstring :="SC5"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT012"
aLinha  :={}
nlastkey:=0
lcontinua:=.t.

cperg:="PERGVIT012"
_pergsx1()
pergunte(cperg,.f.)

wnrel:="VIT012"+Alltrim(cusername)
wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

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
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

_cestado :=getmv("MV_ESTADO")
_cnorte  :=getmv("MV_NORTE")
_nicmpad :=getmv("MV_ICMPAD")
_c:=1

_cfilda0:=xfilial("DA0")
_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsa4:=xfilial("SA4")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilse4:=xfilial("SE4")
_cfilsf4:=xfilial("SF4")
_cfilsf7:=xfilial("SF7")

da0->(dbsetorder(1))
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sa4->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
se4->(dbsetorder(1))
sf4->(dbsetorder(1))
sf7->(dbsetorder(1))

setregua(val(mv_par02)-val(mv_par01))

sc5->(dbseek(_cfilsc5+mv_par01,.t.))
while ! sc5->(eof()) .and.;
		sc5->c5_filial==_cfilsc5 .and.;
		sc5->c5_num<=mv_par02 .and.;
		lcontinua

	incregua()
	if sc5->c5_tipo=="N"
		da0->(dbseek(_cfilda0+sc5->c5_tabela))
		sa1->(dbseek(_cfilsa1+sc5->c5_cliente+sc5->c5_lojacli))
		sa4->(dbseek(_cfilsa4+sc5->c5_transp))
		se4->(dbseek(_cfilse4+sc5->c5_condpag))

		if mv_par03==1 .or. mv_par03==3 .or. mv_par03==4 // Pendencia, faturado ou total
			sc6->(dbseek(_cfilsc6+sc5->c5_num))

			_fatorpos:=0.7234
			if sa1->a1_est = "RJ"  				// 19%
				_fatorneg:=0.7523
			elseif sa1->a1_est = "SP#MG" 		// 18%
				_fatorneg:=0.7519
			elseif sa1->a1_est = "PR"  			// 12%
				_fatorneg:=0.7499
//			elseif sf2->f2_est = "AM#AC#AP#RO"  // Zona Franca
			elseif da0->da0_status = "Z"  // Zona Franca
				_fatorneg:=0.7234
			else
				_fatorneg:=0.7515  				// 17%
			endif

			if sc5->c5_percfat==100
				_npicm   :=0
				_nbaseicm:=0
				_nvalicm :=0
				_nbaseret:=0
				_nvalret :=0
				_nbasegnr:=0
				_nvalgnr :=0
				_ndesczf :=0
				_nvalmerc:=0
				_nrepasse:=0
				_nprep   :=0
				_amentes :={}
				_limpcab :=.t.
				_limprime:=.f.
				_nprmax := 0
				_nvalmax :=0
				_npr := 0
				_leitens(1)
				_c:=1
			else
				_nregsc6:=sc6->(recno())
				for _c:=1 to 2
					_npicm   :=0
					_nbaseicm:=0
					_nvalicm :=0
					_nbaseret:=0
					_nvalret :=0
					_nbasegnr:=0
					_nvalgnr :=0
					_ndesczf :=0
					_nvalmerc:=0
					_nrepasse:=0
					_nprep   :=0
					_amentes :={}
					_limpcab :=.t.
					_limprime:=.f.
					_nprmax := 0
					_nvalmax :=0
					_npr := 0					

					if _c==2
						sc6->(dbgoto(_nregsc6))
					endif
					_leitens(1)
				next
			endif

		else // Liberado
			sc9->(dbseek(_cfilsc9+sc5->c5_num))
			_nregsc9:=sc9->(recno())
			_lcont:=.t.
			while ! sc9->(eof()) .and.;
					sc9->c9_filial==_cfilsc9 .and.;
					sc9->c9_pedido==sc5->c5_num .and.;
					_lcont
				if empty(sc9->c9_nfiscal)
					if ! empty(sc9->c9_blest) .or. ! empty(sc9->c9_blcred)
						_lcont:=.f.
					endif
				endif
				sc9->(dbskip())
			end
			if _lcont
				if sc5->c5_percfat==100
					_npicm   :=0
					_nbaseicm:=0
					_nvalicm :=0
					_nbaseret:=0
					_nvalret :=0
					_nbasegnr:=0
					_nvalgnr :=0
					_ndesczf :=0
					_nvalmerc:=0
					_nrepasse:=0
					_nprep   :=0
					_amentes :={}
					_limpcab :=.t.
					_limprime:=.f.
					_nprmax := 0
					_nvalmax :=0
					_npr := 0					
					_c:=1					
					
					sc9->(dbgoto(_nregsc9))
					_leitens(2)
				else
					for _c:=1 to 2
						_npicm   :=0
						_nbaseicm:=0
						_nvalicm :=0
						_nbaseret:=0
						_nvalret :=0
						_nbasegnr:=0
						_nvalgnr :=0
						_ndesczf :=0
						_nvalmerc:=0
						_nrepasse:=0
						_nprep   :=0
						_amentes :={}
						_limpcab :=.t.
						_limprime:=.f.
						_nprmax := 0
						_nvalmax :=0
						_npr := 0					

						sc9->(dbgoto(_nregsc9))
						_leitens(2)
					next
				endif
			endif
		endif
	endif
	sc5->(dbskip())

	if !sc5->(eof()) .and.;
		(sc5->c5_filial==_cfilsc5) .and.;
		(sc5->c5_num<=mv_par02)
		
			@ 066,000 PSAY " "
			setprc(0,0)
	endif

	if labortprint
		@ prow()+2,000 PSAY "**** CANCELADO PELO OPERADOR ****"
		eject
		lcontinua:=.f.
	endif
end

set device to screen

setpgeject(.f.)
if areturn[5]==1
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _leitens(_ntipo)
if _ntipo==1
	while ! sc6->(eof()) .and.;
			sc6->c6_filial==_cfilsc6 .and.;
			sc6->c6_num==sc5->c5_num 
		if sc6->c6_blq<>"R "
			sb1->(dbseek(_cfilsb1+sc6->c6_produto))
			_ccateg:=left(sb1->b1_categ,1)
			da0->(dbseek(_cfilda0+sc5->c5_tabela))					
			if if(sc5->c5_percfat==100,.t.,if(_c==1,_ccateg=="I" .or. da0->da0_status=="Z",_ccateg=="N" .and. da0->da0_status<>"Z"))
				sf4->(dbseek(_cfilsf4+sc6->c6_tes))

				// PREC.MAX CONSUMIDOR
				if sc5->c5_tipocli="S" .AND. sf4->f4_stdesc = "2"
					_npr:=round(sc6->c6_prunit,2)	
				else
				  _npr:=round(sc6->c6_prcven,2)
				endif 
				///								
				
				if mv_par03==1 // Pendencia
					_nqtd:=sc6->c6_qtdven-sc6->c6_qtdent-sc6->c6_qtdemp				
					if _nqtd>0                               
					  	_nvalor:=round(_nqtd*sc6->c6_prcven,2)					
 					  	_nvalst:=round(_nqtd*_npr,2)					
						_vericm()
						_impitem()
					endif
				elseif mv_par03==3 // Faturado
					_nqtd:=sc6->c6_qtdent
					if _nqtd>0
						_nvalor:=round(_nqtd*sc6->c6_prcven,2)    
 					   _nvalst:=round(_nqtd*_npr,2)											
						_vericm()
						_impitem()
					endif
				elseif mv_par03==4 // Total
					_nqtd:=sc6->c6_qtdven
					_nvalor:=round(_nqtd*sc6->c6_prcven,2)       
 					_nvalst:=round(_nqtd*_npr,2)										
					_vericm()
					_impitem()
				endif
			endif
		endif
		sc6->(dbskip())
	end
else
	while ! sc9->(eof()) .and.;
			sc9->c9_filial==_cfilsc9 .and.;
			sc9->c9_pedido==sc5->c5_num
		if empty(sc9->c9_nfiscal) .and.;
			empty(sc9->c9_blest) .and.;
			empty(sc9->c9_blcred)
			sc6->(dbseek(_cfilsc6+sc9->c9_pedido+sc9->c9_item+sc9->c9_produto))
			sb1->(dbseek(_cfilsb1+sc6->c6_produto))
			da0->(dbseek(_cfilda0+sc5->c5_tabela))			
			_ccateg:=left(sb1->b1_categ,1)
			if if(sc5->c5_percfat==100,.t.,if(_c==1,_ccateg=="I" .or. da0->da0_status=="Z",_ccateg=="N" .and. da0->da0_status<>"Z" ))
				sf4->(dbseek(_cfilsf4+sc6->c6_tes))
				
				// PREC.MAX CONSUMIDOR
				if sc5->c5_tipocli="S" .AND. sf4->f4_stdesc = "2" // sc5->c5_licitac <> "S"		
					_npr:=round(sc6->c6_prunit,2)	
				else
				  _npr:=round(sc6->c6_prcven,2)
				endif 
				///							

				_nqtd  :=sc9->c9_qtdlib
			    _nvalor:=round(_nqtd*sc6->c6_prcven,2)          
				_nvalst:=round(_nqtd*_npr,2)									
				_vericm()
				_impitem()
			endif
		endif
		sc9->(dbskip())
	end
endif
_improd()
return

static function _impcab()
_limprime:=.t.
if _limpcab// .or. prow()>50
	_limpcab:=.f.
	@ prow(),000   PSAY CHR(15)
	@ prow()+1,000   PSAY sm0->m0_nomecom
	@ prow(),041   PSAY "|"
	@ prow(),043   PSAY sc5->c5_cliente+"/"+sc5->c5_lojacli+"-"+sa1->a1_nome
	@ prow(),097   PSAY "|"
	@ prow(),099   PSAY "PEDIDO No. "+sc5->c5_num+" - "+if(mv_par03==1,"Pendencia",if(mv_par03==2,"Liberado",if(mv_par03==3,"Faturado","Total")))
	@ prow()+1,000 PSAY sm0->m0_endcob
	@ prow(),041   PSAY "|"
	@ prow(),043   PSAY sa1->a1_end
	@ prow(),097   PSAY "|"
	@ prow()+1,000 PSAY sm0->m0_cidcob
	@ prow(),021   PSAY sm0->m0_estcob
	@ prow(),024   PSAY sm0->m0_cepcob picture "@R 99999-999"
	@ prow(),041   PSAY "|"
	@ prow(),043   PSAY left(sa1->a1_mun,20)
	@ prow(),064   PSAY sa1->a1_est
	@ prow(),067   PSAY sa1->a1_cep picture "@R 99999-999"
	@ prow(),077   PSAY "TEL: "+alltrim(sa1->a1_ddd)+" "+alltrim(sa1->a1_tel)
	@ prow(),097   PSAY "|"
	@ prow(),099   PSAY sc5->c5_emissao
	@ prow()+1,000 PSAY "TEL: "+sm0->m0_tel
	@ prow(),020   PSAY "CGC: "+sm0->m0_cgc
	@ prow(),041   PSAY "|"
	@ prow(),043   PSAY "CGC: "+sa1->a1_cgc
	@ prow(),063   PSAY "INSC.EST.: "+sa1->a1_inscr
	@ prow(),097   PSAY "|"
	@ prow()+1,000 PSAY replicate("-",limite)
	sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
	@ prow()+1,000 PSAY "VENDEDOR: "+sc5->c5_vend1+" - "+sa3->a3_nome
	@ prow(),061   PSAY "COMISSAO: "+transform(sc5->c5_comis1,"@E 99.99")+"%"
	@ prow()+1,000 PSAY "TABELA...: "+sc5->c5_tabela+"-"+da0->da0_descri
	@ prow(),046   PSAY "DESCONTOS: "+transform(sc5->c5_desc1,"@E 99.99")+"%+"+transform(sc5->c5_desc2,"@E 99.99")+"%"+;
												 transform(sc5->c5_desc3,"@E 99.99")+"%+"+transform(sc5->c5_desc4,"@E 99.99")+"%"
	@ prow(),085   PSAY "DESC.ITENS: "+transform(sc5->c5_descit,"@E 99.99")+"%"
	@ prow(),104   PSAY "PROMOCAO: "+sc5->c5_promoc
	@ prow()+1,000 PSAY "COND.PGTO: "+sc5->c5_condpag+"-"+se4->e4_descri
	@ prow(),029   PSAY "TIPO CLIENTE: "+sc5->c5_tipocli
	@ prow(),045   PSAY "TRANSPORTADORA: "+sc5->c5_transp+"-"+sa4->a4_nome
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "It Produto                                         UM Quantidade    Preco unit.    Valor total Desc. TES ICMS Promocao Cat Pr.Max"
	@ prow()+1,000 PSAY replicate("-",limite)
endif
return

static function _impitem()
_impcab()
_nprmax:= 0
_fatorpos:=0.7234

if sa1->a1_est = "RJ"				// 19%
	_fatorneg:=0.7523
elseif sa1->a1_est $ "SP#MG"		// 18%
	_fatorneg:=0.7519
elseif sa1->a1_est = "PR"			// 12%
	_fatorneg:=0.7499
//elseif sf2->f2_est $ "AM#AC#AP#RO"
elseif da0->da0_status = "Z"		// Zona Franca
	_fatorneg:=0.7234
else
	_fatorneg:=0.7515				//	17%
endif

if sc5->c5_desc3>0  
	_npreco  :=round(sc6->c6_prcven/(1-sc5->c5_desc3/100),6)
	_ntotal  :=round(_nqtd*_npreco,2)
	_nprep   :=sc5->c5_desc3
	_nrepasse+=_ntotal-_nvalor       
	if sb1->b1_categ=="N  "
		_nprmax:=round(sc6->c6_prunit/_fatorneg,6)
	else
		_nprmax:=round(sc6->c6_prunit/_fatorpos,6)
	endif	
else                     
	if sc5->c5_licitac <> "S"
		if sb1->b1_categ=="N  "
			_nprmax:=round(sc6->c6_prunit/_fatorneg,6)
		else
			_nprmax:=round(sc6->c6_prunit/_fatorpos,6)
		endif	
	else
		if sb1->b1_categ=="N  "
			_nprmax:=round(sc6->c6_prcven/_fatorneg,6)
		else
			_nprmax:=round(sc6->c6_prcven/_fatorpos,6)
		endif	
	endif
	_npreco  :=sc6->c6_prcven
	_ntotal  :=_nvalor
endif

@ prow()+1,000 PSAY sc6->c6_item
@ prow(),003   PSAY left(sc6->c6_produto,6)+"-"+left(sb1->b1_desc,40)
@ prow(),051   PSAY sb1->b1_um
@ prow(),054   PSAY _nqtd picture "@E 999,999.99"
@ prow(),065   PSAY _npreco picture "@E 999,999.999999"
@ prow(),080   PSAY _ntotal picture "@E 999,999,999.99"
@ prow(),095   PSAY sc6->c6_descont picture "@E 99.99"
@ prow(),101   PSAY sc6->c6_tes
@ prow(),106   PSAY _npicm picture "99"
@ prow(),113   PSAY sc6->c6_promoc
@ prow(),119   PSAY sb1->b1_categ
@ prow(),121   PSAY _nprmax picture "@E 9999.99"

_nvalmerc+=_nvalor
_nvalmax += _nprmax*_nqtd
if ! empty(sf4->f4_formula)
	_i:=ascan(_amentes,sf4->f4_formula)
	if _i==0
		aadd(_amentes,sf4->f4_formula)
	endif
endif

if prow()>60
	@ 066,000 PSAY " "
	setprc(0,0)
endif

return

static function _improd()
if _limprime
	if _nrepasse>0
		@ prow()+1,000 PSAY "DESCONTO REF. REPASSE "+transform(_nprep,"@E 99.99")+"%"
		@ prow(),080   PSAY _nrepasse picture "@E 999,999,999.99"
	endif
	@ prow()+1,000 PSAY "TOTAL DAS MERCADORIAS"
	@ prow(),080   PSAY _nvalmerc picture "@E 999,999,999.99"
	@ prow(),115   PSAY _nvalmax picture "@E 999,999,999.99"	
	if _ndesczf>0
		@ prow()+1,000 PSAY "SUFRAMA "+sa1->a1_suframa+" - Deducao de 12% de ICMS"
		@ prow(),080   PSAY _ndesczf picture "@E 999,999,999.99"
		_nvalmerc-=_ndesczf
	endif
	@ prow()+2,000 PSAY "MENSAGENS DA NOTA FISCAL"
	for _i:=1 to len(_amentes)
		@ prow()+1,000 PSAY formula(_amentes[_i])
	next
	if ! empty(sc5->c5_menpad)
		@ prow()+1,000 PSAY formula(sc5->c5_menpad)
	endif
	if ! empty(sc5->c5_mennota)
		@ prow()+1,000 PSAY sc5->c5_mennota
	endif
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "     BASE ICMS     VALOR ICMS     BASE SUBS. VAL.ICMS SUBS.  TOTAL MERCAD.  TOTAL DA NOTA"
	@ prow()+1,000 PSAY _nbaseicm picture "@E 999,999,999.99"
	@ prow(),015   PSAY _nvalicm picture "@E 999,999,999.99"
	@ prow(),030   PSAY _nbaseret picture "@E 999,999,999.99"
	@ prow(),045   PSAY _nvalret picture "@E 999,999,999.99"
	@ prow(),060   PSAY _nvalmerc picture "@E 999,999,999.99"
	@ prow(),075   PSAY _nvalmerc+_nvalret picture "@E 999,999,999.99"
	if sc5->c5_geragnr=="S"
		@ prow()+2,000 PSAY "      BASE GNR      VALOR GNR"
		@ prow()+1,000 PSAY _nbasegnr picture "@E 999,999,999.99"
		@ prow(),015   PSAY _nvalgnr  picture "@E 999,999,999.99"
	endif
	@ prow()+1,000 PSAY replicate("-",limite)

	if _c==1
		@ 066,000 PSAY " "
		setprc(0,0)
	endif
endif
return

static function _vericm()
_nbaseicmp:=0
_nvalicmp :=0
if sf4->f4_icm=="S"
	if (sc5->c5_tipocli=="F" .and.;
		empty(sa1->a1_inscr)) .or. sf4->f4_tpmov="U"
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
		sc5->c5_tipocli<>"F" .and. sf4->f4_tpmov<>"U"
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
				_nbaseretp:=noround(_nvalst*(1+sf7->f7_margem/100),2)
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
aadd(_agrpsx1,{cperg,"01","Do pedido          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o pedido       ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Imprime            ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Pendencia"      ,space(30),space(15),"Liberado"       ,space(30),space(15),"Faturado"       ,space(30),space(15),"Total"          ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
DADOS DA EMPRESA									 DADOS DO CLIENTE
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | 999999/99-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    | PEDIDO No. 999999 (XXXXXXXXXXXXX)
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX              |
XXXXXXXXXXXXXXXXXXXX XX 99999-999        | XXXXXXXXXXXXXXXXXXXX XX 99999-999 TEL: XXXXXXXXXXXXXX | EMISSAO: 99/99/99
TEL: XXXXXXXXXXXXXX CGC: XXXXXXXXXXXXXX  | CGC: XXXXXXXXXXXXXX INSC.EST.: XXXXXXXXXXXXXX         |
DADOS DO PEDIDO
VENDEDOR.: 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX COMISSAO: 99,99%
TABELA...: 999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX DESCONTOS: 99,99%+99,99%+99,99%+99,99% DESC.ITENS: 99,99% PROMOCAO: X
COND.PGTO: 999-XXXXXXXXXXXXXXX TIPO CLIENTE: X TRANSPORTADORA: 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

It Produto                                         UM Quantidade    Preco unit.    Valor total Desc. TES ICMS Promocao Cat
99 999999-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx XX 999.999,99 999.999,999999 999.999.999,99 99,99 999  99     x     xxx

MENSAGENS DA NOTA FISCAL

     BASE ICMS     VALOR ICMS     BASE SUBS. VAL.ICMS SUBS.  TOTAL MERCAD.  TOTAL DA NOTA
999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99

      BASE GNR      VALOR GNR
999.999.999,99 999.999.999,99
*/