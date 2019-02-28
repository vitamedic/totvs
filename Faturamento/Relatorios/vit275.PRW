/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT275   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento de Vendas x Meta                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vit275()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="ACOMPANHAMENTO DE VENDAS X META"
cdesc1  :="Este programa ira emitir o acompanhamento de vendas X meta"
cdesc2  :=""
cdesc3  :=""
cstring :="SD2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT275"
wnrel   :="VIT275"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
lcontinua:=.t.
_carqtmp1  := ""
_cindtmp11 := ""
cperg:="PERGVIT275"
wcgRegiao := " "
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	return
endif



rptstatus({|| rptdetail()})

_cext:=trb1->(ordbagext())
trb1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp11+_cext)


return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao rptdetail     ³ Autor ³ Heraildo C. de Freitas³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ impressao do relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

_ameses:={}
_ddata:=mv_par01
while _ddata<=mv_par02
	aadd(_ameses,{strzero(month(_ddata),2)+"/"+strzero(year(_ddata),4),strzero(year(_ddata),4)+strzero(month(_ddata),2)})
	_ddata:=lastday(_ddata)+1
end

titulo:="ACOMPANHAMENTO DE VENDAS X META - PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
cabec1:=""
cabec2:=""

_cfilsa3:=xfilial("SA3")
_cfilsct:=xfilial("SCT")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")
_cfilsf4:=xfilial("SF4")

sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente := sa3->a3_cod
	wcgRegiao := sa3->A3_REGIAO
else
	_cgerente := space(6)
endif

processa({|| _geratmp()})

setregua(sa3->(lastrec()))

setprc(0,0)

_atotvend:={}
_atotreg :={}
_ntot22  :=0
_ntmeta  :=0
_ntvenda :=0
_lv22    :=.f.

