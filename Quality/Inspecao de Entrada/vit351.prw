/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT351   ³Autor ³ Alex Júnio de Miranda   ³Data ³ 14/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Especificacao Tecnica - Inspecao de Entradas               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function VIT351()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="ESPECIFICACAO TECNICA - INSPECAO DE ENTRADAS"
cdesc1   :="Este programa ira emitir o espelho da Especificação Técnica"
cdesc2   :="incluída no módulo Inspeção de Entradas, conforme produto"
cdesc3   :="e revisão informados."
cstring  :="QEK"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT351"
wnrel    :="VIT351"+Alltrim(cusername)
alinha   :={}
aordem	:={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

_cperg:="PERGVIT351"
_pergsx1()
pergunte(_cperg,.f.)

wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

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
_cfilqe1:=xfilial("QE1")
_cfilqe6:=xfilial("QE6")
_cfilqe7:=xfilial("QE7")
_cfilqe8:=xfilial("QE8")
_cfilqa2:=xfilial("QA2")
_cfilsah:=xfilial("SAH")
_cfilsb1:=xfilial("SB1")

qe1->(dbsetorder(1))
qe6->(dbsetorder(3))
qe7->(dbsetorder(2))
qe8->(dbsetorder(2))
qa2->(dbsetorder(2))
sah->(dbsetorder(1))    
sb1->(dbsetorder(1))    

_cMsg := ""

_aestrut:={}
aadd(_aestrut,{"ENSAIO"     ,"C",008,0})
aadd(_aestrut,{"DESCENSAIO" ,"C",060,0})
aadd(_aestrut,{"LABOR"      ,"C",006,0})
aadd(_aestrut,{"SEQLAB"     ,"C",002,0})
aadd(_aestrut,{"ESPECIFICA" ,"C",500,0})
//aadd(_aestrut,{"MEDICA"     ,"C",050,0})
aadd(_aestrut,{"REFER     " ,"C",005,0})
aadd(_aestrut,{"METODO    " ,"C",012,0})

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

_cMsg += '<title>especificação Técnica - Inspeção de Entradas</title>'

_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
_cMsg += '</head>'
_cMsg += '<body>'


//³ INÍCIO DA TABELA (CABEÇALHO - TÍTULO)

_cMsg += '<table width="700" height="44" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg += '<tr>'
_cMsg += '<td width="150" height="44"><img src="file://///srv-gti-01/remote/figuras/logo.jpg" width="129" height="41"></td>'

_cMsg += '<td width="548" align="center" valign="middle"><font face=arial,verdana size=4><b>ESPECIFICA&Ccedil;&Atilde;O T&Eacute;CNICA</b></font></td>'
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

qe6->(dbsetorder(3))
qe6->(dbseek(_cfilqe6+mv_par01+mv_par02))

_cMsg += '<tr>'
_cMsg += '<td width="175"><font face=arial,verdana size=2><b>Código: </b>'+substr(qe6->qe6_produt,1,6)+'</font></td>'

_cMsg += '<td colspan="3"><font face=arial,verdana size=2><b>Descrição: </b>'+qe6->qe6_descpo+'</font></td>'
_cMsg += '</tr>'
_cMsg += '<tr>'

sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+mv_par01))

_cMsg += '<td width="175"><font face=arial,verdana size=2><b>Categoria: </b>'+qe6->qe6_categ+'</font></td>'
_cMsg += '<td width="174"><font face=arial,verdana size=2><b>DCB: </b>'+sb1->b1_dcb1+'</font></td>'

if (qe6->qe6_tipo=="MP")  // MATÉRIA-PRIMA
	_cMsg += '<td width="179"><font face=arial,verdana size=2><b>F&oacute;rmula Molecular: </b>'+qe6->qe6_formol+'</font></td>'
	_cMsg += '<td width="170"><font face=arial,verdana size=2><b>Peso Molecular: </b>'+Transform((qe6->qe6_pesmol),'@E 99,999.99')+'</font></td>'
else 
	_cMsg += '<td width="179"><font face=arial,verdana size=2><b>F&oacute;rmula Molecular: </b>&nbsp;</font></td>'
	_cMsg += '<td width="170"><font face=arial,verdana size=2><b>F&oacute;rmula Molecular: </b>&nbsp;</font></td>'
endif

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
_cMsg += '<td width="075" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>REFERÊNCIA</b></font></td>'
_cMsg += '<td width="100" align="center" bgcolor="#E9E9E9"><font face=arial,verdana size=2><b>MÉTODO</b></font></td>'
_cMsg += '</tr>'


//TABELA DE ESPECIFICAÇÕES - ITENS

tmp1->(dbsetorder(2))
tmp1->(dbgotop())

