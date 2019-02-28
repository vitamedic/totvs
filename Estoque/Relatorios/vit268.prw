/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT268   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 14/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Déficit de Vendas / Estoque                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit268()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="DEFICIT DE VENDAS/ESTOQUE"
cdesc1  :="Este programa ira emitir o Deficit de Vendas/Estoque por produto"
cdesc2  :="para um determinado periodo, levando-se em consideracao a previ-"
cdesc3  :="sao de vendas e o total faturado."
cstring :="SD2"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT268"
wnrel   :="VIT268"+Alltrim(cusername)
alinha  :={}
aordem  :={"Alfabetica","Grupo","Ranking Deficit Estoque (R$)","Ranking Deficit Estoque (UN)","Ranking Deficit Vendas (R$)","Ranking Deficit Vendas (UN)"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=220
cbtxt    :=space(10)

cperg:="PERGVIT268"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

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
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
_cfilsd2:=xfilial("SD2")
_cfilsb1:=xfilial("SB1")
_cfilsf4:=xfilial("SF4")
_cfilsct:=xfilial("SCT")
sd2->(dbsetorder(5))
sb1->(dbsetorder(1))
sf4->(dbsetorder(1))
sct->(dbsetorder(2))

processa({|| _querys()})

_datafin:="  /  /  "
_mesfin:=0
_anofin:=0
_diafin:=0

_mesfin:= strzero(month(mv_par02),2)
_anofin:= strzero(year(mv_par02),4) 

if (_mesfin="01") .or. (_mesfin="03") .or. (_mesfin="05") .or. (_mesfin="07") .or.;
	(_mesfin="08") .or. (_mesfin="10") .or. (_mesfin="12")
	_diafin:="31"
elseif (_mesfin == "02")
	_diafin:="28"
else            
	_diafin:="30"		
endif           
		
_datafin:=ctod(_diafin+"/"+_mesfin+"/"+_anofin)

processa({|| _query2(_datafin)})

cabec1:= dtoc(mv_par01)+" a "+dtoc(mv_par02)+"                                                              FATURADO                 PREVISAO VENDAS          DEFICIT ESTOQUE          DEFICIT VENDAS"
cabec2:="PRODUTO DESCRICAO                        GRUPO LINHA  PC.MEDIO  EST.FINAL    UN.          VALOR       UN.          VALOR       UN.          VALOR       UN.          VALOR"

setprc(0,0)
@ 000,000 PSAY avalimp(133)

setregua(tmp1->(lastrec()))

// Sub-Totalizadores Por Linha
_stotest:=0
_stotunfat:=0
_stotvalfat:=0
_stotunprev:=0
_stotvalprev:=0
_stotundest:=0
_stotvaldest:=0
_stotundven:=0
_stotvaldven:=0

// Totalizadores Gerais
_totest:=0       
_totunfat:=0
_totvalfat:=0
_totunprev:=0
_totvalprev:=0
_totundest:=0
_totvaldest:=0
_totundven:=0
_totvaldven:=0
_pcomedio:=0
_linha:=""

//////////////////////////////////////////////////////////////////////////////////////
//
// ARQUIVO TEMPORÁRIO PARA INDEXAÇÃO/PREPARAÇÃO DOS RESULTADOS PARA IMPRESSÃO
//
//////////////////////////////////////////////////////////////////////////////////////

_aestrut:={}
aadd(_aestrut,{"CODIGO"      ,"C",06,0})
aadd(_aestrut,{"DESCRICAO"   ,"C",30,0})
aadd(_aestrut,{"GRUPO"       ,"C",04,0})
aadd(_aestrut,{"LINHA"       ,"C",01,0})
aadd(_aestrut,{"PCOMEDIO"    ,"N",09,4})
aadd(_aestrut,{"ESTFIN"      ,"N",07,0})
aadd(_aestrut,{"TOTQTFAT"    ,"N",06,0})
aadd(_aestrut,{"TOTVALFAT"   ,"N",09,2})
aadd(_aestrut,{"TOTQTPRVEN"  ,"N",06,0})
aadd(_aestrut,{"TOTVLPRVEN"  ,"N",09,2})
aadd(_aestrut,{"TOTQTDEST"   ,"N",06,0})
aadd(_aestrut,{"TOTVALDEST"  ,"N",09,2})
aadd(_aestrut,{"TOTQTDVEN"   ,"N",06,0})
aadd(_aestrut,{"TOTVALDVEN"  ,"N",09,2})
aadd(_aestrut,{"LINHAINV"    ,"C",01,0})

_carqtmp3:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp3,"TMP3",.f.)

