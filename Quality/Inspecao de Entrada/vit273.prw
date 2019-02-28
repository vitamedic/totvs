/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT273   ³Autor ³ Alex Júnio de Miranda   ³Data ³ 01/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Laudo Tecnico Analitico                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function VIT273(_lauto)
if _lauto==nil
	_lauto:=.f.
endif
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="LAUDO TECNICO ANALITICO"
cdesc1   :="Este programa ira emitir o Laudo Tecnico Analitico"
cdesc2   :=""
cdesc3   :=""
cstring  :="QEK"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT273"
wnrel    :="VIT273"+Alltrim(cusername)
alinha   :={}
aordem	:={"Laudo em Branco","Laudo Preenchido"}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

if _lauto
	_cperg:="PERGVIT273"
	mv_par01:=sd1->d1_cod	    // CÓDIGO DO PRODUTO
	mv_par02:=sd1->d1_lotectl   // LOTE DO PRODUTO
	mv_par03:=1
else
	_cperg:="PERGVIT273"
	_pergsx1()
	pergunte(_cperg,.f.)
endif

wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
if _lauto
	nordem:=1
else
	nordem:=areturn[8]
endif

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

static function rptdetail()
_cfilqek:=xfilial("QEK")
_cfilqel:=xfilial("QEL")
_cfilqeq:=xfilial("QEQ")
_cfilqer:=xfilial("QER")
_cfilqes:=xfilial("QES")
_cfilqe1:=xfilial("QE1")
_cfilqe6:=xfilial("QE6")
_cfilqe7:=xfilial("QE7")
_cfilqe8:=xfilial("QE8")
_cfilsa2:=xfilial("SA2")
_cfilsd1:=xfilial("SD1")
_cfilqa2:=xfilial("QA2")
_cfilsah:=xfilial("SAH")
_cfilsd5:=xfilial("SD5")
//_cfilsb8:=xfilial("SB8")

qek->(dbsetorder(6))
qel->(dbsetorder(2))
qeq->(dbsetorder(1))
qer->(dbsetorder(1))
qes->(dbsetorder(1))
qe1->(dbsetorder(1))
qe6->(dbsetorder(3))
qe7->(dbsetorder(2))
qe8->(dbsetorder(2))
sa2->(dbsetorder(1))
sd1->(dbsetorder(2))
qa2->(dbsetorder(2))
sah->(dbsetorder(1))    
sd5->(dbsetorder(2))    
//sb8->(dbsetorder(3))    

_numtestes:=0
_avfinal:=""
_lote:=""

if mv_par03==1
//	_lote:=LocSubLote(mv_par01,mv_par02)
	_lote:=mv_par02
	_cAssunto:= 'LAUDO TÉCNICO DE ANÁLISE'
else 
	_lote:=mv_par02
	_cAssunto:= 'LAUDO TÉCNICO REANÁLISE'
endif

_cMsg := ""

_aestrut:={}
aadd(_aestrut,{"ENSAIO"     ,"C",008,0})
aadd(_aestrut,{"DESCENSAIO" ,"C",080,0})
aadd(_aestrut,{"LABOR"      ,"C",006,0})
aadd(_aestrut,{"SEQLAB"     ,"C",002,0})
aadd(_aestrut,{"ESPECIFICA" ,"C",500,0})
aadd(_aestrut,{"MEDICA"     ,"C",050,0})
aadd(_aestrut,{"REFER     " ,"C",005,0})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)

_cindtmp11:=criatrab(,.f.)
_cchave   :="ensaio+labor+seqlab+refer"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave   :="labor+seqlab+ensaio"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))


tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))
tmp1->(dbsetorder(1))

processa({|| _montalau()})

setregua(tmp1->(lastrec()))

//³ INÍCIO DO CÓDIGO HTML

_cMsg := ''
_cMsg += '<html>'
_cMsg += '<head>'

if mv_par03==1
	_cMsg += '<title>Laudo Técnico Analítico</title>'
else
	_cMsg += '<title>Laudo Técnico Reanálise</title>'
endif	

_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
_cMsg += '</head>'
_cMsg += '<body>'


//³ INÍCIO DA TABELA (CABEÇALHO - TÍTULO)

_cMsg += '<table width="700" height="44" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg += '<tr>'
//_cMsg += '<td width="150" height="44"><img src="http://10.1.1.50/logovitapan.png" width="129" height="41"></td>'
//_cMsg += '<td width="150" height="44"><img src="\\10.1.1.24\pública\log\laudo0101.png" width="129" height="41"></td>' //Leandro 24/07/15
//_cMsg += '<td width="150" height="44"><img src="http://10.1.1.40/laudo0101.png" width="129" height="41"></td>' //Guilherme 03/09/2015 //Para que o endereço seja reolvido pelo named.
_cMsg += '<td width="150" height="44"><img src="https://drive.google.com/uc?id=1uN6KBQwMYScNoqqe1omuv-vd3KFvm-xc" width="129" height="41"></td>' //MARCIO DAVID 06/08/18//Para que o endereço seja reolvido pelo google drive.

