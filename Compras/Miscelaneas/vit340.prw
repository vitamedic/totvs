/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT340   ³ Autor ³Alex Junio de Miranda  ³ Data ³ 28/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina de Liberação/Bloqueio de Solicitações de compras    ³±±
±±³          ³ por Solicitação (todos o itens)                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "protheus.ch"
#include "rwmake.ch"

user function vit340(cAlias,nReg,nOpc)

@ 000,000 to 145,300 dialog _odlg1 title "Liberação/Bloqueio de Solicitação de Compras"

@ 010,010 say "Confirme Operação para a seguinte S.C.:"
@ 020,010 say sc1->c1_num size 60,8

@ 040,015 Button OemToAnsi("_Liberar")  Size 36,16 Action Processa({|| _gravalib(sc1->c1_num)})
@ 040,058 Button OemToAnsi("_Bloquear") Size 36,16 Action Processa({|| _gravabloq(sc1->c1_num)})
@ 040,100 Button OemToAnsi("_Cancelar") Size 36,16 Action Close(_odlg1)

activate dialog _odlg1 centered
return()


/* LIBERAÇÃO DA SC */
static function _gravalib(_num)
sc1->(dbgotop())
sc1->(dbseek(xfilial()+_num))

while !sc1->(eof()) .and.;
		sc1->c1_num == _num
		
    if empty(sc1->c1_pedido)
		if empty(sc1->c1_dtlib1)
			sc1->(reclock("SC1",.f.))
			sc1->c1_aprov:="L"
			sc1->c1_dtlib1:=date()
			sc1->c1_dtlib2:=ctod("  /  /  ")
			sc1->c1_dtlib3:=ctod("  /  /  ")
			sc1->c1_nomapro:= RetNome(__cuserid)
			
		elseif empty(sc1->c1_dtlib2)
			sc1->(reclock("SC1",.f.))
			sc1->c1_aprov:="L"
			sc1->c1_dtlib2:=date()		
			sc1->c1_dtlib3:=ctod("  /  /  ")
			sc1->c1_nomapro:= RetNome(__cuserid)
			
		else
			sc1->(reclock("SC1",.f.))
			sc1->c1_aprov:="L"
			sc1->c1_dtlib3:=date()					
			sc1->c1_nomapro:= RetNome(__cuserid)
		endif
		sc1->(msunlock())
	endif
	sc1->(dbskip())
end
close(_odlg1)
return()


/* BLOQUEIO DA SC */
static function _gravabloq(_num)

sc1->(dbgotop())
sc1->(dbseek(xfilial()+_num))

while !sc1->(eof()) .and.; 
		sc1->c1_num == _num
		
    if empty(sc1->c1_pedido)
		sc1->(reclock("SC1",.f.))
		sc1->c1_aprov:="B"
		sc1->(msunlock())
	endif
	sc1->(dbskip())
end
close(_odlg1)
return()


Static Function RetNome(_user)

Local _daduser  := {}
Local _userid := Alltrim(_user) // substr(cusuario,7,15)
Local _cNome := ""

psworder(1)

if pswseek(_userid,.t.)
	_daduser:=pswret(1)
	_cNome  := _daduser[1,2]
endif

Return (_cNome)
