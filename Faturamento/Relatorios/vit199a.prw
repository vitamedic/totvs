/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT199   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 08/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ficha Tecnica de Produto                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

User Function VIT199a()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="FICHA TECNICA DE PRODUTO"
cdesc1   :="Este programa ira emitir a ficha tecnica do Produto"
cdesc2   :=""
cdesc3   :=""
cstring  :="DA1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT199A"
wnrel    :="VIT199A"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT199"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

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
_cfilsb1:=xfilial("SB1")
_cfilda1:=xfilial("DA1")        
_cfilda0:=xfilial("DA0")
sb1->(dbsetorder(1))
da1->(dbsetorder(2))    
da0->(dbsetorder(1))

_cAssunto:= 'FICHA TÉCNICA DE PRODUTO'
_cMsg := ""        
_prcven17:=0
_prcven18:=0
_prcven19:=0
_prcvenzfm:=0

processa({|| _querys()})      //³ Produtos do parâmetro
processa({|| _query2()})		//³ Tabelas válidas

setregua(sb1->(lastrec()))

tmp1->(dbgotop())

//³ Início do código HTML

_cMsg := ""
_cMsg += '<html>'
_cMsg += '<head>'
_cMsg += '<title>Ficha Técnica de Produto</title>'
_cMsg += '</head>'
_cMsg += '<body>'

while ! tmp1->(eof()) .and.;
      lcontinua

   if labortprint
		_cMsg += '***** CANCELADO PELO OPERADOR *****'
   	lcontinua:=.f.
	endif  
   
   _prod:= tmp1->cod 	

   _cMsg += '<table cellpadding="0" cellspacing="0" width="700" height="44" border="0" align="center">'
	_cMsg += '<tr>'
	_cMsg += '<td><img src="C:\WINDOWS\TEMP\logo.jpg" width="129" height="41"></td>'
	_cMsg += '<td width="500" align=right valign=bottom><font face=arial,verdana size=4><b>FICHA TÉCNICA DE PRODUTO</b></font></td>'
	_cMsg += '</tr>'
	_cMsg += '</table>'
	_cMsg += '<table cellpadding="0" cellspacing="0" width="700" border="0" height="2" align="center">'
	_cMsg += '<tr>'
	_cMsg += '<td width="700"><img src="C:\WINDOWS\TEMP\pixc.gif" width="100%" height="2"></td>'
	_cMsg += '</tr></table>'
	_cMsg += '<br>'
	_cMsg += '<table cellpadding="0" cellspacing="0" width="700" border="0" align="center">'
//	_cMsg += '<tr>'
//	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Código:</font></td>'
//	_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+tmp1->cod+'</b></font></td>'
//	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Produto:</font></td>'
	_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b><u>'+tmp1->descri+'</u></b></font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Princípio Ativo:</font></td>'
	_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+tmp1->desccie+'</b></font></td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Apresentação:</font></td>'
	_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+tmp1->apres+'</b></font></td>'
	_cMsg += '</tr>'

//
// OCULTADOS PROVISORIAMENTE PARA POSTERIOR IMPLEMENTAÇÃO DOS CAMPOS
//

//	_cMsg += '<tr>'
//	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Produto de Referência:</font></td>'
//	_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>AAS</b></font></td>'
//	_cMsg += '</tr>'
//	_cMsg += '<tr>'
//	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Classe Terapêutica:</font></td>'
//	_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>ANTIINFLAMATÓRIO</b></font></td>'
//	_cMsg += '</tr>'
//	_cMsg += '<tr>'
//	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Indicações:</font></td>'
//	_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>Analgésico, antitérmico e antiinflamatório</b></font></td>'
//	_cMsg += '</tr>'
//	_cMsg += '<tr>'
//	_cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Linha:</font></td>'
//	_cMsg += '<td width=450 valign="middle">'
//	_cMsg += '<table cellpadding="0" cellspacing="0" width="450" border="0" align="left">'
//	_cMsg += '<tr>'
   
