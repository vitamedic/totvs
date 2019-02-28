/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT057   ³ Autor ³ Gardenia Ilany F. Vale³ Data ³ 22/04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Amarracao do Conhecimento de Frete a Nota Fiscal de Saida  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "protheus.ch"
#include "rwmake.ch"

user function VIT057()
ccadastro:="Atualiza frete"
cstring  :="SF2"
arotina  :={{"Pesquisar" ,"axpesqui"                    ,0,1},;
				{"Visualizar","axvisual"                    ,0,2},;
				{"Atualizar" ,'execblock("VIT057A",.f.,.f.)',0,3}}
dbselectarea("SF2")
dbsetorder(1)
mbrowse(6,1,22,75,cstring,,"F2_NUMFRET")
return

user function VIT057a()

Local oCombo, aItems:= {"FM=Frete Minimo","FP=Frete Peso","FC=Frete Cubagem","FF=Frete Fluvial","FQ=Frete Percentual","OU=Outros"}

_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
_cfilsa4:=xfilial("SA4")
_cfilsc5:=xfilial("SC5")
_cfilsd2:=xfilial("SD2")
_cfilszb:=xfilial("SZB")
szb->(dbsetorder(1))
sa1->(dbsetorder(1))
sa2->(dbsetorder(1))
sa4->(dbsetorder(1))
sc5->(dbsetorder(1))
sd2->(dbsetorder(3))
sa4->(dbseek(_cfilsa4+sf2->f2_transp))
//if empty(sa4->a4_fornece) .or. empty(sa4->a4_loja)
_mpode :=.f.

_ctpfrete:=sf2->f2_tipfret

if _ctpfrete="FM"
	cCombo:= "FM"
elseif _ctpfrete="FP"
	cCombo:= "FP"
elseif _ctpfrete="FC"
	cCombo:= "FC"
elseif _ctpfrete="FF"
	cCombo:= "FF"
elseif _ctpfrete="FQ"
	cCombo:= "FQ"
else
	cCombo:= "OU"
endif

if _mpode
	msginfo("Nao existe codigo de fornecedor cadastrado na transportadora!")
else
	if empty(sf2->f2_numfret)
		_cserfret:=space(3)
		_cnumfret:=space(6)
  		_cnumpasse:=space(11)
//      _ddtentg:=ctod("  /  /  ") //retirar esta linha
  		
//		Incluir este teste para não perder a data já incluída.

		if empty(sf2->f2_dtentrg)
			_ddtentg:=ctod("  /  /  ")
		else
			_ddtentg:=sf2->f2_dtentrg   
		endif

		if empty(sf2->f2_dtentcd)
			_ddtentc:=ctod("  /  /  ")
		else
			_ddtentc:=sf2->f2_dtentcd   
		endif
	else
		_cserfret:=sf2->f2_serfret
		_cnumfret:=sf2->f2_numfret
		_ddtentg:=sf2->f2_dtentrg
		_ddtentc:=sf2->f2_dtentcd 
		_cnumpasse:=sf2->f2_passe		
	endif
	if sf2->f2_tipo$"BD"
		sa2->(dbseek(_cfilsa2+sf2->f2_cliente+sf2->f2_loja))
		_cnomecli:=sa2->a2_nome
	else
		sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
		_cnomecli:=sa1->a1_nome
	endif
	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
	sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
	sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
	_local:=sa1->a1_local
	_uf:=sa1->a1_est

	sa4->(dbseek(_cfilsa4+sf2->f2_transp))
	_cgctransp:=sa4->a4_cgc
	sa2->(dbsetorder(3))
	sa2->(dbseek(_cfilsa2+_cgctransp))
	_codtransp:=sa2->a2_cod
	_cnota   :=sf2->f2_doc
	_cserie  :=sf2->f2_serie
	_cpedido :=sd2->d2_pedido
	_ccliente:=sf2->f2_cliente
	_cloja   :=sf2->f2_loja
	_ctransp :=sf2->f2_transp
	_cnometra:=sa4->a4_nome
	_ctpfrete:=if(sc5->c5_tpfrete=="F","FOB","CIF")
	_nfrete  :=sc5->c5_frete
	_fatura :=sf2->f2_fatura
	_valfrete:=sf2->f2_vlfrete
	_descfr:=sf2->f2_descfr
	_avaria:=sf2->f2_avaria
	_obsfr:= sf2->f2_obsfr
	_descpg:=sf2->f2_descpg
	_icmsfr:=sf2->f2_icmsfr
	_pesfret:=sf2->f2_pesfret

	szb->(dbseek(_cfilszb+_codtransp+_uf+"S"+_local))
   _aliqicm:=0
   _x:= (sf2->f2_valbrut*szb->zb_advalor/100)
   _x:=_x + (sf2->f2_valbrut*szb->zb_gris/100)
   _y:= szb->zb_fretpes* sf2->f2_pbruto
   _qtdped:=int(sf2->f2_pbruto/100) 	
   if _qtdped <1
   	_qtdped:=1
   endif	
   _z:= _x+_y+ szb->zb_txdocto // +(szb->zb_pedagio*_qtdped)
   _aliqicm:= (100-szb->zb_aliqicm)/100
   if _z < szb->zb_fretmin
  	  _z:= szb->zb_fretmin
   endif	    
   _z:=_z/_aliqicm
   _z:=_z+szb->zb_txporto +(szb->zb_pedagio*_qtdped)

