#include 'protheus.ch'
#include 'parmtype.ch'
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT110END ³ AUTOR ³ Stephen Noel de M R³   Data ³  12/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada apos a Lieração da Solicitação de Compras ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function MT110END()

Local nNumSC := PARAMIXB[1]       // Numero da Solicitação de compras 
Local nOpca  := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear // Validações do Usuario

sc1->(dbgotop())
sc1->(dbseek(xfilial("SC1") + nNumSC))

while !sc1->(eof()) .and.;
		sc1->c1_num == nNumSC
		
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
Return 

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