// ÍNDICE PARA ORDEM DE CÓDIGO
_cindtmp31:=criatrab(,.f.)
_cchave   :="codigo"
tmp3->(indregua("TMP3",_cindtmp31,_cchave))

// ÍNDICE PARA ORDEM DE GRUPO/AFABÉTICA
_cindtmp32:=criatrab(,.f.)
_cchave   :="linha+grupo+descricao"
tmp3->(indregua("TMP3",_cindtmp32,_cchave))

// ÍNDICE PARA ORDEM DE LINHA/ALFABÉTICA
_cindtmp33:=criatrab(,.f.)
_cchave   :="linha+descricao"
tmp3->(indregua("TMP3",_cindtmp33,_cchave))

// ÍNDICE PARA ORDEM DE RANKING EM DÉFICIT ESTOQUE (R$)
_cindtmp34:=criatrab(,.f.)
_cchave   :="linhainv+strzero(totvaldest,9,2)+strzero(totvaldven,9,2)"
tmp3->(indregua("TMP3",_cindtmp34,_cchave))

// ÍNDICE PARA ORDEM DE RANKING EM DÉFICIT ESTOQUE (UN)
_cindtmp35:=criatrab(,.f.)
_cchave   :="linhainv+strzero(totqtdest,6,0)+strzero(totqtdven,9,2)"
tmp3->(indregua("TMP3",_cindtmp35,_cchave))

// ÍNDICE PARA ORDEM DE RANKING EM DÉFICIT VENDAS (R$)
_cindtmp36:=criatrab(,.f.)
_cchave   :="linhainv+strzero(totvaldven,9,2)+strzero(totvaldest,9,2)"
tmp3->(indregua("TMP3",_cindtmp36,_cchave))

// ÍNDICE PARA ORDEM DE RANKING EM DÉFICIT VENDAS (UN)
_cindtmp37:=criatrab(,.f.)
_cchave   :="linhainv+strzero(totqtdven,6,0)+strzero(totqtdest,9,2)"
tmp3->(indregua("TMP3",_cindtmp37,_cchave))

