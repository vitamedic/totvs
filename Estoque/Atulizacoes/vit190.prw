/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ vit190   ³ Autor ³ Gardenia Ilany F. Vale  Data ³ 07/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Digitacao de simulacao de frete (modelo 3)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SZE - Simulacao de frete                                   ³±±
±±³          ³ SZF - Doumentacao da simulacao   de frete                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function VIT190()
_cfilsa2:=xfilial("SA2")
_cfilszf:=xfilial("SZF")
_cfilsze:=xfilial("SZE")
_cfilszd:=xfilial("SZD")
_cfilszc:=xfilial("SZC")
sa2->(dbsetorder(1))
szf->(dbsetorder(1))
sze->(dbsetorder(1))
szd->(dbsetorder(1))
szc->(dbsetorder(1))

ccadastro:="Simulacao de frete entrada"
arotina  :={}
aadd(arotina,{"Pesquisar"   ,"AXPESQUI()"           ,0,1})
aadd(arotina,{"Visualizar"  ,"U_VIT190A()"          ,0,2})
aadd(arotina,{"Incluir"     ,"U_VIT190B()"          ,0,3})
aadd(arotina,{"Alterar"     ,"U_VIT190C()"          ,0,4})
aadd(arotina,{"Excluir"     ,"U_VIT190D()"          ,0,5})
aadd(arotina,{"impRimir"    ,"U_VIT191()"           ,0,6})
aadd(arotina,{"Simul.s/gravar"    ,"U_VIT191E()"           ,0,6})

setprvt("_transp1,_transp2,_transp3,_valor1,_valor2,_valor3")

sze->(dbgotop())
mbrowse(6,1,22,75,"SZE",,"ZE_SIMULA")
return

// VISUALIZACAO
user function VIT190a()
copcao:="VISUALIZAR"
execblock("VIT190E",.f.,.f.)
return

// INCLUSAO
user function VIT190b()
copcao:="INCLUIR"
execblock("VIT190E",.f.,.f.)
return

// ALTERACAO
user function VIT190c()
copcao:="ALTERAR"
execblock("VIT190E",.f.,.f.)
return

// EXCLUSAO
user function VIT190d()
copcao:="EXCLUIR"
execblock("VIT190E",.f.,.f.)
return

// CONFIRMACAO
user function VIT190E()
if copcao=="INCLUIR"
	nopce:=3
	nopcg:=3
elseif copcao=="ALTERAR"
	nopce:=3
	nopcg:=4
else
	nopce:=2
	nopcg:=2
endif

regtomemory("SZE",copcao=="INCLUIR")

nusado :=0
aheader:={}
sx3->(dbsetorder(1))
sx3->(dbseek("SZF"))
while ! sx3->(eof()) .and.;
	sx3->x3_arquivo=="SZF"
	if upper(alltrim(sx3->x3_campo))<>"ZF_SIMULA" .and.;
		x3uso(sx3->x3_usado) .and.;
		cnivel>=sx3->x3_nivel
		nusado++
		aadd(aheader,{alltrim(sx3->x3_titulo),sx3->x3_campo,sx3->x3_picture,;
		sx3->x3_tamanho,sx3->x3_decimal,sx3->x3_valid,;
		sx3->x3_usado,sx3->x3_tipo,sx3->x3_arquivo,sx3->x3_context})
	endif
	sx3->(dbskip())
end

if copcao=="INCLUIR"
	acols            :={array(nusado+1)}
	acols[1,nusado+1]:=.f.
	for _i:=1 to nusado
		acols[1,_i]:=criavar(aheader[_i,2])
	next