_nmeses:=len(_ameses)
for _ni:=1 to _nmeses step 9
	cabec1:="Representante              Meta Geral "
	_acol:={}
	_nj:=_ni
	_nk:=1
	while _nk<=9 .and.;
		_nj<=_nmeses
		
		cabec1+="        "+_ameses[_nj,1]+"    %  "
		aadd(_acol,_ameses[_nj,2])
		_nj++
		_nk++
	end
	if _nk<=9
		cabec1+="     Venda Total   % "
		_ltotal:=.t.
	else
		_ltotal:=.f.
	endif
	
	_atot := array(len(_acol))
	_av22 := array(len(_acol))
	
	for _nj:=1 to len(_acol)
		_atot[_nj]:=0
		_av22[_nj]:=0
	next
	
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	
	TRB1->(dbgotop())
	while ! TRB1->(eof()) .and. lcontinua
		
		incregua()
		
		_nmetareg:=0
		_nmeta22 :=0
		
		_areg    := array(len(_acol))
		
		for _nj:=1 to len(_acol)
			_areg[_nj]:=0
		next
		
		@ prow()+1,000 PSAY " "
		
		_cregiao:=TRB1->regiao
		
		while ! TRB1->(eof()) .and.	TRB1->regiao==_cregiao .and. lcontinua
			
			if prow()==0 .or. prow()>56
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
			endif
			
			_cvendedor:=TRB1->vendedor
			
			@ prow()+1,000 PSAY TRB1->vendedor+"-"+substr(TRB1->nome,1,15)
			
			if TRB1->anomes=="000000" // META GERAL
				_nmeta:=TRB1->meta
				TRB1->(dbskip())
			else
				_nmeta:=0
			endif
			
			_nmetames:=_nmeta
					
			@ prow(),023 PSAY _nmetames picture "@E 999,999,999.99"
			
			_nmetareg+=_nmeta
			_ntmeta  +=_nmeta
			
			_ncol:=38
			while ! TRB1->(eof()) .and.	TRB1->regiao==_cregiao .and. TRB1->vendedor==_cvendedor .and. lcontinua
				
				while ! TRB1->(eof()) .and.	TRB1->regiao==_cregiao .and. TRB1->vendedor==_cvendedor .and. TRB1->anomes<_acol[1] .and. lcontinua
					TRB1->(dbskip())
				enddo
				
				for _nj:=1 to len(_acol)
					
					if ! TRB1->(eof()) .and. TRB1->regiao==_cregiao .and. TRB1->vendedor==_cvendedor
						
						_nk :=ascan(_acol,TRB1->anomes)
						
						if _nk<>_nj
							_nvenda:=0
						else
							_nvenda := TRB1->venda
							TRB1->(dbskip())
						endif
						
					else
						_nvenda:=0
					endif
					
					
					
					_nv:=ascan(_atotvend,{|x| x[1] == _cregiao + _cvendedor })
					
					if _nv==0
						aadd(_atotvend,{_cregiao + _cvendedor,_nvenda})
					else
						_atotvend[_nv,2]+=_nvenda
					endif
					
					_nr:=ascan(_atotreg,{|x| x[1]==_cregiao})
					
					if _nr==0
						aadd(_atotreg,{_cregiao,_nvenda})
					else
						_atotreg[_nr,2]+=_nvenda
					endif
					
					if _nmetames>0
						_nperc := round((_nvenda/_nmetames)*100,1)
					else
						_nperc := 0
					endif
					
					_ncol +=1
					@ prow(),_ncol PSAY _nvenda picture "@E 999,999,999.99"
					_ncol+=15
					@ prow(),_ncol PSAY _nperc picture "@E 9999.9%"
					_ncol+=6
					
					_areg[_nj]+=_nvenda
					_atot[_nj]+=_nvenda
					_ntvenda  +=_nvenda
				next
				
				if _ltotal
					_nv:=ascan(_atotvend,{|x| x[1]== _cregiao + _cvendedor})
					_nvenda:=_atotvend[_nv,2]
					if _nmeta>0
						_nperc:=round((_nvenda/_nmeta)*100,1)
					else
						_nperc:=0
					endif
					_ncol +=2
					@ prow(),_ncol PSAY _nvenda picture "@E 999,999,999.99"
					_ncol+=15
					@ prow(),_ncol PSAY _nperc picture "@E 9999.9%"
					//					_ncol+=5
					_ncol+=6
					
				endif
				
				while ! TRB1->(eof()) .and.	TRB1->regiao==_cregiao .and. TRB1->vendedor==_cvendedor .and. lcontinua
					TRB1->(dbskip())
				enddo
				
			enddo
		enddo
		
		_atotvend:={}  // Roberto Fiuza 26/05/14 zerar o total do vendedor porque estava acumulando o vendedor 000022-venda direta
		
		_nmetames:=_nmetareg
		
		@ prow()+1,000 PSAY "REGIAO "+_cregiao
		@ prow(),023   PSAY _nmetames picture "@E 999,999,999.99"
		
		_ncol:=38
		for _nj:=1 to len(_areg)
			if _nmetames>0
				_nperc:=round((_areg[_nj]/_nmetames)*100,1)
			else
				_nperc:=0
			endif
			_ncol +=1
			@ prow(),_ncol PSAY _areg[_nj] picture "@E 999,999,999.99"
			_ncol+=15
			@ prow(),_ncol PSAY _nperc picture "@E 9999.9%"
			_ncol+=6
		next
		if _ltotal
			_nr:=ascan(_atotreg,{|x| x[1]==_cregiao})
			if _nr>0
				_nvenda:=_atotreg[_nr,2]
			else
				_nvenda:=0
			endif
			if _nmetareg>0
				_nperc:=round((_nvenda/_nmetareg)*100,1)
			else
				_nperc:=0
			endif
			_ncol +=2
			@ prow(),_ncol PSAY _nvenda picture "@E 999,999,999.99"
			_ncol+=15
			@ prow(),_ncol PSAY _nperc picture "@E 9999.9%"
			_ncol+=5
		endif
	end
	
	_nmetames:=_ntmeta
	
	@ prow()+2,000 PSAY "TOTAL"
	@ prow(),023   PSAY _nmetames picture "@E 999,999,999.99"
	
	_ncol:=38
	for _nj:=1 to len(_atot)
		if _nmetames>0
			_nperc:=round((_atot[_nj]/_nmetames)*100,1)
		else
			_nperc:=0
		endif
		_ncol +=1
		@ prow(),_ncol PSAY _atot[_nj] picture "@E 999,999,999.99"
		_ncol+=15
		@ prow(),_ncol PSAY _nperc picture "@E 9999.9%"
		_ncol+=6
	next
	if _ltotal
		if _ntmeta>0
			_nperc:=round((_ntvenda/_ntmeta)*100,1)
		else
			_nperc:=0
		endif
		_ncol +=2
		@ prow(),_ncol PSAY _ntvenda picture "@E 999,999,999.99"
		_ncol+=15
		@ prow(),_ncol PSAY _nperc picture "@E 9999.9%"
		_ncol+=6
	endif
	
	_aresult:=array(len(_acol),2)
	
	if empty(_cgerente) .or. _cgerente > "001000"
		@ prow()+1,000 PSAY "OBJETIVO"
		_ntmeta := 0
		
		_ncol:=39
		for _nj:=1 to len(_acol)
			_cquery:=" SELECT"
			_cquery+=" SUM(CT_VALOR) META"
			
			_cquery+=" FROM "
			_cquery+=  retsqlname("SA3")+" SA3,"
			_cquery+=  retsqlname("SCT")+" SCT"
			
			_cquery+=" WHERE"
			_cquery+="     SA3.D_E_L_E_T_=' '"
			_cquery+=" AND SCT.D_E_L_E_T_=' '"
			_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
			_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"
			_cquery+=" AND CT_VEND=A3_COD"
			_cquery+=" AND CT_DATA BETWEEN '20140101' and '20141231'"
			
			// Considera se emitido por gerente regional ou representante
			if !empty(_cgerente) .and. _cgerente > "001000"
				_cquery+=" AND A3_SUPER='"+_cgerente+"'"
			elseif !empty(_cgerente) .and. _cgerente < "001000"
				_cquery+=" AND A3_COD='"+_cgerente+"'"
			else
				_cquery+=" AND CT_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
			EndIf
			_cquery+=" AND A3_REGIAO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
			_cquery+=" AND SUBSTR(CT_DATA,1,6)='"+_acol[_nj]+"'"
			
			
			
			_cquery:=changequery(_cquery)
			
			tcquery _cquery new alias "TMP2"
			tcsetfield("TMP2","META","N",12,2)
			
			tmp2->(dbgotop())
			
			@ prow(),_ncol PSAY tmp2->meta picture "@E 999,999,999.99"
			_ntmeta  += tmp2->meta
			
			_ncol+=22
			
			_aresult[_nj,1]:=_atot[_nj]-tmp2->meta
			_aresult[_nj,2]:=round((_atot[_nj]/tmp2->meta)*100,2)
			
			tmp2->(dbclosearea())
		next
		if _ltotal
			@ prow(),_ncol+1 PSAY _ntmeta  picture "@E 999,999,999.99"
			_ncol+=20
		endif
		
		@ prow()+1,000 PSAY "RESULTADO"
		
		_ncol:=39
		for _nj:=1 to len(_acol)
			@ prow(),_ncol PSAY _aresult[_nj,1] picture "@E 999,999,999.99"
			_ncol+=22
		next
		if _ltotal
			@ prow(),_ncol+1 PSAY _ntvenda-_ntmeta  picture "@E 999,999,999.99"
			_ncol+=22
		endif
		
		@ prow()+1,000 PSAY "VENDA X OBJETIVO"
		
		_ncol:=54
		for _nj:=1 to len(_acol)
			@ prow(),_ncol PSAY _aresult[_nj,2] picture "@E 9999.9%"
			_ncol+=22
		next
		if _ltotal
			@ prow(),_ncol+1 PSAY round((_ntvenda/_ntmeta)*100,2)  picture "@E 9999.9%"
			_ncol+=22
		endif
	endif
