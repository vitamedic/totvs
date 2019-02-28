/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ vit376   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 17/11/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Relatorio de Verificacao SX3 X Tabela                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit376()
_cperg:="ACFGR003"

_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da tabela                    ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a tabela                 ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Da empresa                   ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Ate a empresa                ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Corrige erros automaticamente?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
u_pergsx1(_agrpsx1)

if pergunte(_cperg,.t.)
	processa({|| _imprime()},"SX3 X TABELA")
endif
return()

static function _imprime()
procregua(0)
incproc()

_cpathtmp:=alltrim(gettemppath())
_carq:=criatrab(,.f.)+".htm"
if file(_cpathtmp+_carq)
	ferase(_cpathtmp+_carq)
endif
_nhandle:=fcreate(_cpathtmp+_carq,0)

fwrite(_nhandle,'<html>'+chr(13)+chr(10))
fwrite(_nhandle,'<head>'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Language" content="pt-br">'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+chr(13)+chr(10))
fwrite(_nhandle,'<title>VERIFICAÇÃO SX3 X TABELA</title>'+chr(13)+chr(10))
fwrite(_nhandle,'</head>'+chr(13)+chr(10))
fwrite(_nhandle,'<body>'+chr(13)+chr(10))
fwrite(_nhandle,'<p align="center" style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#0000FF">VERIFICAÇÃO SX3 X TABELA</font></b></p>'+chr(13)+chr(10))

fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p>'+chr(13)+chr(10))

fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">EMPRESA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">CHAVE</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">TABELA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">CAMPO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">TIPO SX3</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">TAMANHO SX3</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">DECIMAL SX3</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">TIPO TABELA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">TAMANHO TABELA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">DECIMAL TABELA</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">ERRO</font></b></td>'+chr(13)+chr(10))
if mv_par05==1 // CORRIGE ERROS AUTOMATICAMENTE
	fwrite(_nhandle,'<td align="center" bgcolor="#000080"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="1" color="#FFFFFF">SITUAÇÃO</font></b></td>'+chr(13)+chr(10))
endif
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))

