/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT263   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 02/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ficha Cobranca Judicial - Duplicata em Html                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function VIT263()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="DUPLICATA PARA COBRANCA JUDICIAL"
cdesc1   :="Este programa ira emitir a duplicata para Cobranca"
cdesc2   :="Judicial, em formato para anexar aos processos"
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT263"
wnrel    :="VIT263"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT263"
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
_cfilse1:=xfilial("SE1")
_cfilsa1:=xfilial("SA1")        
sa1->(dbsetorder(1))
se1->(dbsetorder(1))    

_cAssunto:= 'DUPLICATA PARA COBRANÇA JUDICIAL'
_cMsg := ""        

setregua(se1->(lastrec()))

se1->(dbseek(_cfilse1+mv_par01+mv_par02+mv_par03,.t.))

// INÍCIO DO CÓDIGO HTML

_cMsg := ""
_cMsg += '<html>'
_cMsg += '<head>
_cMsg += '<title>Documento sem t&iacute;tulo</title>
_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
_cMsg += '</head>
_cMsg += '<body>
_cMsg += '<table border="0" cellpadding="0" cellspacing="0" width="793">
_cMsg += '  <tr>
_cMsg += '    <td width="13"><img src="file://///192.168.1.20/figuras/spacer.gif" alt="" name="undefined_2" width="13" height="1" border="0"></td>
_cMsg += '    <td width="17"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="17" height="1" border="0"></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="135" height="1" border="0"></td>
_cMsg += '    <td width="9"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="9" height="1" border="0"></td>
_cMsg += '    <td width="64"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="64" height="1" border="0"></td>
_cMsg += '    <td width="34"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="34" height="1" border="0"></td>
_cMsg += '    <td width="7"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="7" height="1" border="0"></td>
_cMsg += '    <td width="103"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="103" height="1" border="0"></td>
_cMsg += '    <td width="8"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="8" height="1" border="0"></td>
_cMsg += '    <td width="69"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="69" height="1" border="0"></td>
_cMsg += '    <td width="34"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="34" height="1" border="0"></td>
_cMsg += '    <td width="6"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="6" height="1" border="0"></td>
_cMsg += '    <td width="45"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="45" height="1" border="0"></td>
_cMsg += '    <td width="59"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="59" height="1" border="0"></td>
_cMsg += '    <td width="9"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="9" height="1" border="0"></td>
_cMsg += '    <td width="11"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="11" height="1" border="0"></td>
_cMsg += '    <td width="114"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="114" height="1" border="0"></td>
_cMsg += '    <td width="8"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="8" height="1" border="0"></td>
_cMsg += '    <td width="10"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="10" height="1" border="0"></td>
_cMsg += '    <td width="35"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="35" height="1" border="0"></td>
_cMsg += '    <td width="10"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="1" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="20"><img name="dup_r1_c1_2" src="file://///192.168.1.20/remote/figuras/dup_r1_c1.jpg" width="790" height="19" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="19" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td rowspan="25"><img name="dup_r2_c1_2" src="file://///192.168.1.20/remote/figuras/dup_r2_c1.jpg" width="13" height="527" border="0" alt=""></td>
_cMsg += '    <td><img name="dup_r2_c2_2" src="file://///192.168.1.20/remote/figuras/dup_r2_c2.jpg" width="17" height="12" border="0" alt=""></td>
_cMsg += '    <td><img name="dup_r2_c3" src="file://///192.168.1.20/remote/figuras/dup_r2_c3.jpg" width="135" height="12" border="0" alt=""></td>
_cMsg += '    <td colspan="9"><img name="dup_r2_c4" src="file://///192.168.1.20/remote/figuras/dup_r2_c4.jpg" width="334" height="12" border="0" alt=""></td>
_cMsg += '    <td><img name="dup_r2_c13" src="file://///192.168.1.20/remote/figuras/dup_r2_c13.jpg" width="45" height="12" border="0" alt=""></td>
_cMsg += '    <td colspan="4"><img name="dup_r2_c14_2" src="file://///192.168.1.20/remote/figuras/dup_r2_c14.jpg" width="193" height="12" border="0" alt=""></td>
_cMsg += '    <td colspan="2"><img name="dup_r2_c18" src="file://///192.168.1.20/remote/figuras/dup_r2_c18.jpg" width="18" height="12" border="0" alt=""></td>
_cMsg += '    <td rowspan="25"><img name="dup_r2_c20" src="file://///192.168.1.20/remote/figuras/dup_r2_c20.jpg" width="35" height="527" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="12" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td><img name="dup_r3_c2_2" src="file://///192.168.1.20/remote/figuras/dup_r3_c2.jpg" width="17" height="94" border="0" alt=""></td>
_cMsg += '    <td bgcolor="#FFFFFF" width="135" height="94" align="center"><img name="logo" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="135" height="43" border="0" alt=""></td>
_cMsg += '    <td colspan="9" height="94">
_cMsg += '		<table align="right" width="320" height="94" border="0" cellpadding="0" cellspacing="0">	
_cMsg += '	    	<tr valign="top" align="center">
_cMsg += '	      		<td valign="top" align="left"><br>
_cMsg += '		    		<font face="Arial, Helvetica, sans-serif" size="3"><b>Vitamedic Indústria Farmacêutica Ltda. </b><br></font>
_cMsg += '	        		<font face="Arial, Helvetica, sans-serif" size="1">VPR 01 Quadra 2A - Módulo 01  -  DAIA  -  Anápolis - GO <br></font>
_cMsg += '					<font face="Arial, Helvetica, sans-serif" size="1">CEP 75133-600 - Fone: (62) 3902-6100 - Fax: (62) 3902-6199<br></font>
_cMsg += '					<font face="Arial, Helvetica, sans-serif" size="1">CNPJ: 30.222.814/0001-31 - INSC.EST. 10.197.801-4</font>
_cMsg += '		  		</td></tr></table></td>
_cMsg += '    <td><img name="dup_r3_c13_2" src="file://///192.168.1.20/remote/figuras/dup_r3_c13.jpg" width="45" height="94" border="0" alt=""></td>
_cMsg += '    <td colspan="4" height="94">