next

if prow()>0
	roda(cbcont,cbtxt)
endif

//TRB1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return()


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ _geratmp ³ Autor ³ Heraildo C. de Freitas³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera tabela temporaria                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

static function _geratmp()

Local aRegVend  := {}
Local a2RegVend := {}
procregua(1)

incproc("Calculando metas e vendas...")

sa3->(dbsetorder(1))

_cquery:=" SELECT"
_cquery+=" A3_REGIAO REGIAO,"
_cquery+=" CT_VEND VENDEDOR,"
_cquery+=" '000000' ANOMES,"
_cquery+=" A3_NREDUZ NOME,"
if len(_ameses) > 1
	_cquery+=" ROUND(SUM(CT_VALOR/"+  cValToChar(len(_ameses))+"),2) META,"
else
	_cquery+=" ROUND(SUM(CT_VALOR),2) META,"
endif
_cquery+=" 0 VENDA"

_cquery+=" FROM "
_cquery+=  retsqlname("SA3")+" SA3,"
_cquery+=  retsqlname("SCT")+" SCT"

_cquery+=" WHERE"
_cquery+="     SA3.D_E_L_E_T_=' '"
_cquery+=" AND SCT.D_E_L_E_T_=' '"
_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"
_cquery+=" AND CT_VEND=A3_COD"
//if mv_par07==2 //Nao mostra representantes inativos  // 09/06/14 todos os vendores deve esta ativo..os invativos esta entra na funcao fVdOutRep()
_cquery+=" AND A3_ATIVO<>'N'"
//endif
_cquery+=" AND CT_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
//_cquery+=" AND CT_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND CT_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND CT_PRODUTO=' '" // Considera somente metas de valores