else
	acols:={}
	szf->(dbseek(_cfilszf+sze->ze_simula))
	while ! szf->(eof()) .and.;
		szf->zf_filial==_cfilszf .and.;
		szf->zf_simula==sze->ze_simula
		aadd(acols,array(nusado+1))
		for _i:=1 to nusado
			ccpo:=upper(alltrim(aheader[_i,2]))
			if aheader[_i,10]=="V"
				if ccpo=="ZF_DESCDOC"
					_cdocumen:=strzero(val(szf->zf_documen),3)
					acols[len(acols),_i]:=posicione("SZC",1,_cfilszc+_cdocumen,"ZC_DESC")
				endif
			else
				acols[len(acols),_i]:=szf->(fieldget(fieldpos(ccpo)))
			endif
		next
		acols[len(acols),nusado+1]:=.f.
		szf->(dbskip())
	end
	if len(acols)==0
		acols            :={array(nusado+1)}
		acols[1,nusado+1]:=.t.
		for _i:=1 to nusado
			acols[1,_i]:=criavar(aheader[_i,2])
		next
	endif
endif

_npref :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZF_DOCUMEN"})
_ndescdoc :=ascan(aheader,{|x| upper(alltrim(x[2]))=="ZF_DESCDOC"})
_npdel   :=len(aheader)+1

if len(acols)>0
	ctitulo       :="Simulacao de frete"
	caliasenchoice:="SZE"
	caliasgetd    :="SZF"
	clinok        :="ALLWAYSTRUE()"
	ctudok        :="ALLWAYSTRUE()"
	cfieldok      :="ALLWAYSTRUE()"
	acpoenchoice  :={"ZE_SIMULA"}
	
	_lret:=modelo3(ctitulo,caliasenchoice,caliasgetd,acpoenchoice,clinok,ctudok,nopce,nopcg,cfieldok,,900)
	if _lret .and. copcao<>"VISUALIZAR"
		_grava()
	endif
endif


sze->(dbseek(_cfilsze+m->ze_simula))

_valor1:=sze->ze_valor1
_valor2:=sze->ze_valor2
_valor3:=sze->ze_valor3

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

sa2->(dbseek(_cfilsa2+sze->ze_transp1))
_desc1:=sa2->a2_nome
sa2->(dbseek(_cfilsa2+sze->ze_transp2))
_desc2:=sa2->a2_nome
sa2->(dbseek(_cfilsa2+sze->ze_transp3))
_desc3:=sa2->a2_nome

if !empty(_desc1) .or. !empty(_desc2) .or.  !empty(_desc3)
	@ 000,000 to 320,430 dialog odlg title "Transportadoras Selecionadas"
	if (_valor1 <= _valor2) .and. (_valor1 <= _valor3)  .and. _valor1 < 999998
		@ 005,010 say "1º "+_desc1
		@ 005,140 say  transform(_valor1,"999,999.99")
	elseif (_valor2 <= _valor1) .and. (_valor2 <= _valor3)	.and.  _valor2 < 999998
		@ 005,010 say "1º "+_desc2
		@ 005,140 say  transform(_valor2,"999,999.99")
	elseif	(_valor3 <= _valor2) .and. (_valor3 <= _valor1)	.and.  _valor3 < 999998
		@ 005,010 say "1º "+_desc3
		@ 005,140 say  transform(_valor3,"999,999.99")
	endif
	
	if ((_valor1 >= _valor2) .and. (_valor1 <= _valor3)) .or.  ((_valor1 <= _valor2) .and. (_valor1 >= _valor3))  .and. _valor1 < 999998
		@ 020,010 say "2º "+_desc1
		@ 020,140 say  transform(_valor1,"999,999.99")
	elseif ((_valor2 >= _valor1) .and. (_valor2 <= _valor3)) .or.  ((_valor2 >= _valor3) .and. (_valor2 <= _valor1))   .and. _valor2 < 999998
		@ 020,010 say "2º "+_desc2
		@ 020,140 say  transform(_valor2,"999,999.99")
	elseif ((_valor3 >= _valor1) .and. (_valor3 <= _valor2)) .or.  ((_valor3 <= _valor1) .and. (_valor3 >= _valor2))  .and. _valor3 < 999998
		@ 020,010 say "2º "+_desc3
		@ 020,140 say  transform(_valor3,"999,999.99")
	endif
	
	if (_valor1 >= _valor2) .and. (_valor1 >= _valor3) .and. _valor1 < 999998
		@ 035,010 say "3º "+_desc1
		@ 035,140 say  transform(_valor1,"999,999.99")
	elseif (_valor2 >= _valor1) .and. (_valor2 >= _valor3)	  .and. _valor2 < 999998
		@ 035,010 say "3º "+_desc2
		@ 035,140 say  transform(_valor2,"999,999.99")
	elseif	(_valor3 >= _valor1) .and. (_valor3 >= _valor2)	.and. _valor3 < 999998
		@ 035,010 say "3º "+_desc3
		@ 035,140 say  transform(_valor3,"999,999.99")
	endif
	
	@ 065,010 bmpbutton type 1 action close(odlg)
	activate dialog odlg centered
