/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT040   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 12/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alteracao de Transportadora e Condicao de Pagamento de     ³±±
±±³          ³ Pedidos de Venda                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/ 

#include "rwmake.ch"

user function vit040()
ccadastro:="Altera transportadora e condicao de pagamento"
arotina  :={{"Pesquisar","AXPESQUI"                    ,0,1},;
				{"Alterar"  ,'EXECBLOCK("VIT040A",.F.,.F.)',0,2}}
sc5->(dbsetorder(1))
sc5->(dbgotop())
mbrowse(6,1,22,75,"SC5",,"C5_NOTA")
return

user function vit040a()
if ! empty(sc5->c5_nota)
	msginfo("Pedido ja encerrado!")
else
	_cfilsa1:=xfilial("SA1")
	_cfilsa2:=xfilial("SA2")
	_cfilsa4:=xfilial("SA4")
	_cfilse4:=xfilial("SE4")
	sa1->(dbsetorder(1))
	sa2->(dbsetorder(1))
	sa4->(dbsetorder(1))
	se4->(dbsetorder(1))
	
	if sc5->c5_tipo$"BD"
		sa2->(dbseek(_cfilsa2+sc5->c5_cliente+sc5->c5_lojacli))
		_cnomecli:=sa2->a2_nome
	else
		sa1->(dbseek(_cfilsa1+sc5->c5_cliente+sc5->c5_lojacli))
		_cnomecli:=sa1->a1_nome
	endif

	sa4->(dbseek(_cfilsa4+sc5->c5_transp))
	se4->(dbseek(_cfilse4+sc5->c5_condpag))

	_ctransp :=sc5->c5_transp
	_cnometra:=sa4->a4_nome
	_ccondpag:=sc5->c5_condpag
	_cdescpag:=se4->e4_descri

	@ 000,000 to 200,450 dialog odlg title "Altera transportadora e condicao de pagamento"
	@ 005,005 say "Pedido"
	@ 005,045 say sc5->c5_num
	@ 020,005 say "Tipo"
	@ 020,045 say sc5->c5_tipo
	if sc5->c5_tipo$"BD"
		@ 035,005 say "Fornecedor"
	else
		@ 035,005 say "Cliente"
	endif
	@ 035,045 say sc5->c5_cliente+"/"+sc5->c5_lojacli+"-"+_cnomecli
	@ 050,005 say "Transportadora"
	@ 050,045 get _ctransp size 30,8 valid _vtransp() f3 "SA4"
	@ 050,080 get _cnometra size 120,8 when .f.
	@ 065,005 say "Condicao"
	@ 065,045 get _ccondpag size 20,8 valid _vcondpag() f3 "SE4"
	@ 065,080 get _cdescpag size 80,8 when .f.

	@ 085,020 bmpbutton type 1 action _grava()
	@ 085,055 bmpbutton type 2 action close(odlg)

	activate dialog odlg centered
endif
return

static function _grava()
sc5->(reclock("SC5",.f.))
sc5->c5_transp :=_ctransp
sc5->c5_condpag:=_ccondpag
msunlock()
close(odlg)
return

static function _vtransp()
_lok:=.t.
if sa4->(dbseek(_cfilsa4+_ctransp))
	_cnometra:=sa4->a4_nome
else
	_lok:=.f.
	msginfo("Codigo nao cadastrado!")
endif
return(_lok)

static function _vcondpag()
_lok:=.t.
if _ccondpag<"500"
	_lok:=.f.
	msginfo("Condicao de pagamento nao permitida!")
elseif se4->(dbseek(_cfilse4+_ccondpag))
	_cdescpag:=se4->e4_descri
else
	_lok:=.f.
	msginfo("Codigo nao cadastrado!")
endif
return(_lok)