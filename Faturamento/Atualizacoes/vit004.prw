#Include 'Protheus.ch'
#Include 'Totvs.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/{Protheus.doc} vit004
	Alteracao de Peso e Volume das Notas Fiscais de Saida
@author Heraildo C. de Freitas
@since 17/01/02
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function vit004() 
Private cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
Private _ctransp
ccadastro:="Aponta peso / volume"
arotina  :={}
aadd(arotina,{"Pesquisar","AXPESQUI"   ,0,1})
aadd(arotina,{"Atualizar","U_VIT004A()",0,2})
sf2->(dbsetorder(1))
sf2->(dbgotop())
mbrowse(6,1,22,75,"SF2",,"F2_IMPRES")
return

user function vit004a()
simula()
if sf2->f2_impres=="S" .and. !empty(sf2->f2_dtentrg) .and. !(cCodUser) $ ("000729/000020") //000445 ricardo
	msginfo("Nota fiscal ja impressa!")
else
	_cfilsa1:=xfilial("SA1")
	_cfilsa2:=xfilial("SA2")
	_cfilsa4:=xfilial("SA4")
	_cfilsc5:=xfilial("SC5")
	_cfilsd2:=xfilial("SD2")
	_cfilsb1:=xfilial("SB1")
	_cfilszb:=xfilial("SZB")
	sa1->(dbsetorder(1))
	sa2->(dbsetorder(1))
	sa4->(dbsetorder(1))
	sc5->(dbsetorder(1))
	sd2->(dbsetorder(3))
	sb1->(dbsetorder(1))
	
	if sf2->f2_tipo$"BD"
		sa2->(dbseek(_cfilsa2+sf2->f2_cliente+sf2->f2_loja))
		_cnomecli:=sa2->a2_nome
	else
		sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
		_cnomecli:=sa1->a1_nome
	endif
	
	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
	sa4->(dbseek(_cfilsa4+sf2->f2_transp))
	_mant := ""
	_j :=0
	
	_ctransp :=sf2->f2_transp
	_npesob  :=sf2->f2_pbruto
	_npesol  :=sf2->f2_pliqui
	_nvolume :=sf2->f2_volume1
	_cdoc    :=sf2->f2_doc
	_cserie  :=sf2->f2_serie
	_ccliente:=sf2->f2_cliente
	_cloja   :=sf2->f2_loja
	_pedido  :=sd2->d2_pedido
	_cidade  :=alltrim(sa1->a1_mun)
	_uf      :=sa1->a1_est
	_dtemb	 :=sf2->f2_dataemb
	_hremb	 :=sf2->f2_horaemb  
	_dtentr  :=sf2->f2_dtentrg //Data de entrega 
   	_entcid  :=sf2->f2_dtentcd //Data de entrega Cidade
	_ctranop :=sf2->f2_tranopc //Transp opcional 
	_obs     :=sf2->f2_obstran //Obs Apontamento da Transportadora	
	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
	_nregsd2:=sd2->(recno())
	
	while ! sd2->(eof()) .and.;
		sd2->d2_doc==sf2->f2_doc
		sb1->(dbseek(_cfilsb1+sd2->d2_cod))
		_mtp = left(sb1->b1_categ,1)
		if _mtp <> _mant
			_mant = _mtp
			if _j >0
				MSGSTOP("Categoria diferentes em mesma nota ")
			endif
		endif
		_j++
		sd2->(dbskip())
	end
	
	sd2->(dbgoto(_nregsd2))
	
	sa4->(dbseek(_cfilsa4+sf2->f2_transp))
	
	_ctransp :=sf2->f2_transp
	_npesob  :=sf2->f2_pbruto
	_npesol  :=sf2->f2_pliqui
	_nvolume :=sf2->f2_volume1
	_cdoc    :=sf2->f2_doc
	_cserie  :=sf2->f2_serie
	_ccliente:=sf2->f2_cliente
	_cloja   :=sf2->f2_loja
	_pedido  :=sd2->d2_pedido
	_cidade  :=alltrim(sa1->a1_mun)
	_uf      :=sa1->a1_est 
	_dtentr  :=sf2->f2_dtentrg //Data de entrega 
   	_entcid  :=sf2->f2_dtentcd //Data de entrega Cidade
	_ctranop :=sf2->f2_tranopc //Transp opcional
	_obs     :=sf2->f2_obstran //Obs Apontamento da Transportadora
	if empty(sf2->f2_dataemb)
		_dtemb	 := ddatabase
		_hremb	 :="18:30"
		_libtran :="S"
	else 
		_dtemb	 :=sf2->f2_dataemb
		_hremb	 :=sf2->f2_horaemb
		_libtran :=sf2->f2_libtran
	endif
	
	@ 000,000 to 450,450 dialog odlg title "Informe dados da nota fiscal"
	@ 005,005 say "Nota Fiscal"
	@ 005,045 say _cdoc
	@ 015,005 say "Serie"
	@ 015,045 say _cserie
	@ 025,005 say "Pedido"
	@ 025,045 say _pedido
	@ 035,005 say "Categoria: "
	@ 035,045 say if(_mtp=="I","Positiva","Negativa")
	@ 045,005 say "Cliente"
	@ 045,045 say _ccliente+"/"+_cloja+"-"+_cnomecli
	@ 055,005 say "Cidade/UF"
	@ 055,045 say _cidade+" / "+_uf
	@ 070,005 say "Transportadora"
	@ 070,045 get _ctransp picture "@!" size 35,9 valid _vtransp() f3 "SA4"
	@ 080,005 say "Peso bruto"
	@ 080,045 get _npesob  picture "@E 999,999.99" size 35,9 valid _vtranop() 
	@ 090,005 say "Peso liquido"
	@ 090,045 get _npesol  picture "@E 999,999.99" size 35,9 valid _vtranop() 
	@ 100,005 say "Volumes"
	@ 100,045 get _nvolume picture "@E 999,999" size 20,9 valid _vtranop() 

	@ 110,005 say "Dt.Embarque"
	@ 110,045 get _dtemb size 45,9 valid _vtranop() 
	@ 120,005 say "Hr.Embarque"
	@ 120,045 get _hremb picture "99:99" size 20,9  valid _vtranop() 

	@ 130,005 say "Apontamento Liberado ?"
	@ 130,065 get _libtran picture "@!" valid _vtranop() 
	                             
	@ 140,005 say "TranspOpcional"
	@ 140,045 get _ctranop picture "@!" size 35,9 valid _vtransp() f3 "SA4"  
	
	@ 150,005 say "Dt.Entregou"
	@ 150,045 get _dtentr size 45,9 
	
	@ 160,005 say "Cheg Cidade"
	@ 160,045 get _entcid size 45,9 
	
	@ 170,005 say "Obs. "
	@ 170,045 get _obs picture "@!" size 60,9	
	
	@ 185,020 bmpbutton type 1 action _grava()
	@ 185,055 bmpbutton type 2 action close(odlg)
	
	activate dialog odlg centered