endif
return

// GRAVACAO
static function _grava()
_lalttab:=.f.
if copcao=="INCLUIR"
	sze->(recLock("SZE",.t.))
else
	reclock("SZE",.f.)
endif
if copcao=="EXCLUIR"
	sze->(dbdelete())
	writesx2("SZE")
else
	_simula:= m->ze_simula
	sze->ze_filial :=_cfilsze
	sze->ze_simula :=m->ze_simula
	sze->ze_fornec :=m->ze_fornec
	sze->ze_lojafor :=m->ze_lojafor
	sze->ze_peso :=m->ze_peso
	sze->ze_volume:=m->ze_volume
	sze->ze_valornf :=m->ze_valornf
	sze->ze_transp1 :=m->ze_transp1
	sze->ze_transp2 :=m->ze_transp2
	sze->ze_transp3 :=m->ze_transp3
	sze->ze_valor1 :=m->ze_valor1
	sze->ze_valor2 :=m->ze_valor2
	sze->ze_valor3 :=m->ze_valor3
	if copcao=="INCLUIR"
		_simula()
		sze->ze_valor1 :=_valor1
		sze->ze_valor2 :=_valor2
		sze->ze_valor3 :=_valor3
		sze->ze_transp1 :=_transp1
		sze->ze_transp2 :=_transp2
		sze->ze_transp3 :=_transp3
		sze->ze_data:=date()
		confirmsx8()
	endif
endif
sze->(msunlock())

for _i:=1 to len(acols)
	if ! acols[_i,_npdel]
		if copcao=="INCLUIR"
			szf->(reclock("SZF",.t.))
		else
			if szf->(dbseek(_cfilszf+m->ze_simula+acols[_i,_npref]))
				szf->(reclock("SZF",.f.))
			elseif copcao=="ALTERAR"
				szf->(reclock("SZF",.t.))
			endif
		endif
		if copcao=="EXCLUIR"
			szf->(dbdelete())
			writesx2("SZF")
		else
			_cdocumen:=strzero(val(acols[_i,_npref]),3)
			szf->zf_filial :=_cfilszf
			szf->zf_simula    :=m->ze_simula
			szf->zf_documen   :=acols[_i,_npref]
			szc->(dbseek(_cfilszc+acols[_i,_npref]))
			szf->(msunlock())
		endif
	elseif copcao=="ALTERAR"
		if szf->(dbseek(_cfilszf+m->ze_simula+acols[_i,_npref]))
			szf->(reclock("SZF",.f.))
			szf->(dbdelete())
			writesx2("SZF")
		endif
	endif
next

return


static function _simula()
_cfilszb:=xfilial("SZB")
_cfilsa2:=xfilial("SA2")
szb->(dbsetorder(1))
sa2->(dbsetorder(1))

sa2->(dbseek(_cfilsa2+m->ze_fornec+ze_lojafor))

_valor1:=999999999
_valor2:=999999999
_valor3:=999999999
_transp1:="      "
_transp2:="      "
_transp3:="      "

szb->(dbgotop())