if mv_par03==1
	_cMsg += '<td width="548" align="center" valign="middle"><font face=arial,verdana size=4><b>LAUDO TÉCNICO ANAL&Iacute;TICO</b></font></td>'
else 
	_cMsg += '<td width="548" align="center" valign="middle"><font face=arial,verdana size=4><b>LAUDO TÉCNICO DE REAN&Aacute;LISE</b></font></td>'
endif
_cMsg += '</tr>'


_cMsg += '</tr>'

//³ INÍCIO DA TABELA (CABEÇALHO - INFORMAÇÕES)

_cMsg += '</tr>'
_cMsg += '<td colspan="2">'
_cMsg += '<table width="698" align="center" cellpadding="0" cellspacing="0">'
_cMsg += '<tr>'
_cMsg += '<td width="175"> &nbsp;</td>'
_cMsg += '<td colspan="3"> &nbsp;</td>'
_cMsg += '</tr>'

_cMsg += '<tr>'
_cMsg += '<td width="175"><font face=arial,verdana size=2><b>Código: </b>'+substr(qek->qek_produt,1,6)+'</font></td>'

qe6->(dbsetorder(3))
qe6->(dbseek(_cfilqe6+mv_par01+qek->qek_revi))

_cMsg += '<td colspan="3"><font face=arial,verdana size=2><b>Descrição: </b>'+qe6->qe6_descpo+'</font></td>'
_cMsg += '</tr>'
_cMsg += '<tr>'

qel->(dbsetorder(2))
qel->(dbseek(_cfilqel+qek->qek_produt+qek->qek_revi+"      "+qek->qek_lote))

_achou:=.f.
///////////////////////////
while !(qel->(eof())) .and.; 
	  !_achou
	
	if qek->qek_dtentr == qel->qel_dtentr
		_achou:=.t.
	else
		qel->(dbskip())
	endif
end  

_avfinal:=qel->qel_laudo

_cMsg += '<td width="175"><font face=arial,verdana size=2><b>Dt. Entrada: </b>'+dtoc(qek->qek_dtentr)+'</font></td>'
_cMsg += '<td width="174"><font face=arial,verdana size=2><b>Lote: </b>'+substr(qek->qek_lote,1,10)+'</font></td>'

if nordem==1  // LAUDO EM BRANCO (SEM RESULTADOS)
	_cMsg += '<td width="179"><font face=arial,verdana size=2><b>Nº Análise: </b>__________</font></td>'
	if mv_par03==1
		_cMsg += '<td width="170"><font face=arial,verdana size=2><b>Dt. Análise: </b>___/___/___</td>'
	else
		_cMsg += '<td width="170"><font face=arial,verdana size=2><b>Dt. Reanálise: </b>___/___/___</td>'
	endif
else
	_cMsg += '<td width="179"><font face=arial,verdana size=2><b>Nº Análise: </b>'+qel->qel_analis+'</font></td>'
	if mv_par03==1
		_cMsg += '<td width="170"><font face=arial,verdana size=2><b>Dt. Análise: </b>'+dtoc(qel->qel_dtaana)+'</font></td>'
	else
		_cMsg += '<td width="170"><font face=arial,verdana size=2><b>Dt. Reanálise: </b>'+dtoc(qel->qel_dtaana)+'</font></td>'
	endif
endif
_cMsg += '</tr>'
_cMsg += '<tr>'

sa2->(dbsetorder(1))
sa2->(dbseek(_cfilsa2+qek->qek_fornec+qek->qek_lojfor))

_cMsg += '<td colspan="3"><font face=arial,verdana size=2><b>Fornecedor: </b>'+sa2->a2_nome+'</font></td>'

sd1->(dbsetorder(1))
sd1->(dbseek(_cfilsd1+qek->qek_ntfisc+qek->qek_serinf+qek->qek_fornec+qek->qek_lojfor+qek->qek_produt+qek->qek_itemnf))

_cMsg += '<td><font face=arial,verdana size=2><b>Lote: </b>'+sd1->d1_lotefor+'</font></td>'
_cMsg += '</tr>'
_cMsg += '</table>'
_cMsg += '<table width="698" align="center" cellpadding="0" cellspacing="0">'
_cMsg += '<tr>'

