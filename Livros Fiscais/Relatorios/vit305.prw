/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT305   ³Autor ³ Heraildo C. de Freitas  ³Data ³ 28/12/06 ³±±
±±³          ³          ³Autor ³ Reuber Abdias M. Jr.    ³Data ³ 28/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Livro CIAP Modelo C                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "topconn.ch"
#include "rwmake.ch"

user function vit305()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="LIVRO CIAP MODELO C"
cdesc1   :="Este programa ira emitir o Livro CIAP modelo C"
cdesc2   :=""
cdesc3   :=""
cstring  :="SF9"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT305"
wnrel    :="VIT305"+Alltrim(cusername)
aordem   :={}
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT305"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
nordem:=areturn[8]
if nlastkey==27
	set filter to
	return
endif
rptstatus({|| rptdetail()})
return()

static function rptdetail()
m_pag :=mv_par03

_cfilsf3:=xfilial("SF3")
_cfilsf9:=xfilial("SF9")
_cfilsfa:=xfilial("SFA")

_ddataini:=ctod("01/01/"+strzero(mv_par02-4,4))
_ddatafim:=lastday(ctod("01/"+strzero(mv_par01,2)+"/"+strzero(mv_par02,4)))

processa({|| _geratmp()})

setprc(0,0)

setregua(0)

_nacum:=0
_nmesbaixa:=1
_ameses:=array(mv_par01)              
_dtsaldoant:=ctod("31/12/"+strzero(mv_par02-1,4))       

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	
	if prow()==0 .or. prow()>60
		if prow()>60
			@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
			@ 66,00 psay " "
			setprc(0,0)  
			eject
		endif
		_impcab1()
		_impcab2()
	endif
	
	// ACUMULANDO O SALDO COM DATAS ANTERIORES
	while ! tmp1->(eof()) .and.; 
	   tmp1->dtmov <= _dtsaldoant
   	_nacum+=tmp1->valor-tmp1->baixa  
 	   tmp1->(dbskip())
	enddo 
	@ prow()+1,000 psay "|"
	@ prow(),009   psay "|"
	@ prow(),021   psay "|"
	@ prow(),031   psay "|"
	@ prow(),033   psay 'SALDO ANTERIOR'
	@ prow(),074   psay "|"
	@ prow(),093   psay "|"
	@ prow(),112   psay "|"
	@ prow(),114   psay _nacum picture "@E 9,999,999,999.99"
	@ prow(),131   psay "|"
	
	
	_nacum+=tmp1->valor-tmp1->baixa
	
	
	
	@ prow()+1,000 psay "|"
	@ prow(),002   psay tmp1->codigo
	@ prow(),009   psay "|"
	@ prow(),011   psay tmp1->dtmov
	@ prow(),021   psay "|"
	@ prow(),023   psay tmp1->nota
	@ prow(),031   psay "|"
	@ prow(),033   psay substr(tmp1->descri,1,40)
	@ prow(),074   psay "|"
	@ prow(),076   psay tmp1->valor picture "@E 9,999,999,999.99"
	@ prow(),093   psay "|"
	@ prow(),095   psay tmp1->baixa picture "@E 9,999,999,999.99"
	@ prow(),112   psay "|"
	@ prow(),114   psay _nacum picture "@E 9,999,999,999.99"
	@ prow(),131   psay "|"
	
	if labortprint
		@ prow()+2,000 psay "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
	tmp1->(dbskip())
	
	if (month(tmp1->dtmov)>=_nmesbaixa .and.;
		year(tmp1->dtmov)==mv_par02) .or. tmp1->(eof())
		
		if tmp1->(eof())
			_nmesfim:=mv_par01
		else
			_nmesfim:=month(tmp1->dtmov)
		endif
		
		while _nmesbaixa<=_nmesfim
			
			if _nmesbaixa>1
				_ameses[_nmesbaixa-1]:=_nacum
			endif
			
			_ddtbaixa :=ctod("01/"+strzero(_nmesbaixa,2)+"/"+strzero(mv_par02,4))
			_dbaixaini:=ctod("01/"+strzero(_nmesbaixa,2)+"/"+strzero(mv_par02-4,4))
			_dbaixafim:=lastday(_dbaixaini)
			
			_cquery:=" SELECT"
			_cquery+=" F9_CODIGO CODIGO,"
			_cquery+=" F9_DOCNFE NOTA,"
			_cquery+=" F9_DESCRI DESCRI,"
			_cquery+=" F9_VALICMS BAIXA"
			
			_cquery+=" FROM "
			_cquery+=  retsqlname("SF9")+" SF9"
			
			_cquery+=" WHERE"
			_cquery+="     SF9.D_E_L_E_T_=' '"
			_cquery+=" AND F9_FILIAL='"+_cfilsf9+"'"
			_cquery+=" AND F9_DTENTNE BETWEEN '"+dtos(_dbaixaini)+"' AND '"+dtos(_dbaixafim)+"'"
			_cquery+=" AND (F9_DTEMINS='        ' OR F9_DTEMINS>'"+dtos(_ddatafim)+"')"
			
			_cquery+=" ORDER BY"
			_cquery+=" 1"
			
			_cquery:=changequery(_cquery)
			
			tcquery _cquery new alias "TMP2"
			tcsetfield("TMP2","BAIXA","N",13,2)
			
			tmp2->(dbgotop())
			while ! tmp2->(eof())
				
				if prow()==0 .or. prow()>60
					if prow()>60
						@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
						@ 66,00 psay " "
						setprc(0,0)    
						eject						
					endif
					_impcab1()
					_impcab2()
				endif
				
				_nacum-=tmp2->baixa
				
				@ prow()+1,000 psay "|"
				@ prow(),002   psay tmp2->codigo
				@ prow(),009   psay "|"
				@ prow(),011   psay _ddtbaixa
				@ prow(),021   psay "|"
				@ prow(),023   psay tmp2->nota
				@ prow(),031   psay "|"
				@ prow(),033   psay substr(tmp2->descri,1,40)
				@ prow(),074   psay "|"
				@ prow(),076   psay 0           picture "@E 9,999,999,999.99"
				@ prow(),093   psay "|"
				@ prow(),095   psay tmp2->baixa picture "@E 9,999,999,999.99"
				@ prow(),112   psay "|"
				@ prow(),114   psay _nacum picture "@E 9,999,999,999.99"
				@ prow(),131   psay "|"
				
				tmp2->(dbskip())
			end
			tmp2->(dbclosearea())
			
			_nmesbaixa++
		end
	endif
			
	_ameses[mv_par01]:=_nacum
