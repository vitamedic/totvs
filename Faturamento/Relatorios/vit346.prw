/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT346   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 20/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Fatura em Html                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

User Function VIT346()
tamanho  :="P"
titulo   :="FATURA PARA COBRANCA CLIENTE"
cdesc1   :="Este programa ira emitir a Fatura para Cobranca,"
cdesc2   :="em formato Html"
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT346"
wnrel    :="VIT346"
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT346"
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

_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
_cfilsf2:=xfilial("SF2")
sa1->(dbsetorder(1))
se1->(dbsetorder(1))
sf2->(dbsetorder(1))


processa({|| _geratmp()})

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())

// INÍCIO DO CÓDIGO HTML

_cMsg2 := ''
_cMsg2 += '<html>'
_cMsg2 += '<head>'
_cMsg2 += '<title>Documento sem t&iacute;tulo</title>'
_cMsg2 += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
_cMsg2 += '</head>'
_cMsg2 += '<body>'
_mfirst:=.t.

while ! tmp1->(eof()) .and.;
		lcontinua
	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
	_cprefixo:=tmp1->prefixo
	_cnumero :=tmp1->numero
	_demissao :=tmp1->emissao
	_nvalor  :=0
	_aduplic :={}
	_anotas  :={}
	
	if !_mfirst
		// quebra a pagina
		_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
		_cMsg2 += "<br clear=all style='page-break-before:always'>"
		_cMsg2 += '</span>'			
	else
		_mfirst:=.f.
	endif

	while ! tmp1->(eof()) .and.;
			tmp1->prefixo==_cprefixo .and.;
			tmp1->numero==_cnumero
		incregua()
		_nvalor+=tmp1->valor
		aadd(_aduplic,{tmp1->parcela,tmp1->vencto,tmp1->valor})
		
		_cquery:=" SELECT"
		_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SE1")+" SE1"
		_cquery+=" WHERE"
		_cquery+="     SE1.D_E_L_E_T_=' '"
		_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
		_cquery+=" AND E1_FATPREF='"+tmp1->prefixo+"'"
		_cquery+=" AND E1_FATURA='"+tmp1->numero+"'"
		_cquery+=" AND E1_TIPOFAT='"+tmp1->tipo+"'"
	
		_cquery:=changequery(_cquery)
		tcquery _cquery new alias "TMP2"
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_i:=ascan(_anotas,{|x| x[1]==tmp2->numero})
			if _i==0
				sf2->(dbseek(_cfilsf2+tmp2->numero+tmp2->prefixo))
				aadd(_anotas,{tmp2->numero,sf2->f2_valfat})
			endif
			tmp2->(dbskip())
		end
		tmp2->(dbclosearea())
		tmp1->(dbskip())
	end
	_i:=1
	_cextenso:=extenso(_nvalor,.f.,1)


	// Cabeçalho
	_cMsg :=' '
	_cMsg += '<table border="0" cellpadding="0" cellspacing="0" width="810">'
	_cMsg += '<tr><td width="550">'
	_cMsg += '<table border="1" cellpadding="0" cellspacing="0" width="550" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg += '<tr><td><table border="0" cellpadding="0" cellspacing="0" width="550">'
	_cMsg += '<tr><td bgcolor="#FFFFFF" width="136" height="80" align="left">'
	_cMsg += '<img name="logo" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="135" height="43" border="0" alt=""></td>'
	_cMsg += '<td bgcolor="#FFFFFF" width="39" height="80" align="left">&nbsp;</td>'
	_cMsg += '<td bgcolor="#FFFFFF" width="375" height="80" valign="middle" align="left">'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="3"><b>'+sm0->m0_nomecom+'</b><br></font>'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">'+left(alltrim(sm0->m0_endcob)+' '+alltrim(sm0->m0_compcob)+' - '+alltrim(sm0->m0_baircob),40)+'  -  '+alltrim(sm0->m0_cidcob)+' - '+sm0->m0_estcob+' <br></font>'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">CEP '+transform(sm0->m0_cepcob,"@R 99999-999")+' - Fone: (62) 3902-6100 - Fax: (62) 3902-6199<br></font>'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">CNPJ: '+transform(sm0->m0_cgc,"@R 99.999.999/9999-99")+' - INSC.EST. '+sm0->m0_insc+'</font></td></tr></table>'
	_cMsg += '</td></tr></table></td>'
	_cMsg += '<td width="20">&nbsp;</td>'
	_cMsg += '<td width="230">'
	_cMsg += '<table border="1" cellpadding="0" cellspacing="0" width="230" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg += '<tr><td bgcolor="#FFFFFF" width="230" height="80" valign="middle" align="left">'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="2">&nbsp; Data de Emissão:</font><br>'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="2">&nbsp; <B>'+dtoc(_demissao)+'</B></font><br /></font></td></tr></table></td></tr>'
	_cMsg += '<tr><td colspan="3" height="8"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
	
	
	// Dados do Cliente
	_cMsg += '<tr><td colspan="3">'
	_cMsg += '<table width="804" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg += '<tr><td><table width="804" border="0" cellspacing="0" cellpadding="0">'
	_cMsg += '<tr><td colspan="2" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Sacado: '
	_cMsg += '<B>'+sa1->a1_nome+'</B></font></td></tr><tr>'
	_cMsg += '<td width="500" height="15">'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Endere&ccedil;o: '
	_cMsg += '<B>'+alltrim(sa1->a1_end)+' - '+alltrim(sa1->a1_bairro)+'</B></font></td>'
	_cMsg += '<td><font face="Arial, Helvetica, sans-serif" size="1">CEP: <B>'+transform(sa1->a1_cep,"@E 99999-999")+'</B></font></td></tr>'
	_cMsg += '<tr><td width="500" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Munic&iacute;pio: <B>'+alltrim(sa1->a1_mun)+'</B></font>'
	_cMsg += '</td><td><font face="Arial, Helvetica, sans-serif" size="1">Estado: <B>'+sa1->a1_est+'</B></font></td></tr><tr>'
	_cMsg += '<td width="500" height="15">'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Pra&ccedil;a de Pagamento: <B>
	
	if empty(sa1->a1_munc)           
		_cMsg += alltrim(sa1->a1_mun)+' - '+sa1->a1_est
	else
		_cMsg += alltrim(sa1->a1_munc)+' - '+sa1->a1_estc
	endif
	
	_cMsg += '</B></font></td>'
	_cMsg += '<td><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
	_cMsg += '<tr><td width="500" height="15"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; CNPJ: <B>'+transform(sa1->a1_cgc,"@R 99.999.999/9999-99")+'</B></font></td>'
	_cMsg += '<td><font face="Arial, Helvetica, sans-serif" size="1">Insc. Est.: <B>'+sa1->a1_inscr+'</B></font></td></tr>'
	_cMsg += '</table></td></tr></table></td></tr>'
	_cMsg += '<tr><td colspan="3" height="8"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
	
	// Dados da Fatura
	// Cabeçalho
	_cMsg += '<tr><td width="806" valign="top" colspan="3">'
	_cMsg += '<table width="808" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg += '<tr><th scope="col" width="200" height="40" rowspan="2">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2">FATURA</font></center></th>'
	_cMsg += '<th scope="col" width="200" height="40" rowspan="2">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2">VALOR</font></center></th>'
	_cMsg += '<th scope="col" height="20" colspan="3">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2">DUPLICATAS EMITIDAS</font></center></th></tr>'
	_cMsg += '<tr><th width="98" height="20" scope="col">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2"><B>Parcela</B></font></center></th>'
	_cMsg += '<th width="148" height="20" scope="col">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2"><B>Vencimento</B></font></center></th>'
	_cMsg += '<th width="150" height="20" scope="col">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2"><B>Valor Parcela</font></center></th></tr>'
	
	// Dados das Parcelas
	
	_numparc:= len(_aduplic)
	_cMsg += '<tr><td valign="middle" rowspan="'+transform(_numparc,"@E 99")+'">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2">'+_cnumero+'</font></center></td>'
	_cMsg += '<td valign="middle" rowspan="5">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2">'+transform(_nvalor,"@E 999,999,999.99")+'</font></center></td>'
	
	for _j:=1 to len(_aduplic)
	
		if _j>1
			_cMsg += '<tr>'	
		endif             
		
		_cMsg += '<td valign="middle" height="15">'
		_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="1">'+_aduplic[_j,1]+'</font></center></td>'
		_cMsg += '<td valign="middle" height="15">'
		_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="1">'+dtoc(_aduplic[_j,2])+'</font></center></td>'
		_cMsg += '<td valign="middle" height="15">'
		_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="1">R$ '+transform(_aduplic[_j,3],"@E 99,999,999.99")+'</font></center></td></tr>'
	next
	
	// Valor por extenso
	_cMsg += '</table></td></tr>'
	_cMsg += '<tr><td colspan="3" height="8"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
	_cMsg += '<tr><td colspan="3">'
	_cMsg += '<table width="807" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg += '<tr><td height="25" width="100"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Valor por Extenso </font>'
	_cMsg += '</td>'
	_cMsg += '<td width="701">'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="1">&nbsp; <B>'
	_cMsg += extenso(_nvalor,.f.,1) 
	_cMsg += '</B></font></td></tr></table></td></tr>'
	_cMsg += '</tr>'
	_cMsg += '<tr><td colspan="3" height="8"><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font></td></tr>'
	
	_cMsg += '<tr><td colspan="3">'
	_cMsg += '<table width="809" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">'
	_cMsg += '<tr><td width="250">'
	_cMsg += '<table width="250" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg += '<tr><td height="30" colspan="2">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2">'
	_cMsg += '<b>RELA&Ccedil;&Atilde;O DE NOTAS FISCAIS</b></font></center></td></tr>'
	_cMsg += '<tr><td width="110" height="20" valign="middle">'
	_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="2"><b>NOTAS </b></font></center></td>'
	_cMsg += '<td width="140" height="20" valign="middle">'
	_cMsg += '<center> <font face="Arial, Helvetica, sans-serif" size="2"><b>VALOR </b></font></center></td></tr>'
	
	for _i:=1 to len(_anotas)
		_cMsg += '<tr><td height="15">'
		_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="1">'+_anotas[_i,1]+'</font></center></td>'
		
		_cMsg += '<td height="15">'
		_cMsg += '<center><font face="Arial, Helvetica, sans-serif" size="1">'+transform(_anotas[_i,2],"@E 999,999,999.99")+'</font></center></td></tr>'
	end	
	
	_numnotas:=len(_anotas)
	_cMsg += '</table>'    
	_cMsg += '</td>'
	_cMsg += '<td width="559" valign="top" align="left">'
	_cMsg += '<table width="558" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg += '<tr>'
	_cMsg += '<td width="554" align="center" height="'+transform(50+(_numnotas*15),"@E 999")+'" valign="top">'
	_cMsg += '<table width="510" border="0" cellpadding="0" cellspacing="0">'
	_cMsg += '<tr><td align="justify">'
	_cMsg += '<font face="Arial, Helvetica, sans-serif" size="2"><br />'
	_cMsg += 'Importância de sua compra de mercadorias e/ou serviços constantes da(s) nota(s) à margem '
	_cMsg += 'discriminada(s), para cuja cobertura emitimos a presente fatura.</font></td>'
	_cMsg += '</tr>'
	_cMsg += '</table></td>'
	_cMsg += '</tr></table></td></tr></table>'
	_cMsg += '</td></tr></table>'
	_cMsg += '<br />'
	_cMsg += '<br />'
	_cMsg += '<br />'
	_cMsg += '<br />'
	_cMsg += '<br />'
	
	
	// Imprime duas por página
