#include "rwmake.ch"

/*/{Protheus.doc} vit065
Rotina Vit623
Gatilho para Atualizar a Data de Validade na Ordem de Produção

02/10/2017 - Gatilho alterado para retornar Lote e Validade do
PI, caso parâmetro MV_XPI == 'S'

@author Heraildo Freitas
@since 17/05/2002
@version P11
@return Nil(nulo)
@author Henrique Corrêa

/*/

user function vit065()

	Local _ddtvalid

	_cfilsb1:=xfilial("SB1")
	sb1->(dbsetorder(1))

	sb1->(dbseek(_cfilsb1+m->c2_produto))
	if val(m->c2_item)==1
		_ddtvalid:=if(empty(m->c2_datpri),ddatabase,m->c2_datpri)+sb1->b1_prvalid
	else
		_nordsc2:=sc2->(indexord())
		_nregsc2:=sc2->(recno())

		_cfilsc2:=xfilial("SC2")
		sc2->(dbsetorder(1))

		_lok:=.f.
		sc2->(dbseek(_cfilsc2+m->c2_num))
		while ! sc2->(eof()) .and.;
		sc2->c2_filial==_cfilsc2 .and.;
		sc2->c2_num==m->c2_num .and.;
		! _lok
			if val(sc2->c2_item)==1
				_lok:=.t.
				_ddtvalid:=sc2->c2_dtvalid
			endif
			sc2->(dbskip())
		end
		if ! _lok
			_ddtvalid:=if(empty(m->c2_datpri),ddatabase,m->c2_datpri)+sb1->b1_prvalid
		endif
		sc2->(dbsetorder(_nordsc2))
		sc2->(dbgoto(_nregsc2))
	endif

return(_ddtvalid)