if mv_par03==1 // Laudo Analítico
	_cMsg += '<td width="155"><font face=arial,verdana size=2><b>Qtde.: </b>'+Transform((sd1->d1_quant),'@E 999,999,999.99')+' '+lower(sd1->d1_um)+'</font></td>'
else
	_cMsg += '<td width="155"><font face=arial,verdana size=2><b>Qtde.: </b>'+qek->qek_tamlot+' '+lower(qek->qek_unimed)+'</font></td>'
endif

_cMsg += '<td width="129"><font face=arial,verdana size=2><b>Nº Volume: </b>'+Transform((sd1->d1_numvol),'@E 9999')+' un</font></td>'
_cMsg += '<td width="125"><font face=arial,verdana size=2><b>NF/Série: </b>'+sd1->d1_doc+'/'+sd1->d1_serie+'</font></td>'
_cMsg += '<td width="120"><font face=arial,verdana size=2><b>Data NF: </b>'+dtoc(sd1->d1_emissao)+'</font></td>'
_cMsg += '<td width="169"><font face=arial,verdana size=2><b>Nº Pedido: </b>'+qek->qek_pedido+'</font></td>'
_cMsg += '</tr>'
_cMsg += '<tr>'
_cMsg += '<td colspan="4"><font face=arial,verdana size=2><b>Fabricante: </b>'+sd1->d1_fabric+'</font></td>'
_cMsg += '<td width="169"><font face=arial,verdana size=2><b>Lote: </b>'+sd1->d1_lotfabr+'</font></td>'
_cMsg += '</tr>'
_cMsg += '</table>'
_cMsg += '<table width="698" align="center" cellpadding="0" cellspacing="0">'
_cMsg += '<tr>'
_cMsg += '<td width="233"><font face=arial,verdana size=2><b>Fabricação: </b>'+dtoc(sd1->d1_dtfabr)+'</font></td>'
_cMsg += '<td width="233"><font face=arial,verdana size=2><b>Validade: </b>'+dtoc(sd1->d1_dtvalid)+'</font></td>'

if (qe6->qe6_tipo=="MP")  // MATÉRIA-PRIMA
	_cMsg += '<td width="232"><font face=arial,verdana size=2><b>Fórmula: </b>'+qe6->qe6_formol+'</font></td>'     //   Implementar cadastro e busca da fórmula qdo for o caso.
else
	_cMsg += '<td width="232">&nbsp;</td>' // MATERIAL DE EMBALAGEM
endif

_cMsg += '</tr>'
_cMsg += '<tr>'
_cMsg += '<td width="233">&nbsp;</td>'
_cMsg += '<td width="233">&nbsp;</td>'
_cMsg += '<td width="232">&nbsp;</td>'
_cMsg += '</tr>'
_cMsg += '</table>'
_cMsg += '</td>'
_cMsg += '</tr>'
_cMsg += '</table>'


//TABELA DE ESPECIFICAÇÕES - CABEÇALHO

_cMsg += '<table width="700" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg += '<tr>'
_cMsg += '<td height="22" width="200" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>TESTE</b></font></td>'
_cMsg += '<td width="325" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>ESPECIFICAÇÃO</b></font></td>'
_cMsg += '<td width="175" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>RESULTADO</b></font></td>'
_cMsg += '</tr>'


//TABELA DE ESPECIFICAÇÕES - ITENS

tmp1->(dbsetorder(2))
tmp1->(dbgotop())

while !(tmp1->(eof()))
	_cMsg += '<tr>'                                                                                                                                 //trim(tmp1->descensaio+tmp1->refer)
	_cMsg += '<td height="22" width="250" align="left" valign="middle"><font face=arial,verdana size=1><p style="margin-left: 4; margin-right: 0">'+trim(tmp1->descensaio)+'<sup> '+trim(tmp1->refer)+'</sup></font></td>'
	_cMsg += '<td width="325" align="left" valign="middle"><font face=arial,verdana size=1><p style="margin-left: 4; margin-right: 0">'+trim(tmp1->especifica)+'</font></td>'
	
	if nordem==1  // LAUDO EM BRANCO (SEM RESULTADOS)
		_cMsg += '<td width="125" align="left" valign="middle"><font face=arial,verdana size=1><p style="margin-left: 4; margin-right: 0">&nbsp;</font></td>'
	else
		_cMsg += '<td width="125" align="left" valign="middle"><font face=arial,verdana size=1><p style="margin-left: 4; margin-right: 0">'+trim(tmp1->medica)+'</font></td>'
	endif
	
	_cMsg += '<tr>'
	
	tmp1->(dbskip())
end

_cMsg += '</table>'


