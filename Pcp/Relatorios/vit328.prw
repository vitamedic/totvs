#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT328   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 18/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Folha de Rosto (Composicao com Unidade Posologica) para    ³±±
±±³          ³ Formula-Mestre - Formato Html                               ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function vit328()

Private cAssunto  := 'Folha de Rosto Formula-Mestre'

cPerg:="PERGVIT328"
_Pergsx1()
pergunte(cPerg,.f.)

@ 106,074 To 346,606 Dialog oDialog Title OemToAnsi("Folha de Rosto Formula-Mestre")
@ 009,012 To 063,196 Title OemToAnsi(cAssunto) Object Quadro
@ 025,024 Say OemToAnsi("Este programa emitira no formato HTML a Folha de Rosto") Size 150,008
@ 038,024 Say OemToAnsi("da Formula-Mestre, contendo a estrutura do produto,   ") Size 150,008
@ 049,024 Say OemToAnsi("conforme os parametros especificados.")                  Size 042,008

@ 013,207 Button OemToAnsi("_Confirma")   Size 036,016 Action Processa({|| vit328a()})
@ 030,207 Button OemToAnsi("_Cancela")    Size 036,016 Action Close(oDialog)
@ 047,207 Button OemToAnsi("_Parametros") Size 036,016 Action Pergunte(cPerg,.T.)
Activate Dialog oDialog Centered
Return


Static Function vit328a()

_cfilsb1:=xfilial("SB1")
_cfilsg1:=xfilial("SG1")
_cfilqdh:=xfilial("QDH")
_cfilsah:=xfilial("SAH")
_cfilsga:=xfilial("SGA")
sb1->(dbsetorder(1))
sg1->(dbsetorder(1))
qdh->(dbsetorder(1))
sah->(dbsetorder(1))
sga->(dbsetorder(1))

_mfirst := .t.
_cMsg:=""

processa({|| _querys()})
tmp1->(dbgotop())
                        
while ! tmp1->(eof()) 

	_cprod:=tmp1->cod
	_mpag:=0
	_cMsg +=cabecalho(_cprod) // GERA CÓDIGO DO CABEÇALHO
	_evapora:=.f.
	_txtevap:=.f.
		
	while ! tmp1->(eof()) .and.;
			_cprod==tmp1->cod
	
		if tmp1->tipo $ 'MP/PI/ID'
			_linha:=1
			_quebra:=.f.
													
			while ! tmp1->(eof()) .and.;
					_cprod==tmp1->cod .and.;
					tmp1->tipo $ 'MP/PI/ID' .and.;
					! _quebra
				if tmp1->evapora="S"                
					_evapora:=.t.
					_txtevap:=.t.
				else
					_evapora:=.f.
				endif

				if _linha==1
					_cMsg += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
					_cMsg += '<td width="1054" colspan="7"  height="25"><p align="center" class="style2"><strong>MAT&Eacute;RIA-PRIMA</strong></p></td></tr></table>'

					_cMsg += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
					_cMsg += '<td width="73" height="25"><p align="center" class="style6"><strong>C&oacute;digo</strong> </p></td>'
					_cMsg += '<td width="432" height="25"><p align="center" class="style6">Mat&eacute;ria-Prima </p></td>'
					_cMsg += '<td width="58" height="25"><p align="center" class="style6">DCB </p></td>'
					_cMsg += '<td width="188" height="25"><p align="center" class="style6">Qtde. Padr&atilde;o </p></td>'
					_cMsg += '<td width="37" height="25"><p align="center" class="style6">UM </p></td>'
					_cMsg += '<td width="210" height="25"><p align="center" class="style6">Qtde. por Unid. Posol&oacute;gica ('+tmp1->unpos+')</p></td>'
					_cMsg += '<td width="40" height="25"><p align="center" class="style6">UM </p></td></tr>'
				endif
											
				_cMsg += '<tr>'
				_cMsg += '<td width="73" height="20"><p class="style3">&nbsp;'+left(tmp1->comp,6)+'</p></td>'
				if _evapora
					_cMsg += '<td width="432" height="20"><p class="style3">&nbsp;'+tmp1->descomp+'*</p></td>'
				else
					_cMsg += '<td width="432" height="20"><p class="style3">&nbsp;'+tmp1->descomp+'</p></td>'
				endif

				if !empty(tmp1->dcb1)
					_cMsg += '<td width="58" height="20"><p align="center" class="style3">'+tmp1->dcb1+'</p></td>'
				else
					_cMsg += '<td width="58" height="20"><p align="center" class="style3">&nbsp;</p></td>'
				endif
				_cMsg += '<td width="188" height="20"><p align="right" class="style3">'+transform((tmp1->quant),'@E 99,999,999.999999')+'</p></td>'
				_cMsg += '<td width="37" height="20"><p align="center" class="style3">'+tmp1->umcomp+'</p></td>'
				_cMsg += '<td width="210" height="20"><p align="right" class="style3">'+transform(((tmp1->quant/tmp1->funpos)/tmp1->le),'@E 99,999,999.999999')+'</p></td>'
				_cMsg += '<td width="40" height="20"><p align="center" class="style3">'+tmp1->umcomp+'</p></td>'
				_cMsg += '</tr>'	
				_linha++
				
				if _linha>=65
					// quebra a pagina
					_cMsg += '</table>'
					// quebra a pagina
					_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
					_cMsg += "<br clear=all style='page-break-before:always'>"
					_cMsg += '</span>'
					_cMsg +=cabecalho(_cprod) // GERA CÓDIGO DO CABEÇALHO
				
					_quebra:=.t.
				endif

				tmp1->(dbskip())
			end
			if _txtevap
				_cMsg += '<tr><td colspan="7"><p align="left" class="style3">* Subst&acirc;ncia desaparece no decorrer do processo.</p></td></tr>'
			endif
			_cMsg += '</table><br /><br />'

		else  // MATERIAL DE EMBALAGEM - Não separado como Essencial (primário) ou Não-essencial (secundário) por solicitação da GQL em 09/2008.
			_linha:=1
			_quebra:=.f.
													
			while ! tmp1->(eof()) .and.;
					_cprod==tmp1->cod .and.;
					tmp1->locpad $ '03/20' .and.;
					! _quebra

				if _linha==1
					_cMsg += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