endif
return

static function _grava()

sa4->(dbseek(_cfilsa4+_ctransp))

if sa4->a4_tpfrete<>'C' 

	sf2->(reclock("SF2",.f.))
	sf2->f2_transp :=_ctransp
	sf2->f2_pbruto :=_npesob
	sf2->f2_pesfret:=_npesob
	sf2->f2_pliqui :=_npesol
	sf2->f2_volume1:=_nvolume
	sf2->f2_libtran:=_libtran
	sf2->f2_dataemb:=_dtemb
	sf2->f2_horaemb:=_hremb 
	sf2->f2_dtentrg	:=  _dtentr   //Data de entrega 
	sf2->f2_dtentcd := 	_entcid  //Data de entrega Cidade
	sf2->f2_tranopc :=	_ctranop //Transp opcional 
    sf2->f2_obstran :=	_obs     //Obs Apontamento da Transportadora

	msunlock() 
	//GRAVA OS DADOS NA SF8 DE NOTAS QUE SÃO DE TRANSPORTE PROPRIO
	If _ctransp $ "000123/000124"	
	   DbSelectArea("SF8")
       DbSetOrder(5) //F8_FILIAL+F8_TIPONF+F8_NFORIG+F8_SERORIG (INDICE 5 )
	   If !DbSeek(xFilial("SF8")+"S"+_cdoc)
     	  RECLOCK("SF8",.T.)
	   		 SF8->F8_FILIAL  	:= xFilial("SF8")
			 SF8->F8_NFDIFRE    := _cdoc //cNumCte
			 SF8->F8_SEDIFRE   	:= _cserie //cSerieCte 
	   		 SF8->F8_DTDIGIT  	:= dDatabase
	   		 SF8->F8_TRANSP  	:= _ctransp  //TRANSPORTADOR
			 SF8->F8_LOJTRAN    := "01" //cLojaFor	 
	   		 SF8->F8_NFORIG  	:= _cdoc 	
	   		 SF8->F8_SERORIG    := _cserie
       		 SF8->F8_FORNECE  	:= _ccliente
			 SF8->F8_LOJA		:= _cloja 
			 SF8->F8_DTPREV  	:= dDatabase 
   			 SF8->F8_TPFRETE  	:= "FP" //Frete Proprio
			 SF8->F8_TIPONF  	:= "S"
   		  MSUNLOCK() 
	   EndIf
	EndIf   
    ///GRAVA OS DADOS NA SF8 DE NOTAS QUE SÃO DE TRANSPORTE PROPRIO
		
	_apedido:={}
	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
	while ! sd2->(eof()) .and.;
		sd2->d2_doc==sf2->f2_doc
		if sd2->d2_serie==sf2->f2_serie .and.;
			sd2->d2_cliente==sf2->f2_cliente .and.;
			sd2->d2_loja==sf2->f2_loja
			_i:=ascan(_apedido,sd2->d2_pedido)
			if _i==0
				aadd(_apedido,sd2->d2_pedido)
				sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
				sc5->(reclock("SC5",.f.))
				sc5->c5_transp:=_ctransp
				sc5->(msunlock())
			endif
		endif
		sd2->(dbskip())
	end
	close(odlg)
