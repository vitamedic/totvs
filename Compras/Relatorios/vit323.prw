/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT323   ³ Autor ³ Alex Júnio            ³ Data ³ 14/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento de Compra                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Variaveis utilizadas para parametros                                   ³±±
±±³mv_par01 Da data                                                       ³±±
±±³mv_par02 Ate a data                                                    ³±±
±±³mv_par01 Do produto                                                    ³±±
±±³mv_par02 Ate o produto                                                 ³±±
±±³mv_par01 Do tipo                                                       ³±±
±±³mv_par02 Ate o tipo                                                    ³±±
±±³mv_par01 Do grupo                                                      ³±±
±±³mv_par02 Ate a grupo                                                   ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT323()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="ACOMPANHAMENTO DE COMPRA"
cdesc1   :="Este programa ira emitir o acompanhamento de compras"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT323"
wnrel    :="VIT323"+Alltrim(cusername)
alinha   :={}
aordem   :={"Emissao SC","Cod. Produto","Desc. Produto (SC)","Grupo","Comprador + Emissao","Comprador + Descricao","Comprador + Grupo"}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=220
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT323"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho)

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
return

static function rptdetail()
_cfilsb1:=xfilial("SB1")
_cfilsbm:=xfilial("SBM")
_cfilsa2:=xfilial("SA2")
_cfilsc1:=xfilial("SC1")
_cfilsc7:=xfilial("SC7")
_cfilsd1:=xfilial("SD1")
_cfilsf1:=xfilial("SF1")
sd1->(dbsetorder(5))
sc7->(dbsetorder(4))
sb1->(dbsetorder(3))
sc1->(dbsetorder(1))
sa2->(dbsetorder(1))
sbm->(dbsetorder(1))
sf1->(dbsetorder(1)) // Filial + Doc + Serie + Fornecedor + Loja + Tipo da Nota

if mv_par11=1
	titulo   :="ACOMPANHAMENTO DE COMPRAS - SC´S EM ABERTO DE "+dtoc(mv_par09)+ " A "+ dtoc(mv_par10)
else
	titulo   :="ACOMPANHAMENTO DE COMPRAS - TODAS AS SC´S DE "+dtoc(mv_par09)+ " A "+ dtoc(mv_par10)
endif

if mv_par12=1 //Analítico
	titulo+= " - ANALITICO"
else
	titulo+= " - SINTETICO"
endif


processa({|| _querys()})

cabec1:="COD.   DESCRIÇÃO PRODUTO (SC)                   UM No.SC. DT.SC.   DT.NECES   QTDE.SC.     SOLICITANTE          PEDIDO  DT.PED.    QTDE.PEDIDO                          QT.TOT.NF. FORNECEDOR "
if mv_par12=1 //Analítico
	cabec2:="                                                                                                                                                NF/SERIE   EMIS.NF      QTDE.NOTA  DT.DIG.NF  RECEB.NF"
else 
	cabec2:=" "
endif
//COD.   DESCRICAO PRODUTO (SC)                   UM No.SC. DT.SC      QTDE.SC.     SOLICITANTE          PEDIDO  DT.PED.    QTDE.PEDIDO  NOTA  SER  EMIS.NF      QTDE.NOTA
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999999 99/99/99 999.999.999,99 XXXXXXXXXXXXXXXXXXXX 999999 99/99/99 999.999.999,99 999999 XXX 99/99/99 999.999.999,99

setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())

_comprador:=tmp1->comprador
_grupo:= tmp1->grupo
_primeiro:=.t.