//  REFERÊNCIAS BIBLIOGRÁFICAS

_cMsg += '<table width="700" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg += '<tr>'
_cMsg += '<td height="22" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>REFERÊNCIA</b></font></td>'
_cMsg += '</tr>'
_cMsg += '<tr>'
_cMsg += '<td height="18" align="left">'
_cMsg += '<table width="690" border="0" align="left" cellpadding="0" cellspacing="0">'

qa2->(dbsetorder(2))
qa2->(dbseek(_cfilqa2+qe6->qe6_chave))

_chave:=qe6->qe6_chave
_texto:=""
_txtfin:=""

while !(qa2->(eof())) .and.;
	(qa2->qa2_chave==_chave)
	
	_texto:=qa2->qa2_texto
	_texto:=trim(_texto)
	if substr(_texto,(len(_texto)-5),6)=="\13\10"
		if _txtfin==""
			_txtfin:=substr(_texto,1,len(_texto)-6)
		else
			//_txtfin+=_texto
			_txtfin+=substr(_texto,1,len(_texto)-6)
		endif
		
		_cMsg += '<tr>'
		_cMsg += '<td height="18" align="left"><font face=arial,verdana size=1><b>'+_txtfin+'</b></font></td>'
		_cMsg += '</tr>'
		_txtfin:=""
	else
		_txtfin+=_texto
	endif
	qa2->(dbskip())
end

_cMsg += '</table>'
_cMsg += '</td></tr>'


// AVALIAÇÃO FINAL

_cMsg += '<tr>'
_cMsg += '<td height="22" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>AVALIAÇÃO FINAL</b></font></td>'
_cMsg += '</tr>'
_cMsg += '<tr>'
_cMsg += '<td height="80" valign="top">'
_cMsg += '<table width="690" cellpadding="0" cellspacing="0">'
_cMsg += '<tr valign="middle">'
_cMsg += '<td width="80" height="30">&nbsp; </td>'

if nordem==2  // 1-LAUDO EM BRANCO (SEM RESULTADOS)
	
	if (_avfinal=="A")
		_cMsg += '<td width="160"><font face=arial,verdana size=2>( x ) Aprovado</font></td>'
		_cMsg += '<td width="200"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado com Restrição</font></td>'
		_cMsg += '<td width="170"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Reprovado</font></td>'
	elseif (_avfinal=="B") .or. (_avfinal=="C")
		_cMsg += '<td width="160"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado</font></td>'
		_cMsg += '<td width="200"><font face=arial,verdana size=2>( x ) Aprovado com Restrição</font></td>'
		_cMsg += '<td width="170"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Reprovado</font></td>'
	elseif (_avfinal=="E")
		_cMsg += '<td width="160"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado</font></td>'
		_cMsg += '<td width="200"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado com Restrição</font></td>'
		_cMsg += '<td width="170"><font face=arial,verdana size=2>( x ) Reprovado</font></td>'
	else
		_cMsg += '<td width="160"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado</font></td>'
		_cMsg += '<td width="200"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado com Restrição</font></td>'
		_cMsg += '<td width="170"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Reprovado</font></td>'
	endif
	
else
	_cMsg += '<td width="160"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado</font></td>'
	_cMsg += '<td width="200"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado com Restrição</font></td>'
	_cMsg += '<td width="170"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Reprovado</font></td>'
endif
_cMsg += '<td width="80">&nbsp; </td>'
_cMsg += '</tr>'
_cMsg += '</table>'

if nordem==1  // LAUDO EM BRANCO (SEM RESULTADOS)
	_cMsg += '<font face="arial,verdana" size="1">OBS.: ___________________________________________________________________________________________________________</br></br></font>'
	// a linha de código abaixo foi incluída em 05/03/2008, por solicitação do CQ, conforme ocomon nº 2400.
	_cMsg += '<font face="arial,verdana" size="1">_________________________________________________________________________________________________________________</font>'

	_cMsg += '<br>'
	_cMsg += '<br>'
	_cMsg += '<font face="arial,verdana" size="2">'
	_cMsg += 'Data de Liberação e/ou Rejeição: ____/____/____&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
	_cMsg += '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Hora: ____:____</br></br>'
	_cMsg += '</font>'
else
	_cMsg += '<font face="arial,verdana" size="1">OBS.: '+qel->qel_justla+'</font>'
	_cMsg += '<br>'
	_cMsg += '<font face="arial,verdana" size="2">'
	_cMsg += 'Data de Liberação e/ou Rejeição: '+dtoc(qel->qel_dtlaud)+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'
	_cMsg += '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Hora: '+qel->qel_hrlaud
	_cMsg += '</font>'