//					_cMsg += '<td width="1054" colspan="6"  height="25"><p align="center" class="style2"><strong>MATERIAL DE EMBALAGEM PRIM&Aacute;RIA</strong></p></td></tr></table>'
					_cMsg += '<td width="1054" colspan="6"  height="25"><p align="center" class="style2"><strong>MATERIAL DE EMBALAGEM</strong></p></td></tr></table>'

					_cMsg += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
					_cMsg += '<td width="73" height="25"><p align="center" class="style6"><strong>C&oacute;digo</strong> </p></td>'
					_cMsg += '<td width="490" height="25"><p align="center" class="style6">Descri&ccedil;&atilde;o do Material </p></td>'
					_cMsg += '<td width="188" height="25"><p align="center" class="style6">Qtde. Padr&atilde;o </p></td>'
					_cMsg += '<td width="37" height="25"><p align="center" class="style6">UM </p></td>'
					_cMsg += '<td width="210" height="25"><p align="center" class="style6">Qtde. por Unid. Posol&oacute;gica ('+tmp1->unpos+')</p></td>'
					_cMsg += '<td width="40" height="25"><p align="center" class="style6">UM </p></td></tr>'					
				endif
											
				_cMsg += '<tr>'
				_cMsg += '<td width="73" height="20"><p class="style3">&nbsp;'+left(tmp1->comp,6)+'</p></td>'
				

				if !empty(alltrim(tmp1->gropc)) // Material em Grupo de Opcionais
   					sga->(dbseek(_cfilsga+tmp1->gropc+tmp1->opc))
					_cMsg += '<td width="490" height="20"><p class="style3">&nbsp;'+tmp1->descomp+' (OPCIONAL '+ tmp1->opc +' - '+alltrim(sga->ga_descgrp)+')</p></td>'
				else  // Sem Grupo de Opcionais
					_cMsg += '<td width="490" height="20"><p class="style3">&nbsp;'+tmp1->descomp+'</p></td>'
				endif

				_cMsg += '<td width="188" height="20"><p align="right" class="style3">'+transform((tmp1->quant),'@E 99,999,999.999999')+'</p></td>'
				_cMsg += '<td width="37" height="20"><p align="center" class="style3">'+tmp1->umcomp+'</p></td>'
				_cMsg += '<td width="210" height="20"><p align="right" class="style3">'+transform(((tmp1->quant/tmp1->funpos)/tmp1->le),'@E 99,999,999.999999')+'</p></td>'
				_cMsg += '<td width="40" height="20"><p align="center" class="style3">'+tmp1->umcomp+'</p></td>'
				_cMsg += '</tr>'	
				_linha++
				
				if _linha>=65
					// quebra a pagina
					_cMsg += '</table>'
					// quebra a pagina
					_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
					_cMsg += "<br clear=all style='page-break-before:always'>"
					_cMsg += '</span>'
					_cMsg +=cabecalho(_cprod) // GERA CÓDIGO DO CABEÇALHO
				
					_quebra:=.t.
				endif

				tmp1->(dbskip())
			end
			_cMsg += '</table><br /><br />'
		endif			
	end	

	_cMsg += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
	_cMsg += '<td width="264" height="30" class="style6"><p align="center"><strong>ELABORADOR</strong></p></td>'
	_cMsg += '<td width="264" height="30" class="style6"><p align="center"><strong>REVISOR</strong></p></td>'
	/*Leandro */
	_cMsg += '<td width="264" height="30" class="style6"><p align="center"><strong>REVISOR</strong></p></td>'
	/**/
	_cMsg += '<td width="263" height="30" class="style6"><p align="center"><strong>APROVADOR</strong></p></td>'
	_cMsg += '<td width="263" height="30" class="style6"><p align="center"><strong>GQL</strong></p></td>'
	_cMsg += '</tr><tr>'
	_cMsg += '<td width="264" height="70" class="style3"><p align="left" class="style2">&nbsp; Nome: <br /><br />&nbsp; Data: _____/_____/_____</p></td>'
	_cMsg += '<td width="264" height="70" class="style3"><p align="left" class="style2">&nbsp; Nome: <br /><br />&nbsp; Data: _____/_____/_____</p></td>'
	/*Leandro */
	_cMsg += '<td width="264" height="70" class="style3"><p align="left" class="style2">&nbsp; Nome: <br /><br />&nbsp; Data: _____/_____/_____</p></td>'
	/**/
	_cMsg += '<td width="263" height="70" class="style3"><p align="left" class="style2">&nbsp; Nome: <br /><br />&nbsp; Data: _____/_____/_____</p></td>'
	_cMsg += '<td width="263" height="70" class="style3"><p align="left" class="style2">&nbsp; Nome: <br /><br />&nbsp; Data: _____/_____/_____</p></td>'
	_cMsg += '</tr></table>'

	if !tmp1->(eof())
		_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
		_cMsg += "<br clear=all style='page-break-before:always'>"
		_cMsg += '</span>'		
	endif