_cquery+=" AND A3_REGIAO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

// Considera se emitido por gerente regional ou representante
if !empty(_cgerente) .and. _cgerente > "001000"
	_cquery+=" AND A3_SUPER='"+_cgerente+"'"
elseif !empty(_cgerente) .and. _cgerente < "001000"
	_cquery+=" AND A3_COD='"+_cgerente+"'"
EndIf

_cquery+=" GROUP BY"
_cquery+=" A3_REGIAO,"
_cquery+=" CT_VEND,"
_cquery+=" '000000',"
_cquery+=" A3_NREDUZ"




_MTcquery := _cquery + " ORDE BY VENDEDOR "
_MTcquery := changequery(_MTcquery)

memowrit("vit275.sql",_MTcquery)

if select("TMED")>0
	TMED->(dbclosearea())
endif

tcquery _cquery new alias "TMED"
tcsetfield("TMED","META" ,"N",14,2)
tcsetfield("TMED","VENDA","N",14,2)


_cquery+=" UNION ALL"

_cquery+=" SELECT SA31.A3_REGIAO REGIAO, F2_VEND1 VENDEDOR, SUBSTR(D2_EMISSAO,1,6) ANOMES, SA3.A3_NREDUZ NOME, 0 META, SUM(D2_TOTAL) VENDA"

_cquery+=" FROM "
_cquery+=  retsqlname("SA3")+" SA3,"
_cquery+=  retsqlname("SA3")+" SA31,"
_cquery+=  retsqlname("SD2")+" SD2,"
_cquery+=  retsqlname("SF2")+" SF2,"
_cquery+=  retsqlname("SF4")+" SF4"

_cquery+=" WHERE"
_cquery+="     SA3.D_E_L_E_T_=' '"
_cquery+=" AND SD2.D_E_L_E_T_=' '"
_cquery+=" AND SF2.D_E_L_E_T_=' '"
_cquery+=" AND SF4.D_E_L_E_T_=' '"
_cquery+=" AND SA3.A3_FILIAL='"+_cfilsa3+"'"
_cquery+=" AND SA31.A3_FILIAL='"+_cfilsa3+"'"
_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND D2_DOC=F2_DOC"
_cquery+=" AND D2_SERIE=F2_SERIE"
_cquery+=" AND F2_VEND1=SA3.A3_COD"
_cquery+=" AND F2_VEND1=SA31.A3_COD"  //_cquery+=" AND F2_VEND2=SA31.A3_COD"       ALTERADO RICARDO 31/03/2016
//if mv_par07==2 //Nao mostra representantes inativos   // // 09/06/14 todos os vendores deve esta ativo..os invativos esta entra na funcao fVdOutRep()
_cquery+=" AND SA31.A3_ATIVO<>'N'"
//endif
_cquery+=" AND D2_TES=F4_CODIGO"
_cquery+=" AND D2_TIPO IN ('N','C')"
_cquery+=" AND F4_DUPLIC='S'"
//_cquery+=" AND F4_ESTOQUE='S'"  //
_cquery+=" AND D2_EMISSAO     BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND F2_VEND1       BETWEEN '"+mv_par03      +"' AND '"+mv_par04+"'"
_cquery+=" AND SA31.A3_REGIAO BETWEEN '"+mv_par05      +"' AND '"+mv_par06+"'"