else 
	msgstop("Informado Codigo de Transportadora de Frete sobre Compras!")
endif
return

Static Function Simula()

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
_cliente:=sf2->f2_cliente
_loja:=sf2->f2_loja
_data:=sf2->f2_emissao   

if sf2->f2_tipo$"BD"
	sa2->(dbseek(_cfilsa2+sf2->f2_cliente+sf2->f2_loja))
	_cnomecli:=sa2->a2_nome
	_uf:= sa2->a2_est
	_local:=sa2->a2_local
	_suframa:= " "
else
	sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
	_cnomecli:=sa1->a1_nome
	_uf:= sa1->a1_est
	_local:=sa1->a1_local
	_suframa:= sa1->a1_suframa
endif

sf2->(dbsetorder(2))
sf2->(dbseek(_cfilsf2+sf2->f2_cliente+sf2->f2_loja))
_tnota:=0
_tpeso:=0
_notas:=""
while ! sf2->(eof())  .and. _cliente== sf2->f2_cliente .and. _loja == sf2->f2_loja
	if  sf2->f2_emissao <> _data
		sf2->(dbskip())
		loop
	endif
	_notas+=" "+sf2->f2_doc
	_tnota+=sf2->f2_valbrut
	_tpeso+=sf2->f2_pbruto
//	_tpeso+=sf2->f2_pesfret
	sf2->(dbskip())
end

sf2->(dbsetorder(1))
go _nregsf2

sa4->(dbseek(_cfilsa4+sf2->f2_transp))
_valor1:=999999999
_valor2:=999999999
_valor3:=999999999
_transp1:="      "
_transp2:="      "
_transp3:="      "
_pzentre1:=0
_pzentre2:=0
_pzentre3:=0

szb->(dbgotop())
while ! szb->(eof())
	if  _local == szb->zb_local .and.;
		szb->zb_tipo=="S" .and.;
		_uf == szb->zb_uf

		_apta:=.t.
		_porto:=.f.
		_vlrmin:=0
		_aliqicm:=0

		_txsuframa:=0
		if !empty(_suframa) .or. _uf=="AM"
			_txsuframa:= szb->zb_suframa
		endif
        
		if ((_tpeso < szb->zb_fretmax) .or. (szb->zb_fretmax=0)) .and. (szb->zb_tpcalc=="2")	// CÃ¡lculo sobre a Nota com peso menor que o Peso MÃ¡ximo: Percentual
			_x:= (_tnota*szb->zb_advalor/100)

		elseif ((_tpeso > szb->zb_fretmax) .and. (szb->zb_tpcalc=="2")) .or.;   // CÃ¡lculo sobre a Nota com peso maior que Peso MÃ¡ximo: Peso
			   (szb->zb_tpcalc=="1")   											// CÃ¡lculo sobre o Peso: Peso
			_x:= szb->zb_fretpes* _tpeso

		elseif szb->zb_tpcalc == "3"											// CÃ¡lculo sobre o Peso e a Nota (Ambos): Percentual + Peso
			_x:= (_tnota*szb->zb_advalor/100)
			_x:=_x+ szb->zb_fretpes* _tpeso
		endif

		_qtdped:=int(_tpeso/100)
		if (_tpeso/100)-_qtdped > 0
			_qtdped+=1
		endif

		_z:= _x		 							// Total do frete
	
		_aliqicm:= (100-szb->zb_aliqicm)/100 	// AlÃ­quota do ICMS

		_peso:=.f.	  
		_x:= _z/_tpeso 		  
		if _x < szb->zb_vlrmin					// Verifica se o Valor por Peso Ã© menor que o Peso MÃ­nimo	
			_z:= szb->zb_vlrmin*_tpeso
			_peso:=.t.
		endif
	
		if _z < szb->zb_fretmin 				// Verifica se o Valor do Frete Ã© menor que o PreÃ§o MÃ­nimo
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

			_z:= _z + szb->zb_txdocto							// Aplica a cobranÃ§a da Taxa do Documento		
		endif
		
		_z:= _z + szb->zb_txporto + (szb->zb_pedagio*_qtdped)	// Aplica CobranÃ§a de PedÃ¡gio 

		_z:= _z + _txsuframa							   		// Aplica a cobranÃ§a da Taxa do Suframa
	
		_z:=_z/_aliqicm											// Aplica alÃ­quota do ICMS


		if _z < _valor1 .and. (_valor1 >=_valor2) .and. (_valor1 >=_valor3)
			_valor1:= _z
			_transp1:= szb->zb_transp
			_pzentre1:= szb->zb_pzentre
		elseif _z <	_valor2 .and. (_valor2 >=_valor3)
			_valor2:= _z
			_transp2:= szb->zb_transp
			_pzentre2:= szb->zb_pzentre
		elseif _z < _valor3
			_valor3:=_z
			_transp3:= szb->zb_transp
			_pzentre3:= szb->zb_pzentre
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

