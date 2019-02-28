/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT274   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 03/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ AXCADASTRO para Manutencao na Tabela de Farmaceuticos      ³±±
±±³          ³ Responsaveis pelos Lotes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "protheus.ch"
#include "rwmake.ch"

user function vit274()
set key VK_F4 to U_VIT274L()

sz0->(dbsetorder(1))
sz0->(dbgotop())
axcadastro("SZ0","Farmaceuticos responsaveis pelos lotes")

set key VK_F4 to
return()

// VALIDACAO DOS CAMPOS
user function vit274a()
_cfilsb8:=xfilial("SB8")

_lok:=.t.
_cvar:=upper(alltrim(readvar()))
if _cvar=="M->Z0_PRODUTO"
	_lok:=existcpo("SB1",m->z0_produto) .and. existcpo("SB8",m->z0_produto+alltrim(m->z0_local)+alltrim(m->z0_lotectl),3) .and. existchav("SZ0",m->z0_produto+m->z0_local+m->z0_lotectl)
elseif _cvar=="M->Z0_LOCAL"
	_lok:=existcpo("SB8",m->z0_produto+m->z0_local+alltrim(m->z0_lotectl),3) .and. existchav("SZ0",m->z0_produto+m->z0_local+m->z0_lotectl)
elseif _cvar=="M->Z0_LOTECTL"
	_lok:=existcpo("SB8",m->z0_produto+m->z0_local+m->z0_lotectl,3) .and. existchav("SZ0",m->z0_produto+m->z0_local+m->z0_lotectl)
endif

if _lok
	sb8->(dbsetorder(3))
	if sb8->(dbseek(_cfilsb8+m->z0_produto+m->z0_local+m->z0_lotectl))
		if sb8->b8_dtvalid<ddatabase
			_lok:=.f.
			msgstop("Lote vencido!")
		elseif u_vit274c(.t.)==0 // SALDO DO LOTE
			_lok:=.f.
			msgstop("Lote com saldo zerado!")
		endif
	endif
endif
return(_lok)

// GATILHO QUE RETORNA A DATA DE VALIDADE DO LOTE
user function vit274b(_lvar)
_cfilsb8:=xfilial("SB8")

if _lvar
	_cproduto:=m->z0_produto
	_clocal  :=m->z0_local
	_clotectl:=m->z0_lotectl
else
	_cproduto:=sz0->z0_produto
	_clocal  :=sz0->z0_local
	_clotectl:=sz0->z0_lotectl
endif

sb8->(dbsetorder(3))
sb8->(dbseek(_cfilsb8+_cproduto+_clocal+_clotectl))
return(sb8->b8_dtvalid)

// RETORNA O SALDO DO LOTE
user function vit274c(_lvar)
_cfilsb8:=xfilial("SB8")
if _lvar
	_cproduto:=m->z0_produto
	_clocal  :=m->z0_local
	_clotectl:=m->z0_lotectl
else
	_cproduto:=sz0->z0_produto
	_clocal  :=sz0->z0_local
	_clotectl:=sz0->z0_lotectl
endif
_nsaldo:=0
sb8->(dbsetorder(3))
sb8->(dbseek(_cfilsb8+_cproduto+_clocal+_clotectl))
while ! sb8->(eof()) .and.;
	sb8->b8_filial==_cfilsb8 .and.;
	sb8->b8_produto==_cproduto .and.;
	sb8->b8_local==_clocal .and.;
	sb8->b8_lotectl==_clotectl
	_nsaldo+=sb8->b8_saldo	
	sb8->(dbskip())
end
return(_nsaldo)

user function vit274l()
_cvar:=upper(alltrim(readvar()))
if _cvar=="M->Z0_LOTECTL
	f4lote(,,,"VIT274",m->z0_produto,m->z0_local)
endif
return()