//	If (tmp1->apreven == '1')//Produto venda comercial - farma
//  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>( X ) FARMA</b></font></td>'
//  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) HOSPITALAR</b></font></td>'
//     _cMsg += '</tr>'
//   _cMsg += '<tr>'
//   _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) GENÉRICO</b></font></td>'
//   _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) HOSPITALAR</b></font></td>'
//   elseif (tmp1->apreven == '2')//Produto venda hospitalar
//  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) FARMA</b></font></td>'
//  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>( X ) HOSPITALAR</b></font></td>'
//     _cMsg += '</tr>'
//   _cMsg += '<tr>'
//   _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) GENÉRICO</b></font></td>'
//   _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>( X ) HOSPITALAR</b></font></td>'

/* CÓDIGO PARA PROVÁVEL CRIAÇÃO DE TIPOS OTC E GENÉRICO

     elseif (tmp1->apreven == '3')//Produto venda OTC
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) FARMA</b></font></td>'
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) OTC</b></font></td>'
     _cMsg += '</tr>'
     _cMsg += '<tr>'
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) GENÉRICO</b></font></td>'
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>( X ) HOSPITALAR</b></font></td>'
   elseif (tmp1->apreven == '4')//Produto venda Genérico
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) FARMA</b></font></td>'
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) OTC</b></font></td>'
     _cMsg += '</tr>'
     _cMsg += '<tr>'
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) GENÉRICO</b></font></td>'
  	  _cMsg += '<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>( X ) HOSPITALAR</b></font></td>'
*/       
//   endif 

//	_cMsg += '</tr>'
//   _cMsg += '</table>'
//   _cMsg += '</td>'
//   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Psicotrópico (Port. 344/98):</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) SIM &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ( X ) NÃO</b></font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Farm. Resp.:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>DRA. GIOVANA BETTONI</b></font></td>'
   _cMsg += '</tr>'
//   _cMsg += '<tr>'
//   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Origem:</font></td>'
//   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>BRASIL</b></font></td>'
//   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Registro M.S. nº:</font></td>'                                                                                      
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+substr(tmp1->anvisa,1,1)+'.'+substr(tmp1->anvisa,2,4)+'.'+substr(tmp1->anvisa,6,4)+'.'+substr(tmp1->anvisa,10,3)+'-'+substr(tmp1->anvisa,13,1)+'</b></font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Código de Barras Unidade:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+tmp1->codbar+'</b></font></td>'
   _cMsg += '</tr>'
//   _cMsg += '<tr>'
//   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Código de Barras Caixa de Embarque:</font></td>'
//   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>9999999999999</b></font></td>'
//   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Nº Denomin. Comum Brasileira (DCB):</font></td>'      
	if (tmp1->dcb2<>' ')
		if (tmp1->dcb3<>' ')
			_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+substr(tmp1->dcb1,1,5)+'.'+substr(tmp1->dcb1,6,2)+'-'+substr(tmp1->dcb1,8,1)
			_cMsg += ' / '+substr(tmp1->dcb2,1,5)+'.'+substr(tmp1->dcb2,6,2)+'-'+substr(tmp1->dcb2,8,1)
			_cMsg += ' / '+substr(tmp1->dcb3,1,5)+'.'+substr(tmp1->dcb3,6,2)+'-'+substr(tmp1->dcb3,8,1)+'</b></font></td>'
		else
			_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+substr(tmp1->dcb1,1,5)+'.'+substr(tmp1->dcb1,6,2)+'-'+substr(tmp1->dcb1,8,1)
			_cMsg += ' / '+substr(tmp1->dcb2,1,5)+'.'+substr(tmp1->dcb2,6,2)+'-'+substr(tmp1->dcb2,8,1)+'</b></font></td>'
		endif
	else
		_cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+substr(tmp1->dcb1,1,5)+'.'+substr(tmp1->dcb1,6,2)+'-'+substr(tmp1->dcb1,8,1)+'</b></font></td>'
	endif
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Classificação Fiscal:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+substr(tmp1->posipi,1,4)+'.'+substr(tmp1->posipi,5,2)+'.'+substr(tmp1->posipi,7,2)+'</b></font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Classificação Fiscal DL 10.147:</font></td>'
	If (tmp1->grtrib=='001' .or. tmp1->grtrib=='003')
     _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>( X ) POSITIVO &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (&nbsp; &nbsp; ) NEGATIVO</b></font></td>'
   elseif (tmp1->grtrib=='002' .or. tmp1->grtrib=='004' .or. tmp1->grtrib=='005')
     _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) POSITIVO &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ( X ) NEGATIVO</b></font></td>'
   else
     _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) POSITIVO &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (&nbsp; &nbsp; ) NEGATIVO</b></font></td>'     
   endif
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Caixa de Embarque:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+Transform(tmp1->cxpad,'@E 9999')+' UNIDADES</b></font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Validade:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+Transform((tmp1->prvalid / 365),'@E 999')+' ANOS</b></font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Temperatura de Estocagem:</font></td>'
   _cMsg += ' <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>15º a 30ºC</b></font></td>'
   _cMsg += '</tr>'