end
tmp1->(dbclosearea())

if prow()>0
	@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
	@ prow()+1,000 psay " "
	if prow()>40
		@ 66,00 psay " "
		setprc(0,0)
		eject
		_impcab1()
	endif
	
	@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
	@ prow()+1,000 psay "| 3 - DEMONSTRATIVO DA APURACAO DO CREDITO A SER EFETIVAMENTE APROPRIADO                                                           |"
	@ prow()+1,000 psay "|----------------------------------------------------------------------------------------------------------------------------------|"
	@ prow()+1,000 psay "|           |   OPERACOES E PRESTACOES ( SAIDAS )   |                      |   SALDO ACUMULADO   |          |                      |"
	@ prow()+1,000 psay "|           |---------------------------------------|     COEFICIENTE      |  (BASE DO CREDITO   |          |        CREDITO       |"
	@ prow()+1,000 psay "|    MES    |    TRIBUTADAS E   |       TOTAL       |         DE           |        A SER        |  FRACAO  |         A SER        |"
	@ prow()+1,000 psay "|           |     EXPORTACAO    |     DAS SAIDAS    |     CREDITAMENTO     |     APROPRIADO)     |  MENSAL  |      APROPRIADO      |"
	@ prow()+1,000 psay "|           |        (1)        |        (2)        |     (3 = 1 / 2)      |         (4)         |    (5)   |    (6 = 3 X 4 X 5)   |"
	@ prow()+1,000 psay "|-----------+-------------------+-------------------+----------------------+---------------------+----------+----------------------|"
	
	_nmes:=1
	_dfisini:=ctod("01/01/"+strzero(mv_par02,4))
	while _dfisini<=_ddatafim
		_dfisfim:=lastday(_dfisini)
		
		_cquery:=" SELECT"
		_cquery+=" SUM(F3_VALCONT) F3_VALCONT,"
		_cquery+=" SUM(F3_BASEICM) F3_BASEICM"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SF3")+" SF3"
		
		_cquery+=" WHERE"
		_cquery+="     SF3.D_E_L_E_T_=' '"
		_cquery+=" AND F3_FILIAL='"+_cfilsf3+"'"
		_cquery+=" AND F3_ENTRADA BETWEEN '"+dtos(_dfisini)+"' AND '"+dtos(_dfisfim)+"'"
		_cquery+=" AND F3_CFO>'5'"
		_cquery+=" AND F3_DTCANC='        '"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		u_setfield("TMP2")
		
		tmp2->(dbgotop())
		_nvalcont:=tmp2->f3_valcont
		_nbaseicm:=tmp2->f3_baseicm
		tmp2->(dbclosearea())