endif

_cMsg += '</td>'
_cMsg += '</tr>'
_cMsg += '<tr valign="middle">'
_cMsg += '<td><br>'
_cMsg += '<table cellpadding="0" cellspacing="0" width="690">'
_cMsg += '<tr>'
_cMsg += '<td width="30">&nbsp; </td>'
_cMsg += '<td>________________________________________</td>'
_cMsg += '<td width="30">&nbsp; </td>'
_cMsg += '<td>________________________________________</td>'
_cMsg += '<td width="30">&nbsp; </td>'
_cMsg += '</tr>'
_cMsg += '<tr valign="top">'
_cMsg += '<td width="30">&nbsp; </td>'
_cMsg += '<td align="center" valign="top"><font face="arial,verdana" size="2">Analista do Controle de Qualidade</font></td>'
_cMsg += '<td width="30">&nbsp; </td>'
_cMsg += '<td align="center" valign="top"><font face="arial,verdana" size="2">Responsável do Controle de Qualidade</font></td>'
_cMsg += '<td width="30">&nbsp; </td>'
_cMsg += '</tr>'
_cMsg += '</table>'
_cMsg += '<br>'
_cMsg += '</td>'
_cMsg += '</tr>'
_cMsg += '</table>'

_cMsg += '<table cellpadding="0" cellspacing="0" width="700" border="0" align="center">'
_cMsg += '<tr><td align="right">'
_cMsg += '<font face="arial,verdana" size="1">Rev.: '+qe6->qe6_revi+' - '+dtoc(qe6->qe6_dtini)+'</font>'
_cMsg += '<font face="arial,verdana" size="1"><br><br>Impressão: '+dtoc(date())+'  '+time()+' h</font>'
_cMsg += '</td></tr></table>'

//³ ENCERRA O CÓDIGO HTML

_cMsg += '</body>'
_cMsg += '</html>'


_cindtmp11+=tmp1->(ordbagext())
_cindtmp12+=tmp1->(ordbagext())

tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())

ferase(_cindtmp11)
ferase(_cindtmp12)

//³ cria o arquivo em disco vit273.html e executa-o em seguida
_carquivo:="C:\WINDOWS\TEMP\LAUDOTECNICO.HTML"
nHdl := fCreate(_carquivo)
fWrite(nHdl,_cMsg,Len(_cMsg))
fClose(nHdl)
ExecArq(_carquivo)

set device to screen

ms_flush()
return

//***********************************************************************
static function _montalau()
//***********************************************************************

qek->(dbsetorder(6))
qek->(dbseek(_cfilqek+_lote))

_lotrea:=.f.

if mv_par03==2         
		
	while !qek->(eof()) .and.;
		qek->qek_lote=_lote .and.;
		!_lotrea
		
		if substr(qek->qek_tipdoc,1,2)=="TR"
			_lotrea:= .t.
		else
			qek->(dbskip())				
		endif
			
	end
endif		

if mv_par03==2 .and. !_lotrea
	return
endif


if mv_par03==1
	while !qek->(eof()) .and.;
		qek->qek_lote=_lote .and.;
		!_lotrea
		
		if substr(qek->qek_tipdoc,1,2)=="NF"
			_lotrea:= .t.
		else
			qek->(dbskip())				
		endif			
	end		
endif

if mv_par03==1 .and. !_lotrea
	return
endif


// BUSCA OS ENSAIOS MENSURÁVEIS
qe7->(dbsetorder(2))
qe7->(dbseek(_cfilqe7+mv_par01+qek->qek_revi+"  "))

