/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT017   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 25/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao da Gnr                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit017()
titulo  := "EMISSAO DA GNR"
cdesc1  := "Este programa ira emitir a GNR"
cdesc2  := ""
cdesc3  := ""
tamanho := "P"
limite  := 80
cstring :="SF2"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT017"
aLinha  :={}
nlastkey:=0
lcontinua:=.t.

cperg:="PERGVIT017"
_pergsx1()
pergunte(cperg,.f.)

wnrel:="VIT017"+Alltrim(cusername)
wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
   set filter to
   return
endif
rptstatus({|| rptdetail()})
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

_cestado :=getmv("MV_ESTADO")
_cnorte  :=getmv("MV_NORTE")
_nicmpad :=getmv("MV_ICMPAD")
_ntxper  :=getmv("MV_TXPER")

_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilse1:=xfilial("SE1")
_cfilse2:=xfilial("SE2")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")
_cfilsf7:=xfilial("SF7")
_cfilsz1:=xfilial("SZ1")
_cfilcd7:=xfilial("CD7")

sa1->(dbsetorder(1))
sa2->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sd2->(dbsetorder(3))
se1->(dbsetorder(1))
se2->(dbsetorder(1))
sf2->(dbsetorder(1))
sf7->(dbsetorder(1))
sz1->(dbsetorder(1))
cd7->(dbsetorder(1))

setregua(val(mv_par02)-val(mv_par01))

setprc(0,0)
@ 000,000 PSAY avalimp(limite)
@ 000,000 PSAY chr(18)

sf2->(dbseek(_cfilsf2+mv_par01,.t.))
while ! sf2->(eof()) .and.;
		sf2->f2_filial==_cfilsf2 .and.;
		sf2->f2_doc<=mv_par02 .and.;
		lcontinua
	incregua()
	if sf2->f2_serie==mv_par03 .and.;
		sf2->f2_tipo=="N"
		sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
		_nbasegnr:=0
		_nvalgnr :=0
		_cpedido :=space(6)
		sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
		while ! sd2->(eof()) .and.;
				sd2->d2_doc==sf2->f2_doc
			if sd2->d2_serie==sf2->f2_serie
				sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
				if sc5->c5_geragnr=="S"
					sb1->(dbseek(_cfilsb1+sd2->d2_cod))
					_cpedido:=sc5->c5_num
					_vericm()
				endif
			endif
			sd2->(dbskip())
		end
		if _nvalgnr>0
			sz1->(dbseek(_cfilsz1+sa1->a1_est))