tmp3->(dbclearind())
tmp3->(dbsetindex(_cindtmp31))
tmp3->(dbsetindex(_cindtmp32))
tmp3->(dbsetindex(_cindtmp33))
tmp3->(dbsetindex(_cindtmp34))
tmp3->(dbsetindex(_cindtmp35))
tmp3->(dbsetindex(_cindtmp36))
tmp3->(dbsetindex(_cindtmp37))
tmp3->(dbsetorder(1))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua

	tmp3->(dbappend())

	tmp3->codigo:=substr(tmp1->cod,1,6)                     		 	// Código Produto
	tmp3->descricao:=substr(tmp1->descri,1,30)                 		// Descrição Produto
	tmp3->grupo:=tmp1->grupo                               			// Grupo do Produto
	
	tmp3->linha:=tmp1->apreven                                     // Linha: 1-Farma/ 2-Hosp.

	if tmp1->apreven=="1"  // UTILIZADO PARA INDEXAÇÃO INVERTIDA
		tmp3->linhainv:="2"
	else
		tmp3->linhainv:="1"
	endif

	_pcomedio:= tmp1->totvalfat/tmp1->totquantfat
	tmp3->pcomedio:= tmp1->totvalfat/tmp1->totquantfat         		// Pço. Médio = TOTAL FATURADO NO PERÍODO / QTDE FATURADA NO PERÍODO

	_estfinal:=0
	_estoque:= calcest(tmp1->cod,"01",mv_par02) 			           	// Cálculo do Estoque na data final do parâmetro.
	_estfinal:=_estoque[1]

	tmp3->estfin:=_estfinal          										// Quantidade no estoque - fechamento.

	tmp3->totqtfat:= tmp1->totquantfat     								// Quantidade faturada no período.
	tmp3->totvalfat:= tmp1->totvalfat  										// Valor faturado no período.

	tmp2->(dbgotop())
	while !tmp2->(eof()) .and. tmp1->cod<>tmp2->produto
		tmp2->(dbskip())
	end

	tmp3->totqtprven:= tmp2->quantprev 										// Quantidade prevista para venda no período.
	tmp3->totvlprven:= tmp2->quantprev*_pcomedio 						// Valor previsto para venda no período.

	if (tmp1->totquantfat < tmp2->quantprev)
		if (_estfinal < (tmp2->quantprev - tmp1->totquantfat))
			tmp3->totqtdest:= (tmp2->quantprev - tmp1->totquantfat)-_estfinal						// Déficit de Unidades do Estoque no período.
			tmp3->totvaldest:= ((tmp2->quantprev - tmp1->totquantfat)-_estfinal)*_pcomedio	// Déficit de Valor do Estoque no período.
			tmp3->totqtdven:=  _estfinal																		// Déficit de Unidades nas Vendas do período.
			tmp3->totvaldven:= _estfinal*_pcomedio															// Déficit de Valor nas Vendas do período.
		else                             
			tmp3->totqtdest:= 0																					// Déficit de Unidades do Estoque no período.
			tmp3->totvaldest:= 0																					// Déficit de Valor do Estoque no período.
			tmp3->totqtdven:= (tmp2->quantprev - tmp1->totquantfat)									// Déficit de Unidades nas Vendas do período.
			tmp3->totvaldven:= (tmp2->quantprev - tmp1->totquantfat)*_pcomedio					// Déficit de Valor nas Vendas do período.
		endif
	endif
	
	tmp1->(dbskip())
end
                      


if nordem==1
	titulo :="DEFICIT DE VENDAS/ESTOQUE (ORDEM ALFABETICA)"
	tmp3->(dbsetorder(3))
	tmp3->(dbgotop())
	_ccond:="! tmp3->(eof())"
elseif nordem==2
	titulo :="DEFICIT DE VENDAS/ESTOQUE (ORDEM GRUPO)"		
	tmp3->(dbsetorder(2))
	tmp3->(dbgotop())
	_ccond:="! tmp3->(eof())"
elseif nordem==3
	titulo :="DEFICIT DE VENDAS/ESTOQUE (RANKING DEFICIT ESTOQUE R$)"
	tmp3->(dbsetorder(4))
	tmp3->(dbgobottom())
	_ccond:="! tmp3->(bof())"
elseif nordem==4
	titulo :="DEFICIT DE VENDAS/ESTOQUE (RANKING DEFICIT ESTOQUE UN)"
	tmp3->(dbsetorder(5))
	tmp3->(dbgobottom())
	_ccond:="! tmp3->(bof())"
elseif nordem==5
	titulo :="DEFICIT DE VENDAS/ESTOQUE (RANKING DEFICIT VENDAS R$)"
	tmp3->(dbsetorder(6))
	tmp3->(dbgobottom())
	_ccond:="! tmp3->(bof())"
elseif nordem==6
	titulo :="DEFICIT DE VENDAS/ESTOQUE (RANKING DEFICIT VENDAS UN)"
	tmp3->(dbsetorder(7))
	tmp3->(dbgobottom())
	_ccond:="! tmp3->(bof())"