while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	incregua()
	_fornece:=tmp1->fornece
	_loja:=tmp1->loja
	
	if !empty(tmp1->pedido)
		
		_totnf:=0
		
		// QUERY PARA BUSCAR NF´s
		_cquer2:=" SELECT"
		_cquer2+=" SUM(D1_QUANT) TOTNF"
		_cquer2+=" FROM "
		_cquer2+=retsqlname("SD1")+" SD1"
		_cquer2+=" WHERE SD1.D_E_L_E_T_=' '"
		_cquer2+=" AND D1_EMISSAO>= '"+dtos(tmp1->emissaoped)+"'"
		_cquer2+=" AND D1_PEDIDO='"+tmp1->pedido+"'"
		_cquer2+=" AND D1_ITEMPC='"+tmp1->itemped+"'
		
		_cquer2:=changequery(_cquer2)
		
		tcquery _cquer2 new alias "TMP2"
		tcsetfield("TMP2","TOTNF"  ,"N",15,2)
		
		_totnf:= tmp2->totnf
		
		tmp2->(dbclosearea())
		
		if (mv_par11==1 .and. tmp1->quantped <= _totnf) .or.;
			(tmp1->residuo=="S" .and. tmp1->quantped > _totnf)
			
			tmp1->(dbskip())
			
		else
					
			if nordem==4
				if (_grupo<>tmp1->grupo) .or. (_primeiro)
					if !_primeiro
						@ prow()+1,000 PSAY " "
					endif
					@ prow()+1,000 PSAY tmp1->grupo+" - "+tmp1->descgrupo
					_grupo:=tmp1->grupo 
					_primeiro:=.f.
				endif
			elseif (nordem==5) .or. (nordem==6)
				if (_comprador<>tmp1->comprador) .or. (_primeiro)
					if !_primeiro
						@ prow()+1,000 PSAY " "
					endif
					@ prow()+1,000 PSAY tmp1->comprador+"-"+upper(RetNome(tmp1->comprador))
					_comprador:=tmp1->comprador
					_primeiro:=.f.
				endif
			elseif nordem==7
				if (_comprador<>tmp1->comprador) .or. (_primeiro)
					if !_primeiro
						@ prow()+1,000 PSAY " "
					endif
					@ prow()+1,000 PSAY tmp1->comprador+"-"+upper(RetNome(tmp1->comprador))
					_comprador:=tmp1->comprador
					if _primeiro
						@ prow()+1,000 PSAY tmp1->grupo+" - "+tmp1->descgrupo
						_primeiro:=.f.
					endif
				endif
				if (_grupo<>tmp1->grupo) .or. (_primeiro)
					if !_primeiro
						@ prow()+1,000 PSAY " "
					endif
					@ prow()+1,000 PSAY tmp1->grupo+" - "+tmp1->descgrupo
					_grupo:=tmp1->grupo
					_primeiro:=.f.
				endif
			endif
			
			@ prow()+1,000 PSAY substr(tmp1->produto,1,6)
			@ prow(),007   PSAY tmp1->descri
			@ prow(),048   PSAY tmp1->um
			@ prow(),051   PSAY tmp1->num
			@ prow(),058   PSAY tmp1->emissao
			@ prow(),068   PSAY tmp1->datprf
			@ prow(),077   PSAY tmp1->quant picture "@E 999,999,999.99"
			@ prow(),092   PSAY substr(tmp1->solicit,1,20)
			@ prow(),113   PSAY tmp1->pedido
			@ prow(),120   PSAY tmp1->emissaoped
			@ prow(),129   PSAY tmp1->quantped picture "@E 999,999,999.99"
			@ prow(),164   PSAY _totnf picture "@E 999,999,999.99"
			
			sa2->(dbseek(_cfilsa2+_fornece+_loja))
			@ prow(),179 PSAY sa2->a2_nome
			
			if mv_par12=1 // Relatório Analítico
				_cquer2:=" SELECT"
				_cquer2+=" SUM(D1_QUANT) TOTNF,"
				_cquer2+=" D1_DOC DOC,"
				_cquer2+=" D1_SERIE SERIE,"
				_cquer2+=" D1_EMISSAO EMISSAO,"
				_cquer2+=" D1_DTDIGIT DTDIGIT"
				_cquer2+=" FROM "
				_cquer2+=retsqlname("SD1")+" SD1"
				_cquer2+=" WHERE SD1.D_E_L_E_T_=' '"
				_cquer2+=" AND D1_EMISSAO>= '"+dtos(tmp1->emissaoped)+"'"
				_cquer2+=" AND D1_PEDIDO='"+tmp1->pedido+"'"
				_cquer2+=" AND D1_ITEMPC='"+tmp1->itemped+"'
				_cquer2+=" GROUP BY D1_DOC,D1_SERIE,D1_EMISSAO,D1_DTDIGIT"
				
				_cquer2:=changequery(_cquer2)
				
				tcquery _cquer2 new alias "TMP2"
				tcsetfield("TMP2","TOTNF"  ,"N",15,2)
				tcsetfield("TMP2","EMISSAO","D")
				tcsetfield("TMP2","DTDIGIT","D")
								
				tmp2->(dbgotop())
				
				while ! tmp2->(eof()) .and.;
					lcontinua
					if prow()==0 .or. prow()>54
						cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
					endif
					
					set softseek on
					sf1->(dbseek(_cfilsf1+tmp2->doc+tmp2->serie+_fornece+_loja+"N"))
					set softseek off
					_recebnf:= sf1->f1_recbmto
					
					@ prow()+1,144   PSAY tmp2->doc
					@ prow()  ,151   PSAY tmp2->serie
					@ prow()  ,155   PSAY tmp2->emissao
					@ prow()  ,164   PSAY tmp2->totnf picture "@E 999,999,999.99"
					@ prow()  ,179   PSAY tmp2->dtdigit
					@ prow()  ,189   PSAY _recebnf
				
					if labortprint
						@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
						lcontinua:=.f.
					endif
					tmp2->(dbskip())
				end
				tmp2->(dbclosearea())
				
			endif
			
			tmp1->(dbskip())
		endif
	else
		if nordem==4
			if (_grupo<>tmp1->grupo) .or. (_primeiro)
				if !_primeiro
					@ prow()+1,000 PSAY " "
				endif
				@ prow()+1,000 PSAY tmp1->grupo+" - "+tmp1->descgrupo
				_grupo:=tmp1->grupo 
				_primeiro:=.f.
			endif
		elseif (nordem==5) .or. (nordem==6)
			if (_comprador<>tmp1->comprador) .or. (_primeiro)
				if !_primeiro
					@ prow()+1,000 PSAY " "
				endif
				@ prow()+1,000 PSAY tmp1->comprador+"-"+upper(RetNome(tmp1->comprador))
				_comprador:=tmp1->comprador
				_primeiro:=.f.
			endif
		elseif nordem==7
			if (_comprador<>tmp1->comprador) .or. (_primeiro)
				if !_primeiro
					@ prow()+1,000 PSAY " "
				endif
				@ prow()+1,000 PSAY tmp1->comprador+"-"+upper(RetNome(tmp1->comprador))
				_comprador:=tmp1->comprador
				if _primeiro
					@ prow()+1,000 PSAY tmp1->grupo+" - "+tmp1->descgrupo
					_primeiro:=.f.
				endif
			endif
			if (_grupo<>tmp1->grupo) .or. (_primeiro)
				if !_primeiro
					@ prow()+1,000 PSAY " "
				endif
				@ prow()+1,000 PSAY tmp1->grupo+" - "+tmp1->descgrupo
				_grupo:=tmp1->grupo
				_primeiro:=.f.
			endif
		endif
		
		@ prow()+1,000 PSAY substr(tmp1->produto,1,6)
		@ prow(),007   PSAY tmp1->descri
		@ prow(),048   PSAY tmp1->um
		@ prow(),051   PSAY tmp1->num
		@ prow(),058   PSAY tmp1->emissao
		@ prow(),068   PSAY tmp1->datprf
		@ prow(),077   PSAY tmp1->quant picture "@E 999,999,999.99"
		@ prow(),092   PSAY substr(tmp1->solicit,1,20)
		
		tmp1->(dbskip())
	endif
	
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
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
_cquery:=" SELECT"
_cquery+=" C1_PRODUTO PRODUTO,"
_cquery+=" C1_DESCRI DESCRI,"
_cquery+=" B1_GRUPO GRUPO,"
_cquery+=" BM_DESC DESCGRUPO,"
_cquery+=" C1_EMISSAO EMISSAO,"
_cquery+=" C1_NUM NUM,"
_cquery+=" C1_DATPRF DATPRF,"
_cquery+=" C1_UM UM,"
_cquery+=" C1_QUANT QUANT,"
_cquery+=" C1_SOLICIT SOLICIT,"
_cquery+=" C1_LOCAL LOCALP,"
_cquery+=" C1_ITEMPED ITEMPED,"
_cquery+=" C1_FORNECE FORNECE,"
_cquery+=" C1_LOJA LOJA,"
_cquery+=" (SELECT SC7.C7_NUM FROM "+retsqlname("SC7")+" SC7 WHERE SC7.D_E_L_E_T_=' ' AND SC7.C7_NUMSC = C1_NUM AND SC7.C7_ITEMSC=C1_ITEM) PEDIDO,"
_cquery+=" (SELECT SC7A.C7_EMISSAO FROM "+retsqlname("SC7")+" SC7A WHERE SC7A.D_E_L_E_T_=' ' AND SC7A.C7_NUMSC = C1_NUM AND SC7A.C7_ITEMSC=C1_ITEM) EMISSAOPED,"
_cquery+=" (SELECT SC7B.C7_USER FROM "+retsqlname("SC7")+" SC7B WHERE SC7B.D_E_L_E_T_=' ' AND SC7B.C7_NUMSC = C1_NUM AND SC7B.C7_ITEMSC=C1_ITEM) COMPRADOR,"
_cquery+=" (SELECT SC7C.C7_RESIDUO FROM "+retsqlname("SC7")+" SC7C WHERE SC7C.D_E_L_E_T_=' ' AND SC7C.C7_NUMSC = C1_NUM AND SC7C.C7_ITEMSC=C1_ITEM) RESIDUO,"
_cquery+=" (SELECT SC7D.C7_QUANT FROM "+retsqlname("SC7")+" SC7D WHERE SC7D.D_E_L_E_T_=' ' AND SC7D.C7_NUMSC = C1_NUM AND SC7D.C7_ITEMSC=C1_ITEM) QUANTPED"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SC1")+" SC1,"
_cquery+=  retsqlname("SBM")+" SBM"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SC1.D_E_L_E_T_<>'*'"
_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
_cquery+=" AND C1_PRODUTO=B1_COD"
_cquery+=" AND C1_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND C1_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B1_GRUPO=BM_GRUPO"
_cquery+=" AND C1_EMISSAO BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"