//   _cMsg += '<tr>'
//   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Dimensão do Cartucho:</font></td>'
//   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>128 × 50 × 66 mm </b></font></td>'
//   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Peso do Cartucho:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+Transform((tmp1->peso*1000),'@E 9999')+'g</b></font></td>'
   _cMsg += '</tr>'
//   _cMsg += '<tr>'
//   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Dimensão da Caixa Padrão:</font></td>'
//   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>128 × 50 × 66 mm </b></font></td>'
//   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Peso Bruto da Caixa Padrão:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2"><b>'+Transform((tmp1->pesbru*tmp1->cxpad),'@E 9999.9999')+'Kg</b></font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">&nbsp; </font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2">&nbsp; </font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=250 height=23 valign="middle"><font face=Arial size="2">Preços:</font></td>'
   _cMsg += '<td width=450 height=23 valign="middle"><font face=Arial size="2">&nbsp; </font></td>'
   _cMsg += '</tr>'
   _cMsg += '</table>'

   incregua()
	tmp2->(dbgotop())
	_prcvenzfm:=0
	_prcven17:=0
	_prcven18:=0
	_prcven19:=0
				
	while ! tmp2->(eof()) .and.;
         lcontinua
      
     da1->(dbseek(_cfilda1+_prod+tmp2->codtab)) 
     
	  if (tmp2->statustab == 'Z') .and. (tmp2->desc3 == 5.68)   //³ Verifica tabela ativa e alíquotas
	    _prcvenzfm:= da1->da1_prcven
	  elseif (tmp2->desc3 == 5.68)
		 _prcven17:= da1->da1_prcven
	  elseif (tmp2->desc3 == 6.82)
	 	 _prcven18:= da1->da1_prcven
	  elseif (tmp2->desc3 == 7.95)
	  	 _prcven19:= da1->da1_prcven			
	  endif
     
     tmp2->(dbskip())
	end                                                                               

  
	//imprime os preços do produto e salta a página
   _cMsg += '<table cellpadding="0" cellspacing="0" width="700" border="1" bordercolor="#000000" align="center">'
   _cMsg += '<tr>'
   _cMsg += '<td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Alíquota 17%</font></td>'
   _cMsg += '<td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Alíquota 18%</font></td>'
   _cMsg += '<td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Alíquota 19%</font></td>'
   _cMsg += '<td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Zona Franca de Manaus</font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>'
   _cMsg += '<td width=88 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>'
   _cMsg += '<td width=89 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>'
   _cMsg += '</tr>'
   _cMsg += '<tr>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prcven17,2),'@E 9,999,999.99')+'</font></td>'

   //³ cálculo preço consumidor para alíquota 17%
   _prccon:=0
	_prccon:= CalqPrcCon(_prcven17,tmp1->categ,17) 
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prccon,2),'@E 9,999,999.99')+'</font></td>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prcven18,2),'@E 9,999,999.99')+'</font></td>'

   //³ cálculo preço consumidor para alíquota 18%
	_prccon:= CalqPrcCon(_prcven18,tmp1->categ,18)   
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prccon,2),'@E 9,999,999.99')+'</font></td>'
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prcven19,2),'@E 9,999,999.99')+'</font></td>'

   //³ cálculo preço consumidor para alíquota 19%
	_prccon:= CalqPrcCon(_prcven19,tmp1->categ,19)   
   _cMsg += '<td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prccon,2),'@E 9,999,999.99')+'</font></td>'
   _cMsg += '<td width=88 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prcvenzfm,2),'@E 9,999,999.99')+'</font></td>'

   //³ cálculo preço consumidor para alíquota Zona Franca de Manaus
	_prccon:= CalqPrcCon(_prcvenzfm,'P',17)   
   _cMsg += '<td width=89 height=23 valign="middle" align="center"><font face=Arial size="2">'+Transform(noround(_prccon,2),'@E 9,999,999.99')+'</font></td>'
   _cMsg += '</tr>'
   _cMsg += '</table>'

   tmp1->(dbskip())	
	If ! tmp1->(eof())
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'   
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'   
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'   
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'   
   	_cMsg += '<br>'   
   	_cMsg += '<br>'

