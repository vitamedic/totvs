/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT345   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 12/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Duplicata em Html                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

User Function VIT345()
//nordem   :=""
tamanho  :="P"
//limite   :=80
titulo   :="DUPLICATA"
cdesc1   :="Este programa ira emitir a duplicata para Cobranca,"
cdesc2   :="em formato html"
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT345"
wnrel    :="VIT345"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
//cbcont   :=0
//m_pag    :=1
//li       :=80
//cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT345"
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

setregua(se1->(lastrec()))

se1->(dbseek(_cfilse1+mv_par01+mv_par02,.t.))

// INÍCIO DO CÓDIGO HTML

_cMsg := ''
_cMsg += '<html>'
_cMsg += '<head>'
_cMsg += '<title>Documento sem t&iacute;tulo</title>'
_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
_cMsg += '</head>'
_cMsg += '<body>'

_parc:=0
_numero:= se1->e1_num

while ! se1->(eof()) .and.;
		se1->e1_filial==_cfilse1 .and.;
		se1->e1_prefixo==mv_par01 .and.;
		se1->e1_num<=mv_par03
	incregua()

	if se1->e1_tipo <> "JP "

		if _parc==3 .or.;
			_numero<>se1->e1_num

			_parc:=0
			_numero:= se1->e1_num
			// quebra a pagina    			
			_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
			_cMsg += "<br clear=all style='page-break-before:always'>"
			_cMsg += '</span>'			
		elseif _parc<>0
			_cMsg += '<center>-----------------------------------------------------------------------------------------------</center>'
			_cMsg += '<br />
			_cMsg += '<br />
		endif                 
		
		_cMsg += '<table border="0" cellpadding="0" cellspacing="0" width="810">'
		_cMsg += '<tr><td width="550">'
		_cMsg += '<table border="1" cellpadding="0" cellspacing="0" width="550" bordercolor="#000000" style="border-collapse: collapse">'
		_cMsg += '<tr><td>'
		_cMsg += '<table border="0" cellpadding="0" cellspacing="0" width="550">'
		_cMsg += '<tr><td bgcolor="#FFFFFF" width="136" height="80" align="left">'
		_cMsg += '<img name="logo" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="135" height="43" border="0" alt=""></td>'
		_cMsg += '<td bgcolor="#FFFFFF" width="39" height="80" align="left">&nbsp;</td>'
		_cMsg += '<td bgcolor="#FFFFFF" width="375" height="80" valign="middle" align="left">'
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="3"><b>Vitamedic Indústria Farmacêutica Ltda. </b><br></font>'
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">VPR 01 Quadra 2A - Módulo 01  -  DAIA  -  Anápolis - GO <br></font>'
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">CEP 75132-020 - Fone: (62) 3902-6100 - Fax: (62) 3902-6199<br></font>'
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">CNPJ: 30.222.814/0001-31 - INSC.EST. 10.197.801-4</font></td></tr></table>'
		_cMsg += '</td></tr></table></td>'
		_cMsg += '<td width="20">&nbsp;</td>'
		_cMsg += '<td width="230">'
		
		_cMsg += '<table border="1" cellpadding="0" cellspacing="0" width="230" bordercolor="#000000" style="border-collapse: collapse">'
		_cMsg += '<tr><td bgcolor="#FFFFFF" width="230" height="80" valign="middle" align="left">'