//Utilização do Filtro
#IFDEF TOP
	IF !Empty(aReturn[7])   // Coloca expressao do filtro
		_filtro := aReturn[7]
		_filtro := STRTRAN (_filtro,".And."," AND " )
		_filtro := STRTRAN (_filtro,".and."," AND " )
		_filtro := STRTRAN (_filtro,".Or."," OR ")
		_filtro := STRTRAN (_filtro,".or."," OR ")
		_filtro := STRTRAN (_filtro,"=="," = ")
		_filtro := STRTRAN (_filtro,'"',"'")
		_filtro := STRTRAN (_filtro,'Alltrim',"LTRIM")
		_filtro := STRTRAN (_filtro,'$',"LIKE")
		_cquery+=" AND ("+_filtro+")"
	Endif
#ENDIF

#IFNDEF TOP
	IF !Empty(aReturn[7])   // Coloca expressao do filtro
		Set Filter to &( aReturn[7] )
	Endif
#ENDIF

if nordem==1     // EMISSAO SC
	_cquery+=" ORDER BY C1_EMISSAO,C1_DESCRI"
elseif nordem==2 // CODIGO DO PRODUTO
	_cquery+=" ORDER BY C1_PRODUTO,C1_EMISSAO"
elseif nordem==3 // DESCRIÇÃO DO PRODUTO
	_cquery+=" ORDER BY C1_DESCRI,C1_EMISSAO"