//  NATUREZA DA OPERAÇÃO
_cMsg += '	  <font face="Arial, Helvetica, sans-serif" size="2">Natureza da Operação:</font>'
_cMsg += '    <br><font face="Arial, Helvetica, sans-serif" size="2"><B>&nbsp; 6.71 - VENDA DE PRODUTOS</B></font>'

//  DATA DA EMISSÃO DA NOTA
_cMsg += '    <br><font face="Arial, Helvetica, sans-serif" size="2">Data de Emissão da Nota:</font>'
_cMsg += '    <br><font face="Arial, Helvetica, sans-serif" size="2"><B>&nbsp; '+dtoc(se1->e1_emissao)+'</B></font></td>'
_cMsg += '    <td colspan="2"><img name="dup_r3_c18" src="file://///192.168.1.20/remote/figuras/dup_r3_c18.jpg" width="18" height="94" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="94" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td><img name="dup_r4_c2" src="file://///192.168.1.20/remote/figuras/dup_r4_c2.jpg" width="17" height="9" border="0" alt=""></td>
_cMsg += '    <td><img name="dup_r4_c3" src="file://///192.168.1.20/remote/figuras/dup_r4_c3.jpg" width="135" height="9" border="0" alt=""></td>
_cMsg += '    <td colspan="9"><img name="dup_r4_c4_2" src="file://///192.168.1.20/remote/figuras/dup_r4_c4.jpg" width="334" height="9" border="0" alt=""></td>
_cMsg += '    <td><img name="dup_r4_c13" src="file://///192.168.1.20/remote/figuras/dup_r4_c13.jpg" width="45" height="9" border="0" alt=""></td>
_cMsg += '    <td colspan="4"><img name="dup_r4_c14" src="file://///192.168.1.20/remote/figuras/dup_r4_c14.jpg" width="193" height="9" border="0" alt=""></td>
_cMsg += '    <td colspan="2"><img name="dup_r4_c18" src="file://///192.168.1.20/remote/figuras/dup_r4_c18.jpg" width="18" height="9" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="9" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td rowspan="21" colspan="2"><img name="dup_r5_c2" src="file://///192.168.1.20/remote/figuras/dup_r5_c2.jpg" width="152" height="347" border="0" alt=""></td>
_cMsg += '    <td colspan="3"><img name="dup_r5_c4" src="file://///192.168.1.20/remote/figuras/dup_r5_c4.jpg" width="107" height="9" border="0" alt=""></td>
_cMsg += '    <td rowspan="5"><img name="dup_r5_c7" src="file://///192.168.1.20/remote/figuras/dup_r5_c7.jpg" width="7" height="43" border="0" alt=""></td>
_cMsg += '    <td><img name="dup_r5_c8" src="file://///192.168.1.20/remote/figuras/dup_r5_c8.jpg" width="103" height="9" border="0" alt=""></td>
_cMsg += '    <td rowspan="5"><img name="dup_r5_c9" src="file://///192.168.1.20/remote/figuras/dup_r5_c9.jpg" width="8" height="43" border="0" alt=""></td>
_cMsg += '    <td colspan="2"><img name="dup_r5_c10" src="file://///192.168.1.20/remote/figuras/dup_r5_c10.jpg" width="103" height="9" border="0" alt=""></td>
_cMsg += '    <td rowspan="5"><img name="dup_r5_c12" src="file://///192.168.1.20/remote/figuras/dup_r5_c12.jpg" width="6" height="43" border="0" alt=""></td>
_cMsg += '    <td colspan="2"><img name="dup_r5_c13" src="file://///192.168.1.20/remote/figuras/dup_r5_c13.jpg" width="104" height="9" border="0" alt=""></td>
_cMsg += '    <td rowspan="5"><img name="dup_r5_c15" src="file://///192.168.1.20/remote/figuras/dup_r5_c15.jpg" width="9" height="43" border="0" alt=""></td>
_cMsg += '    <td rowspan="2" colspan="4"><img name="dup_r5_c16" src="file://///192.168.1.20/remote/figuras/dup_r5_c16.jpg" width="143" height="21" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="9" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td rowspan="4"><img name="dup_r6_c4" src="file://///192.168.1.20/remote/figuras/dup_r6_c4.jpg" width="9" height="34" border="0" alt=""></td>
_cMsg += '    <td rowspan="4" colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">FATURA</font></center></td>
_cMsg += '    <td rowspan="2"><center><font face="Arial, Helvetica, sans-serif" size="1">PARCELA</font></center></td>
_cMsg += '    <td rowspan="2" colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="1">FATURA/DUPLIC.</font></center></td>
_cMsg += '    <td rowspan="4" colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">VENCIMENTO</font></center></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="12" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td rowspan="8"><img name="dup_r7_c16" src="file://///192.168.1.20/remote/figuras/dup_r7_c16.jpg" width="11" height="87" border="0" alt=""></td>
_cMsg += '    <td rowspan="8" colspan="2" valign="top"><img name="inst_fin" src="file://///192.168.1.20/remote/figuras/inst_fin.jpg" width="120" height="28" border="0" alt=""></td>
_cMsg += '    <td rowspan="8"><img name="dup_r7_c19" src="file://///192.168.1.20/remote/figuras/dup_r7_c19.jpg" width="10" height="87" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="3" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td><img name="dup_r8_c8" src="file://///192.168.1.20/remote/figuras/dup_r8_c8.jpg" width="103" height="5" border="0" alt=""></td>
_cMsg += '    <td colspan="2"><img name="dup_r8_c10" src="file://///192.168.1.20/remote/figuras/dup_r8_c10.jpg" width="103" height="5" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="5" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td><center><font face="Arial, Helvetica, sans-serif" size="1">Nº de Ordem</font></center></td>
_cMsg += '    <td colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="1">Valor</font></center></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="14" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="12"><img name="dup_r10_c4_2" src="file://///192.168.1.20/remote/figuras/dup_r10_c4.jpg" width="447" height="6" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="6" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td><img name="dup_r11_c4" src="file://///192.168.1.20/remote/figuras/dup_r11_c4.jpg" width="9" height="27" border="0" alt=""></td>
_cMsg += '    <td colspan="2" valign="middle"><center>