/*		
		_ndiaini:=day(_dfisini)
		if month(_dfisini)==12
			_nmesini:=1
			_nanoini:=year(_dfisini)-3
		else
			_nmesini:=month(_dfisini)+1
			_nanoini:=year(_dfisini)-4
		endif
		_ddataini:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini,2)+"/"+strzero(_nanoini,4))
		
		_cquery:=" SELECT"
		_cquery+=" SUM(F9_VALICMS) F9_VALICMS"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SF9")+" SF9"
		
		_cquery+=" WHERE"
		_cquery+="     SF9.D_E_L_E_T_=' '"
		_cquery+=" AND F9_FILIAL='"+_cfilsf9+"'"
		_cquery+=" AND F9_DTENTNE BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_dfisfim)+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		u_setfield("TMP2")
		
		tmp2->(dbgotop())
		_nvalicms:=tmp2->f9_valicms
		tmp2->(dbclosearea())
		
		_cquery:=" SELECT"
		_cquery+=" SUM(F9_BXICMS) F9_BXICMS"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SF9")+" SF9"
		
		_cquery+=" WHERE"
		_cquery+="     SF9.D_E_L_E_T_=' '"
		_cquery+=" AND F9_FILIAL='"+_cfilsf9+"'"
		_cquery+=" AND F9_DTEMINS BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_dfisfim)+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		u_setfield("TMP2")
		
		tmp2->(dbgotop())
		_nbxicms:=tmp2->f9_bxicms
		tmp2->(dbclosearea())
*/		
		_cquery:=" SELECT"
		_cquery+=" SUM(FA_VALOR) FA_VALOR"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SFA")+" SFA"
		
		_cquery+=" WHERE"
		_cquery+="     SFA.D_E_L_E_T_=' '"
		_cquery+=" AND FA_FILIAL='"+_cfilsfa+"'"
		_cquery+=" AND FA_DATA BETWEEN '"+dtos(_dfisini)+"' AND '"+dtos(_dfisfim)+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		u_setfield("TMP2")
		
		tmp2->(dbgotop())
		_nvalcred:=tmp2->fa_valor
		tmp2->(dbclosearea())
		
		@ prow()+1,000 psay "|"
		@ prow(),002   psay upper(mesextenso(_dfisini))
		@ prow(),012   psay "|"
		@ prow(),014   psay _nbaseicm picture "@E 99,999,999,999.99"
		@ prow(),032   psay "|"
		@ prow(),034   psay _nvalcont picture "@E 99,999,999,999.99"
		@ prow(),052   psay "|"
		@ prow(),059   psay _nbaseicm/_nvalcont picture "@E 999.9999"
		@ prow(),075   psay "|"