///  VisualizaÃ§Ã£o das transportadoras

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
	@ 000,000 to 320,470 dialog odlg title "Transportadoras Selecionadas"
	@ 005,010 say "NOTAS : " +_notas
	@ 015,010 say "VALOR TOTAL DAS NOTAS..: "+transform(_tnota,"@E 999,999.99")
	@ 025,010 say "PESO TOTAL DOS PRODUTOS: "+transform(_tpeso,"@E 999,999.99")
	
	if (_valor1 <= _valor2) .and. (_valor1 <= _valor3)  .and. _valor1 < 999998
		@ 050,010 say "1º "+_desc1
		@ 050,140 say  transform(_valor1,"999,999.99")
		@ 050,170 say  "PZ.ENTR.:"
		@ 050,197 say transform(_pzentre1,"999")
		@ 050,205 say  "D"
		@ 050,215 say transform((_valor1/_tnota)*100,"999.99%")
	elseif (_valor2 <= _valor1) .and. (_valor2 <= _valor3)	.and.  _valor2 < 999998
		@ 050,010 say "1º "+_desc2
		@ 050,140 say  transform(_valor2,"999,999.99")
		@ 050,170 say  "PZ.ENTR.:"
		@ 050,197 say transform(_pzentre2,"999")
		@ 050,205 say  "D"
		@ 050,215 say transform((_valor2/_tnota)*100,"999.99%")
	elseif	(_valor3 <= _valor2) .and. (_valor3 <= _valor1)	.and.  _valor3 < 999998
		@ 050,010 say "1º "+_desc3
		@ 050,140 say  transform(_valor3,"999,999.99")
		@ 050,170 say  "PZ.ENTR.:"
		@ 050,197 say transform(_pzentre3,"999")
		@ 050,205 say  "D"
		@ 050,215 say transform((_valor3/_tnota)*100,"999.99%")
	endif
	
	if ((_valor1 >= _valor2) .and. (_valor1 <= _valor3)) .or.  ((_valor1 <= _valor2) .and. (_valor1 >= _valor3))  .and. _valor1 < 999998
		@ 060,010 say "2º "+_desc1
		@ 060,140 say  transform(_valor1,"999,999.99")
		@ 060,170 say  "PZ.ENTR.:"
		@ 060,197 say transform(_pzentre1,"999")
		@ 060,205 say  "D"
		@ 060,215 say transform((_valor1/_tnota)*100,"999.99%")
	elseif ((_valor2 >= _valor1) .and. (_valor2 <= _valor3)) .or.  ((_valor2 >= _valor3) .and. (_valor2 <= _valor1))   .and. _valor2 < 999998
		@ 060,010 say "2º "+_desc2
		@ 060,140 say  transform(_valor2,"999,999.99")
		@ 060,170 say  "PZ.ENTR.:"
		@ 060,197 say transform(_pzentre2,"999")
		@ 060,205 say  "D"
		@ 060,215 say transform((_valor2/_tnota)*100,"999.99%")
	elseif ((_valor3 >= _valor1) .and. (_valor3 <= _valor2)) .or.  ((_valor3 <= _valor1) .and. (_valor3 >= _valor2))  .and. _valor3 < 999998
		@ 060,010 say "2º "+_desc3
		@ 060,140 say  transform(_valor3,"999,999.99")
		@ 060,170 say  "PZ.ENTR.:"
		@ 060,197 say transform(_pzentre3,"999")
		@ 060,205 say  "D"
		@ 060,215 say transform((_valor3/_tnota)*100,"999.99%")
	endif
	
	
	if (_valor1 >= _valor2) .and. (_valor1 >= _valor3) .and. _valor1 < 999998
		@ 070,010 say "3º "+_desc1
		@ 070,140 say  transform(_valor1,"999,999.99")
		@ 070,170 say  "PZ.ENTR.:"
		@ 070,197 say transform(_pzentre1,"999")
		@ 070,205 say  "D"
		@ 070,215 say transform((_valor1/_tnota)*100,"999.99%")
	elseif (_valor2 >= _valor1) .and. (_valor2 >= _valor3)	  .and. _valor2 < 999998
		@ 070,010 say "3º "+_desc2
		@ 070,140 say  transform(_valor2,"999,999.99")
		@ 070,170 say  "PZ.ENTR.:"
		@ 070,197 say transform(_pzentre2,"999")
		@ 070,205 say  "D"
		@ 070,215 say transform((_valor2/_tnota)*100,"999.99%")
	elseif	(_valor3 >= _valor1) .and. (_valor3 >= _valor2)	.and. _valor3 < 999998
		@ 070,010 say "3º "+_desc3
		@ 070,140 say  transform(_valor3,"999,999.99")
		@ 070,170 say  "PZ.ENTR.:"
		@ 070,197 say transform(_pzentre3,"999")
		@ 070,205 say  "D"
		@ 070,215 say transform((_valor3/_tnota)*100,"999.99%")
	endif
	
	@ 095,010 bmpbutton type 1 action close(odlg)
	activate dialog odlg centered
	