//  DADOS DA FATURA
_cMsg += '       <font face="Arial, Helvetica, sans-serif" size="2"><B>'+se1->e1_prefixo+'-'+se1->e1_num+'</B></font>'
_cMsg += '       </center></td>'
_cMsg += '    <td><img name="dup_r11_c7" src="file://///192.168.1.20/remote/figuras/dup_r11_c7.jpg" width="7" height="27" border="0" alt=""></td>
_cMsg += '	  <td valign="middle"><center>'
_cMsg += '		  <font face="Arial, Helvetica, sans-serif" size="2"><B>'+se1->e1_parcela+'</B></font></center></td>'
_cMsg += '    <td><img name="dup_r11_c9" src="file://///192.168.1.20/remote/figuras/dup_r11_c9.jpg" width="8" height="27" border="0" alt=""></td>
_cMsg += '	  <td colspan="2" valign="middle"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>'+Transform(se1->e1_valor,'@E 9,999,999.99')+'</B></font></center></td>'
_cMsg += '    <td><img name="dup_r11_c12" src="file://///192.168.1.20/remote/figuras/dup_r11_c12.jpg" width="6" height="27" border="0" alt=""></td>
_cMsg += '    <td colspan="2" valign="middle"><center>
_cMsg += '       <font face="Arial, Helvetica, sans-serif" size="2"><B>'+dtoc(se1->e1_vencto)+'</B></font>'
_cMsg += '		  </center></td>'
_cMsg += '    <td><img name="dup_r11_c15" src="file://///192.168.1.20/remote/figuras/dup_r11_c15.jpg" width="9" height="27" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="27" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="12"><img name="dup_r12_c4" src="file://///192.168.1.20/remote/figuras/dup_r12_c4.jpg" width="447" height="7" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="7" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="12" valign="bottom"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Desconto de:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
_cMsg += '		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
_cMsg += '		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Até</font></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="17" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td rowspan="2" colspan="12" valign="bottom">
_cMsg += '	    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Condi&ccedil;&otilde;es especiais:</font></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="8" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="4"><img name="dup_r15_c16" src="file://///192.168.1.20/remote/figuras/dup_r15_c16.jpg" width="143" height="14" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="14" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td rowspan="6" valign="top"><img name="dup_r16_c4" src="file://///192.168.1.20/remote/figuras/dup_r16_c4.jpg" width="9" height="117" border="0" alt=""></td>
_cMsg += '    <td colspan="15"><img name="dup_r16_c5" src="file://///192.168.1.20/remote/figuras/dup_r16_c5.jpg" width="581" height="18" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="18" border="0"></td>
_cMsg += '  </tr>

