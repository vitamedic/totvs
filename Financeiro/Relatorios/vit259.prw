/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT259   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 02/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Posicao da Cobranca por Linha (Farma/Licitacao/Economica)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit259()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="POSICAO DA COBRANCA POR LINHA (FARMA/LICITACAO/ECONOMICA)"
cdesc1   :="Este programa ira emitir a posicao da cobranca por linha"
cdesc2   :="(FARMA / LICITACAO / ECONOMICA)"
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT259"
wnrel    :="VIT259"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT259"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.t.,"",.f.,tamanho,"",.f.)

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

cabec1:="                       FARMA             LICITACAO FARMA      LICITACAO ECONOMICA           OUTROS        "
cabec2:="TIPO                   VALOR   %              VALOR   %              VALOR   %              VALOR   %              TOTAL"

_cfilda0:=xfilial("DA0")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsd2:=xfilial("SD2")
_cfilse1:=xfilial("SE1")
_cfilsf2:=xfilial("SF2")

_avalores:=array(2,4)
for _ni:=1 to 2
	for _nj:=1 to 4
		_avalores[_ni,_nj]:=0
	next
next

processa({|| _geratmp()})

setprc(0,0)

setregua(se1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	
	incregua()
	
	if tmp1->e1_fatura=="NOTFAT" // FATURAS
		
		_ntotfat:=0
		se1->(dbsetorder(1))
		se1->(dbseek(_cfilse1+tmp1->e1_prefixo+tmp1->e1_num))
		while ! se1->(eof()) .and.;
			se1->e1_filial==_cfilse1 .and.;
			se1->e1_prefixo==tmp1->e1_prefixo .and.;
			se1->e1_num==tmp1->e1_num
			
			if se1->e1_tipo==tmp1->e1_tipo
				_ntotfat+=se1->e1_valor
			endif
			
			se1->(dbskip())
		end
		
		_nfatorf:=tmp1->e1_valor/_ntotfat // FATOR DE MULTIPLICACAO PARA QUANDO HOUVER MAIS DE UMA PARCELA NA FATURA
		
		_nfator1:=(tmp1->e1_saldo/tmp1->e1_valor)*_nfatorf // FATOR DE MULTIPLICACAO PARA QUANDO HOUVER BAIXA PARCIAL
		
		se1->(dbordernickname("SE1VIT01"))
		se1->(dbseek(_cfilse1+tmp1->e1_prefixo+tmp1->e1_num))
		
		while ! se1->(eof()) .and.;
			se1->e1_filial==_cfilse1 .and.;
			se1->e1_fatpref==tmp1->e1_prefixo .and.;
			se1->e1_fatura==tmp1->e1_num
			
			if se1->e1_tipofat==tmp1->e1_tipo
				
				sd2->(dbsetorder(3))
				if sd2->(dbseek(_cfilsd2+se1->e1_num+se1->e1_serie))
					
					sf2->(dbsetorder(1))
					sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
					_nfator2:=se1->e1_valor/sf2->f2_valfat // FATOR DE MULTIPLICACAO PARA QUANDO HOUVER MAIS DE UMA PARCELA
					
					while ! sd2->(eof()) .and.;
						sd2->d2_filial==_cfilsd2 .and.;
						sd2->d2_doc==se1->e1_num .and.;
						sd2->d2_serie==se1->e1_serie
						
						sc5->(dbsetorder(1))
						sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
						da0->(dbsetorder(1))
						da0->(dbseek(_cfilda0+sc5->c5_tabela))
						
						if da0->da0_status$"LR" // LICITACAO
							sb1->(dbsetorder(1))
							sb1->(dbseek(_cfilsb1+sd2->d2_cod))
							if sb1->b1_apreven=="1" // FARMA
								if tmp1->e1_vencrea<ddatabase // VENCIDO
									_avalores[1,2]+=((sd2->d2_total+sd2->d2_icmsret)*_nfator2)*_nfator1
								else // A VENCER
									_avalores[2,2]+=((sd2->d2_total+sd2->d2_icmsret)*_nfator2)*_nfator1
								endif
							else // ECONOMICA
								if tmp1->e1_vencrea<ddatabase // VENCIDO
									_avalores[1,3]+=((sd2->d2_total+sd2->d2_icmsret)*_nfator2)*_nfator1
								else // A VENCER
									_avalores[2,3]+=((sd2->d2_total+sd2->d2_icmsret)*_nfator2)*_nfator1
								endif
							endif
						else // FARMA
							if tmp1->e1_vencrea<ddatabase // VENCIDO
								_avalores[1,1]+=((sd2->d2_total+sd2->d2_icmsret)*_nfator2)*_nfator1
							else // A VENCER
								_avalores[2,1]+=((sd2->d2_total+sd2->d2_icmsret)*_nfator2)*_nfator1
							endif
						endif
						sd2->(dbskip())
					end
				else // OUTROS
					if tmp1->e1_vencrea<ddatabase // VENCIDO
						_avalores[1,4]+=se1->e1_valor*_nfator1
					else // A VENCER
						_avalores[2,4]+=se1->e1_valor*_nfator1
					endif
				endif
			endif
			se1->(dbskip())
		end
	else
		if tmp1->e1_vencrea<ddatabase // VENCIDO
			if tmp1->e1_tipo$'RA /NCC' .or. right(tmp1->e1_tipo,3,1)='-' // RECEBIMENTO ANTECIPADO, NOTA DE CREDITO OU ABATIMENTO
				_avalores[1,4]+=tmp1->e1_saldo*(-1)
			else
				_avalores[1,4]+=tmp1->e1_saldo
			endif
		else // A VENCER
			if tmp1->e1_tipo$'RA /NCC' .or. right(tmp1->e1_tipo,3,1)='-' // RECEBIMENTO ANTECIPADO, NOTA DE CREDITO OU ABATIMENTO
				_avalores[2,4]+=tmp1->e1_saldo*(-1)
			else
				_avalores[2,4]+=tmp1->e1_saldo
			endif
		endif
	endif
	
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
	
	tmp1->(dbskip())
end

if lcontinua
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	
	_ntvenc :=_avalores[1,1]+_avalores[1,2]+_avalores[1,3]+_avalores[1,4]
	_ntavenc:=_avalores[2,1]+_avalores[2,2]+_avalores[2,3]+_avalores[2,4]
	_ntgeral:=_ntvenc+_ntavenc
	
	@ prow()+1,000 PSAY "VENCIDOS"
	@ prow(),014   PSAY round(_avalores[1,1],2)               picture "@E 999,999,999.99"
	@ prow(),029   PSAY round((_avalores[1,1]/_ntvenc)*100,2) picture "@E 999.99%"
	@ prow(),037   PSAY round(_avalores[1,2],2)               picture "@E 999,999,999.99"
	@ prow(),052   PSAY round((_avalores[1,2]/_ntvenc)*100,2) picture "@E 999.99%"
	@ prow(),060   PSAY round(_avalores[1,3],2)               picture "@E 999,999,999.99"
	@ prow(),075   PSAY round((_avalores[1,3]/_ntvenc)*100,2) picture "@E 999.99%"
	@ prow(),083   PSAY round(_avalores[1,4],2)               picture "@E 999,999,999.99"
	@ prow(),098   PSAY round((_avalores[1,4]/_ntvenc)*100,2) picture "@E 999.99%"
	@ prow(),106   PSAY round(_ntvenc,2)                      picture "@E 999,999,999.99"
	
	@ prow()+1,000 PSAY "A VENCER"
	@ prow(),014   PSAY round(_avalores[2,1],2)                picture "@E 999,999,999.99"
	@ prow(),029   PSAY round((_avalores[2,1]/_ntavenc)*100,2) picture "@E 999.99%"
	@ prow(),037   PSAY round(_avalores[2,2],2)                picture "@E 999,999,999.99"
	@ prow(),052   PSAY round((_avalores[2,2]/_ntavenc)*100,2) picture "@E 999.99%"
	@ prow(),060   PSAY round(_avalores[2,3],2)                picture "@E 999,999,999.99"
	@ prow(),075   PSAY round((_avalores[2,3]/_ntavenc)*100,2) picture "@E 999.99%"
	@ prow(),083   PSAY round(_avalores[2,4],2)                picture "@E 999,999,999.99"
	@ prow(),098   PSAY round((_avalores[2,4]/_ntavenc)*100,2) picture "@E 999.99%"
	@ prow(),106   PSAY round(_ntavenc,2)                      picture "@E 999,999,999.99"
	
	@ prow()+1,000 PSAY "INADIMPLENCIA %"
	@ prow(),029   PSAY round((_avalores[1,1]/(_avalores[1,1]+_avalores[2,1]))*100,2) picture "@E 999.99%"
	@ prow(),052   PSAY round((_avalores[1,2]/(_avalores[1,2]+_avalores[2,2]))*100,2) picture "@E 999.99%"
	@ prow(),075   PSAY round((_avalores[1,3]/(_avalores[1,3]+_avalores[2,3]))*100,2) picture "@E 999.99%"
	@ prow(),098   PSAY round((_avalores[1,4]/(_avalores[1,4]+_avalores[2,4]))*100,2) picture "@E 999.99%"
	@ prow(),114   PSAY round((_ntvenc/_ntgeral)*100,2)                               picture "@E 999.99%"
	
	@ prow()+1,000 PSAY "TOTAL GERAL"
	@ prow(),014   PSAY round(_avalores[1,1]+_avalores[2,1],2)                  picture "@E 999,999,999.99"
	@ prow(),029   PSAY round(((_avalores[1,1]+_avalores[2,1])/_ntgeral)*100,2) picture "@E 999.99%"
	@ prow(),037   PSAY round(_avalores[1,2]+_avalores[2,2],2)                  picture "@E 999,999,999.99"
	@ prow(),052   PSAY round(((_avalores[1,2]+_avalores[2,2])/_ntgeral)*100,2) picture "@E 999.99%"
	@ prow(),060   PSAY round(_avalores[1,3]+_avalores[2,3],2)                  picture "@E 999,999,999.99"
	@ prow(),075   PSAY round(((_avalores[1,3]+_avalores[2,3])/_ntgeral)*100,2) picture "@E 999.99%"
	@ prow(),083   PSAY round(_avalores[1,4]+_avalores[2,4],2)                  picture "@E 999,999,999.99"
	@ prow(),098   PSAY round(((_avalores[1,4]+_avalores[2,4])/_ntgeral)*100,2) picture "@E 999.99%"
	@ prow(),106   PSAY round(_ntgeral,2)                                       picture "@E 999,999,999.99"
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
endif
ms_flush()
return

static function _geratmp()
procregua(1)
incproc("Selecionando titulos...")

_cquery:=" SELECT"
_cquery+=" E1_PREFIXO,"
_cquery+=" E1_NUM,"
_cquery+=" E1_PARCELA,"
_cquery+=" E1_TIPO,"
_cquery+=" E1_SERIE,"
_cquery+=" E1_VENCREA,"
_cquery+=" E1_VALOR,"
_cquery+=" E1_SALDO,"
_cquery+=" E1_FATURA"

_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1"

_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_SALDO>0"
_cquery+=" AND E1_TIPO<>'PR '"
_cquery+=" AND E1_VENCREA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"

_cquery+=" ORDER BY"
_cquery+=" 1,2,3,4"

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","E1_VENCREA","D")
tcsetfield("TMP1","E1_VALOR"  ,"N",12,2)
tcsetfield("TMP1","E1_SALDO"  ,"N",12,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do vencto. real    ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o vencto. real ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
FARMA             LICITACAO FARMA      LICITACAO ECONOMICA           OUTROS
TIPO                   VALOR   %              VALOR   %              VALOR   %              VALOR   %              TOTAL
VENCIDOS      999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99
A VENCER      999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99
INADIMPLENCIA %              999,99%                999,99%                999,99%                999,99%         999,99%
TOTAL GERAL   999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99 999,99% 999.999.999,99
*/