while !qe7->(eof()) .and.;
	qe7->qe7_produt==mv_par01 .and.;
	qe7->qe7_revi==qek->qek_revi
	
	if !(tmp1->(dbseek(qe7->qe7_ensaio+qe7->qe7_labor+qe7->qe7_seqlab)))
		
		qe1->(dbsetorder(1))
		qe1->(dbseek(_cfilqe1+qe7->qe7_ensaio))
		
		qer->(dbordernickname("QERVIT01"))
 		qer->(dbseek(_cfilqer+qek->qek_produt+qek->qek_revi+qek->qek_fornec+qek->qek_lojfor+dtos(qek->qek_dtentr)+qek->qek_lote+qe7->qe7_labor+qe7->qe7_ensaio))
		
		qes->(dbsetorder(1))
		qes->(dbseek(_cfilqes+qer->qer_chave))
		
		sah->(dbsetorder(1))
		sah->(dbseek(_cfilsah+qe7->qe7_unimed))
		
		_medica1:=0
		_totens:=0
		_decimais:=0
		
		_medicao:=MudaVirPt(qes->qes_medica)  // Muda identificador de decimais de "," para "."
		
		_medicao:= alltrim(_medicao)  // O campo qes_medica esta duplicado no arquivo "existe 2 resultados com a mesma medição"
		
		for _i:=1 to len(_medicao)
			if (substr(_medicao,_i,1)==",") .or.;
				(substr(_medicao,_i,1)==".")
				_decimais:= len(_medicao)-_i
			endif
		next
		
		set fixed on
		set decimals to _decimais
		
		/*
		// comentado este trecho, devido ao valor do RESULTADO estar diferente do apresentado no protheus - g.sampaio 25/05/2018
		while !qes->(eof()) .and.;
			qes->qes_codmed==qer->qer_chave
			
			_medicao:=MudaVirPt(qes->qes_medica)  // Muda identificador de decimais de "," para "."
			_medicao:= alltrim(_medicao) // O campo qes_medica esta duplicado no arquivo "existe 2 resultados com a mesma medição"
			
			_medica1+=val(_medicao)/2
			_totens++
			
			qes->(dbskip())
		end             
		
		_medicao:=alltrim(str(_medica1))
		_medicao:=MudaPtVir(_medicao)  // Muda identificador de decimais de "." para ","
		*/
		
		tmp1->(dbappend())
		
		tmp1->ensaio     := qe7->qe7_ensaio    
		tmp1->descensaio := alltrim(qe1->qe1_descpo)+" "+alltrim(qe7->qe7_obs)

		tmp1->labor      := qe7->qe7_labor
		tmp1->seqlab     := qe7->qe7_seqlabor
		tmp1->refer      := qe7->qe7_refer
		
		// Verifica na especificação o controle de máximo e mínimo/ Somente Mínimo / somente Máximo
		// Incluído em 16/11/2006 - Alex Júnio - Conforme chamado nº 3086.
		// Soma ao valor nominal o valor minimo e Máximo conforme chamado nº 426 de 27/02/07 


		if qe7->qe7_minmax=="1"				// Controla Máximo e Mínimo 		
			if sah->ah_unimed=='12'	
				tmp1->especifica := alltrim(qe7->qe7_nominal)+" ("+alltrim(qe7->qe7_lie)+" - "+alltrim(qe7->qe7_lse)+") "
			else
				tmp1->especifica := alltrim(qe7->qe7_nominal)+" "+alltrim(sah->ah_umres)+" ("+alltrim(qe7->qe7_lie)+" - "+alltrim(qe7->qe7_lse)+") "+alltrim(sah->ah_umres)
			endif
		elseif qe7->qe7_minmax=="2"			// Controla Somente Mínimo  
//		   _nval := val(qe7->qe7_nominal)+val(qe7->qe7_lie)
			if sah->ah_unimed=='12'
				tmp1->especifica := "Mínimo    "+alltrim(qe7->qe7_lie)  //Guilherme 02/09/2015 //Correção do texto "Minimo de" para "Minimo"
			else
				tmp1->especifica := "Mínimo    "+alltrim(qe7->qe7_lie)+" "+alltrim(sah->ah_umres) //Guilherme 02/09/2015 //Correção do texto "Minimo de" para "Minimo"
			endif
		else								// Controla Somente Máximo
//		  _nval :=val(qe7->qe7_nominal)+val(qe7->qe7_lse)
			if sah->ah_unimed=='12'
				tmp1->especifica := "Máximo    "+alltrim(qe7->qe7_lse) //Guilherme 02/09/2015 //Correção do texto "Maximo de" para "Maximo"
			else
				tmp1->especifica := "Máximo    "+alltrim(qe7->qe7_lse)+" "+alltrim(sah->ah_umres) //Guilherme 02/09/2015 //Correção do texto "Maximo de" para "Maximo"
			endif
		endif
		
		if sah->ah_unimed=='12'
			tmp1->medica     := _medicao
		else
			tmp1->medica     := _medicao+" "+alltrim(sah->ah_umres)
		endif
		set fixed off
		
	endif
	
	qe7->(dbskip())
	
end


// BUSCA OS ENSAIOS TIPO TEXTO
qe8->(dbsetorder(2))
qe8->(dbseek(_cfilqe8+mv_par01+qek->qek_revi+"  "))