//DADOS DO CLIENTE

sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))

_cMsg += '  <tr valign="top">
_cMsg += '    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Nome da Firma: </font></td>
_cMsg += '    <td colspan="12"><font face="Arial, Helvetica, sans-serif" size="1"><B>'+sa1->a1_nome+'</B></font></td>
_cMsg += '    <td rowspan="8" valign="top" align="left"><img name="dup_r17_c19" src="file://///192.168.1.20/remote/figuras/dup_r17_c19.jpg" width="10" height="143" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr valign="top">
_cMsg += '    <td colspan="1"><font face="Arial, Helvetica, sans-serif" size="1">Endereço: </font></td>
_cMsg += '    <td colspan="5"><font face="Arial, Helvetica, sans-serif" size="1"><B>'+sa1->a1_end+'</B></font></td>
_cMsg += '    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">CEP: </font></td>
_cMsg += '    <td colspan="6"><font face="Arial, Helvetica, sans-serif" size="1"><B>'+substr(sa1->a1_cep,1,5)+'-'+substr(sa1->a1_cep,6,3)+'</B></font></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr valign="top">
_cMsg += '    <td colspan="1"><font face="Arial, Helvetica, sans-serif" size="1">Município: </font></td>
_cMsg += '    <td colspan="5"><font face="Arial, Helvetica, sans-serif" size="1"><B>'+sa1->a1_mun+'</B></font></td>
_cMsg += '    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Estado: </font></td>	
_cMsg += '    <td colspan="6"><font face="Arial, Helvetica, sans-serif" size="1"><B>'+sa1->a1_est+'</B></font></td>		
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="19" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr valign="top">
_cMsg += '    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Praça de Pagamento: </font></td>

if !empty(sa1->a1_munc)
	_cMsg += '    <td colspan="12"><font face="Arial, Helvetica, sans-serif" size="1"><B>&nbsp; &nbsp; '+sa1->a1_munc+'</B></font></td>
else 
	_cMsg += '    <td colspan="12"><font face="Arial, Helvetica, sans-serif" size="1"><B>&nbsp; &nbsp; '+sa1->a1_mun+'</B></font></td>
