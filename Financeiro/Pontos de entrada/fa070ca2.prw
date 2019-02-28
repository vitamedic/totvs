/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Programa  ³ FA070CA2 ³ Autor ³ Heraildo C. de Freitas³ Data ³ 22/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para Verificar se o Cancelamento da Baixa ³±±
±±³          ³ do Titulo a Receber Refere-se a Cheque Devolvido           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function fa070ca2()
if substr(se1->e1_tipo,1,2)=="CH"
	@ 000,000 to 080,300 dialog odlg title "Cheques devolvidos"
	@ 005,005 say "Cheque devolvido?"
	@ 020,005 button "_1a. devolucao" size 50,10 action _primeira()
	@ 020,060 button "_2a. devolucao" size 50,10 action _segunda()
	@ 020,115 button "_Nao"           size 20,10 action close(odlg)
	activate dialog odlg centered
endif
return

static function _primeira()
_nordsa1:=sa1->(indexord())
_nregsa1:=sa1->(recno())

_cfilsa1:=xfilial("SA1")
sa1->(dbsetorder(1))

if sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))
	sa1->(reclock("SA1",.f.))
	if empty(se1->e1_dtdev1)
		sa1->a1_chqdevo++
	endif
	sa1->a1_dtulchq:=ddatabase
	sa1->(msunlock())
	
	se1->(reclock("SE1",.f.))
	se1->e1_dtdev1:=ddatabase
	se1->(msunlock())
endif

sa1->(dbsetorder(_nordsa1))
sa1->(dbgoto(_nregsa1))
close(odlg)
return

static function _segunda()
_nordsa1:=sa1->(indexord())
_nregsa1:=sa1->(recno())

_cfilsa1:=xfilial("SA1")
sa1->(dbsetorder(1))

if sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))
	sa1->(reclock("SA1",.f.))
	sa1->a1_dtulchq:=ddatabase
	sa1->(msunlock())

	se1->(reclock("SE1",.f.))
	se1->e1_dtdev2:=ddatabase
	se1->(msunlock())
endif

sa1->(dbsetorder(_nordsa1))
sa1->(dbgoto(_nregsa1))
close(odlg)
return
