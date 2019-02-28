/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ WFW120P  ³ Autor ³ Heraildo C. de Freitas³ Data ³26/09/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada apos a gravacao do pedido de compras para ³±±
±±³          ³ solicitar a transportadora                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function wfw120p()

	static _cpedido
	private _ctransp


	if _cpedido==nil .or. _cpedido<>sc7->c7_num
	
		execblock("VIT191E",.f.,.f.)

		_cpedido:=sc7->c7_num
		_ctransp:=sc7->c7_trans
	
		@ 000,000 to 080,200 dialog odlg title "Informe a transportadora"
	
		@ 005,005 say "Transportadora"
		@ 005,045 get _ctransp f3 "SA4" valid fCertTransp() //vazio() .or. existcpo("SA4",_ctransp)
	
		@ 025,020 bmpbutton type 1 action _grava()
		@ 025,055 bmpbutton type 2 action close(odlg)
	
		activate dialog odlg centered
	endif
return

static function _grava()
	local _nregsc7,_nordsc7,_cfilsc7,_cnum

	_nregsc7:=sc7->(recno())
	_nordsc7:=sc7->(indexord())
	_cfilsc7:=xfilial("SC7")
	sc7->(dbsetorder(1))

	_cnum:=sc7->c7_num
	sc7->(dbseek(_cfilsc7+_cnum))
	while ! sc7->(eof()) .and.;
			sc7->c7_filial==_cfilsc7 .and.;
			sc7->c7_num==_cnum
		sc7->(reclock("SC7",.f.))
		sc7->c7_trans:=_ctransp
		sc7->(msunlock())
		sc7->(dbskip())
	end
	sc7->(dbsetorder(_nordsc7))
	sc7->(dbgoto(_nregsc7))
	close(odlg)
return

//****************************************************************************************************
//| Funcao    | fCertTransp |  Autor |  Roberto Fiuza      |  Data |   04/06/17  |                   |
//|**************************************************************************************************|
//| Descricao |  A funcao para validar a transportadora                                              |
//|           |                                                                                      |
//|**************************************************************************************************|
//| Uso       | Fiuza's Informatica                                                                  |
//****************************************************************************************************

Static Function fCertTransp()

	IF EMPTY(_ctransp)
		msgstop("Transportadora não informada")
		return .f.
	ENDIF
	
	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial() + _ctransp )
	if eof()
		msgstop("Transportadora não cadastrada")
		return .f.
	else
		IF EMPTY(A4_XCERT1)
			msgstop("Transportadora sem o certificado 1")
			return .f.
		else
			if A4_XDTCER1 < dDataBase
				msgstop("Transportadora com o certificado " + alltrim(A4_XCERT1) + " vencido em " + dtoc(A4_XDTCER1) )
				return .f.
			endif
		ENDIF
	
		IF ! EMPTY(A4_XCERT2)
			if A4_XDTCER2 < dDataBase
				msgstop("Transportadora com o certificado " + alltrim(A4_XCERT2) + " vencido em " + dtoc(A4_XDTCER2) )
				return .f.
			endif
		ENDIF
	
		IF ! EMPTY(A4_XCERT3)
			if A4_XDTCER3 < dDataBase
				msgstop("Transportadora com o certificado " + alltrim(A4_XCERT3) + " vencido em " + dtoc(A4_XDTCER3) )
				return .f.
			endif
		ENDIF
	
	
		_cnum   := sc7->c7_num
		_cfilsc7:= xfilial("SC7")
		wTipos  := ""
		waTPMat   := {}

		sc7->(dbseek(_cfilsc7+_cnum))
		while ! sc7->(eof()) .and. sc7->c7_filial==_cfilsc7 .and. sc7->c7_num==_cnum
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1") + SC7->C7_PRODUTO )
			wTipos := wTipos + SB1->B1_TIPO

			_ni := ascan(waTPMat,SB1->B1_TIPO)
			if _ni == 0
				aadd(waTPMat,SB1->B1_TIPO)
			endif


			sc7->(dbskip())
		enddo
	
		IF ! EMPTY(SA4->A4_XTPPROD)
			//IF ! SA4->A4_XTPPROD $ wTipos
			//	msgstop("Transportadora só pode transportar o tipo de marcadoria " + alltrim(SA4->A4_XTPPROD) )
			//	return .f.
			//ENDIF
			
			for _ni := 1 to len(waTPMat)
				if ! waTPMat[_ni] $ SA4->A4_XTPPROD
					msgstop("Transportadora nao pode transporta o tipo " + waTPMat[_ni] + ", só pode transportar o tipo de marcadoria " + alltrim(SA4->A4_XTPPROD) )
					return .f.
				endif
			next
			
		ENDIF
	
	endif
	
	
	
return .t.