// Considera se emitido por gerente regional ou representante
if !empty(_cgerente) .and. _cgerente > "001000"
	_cquery+=" AND SA3.A3_SUPER='"+_cgerente+"'"
elseif !empty(_cgerente) .and. _cgerente < "001000"
	_cquery+=" AND SA3.A3_COD='"+_cgerente+"'"
EndIf

_cquery+=" GROUP BY"
_cquery+=" SA31.A3_REGIAO,"
_cquery+=" F2_VEND1,"
_cquery+=" SUBSTR(D2_EMISSAO,1,6),"
_cquery+=" SA3.A3_NREDUZ"

_cquery+=" ORDER BY"
_cquery+=" 1,2,3"


_cquery:=changequery(_cquery)
memowrit("vit275.sql",_cquery)

if select("TMP1")>0
	TMP1->(dbclosearea())
endif


tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","META" ,"N",14,2)
tcsetfield("TMP1","VENDA","N",14,2)


aStru:={}
aAdd (aStru, {"REGIAO"  ,	"C",	003,	0})
aAdd (aStru, {"VENDEDOR",	"C",	006,	0})
aAdd (aStru, {"ANOMES"  ,	"C",	006,	0})
aAdd (aStru, {"NOME"    ,	"C",	015,	0})
aAdd (aStru, {"META"    ,	"N",	014,	2})
aAdd (aStru, {"VENDA"   ,	"N",	014,	2})
aAdd (aStru, {"FLAG"    ,	"C",	001,	0})


_carqtmp1:=criatrab(aStru,.t.)
dbusearea(.t.,,_carqtmp1,"trb1",.f.,.f.)

_cindtmp11:=criatrab(,.f.)
_cchave   :="REGIAO+VENDEDOR+ANOMES"
trb1->(indregua("trb1",_cindtmp11,_cchave))

//trb1->(dbclearind())
//trb1->(dbsetindex(_cindtmp11))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and. lcontinua
	
	_nv := ascan(aRegVend,{|x| x[1]== tmp1->VENDEDOR + tmp1->ANOMES })
	
	if _nv==0  // tratamento para nao haver 2 regioes para um vendedor no periodo
		aadd(aRegVend ,{ tmp1->VENDEDOR + tmp1->ANOMES ,  tmp1->REGIAO , tmp1->VENDEDOR , tmp1->ANOMES})
	else
		if tmp1->VENDEDOR <> "000022"  // se nao for venda direta
			aadd(a2RegVend,{ tmp1->VENDEDOR + tmp1->ANOMES ,  tmp1->REGIAO , tmp1->VENDEDOR , tmp1->ANOMES})
		endif
	endif
	
	
	dbSelectArea("TRB1")
	RECLOCK("TRB1",.T.)
	REPLACE REGIAO    with   tmp1->REGIAO
	REPLACE VENDEDOR  with   tmp1->VENDEDOR
	REPLACE ANOMES    with   tmp1->ANOMES
	REPLACE NOME      with   tmp1->NOME
	REPLACE META      with   tmp1->META
	REPLACE VENDA     with   tmp1->VENDA
	MSUNLOCK()
	
	tmp1->(dbskip())
enddo