elseif nordem==4 // GRUPO DO PRODUTO
	_cquery+=" ORDER BY B1_GRUPO,C1_EMISSAO"
elseif nordem==5 // COMPRADOR + EMISSAO
	_cquery+=" ORDER BY COMPRADOR,C1_EMISSAO"
elseif nordem==6 // COMPRADOR + DESCRICAO
	_cquery+=" ORDER BY COMPRADOR,C1_DESCRI,C1_EMISSAO"
else 			 // COMPRADOR + GRUPO
	_cquery+=" ORDER BY COMPRADOR,B1_GRUPO,C1_EMISSAO"
endif

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","DATPRF","D")
tcsetfield("TMP1","QUANT"  ,"N",15,3)
tcsetfield("TMP1","QUANTPED"  ,"N",15,3)
tcsetfield("TMP1","EMISSAOPED","D")
return


Static Function RetNome(_user)

Local _daduser  := {}
Local _userid := Alltrim(_user) // substr(cusuario,7,15)
Local _cNome := ""

psworder(1)

if pswseek(_userid,.t.)
	_daduser:=pswret(1)
	_cNome  := _daduser[1,4]
endif
Return (_cNome)

/*

INFORMAÇÕES DO VETOR DE USUÁRIO
     01 - C - UserID
     02 - C - User Name
     03 - C - Senha
     04 - C - Nome Completo
     05 - A - ???
     06 - D - Data de Validade Senha
     07 - N - Senha expira Após X dias
     08 - L - Autorizo Trocar Senha
     09 - L - Alterar senha no próximo login
     10 - A - 
     11 - C - Superior do Usuário
     12 - C - Departamento
     13 - C - Cargo
     14 - C - E-mail
     15 - N - Numero de Acessos Simultaneos
     16 - D - ???
     17 - L - Listner de Ligação
     18 - N - Digitos do Ano
     19 - L - ???
     20 - C - ???
     21 - C - ???

*/


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazem            ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Da data solicit.   ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate a data solic.  ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Apenas solicit.aber?","mv_chB","N",01,0,0,"C",space(60),"mv_par11"       ,"S=Sim"          ,space(30),space(15),"N=Nao"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Tipo de Relacao    ?","mv_chC","N",01,0,0,"C",space(60),"mv_par12"       ,"1=Analitico"    ,space(30),space(15),"2=Sintetico"    ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