// linha retirada por solicitação do Faturamento - Chamado Ocomon nº 999
//	_cMsg := _cMsg+_cMsg
	_cMsg2 += _cMsg

end

_cMsg2 += '</body>'
_cMsg2 += '</html>'

//³ cria o arquivo em disco duplicata.html e executa-o em seguida
nHdl := fCreate("C:\TEMP\fatura.html")
fWrite(nHdl,_cMsg2,Len(_cMsg2))
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
cPathFile := "c:\TEMP\fatura.html"

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


static function _geratmp()
procregua(1)

incproc("Selecionando faturas...")
_cquery:=" SELECT"
_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO,"
_cquery+=" E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_EMISSAO EMISSAO,E1_VENCTO VENCTO,"
_cquery+=" E1_VALOR VALOR"
_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_PREFIXO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND E1_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
_cquery+=" AND E1_TIPO='FT '"
_cquery+=" ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VENCTO" ,"D")
tcsetfield("TMP1","VALOR"  ,"N",12,2)
return





//***********************************************************************
static function _pergsx1()
//***********************************************************************
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do prefixo         ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o prefixo      ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do numero          ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o numero       ?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da emissao         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a emissao      ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
                                <td bgcolor="#FFFFFF" width="136" height="80" align="left">
                                <img name="logo" src="file://///192.168.1.20/remote/figuras/logo.jpg" width="135" height="43" border="0" alt="">
                                </td>
                                <td bgcolor="#FFFFFF" width="39" height="80" align="left">&nbsp;
                                </td>
                                <td bgcolor="#FFFFFF" width="375" height="80" valign="middle" align="left">
                                <font face="Arial, Helvetica, sans-serif" size="3"><b>Vitapan Indústria Farmacêutica Ltda. </b><br></font>
                                <font face="Arial, Helvetica, sans-serif" size="1">VPR 01 Quadra 2A - Módulo 01  -  DAIA  -  Anápolis - GO <br></font>
                                <font face="Arial, Helvetica, sans-serif" size="1">CEP 75132-020 - Fone: (62) 3902-6100 - Fax: (62) 3902-6199<br></font>
                                <font face="Arial, Helvetica, sans-serif" size="1">CNPJ: 30.222.814/0001-31 - INSC.EST. 10.197.801-4</font>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td width="20">&nbsp;</td>
        <td width="230">
            <table border="1" cellpadding="0" cellspacing="0" width="230" bordercolor="#000000" style="border-collapse: collapse">
                <tr>
                    <td bgcolor="#FFFFFF" width="230" height="80" valign="middle" align="left">
                        <font face="Arial, Helvetica, sans-serif" size="2">&nbsp; Data de Emissão:</font><br>
                        <font face="Arial, Helvetica, sans-serif" size="2">&nbsp; <B>25/06/09</B></font><br /></font>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="3" height="8">
            <font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table width="804" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
                <tr>
                    <td>
                        <table width="804" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="2" height="15">
                                    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Sacado: 
                                    <B>BIG FARMA COM. DE PROD. FARMAC. LTDA EPP</B></font>
                                </td>
                            </tr>
                            <tr>
                                <td width="500" height="15">
                                    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Endere&ccedil;o: 
                                    <B>AV. JOAO PESSOA, 349                    </B></font>
                                </td>
                                <td>
                                    <font face="Arial, Helvetica, sans-serif" size="1">CEP: <B>65040-000</B></font>
                                </td>
                            </tr>
                            <tr>
                                <td width="500" height="15">
                                    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Munic&iacute;pio: <B>SAO LUIS                 </B></font>
                                </td>
                                <td>
                                    <font face="Arial, Helvetica, sans-serif" size="1">Estado: <B>MA</B></font>
                                </td>
                            </tr>
                            <tr>
                                <td width="500" height="15">
                                    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Pra&ccedil;a de Pagamento: <B>SAO LUIZ - MA     </B></font>                                </td>
                                <td>
                                    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font>
                                </td>
                            </tr>
                            <tr>
                                <td width="500" height="15">
                                    <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; CNPJ: <B>05.764.082/0001-64</B></font>
                                </td>
                                <td>
                                    <font face="Arial, Helvetica, sans-serif" size="1">Insc. Est.: <B>12207584-6        </B></font>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="3" height="8">
            <font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font>
        </td>
    </tr>
    <tr>
        <td width="806" valign="top" colspan="3">
            <table width="808" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
				<tr>
					<th scope="col" width="200" height="40" rowspan="2">
                        <center><font face="Arial, Helvetica, sans-serif" size="2">FATURA</font></center>
                    </th>
                    <th scope="col" width="200" height="40" rowspan="2">
                        <center><font face="Arial, Helvetica, sans-serif" size="2">VALOR</font></center>
                  	</th>
                    <th scope="col" height="20" colspan="3">
						<center><font face="Arial, Helvetica, sans-serif" size="2">DUPLICATAS EMITIDAS</font></center>
                  	</th>
				</tr>
                <tr>
                    <th width="98" height="20" scope="col">
						<center><font face="Arial, Helvetica, sans-serif" size="2"><B>Parcela</B></font></center>
					</th>
					<th width="148" height="20" scope="col">
                        <center><font face="Arial, Helvetica, sans-serif" size="2"><B>Vencimento</B></font></center>
					</th>
					<th width="150" height="20" scope="col">
                        <center><font face="Arial, Helvetica, sans-serif" size="2"><B>Valor Parcela</font></center>
					</th>
				</tr>
                <tr>
                    <td valign="middle" rowspan="5">
                        <center><font face="Arial, Helvetica, sans-serif" size="2">000036525</font></center>
                    </td>
                    <td valign="middle" rowspan="5">
                        <center><font face="Arial, Helvetica, sans-serif" size="2">    5.376,96</font></center>
                    </td>
                    <td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">A</font></center>
                    </td>
                    <td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">30/07/09</font></center>
                    </td>
                    <td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">R$ 1.075,39</font></center>
                    </td>
				</tr>
                <tr>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">B</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">15/08/09</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">R$ 1.075,39</font></center>
                    </td>
				</tr>                
				<tr>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">C</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">31/08/09</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">R$ 1.075,39</font></center>
                    </td>
				</tr>                
				<tr>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">D</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">15/09/09</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">R$ 1.075,39</font></center>
                    </td>
				</tr>                
				<tr>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">E</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">30/09/09</font></center>
                    </td>
					<td valign="middle" height="15">
                        <center><font face="Arial, Helvetica, sans-serif" size="1">R$ 1.075,40</font></center>
                    </td>
				</tr>

			</table>
		</td>
	</tr>
    <tr>
        <td colspan="3" height="8">
            <font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table width="807" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
				<tr>
                    <td height="25" width="100">
                        <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; Valor por Extenso </font>
                    </td>
                    <td width="701">
                        <font face="Arial, Helvetica, sans-serif" size="1">&nbsp; 
                        <B> CINCO MIL, TREZENTOS E SETENTA E SEIS REAIS E NOVENTA E SEIS CENTAVOS</B></font>                    </td>
				</tr>
            </table>
      </td>
    </tr>
    <tr>
        <td colspan="3" height="8">
            <font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font>
        </td>
    </tr>

	<tr>
    	<td colspan="3">
        	<table width="809" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
            	<tr>
                	<td width="250">
                        <table width="250" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
                            <tr>
                                <td height="30" colspan="2">
                                	<center><font face="Arial, Helvetica, sans-serif" size="2">
                                	<b>RELA&Ccedil;&Atilde;O DE NOTAS FISCAIS</b></font></center></td>
                            </tr>
							<tr>
                                <td width="110" height="20" valign="middle">
                                    <center><font face="Arial, Helvetica, sans-serif" size="2"><b>NOTAS </b></font></center></td>
                                <td width="140" height="20" valign="middle">
                                    <center> <font face="Arial, Helvetica, sans-serif" size="2"><b>VALOR </b></font></center></td>
							</tr>
							<tr>
                                <td height="15">
                                	<center><font face="Arial, Helvetica, sans-serif" size="1">000004786</font></center></td>
								<td height="15">
									<center><font face="Arial, Helvetica, sans-serif" size="1">4.371,00</font></center></td>
                            </tr>
							<tr>
								<td height="15">
									<center><font face="Arial, Helvetica, sans-serif" size="1">000004787</font></center></td>
                                <td height="15">
									<center><font face="Arial, Helvetica, sans-serif" size="1">1.005,96</font></center></td>
							</tr>
                        </table>
					</td>
					<td width="559" valign="top" align="left">
						<table width="558" border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="border-collapse: collapse">
							<tr>
                                <td width="554" align="center" height="80" valign="top">
                                	<table width="510" border="0" cellpadding="0" cellspacing="0">
                                    	<tr>
                                        	<td align="justify">
                                                <font face="Arial, Helvetica, sans-serif" size="2"><br />
                                                Importância de sua compra de mercadorias e/ou serviços constantes da(s) nota(s) à margem
                                                discriminada(s), para cuja cobertura emitimos a presente fatura.</font></td>
										</tr>
									</table></td>
							</tr>
						</table>
					</td>
				</tr>
            </table>
		</td>
	</tr>
</table>
<br />
</body>
</html>


*/

