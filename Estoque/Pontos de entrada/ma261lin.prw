/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±³Programa  ³MA261LIN  ³Autor  ³Alex Júnio de Miranda ³ Data ³ 07/12/10  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Valida a inclusao de tranferencias (mod. 2) verificando se ³±±
±±³          ³ as informações de origem e/ou destino são compatíveis      ³±±
±±³          ³ gerando advertências em tela para notificação dos usuários ³±±
±±³          ³ ---------------------------------------------------------- ³±±
±±³          ³ Bloqueia movimentação de produtos que não são permitidas   ³±±
±±³          ³ para o usuário, conforme procedimento PR-GTI-027           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function ma261lin()
local _lok			:=.t.
local _npdelete		:=len(aheader)+1
local _ni       	:=1
local _codUsuario	:= RETCODUSR()

local _npProdOrig :=ascan(aheader,{|x| upper(alltrim(x[1]))=="PROD.ORIG."})
local _npArmOrig  :=ascan(aheader,{|x| upper(alltrim(x[1]))=="ARMAZEM ORIG."})
local _npEndOrig  :=ascan(aheader,{|x| upper(alltrim(x[1]))=="ENDERECO ORIG."})
local _npLoteOrig :=ascan(aheader,{|x| upper(alltrim(x[1]))=="LOTE"})
local _npValOrig  :=ascan(aheader,{|x| upper(alltrim(x[1]))=="VALIDADE"})
local _npProdDest :=ascan(aheader,{|x| upper(alltrim(x[1]))=="PROD.DESTINO"})
local _npArmDest  :=ascan(aheader,{|x| upper(alltrim(x[1]))=="ARMAZEM DESTINO"})
local _npEndDest  :=ascan(aheader,{|x| upper(alltrim(x[1]))=="ENDERECO DESTINO"})
local _npLoteDest :=ascan(aheader,{|x| upper(alltrim(x[1]))=="LOTE DESTINO"})
local _npValDest  :=ascan(aheader,{|x| upper(alltrim(x[1]))=="VALIDADE DESTINO"})

if !isBlind()// so executo se for diferente de rotinas automaticas
	while _lok .and.;
		_ni<=len(acols)
		
		if ! acols[_ni,_npdelete]
			// Dados Produto Origem
			_cProdOrig :=acols[_ni,_npProdOrig]
			_cArmOrig  :=acols[_ni,_npArmOrig]
			_cEndOrig  :=acols[_ni,_npEndOrig]
			_cLoteOrig :=acols[_ni,_npLoteOrig]
			_cValOrig  :=acols[_ni,_npValOrig]
			
			// Dados Produto Destino
			_cProdDest :=acols[_ni,_npProdDest]
			_cArmDest  :=acols[_ni,_npArmDest]
			_cEndDest  :=acols[_ni,_npEndDest]
			_cLoteDest :=acols[_ni,_npLoteDest]
			_cValDest  :=acols[_ni,_npValDest]
			
			_cTpProd   := Posicione("SB1",1,xfilial("SB1")+_cProdOrig,"B1_TIPO")
			_cTpLib    := Posicione("ZAA",1,xfilial("ZAA")+_codUsuario,"ZAA_TIPOPR")
			
			if !empty(_cTpLib) .and. _cTpProd $ _cTpLib
				
				if alltrim(_cProdOrig)<>alltrim(_cProdDest)
					MsgAlert( " Esta movimentação não e permitida, somente transferencias usando os mesmos PRODUTOS podem ser feitas. " )
					_lok:=.f.
				endif
				
				if alltrim(_cArmOrig)<>alltrim(_cArmDest)
					if MsgYesNo("Codigos para Armazem Origem e Destino sao diferentes. Confirma Transferencia?",OemToAnsi('ATENCAO'))
						_lok:=.t.
					else
						_lok:=.f.
					endif
				endif
				
				if alltrim(_cLoteOrig)<>alltrim(_cLoteDest)
					MsgAlert( " Esta movimentação não e permitida, somente transferencias usando os mesmos LOTES podem ser feitas. " )
					_lok:=.f.
				endif
				
				if !_cValOrig == _cValDest
					MsgAlert( " Esta movimentação não e permitida, somente transferencias usando os mesmos VENCIMENTOS DE LOTES podem ser feitas. " )
					_lok:=.f.
				endif
			else
				MsgAlert( " Usuário não tem permissão para movimentar este tipo de produto. " )
				_lok:=.f.
			endif
		endif
		
		_ni++
	end
endIf

return(_lok)