/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Programa  ³ FC010FIL ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 22/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Filtrar Posição de Cliente para Gerentes Regionais Apresen-³±±
±±           ³ tando Somente Clientes que são Parte da Carteira do Mesmo. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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