while !qe8->(eof()) .and.;
	qe8->qe8_produt==mv_par01 .and.;
	qe8->qe8_revi==qek->qek_revi
	if !(tmp1->(dbseek(qe8->qe8_ensaio+qe8->qe8_labor+qe8->qe8_seqlab+qe8->qe8_refer)))
		if !qe8->qe8_refer$"(I)  "
		
			qe1->(dbsetorder(1))
			qe1->(dbseek(_cfilqe1+qe8->qe8_ensaio))
			
			qer->(dbordernickname("QERVIT01"))
			qer->(dbseek(_cfilqer+qek->qek_produt+qek->qek_revi+qek->qek_fornec+qek->qek_lojfor+dtos(qek->qek_dtentr)+qek->qek_lote+qe8->qe8_labor+qe8->qe8_ensaio))
			
			qeq->(dbsetorder(1))
			qeq->(dbseek(_cfilqeq+qer->qer_chave))
			
			tmp1->(dbappend())        
				
			tmp1->refer      := qe8->qe8_refer
			tmp1->ensaio     := qe8->qe8_ensaio
			tmp1->descensaio := qe1->qe1_descpo //+"-"+qe7->qe7_refer
			tmp1->labor      := qe8->qe8_labor
			tmp1->seqlab     := qe8->qe8_seqlabor
			tmp1->especifica := qe8->qe8_texto
			tmp1->medica     := alltrim(qeq->qeq_medica)
			
		endif
	endif	
	qe8->(dbskip())	
end

return


//***********************************************************************
Static Function MudaVirPt(_medicao)
//***********************************************************************

_medresul:=""

for _j:=1 to len(_medicao)
	if (substr(_medicao,_j,1)==",") .or.;
		(substr(_medicao,_j,1)==".")
		_medresul+= "."
	else
		_medresul+= substr(_medicao,_j,1)
	endif
next

return(_medresul)



//***********************************************************************
Static Function MudaPtVir(_medicao)
//***********************************************************************

_medresul:=""

for _j:=1 to len(_medicao)
	if (substr(_medicao,_j,1)==".")
		_medresul+= ","
	else
		_medresul+= substr(_medicao,_j,1)
	endif
next

return(_medresul)


//***********************************************************************
Static Function LocSubLote(_produto,_lote)
//***********************************************************************

_sublote:=""

_cquery:=" SELECT"
_cquery+=" D5_LOTECTL||D5_NUMLOTE LOTE"
_cquery+=" FROM "
_cquery+= retsqlname("SD5")+" SD5"
_cquery+=" WHERE D_E_L_E_T_=' '"
_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
_cquery+=" AND D5_PRODUTO='"+_produto+"'"
_cquery+=" AND D5_LOTECTL='"+_lote+"'"
_cquery+=" AND D5_ESTORNO<>'S'"
_cquery+=" AND D5_LOCAL='98'"
_cquery+=" AND D5_CLIFOR<>' '"
                                  
_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP2"

tmp2->(dbgotop())

_sublote:=tmp2->lote

tmp2->(dbclosearea())

return(_sublote)




//***********************************************************************
Static Function ExecArq(_carquivo)
//***********************************************************************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := _carquivo

SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)

//³ Faz a chamada do aplicativo associado                                  ³
nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

If nRet <= 32
	cCompl := ""
	If nRet == 31
		cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
	EndIf
	Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
EndIf

Return



//***********************************************************************
static function _pergsx1()
//***********************************************************************
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Produto            ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"02","Lote               ?","mv_ch2","C",10,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Imprime            ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par03"       ,"Analise"        ,space(30),space(15),"Reanalise"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})                                        

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

