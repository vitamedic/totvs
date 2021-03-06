#include 'protheus.ch'
#include 'parmtype.ch'
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT110END � AUTOR � Stephen Noel de M R�   Data �  12/09/18 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de entrada apos a Liera玢o da Solicita玢o de Compras 潮�
北�          �                                                            潮�
北�          �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitamedic                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
User Function MT110END()

Local nNumSC := PARAMIXB[1]       // Numero da Solicita玢o de compras 
Local nOpca  := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear // Valida珲es do Usuario

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