end
       

_cMsg += '</body>'
_cMsg += '</html>'

tmp1->(dbclosearea())

//³ cria o arquivo em disco vit273.html e executa-o em seguida
_carquivo:="C:\WINDOWS\TEMP\FM.HTML"
nHdl := fCreate(_carquivo)
fWrite(nHdl,_cMsg,Len(_cMsg))
fClose(nHdl)
ExecArq(_carquivo)

set device to screen

ms_flush()
return



Static function cabecalho(_cprod)

sah->(dbseek(_cfilsah+tmp1->segum))
sb1->(dbseek(_cfilsb1+tmp1->cod))
_cMsg2:=''

if _mfirst
	_mpag:=1
	_mfirst:=.f.
	_cMsg2 := ''
	_cMsg2 += '<html xmlns="http://www.w3.org/1999/xhtml">'
	_cMsg2 += '<head>'
	_cMsg2 += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
	_cMsg2 += '<title>FOLHA DE ROSTO DA F&Oacute;RMULA-MESTRE</title>'
	_cMsg2 += '<style type="text/css">'
	_cMsg2 += '<!--'
	_cMsg2 += '.style2 {font-family: Arial, Helvetica, sans-serif}'
	_cMsg2 += '.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 10px; }'
	_cMsg2 += '.style4 {font-size: 12px}'
	_cMsg2 += '.style6 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }'
	_cMsg2 += '-->'
	_cMsg2 += '</style>'
	_cMsg2 += '</head>'
	_cMsg2 += '<body>'