//		@ prow(),079   psay _nvalicms-_nbxicms picture "@E 99,999,999,999.99"
		@ prow(),079   psay _ameses[_nmes] picture "@E 99,999,999,999.99"
		@ prow(),097   psay "|"
		@ prow(),101   psay "1/48"
		@ prow(),108   psay "|"
		@ prow(),113   psay _nvalcred picture "@E 99,999,999,999.99"
		@ prow(),131   psay "|"
		
		_nmes++
		_dfisini:=_dfisfim+1
	end
	@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
endif

set device to screen

setpgeject(.f.)
if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return()

static function _impcab1()
@ 000,000      psay avalimp(limite)
@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
@ prow()+1,000 psay "|                                      CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                      |"
@ prow()+1,000 psay "|                                                             MODELO C                                                             |"
@ prow()+1,000 psay "| Ano:"
@ prow(),007   psay strzero(mv_par02,4)
@ prow(),119   psay "Folha:"
@ prow(),126   psay strzero(m_pag,4)
@ prow(),131   psay "|"
@ prow()+1,000 psay "|----------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 psay "| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                |"
@ prow()+1,000 psay "|----------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 psay "|Nome:"
@ prow(),007   psay substr(sm0->m0_nomecom,1,40)
@ prow(),048   psay "C.N.P.J. No:"
@ prow(),061   psay sm0->m0_cgc picture "@R 99.999.999/9999-99"
@ prow(),081   psay "Inscricao Estadual No:"
@ prow(),104   psay substr(sm0->m0_insc,1,14)
@ prow(),131   psay "|"
@ prow()+1,000 psay "|Endereco:"
@ prow(),011   psay substr(sm0->m0_endent,1,30)
@ prow(),050   psay "Bairro:"
@ prow(),058   psay substr(sm0->m0_bairent,1,20)
@ prow(),081   psay "Municipio:"
@ prow(),092   psay substr(sm0->m0_cident,1,20)
@ prow(),131   psay "|"
@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
@ prow()+1,000 psay " "
m_pag++
return()

static function _impcab2()
@ prow()+1,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
@ prow()+1,000 psay "| 2 - DEMONSTRATIVO DA BASE DO CREDITO A SER APROPRIADO                                                                            |"
@ prow()+1,000 psay "|----------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 psay "|                          IDENTIFICACAO DO BEM                           |                      VALOR DO ICMS                     |"
@ prow()+1,000 psay "|-------------------------------------------------------------------------+--------------------------------------------------------|"
@ prow()+1,000 psay "| No. ou |           |  Nota   |                                          |      Entrada     |  Saida,Baixa ou  | Saldo  Acumulado |"
@ prow()+1,000 psay "| Codigo |   Data    | Fiscal  |            Descricao Resumida            | (Credito Passivel|      Perda       |Base do Credito a |"
@ prow()+1,000 psay "|        |           |         |                                          |  de Apropriacao) |Deducao de Credito|  ser Apropriado  |"
@ prow()+1,000 psay "|--------+-----------+---------+------------------------------------------+------------------+------------------+------------------|"
return()

static function _geratmp()
procregua(0)

incproc("Selecionando registros...")

_cquery:=" SELECT"
_cquery+=" F9_CODIGO CODIGO,"
_cquery+=" F9_DTENTNE DTMOV,"
_cquery+=" F9_DOCNFE NOTA,"
_cquery+=" F9_DESCRI DESCRI,"
_cquery+=" F9_VALICMS VALOR,"
_cquery+=" 0 BAIXA"

_cquery+=" FROM "
_cquery+=  retsqlname("SF9")+" SF9"

_cquery+=" WHERE"
_cquery+="     SF9.D_E_L_E_T_=' '"
_cquery+=" AND F9_FILIAL='"+_cfilsf9+"'"
_cquery+=" AND F9_DTENTNE BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"

_cquery+=" UNION ALL"

_cquery+=" SELECT"
_cquery+=" F9_CODIGO CODIGO,"
_cquery+=" F9_DTEMINS DTMOV,"
_cquery+=" F9_DOCNFS NOTA,"
_cquery+=" F9_DESCRI DESCRI,"
_cquery+=" 0 VALOR,"
_cquery+=" F9_BXICMS BAIXA"