/*		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">&nbsp;<br /></font>'*/
		
		//  NATUREZA DA OPERAÇÃO
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="2">&nbsp; Natureza da Operação:</font>'
		_cMsg += '<br><font face="Arial, Helvetica, sans-serif" size="2">&nbsp; <B>VENDA DE PRODUTO</B></font>'
		
		//  DATA DA EMISSÃO DA NOTA
		_cMsg += '<br><font face="Arial, Helvetica, sans-serif" size="2">&nbsp; Data de Emissão da Nota:</font>'
		_cMsg += '<br><font face="Arial, Helvetica, sans-serif" size="2">&nbsp; <B>'+dtoc(se1->e1_emissao)+'</B></font></td></tr></table></td></tr>'
		_cMsg += '<tr>'
		_cMsg += '<td colspan="3" height="12"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
		
		//  DADOS DA FATURA
		_cMsg += '<tr><td width="555" valign="top">'
		_cMsg += '<table width="554" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
		_cMsg += '<tr><th scope="col" width="148" height="40" rowspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">DUPLICATA</font></center></th>'
		_cMsg += '<th scope="col" width="128" height="20"><center><font face="Arial, Helvetica, sans-serif" size="1">PARCELA</font></center></th>'
		_cMsg += '<th scope="col" width="129" height="20"><center><font face="Arial, Helvetica, sans-serif" size="1">FATURA/DUPLIC.</font></center></th>'
		_cMsg += '<th scope="col" width="139" height="40" rowspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">VENCIMENTO</font></center></th></tr>'
		_cMsg += '<tr><th scope="col" height="20"><center><font face="Arial, Helvetica, sans-serif" size="1">N&ordm; de Ordem</font></center></th>'
		_cMsg += '<th scope="col" height="20"><center><font face="Arial, Helvetica, sans-serif" size="1">Valor</font></center></th></tr>'
		_cMsg += '<tr><td valign="middle" height="35"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>'+se1->e1_prefixo+'-'+se1->e1_num+'</B></font></center></td>'
		_cMsg += '<td valign="middle" height="35"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>'+se1->e1_parcela+'</B></font></center></td>'
		_cMsg += '<td valign="middle" height="35"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>'+Transform(se1->e1_valor,'@E 9,999,999.99')+'</B></font></center></td>'
		_cMsg += '<td valign="middle" height="35"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>'+dtoc(se1->e1_vencto)+'</B></font></center></td></tr></table></td>'
		_cMsg += '<td width="20">&nbsp;</td>'
		_cMsg += '<td width="230" valign="top">'
		_cMsg += '<table width="230" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
		_cMsg += '<tr><td align="left" height="75" valign="top">'
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="2">&nbsp; &nbsp;<b>NOTAS </b></font>'
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">&nbsp;<br /><br /></font>'
		
		// NÚMERO(S) DA(S) NOTA(S)
		_notas:=u_vit144(se1->e1_num) 
		_notas:=substr(_notas,8,(len(_notas)-7))
		_nota:=""
		
		for _i:=1 to len(_notas)
			if substr(_notas,_i,1)==" "
				_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">&nbsp; &nbsp;'+_nota+' <br />'
				_nota:=""	
			else
				_nota:=_nota+substr(_notas,_i,1)	
			endif
		next
		_cMsg += '&nbsp; &nbsp;'+_nota+'</font></td></tr></table></td></tr>'
		_cMsg += '<tr><td colspan="3" height="10"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
		_cMsg += '<tr><td colspan="3">'
		_cMsg += '<table width="806" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
		_cMsg += '<tr><td height="25" width="100">'
		_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Valor por Extenso </font></td>'
		_cMsg += '<td width="700"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; <B>'+extenso(se1->e1_valor)+'</B></font></td></tr></table></td></tr>'
		_cMsg += '<tr><td colspan="3" height="10"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
		
		
		//DADOS DO CLIENTE
		sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))
		
		_cMsg += '<tr><td colspan="3">
		_cMsg += '<table width="804" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
		_cMsg += '<tr><td><table width="804" border="0" cellspacing="0" cellpadding="0">'
		_cMsg += '<tr><td colspan="2" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Nome da Firma: <B>'+sa1->a1_nome+'</B></font></td></tr>'
		_cMsg += '<tr><td width="500" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Endere&ccedil;o: <B>'+sa1->a1_end+'</B></font></td>'
		_cMsg += '<td><font face="Arial, Helvetica, sans-serif" size="1">CEP: <B>'+substr(sa1->a1_cep,1,5)+'-'+substr(sa1->a1_cep,6,3)+'</B></font></td></tr>'
		_cMsg += '<tr><td width="500" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Munic&iacute;pio: <B>'+sa1->a1_mun+'</B></font></td>'
		_cMsg += '<td><font face="Arial, Helvetica, sans-serif" size="1">Estado: <B>'+sa1->a1_est+'</B></font></td></tr>'
		
		if !empty(sa1->a1_munc)
			_cMsg += '<tr><td width="500" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Pra&ccedil;a de Pagamento: <B>'+sa1->a1_munc+'</B></font></td>'
		else 
			_cMsg += '<tr><td width="500" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Pra&ccedil;a de Pagamento: <B>'+sa1->a1_mun+'</B></font></td>'
		endif
		
		_cMsg += '<td><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
		_cMsg += '<tr><td width="500" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; CNPJ: <B>'
		_cMsg += substr(sa1->a1_cgc,1,2)+'.'+substr(sa1->a1_cgc,3,3)+'.'+substr(sa1->a1_cgc,6,3)+'/'+substr(sa1->a1_cgc,9,4)+'-'+substr(sa1->a1_cgc,13,2)+'</B></font></td>'
		_cMsg += '<td><font face="Arial, Helvetica, sans-serif" size="1">Insc. Est.: <B>'+sa1->a1_inscr+'</B></font></td>'
		_cMsg += '</tr></table></td></tr></table>'
		_cMsg += '</td></tr>'
		_cMsg += '</table>'  
		_cMsg += '<br />
		_cMsg += '<br />

		_parc++ //número de duplicata na página
	endif
	se1->(dbskip())