else
	_mpag++
endif

//³ INÍCIO DO CÓDIGO HTML 
_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr><td>'
_cMsg2 += '<table width="1054" border="0" cellpadding="0" cellspacing="0"><tr>'
_cMsg2 += '<td width="135" rowspan="5" class="style2"><p align="center"><font face="Arial Black" size="6">Vitamedic</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </p></td>'
_cMsg2 += '<td colspan="2" class="style2"><p>Produto: <strong>'+substr(tmp1->cod,1,6)+' &ndash; '+tmp1->descri+'</strong></p></td>'
_cMsg2 += '<td width="180" class="style2"><p align="right">P&aacute;gina '+transform(_mpag,'@ 99')+'</p></td></tr><tr>'
_cMsg2 += '<td colspan="2" class="style2"><p>Denom.Qu&iacute;mica: '+tmp1->desccie+'</p></td>'
_cMsg2 += '<td width="180" class="style2"><p>Val.: <strong>'+strzero((tmp1->prvalid/365)*12,2,0)+' meses</strong></p></td></tr><tr>'
_cMsg2 += '<td colspan="2" class="style2"><p>Apresenta&ccedil;&atilde;o: '+tmp1->apres+'</p></td>'

if empty(tmp1->rv)
	_cMsg2 += '<td width="180" class="style2"><p>Rev.: &nbsp;</p></td></tr><tr>'
else
	_cMsg2 += '<td width="180" class="style2"><p>Rev.: <strong>'+tmp1->rv+'</strong></p></td></tr><tr>'
endif

if sb1->b1_tipo$"PA/PL/PI/PD"
	_cMsg2 += '<td width="300" class="style2"><p>Qtde.    Te&oacute;rica: <strong>'+Transform((tmp1->le),'@E 9,999,999')+' '+tmp1->um+'</strong></p></td>'
	_cMsg2 += '<td width="439" class="style2"><p>Qtde.    Te&oacute;rica 2&ordf; UM: <strong>'+Transform((tmp1->le2),'@E 9,999,999')+' '+upper(sah->ah_descpo)+'</strong></p></td>'
else 
	_cMsg2 += '<td width="300" class="style2"><p>Qtde.    Te&oacute;rica: <strong>'+Transform((tmp1->le),'@E 9,999,999.9999')+' '+tmp1->um+'</strong></p></td>'
	_cMsg2 += '<td width="439" class="style2"><p>Qtde.    Te&oacute;rica 2&ordf; UM: <strong>'+Transform((tmp1->le2),'@E 9,999,999.9999')+' '+upper(sah->ah_descpo)+'</strong></p></td>'
endif
	
if empty(tmp1->dtvig)
	_cMsg2 += '<td width="180" class="style2">Dt. Revis&atilde;o: &nbsp;</td></tr>'
else
	_cMsg2 += '<td width="180" class="style2">Dt. Revis&atilde;o: <strong>'+dtoc(tmp1->dtvig)+'</strong></td></tr>'
endif

_cMsg2 += '<tr><td width="913" colspan="3" class="style2"><p align="center"><strong>F&Oacute;RMULA-MESTRE</strong></p></td></tr>'
_cMsg2 += '</table></td></tr></table><br />'

return(_cMsg2)


//******************************************
static function _querys()
//******************************************

if mv_par07 == 1
	mv_par07 := "OP"
elseif mv_par07 == 2
	mv_par07 := "OE"
endif

