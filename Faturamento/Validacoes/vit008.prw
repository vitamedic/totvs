/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅ROGRAMA  � VIT008   � AUTOR � Heraildo C. de Freitas� DATA �10/01/2002潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰ESCRICAO � Validacao no Percentual de Desconto no Pedido de Venda     潮�
北�          � nao Permitindo Ultrapassar o Desconto Maximo do Produto    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#include "rwmake.ch"

user function vit008()
	if m->c5_tipo <> "N" //.and. m->c5_tipo <> "C"
		_lok:=.f.
//elseif m->c5_tipo = "C"
//	_lok:=.t.
	else
		_lok:=.t.
	endif
	_cfilsb1:=xfilial("SB1")
	sb1->(dbsetorder(1))

	_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRODUTO"})
	_cproduto :=acols[n,_npproduto]
	_ndescavi:=0

	sb1->(dbseek(_cfilsb1+_cproduto))
	if sb1->b1_promoc=="M"
		if m->c5_condpag$"536/607/608/836/860/861"   // A VISTA
			if da0->da0_status$"L/R"
				_ndescavi:=3
			else
				_ndescavi:=5
			endif
		endif
		if m->c5_descit>sb1->b1_descmax
			_ndescont:=sb1->b1_descmax
		else
			_ndescont:=m->c5_descit
		endif
	else
		if m->c5_condpag$"536/607/608/836/860/861" // A VISTA
			if sb1->b1_promoc$"PF" .and.;
					m->c5_promoc=="S"
				_ndescavi:=3
			else
				if da0->da0_status$"L/R"
					_ndescavi:=3
				else
					_ndescavi:=5
				endif
			endif
		endif

		if sb1->b1_promoc$"PF" .and.;
				m->c5_promoc=="S"
			_ndescont:=sb1->b1_descmax
		else
			if alltrim(cusername)$getmv("MV_PEDAUT") //Getnewpar("MV_PEDAUT","Administrador")==Substr(cUsuario,7,15) .or. Alltrim(Substr(cUsuario,7,15))=="Administrador")
				_ndescont:=m->c6_descont
				_lok:=.t.
			else
				if empty(m->c5_pocket) .or. !inclui
					_ndescont:=m->c5_descit
					_lok:=.f.
				elseif !empty(m->c5_pocket) .and. inclui
					_ndescont:=m->c5_descit
					_lok:=.t.
				endif
			endif
		endif
	endif
	if empty(m->c5_pocket)
		if m->c6_descont>_ndescont+_ndescavi .or. (m->c6_descont<>_ndescont+_ndescavi .and. !alltrim(cusername)$getmv("MV_PEDAUT"))
			_lok:=.f.
			msginfo("Desconto digitado ultrapassou o maximo permitido para este produto!")
		endif
	endif
return(_lok)