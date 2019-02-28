/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT214   ³ Autor ³ Gardenia Ilany        ³ Data ³ 27/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Simulacao de Frete Saida                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function VIT214()

_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
sa1->(dbsetorder(1))
sa2->(dbsetorder(1))

_cliente:= space(06)
_loja:= "  "
_tpeso:=0
_volume:=0
_tnota:=0

@ 000,000 to 280,450 dialog odlg title "Informe os dados da simulação"
@ 005,005 say "Cliente"
@ 005,045 get _cliente picture "@!"  f3 "SA1"
@ 020,005 say "Loja"
@ 020,045 get _loja
@ 035,005 say "Peso"
@ 035,045 get _tpeso picture  "@E 999,999.99"
@ 050,005 say "Volume"
@ 050,045 get _volume  picture "@E 999,999.99"
@ 065,005 say "Valor NF"
@ 065,045 get _tnota picture "@E 999,999.99"

@ 125,020 bmpbutton type 1 action _simula()
@ 125,055 bmpbutton type 2 action close(odlg)

activate dialog odlg centered
return


Static  Function _simula()

_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
_cfilsa4:=xfilial("SA4")
_cfilszb:=xfilial("SZB")
_cfilsf2:=xfilial("SF2")
szb->(dbsetorder(1))
sa1->(dbsetorder(1))
sa2->(dbsetorder(1))
sa4->(dbsetorder(1))

_nregsf2:=recno()
_data:=date()

sa1->(dbseek(_cfilsa1+_cliente+_loja))
_cnomecli:=sa1->a1_nome
_uf:= sa1->a1_est
_local:=sa1->a1_local
_suframa:= sa1->a1_suframa

sa4->(dbseek(_cfilsa4+sf2->f2_transp))
_valor1:=999999999
_valor2:=999999999
_valor3:=999999999
_transp1:="      "
_transp2:="      "
_transp3:="      "

szb->(dbgotop())
while ! szb->(eof())
	if  _local == szb->zb_local .and.;
		szb->zb_tipo=="S" .and.;
		_uf == szb->zb_uf
		
		_apta:=.t.
		_porto:=.f.
		_aliqicm:=0

		_txsuframa:=0
		if !empty(_suframa) .or. _uf=="AM"
			_txsuframa:= szb->zb_suframa
		endif
		
		if ((_tpeso < szb->zb_fretmax) .or. (szb->zb_fretmax=0)) .and. (szb->zb_tpcalc=="2")	// Cálculo sobre a Nota com peso menor que o Peso Máximo: Percentual
			_x:= (_tnota*szb->zb_advalor/100)

		elseif ((_tpeso > szb->zb_fretmax) .and. (szb->zb_tpcalc=="2")) .or.;   // Cálculo sobre a Nota com peso maior que Peso Máximo: Peso
			   (szb->zb_tpcalc=="1")   											// Cálculo sobre o Peso: Peso
			_x:= szb->zb_fretpes* _tpeso

		elseif szb->zb_tpcalc == "3"											// Cálculo sobre o Peso e a Nota (Ambos): Percentual + Peso
			_x:= (_tnota*szb->zb_advalor/100)
			_x:=_x+ szb->zb_fretpes* _tpeso
		endif

		_qtdped:=int(_tpeso/100)
		if (_tpeso/100)-_qtdped > 0
			_qtdped+=1
		endif

		_z:= _x		 							// Total do frete
	
		_aliqicm:= (100-szb->zb_aliqicm)/100 	// Alíquota do ICMS

		_peso:=.f.	  
		_x:= _z/_tpeso 		  
		if _x < szb->zb_vlrmin					// Verifica se o Valor por Peso é menor que o Peso Mínimo	
			_z:= szb->zb_vlrmin*_tpeso
			_peso:=.t.
		endif
	
		if _z < szb->zb_fretmin 				// Verifica se o Valor do Frete é menor que o Preço Mínimo
			_z:= szb->zb_fretmin
			_peso:=.f.
		endif
	
		if !_peso
			if _tnota*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (_tnota*szb->zb_gris/100)
			endif
			_z:=_z + _gris

			_z:= _z + szb->zb_txdocto							// Aplica a cobrança da Taxa do Documento		
		endif
		
		_z:= _z + szb->zb_txporto + (szb->zb_pedagio*_qtdped)	// Aplica Cobrança de Pedágio 

		_z:= _z + _txsuframa								// Aplica a cobrança da Taxa do Suframa
	
		_z:=_z/_aliqicm										// Aplica alíquota do ICMS