endif
return

static function _vtransp()
_lok:=.f.
//sf2->(dbsetorder(3))
(DbSelectArea("SZB"))
SZB->(DbSetOrder(3))
if szb->(dbseek(space(2)+_ctransp+"S"+_uf))
	if existcpo("SA4",_ctransp) .and. VldCertificado()
		_lok:=.t.
		sa4->(dbseek(_cfilsa4+_ctransp)) 
		@ 070,085 say sa4->a4_nome
		//odlg:refresh()
	endif
else
	if msgbox("Esta transportadora n�o atende este estado, CONFIRMA?","Aten��o","YESNO")
		if existcpo("SA4",_ctransp) .and. VldCertificado()
			_lok:=.t.
			sa4->(dbseek(_cfilsa4+_ctransp))
			@ 070,085 say sa4->a4_nome
			//odlg:refresh()
		endif
	endif
endif
return(_lok)    

Static Function VldCertificados()

Local Certi1
Local Datcer1
Local Datcer2
Local Datcer3
Local Datcer4
Local Datcer5
	//If ! SB1->B1_TIPO $ SA4->A4_XTPPRDS
	//	msgStop("Para esse tipo de produto n�o � necess�rio informar um Transportador Certificado!!!")
	//	Return(.f.)
	Certi1:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XCERT1")
	Datcer1:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER1")
	Datcer2:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER2")
	Datcer3:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER3")
	Datcer4:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER4")
	Datcer5:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER5")
	If empty(Certi1)
	   	msgStop("Informe o 1o. certificado no cadastro da Transportadora!!!")
		Return(.f.)
	ElseIf Datcer1 < dDataBase
		   	msgStop("1o. Certificado da Transportadora est� vencido!!!")
			Return(.f.)
	ElseIf !empty(Datcer2) .and. Datcer2 < dDataBase
		   	msgStop("2o. Certificado da Transportadora est� vencido!!!")
			Return(.f.)
	ElseIf !empty(Datcer3) .and. Datcer3 < dDataBase
		   	msgStop("3o. Certificado da Transportadora est� vencido!!!")
			Return(.f.)
	ElseIf !empty(Datcer4) .and. Datcer4 < dDataBase
		   	msgStop("4o. Certificado da Transportadora est� vencido!!!")
			Return(.f.)
	ElseIf !empty(Datcer5) .and. Datcer5 < dDataBase
		   	msgStop("5o. Certificado da Transportadora est� vencido!!!")
			Return(.f.)
	EndIf

Return(.t.)

//Valida  a transportadora opcional 
//Ricardo Moreira 31/10/2016

static function _vtranop()
Local _lret:=.t.                

//         000729 Julio Bustamante
//         000020 Luciana Yoko
//         000445  Ricardo 
IF(sf2->f2_impres=="S") .and. !empty(sf2->f2_dtentrg) .and. !(cCodUser) $ ("000729/000020/000445") 
 _lret:=.f.
EndIf
return(_lret)