tmp1->(dbgotop())
while ! tmp1->(eof()) .and. lcontinua
	
	//*********************************************************************************************************
	// Inicio - Roberto Fiuza 03/06/14 Localiza vendas sem representante ou regiao para este vendedor no mes  *
	//*********************************************************************************************************
	// Este tratamento deve ser feito apenas qdo for impresso apenas 1 mes.
	// Qdo é para varios meses a query ja retorna os val
	if tmp1->VENDEDOR <> "000022"  // se nao for venda direta
		
		For Wx = 1  to Len(_ameses)
			
			_nv := ascan(a2RegVend,{|x| x[1]== tmp1->VENDEDOR + _ameses[Wx][2] })
			
			if _nv==0  //  se nao existir 2 regios para o vendedor no mesmo periodo
				dbselectarea("SA3")
				DbsetOrder(1) // Codigo do Vendedor
				dbSeek(xFilial("SA3")+ tmp1->VENDEDOR)
				_nvenda   := fVdOutRep( tmp1->VENDEDOR,A3_SUPER,_ameses[Wx][2] )
				if _nvenda > 0
					dbSelectArea("TRB1")
					dbSeek( tmp1->REGIAO + tmp1->VENDEDOR + _ameses[Wx][2] )
					if eof()
						RECLOCK("TRB1",.T.)
						REPLACE REGIAO    with   tmp1->REGIAO
						REPLACE VENDEDOR  with   tmp1->VENDEDOR
						REPLACE ANOMES    with   _ameses[Wx][2]
						REPLACE NOME      with   tmp1->NOME
						REPLACE META      with   tmp1->META
						REPLACE VENDA     with   _nvenda
						REPLACE FLAG      with  "x"
					else
						RECLOCK("TRB1",.F.)
						REPLACE  VENDA     with   VENDA //+ _nvenda      comentado .. tava duplicando no relatorio 03/05/2016
					endif
					MSUNLOCK()
				Endif
			Endif
		next
	endif
	
	//*********************************************************************************************************
	// Fim    - Roberto Fiuza 03/06/14 Localiza vendas sem representante ou regiao para este vendedor no mes  *
	//*********************************************************************************************************
	_cregiao   := tmp1->regiao
	_cvendedor := tmp1->vendedor
	while ! tmp1->(eof()) .and.	tmp1->regiao==_cregiao .and. tmp1->vendedor==_cvendedor    // vai para o proximo vendedor
		tmp1->(dbskip())
	enddo
enddo


// Qdo é para varios meses a query ja retorna os valores corretos
// entao deve excluir a duplicidade
if Len(_ameses) > 1
	For Wv = 1  to Len(a2RegVend)
		dbSelectArea("TRB1")  // regiao + vend + anomes
		dbSeek( a2RegVend[wv][2] + a2RegVend[wv][3] )
		do While ! eof() .and. REGIAO = a2RegVend[wv][2] .and. VENDEDOR  = a2RegVend[wv][3]
			if FLAG = 'x'
				RECLOCK("TRB1",.F.)
				REPLACE VENDA     with   0
				MSUNLOCK()
			endif
			skip
		enddo
	NEXT
ENDIF


// Localiza faturamento para o vendedor 000022(Venda direta) sem regiao
If empty(_cgerente)
	For Wx = 1  to Len(_ameses)
		_nvenda   := fVdOutRep( "000022" ,  , _ameses[Wx][2] )
		if _nvenda > 0
			dbSelectArea("TRB1")
			dbSeek( "SEM" + "000022" + _ameses[Wx][2] )
			if eof()
				RECLOCK("TRB1",.T.)
				REPLACE REGIAO    with   "SEM"
				REPLACE VENDEDOR  with   "000022"
				REPLACE ANOMES    with   _ameses[Wx][2]
				REPLACE NOME      with   "VENDA DIRETA"
				REPLACE META      with   0
				REPLACE VENDA     with   _nvenda
			else
				RECLOCK("TRB1",.F.)
				REPLACE  VENDA     with   VENDA + _nvenda
			endif
			MSUNLOCK()
		Endif
	next
endif

// Localiza faturamento para o vendedor 000022(Venda direta) qdo for selecionado apenas um gerente
If !empty(_cgerente) .and. _cgerente > "001000"
	For Wx = 1  to Len(_ameses)
		_nvenda   := fVdOutRep( "000022" ,_cgerente, _ameses[Wx][2] )
		if _nvenda > 0
			dbSelectArea("TRB1")
			dbSeek( wcgRegiao + "000022" + _ameses[Wx][2] )
			if eof()
				RECLOCK("TRB1",.T.)
				REPLACE REGIAO    with   wcgRegiao
				REPLACE VENDEDOR  with   "000022"
				REPLACE ANOMES    with   _ameses[Wx][2]
				REPLACE NOME      with   "VENDA DIRETA"
				REPLACE META      with   0
				REPLACE VENDA     with   _nvenda
			else
				RECLOCK("TRB1",.F.)
				REPLACE  VENDA     with   VENDA + _nvenda
			endif
			MSUNLOCK()
		Endif
	next
Endif




return()


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao fVdOutRep     ³ Autor ³ Heraildo C. de Freitas³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera tabela temporaria                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

static function fVdOutRep(wVend,wSupAtu,wAnoMes)