_cquery+=" FROM "
_cquery+=  retsqlname("SF9")+" SF9"

_cquery+=" WHERE"
_cquery+="     SF9.D_E_L_E_T_=' '"
_cquery+=" AND F9_FILIAL='"+_cfilsf9+"'"
_cquery+=" AND F9_DTENTNE BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
_cquery+=" AND F9_DTEMINS BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"

_cquery+=" ORDER BY"
_cquery+=" 2,1,6,3"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DTMOV","D",08,0)
tcsetfield("TMP1","VALOR","N",13,2)
tcsetfield("TMP1","BAIXA","N",13,2)
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Mes                          ?","mv_ch1","N",02,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ano                          ?","mv_ch2","N",04,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Pagina inicial               ?","mv_ch3","N",04,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
------------------------------------------------------------------------------------------------------------------------------------
|                                      CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                      |
|                                                             MODELO C                                                             |
| Ano: 9999                                                                                                            Folha: 9999 |
|----------------------------------------------------------------------------------------------------------------------------------|
| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                |
|----------------------------------------------------------------------------------------------------------------------------------|
|Nome: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX C.N.P.J. No: 99.999.999/9999-99  Inscricao Estadual No: XXXXXXXXXXXXXX             |
|Endereco: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX         Bairro: XXXXXXXXXXXXXXXXXXXX   Municipio: XXXXXXXXXXXXXXXXXXXX                   |
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
| 2 - DEMONSTRATIVO DA BASE DO CREDITO A SER APROPRIADO                                                                            |
|----------------------------------------------------------------------------------------------------------------------------------|
|                          IDENTIFICACAO DO BEM                           |                      VALOR DO ICMS                     |
|-------------------------------------------------------------------------+--------------------------------------------------------|
| No. ou |           |  Nota   |                                          |      Entrada     |  Saida,Baixa ou  | Saldo  Acumulado |
| Codigo |   Data    | Fiscal  |            Descricao Resumida            | (Credito Passivel|      Perda       |Base do Credito a |
|        |           |         |                                          |  de Apropriacao) |Deducao de Credito|  ser Apropriado  |
|--------+-----------+---------+------------------------------------------+------------------+------------------+------------------|
| 999999 | 99/99/9999| 999999  | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | 9.999.999.999,99 | 9.999.999.999,99 | 9.999.999.999,99 |
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
| 3 - DEMONSTRATIVO DA APURACAO DO CREDITO A SER EFETIVAMENTE APROPRIADO                                                           |
|----------------------------------------------------------------------------------------------------------------------------------|
|           |   OPERACOES E PRESTACOES ( SAIDAS )   |                      |   SALDO ACUMULADO   |          |                      |
|           |---------------------------------------|     COEFICIENTE      |  (BASE DO CREDITO   |          |        CREDITO       |
|    MES    |    TRIBUTADAS E   |       TOTAL       |         DE           |        A SER        |  FRACAO  |         A SER        |
|           |     EXPORTACAO    |     DAS SAIDAS    |     CREDITAMENTO     |     APROPRIADO)     |  MENSAL  |      APROPRIADO      |
|           |        (1)        |        (2)        |     (3 = 1 / 2)      |         (4)         |    (5)   |    (6 = 3 X 4 X 5)   |
|-----------+-------------------+-------------------+----------------------+---------------------+----------+----------------------|
| JANEIRO   | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| FEVEREIRO | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| MARCO     | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| ABRIL     | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| MAIO      | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| JUNHO     | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| JULHO     | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| AGOSTO    | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| SETEMBRO  | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| OUTUBRO   | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| NOVEMBRO  | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
| DEZEMBRO  | 99.999.999.999,99 | 99.999.999.999,99 |      999,9999        |   99.999.999.999,99 |   1/48   |    99.999.999.999,99 |
------------------------------------------------------------------------------------------------------------------------------------
*/