_cquery:=" SELECT"
_cquery+=" COD," 
_cquery+=" DESCRI," 
_cquery+=" DESCCIE," 
_cquery+=" PRVALID," 
_cquery+=" APRES," 
_cquery+=" LE," 
_cquery+=" UM," 
_cquery+=" LE2," 
_cquery+=" SEGUM," 
_cquery+=" FUNPOS," 
_cquery+=" UNPOS," 
_cquery+=" DTVIG," 
_cquery+=" RV," 
_cquery+=" COMP," 
_cquery+=" DESCOMP," 
_cquery+=" TIPO," 
_cquery+=" UMCOMP," 
_cquery+=" LOCPAD," 
_cquery+=" GRUPO,"
_cquery+=" DCB1,"
_cquery+=" EVAPORA,"
_cquery+=" GROPC,"
_cquery+=" OPC,"
_cquery+=" Sum(QUANT) QUANT"
_cquery+=" FROM ("
_cquery+=" SELECT SG1.G1_COD COD,SB1A.B1_DESC DESCRI,SB1A.B1_DESCCIE DESCCIE,SB1A.B1_PRVALID PRVALID,SB1A.B1_UM UM,"
_cquery+=" CASE"
_cquery+="   WHEN SB1A.B1_TIPCONV='M' THEN (SB1A.B1_LE*SB1A.B1_CONV)"
_cquery+="   ELSE (SB1A.B1_LE/SB1A.B1_CONV)"
_cquery+=" END LE2,"
_cquery+=" SB1A.B1_SEGUM SEGUM,SB1A.B1_APRES APRES,SB1A.B1_LE LE,SB1A.B1_FUNPOS FUNPOS,SB1A.B1_UNPOS UNPOS,"
_cquery+=" (SELECT QDH1.QDH_DTVIG FROM "+retsqlname("QDH")+" QDH1 "
_cquery+="  WHERE QDH1.D_E_L_E_T_=' ' AND QDH1.QDH_DOCTO='"+ALLTRIM(mv_par07)+"-'||SubStr(SG1.G1_COD,1,13) AND QDH1.QDH_OBSOL<>'S' AND QDH1.QDH_DTVIG<>' ') DTVIG,"
_cquery+=" (SELECT QDH2.QDH_RV FROM "+retsqlname("QDH")+" QDH2 "
_cquery+="  WHERE QDH2.D_E_L_E_T_=' ' AND QDH2.QDH_DOCTO='"+ALLTRIM(mv_par07)+"-'||SubStr(SG1.G1_COD,1,13) AND QDH2.QDH_OBSOL<>'S' AND QDH2.QDH_DTVIG<>' ') RV,"
_cquery+=" SG1.G1_COMP COMP,SB1B.B1_DESC DESCOMP,SB1B.B1_TIPO TIPO,SB1B.B1_UM UMCOMP,SB1B.B1_LOCPAD LOCPAD,SB1B.B1_GRUPO GRUPO,SB1B.B1_DCB1 DCB1,SG1.G1_QUANT QUANT,"
_cquery+=" SG1.G1_EVAPORA EVAPORA, SG1.G1_GROPC GROPC, SG1.G1_OPC OPC"
_cquery+=" FROM "
_cquery+=retsqlname("SB1")+" SB1A,"
_cquery+=retsqlname("SB1")+" SB1B,"
_cquery+=retsqlname("SG1")+" SG1"
_cquery+=" WHERE"
_cquery+="     SB1A.D_E_L_E_T_=' '"
_cquery+=" AND SB1B.D_E_L_E_T_=' '"
_cquery+=" AND SG1.D_E_L_E_T_=' '"
_cquery+=" AND SB1A.B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND SB1B.B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND SG1.G1_FILIAL='"+_cfilsg1+"'"
_cquery+=" AND SG1.G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND SG1.G1_COD=SB1A.B1_COD"
_cquery+=" AND SB1A.B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND SB1A.B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND SB1B.B1_COD=SG1.G1_COMP)"
_cquery+=" GROUP BY COD, DESCRI, DESCCIE, PRVALID, UM, LE2, SEGUM, APRES, LE, FUNPOS, UNPOS, DTVIG, RV, COMP, DESCOMP, TIPO, UMCOMP, LOCPAD, GRUPO, DCB1, EVAPORA, GROPC, OPC"
//_cquery+=" ORDER BY COD,LOCPAD,TIPO,DESCOMP"
_cquery+=" ORDER BY COD,LOCPAD,DESCOMP"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","LE"     ,"N",15,7)
tcsetfield("TMP1","LE2"    ,"N",15,7)
tcsetfield("TMP1","QUANT"  ,"N",15,7)
tcsetfield("TMP1","FUNPOS" ,"N",9,2)
tcsetfield("TMP1","DTVIG"  ,"D")
return




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


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Tipo.Doc           ?","mv_ch7","N",01,0,3,"C",space(60),"mv_par07"       ,"OP"             ,space(30),space(15),"OE"             ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