// Para adequar a novo layout - daqui para baixo   	
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
   	_cMsg += '<br>'
 	Endif
	
end                                                 

//³ encerra códito html
_cMsg += '</body>'
_cMsg += '</html>'


tmp1->(dbclosearea())
tmp2->(dbclosearea())

//copia um arquivo existente para uma variável para ser criado posteriormente em outro local

_carq:="C:\WINDOWS\TEMP\logo.jpg" 
if file(_carq)       // verifica se o arquivo logo.jpg já existe
	_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq)  //apaga o arquivo logo.jpg
	endif
endif
Copy File logo.jpg to c:\WINDOWS\TEMP\logo.jpg //copiar o arquivo de figura da logomarca

_carq2:="C:\WINDOWS\TEMP\pixc.gif" 
if file(_carq2)       // verifica se o arquivo pixc.gif já existe
	_lcontinua:=msgbox("O arquivo "+_carq2+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq2)  //apaga o arquivo logo.jpg
	endif
endif
Copy File pixc.gif to c:\WINDOWS\TEMP\pixc.gif //copiar o arquivo de linha cinza

//³ cria o arquivo em disco vit199.html e executa-o em seguida
nHdl := fCreate("C:\WINDOWS\TEMP\VIT199.HTML")
fWrite(nHdl,_cMsg,Len(_cMsg))
fClose(nHdl)
ExecArq()

set device to screen

ms_flush()
return                         


//***********************************************************************
static function _querys()                                                
//***********************************************************************
_cquery:=" SELECT"
_cquery+=" B1_COD COD,B1_DESC DESCRI,B1_DESCCIE DESCCIE,B1_APRES APRES,B1_APREVEN APREVEN,"
_cquery+=" B1_ANVISA ANVISA,B1_CODBAR CODBAR,B1_DCB1 DCB1,B1_DCB2 DCB2,B1_DCB3 DCB3,B1_POSIPI POSIPI,"
_cquery+=" B1_GRTRIB GRTRIB,B1_CXPAD CXPAD,B1_PRVALID PRVALID,B1_PESO PESO,B1_PESBRU PESBRU,B1_CATEG CATEG"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"   
_cquery+=" AND B1_TIPO='PA'"
// À pedido da Diretoria Comercial, o relatório filtra somente produtos em linha farma
_cquery+=" AND B1_APREVEN='1'"
_cquery+=" ORDER BY B1_COD"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","PESO","N",7,4)
tcsetfield("TMP1","PESBRU","N",7,4)
return


//***********************************************************************
static function _query2()                                                
//***********************************************************************
_cquery:=" SELECT"
_cquery+=" DA0_CODTAB CODTAB,DA0_STATUS STATUSTAB, DA0_DESC3 DESC3"
_cquery+=" FROM "
_cquery+=  retsqlname("DA0")+" DA0"
_cquery+=" WHERE"
_cquery+="     DA0.D_E_L_E_T_<>'*'"
_cquery+=" AND DA0_FILIAL='"+_cfilda0+"'"
_cquery+=" AND DA0_DATDE<='"+dtos(date())+"'"
_cquery+=" AND (DA0_DATATE>='"+dtos(date())+"' OR DA0_DATATE='        ')"
_cquery+=" AND DA0_ATIVO<>'2'"
_cquery+=" ORDER BY DA0_CODTAB"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP2"
tcsetfield("TMP2","DESC3","N",7,2)

return



//***********************************************************************
Static Function CalqPrcCon(_prcven,_categ,_aliq)		//³código para encontrar o preço do consumidor      
//***********************************************************************

if (_categ <> "N")
  _nprco := _prcven / .7234
elseif _aliq=19
  _nprco := _prcven / .7523
elseif _aliq=18            
  _nprco := _prcven / .7519
elseif _aliq=17
  _nprco := _prcven / .7515