end
	
_cMsg += '</body>'
_cMsg += '</html>'



//³ cria o arquivo em disco duplicata.html e executa-o em seguida
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
aadd(_agrpsx1,{cperg,"02","Da Duplicata       ?","mv_ch2","C",09,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SE1"})
aadd(_agrpsx1,{cperg,"03","Ate a Duplicata    ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SE1"})
	
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
<table border="0" cellpadding="0" cellspacing="0" width="810">
<tr>
	<td width="550">
        <table border="1" cellpadding="0" cellspacing="0" width="550" bordercolor="#000000" style="border-collapse: collapse">
	        <tr>
			<td>
        	    <table border="0" cellpadding="0" cellspacing="0" width="550">
            	<tr>
                	<td bgcolor="#FFFFFF" width="136" height="94" align="left">
                    	<img name="logo" src="file://///192.168.1.20/remote/figuras/logo.jpg" width="135" height="43" border="0" alt=""></td>
	                <td bgcolor="#FFFFFF" width="39" height="94" align="left">&nbsp;</td>
    	            <td bgcolor="#FFFFFF" width="375" height="94" valign="top" align="left"><br>
        	            <font face="Arial, Helvetica, sans-serif" size="3"><b>Vitapan Indústria Farmacêutica Ltda. </b><br></font>
            	        <font face="Arial, Helvetica, sans-serif" size="1">VPR 01 Quadra 2A - Módulo 01  -  DAIA  -  Anápolis - GO <br></font>
                	    <font face="Arial, Helvetica, sans-serif" size="1">CEP 75132-020 - Fone: (62) 3902-6100 - Fax: (62) 3902-6199<br></font>
                    	<font face="Arial, Helvetica, sans-serif" size="1">CNPJ: 30.222.814/0001-31 - INSC.EST. 10.197.801-4</font></td></tr></table>
			</td></tr></table>
	</td>
   	<td width="20">&nbsp;</td>
	<td width="230">
		<table border="1" cellpadding="0" cellspacing="0" width="230" bordercolor="#000000" style="border-collapse: collapse">
        	<tr>
            	<td bgcolor="#FFFFFF" width="230" height="94" valign="top" align="left">
	                <font face="Arial, Helvetica, sans-serif" size="1">&nbsp;<br /></font>
	                <font face="Arial, Helvetica, sans-serif" size="2">&nbsp; Natureza da Operação:</font>
	                <br><font face="Arial, Helvetica, sans-serif" size="2">&nbsp; <B>%TB.CFOP%</B></font> 
	                <br><font face="Arial, Helvetica, sans-serif" size="2">&nbsp; Data de Emissão da Nota:</font>
	                <br><font face="Arial, Helvetica, sans-serif" size="2">&nbsp; <B>%TB.DTEMISSAO%</B></font></td></tr></table>
	</td>
</tr>
<tr>
    <td colspan="3">&nbsp;</td></tr>
<tr>
    <td width="555" valign="top">
    	<table width="554" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
			<tr>
				<th scope="col" width="148" height="44" rowspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">FATURA</font></center></th>
            	<th scope="col" width="128" height="22"><center><font face="Arial, Helvetica, sans-serif" size="1">PARCELA</font></center></th>
            	<th scope="col" width="129" height="22"><center><font face="Arial, Helvetica, sans-serif" size="1">FATURA/DUPLIC.</font></center></th>
            	<th scope="col" width="139" height="44" rowspan="2"><center><font face="Arial, Helvetica, sans-serif" size="2">VENCIMENTO</font></center></th></tr>
          	<tr>
            	<th scope="col" height="22"><center><font face="Arial, Helvetica, sans-serif" size="1">N&ordm; de Ordem</font></center></th>
	            <th scope="col" height="22"><center><font face="Arial, Helvetica, sans-serif" size="1">Valor</font></center></th></tr>
			<tr>
	            <td valign="middle" height="39"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.FAT%</B></font></center></td>
	            <td valign="middle" height="39"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.PARC%</B></font></center></td>
	            <td valign="middle" height="39"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.VALOR%</B></font></center></td>
	            <td valign="middle" height="39"><center><font face="Arial, Helvetica, sans-serif" size="2"><B>%TB.VENC%</B></font></center></td></tr></table>
	</td>
    <td width="20">&nbsp;</td>
    <td width="230" valign="top">
		<table width="230" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
			<tr>
				<td align="left" height="83" valign="top">
            		<font face="Arial, Helvetica, sans-serif" size="2">&nbsp; &nbsp;<b>NOTAS </b></font>
                	<font face="Arial, Helvetica, sans-serif" size="1">&nbsp;<br /><br /></font>
                	<font face="Arial, Helvetica, sans-serif" size="2">&nbsp; &nbsp;000004786 <br /> 
                		&nbsp; &nbsp;000004787</font></td></tr></table>	            
    </td></tr>
<tr>
	<td colspan="3">&nbsp;</td></tr>
<tr>
    <td colspan="3"> 
		<table width="806" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
   	  		<tr>
		        <td height="40" width="100">
	                <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Valor por Extenso </font></td>
                <td width="700"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; <B>%TB.EXTENSO% </B></font>	  </td>
			</tr></table></td></tr>
<tr>
    <td colspan="3">&nbsp;</td></tr>


/////////////////////////





<tr>
	<td colspan="3">
		<table width="804" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
			<tr>
				<td>
    				<table width="804" border="0" cellspacing="0" cellpadding="0">
                		<tr>
                    		<td colspan="2" height="25"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Nome da Firma: <B>%TB.RAZAO%</B></font></td></tr>
						<tr>
	                    	<td width="500" height="25"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Endere&ccedil;o: <B>%TB.ENDEREÇO%</B></font></td>
	                    	<td><font face="Arial, Helvetica, sans-serif" size="1">CEP: <B>%TB.CEP%</B></font></td>
						</tr>
                		<tr>
	                    	<td width="500" height="25"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Munic&iacute;pio: <B>%TB.MUNICIPIO%</B></font></td>
	                    	<td><font face="Arial, Helvetica, sans-serif" size="1">Estado: <B>%TB.UF%</B></font></td></tr>
	                	<tr>
    	                	<td width="500" height="25"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Pra&ccedil;a de Pagamento: <B>%TB.PAGTO%</B></font></td>
        	           	    <td><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>
            	    	<tr>
                	    	<td width="500" height="25"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; CNPJ: <B>%TB.CNPJ%</B></font></td>
                   		    <td><font face="Arial, Helvetica, sans-serif" size="1">Insc. Est.: <B>%TB.IE%</B></font></td>
						</tr></table></td></tr></table>
    </td></tr></table>
</body>
</html>



*/