endif	
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr valign="top">
_cMsg += '    <td colspan="1"><font face="Arial, Helvetica, sans-serif" size="1">CNPJ: </font></td>
_cMsg += '    <td colspan="5"><font face="Arial, Helvetica, sans-serif" size="1"><B>'
_cMsg +=         substr(sa1->a1_cgc,1,2)+'.'+substr(sa1->a1_cgc,3,3)+'.'+substr(sa1->a1_cgc,6,3)+'/'+substr(sa1->a1_cgc,9,4)+'-'+substr(sa1->a1_cgc,13,2)+'</B></font></td>
_cMsg += '    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Insc Est: </font></td>	
_cMsg += '    <td colspan="6"><font face="Arial, Helvetica, sans-serif" size="1"><B>&nbsp; &nbsp; '+sa1->a1_inscr+'</B></font></td>		
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr valign="top">
_cMsg += '    <td colspan="15" valign="top"><img name="dup_r22_c4_2" src="file://///192.168.1.20/remote/figuras/dup_r22_c4.jpg" width="580" height="8" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="8" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="2" valign="top"><img name="dup_r23_c4" src="file://///192.168.1.20/remote/figuras/dup_r23_c4.jpg" width="73" height="26" border="0" alt=""></td>
_cMsg += '    <td colspan="13"><font face="Arial, Helvetica, sans-serif" size="1"><B>'+extenso(se1->e1_valor)+'</B></font></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="26" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="15" valign="top"><img name="dup_r24_c4" src="file://///192.168.1.20/remote/figuras/dup_r24_c4.jpg" width="580" height="10" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="10" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="16"><p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Reconhe&ccedil;o(emos)
_cMsg += '      a exatid&atilde;o desta DUPLICATA DE VENDA MERCANTIL na import&acirc;ncia que pagarei(emos)
_cMsg += '      a VITAMEDIC IND&Uacute;STRIA FARMAC&Ecirc;UTICA LTDA., ou &agrave; sua ordem na pra&ccedil;a
_cMsg += '    e vencimentos indicados.</font></p>
_cMsg += '    <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
_cMsg += '	  Data _____/_____/_____&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
_cMsg += '	  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
_cMsg += '	  ________________________________ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
_cMsg += '	  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
_cMsg += '	  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
_cMsg += '	  &nbsp; &nbsp; &nbsp;Assinatura do Sacado</font></p></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="64" border="0"></td>
_cMsg += '  </tr>
_cMsg += '  <tr>
_cMsg += '    <td colspan="18"><img name="dup_r26_c2" src="file://///192.168.1.20/remote/figuras/dup_r26_c2.jpg" width="742" height="65" border="0" alt=""></td>
_cMsg += '    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="65" border="0"></td>
_cMsg += '  </tr>
_cMsg += '</table>
_cMsg += '</body>
_cMsg += '</html>


//³ cria o arquivo em disco vit199.html e executa-o em seguida
nHdl := fCreate("C:\WINDOWS\TEMP\duplicata.html")
fWrite(nHdl,_cMsg,Len(_cMsg))
fClose(nHdl)
ExecArq()

set device to screen

ms_flush()
return                         