while !(tmp1->(eof()))
	_cMsg += '<tr>'
	_cMsg += '<td height="22" width="250" align="left" valign="middle"><font face=arial,verdana size=1><p style="margin-left: 4; margin-right: 0">'+trim(tmp1->descensaio)+'</p></font></td>'
	_cMsg += '<td width="325" align="left" valign="middle"><font face=arial,verdana size=1><p style="margin-left: 4; margin-right: 0">'+trim(tmp1->especifica)+'</p></font></td>'
	
	_cMsg += '<td width="075" align="left" valign="middle"><font face=arial,verdana size=1><p align="center">'+trim(tmp1->refer)+'</p></font></td>'
	_cMsg += '<td width="100" align="left" valign="middle"><font face=arial,verdana size=1><p align="center">'+trim(tmp1->metodo)+'</p></font></td>'
	
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

//³ cria o arquivo em disco especificacao.html e executa-o em seguida
_carquivo:="C:\WINDOWS\TEMP\ESPECIFICACAO.HTML"
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

qe6->(dbsetorder(3))
qe6->(dbseek(_cfilqe6+mv_par01+mv_par02))

// BUSCA OS ENSAIOS MENSURÁVEIS
qe7->(dbsetorder(2))
qe7->(dbseek(_cfilqe7+mv_par01+mv_par02+"  "))

while !qe7->(eof()) .and.;
	qe7->qe7_produt==mv_par01 .and.;
	qe7->qe7_revi==mv_par02
	
	if !(tmp1->(dbseek(qe7->qe7_ensaio+qe7->qe7_labor+qe7->qe7_seqlab)))
		
		qe1->(dbsetorder(1))
		qe1->(dbseek(_cfilqe1+qe7->qe7_ensaio))
		
		sah->(dbsetorder(1))
		sah->(dbseek(_cfilsah+qe7->qe7_unimed))
		
		_medica1:=0
		_totens:=0
		_decimais:=0
			
		tmp1->(dbappend())
		
		tmp1->ensaio     := qe7->qe7_ensaio    
		tmp1->descensaio := alltrim(qe1->qe1_descpo)+" "+alltrim(qe7->qe7_obs)
		tmp1->labor      := qe7->qe7_labor
		tmp1->seqlab     := qe7->qe7_seqlabor
		tmp1->refer      := qe7->qe7_refer
		tmp1->metodo     := qe7->qe7_metodo
		
		// Verifica na especificação o controle de máximo e mínimo/ Somente Mínimo / somente Máximo

		if qe7->qe7_minmax=="1"				// Controla Máximo e Mínimo 		
			tmp1->especifica := alltrim(qe7->qe7_nominal)+" "+alltrim(sah->ah_umres)+" ("+alltrim(qe7->qe7_lie)+" - "+alltrim(qe7->qe7_lse)+") "+alltrim(sah->ah_umres)
		elseif qe7->qe7_minmax=="2"		// Controla Somente Mínimo  
			tmp1->especifica := "Mínimo "+alltrim(qe7->qe7_lie)+" "+alltrim(sah->ah_umres)
		else										// Controla Somente Máximo
			tmp1->especifica := "Máximo "+alltrim(qe7->qe7_lse)+" "+alltrim(sah->ah_umres)
		endif		
	endif
	
	qe7->(dbskip())
end


// BUSCA OS ENSAIOS TIPO TEXTO
qe8->(dbsetorder(2))
qe8->(dbseek(_cfilqe8+mv_par01+mv_par02+"  "))

while !qe8->(eof()) .and.;
	qe8->qe8_produt==mv_par01 .and.;
	qe8->qe8_revi==mv_par02
	if !(tmp1->(dbseek(qe8->qe8_ensaio+qe8->qe8_labor+qe8->qe8_seqlab+qe8->qe8_refer)))
		if !qe8->qe8_refer$"(I)  "
		
			qe1->(dbsetorder(1))
			qe1->(dbseek(_cfilqe1+qe8->qe8_ensaio))
			
			tmp1->(dbappend())        
				
			tmp1->ensaio     := qe8->qe8_ensaio
			tmp1->descensaio := AllTrim(qe1->qe1_descpo) +" "+AllTrim(qe8->qe8_obs) 
			tmp1->labor      := qe8->qe8_labor
			tmp1->seqlab     := qe8->qe8_seqlabor
			tmp1->especifica := qe8->qe8_texto
			tmp1->refer      := qe8->qe8_refer
			tmp1->metodo     := qe8->qe8_metodo			
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
aadd(_agrpsx1,{_cperg,"01","Produto            ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QE6"})
aadd(_agrpsx1,{_cperg,"02","Revisao            ?","mv_ch2","C",02,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