while ! szb->(eof())
	if  sa2->a2_local == szb->zb_local .and.;
		szb->zb_tipo=="E" .and.;
		sa2->a2_est == szb->zb_uf

		_apta:=.t.
		_porto:=.f.

		for _i:=1 to len(acols)
			szd->(dbseek(_cfilszd+szb->zb_transp+strzero(val(acols[_i,_npref]),3)))
			if strzero(val(acols[_i,_npref]),3)<> "000"
				if szb->zb_transp<>szd->zd_transp .and. strzero(val(acols[_i,_npref]),3) <> szd->zd_documen
					_apta:=.f.
				endif
				if strzero(val(acols[_i,_npref]),3)== "005"
					_porto:=.t.
				endif
			endif
		next

		if !_apta
			szb->(dbskip())
			loop
		endif

		_aliqicm:=0
		_vlrmin:=0
		_x:=0
		_z:=0

		if ((m->ze_peso < szb->zb_fretmax) .or. (szb->zb_fretmax=0)) .and. (szb->zb_tpcalc=="2")	// Cálculo sobre a Nota com peso menor que o Peso Máximo: Percentual
			_x:= (m->ze_valornf*szb->zb_advalor/100)

		elseif ((m->ze_peso > szb->zb_fretmax) .and. (szb->zb_tpcalc=="2")) .or.;   // Cálculo sobre a Nota com peso maior que Peso Máximo: Peso
			   (szb->zb_tpcalc=="1")   											// Cálculo sobre o Peso: Peso
			_x:= szb->zb_fretpes* m->ze_peso

		elseif szb->zb_tpcalc == "3"											// Cálculo sobre o Peso e a Nota (Ambos): Percentual + Peso
			_x:= (m->ze_valornf*szb->zb_advalor/100)
			_x:=_x+ szb->zb_fretpes* m->ze_peso
		endif

		_qtdped:=int(m->ze_peso/100)
		if (m->ze_peso/100)-_qtdped > 0
			_qtdped+=1
		endif

		_z:= _x		 							// Total do frete
	
		_aliqicm:= (100-szb->zb_aliqicm)/100 	// Alíquota do ICMS

		_peso:=.f.	  
		_x:= _z/m->ze_peso
		if _x < szb->zb_vlrmin					// Verifica se o Valor por Peso é menor que o Peso Mínimo	
			_z:= szb->zb_vlrmin*m->ze_peso
			_peso:=.t.
		endif
	
		if _z < szb->zb_fretmin 				// Verifica se o Valor do Frete é menor que o Preço Mínimo
			_z:= szb->zb_fretmin
			_peso:=.f.
		endif
	
		if !_peso
			if m->ze_valornf*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (m->ze_valornf*szb->zb_gris/100)
			endif
			_z:=_z + _gris

			_z:= _z + szb->zb_txdocto							// Aplica a cobrança da Taxa do Documento		
		endif
		
		_z:= _z + szb->zb_txporto + (szb->zb_pedagio*_qtdped)	// Aplica Cobrança de Pedágio 

		_z:=_z/_aliqicm										// Aplica alíquota do ICMS