endif

while &_ccond .and.;
	lcontinua
	incregua()
   if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,10)
	endif

	_linha:= tmp3->linha
	@ prow()+1,000 PSAY tmp3->codigo								  				// Código Produto
	@ prow(),009   PSAY tmp3->descricao											// Descrição Produto
	@ prow(),040   PSAY tmp3->grupo												// Grupo
	
	if (tmp3->linha == '1')                                     		// Linha: 1-Farma/ 2-Hosp.
		@ prow(),046 PSAY "Farma"
	else                        
		@ prow(),046 PSAY "Hosp."	
	endif

	@ prow(),052   PSAY tmp3->pcomedio    picture "@E 9,999.9999"		// Pço Médio
	@ prow(),063   PSAY tmp3->estfin      picture "@E 9,999,999"		// Estoque Final
	@ prow(),076   PSAY tmp3->totqtfat    picture "@E 999,999"    		// Quantidade faturada no período.
	@ prow(),085   PSAY tmp3->totvalfat   picture "@E 9,999,999.99" 	// Valor faturado no período.

	@ prow(),101   PSAY tmp3->totqtprven  picture "@E 999,999"      	// Quantidade prevista para venda no período.
	@ prow(),110   PSAY tmp3->totvlprven  picture "@E 9,999,999.99"   // Valor previsto para venda no período.

	@ prow(),126   PSAY tmp3->totqtdest   picture "@E 999,999"        // Déficit de Unidades do Estoque no período.
	@ prow(),135   PSAY tmp3->totvaldest   picture "@E 9,999,999.99"   // Déficit de Valor do Estoque no período.

	@ prow(),151   PSAY tmp3->totqtdven   picture "@E 999,999"        // Déficit de Unidades nas Vendas do período.
	@ prow(),160   PSAY tmp3->totvaldven  picture "@E 9,999,999.99"   // Déficit de Valor nas Vendas do período.

	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif

	// Atualização de sub-totais
	_stotest+= tmp3->estfin  
	_stotunfat+= tmp3->totqtfat	
	_stotvalfat+= tmp3->totvalfat
	_stotunprev+= tmp3->totqtprven
	_stotvalprev+= tmp3->totvlprven
	_stotundest+= tmp3->totqtdest
	_stotvaldest+= tmp3->totvaldest
	_stotundven+= tmp3->totqtdven
	_stotvaldven+= tmp3->totvaldven

	// Atualização de totais
	_totest+= tmp3->estfin  
	_totunfat+= tmp3->totqtfat	
	_totvalfat+= tmp3->totvalfat
	_totunprev+= tmp3->totqtprven
	_totvalprev+= tmp3->totvlprven
	_totundest+= tmp3->totqtdest
	_totvaldest+= tmp3->totvaldest
	_totundven+= tmp3->totqtdven
	_totvaldven+= tmp3->totvaldven

	if (nordem>2)
		tmp3->(dbskip(-1))
	else
		tmp3->(dbskip())
	endif

	if (_linha<>tmp3->linha) .or.;
		(tmp3->(eof()) .and. _ccond=="! tmp3->(eof())") .or.;
		(tmp3->(bof()) .and. _ccond=="! tmp3->(bof())")		
	
		if _linha == '1'                                       // Linha: 1-Farma/ 2-Hosp.
			@ prow()+2,009   PSAY "SUBTOTAL DIVISÃO - FARMA"
		else                        
			@ prow()+2,009   PSAY "SUBTOTAL DIVISÃO - HOSPITALAR"
		endif

		@ prow(),061   PSAY _stotest     picture "@E 999,999,999"    // Sub-total Quantidade no estoque - fechamento.
		@ prow(),073   PSAY _stotunfat   picture "@E 99,999,999"     // Sub-total Quantidade faturada no período.
		@ prow(),084   PSAY _stotvalfat  picture "@E 99,999,999.99"  // Sub-total Valor faturado no período.
		@ prow(),098   PSAY _stotunprev  picture "@E 99,999,999"     // Sub-total Quantidade prevista para venda no período.
		@ prow(),109   PSAY _stotvalprev picture "@E 99,999,999.99"  // Sub-total Valor previsto para venda no período.
		@ prow(),123   PSAY _stotundest  picture "@E 99,999,999"     // Sub-total Déficit de Unidades do Estoque no período.
		@ prow(),134   PSAY _stotvaldest picture "@E 99,999,999.99"  // Sub-total Déficit de Valor do Estoque no período.
		@ prow(),148   PSAY _stotundven  picture "@E 99,999,999"     // Sub-total Déficit de Unidades nas Vendas do período.
		@ prow(),159   PSAY _stotvaldven picture "@E 99,999,999.99"  // Sub-total Déficit de Valor nas Vendas do período.
		@ prow()+1,009 PSAY "      " 
	
		if prow()==0 .or. prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
		endif

		_stotest:=0                              
		_stotunfat:=0                            
		_stotvalfat:=0                           
		_stotunprev:=0                           
		_stotvalprev:=0                          
		_stotundest:=0                           
		_stotvaldest:=0                          
		_stotundven:=0                           
		_stotvaldven:=0	
	endif