/*
		if szb->zb_tpcalc == "1"
			_x:= (_tpeso*szb->zb_fretpes)
		elseif szb->zb_tpcalc == "2"
			_x:= (_tnota*szb->zb_advalor/100)
			if _tpeso >= szb->zb_fretmax .and. szb->zb_fretmax >0
				_x:= (_tpeso*szb->zb_fretpes)
			endif
			if szb->zb_transp =="664828"  .and. _tpeso >= szb->zb_fretmax
				_x:= (_tpeso*szb->zb_fretpes)
				_x+= (_tnota*szb->zb_advalor/100)
			endif
		else
			_x:= (_tpeso*szb->zb_fretpes)
			_x+= (_tnota*szb->zb_advalor/100)
		endif
		
		_x:=_x + (_tnota*szb->zb_gris/100)
		_y:= szb->zb_fretpes* _tpeso
		_qtdped:=int(_tpeso/100)
		if (_tpeso/100)-_qtdped > 0
			_qtdped+=1
		endif
		_z:= _x+_y+ szb->zb_txdocto //+(szb->zb_pedagio*_qtdped)
		_aliqicm:= (100-szb->zb_aliqicm)/100
		if _z < szb->zb_fretmin
			_z:= szb->zb_fretmin
		endif
		_z:=_z/_aliqicm
		_z:=_z+szb->zb_txporto +(szb->zb_pedagio*_qtdped)+_txsuframa
*/

		if _z < _valor1 .and. (_valor1 >=_valor2) .and. (_valor1 >=_valor3)
			_valor1:= _z
			_transp1:= szb->zb_transp
		elseif _z <	_valor2 .and. (_valor2 >=_valor3)
			_valor2:= _z
			_transp2:= szb->zb_transp
		elseif _z < _valor3
			_valor3:=_z
			_transp3:= szb->zb_transp
		endif
		
	endif
	szb->(dbskip())
end

if _valor1==999999999
	_valor1:=0
	_transp1:="      "
endif
if _valor2==999999999
	_valor2:=0
	_transp2:="      "
endif
if	_valor3==999999999
	_valor3:=0
	_transp3:="      "
endif

///  Visualização das transportadoras

if _valor1==_valor2
	_valor1+=0.01
endif
if _valor1==_valor3
	_valor3+=0.01
endif
if _valor2==_valor3
	_valor2+=0.01
endif

if _valor1 ==0
	_valor1:= 999999
elseif _valor2==0
	_valor2 :=999999
elseif _valor3 ==0
	_valor3 := 999999
endif

sa2->(dbseek(_cfilsa1+_transp1))
_desc1:=sa2->a2_nome

sa2->(dbseek(_cfilsa2+_transp2))
_desc2:=sa2->a2_nome

sa2->(dbseek(_cfilsa2+_transp3))
_desc3:=sa2->a2_nome