if select("TPREP")>0
	TPREP->(dbclosearea())
endif


_cquery:= " SELECT SUM(D2_TOTAL) VENDA"
_cquery+=" FROM "
_cquery+=  retsqlname("SD2")+" SD2,"
_cquery+=  retsqlname("SF2")+" SF2,"
_cquery+=  retsqlname("SF4")+" SF4"
_cquery+=" WHERE"
_cquery+="     SD2.D_E_L_E_T_=' '"
_cquery+=" AND SF2.D_E_L_E_T_=' '"
_cquery+=" AND SF4.D_E_L_E_T_=' '"
_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND D2_DOC   = F2_DOC"
_cquery+=" AND D2_SERIE = F2_SERIE"

IF wVend = "000022" .AND. EMPTY(wSupAtu)       // venda direta sem regiao
	_cquery+=" AND F2_VEND1 = '"+wVend+"'"
	_cquery+=" AND F2_VEND2 = '  '"
elseIF wVend = "000022" .AND. !EMPTY(wSupAtu)  // venda direta qdo for selecionado apenas um gerente
	_cquery+=" AND F2_VEND1 = '"+wVend+"'"
	_cquery+=" AND F2_VEND2 = '"+wSupAtu+"'"
ELSE
	_cquery+=" AND F2_VEND1 = '"+wVend+"'"
	_cquery+=" AND F2_VEND2<> '"+wSupAtu+"'"
ENDIF

_cquery+=" AND D2_TES  = F4_CODIGO"
_cquery+=" AND D2_TIPO IN ('N','C')"
_cquery+=" AND F4_DUPLIC ='S'"
//_cquery+=" AND F4_ESTOQUE='S'"
_cquery+=" AND SUBSTR(D2_EMISSAO,1,6) = '"+wAnoMes+"'"

_cquery:=changequery(_cquery)

memowrit("vit275SemRep.sql",_cquery)

tcquery _cquery new alias "TPREP"

Return TPREP->VENDA

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao fVdSemVen     ³ Autor ³ Heraildo C. de Freitas³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera tabela temporaria faturmanto sem vendedor             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

static function fVdSemVen()

if select("TPSEM")>0
	TPSEM->(dbclosearea())
endif


_cquery:= " SELECT SUM(D2_TOTAL) VENDA"
_cquery+=" FROM "
_cquery+=  retsqlname("SD2")+" SD2,"
_cquery+=  retsqlname("SF2")+" SF2,"
_cquery+=  retsqlname("SF4")+" SF4"
_cquery+=" WHERE"
_cquery+="     SD2.D_E_L_E_T_=' '"
_cquery+=" AND SF2.D_E_L_E_T_=' '"
_cquery+=" AND SF4.D_E_L_E_T_=' '"
_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND D2_DOC   = F2_DOC"
_cquery+=" AND D2_SERIE = F2_SERIE"
_cquery+=" AND F2_VEND1 = '      '"
_cquery+=" AND D2_TES  = F4_CODIGO"
_cquery+=" AND D2_TIPO IN ('N','C')"
_cquery+=" AND F4_DUPLIC ='S'"
//_cquery+=" AND F4_ESTOQUE='S'"
_cquery+=" AND SUBSTR(D2_EMISSAO,1,6) = '"+TEMP1->ANOMES+"'"

_cquery:=changequery(_cquery)

memowrit("vit275SemRep.sql",_cquery)

tcquery _cquery new alias "TPSEM"

Return TPSEM->VENDA




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ _pergsx1 ³ Autor ³ Heraildo C. de Freitas³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera tabela sx1                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data                      ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data                   ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do representante             ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o representante          ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Da regiao                    ?","mv_ch5","C",03,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a regiao                 ?","mv_ch6","C",03,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Mostra representante inativo ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
return()

/*
Representante              Meta Geral        99/9999   %         99/9999   %         99/9999   %         99/9999   %         99/9999   %         99/9999   %         99/9999   %         99/9999   %     Venda Total   %
999999-XXXXXXXXXXXXXXX 999,999,999.99 999,999,999.99 9999 999,999,999.99 9999 999,999,999.99 9999 999,999,999.99 9999 999,999,999.99 9999 999,999,999.99 9999 999,999,999.99 9999 999,999,999.99 9999 999,999,999.99 9999
*/