/* CÓDIGO ORIGINAL DO HTML

<html>
<head>
<title>Laudo T&eacute;cnico Anal&iacute;tico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<table width="700" height="44" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">
<tr>
<td width="150" height="44"><img src="file://///logon/remote/relatorio/duplicata/logo.jpg" width="129" height="41"></td>
<td width="548" align="center" valign="middle"><font face=arial,verdana size=4><b>LAUDO TÉCNICO ANAL&Iacute;TICO</b></font></td>
</tr>
<tr>
<td colspan="2">
<table width="698" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="175"><font face=arial,verdana size=2><b>Código: </b>999999</font></td>
<td colspan="3"><font face=arial,verdana size=2><b>Descrição: </b>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</font></td>
</tr>
<tr>
<td width="175"><font face=arial,verdana size=2><b>Data: </b>99/99/9999</font></td>
<td width="174"><font face=arial,verdana size=2><b>Lote: </b>AUTO999999</font></td>
<td width="179"><font face=arial,verdana size=2><b>Nº Análise: </b>99/999/999999</font></td>
<td width="170"><font face=arial,verdana size=2><b>Dt. Análise: </b>99/99/9999</font></td>
</tr>
<tr>
<td colspan="3"><font face=arial,verdana size=2><b>Fornecedor: </b>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</font></td>
<td><font face=arial,verdana size=2><b>Lote: </b>999999999999999</font></td>
</tr>
</table>
<table width="698" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="155"><font face=arial,verdana size=2><b>Qtde.: </b>9.999.999,99 UN</font></td>
<td width="129"><font face=arial,verdana size=2><b>Nº Volume: </b>999 Un</font></td>
<td width="125"><font face=arial,verdana size=2><b>NF/Série: </b>025145/1</font></td>
<td width="120"><font face=arial,verdana size=2><b>Data NF: </b>99/99/99</font></td>
<td width="169"><font face=arial,verdana size=2><b>Nº Pedido: </b>015984</font></td>
</tr>
<tr>
<td colspan="4"><font face=arial,verdana size=2><b>Fabricante: </b>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</font></td>
<td width="169"><font face=arial,verdana size=2><b>Lote: </b>015984/2006</font></td>
</tr>
</table>
<table width="698" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="233"><font face=arial,verdana size=2><b>Fabricação: </b>99/99/9999</font></td>
<td width="233"><font face=arial,verdana size=2><b>Validade: </b>99/99/9999</font></td>
<td width="232"><font face=arial,verdana size=2><b>Fórmula: </b>C6H10N10</font></td>
</tr>
</table>
</td>
</tr>
</table>

<table width="700" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">
<tr>
<td height="22" width="200" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>TESTE</b></font></td>
<td width="325" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>ESPECIFICAÇÃO</b></font></td>
<td width="175" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>RESULTADO</b></font></td>
</tr>
<tr>
<td height="22" width="200" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; TESTE</font></td>
<td width="325" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; ESPECIFICAÇÃO</font></td>
<td width="175" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; RESULTADO</font></td>
</tr>
<tr>
<td height="22" width="200" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; TESTE 1</font></td>
<td width="325" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; ESPECIFICAÇÃO 1</font></td>
<td width="175" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; RESULTADO 1</font></td>
</tr>
<tr>
<td height="22" width="200" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; TESTE 2</font></td>
<td width="325" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; ESPECIFICAÇÃO 2</font></td>
<td width="175" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; RESULTADO 2</font></td>
</tr>
<tr>
<td height="22" width="200" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; TESTE 3</font></td>
<td width="325" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; ESPECIFICAÇÃO 3</font></td>
<td width="175" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; RESULTADO 3</font></td>
</tr>
<tr>
<td height="22" width="200" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; TESTE 4</font></td>
<td width="325" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; ESPECIFICAÇÃO 4</font></td>
<td width="175" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; RESULTADO 4</font></td>
</tr>
<tr>
<td height="22" width="200" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; TESTE 5</font></td>
<td width="325" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; ESPECIFICAÇÃO 5</font></td>
<td width="175" align="left" valign="middle"><font face=arial,verdana size=1>&nbsp; RESULTADO 5</font></td>
</tr>
</table>


/// DAQUI


<table width="700" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">
<tr>
<td height="22" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>REFERÊNCIA</b></font></td>
</tr>
<tr>
<td height="18" align="left"><font face=arial,verdana size=1><b>&nbsp; (1) Desenvolvimento Local</b></font></td>
</tr>
<tr>
<td height="22" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>AVALIAÇÃO FINAL</b></font></td>
</tr>
<tr>
<td height="80" valign="top">
<table width="690" cellpadding="0" cellspacing="0">
<tr valign="middle">
<td width="80" height="30">&nbsp; </td>
<td width="160"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado</font></td>
<td width="200"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Aprovado com Restrição</font></td>
<td width="170"><font face=arial,verdana size=2>(&nbsp; &nbsp; ) Reprovado</font></td>
<td width="80">&nbsp; </td>
</tr>
</table>
<font face="arial,verdana" size="1">OBS.: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</font>
<br>
<font face="arial,verdana" size="2">
Data de Liberação e/ou Rejeição: 99/99/9999 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Hora: 99:99
</font>
</td>
</tr>
<tr valign="middle">
<td><br>
<table cellpadding="0" cellspacing="0" width="690">
<tr>
<td width="30">&nbsp; </td>
<td>________________________________________</td>
<td width="30">&nbsp; </td>
<td>________________________________________</td>
<td width="30">&nbsp; </td>
</tr>
<tr valign="top">
<td width="30">&nbsp; </td>
<td align="center" valign="top"><font face="arial,verdana" size="2">Analista do Controle de Qualidade</font></td>
<td width="30">&nbsp; </td>
<td align="center" valign="top"><font face="arial,verdana" size="2">Responsável do Controle de Qualidade</font></td>
<td width="30">&nbsp; </td>
</tr>
</table>
<br>
</td>
</tr>
</table>
</body>
</html>



*/