end


if prow()==0 .or. prow()>60
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
endif


// IMPRIME TOTAIS GERAIS
@ prow()+2,009 PSAY "TOTAL GERAL"
@ prow(),061   PSAY _totest picture "@E 999,999,999"         // Total Quantidade no estoque - fechamento.
@ prow(),073   PSAY _totunfat picture "@E 99,999,999"        // Total Quantidade faturada no período.
@ prow(),084   PSAY _totvalfat picture "@E 99,999,999.99"    // Total Valor faturado no período.
@ prow(),098   PSAY _totunprev picture "@E 99,999,999"       // Total Quantidade prevista para venda no período.
@ prow(),109   PSAY _totvalprev picture "@E 99,999,999.99"   // Total Valor previsto para venda no período.
@ prow(),123   PSAY _totundest  picture "@E 99,999,999"      // Total Déficit de Unidades do Estoque no período.
@ prow(),134   PSAY _totvaldest picture "@E 99,999,999.99"   // Total Déficit de Valor do Estoque no período.
@ prow(),148   PSAY _totundven  picture "@E 99,999,999"      // Total Déficit de Unidades nas Vendas do período.
@ prow(),159   PSAY _totvaldven picture "@E 99,999,999.99"   // Total Déficit de Valor nas Vendas do período.

if prow()>0 .and. lcontinua
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())
tmp2->(dbclosearea())

_cindtmp31+=tmp3->(ordbagext())
if nordem>1
	_cindtmp32+=tmp3->(ordbagext())
endif

tmp3->(dbclosearea())   
ferase(_carqtmp3+getdbextension())
ferase(_cindtmp31)
if nordem>1
	ferase(_cindtmp32)
	ferase(_cindtmp33)
	ferase(_cindtmp34)
	ferase(_cindtmp35)
	ferase(_cindtmp36)
	ferase(_cindtmp37)
endif


set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return


/* BUSCA TOTAL FATURADO NO PERÍODO INFORMADO */

static function _querys()
_cquery:=" SELECT"
_cquery+=" D2_COD COD,"
_cquery+=" B1_DESC DESCRI," 
_cquery+=" D2_GRUPO GRUPO,"
_cquery+=" B1_APREVEN APREVEN,"
_cquery+=" SUM(D2_QUANT) TOTQUANTFAT,"
_cquery+=" SUM(D2_TOTAL) TOTVALFAT"

_cquery+=" FROM "
_cquery+=  retsqlname("SD2")+" SD2,"
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SF4")+" SF4"