//			for _i:=1 to 2 
				@ prow()+1,000 PSAY "--------------------------------------------------------------------------------"
				@ prow()+1,000 PSAY "|     GUIA NACIONAL DE RECOLHIMENTO    |RESERVADO    |MICROFILME               |"
				@ prow()+1,000 PSAY "|      DE TRIBUTOS ESTADUAIS - GNRE    |             |                         |"
				@ prow()+1,000 PSAY "|----------------------------------------------------+-------------------------|"
				@ prow()+1,000 PSAY "|UF FAVORECIDA                   |DATA DE VENCIMENTO |CODIGO DA UF FAVOR.      |" 
				@ prow()+1,000 PSAY "|"
				@ prow(),025   PSAY sa1->a1_est
				@ prow(),033   PSAY "|"
				@ prow(),042   PSAY sf2->f2_emissao
				@ prow(),053   PSAY "|"
				@ prow(),059   PSAY sz1->z1_codest
				@ prow(),079   PSAY "|"
				@ prow()+1,000 PSAY "|----------------------------------------------------+-------------------------|"
				@ prow()+1,000 PSAY "|No.CONVENIO OU PROTOCOLO/ESPEC. MERCADORIA          |CODIGO DA RECEITA        |"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY "MEDICAMENTOS"
				@ prow(),053   PSAY "|"
				@ prow(),056   PSAY "10004-8"
				@ prow(),079   PSAY "|"
				@ prow()+1,000 PSAY "|----------------------------------------------------+-------------------------|"
				@ prow()+1,000 PSAY "|NOME FIRMA OU RAZAO SOCIAL       |INSC.EST.UF FAVOR.|CGC/CPF DO CONTRBI.      |"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY left(sa1->a1_nome,32)
				@ prow(),034   PSAY "|"
				@ prow(),035   PSAY left(sa1->a1_inscr,16)
				@ prow(),053   PSAY "|"
				@ prow(),054   PSAY sa1->a1_cgc picture "@R 99.999.999/9999-99"
				@ prow(),079   PSAY "|"
				@ prow()+1,000 PSAY "|----------------------------------------------------+-------------------------|"
				@ prow()+1,000 PSAY "|ENDERECO                                            |No.DOC. ORIGEM           |"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY left(alltrim(sa1->a1_end)+" - "+alltrim(sa1->a1_bairro),51)
				@ prow(),053   PSAY "|"
				@ prow(),054   PSAY sf2->f2_doc
				@ prow(),079   PSAY "|"
				@ prow()+1,000 PSAY "|----------------------------------------------------+-------------------------|"
				@ prow()+1,000 PSAY "|MUNICIPIO        | UF |CEP       |TELEFONE          |PER. REF/No.PARCELA      |"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY left(sa1->a1_mun,17)
				@ prow(),018   PSAY "|"
				@ prow(),020   PSAY sa1->a1_est
				@ prow(),023   PSAY "|"
				@ prow(),024   PSAY sa1->a1_cep picture "@R 99.999-999"
				@ prow(),034   PSAY "|"
				@ prow(),035   PSAY sa1->a1_tel
				@ prow(),053   PSAY "|"
				@ prow(),079   PSAY "|"
				@ prow()+1,000 PSAY "|---------------------------------+------------------+-------------------------|"
				@ prow()+1,000 PSAY "|INFORMACOES COMPLEMENTARES       | BANCO/AG.ARRECAD.|VALOR PRINCIPAL          |"
				@ prow()+1,000 PSAY "|                                 | BEG-BCO EST.GOIAS|"
				@ prow(),055   PSAY _nvalgnr picture "@E 999,999,999.99"
				@ prow(),079   PSAY "|"
				@ prow()+1,000 PSAY "|                                 -------------------+-------------------------|"
				@ prow()+1,000 PSAY "|                                                    |ATUAL.MONETARIA          |"
				@ prow()+1,000 PSAY "|                                                    |                         |"
				@ prow()+1,000 PSAY "|                                                    |-------------------------|"
				@ prow()+1,000 PSAY "|                                                    |JUROS                    |"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY sz1->z1_banco
				@ prow(),053   PSAY "|                         |"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY "Agencia "+sz1->z1_agencia
				@ prow(),053   PSAY "|-------------------------|"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY "Conta corrente "+sz1->z1_conta  
				@ prow(),053   PSAY "|MULTA                    |"
				@ prow()+1,000 PSAY "|"
				@ prow(),001   PSAY left(sm0->m0_nomecom,32)+"  "+left(sm0->m0_cidcob,15)+"-"+sm0->m0_estcob
				@ prow(),053   PSAY "|                         |"
				@ prow()+1,000 PSAY "|----------------------------------------------------+-------------------------|"
				@ prow()+1,000 PSAY "|Autenticacao Mecanica                               |TOTAL A RECOLHER         |"
				@ prow()+1,000 PSAY "|                                                    |                         |"
				@ prow()+1,000 PSAY "|                                                    |"
				@ prow(),055   PSAY _nvalgnr picture "@E 999,999,999.99"
				@ prow(),079   PSAY "|"
				@ prow()+1,000 PSAY "--------------------------------------------------------------------------------"
				@ prow()+1,000 PSAY "1a.via-Banco/Fisco Est.Favorecido  2a.via-Contribuinte  3a.via-Cont./Fisco"
				eject
  //			next
			begin transaction
			if ! se1->(dbseek(_cfilse1+sf2->f2_serie+sf2->f2_doc+"R"+"NF "))
				se1->(reclock("SE1",.t.))
				se1->e1_filial :=_cfilse1
				se1->e1_prefixo:=sf2->f2_serie
				se1->e1_num    :=sf2->f2_doc
				se1->e1_parcela:="R"
				se1->e1_tipo   :="NF "
				se1->e1_naturez:="10102"
				se1->e1_cliente:=sf2->f2_cliente
				se1->e1_loja   :=sf2->f2_loja
				se1->e1_nomcli :=sa1->a1_nreduz
				se1->e1_emissao:=sf2->f2_emissao
				se1->e1_vencto :=sf2->f2_emissao+10
				se1->e1_vencrea:=datavalida(se1->e1_vencto)
				se1->e1_valor  :=_nvalgnr
				se1->e1_emis1  :=date()
				se1->e1_la     :="S"
				se1->e1_situaca:="0"
				se1->e1_saldo  :=_nvalgnr
				se1->e1_vend1  :=sf2->f2_vend1
				se1->e1_vend2  :=sf2->f2_vend2
				se1->e1_vend3  :=sf2->f2_vend3
				se1->e1_vend4  :=sf2->f2_vend4
				se1->e1_vend5  :=sf2->f2_vend5
				se1->e1_vencori:=se1->e1_vencto
				se1->e1_porcjur:=_ntxper
				se1->e1_moeda  :=1
				se1->e1_pedido :=_cpedido
				se1->e1_vlcruz :=_nvalgnr
				se1->e1_serie  :=sf2->f2_serie
				se1->e1_status :="A"
				se1->e1_origem :="FINA040 "
				se1->e1_filorig:=sm0->m0_codfil
				se1->e1_msfil  :=sm0->m0_codfil
				se1->e1_msemp  :=sm0->m0_codigo
				se1->(msunlock())
			endif
			if ! se2->(dbseek(_cfilse2+sf2->f2_serie+sf2->f2_doc+"R"+"NF "+sz1->z1_fornece+sz1->z1_loja))
				sa2->(dbseek(_cfilsa2+sz1->z1_fornece+sz1->z1_loja))
				se2->(reclock("SE2",.t.))
				se2->e2_filial :=_cfilse2
				se2->e2_prefixo:=sf2->f2_serie
				se2->e2_num    :=sf2->f2_doc
				se2->e2_parcela:="R"
				se2->e2_tipo   :="NF "
				se2->e2_naturez:="20202"
				se2->e2_fornece:=sz1->z1_fornece
				se2->e2_loja   :=sz1->z1_loja
				se2->e2_nomfor :=sa2->a2_nreduz
				se2->e2_emissao:=sf2->f2_emissao
				se2->e2_vencto :=sf2->f2_emissao
				se2->e2_vencrea:=datavalida(sf2->f2_emissao)
				se2->e2_valor  :=_nvalgnr
				se2->e2_emis1  :=date()
				se2->e2_la     :="S"
				se2->e2_saldo  :=_nvalgnr
				se2->e2_vencori:=sf2->f2_emissao
				se2->e2_moeda  :=1
				se2->e2_vlcruz :=_nvalgnr
				se2->e2_origem :="FINA050 "
				se2->(msunlock())
			endif
			end transaction
		endif
	endif
	sf2->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "**** CANCELADO PELO OPERADOR ****"
		eject
		lcontinua:=.f.
	endif