//	_cfretepr:=if(sc5->c5_fretepr=="P","PAGO","REEMBOLSADO")
	@ 000,000 to 520,540 dialog odlg title "Amarracao NF saida X frete"
	@ 005,010 say "Nota fiscal"
	@ 005,075 get _cnota    size 30,8 when .f.
	@ 005,110 get _cserie   size 15,8 when .f.
	@ 020,010 say "Pedido"
	@ 020,075 get _cpedido  size 30,8 when .f.
	if substr(sd2->d2_cod,1,6)=="666666"
		@ 020,110 say "CATALOGO"
	endif
	@ 035,010 say "Cliente"
	@ 035,075 get _ccliente size 30,8 when .f.
	@ 035,110 get _cloja    size 10,8 when .f.
	@ 035,130 get _cnomecli size 130,8 when .f.
	@ 050,010 say "Transportadora"
	@ 050,075 get _ctransp  size 30,8 when .f.
	@ 050,110 get _cnometra size 130,8 when .f.
	@ 065,010 say "Tipo frete"
	@ 065,075 get _ctpfrete size 15,8 when .f.
	@ 080,010 say "Vl. Previsto frete"
//	@ 080,075 get _nfrete   size 60,8 when .f. picture "@E 999,999,999.99"
	@ 080,075 get _z   size 60,8 when .f. picture "@E 999,999,999.99"
//	@ 095,010 say "Frete pago/reemb."
//	@ 095,075 get _cfretepr size 50,8 when .f.
	@ 095,010 say "Serie conhecimento"
	@ 095,075 get _cserfret
	@ 095,130 say "Numero conhecimento"
	@ 095,190 get _cnumfret //valid _Funcao
	@ 110,010 say "Valor conhecimento"
	@ 110,075 get _valfrete size 60,8 picture "@E 999,999,999.99"
	@ 125,010 say "Fatura            "
	@ 125,075 get _fatura size 60,8
	@ 140,010 say "Data Entrega"
	@ 140,075 get _ddtentg  size 40,8 picture "@E 99/99/99"

	@ 185,130 say "Data Chegada Cidade"
	@ 185,195 get _ddtentc  size 40,8 picture "@E 99/99/99"


	@ 140,130 MSCOMBOBOX oCombo VAR cCombo ITEMS aItems When .t. SIZE 100,20 OF odlg PIXEL 

//	@ 140,130 say "Passe Fiscal"
//	@ 140,170 get _cnumpasse size 60,8 picture "@!" 
		
	@ 155,010 say "Desconto Frete"
	@ 155,075 get _descfr size 60,8 picture "@E 999,999,999.99"	
	@ 170,010 say "ICMS Frete"
	@ 170,075 get _icmsfr size 60,8 picture "@E 999,999,999.99"	
	@ 185,010 say "Desconto Pago (S/N)"
  	@ 185,075 get _descpg size 10,8 when !empty(_descfr) valid _descpg $("SN ") picture "@!"	
	@ 200,010 say "Avaria"
	@ 200,075 get _avaria size 60,8 picture "@E 999,999,999.99"	
	@ 215,010 say "Peso Frete"
	@ 215,075 get _pesfret size 60,8 picture "@E 999,999,999.99"
	@ 230,010 say "Obs."
	@ 230,075 get _obsfr size 160,8 picture "@!"	

	@ 245,075 bmpbutton type 1 action _grava()
	@ 245,115 bmpbutton type 2 action close(odlg)
	activate dialog odlg centered
endif
return()

static function _grava
sf2->(reclock("SF2",.f.))
sf2->f2_serfret:=_cserfret
sf2->f2_numfret:=_cnumfret
sf2->f2_fatura:=_fatura
sf2->f2_vlfrete:=_valfrete
sf2->f2_pesfret:=_pesfret
sf2->f2_descfr:=_descfr
sf2->f2_icmsfr:=_icmsfr
sf2->f2_obsfr:=_obsfr
sf2->f2_avaria:=_avaria
sf2->f2_descpg=_descpg

sf2->f2_dtentrg:=_ddtentg
sf2->f2_dtentcd:=_ddtentc

sf2->f2_tipfret:=cCombo
sf2->f2_passe:=_cnumpasse

sf2->(msunlock())
sysrefresh()
close(odlg)
return