_aareasm0:=sm0->(getarea())
sm0->(dbsetorder(1))
sm0->(dbseek(mv_par03,.t.))
while ! sm0->(eof()) .and.;
	sm0->m0_codigo<=mv_par04
	
	_carqsx2:="sx2"+sm0->m0_codigo+"0"
	dbusearea(.t.,,_carqsx2,"SX2NEW",.t.,.f.)
	dbsetindex(_carqsx2)
	
	_carqsx3:="sx3"+sm0->m0_codigo+"0"
	dbusearea(.t.,,_carqsx3,"SX3NEW",.t.,.f.)
	dbsetindex(_carqsx3)
	
	sx2new->(dbsetorder(1))
	sx2new->(dbseek(mv_par01,.t.))
	while ! sx2new->(eof()) .and.;
		sx2new->x2_chave<=mv_par02
		
		_ctabela:=alltrim(sx2new->x2_arquivo)
		
		incproc("Verificando tabela "+_ctabela)
		
		if tccanopen(_ctabela)
			_calias:=sx2new->x2_chave+"NEW"
			dbusearea(.t.,"TOPCONN",_ctabela,_calias,.t.,.f.)
			
			_aestrut:=(_calias)->(dbstruct())
			
			// VERIFICA SX3 X TABELA
			sx3new->(dbsetorder(1))
			sx3new->(dbseek(sx2new->x2_chave))
			while ! sx3new->(eof()) .and.;
				sx3new->x3_arquivo==sx2new->x2_chave
				
				if sx3new->x3_context<>"V"
					_ni:=ascan(_aestrut,{|x| alltrim(x[1])==alltrim(sx3new->x3_campo)})
					if _ni==0
						fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sm0->m0_codigo+'</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx2new->x2_chave+'</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_ctabela+'</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_campo+'</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_tipo+'</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_tamanho)+'</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_decimal)+'</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">CAMPO EXISTE NO SX3 E NÃO EXISTE NA TABELA</font></td>'+chr(13)+chr(10))
						if mv_par05==1 // CORRIGE ERROS AUTOMATICAMENTE
							reclock("SX3NEW",.f.)
							sx3new->(dbdelete())
							msunlock()
							fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">DELETADO DO SX3</font></td>'+chr(13)+chr(10))
						endif
						fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
					else
						if _aestrut[_ni,2]<>sx3new->x3_tipo
							fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sm0->m0_codigo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx2new->x2_chave+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_ctabela+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_campo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_tipo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_tamanho)+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_decimal)+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_aestrut[_ni,2]+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,3])+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,4])+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">TIPO DIFERENTE ENTRE SX3 E TABELA</font></td>'+chr(13)+chr(10))
							if mv_par05==1 // CORRIGE ERROS AUTOMATICAMENTE
								reclock("SX3NEW",.f.)
								sx3new->x3_tipo:=_aestrut[_ni,2]
								msunlock()
								fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">TIPO ALTERADO NO SX3</font></td>'+chr(13)+chr(10))
							endif
							fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
						endif
						if _aestrut[_ni,3]<>sx3new->x3_tamanho
							fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sm0->m0_codigo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx2new->x2_chave+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_ctabela+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_campo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_tipo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_tamanho)+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_decimal)+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_aestrut[_ni,2]+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,3])+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,4])+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">TAMANHO DIFERENTE ENTRE SX3 E TABELA</font></td>'+chr(13)+chr(10))
							if mv_par05==1 // CORRIGE ERROS AUTOMATICAMENTE
								reclock("SX3NEW",.f.)
								sx3new->x3_tamanho:=_aestrut[_ni,3]
								msunlock()
								fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">TAMANHO ALTERADO NO SX3</font></td>'+chr(13)+chr(10))
							endif
							fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
						endif
						if _aestrut[_ni,4]<>sx3new->x3_decimal
							fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sm0->m0_codigo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx2new->x2_chave+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_ctabela+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_campo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx3new->x3_tipo+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_tamanho)+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(sx3new->x3_decimal)+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_aestrut[_ni,2]+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,3])+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,4])+'</font></td>'+chr(13)+chr(10))
							fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">DECIMAL DIFERENTE ENTRE SX3 E TABELA</font></td>'+chr(13)+chr(10))
							if mv_par05==1 // CORRIGE ERROS AUTOMATICAMENTE
								reclock("SX3NEW",.f.)
								sx3new->x3_decimal:=_aestrut[_ni,4]
								msunlock()
								fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">DECIMAL ALTERADO NO SX3</font></td>'+chr(13)+chr(10))
							endif
							fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
						endif
					endif
				endif
				
				sx3new->(dbskip())
			end
			
			// VERIFICA TABELA X SX3
			for _ni:=1 to len(_aestrut)
				sx3new->(dbsetorder(2))
				if ! sx3new->(dbseek(pad(_aestrut[_ni,1],10)))
					fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sm0->m0_codigo+'</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+sx2new->x2_chave+'</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_ctabela+'</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_aestrut[_ni,1]+'</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="center" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+_aestrut[_ni,2]+'</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,3])+'</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td align="right" bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">'+str(_aestrut[_ni,4])+'</font></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">CAMPO EXISTE NA TABELA E NÃO EXISTE NO SX3</font></td>'+chr(13)+chr(10))
					if mv_par05==1 // CORRIGE ERROS AUTOMATICAMENTE
						fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="1" color="#000080">VERIFICAR ERRO</font></td>'+chr(13)+chr(10))
					endif
					fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
				endif
			next
			
			(_calias)->(dbclosearea())
		endif
		
		sx2new->(dbskip())
	end
	sx2new->(dbclosearea())
	sx3new->(dbclosearea())
	
	_cemp:=sm0->m0_codigo
	while ! sm0->(eof()) .and.;
		sm0->m0_codigo==_cemp
		
		sm0->(dbskip())
	end
end
sm0->(restarea(_aareasm0))

fwrite(_nhandle,'</table>'+chr(13)+chr(10))

fwrite(_nhandle,'</body>'+chr(13)+chr(10))
fwrite(_nhandle,'</html>'+chr(13)+chr(10))

fclose(_nhandle)

shellexecute("open",_carq,"",_cpathtmp,1)
return()