endif                                                                              
return(_nprco)	   


//***********************************************************************
Static Function ExecArq()
//***********************************************************************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := "C:\WINDOWS\TEMP\VIT199.HTML"

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
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
	
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
<title>Ficha Técnica de Produto</title>
</head>

<body>


<table cellpadding="0" cellspacing="0" width="700" height="44" border="0" align="center">
<tr>
  <td><img src="C:\WINDOWS\TEMP\logo.jpg" width="129" height="41"></td>
  <td width="500" align=right valign=bottom><font face=arial,verdana size=4><b>FICHA TÉCNICA DE PRODUTO</b></font></td>
</tr>
</table>

<table cellpadding="0" cellspacing="0" width="700" border="0" height="2" align="center">
 <tr>
  <td width="700"><img src="C:\WINDOWS\TEMP\pixc.gif" width="100%" height="2"></td>
</tr></table>
<br>

<table cellpadding="0" cellspacing="0" width="700" border="0" align="center">

 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Código:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>XXXXXX</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Produto:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b><u>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</u></b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Princípio Ativo:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Apresentação:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Produto de Referência:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>AAS</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Classe Terapêutica:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>XXXXXX</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Indicações:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>Analgésico, antitérmico e antiinflamatório</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Linha:</font></td>
  <td width=450 valign="middle">

    <table cellpadding="0" cellspacing="0" width="450" border="0" align="left">
      <tr>
  	<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) FARMA</b></font></td>
  	<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) OTC</b></font></td>
      </tr>
      <tr>
  	<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) GENÉRICO</b></font></td>
  	<td width=225 height=23 align="left" valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) HOSPITALAR</b></font></td>
      </tr> 
    </table>

  </td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Psicotrópico (Port. 344/98):</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) SIM &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (&nbsp; &nbsp; ) NÃO</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Farm. Resp.:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>DR. JOSÉ J. G. SILVESTRE</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Origem:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>BRASIL</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Registro M.S. nº:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>9.9999.9999.999-9</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Código de Barras Unidade:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>9999999999999</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Código de Barras Caixa de Embarque:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>9999999999999</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Nº Denomin. Comum Brasileira (DCB):</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>99999.99-9</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Classificação Fiscal:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>99999</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Classificação Fiscal DL 10.147:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>(&nbsp; &nbsp; ) POSITIVO &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (&nbsp; &nbsp; ) NEGATIVO</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Caixa de Embarque:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>xx UNIDADES</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Validade:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>XX ANOS</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Temperatura de Estocagem:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>15º a 30ºC</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Dimensão do Cartucho:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>128 × 50 × 66 mm </b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Peso do Cartucho:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>9999g</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Dimensão da Caixa Padrão:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>128 × 50 × 66 mm </b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Peso Bruto da Caixa Padrão:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2"><b>99,9999Kg</b></font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">&nbsp; </font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2">&nbsp; </font></td>
 </tr>
 <tr>
  <td width=250 height=23 valign="middle"><font face=Arial size="2">Preços:</font></td>
  <td width=450 height=23 valign="middle"><font face=Arial size="2">&nbsp; </font></td>
 </tr>
</table>

<table cellpadding="0" cellspacing="0" width="700" border="1" bordercolor="#000000" align="center">
 <tr>
  <td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Alíquota 17%</font></td>
  <td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Alíquota 18%</font></td>
  <td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Alíquota 19%</font></td>
  <td colspan=2 height=23 valign="middle" align="center"><font face=Arial size="2">Zona Franca de Manaus</font></td>
 </tr>
 <tr>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>
  <td width=88 height=23 valign="middle" align="center"><font face=Arial size="2">Fábrica</font></td>
  <td width=89 height=23 valign="middle" align="center"><font face=Arial size="2">Consumidor</font></td>
 </tr>
 <tr>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">12,52</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">16,66</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">12,70</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">16,89</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">12,88</font></td>
  <td width=87 height=23 valign="middle" align="center"><font face=Arial size="2">17,12</font></td>
  <td width=88 height=23 valign="middle" align="center"><font face=Arial size="2">0,00</font></td>
  <td width=89 height=23 valign="middle" align="center"><font face=Arial size="2">0,00</font></td>
 </tr>
</table>

</body>

</html>



*/