_cquery+=" WHERE"                   
_cquery+="     SD2.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND D2_GRUPO BETWEEN 'PA01' AND 'PA99'"
_cquery+=" AND D2_TP='PA'"
_cquery+=" AND D2_COD=B1_COD"
_cquery+=" AND D2_TES=F4_CODIGO"
_cquery+=" AND F4_DUPLIC='S'"
_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"

_cquery+=" GROUP BY D2_COD, B1_DESC, D2_GRUPO, B1_APREVEN"

_cquery+=" ORDER BY B1_APREVEN, D2_GRUPO, B1_DESC, D2_COD"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","TOTQUANTFAT","N",7,0)
tcsetfield("TMP1","TOTVALFAT","N",12,2)

return


/* BUSCA TOTAL PREVISTO NO PERÍODO INFORMADO */

static function _query2(_datafin)
_cquery2:=" SELECT"
_cquery2+=" CT_PRODUTO PRODUTO,"
_cquery2+=" SUM(CT_QUANT) QUANTPREV"

_cquery2+=" FROM "
_cquery2+=  retsqlname("SCT")+" SCT"

_cquery2+=" WHERE"                   
_cquery2+="     SCT.D_E_L_E_T_<>'*'"
_cquery2+=" AND CT_FILIAL='"+_cfilsct+"'"
_cquery2+=" AND CT_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(_datafin)+"'"
_cquery2+=" AND CT_PRODUTO<>'               '"
_cquery2+=" AND CT_TIPO='PA'"

_cquery2+=" GROUP BY CT_PRODUTO"

_cquery2+=" ORDER BY CT_PRODUTO"

_cquery2:=changequery(_cquery2)

tcquery _cquery2 new alias "TMP2"    
tcsetfield("TMP2","QUANTPREV","N",7,0)

return




static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a Data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
**LAYOUT DO RELATORIO


10/01/05 a 15/01/05                                                        FATURADO                 PREVISAO VENDAS          DEFICIT ESTOQUE          DEFICIT VENDAS
PRODUTO DESCRICAO                      GRUPO LINHA  PC.MEDIO  EST.FINAL    UN.          VALOR       UN.          VALOR       UN.          VALOR       UN.          VALOR"
999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXX  XXXXX 99.999,99  9.999.999    999.999  9.999.999,99    999.999  9.999.999,99    999.999  9.999.999,99    999.999  9.999.999,99"
999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXX  XXXXX 99.999,99  9.999.999    999.999  9.999.999,99    999.999  9.999.999,99    999.999  9.999.999,99    999.999  9.999.999,99"
        SUBTOTAL DIVISAO - FARMA                            999.999.999 99.999.999 99.999.999,99 99.999.999 99.999.999,99 99.999.999 99.999.999,99 99.999.999 99.999.999,99


**QUERY EXECUTADA NO SQL PLUS WORKSHEET

SELECT D2_COD, B1_DESC, D2_GRUPO, B1_APREVEN, SUM(D2_QUANT), SUM(D2_TOTAL)
FROM SD2010 SD2, SB1010 SB1, SF4010 SF4
WHERE
    SD2.D_E_L_E_T_<>'*'
AND SB1.D_E_L_E_T_<>'*'
AND SF4.D_E_L_E_T_<>'*'
AND D2_FILIAL='01'
AND B1_FILIAL='01'
AND F4_FILIAL='01'
AND D2_GRUPO BETWEEN 'PA01' AND 'PA99'
AND D2_COD=B1_COD
AND D2_TES=F4_CODIGO
AND F4_DUPLIC='S'
AND D2_EMISSAO BETWEEN '20060501' AND '20060531'
GROUP BY D2_COD, B1_DESC, D2_GRUPO, B1_APREVEN
ORDER BY B1_APREVEN, D2_GRUPO, B1_DESC, D2_COD

*/