/*
		if szb->zb_fretmax > m->ze_peso .or. empty(szb->zb_fretmax)
			_x:= (m->ze_valornf*szb->zb_advalor/100)
        	
			//verifica se o valor simulado é menor que o valor mínimo pago por Kg
			_vlrmin:=(m->ze_peso*szb->zb_vlrmin)
			if _x < _vlrmin   //se verdadeiro, será cobrado o valor mínimo por kg
				_x:= _vlrmin
			endif
        	
			if m->ze_valornf*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= m->ze_valornf*szb->zb_gris/100
			endif
			
			_x:=_x + _gris
			if  empty(szb->zb_fretmax)
				_y:= szb->zb_fretpes* m->ze_peso
			else
				_y:=0
			endif
		elseif  szb->zb_tpcalc == "1"
			_x:= szb->zb_fretpes* m->ze_peso
			if m->ze_valornf*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (m->ze_valornf*szb->zb_gris/100)
			endif
			_x:=_x + _gris
			_y:=0
		elseif szb->zb_tpcalc == "3"
			if szb->zb_transp == '317847'
				_x:= szb->zb_fretpes* m->ze_peso
				_y:=0
			else
				_x:= (m->ze_valornf*szb->zb_advalor/100)
				_x:=_x+ szb->zb_fretpes* m->ze_peso
    	
				//verifica se o valor simulado é menor que o valor mínimo pago por Kg
				_vlrmin:=(m->ze_peso*szb->zb_vlrmin)
				if _x < _vlrmin   //se verdadeiro, será cobrado o valor mínimo por kg
					_x:= _vlrmin
				endif
    	
				if m->ze_valornf*szb->zb_gris/100 < szb->zb_grismin
					_gris:=szb->zb_grismin
				else
					_gris:= (m->ze_valornf*szb->zb_gris/100)
				endif
				_x:=_x +_gris
			endif
		elseif szb->zb_tpcalc == "2"
			_x:= (m->ze_valornf*szb->zb_advalor/100)
        	
			//verifica se o valor simulado é menor que o valor mínimo pago por Kg
			_vlrmin:=(m->ze_peso*szb->zb_vlrmin)
			if _x < _vlrmin   //se verdadeiro, será cobrado o valor mínimo por kg
				_x:= _vlrmin
			endif
        	
			if m->ze_valornf*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (m->ze_valornf*szb->zb_gris/100)
			endif
			_x:=_x + _gris
			
		endif
	
		_qtdped:=int(m->ze_peso/100)
		if (m->ze_peso/100)-_qtdped > 0
			_qtdped+=1
		endif
		_z:= _x+ _y+szb->zb_txdocto //+(szb->zb_pedagio*_qtdped)
		_aliqicm:= (100-szb->zb_aliqicm)/100
		if _z < szb->zb_fretmin
			_z:= szb->zb_fretmin
		endif
		_z:=_z/_aliqicm
		_z:=_z+szb->zb_txporto +(szb->zb_pedagio*_qtdped)
		
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
		//  msgstop(transform(_valor1,"999,999.99") + "  "+ transform(_valor2,"999,999.99")+"  "+transform(_valor3,"999,999.99") )
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
return


user function VIT191E()
_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
sa1->(dbsetorder(1))
sa2->(dbsetorder(1))

_fornec:= space(06)
_loja:= "  "
_tpeso:=0
_volume:=0
_tnota:=0
_doc1:= space(03)
_doc2:= space(03)
_doc3:= space(03)

@ 000,000 to 280,450 dialog odlg title "Informe os dados da simulação"
@ 005,005 say "Fornecedor"
@ 005,045 get _fornec picture "@!"  f3 "FOR"
@ 020,005 say "Loja"
@ 020,045 get _loja
@ 035,005 say "Peso"
@ 035,045 get _tpeso picture  "@E 999,999.99"
@ 050,005 say "Volume"
@ 050,045 get _volume  picture "@E 999,999.99"
@ 065,005 say "Valor NF"
@ 065,045 get _tnota picture "@E 999,999.99"
@ 080,005 say "Documentos"
@ 080,045 get _doc1 picture "@!"  f3 "SZC"
@ 080,075 get _doc2 picture "@!"  f3 "SZC"  when !empty(_doc1)
@ 080,105 get _doc3 picture "@!"  f3 "SZC" when !empty(_doc2)

@ 125,020 bmpbutton type 1 action vit191F()
@ 125,055 bmpbutton type 2 action close(odlg)

activate dialog odlg centered
return




Static Function vit191f()

_cfilsa2:=xfilial("SA2")
_cfilsa4:=xfilial("SA4")
_cfilszb:=xfilial("SZB")
_cfilszd:=xfilial("SZD")
szb->(dbsetorder(1))
szd->(dbsetorder(1))
sa2->(dbsetorder(1))
sa2->(dbsetorder(1))
sa4->(dbsetorder(1))

sa2->(dbseek(_cfilsa2+_fornec+_loja))

_data:=date()
_cnomecli:=sa2->a2_nome
_uf:= sa2->a2_est
_local:=sa2->a2_local
_valor1:=999999999
_valor2:=999999999
_valor3:=999999999
_transp1:="      "
_transp2:="      "
_transp3:="      "

szb->(dbgotop())

while ! szb->(eof())
	if  sa2->a2_local == szb->zb_local .and.;
		szb->zb_tipo=="E" .and.;
		sa2->a2_est == szb->zb_uf

		_apta:=.t.
		_porto:=.f.

		szd->(dbseek(_cfilszd+szb->zb_transp+_doc1))
		if szb->zb_transp<>szd->zd_transp .and. _doc1 <> szd->zd_documen
			_apta:=.f.
		endif
		if _doc1== "005"
			_porto:=.t.
		endif
	
		szd->(dbseek(_cfilszd+szb->zb_transp+_doc2))
		if szb->zb_transp<>szd->zd_transp .and. _doc2 <> szd->zd_documen
			_apta:=.f.
		endif

		if _doc2== "005"
			_porto:=.t.
		endif
	
		szd->(dbseek(_cfilszd+szb->zb_transp+_doc3))
		if szb->zb_transp<>szd->zd_transp .and. _doc3 <> szd->zd_documen
			_apta:=.f.
		endif

		if _doc3== "005"
			_porto:=.t.
		endif

		if !_apta
			szb->(dbskip())
			loop
		endif
		_aliqicm:=0


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

		_z:=_z/_aliqicm										// Aplica alíquota do ICMS

/*	
		if szb->zb_fretmax > _tpeso .or. empty(szb->zb_fretmax)
			_x:= (_tnota*szb->zb_advalor/100)

			//verifica se o valor simulado é menor que o valor mínimo pago por Kg
			_vlrmin:=(_tpeso*szb->zb_vlrmin)
			if _x < _vlrmin   //se verdadeiro, será cobrado o valor mínimo por kg
				_x:= _vlrmin
			endif
    	
			if m->_tnota*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (_tnota*szb->zb_gris/100)
			endif
			
			_x:=_x + _gris
			if  empty(szb->zb_fretmax)
				_y:= szb->zb_fretpes* _tpeso
			else
				_y:=0
			endif
		elseif  szb->zb_tpcalc == "1"
			_x:= szb->zb_fretpes* _tpeso
			if m->_tnota*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (_tnota*szb->zb_gris/100)
			endif
			_x:=_x + _gris
			_y:=0
		elseif szb->zb_tpcalc == "3"
			_x:= (_tnota*szb->zb_advalor/100)
			_x:=_x+ szb->zb_fretpes* _tpeso
	
			//verifica se o valor simulado é menor que o valor mínimo pago por Kg
			_vlrmin:=(_tpeso*szb->zb_vlrmin)
			if _x < _vlrmin   //se verdadeiro, será cobrado o valor mínimo por kg
				_x:= _vlrmin
			endif
    	
			if m->_tnota*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (_tnota*szb->zb_gris/100)
			endif
			
			_x:=_x + _gris
			_y:=0
		elseif szb->zb_tpcalc == "2"
			_x:= (_tnota*szb->zb_advalor/100)

			//verifica se o valor simulado é menor que o valor mínimo pago por Kg
			_vlrmin:=(_tpeso*szb->zb_vlrmin)
			if _x < _vlrmin   //se verdadeiro, será cobrado o valor mínimo por kg
				_x:= _vlrmin
			endif
	
			if m->_tnota*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (_tnota*szb->zb_gris/100)
			endif
			
			_x:=_x + _gris
			_y:=0
		endif
	
	
		_qtdped:=int(_tpeso/100)
		if (_tpeso/100)-_qtdped > 0
			_qtdped+=1
		endif
		_z:= _x+ _y+szb->zb_txdocto //+(szb->zb_pedagio*_qtdped)
		_aliqicm:= (100-szb->zb_aliqicm)/100
		if _z < szb->zb_fretmin
			_z:= szb->zb_fretmin
		endif
		_z:=_z/_aliqicm
		_z:=_z+szb->zb_txporto +(szb->zb_pedagio*_qtdped)  
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
_fornec:= space(06)
_loja:= "  "
_tpeso:=0
_volume:=0
_tnota:=0
return