end

set device to screen

if areturn[5]==1
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _vericm()
sf7->(dbseek(_cfilsf7+sb1->b1_grtrib+sa1->a1_grptrib))
_lok:=.f.

if ! se1->(dbseek(_cfilse1+sf2->f2_serie+sf2->f2_doc+"R"+"NF "))

	while ! sf7->(eof()) .and.;
			sf7->f7_filial==_cfilsf7 .and.;
			alltrim(sf7->f7_grtrib)==alltrim(sb1->b1_grtrib) .and.;
			sf7->f7_grpcli==sa1->a1_grptrib .and.;
			! _lok
		if sf7->f7_est==sa1->a1_est
			_lok:=.t.
			if sf7->f7_est=="MG" .and. sb1->b1_tpprod=="1"
				_nbasegnrp:=noround(sd2->d2_total*(1+38.24/100),2)
				_nvalgnrp:=noround(_nbasegnrp*(12/100),2)-sd2->d2_valicm
			elseif sf7->f7_est=="SP" .and. sb1->b1_cmed =="1" .and. sb1->b1_farmpop=="2"
				_pMc := Posicione("CD7",1,xFilial("CD7")+"S"+sd2->d2_serie+sd2->d2_doc+sd2->d2_cliente+sd2->d2_loja+sd2->d2_item,"CD7_PRECO" )
				_nbase1:=sd2->d2_quant*_pMc
				_nbaseg2:=round((_nbase1*sb1->b1_portcat)/100,2)
				_nbasegnrp:=noround(_nbase1-_nbaseg2,2)
				_nvalgnrp:=noround(_nbasegnrp*(18/100),2)-sd2->d2_valicm
			elseif sf7->f7_est=="SP" .and. sb1->b1_cmed =="2" 
				_nbasesp2:=round((sd2->d2_total*sb1->b1_portcat)/100,2)
				_nbasegnrp:= _nbasesp2+sd2->d2_total
				_nvalgnrp:=noround(_nbasegnrp*(18/100),2)-sd2->d2_valicm
			elseif sf7->f7_est=="SP" .and. sb1->b1_cmed =="1" .and. sb1->b1_farmpop=="1"
				_nbasegnrp:= sd2->d2_qtsegum*sb1->b1_vlrcomp
				_nvalgnrp:=noround(_nbasegnrp*(18/100),2)-sd2->d2_valicm
			else
				_nbasegnrp:=noround(sd2->d2_total*(1+sf7->f7_margem/100),2)
				if sf7->f7_bsicmst>0
					_nbasegnrp:=noround(_nbasegnrp*(sf7->f7_bsicmst/100),2)
				endif
				_nvalgnrp:=noround(_nbasegnrp*(sf7->f7_aliqdst/100),2)-sd2->d2_valicm
			endif			
			_nbasegnr+=_nbasegnrp
			_nvalgnr +=_nvalgnrp
		endif
		sf7->(dbskip())
	end
