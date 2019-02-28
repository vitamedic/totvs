/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT369   ³ Autor: Heraildo C.de Freitas  ³ Data: 11/05/11  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Fluxo de Caixa Previsto                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

// EXECUÇÃO VIA MENU
user function vit369()
local asizeaut:={}
local aobjects:={}
local ainfo   :={}
local aposget :={}
local aposobj :={}
local abuttons:={}

cperg:="pergvit369"

_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do vencimento               ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"      "})
aadd(_agrpsx1,{cperg,"02","Ate o vencimento            ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"      "})
aadd(_agrpsx1,{cperg,"03","Considera tit. provisorios  ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"      "})
u_pergsx1()

if pergunte(cperg,.t.)
	
	_aestrut:={}
	aadd(_aestrut,{"OK"     ,"C",02,0})
	aadd(_aestrut,{"EMPRESA","C",02,0})
	aadd(_aestrut,{"FILIAL" ,"C",02,0})
	aadd(_aestrut,{"NOMEEMP","C",15,0})
	aadd(_aestrut,{"NOMEFIL","C",15,0})
	
	_carqtmp1:=criatrab(_aestrut,.t.)
	
	dbusearea(.t.,,_carqtmp1,"TMP1",.t.,.f.)
	
	_cchave  :="EMPRESA+FILIAL"
	_cindtmp1:=criatrab(,.f.)
	indregua("TMP1",_cindtmp1,_cchave)
	
	_aareasm0:=sm0->(getarea())
	
	sm0->(dbsetorder(1))
	sm0->(dbgotop())
	while ! sm0->(eof())
		
		reclock("TMP1",.t.)
		tmp1->empresa:=sm0->m0_codigo
		tmp1->filial :=sm0->m0_codfil
		tmp1->nomeemp:=sm0->m0_nome
		tmp1->nomefil:=sm0->m0_filial
		msunlock()
		
		sm0->(dbskip())
	end
	
	sm0->(restarea(_aareasm0))
	
	tmp1->(dbgotop())
	
	_acampos:={}
	aadd(_acampos,{"OK"     ,," "           ," "})
	aadd(_acampos,{"EMPRESA",,"Empresa"     ," "})
	aadd(_acampos,{"FILIAL" ,,"Filial"      ," "})
	aadd(_acampos,{"NOMEEMP",,"Nome empresa"," "})
	aadd(_acampos,{"NOMEFIL",,"Nome filial" ," "})
	
	linverte:=.f.
	cmarca  :=getmark()
	nopca:=0
	
	asizeaut:=msadvsize(,.f.)
	aadd(aobjects,{0,15,.t.,.f.})
	aadd(aobjects,{100,100,.t.,.t.})
	aadd(aobjects,{0,2,.t.,.f.})
	ainfo:={asizeaut[1],asizeaut[2],asizeaut[3],asizeaut[4],2,2}
	aposobj:=msobjsize(ainfo,aobjects)
	aposget:=msobjgetpos(asizeaut[3]-asizeaut[1],305,{{5,30,60,85,115,130,160,175},{5,25,80,100}})
	
	define msdialog odlg title "Empresas / Filiais" from asizeaut[7],0 to asizeaut[6],asizeaut[5] of omainwnd pixel
	
	omark:=msselect():new("TMP1","OK","",_acampos,@linverte,@cmarca,{aposobj[2,1],aposobj[2,2],aposobj[2,3],aposobj[2,4]})
	omark:obrowse:lhasmark:=.t.
	omark:obrowse:lcanallmark:=.t.
	omark:obrowse:ballmark:={|| u_zfinr12b(cmarca)} // MARCAR/DESMARCAR TODOS
	
	activate msdialog odlg on init enchoicebar(odlg,{|| (nopca:=1,odlg:end())},{|| odlg:end()},,abuttons)
	
	if nopca==1
		
		_aempfil:={}
		
		tmp1->(dbgotop())
		while ! tmp1->(eof())
			
			if tmp1->(marked("OK"))
				aadd(_aempfil,{tmp1->empresa,tmp1->filial,tmp1->nomeemp,tmp1->nomefil})
			endif
			
			tmp1->(dbskip())
		end
		
		tmp1->(dbclosearea())
		ferase(_carqtmp1+getdbextension())
		ferase(_cindtmp1+ordbagext())
		
		if empty(_aempfil)
			msginfo("Nenhuma empresa/filial foi selecionada!")
		else
			processa({|| _imprime()},"Fluxo de caixa previsto")
		endif
	else
		tmp1->(dbclosearea())
		ferase(_carqtmp1+getdbextension())
		ferase(_cindtmp1+ordbagext())
	endif
endif
return()

static function _imprime()
procregua(0)
incproc()

_cempfil:=""
for _ni:=1 to len(_aempfil)
	_cempfil+=if(! empty(_cempfil),", ","")+alltrim(_aempfil[_ni,3])+"/"+alltrim(_aempfil[_ni,4])
next

_cdirdocs:=msdocpath()
_carq:="fluxo_de_caixa_previsto.htm"
if file(_cdirdocs+"\"+_carq)
	ferase(_cdirdocs+"\"+_carq)
endif
_nhandle:=fcreate(_cdirdocs+"\"+_carq,0)

fwrite(_nhandle,'<html>'+chr(13)+chr(10))
fwrite(_nhandle,'<head>'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Language" content="pt-br">'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+chr(13)+chr(10))
fwrite(_nhandle,'<title>FLUXO DE CAIXA PREVISTO</title>'+chr(13)+chr(10))
fwrite(_nhandle,'</head>'+chr(13)+chr(10))
fwrite(_nhandle,'<body>'+chr(13)+chr(10))

fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
fwrite(_nhandle,'<td width="260"><p style="margin-top: 0; margin-bottom: 0"><img name="logo" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="135" height="43" border="0" alt=""></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">FLUXO DE CAIXA PREVISTO - '+dtoc(date())+' '+time()+'</font></b></p>'+chr(13)+chr(10))
fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">VENCIMENTO DE '+dtoc(mv_par01)+' A '+dtoc(mv_par02)+'</font></b></p>'+chr(13)+chr(10))
fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">EMPRESAS/FILIAIS: '+_cempfil+'</font></b></p>'+chr(13)+chr(10))
fwrite(_nhandle,'</td>'+chr(13)+chr(10))
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
fwrite(_nhandle,'</table>'+chr(13)+chr(10))

_aestrut:={}
aadd(_aestrut,{"VENCIMENTO","D",08,0})
aadd(_aestrut,{"RECEBER"   ,"N",12,2})
aadd(_aestrut,{"PAGAR"     ,"N",12,2})

_carqtmp1:=criatrab(_aestrut,.t.)

dbusearea(.t.,,_carqtmp1,"TMP1",.t.,.f.)

_cchave  :="DTOS(VENCIMENTO)"
_cindtmp1:=criatrab(,.f.)
indregua("TMP1",_cindtmp1,_cchave)

_nsaldo:=0
_ddata:=mv_par01-1
_ddataini:=mv_par01-1
while datavalida(_ddata)<>_ddataini
	_ddata--
	_ddataini--
end

for _ni:=1 to len(_aempfil)
	
	incproc("Calculando contas a receber: "+alltrim(_aempfil[_ni,3])+"/"+alltrim(_aempfil[_ni,4]))
	
	dbusearea(.t.,,"SX2"+_aempfil[_ni,1]+"0","SX2AUX",.t.,.f.)
	sx2aux->(dbsetindex("SX2"+_aempfil[_ni,1]+"0"))
	
	sx2aux->(dbsetorder(1))
	
	sx2aux->(dbseek("SA1"))
	_ctabsa1 :=alltrim(sx2aux->x2_arquivo)
	_cmodosa1:=sx2aux->x2_modo
	
	sx2aux->(dbseek("SA2"))
	_ctabsa2 :=alltrim(sx2aux->x2_arquivo)
	_cmodosa2:=sx2aux->x2_modo
	
	sx2aux->(dbclosearea())
	
	// CALCULA CONTAS A RECEBER
	_cquery:= "SELECT"
	_cquery+=" E1_PORTADO,"
	_cquery+=" E1_VENCREA,"
	_cquery+=" SUM(CASE WHEN E1_DESCFIN>0 THEN ROUND(E1_SALDO*(1-(E1_DESCFIN/100)),2) ELSE E1_SALDO END) E1_SALDO"
	
	_cquery+=" FROM "
	_cquery+=  _ctabsa1+" SA1,"
	_cquery+=" SE1"+_aempfil[_ni,1]+"0 SE1"
	
	_cquery+=" WHERE"
	_cquery+=    " SA1.D_E_L_E_T_=' '"
	_cquery+=" AND SE1.D_E_L_E_T_=' '"
	if _cmodosa1=="C"
		_cquery+=" AND A1_FILIAL='  '"
	else
		_cquery+=" AND A1_FILIAL='"+_aempfil[_ni,2]+"'"
	endif
	_cquery+=" AND E1_FILIAL='"+_aempfil[_ni,2]+"'"
	_cquery+=" AND E1_CLIENTE=A1_COD"
	_cquery+=" AND E1_LOJA=A1_LOJA"
	_cquery+=" AND E1_VENCREA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par02)+"'"
	_cquery+=" AND E1_TIPO NOT IN ('NCC','RA ')"
	if mv_par03==2 // NAO CONSIDERAR TITULOS PROVISORIOS
		_cquery+=" AND E1_TIPO<>'PR '"
	endif
	_cquery+=" AND E1_SALDO>0"
//	_cquery+=" AND A1_FLUXO<>'2'"
//	_cquery+=" AND E1_FLUXO<>'N'"
	
	_cquery+=" GROUP BY"
	_cquery+=" E1_PORTADO,E1_VENCREA"
	
	_cquery+=" ORDER BY"
	_cquery+=" E1_VENCREA"
	
	memowrite("zfinr012a.sql",_cquery)
	
	tcquery _cquery new alias "TMP2"
	u_setfield("TMP2")
	
	tmp2->(dbgotop())
	while ! tmp2->(eof())
		
		_dvencrea:=tmp2->e1_vencrea
		
		if _dvencrea>=mv_par01 .and. _dvencrea<=mv_par02
			
			if ! tmp1->(dbseek(dtos(_dvencrea)))
				reclock("TMP1",.t.)
				tmp1->vencimento:=_dvencrea
			else
				reclock("TMP1",.f.)
			endif
			tmp1->receber+=tmp2->e1_saldo
			msunlock()
			
		endif
		
		tmp2->(dbskip())
	end
	tmp2->(dbclosearea())
	
	incproc("Calculando contas a pagar: "+alltrim(_aempfil[_ni,3])+"/"+alltrim(_aempfil[_ni,4]))
	
	// CALCULA CONTAS A PAGAR
	
	_cquery:= " SELECT" 
	_cquery+= " E2_VENCREA," 
	_cquery+= " SUM("
	_cquery+= "   CASE"
	_cquery+= "   WHEN E2_MOEDA = '1' THEN E2_SALDO"
	_cquery+= " WHEN E2_MOEDA = '2' THEN (E2_SALDO *"
	_cquery+= "   (SELECT  SM21.M2_MOEDA2"
	_cquery+= "   FROM SM2010 SM21"
	_cquery+= "   WHERE SM21.D_E_L_E_T_ = ' '"
	_cquery+= "   AND SM21.M2_MOEDA2>0"
	_cquery+= "   AND SM21.M2_DATA = (SELECT MAX(M21.M2_DATA) FROM SM2010 M21 WHERE M21.D_E_L_E_T_ = ' ' AND M21.M2_MOEDA2>0)))"
	_cquery+= " WHEN E2_MOEDA = '3' THEN (E2_SALDO *"
	_cquery+= "   (SELECT  SM22.M2_MOEDA3"
	_cquery+= "   FROM SM2010 SM22"
	_cquery+= "   WHERE SM22.D_E_L_E_T_ = ' '"
	_cquery+= "   AND SM22.M2_MOEDA3>0"
	_cquery+= "   AND SM22.M2_DATA = (SELECT MAX(M213.M2_DATA) FROM SM2010 M213 WHERE M213.D_E_L_E_T_ = ' ' AND M213.M2_MOEDA3>0)))"
	_cquery+= " WHEN E2_MOEDA = '4' THEN (E2_SALDO *"
	_cquery+= "   (SELECT  SM24.M2_MOEDA4"
	_cquery+= "   FROM SM2010 SM24"
	_cquery+= "   WHERE SM24.D_E_L_E_T_ = ' '"
	_cquery+= "   AND SM24.M2_MOEDA4>0"
	_cquery+= "   AND SM24.M2_DATA = (SELECT MAX(M214.M2_DATA) FROM SM2010 M214 WHERE M214.D_E_L_E_T_ = ' ' AND M214.M2_MOEDA4>0)))"
	_cquery+= " END) AS E2_SALDO"
	_cquery+="  FROM "
	_cquery+=  _ctabsa2+" SA2,"
	_cquery+=" SE2"+_aempfil[_ni,1]+"0 SE2"
	_cquery+= " WHERE SA2.D_E_L_E_T_=' '" 
	_cquery+= " AND SE2.D_E_L_E_T_=' '" 
	if _cmodosa2=="C"
		_cquery+=" AND A2_FILIAL='  '"
	else
		_cquery+=" AND A2_FILIAL='"+_aempfil[_ni,2]+"'"
	endif
	_cquery+= " AND E2_FILIAL='"+_aempfil[_ni,2]+"'" 
	_cquery+= " AND E2_FORNECE=A2_COD" 
	_cquery+= " AND E2_LOJA=A2_LOJA "
	_cquery+= " AND E2_VENCREA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'" 
	_cquery+= " AND E2_TIPO NOT IN ('NDF','PA ')" 
	_cquery+= " AND E2_SALDO>0"
	_cquery+= " GROUP BY E2_VENCREA" 
	_cquery+= " ORDER BY E2_VENCREA"	
	
	memowrite("zfinr012b.sql",_cquery)
	
	tcquery _cquery new alias "TMP2"
	u_setfield("TMP2")
	
	tmp2->(dbgotop())
	while ! tmp2->(eof())
		
		if ! tmp1->(dbseek(dtos(tmp2->e2_vencrea)))
			reclock("TMP1",.t.)
			tmp1->vencimento:=tmp2->e2_vencrea
		else
			reclock("TMP1",.f.)
		endif
		tmp1->pagar+=tmp2->e2_saldo
		msunlock()
		
		tmp2->(dbskip())
	end
	tmp2->(dbclosearea())
	
	// SALDO BANCARIO
	_cquery:=" SELECT"
	_cquery+=" SUM(E8_SALATUA) E8_SALATUA"
	
	_cquery+=" FROM "
	_cquery+=" SA6"+_aempfil[_ni,1]+"0 SA6,"
	_cquery+=" SE8"+_aempfil[_ni,1]+"0 SE8"
	
	_cquery+=" WHERE"
	_cquery+=    " SA6.D_E_L_E_T_=' '"
	_cquery+=" AND SE8.D_E_L_E_T_=' '"
	_cquery+=" AND A6_FILIAL=' '"
	_cquery+=" AND E8_FILIAL='"+_aempfil[_ni,2]+"'"
	_cquery+=" AND E8_BANCO=A6_COD"
	_cquery+=" AND E8_AGENCIA=A6_AGENCIA"
	_cquery+=" AND E8_CONTA=A6_NUMCON"
	_cquery+=" AND A6_FLUXCAI<>'N'"
	_cquery+=" AND E8_DTSALAT=("
	_cquery+=    " SELECT"
	_cquery+=    " MAX(E8_DTSALAT)"
	_cquery+=    " FROM "
	_cquery+=    " SE8"+_aempfil[_ni,1]+"0 SE82"
	_cquery+=    " WHERE"
	_cquery+=        " SE82.D_E_L_E_T_=' '"
	_cquery+=    " AND SE82.E8_FILIAL=SE8.E8_FILIAL"
	_cquery+=    " AND SE82.E8_BANCO=SE8.E8_BANCO"
	_cquery+=    " AND SE82.E8_AGENCIA=SE8.E8_AGENCIA"
	_cquery+=    " AND SE82.E8_CONTA=SE8.E8_CONTA"
	_cquery+=    " AND SE82.E8_DTSALAT<'"+dtos(mv_par01)+"')"
	
	memowrite("zfinr012c.sql",_cquery)
	
	tcquery _cquery new alias "TMP2"
	u_setfield("TMP2")
	
	tmp2->(dbgotop())
	_nsaldo+=tmp2->e8_salatua
	tmp2->(dbclosearea())
next

fwrite(_nhandle,'<p align="center" style="margin-top: 0; margin-bottom: 0">&nbsp;</p>'+chr(13)+chr(10))
fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">SALDO BANCÁRIO INICIAL: '+alltrim(transform(_nsaldo,"@E 999,999,999.99"))+'</font></b></p>'+chr(13)+chr(10))

fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">DATA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR A RECEBER</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR A PAGAR</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">RESULTADO DO DIA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">SALDO FINAL</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))

_nreceber:=0
_npagar  :=0

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	_nreceber+=tmp1->receber
	_npagar+=tmp1->pagar
	_nsaldo+=tmp1->receber-tmp1->pagar
	
	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+dtoc(tmp1->vencimento)+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->receber,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->pagar,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->receber-tmp1->pagar,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_nsaldo,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080"><b>TOTAL</b></font></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080"><b>'+alltrim(transform(_nreceber,"@E 999,999,999.99"))+'</b></font></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080"><b>'+alltrim(transform(_npagar,"@E 999,999,999.99"))+'</b></font></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080"><b>'+alltrim(transform(_nreceber-_npagar,"@E 999,999,999.99"))+'</b></font></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080"><b>'+alltrim(transform(_nsaldo,"@E 999,999,999.99"))+'</b></font></td>'+chr(13)+chr(10))
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))

fwrite(_nhandle,'</table>'+chr(13)+chr(10))

fwrite(_nhandle,'</body>'+chr(13)+chr(10))
fwrite(_nhandle,'</html>'+chr(13)+chr(10))

fclose(_nhandle)

_cpathtmp:=alltrim(gettemppath())
if file(_cpathtmp+_carq)
	ferase(_cpathtmp+_carq)
endif
cpys2t(_cdirdocs+"\"+_carq,_cpathtmp,.t.)

shellexecute("open",_carq,"",_cpathtmp,1)
return()

// MARCAR/DESMARCAR TODOS
user function zfinr12b(cmarca,omark)
local _aareatmp1:=tmp1->(getarea())

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	reclock("TMP1",.f.)
	if tmp1->(marked("OK"))
		tmp1->ok:=space(2)
	else
		tmp1->ok:=cmarca
	endif
	msunlock()
	
	tmp1->(dbskip())
end

tmp1->(restarea(_aareatmp1))
return()