//***********************************************************************
Static Function ExecArq()
//***********************************************************************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := "c:\WINDOWS\TEMP\duplicata.html"

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
aadd(_agrpsx1,{cperg,"01","Prefixo            ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","No.Fatura/Duplicata?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SE1"})
aadd(_agrpsx1,{cperg,"03","Parcela            ?","mv_ch3","C",01,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

**************************************************************************************************
*****************************   CÓDIGO ORIGINAL DA PÁGINA EM HTML    *****************************
**************************************************************************************************


<html>
<head>
<title>Documento sem t&iacute;tulo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" width="793">
  <tr>
    <td width="13"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="13" height="1" border="0"></td>
    <td width="17"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="17" height="1" border="0"></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="135" height="1" border="0"></td>
    <td width="9"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="9" height="1" border="0"></td>
    <td width="64"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="64" height="1" border="0"></td>
    <td width="34"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="34" height="1" border="0"></td>
    <td width="7"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="7" height="1" border="0"></td>
    <td width="103"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="103" height="1" border="0"></td>
    <td width="8"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="8" height="1" border="0"></td>
    <td width="69"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="69" height="1" border="0"></td>
    <td width="34"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="34" height="1" border="0"></td>
    <td width="6"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="6" height="1" border="0"></td>
    <td width="45"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="45" height="1" border="0"></td>
    <td width="59"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="59" height="1" border="0"></td>
    <td width="9"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="9" height="1" border="0"></td>
    <td width="11"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="11" height="1" border="0"></td>
    <td width="114"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="114" height="1" border="0"></td>
    <td width="8"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="8" height="1" border="0"></td>
    <td width="10"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="10" height="1" border="0"></td>
    <td width="35"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="35" height="1" border="0"></td>
    <td width="10"><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="20"><img name="dup_r1_c1_2" src="file://///192.168.1.20/remote/figuras/dup_r1_c1.jpg" width="790" height="19" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="19" border="0"></td>
  </tr>
  <tr>
    <td rowspan="25"><img name="dup_r2_c1_2" src="file://///192.168.1.20/remote/figuras/dup_r2_c1.jpg" width="13" height="527" border="0" alt=""></td>
    <td><img name="dup_r2_c2_2" src="file://///192.168.1.20/remote/figuras/dup_r2_c2.jpg" width="17" height="12" border="0" alt=""></td>
    <td><img name="dup_r2_c3" src="file://///192.168.1.20/remote/figuras/dup_r2_c3.jpg" width="135" height="12" border="0" alt=""></td>
    <td colspan="9"><img name="dup_r2_c4" src="file://///192.168.1.20/remote/figuras/dup_r2_c4.jpg" width="334" height="12" border="0" alt=""></td>
    <td><img name="dup_r2_c13" src="file://///192.168.1.20/remote/figuras/dup_r2_c13.jpg" width="45" height="12" border="0" alt=""></td>
    <td colspan="4"><img name="dup_r2_c14_2" src="file://///192.168.1.20/remote/figuras/dup_r2_c14.jpg" width="193" height="12" border="0" alt=""></td>
    <td colspan="2"><img name="dup_r2_c18" src="file://///192.168.1.20/remote/figuras/dup_r2_c18.jpg" width="18" height="12" border="0" alt=""></td>
    <td rowspan="25"><img name="dup_r2_c20" src="file://///192.168.1.20/remote/figuras/dup_r2_c20.jpg" width="35" height="527" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="12" border="0"></td>
  </tr>
  <tr>
    <td><img name="dup_r3_c2_2" src="file://///192.168.1.20/remote/figuras/dup_r3_c2.jpg" width="17" height="94" border="0" alt=""></td>
    <td bgcolor="#FFFFFF" width="135" height="94" align="center"><img name="logo" src="file://///192.168.1.20/remote/figuras/logo.jpg" width="135" height="43" border="0" alt=""></td>
    <td colspan="9" height="94">
		<table align="right" width="320" height="94" border="0" cellpadding="0" cellspacing="0">	
	    	<tr valign="top" align="center">
	      		<td valign="top" align="left"><br>
		    		<font face="Arial, Helvetica, sans-serif" size="3"><b>Vitapan Indústria Farmacêutica Ltda. </b><br></font>
	        		<font face="Arial, Helvetica, sans-serif" size="1">VPR 01 Quadra 2A - Módulo 01  -  DAIA  -  Anápolis - GO <br></font>
					<font face="Arial, Helvetica, sans-serif" size="1">CEP 75133-600 - Fone: (62) 3902-6100 - Fax: (62) 3902-6199<br></font>
					<font face="Arial, Helvetica, sans-serif" size="1">CNPJ: 30.222.814/0001-31 - INSC.EST. 10.197.801-4</font>
		  		</td></tr></table></td>
    <td><img name="dup_r3_c13_2" src="file://///192.168.1.20/remote/figuras/dup_r3_c13.jpg" width="45" height="94" border="0" alt=""></td>
    <td colspan="4" height="94">
	  <font face="Arial, Helvetica, sans-serif" size="2">Natureza da Operação:</font>
	  <br><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.CFOP%</B></font> 
	  <br><font face="Arial, Helvetica, sans-serif" size="2">Data de Emissão da Nota:</font>
	  <br><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.DTEMISSAO%</B></font></td>  
    <td colspan="2"><img name="dup_r3_c18" src="file://///192.168.1.20/remote/figuras/dup_r3_c18.jpg" width="18" height="94" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="94" border="0"></td>
  </tr>
  <tr>
    <td><img name="dup_r4_c2" src="file://///192.168.1.20/remote/figuras/dup_r4_c2.jpg" width="17" height="9" border="0" alt=""></td>
    <td><img name="dup_r4_c3" src="file://///192.168.1.20/remote/figuras/dup_r4_c3.jpg" width="135" height="9" border="0" alt=""></td>
    <td colspan="9"><img name="dup_r4_c4_2" src="file://///192.168.1.20/remote/figuras/dup_r4_c4.jpg" width="334" height="9" border="0" alt=""></td>
    <td><img name="dup_r4_c13" src="file://///192.168.1.20/remote/figuras/dup_r4_c13.jpg" width="45" height="9" border="0" alt=""></td>
    <td colspan="4"><img name="dup_r4_c14" src="file://///192.168.1.20/remote/figuras/dup_r4_c14.jpg" width="193" height="9" border="0" alt=""></td>
    <td colspan="2"><img name="dup_r4_c18" src="file://///192.168.1.20/remote/figuras/dup_r4_c18.jpg" width="18" height="9" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="9" border="0"></td>
  </tr>
  <tr>
    <td rowspan="21" colspan="2"><img name="dup_r5_c2" src="file://///192.168.1.20/remote/figuras/dup_r5_c2.jpg" width="152" height="347" border="0" alt=""></td>
    <td colspan="3"><img name="dup_r5_c4" src="file://///192.168.1.20/remote/figuras/dup_r5_c4.jpg" width="107" height="9" border="0" alt=""></td>
    <td rowspan="5"><img name="dup_r5_c7" src="file://///192.168.1.20/remote/figuras/dup_r5_c7.jpg" width="7" height="43" border="0" alt=""></td>
    <td><img name="dup_r5_c8" src="file://///192.168.1.20/remote/figuras/dup_r5_c8.jpg" width="103" height="9" border="0" alt=""></td>
    <td rowspan="5"><img name="dup_r5_c9" src="file://///192.168.1.20/remote/figuras/dup_r5_c9.jpg" width="8" height="43" border="0" alt=""></td>
    <td colspan="2"><img name="dup_r5_c10" src="file://///192.168.1.20/remote/figuras/dup_r5_c10.jpg" width="103" height="9" border="0" alt=""></td>
    <td rowspan="5"><img name="dup_r5_c12" src="file://///192.168.1.20/remote/figuras/dup_r5_c12.jpg" width="6" height="43" border="0" alt=""></td>
    <td colspan="2"><img name="dup_r5_c13" src="file://///192.168.1.20/remote/figuras/dup_r5_c13.jpg" width="104" height="9" border="0" alt=""></td>
    <td rowspan="5"><img name="dup_r5_c15" src="file://///192.168.1.20/remote/figuras/dup_r5_c15.jpg" width="9" height="43" border="0" alt=""></td>
    <td rowspan="2" colspan="4"><img name="dup_r5_c16" src="file://///192.168.1.20/remote/figuras/dup_r5_c16.jpg" width="143" height="21" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="9" border="0"></td>
  </tr>
  <tr>
    <td rowspan="4"><img name="dup_r6_c4" src="file://///192.168.1.20/remote/figuras/dup_r6_c4.jpg" width="9" height="34" border="0" alt=""></td>
    <td rowspan="4" colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">FATURA</font></center></td>
    <td rowspan="2"><center><font face="Arial, Helvetica, sans-serif" size="1">PARCELA</font></center></td>
    <td rowspan="2" colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="1">FATURA/DUPLIC.</font></center></td>
    <td rowspan="4" colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">VENCIMENTO</font></center></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="12" border="0"></td>
  </tr>
  <tr>
    <td rowspan="8"><img name="dup_r7_c16" src="file://///192.168.1.20/remote/figuras/dup_r7_c16.jpg" width="11" height="87" border="0" alt=""></td>
    <td rowspan="8" colspan="2" valign="top"><img name="inst_fin" src="file://///192.168.1.20/remote/figuras/inst_fin.jpg" width="120" height="28" border="0" alt=""></td>
    <td rowspan="8"><img name="dup_r7_c19" src="file://///192.168.1.20/remote/figuras/dup_r7_c19.jpg" width="10" height="87" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="3" border="0"></td>
  </tr>
  <tr>
    <td><img name="dup_r8_c8" src="file://///192.168.1.20/remote/figuras/dup_r8_c8.jpg" width="103" height="5" border="0" alt=""></td>
    <td colspan="2"><img name="dup_r8_c10" src="file://///192.168.1.20/remote/figuras/dup_r8_c10.jpg" width="103" height="5" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="5" border="0"></td>
  </tr>
  <tr>
    <td><center><font face="Arial, Helvetica, sans-serif" size="1">Nº de Ordem</font></center></td>
    <td colspan="2"><center><font face="Arial, Helvetica, sans-serif" size="1">Valor</font></center></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="14" border="0"></td>
  </tr>
  <tr>
    <td colspan="12"><img name="dup_r10_c4_2" src="file://///192.168.1.20/remote/figuras/dup_r10_c4.jpg" width="447" height="6" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="6" border="0"></td>
  </tr>
  <tr>
    <td><img name="dup_r11_c4" src="file://///192.168.1.20/remote/figuras/dup_r11_c4.jpg" width="9" height="27" border="0" alt=""></td>
    <td colspan="2" valign="middle"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.FAT%</B></font></center></td>
    <td><img name="dup_r11_c7" src="file://///192.168.1.20/remote/figuras/dup_r11_c7.jpg" width="7" height="27" border="0" alt=""></td>
    <td valign="middle"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.PARC%</B></font></center></td>
    <td><img name="dup_r11_c9" src="file://///192.168.1.20/remote/figuras/dup_r11_c9.jpg" width="8" height="27" border="0" alt=""></td>
    <td colspan="2" valign="middle"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.VALOR%</B></font></center></td>
    <td><img name="dup_r11_c12" src="file://///192.168.1.20/remote/figuras/dup_r11_c12.jpg" width="6" height="27" border="0" alt=""></td>
    <td colspan="2" valign="middle"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.VENC%</B></font></center></td>
    <td><img name="dup_r11_c15" src="file://///192.168.1.20/remote/figuras/dup_r11_c15.jpg" width="9" height="27" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="27" border="0"></td>
  </tr>
  <tr>
    <td colspan="12"><img name="dup_r12_c4" src="file://///192.168.1.20/remote/figuras/dup_r12_c4.jpg" width="447" height="7" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="7" border="0"></td>
  </tr>
  <tr>
    <td colspan="12" valign="bottom"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Desconto de:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Até</font></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="17" border="0"></td>
  </tr>
  <tr>
    <td rowspan="2" colspan="12" valign="bottom">
	    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Condi&ccedil;&otilde;es especiais:</font></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="8" border="0"></td>
  </tr>
  <tr>
    <td colspan="4"><img name="dup_r15_c16" src="file://///192.168.1.20/remote/figuras/dup_r15_c16.jpg" width="143" height="14" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="14" border="0"></td>
  </tr>
  <tr>
    <td rowspan="6" valign="top"><img name="dup_r16_c4" src="file://///192.168.1.20/remote/figuras/dup_r16_c4.jpg" width="9" height="117" border="0" alt=""></td>
    <td colspan="15"><img name="dup_r16_c5" src="file://///192.168.1.20/remote/figuras/dup_r16_c5.jpg" width="581" height="18" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="18" border="0"></td>
  </tr>
  <tr valign="top">
    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Nome da Firma: </font></td>
    <td colspan="12"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.RAZAO%</B></font></td>
    <td rowspan="8" valign="top" align="left"><img name="dup_r17_c19" src="file://///192.168.1.20/remote/figuras/dup_r17_c19.jpg" width="10" height="143" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
  </tr>
  <tr valign="top">
    <td colspan="1"><font face="Arial, Helvetica, sans-serif" size="1">Endereço: </font></td>
    <td colspan="5"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.END%</B></font></td>
    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">CEP: </font></td>
    <td colspan="6"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.CEP%</B></font></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
  </tr>
  <tr valign="top">
    <td colspan="1"><font face="Arial, Helvetica, sans-serif" size="1">Município: </font></td>
    <td colspan="5"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.MUN%</B></font></td>
    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Estado: </font></td>	
    <td colspan="6"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.UF%</B></font></td>		
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="19" border="0"></td>
  </tr>
  <tr valign="top">
    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Praça de Pagamento: </font></td>
    <td colspan="12"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.PAG%</B></font></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
  </tr>
  <tr valign="top">
    <td colspan="1"><font face="Arial, Helvetica, sans-serif" size="1">CNPJ: </font></td>
    <td colspan="5"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.CNPJ%</B></font></td>
    <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="1">Insc Est: </font></td>	
    <td colspan="6"><font face="Arial, Helvetica, sans-serif" size="1"><B>&nbsp; %TB.IE%</B></font></td>		
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="20" border="0"></td>
  </tr>
  <tr valign="top">
    <td colspan="15" valign="top"><img name="dup_r22_c4_2" src="file://///192.168.1.20/remote/figuras/dup_r22_c4.jpg" width="580" height="8" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="8" border="0"></td>
  </tr>
  <tr>
    <td colspan="2" valign="top"><img name="dup_r23_c4" src="file://///192.168.1.20/remote/figuras/dup_r23_c4.jpg" width="73" height="26" border="0" alt=""></td>
    <td colspan="13"><font face="Arial, Helvetica, sans-serif" size="1"><B>%TB.EXTENSO%</B></font></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="26" border="0"></td>
  </tr>
  <tr>
    <td colspan="15" valign="top"><img name="dup_r24_c4" src="file://///192.168.1.20/remote/figuras/dup_r24_c4.jpg" width="580" height="10" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="10" border="0"></td>
  </tr>
  <tr>
    <td colspan="16"><p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Reconhe&ccedil;o(emos)
      a exatid&atilde;o desta DUPLICATA DE VENDA MERCANTIL na import&acirc;ncia que pagarei(emos)
      a VITAPAN IND&Uacute;STRIA FARMAC&Ecirc;UTICA LTDA., ou &agrave; sua ordem na pra&ccedil;a
    e vencimentos indicados.</font></p>
    <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
	  Data _____/_____/_____&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	  ________________________________ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	  &nbsp; &nbsp; &nbsp;Assinatura do Sacado</font></p></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="64" border="0"></td>
  </tr>
  <tr>
    <td colspan="18"><img name="dup_r26_c2" src="file://///192.168.1.20/remote/figuras/dup_r26_c2.jpg" width="742" height="65" border="0" alt=""></td>
    <td><img src="file://///192.168.1.20/remote/figuras/spacer.gif" alt="" name="undefined_2" width="1" height="65" border="0"></td>
  </tr>
</table>
</body>
</html>


*/