else 
	_nvalgnr:= se1->e1_valor
endif
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da nota fiscal     ?","mv_ch1","C",09,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a nota fiscal  ?","mv_ch2","C",09,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da serie           ?","mv_ch3","C",03,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return

/*
--------------------------------------------------------------------------------
|     GUIA NACIONAL DE RECOLHIMENTO    |RESERVADO    |MICROFILME               |
|      DE TRIBUTOS ESTADUAIS - GNRE    |             |                         |
|----------------------------------------------------+-------------------------|
|UF FAVORECIDA                   |DATA DE VENCIMENTO |CODIGO DA UF FAVOR.      |
|                                |                   |                         |
|----------------------------------------------------+-------------------------|
|No.CONVENIO OU PROTOCOLO/ESPEC. MERCADORIA          |CODIGO DA RECEITA        |
|MEDICAMENTOS                                        |                         |
|----------------------------------------------------+-------------------------|
|NOME FIRMA OU RAZAO SOCIAL       |INSC.EST.UF FAVOR.|CGC/CPF DO CONTRBI.      |
|                                 |                  |                         |
|----------------------------------------------------+-------------------------|
|ENDERECO                                            |No.DOC. ORIGEM           |
|                                                    |                         |
|----------------------------------------------------+-------------------------|
|MUNICIPIO        | UF |CEP       |TELEFONE          |PER. REF/No.PARCELA      |
|                 |    |          |                  |                         |
|---------------------------------+------------------+-------------------------|
|INFORMACOES COMPLEMENTARES       | BANCO/AG.ARRECAD.|VALOR PRINCIPAL          |
|                                 | BEG-BCO EST.GOIAS|                         |
|                                 -------------------+-------------------------|
|                                                    |ATUAL.MONETARIA          |
|                                                    |                         |
|                                                    |-------------------------|
|                                                    |JUROS                    |
|                                                    |                         |
|                                                    |-------------------------|
|                                                    |MULTA                    |
|                                                    |                         |
|----------------------------------------------------+-------------------------|
|Autenticacao Mecanica                               |TOTAL A RECOLHER         |
|                                                    |                         |
|                                                    |                         |
--------------------------------------------------------------------------------
   1a.via-Banco/Fisco Est.Favorecido  2a.via-Contribuinte  3a.via-Cont./Fisco
*/