if !empty(_desc1) .or. !empty(_desc2) .or.  !empty(_desc3)
	@ 000,000 to 320,430 dialog _odlg title "Transportadoras Selecionadas"
	
	if (_valor1 <= _valor2) .and. (_valor1 <= _valor3)  .and. _valor1 < 999998
		@ 020,010 say "1º "+_desc1
		@ 020,140 say  transform(_valor1,"999,999.99")
	elseif (_valor2 <= _valor1) .and. (_valor2 <= _valor3)	.and.  _valor2 < 999998
		@ 020,010 say "1º "+_desc2
		@ 020,140 say  transform(_valor2,"999,999.99")
	elseif	(_valor3 <= _valor2) .and. (_valor3 <= _valor1)	.and.  _valor3 < 999998
		@ 020,010 say "1º "+_desc3
		@ 020,140 say  transform(_valor3,"999,999.99")
	endif
	
	
	if ((_valor1 >= _valor2) .and. (_valor1 <= _valor3)) .or.  ((_valor1 <= _valor2) .and. (_valor1 >= _valor3))  .and. _valor1 < 999998
		@ 040,010 say "2º "+_desc1
		@ 040,140 say  transform(_valor1,"999,999.99")
	elseif ((_valor2 >= _valor1) .and. (_valor2 <= _valor3)) .or.  ((_valor2 >= _valor3) .and. (_valor2 <= _valor1))   .and. _valor2 < 999998
		@ 040,010 say "2º "+_desc2
		@ 040,140 say  transform(_valor2,"999,999.99")
	elseif ((_valor3 >= _valor1) .and. (_valor3 <= _valor2)) .or.  ((_valor3 <= _valor1) .and. (_valor3 >= _valor2))  .and. _valor3 < 999998
		@ 040,010 say "2º "+_desc3
		@ 040,140 say  transform(_valor3,"999,999.99")
	endif
	
	
	if (_valor1 >= _valor2) .and. (_valor1 >= _valor3) .and. _valor1 < 999998
		@ 060,010 say "3º "+_desc1
		@ 060,140 say  transform(_valor1,"999,999.99")
	elseif (_valor2 >= _valor1) .and. (_valor2 >= _valor3)	  .and. _valor2 < 999998
		@ 060,010 say "3º "+_desc2
		@ 060,140 say  transform(_valor2,"999,999.99")
	elseif	(_valor3 >= _valor1) .and. (_valor3 >= _valor2)	.and. _valor3 < 999998
		@ 060,010 say "3º "+_desc3
		@ 060,140 say  transform(_valor3,"999,999.99")
	endif
	
	
	@ 095,010 bmpbutton type 1 action close(_odlg)
	activate dialog _odlg centered
	
endif
_cliente:= space(06)
_loja:= "  "
_tpeso:=0
_volume:=0
_tnota:=0
return

// Função TxSuframa inativada em 15/12/2008. Criado campo ZB_SUFRAMA para taxa do suframa por transportadora.
/*

Static function TxSuframa(_interv)
if _interv >= 0.01 .and. _interv <=100
	_txsuframa:=1.00
elseif  _interv >= 100.01 .and. _interv <=500
	_txsuframa:=2.06
elseif  _interv >= 500.01 .and. _interv <=1000
	_txsuframa:=6.97
elseif  _interv >= 1000.01 .and. _interv <=2000
	_txsuframa:=12.64
elseif  _interv >= 2000.01 .and. _interv <=5000
	_txsuframa:=29.07
elseif  _interv >= 5000.01 .and. _interv <=10000
	_txsuframa:=55.90
elseif  _interv >= 10000.01 .and. _interv <=20000
	_txsuframa:=126.88
elseif  _interv >= 20000.01 .and. _interv <=50000
	_txsuframa:=281.74
elseif  _interv >= 50000.01 .and. _interv <=100000
	_txsuframa:=630.50
elseif  _interv >= 100000.01 .and. _interv <=150000
	_txsuframa:=1213.51
elseif  _interv >= 150000.01 .and. _interv <=200000
	_txsuframa:=1610.01
elseif  _interv >= 200000.01 .and. _interv <=300000
	_txsuframa:=2167.65
elseif  _interv >= 300000.01 .and. _interv <=500000
	_txsuframa:=3484.54
elseif  _interv >= 500000.01 .and. _interv <=1000000
	_txsuframa:=6153.67
elseif  _interv >= 1000000.01 .and. _interv <=2000000
	_txsuframa:=12307.34
elseif  _interv >= 2000000.01 .and. _interv <=3000000
	_txsuframa:=18416.01
elseif  _interv >= 3000000.01
	_txsuframa:=24614.68
endif
return(_txsuframa)
*/
