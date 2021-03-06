/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘
北砅rograma  � FC010FIL � Autor � Alex J鷑io de Miranda � Data � 22/09/09 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Filtrar Posi玢o de Cliente para Gerentes Regionais Apresen-潮�
北           � tando Somente Clientes que s鉶 Parte da Carteira do Mesmo. 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#include "topconn.ch"

user function fc010fil(cFilter)

//Tratamento do cFilter no Ponto de Entrada.

_aarea   :=getarea()
_aareasa3:=sa3->(getarea())

// PESQUISA CODIGO DO SUPERVISOR
_cfilsa3:=xfilial("SA3")
sa3->(dbsetorder(7))  

_cgerente:=""
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente1:=sa3->a3_cod
	_cgerente:=sa3->a3_codusr // Leandro 17/10/2016
else
	_cgerente:=space(6)
endif


if !empty(_cgerente)
	_cquery:=" SELECT"
	_cquery+=" A3_COD"
	_cquery+=" FROM "
	_cquery+= retsqlname("SA3")+" SA3"
	_cquery+=" WHERE SA3.D_E_L_E_T_=' '" 
	if  _cgerente1 > "001000" .or. _cgerente > "001000" 
		_cquery+=" AND A3_SUPER='"+_cgerente1+"'" // Leandro 17/10/2016
	else
			//_cquery+=" AND A3_COD='"+_cgerente+"'"
			_cquery+=" AND A3_CODUSR='"+_cgerente+"'" // Leandro 17/10/2016
	endif
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	
	tmp1->(dbgotop())
	
	_repres := "("
	
	while !tmp1->(eof())
		_repres += "'" + tmp1->a3_cod + "'"
		tmp1->(dbskip())
	
		if !tmp1->(eof())
			_repres += ","
		endif
	end
	           
	_repres += ")"
	tmp1->(dbclosearea())
	
	cFilter:=" A1_VEND IN " + _repres
endif

restarea(_aarea)
sa3->(restarea(_aareasa3))

return cFilter