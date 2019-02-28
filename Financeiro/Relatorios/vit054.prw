/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT054   ³ Autor ³ Gardenia Ilany        ³ Data ³ 17/04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Carta de Cobranca de Juros e Despesas         ³±±
±±³          ³ Bancarias                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function VIT054()
ccadastro:="Carta de cobrança de juros e despesas bancárias"
arotina  :={}
aadd(arotina,{"Pesquisar" ,"axpesqui"                    ,0,1})
aadd(arotina,{"Visualizar","axvisual"                    ,0,2})
aadd(arotina,{"Imprimir"  ,'execblock("VIT054A",.f.,.f.)',0,3})
se1->(dbsetorder(1))
se1->(dbgotop())
se1->(mbrowse(006,001,022,075,"SE1",,"! E1_SALDO"))
return

user function VIT054a()
if substr(se1->e1_tipo,3,1)=="-" .or. se1->e1_tipo$"JP /RA /PR "
	msgstop("Não é possível imprimir carta de cobrança para este título!")
else
	_nordse1:=se1->(indexord())
	_nregse1:=se1->(recno())
	
	_cfilsa1:=xfilial("SA1")
	_cfilse1:=xfilial("SE1")
	sa1->(dbsetorder(1))
	se1->(dbsetorder(1))
	
	_nrecebido:=se1->e1_valor-saldotit(se1->e1_prefixo,se1->e1_num,;
	se1->e1_parcela,se1->e1_tipo,;
	se1->e1_naturez,"R",se1->e1_cliente,;
	se1->e1_moeda,,,se1->e1_loja,_cfilse1)
	
	// totaliza o valor pago pelo cliente
	//   _nrecebido:=_nrecebido+se1->e1_juros
	/*
	_njurrec  :=se1->e1_juros
	_ndias    :=date()-se1->e1_vencto
	_njuros1:=0
	if _ndias <=30
	_njuros :=(se1->e1_saldo*_ndias*0.27)/100
	else
	_njuros :=(se1->e1_saldo*30*0.27)/100
	_saldo:=se1->e1_saldo*((1+(0.27/100))^(_ndias-30))
	_njuros1:=_saldo-se1->e1_saldo
	endif
	_njuros:=_njuros+_njuros1
	
	*/
	
	_njurrec  :=se1->e1_juros
	_ndias    :=se1->e1_baixa-se1->e1_vencrea
	if ! empty(se1->e1_valjur)
		_njuros:=round(_ndias*se1->e1_valjur,2)-_njurrec
	else
		_njuros:=round(_ndias*(se1->e1_valor*(se1->e1_porcjur/100)),2)-_njurrec
	endif
	if _njuros<0
		_njuros:=0
	endif
	
	
	
	//	if ! empty(se1->e1_valjur)
	//		_njuros:=round(_ndias*se1->e1_valjur,2)-_njurrec
	//	else
	//		_njuros:=round(_ndias*(se1->e1_valor*(se1->e1_porcjur/100)),2)-_njurrec
	//	endif
	_juros:=se1->e1_saldo
	if _njuros<0
		_njuros:=0
	endif
	_ndesp    :=0
	_cvencrea :=dtoc(se1->e1_vencrea)
	_cbaixa   :=dtoc(se1->e1_baixa)
	_cchave:=_cfilse1+se1->e1_cliente+se1->e1_loja+se1->e1_prefixo+se1->e1_num+se1->e1_parcela+"JP "
	se1->(dbsetorder(2))
	if se1->(dbseek(_cchave))
		_cnatureza:=se1->e1_naturez
		_chist    :=se1->e1_hist
	else
		_cnatureza:=space(10)
		_chist    :=space(25)
	endif
	
	se1->(dbsetorder(_nordse1))
	se1->(dbgoto(_nregse1))
	
	sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))
	
	@ 000,000 to 390,600 dialog odlg title ccadastro
	
	@ 005,005 say "Cliente"
	@ 005,060 say se1->e1_cliente+"/"+se1->e1_loja+" - "+sa1->a1_nome
	@ 020,005 say "Titulo"
	@ 020,060 say se1->e1_prefixo+"/"+se1->e1_num+"/"+se1->e1_parcela+"/"+se1->e1_tipo
	@ 035,005 say "Vencimento"
	@ 035,060 say _cvencrea
	@ 050,005 say "Valor"
	@ 050,060 say se1->e1_valor size 60,8 picture "@E 999,999,999.99"
	@ 065,005 say "Recebimento"
	@ 065,060 say _cbaixa
	@ 080,005 say "Valor recebido"
	@ 080,060 say _nrecebido size 60,8 picture "@E 999,999,999.99"
	@ 095,005 say "Juros recebidos"
	@ 095,060 say _njurrec size 60,8 picture "@E 999,999,999.99"
	@ 110,005 say "Juros a receber"
	@ 110,060 get _njuros size 60,8 picture "@E 999,999,999.99" valid positivo()
	@ 125,005 say "Despesas"
	@ 125,060 get _ndesp  size 60,8 picture "@E 999,999,999.99" valid positivo()
	@ 140,005 say "Natureza"
	@ 140,060 get _cnatureza size 60,8 f3 "SED" valid existcpo("SED")
	@ 155,005 say "Historico"
	@ 155,060 get _chist size 150,8
	
	@ 175,060 bmpbutton type 1 action _grava()
	@ 175,100 bmpbutton type 2 action close(odlg)
	
	activate dialog odlg centered
	
	se1->(dbsetorder(_nordse1))
	se1->(dbgoto(_nregse1))
	sysrefresh()
endif
//return

static function _grava()
if _njuros+_ndesp>0
	_ncampos:=se1->(fcount())
	_atit:={}
	for _i:=1 to _ncampos
		aadd(_atit,se1->(fieldget(_i)))
	next
	se1->(dbsetorder(2))
	if ! se1->(dbseek(_cchave))
		se1->(reclock("SE1",.t.))
		se1->e1_filial :=_cfilse1
		se1->e1_prefixo:=_atit[se1->(fieldpos("E1_PREFIXO"))]
		se1->e1_num    :=_atit[se1->(fieldpos("E1_NUM"    ))]
		se1->e1_parcela:=_atit[se1->(fieldpos("E1_PARCELA"))]
		se1->e1_tipo   :="JP "
		se1->e1_naturez:=_cnatureza
		se1->e1_cliente:=_atit[se1->(fieldpos("E1_CLIENTE"))]
		se1->e1_loja   :=_atit[se1->(fieldpos("E1_LOJA"   ))]
		se1->e1_nomcli :=_atit[se1->(fieldpos("E1_NOMCLI" ))]
		//		se1->e1_emissao:=_atit[se1->(fieldpos("E1_BAIXA"  ))]
		//		se1->e1_vencto :=_atit[se1->(fieldpos("E1_BAIXA"  ))]
		se1->e1_emissao:=ddatabase
		se1->e1_vencto :=ddatabase
		se1->e1_vencrea:=datavalida(_atit[se1->(fieldpos("E1_BAIXA"  ))])
		se1->e1_valor  :=_njuros+_ndesp
		se1->e1_emis1  :=ddatabase
		se1->e1_hist   :=_chist
		se1->e1_situaca:="0"
		se1->e1_saldo  :=_njuros+_ndesp
		se1->e1_vend1  :=_atit[se1->(fieldpos("E1_VEND1"  ))]
		se1->e1_vend2  :=_atit[se1->(fieldpos("E1_VEND2"  ))]
		se1->e1_vend3  :=_atit[se1->(fieldpos("E1_VEND3"  ))]
		se1->e1_vend4  :=_atit[se1->(fieldpos("E1_VEND4"  ))]
		se1->e1_vend5  :=_atit[se1->(fieldpos("E1_VEND5"  ))]
		se1->e1_comis1 := 0.00
		se1->e1_comis2 := 0.00
		se1->e1_comis3 := 0.00
		se1->e1_comis4 := 0.00
		se1->e1_bascom1:= 0.00
		se1->e1_bascom2:= 0.00
		se1->e1_bascom3:= 0.00
		se1->e1_bascom4:= 0.00
		se1->e1_vencori:=_atit[se1->(fieldpos("E1_BAIXA"  ))]
		se1->e1_moeda  :=_atit[se1->(fieldpos("E1_MOEDA"  ))]
		se1->e1_ocorren:="01"
		se1->e1_pedido :=_atit[se1->(fieldpos("E1_PEDIDO" ))]
		se1->e1_vlcruz :=_njuros+_ndesp
		se1->e1_status :="A"
		se1->e1_origem :="FINA040 "
		se1->e1_filorig:=_atit[se1->(fieldpos("E1_FILORIG"))]
		se1->(msunlock())
	else
		se1->(reclock("SE1",.f.))
		se1->e1_naturez:=_cnatureza
		se1->e1_valor  :=_njuros+_ndesp
		se1->e1_hist   :=_chist
		se1->e1_saldo  :=_njuros+_ndesp
		se1->e1_vlcruz :=_njuros+_ndesp
		se1->e1_comis1 := 0.00
		se1->e1_comis2 := 0.00
		se1->e1_comis3 := 0.00
		se1->e1_comis4 := 0.00
		se1->e1_bascom1:= 0.00
		se1->e1_bascom2:= 0.00
		se1->e1_bascom3:= 0.00
		se1->e1_bascom4:= 0.00
		se1->(msunlock())
	endif
	se1->(dbgoto(_nregse1))
	nordem   :=""
	tamanho  :="P"
	limite   :=80
	titulo   :="CARTA DE COBRANCA DE JUROS E DESPESAS BANCARIAS"
	cdesc1   :="Este programa ira emitir as cartas de cobranca de juros e despesas bancarias"
	cdesc2   :=""
	cdesc3   :=""
	cstring  :="SE1"
	areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
	nomeprog :="VIT054"
	wnrel    :="VIT054"+Alltrim(cusername)
	alinha   :={}
	nlastkey :=0
	lcontinua:=.t.
	
	cperg:=""
	
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
	close(odlg)
else
	msgstop("A soma de juros + despesas não pode ser zero!")
endif
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

setregua(1)

setprc(0,0)

@ 000,000      PSAY avalimp(limite)+chr(18)
@ prow()+3,005 PSAY alltrim(sm0->m0_cidcob)+", "+str(day(se1->e1_baixa),2)+;
" de "+mesextenso(month(se1->e1_baixa))+" de "+;
str(year(se1->e1_baixa),4)

@ prow()+7,005 PSAY "Prezado cliente,"

sa1->(dbsetorder(1))
sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))

@ prow()+2,005 PSAY sa1->a1_nome
//@ prow()+1,000 PSAY sa1->a1_end+" - "+sa1->a1_bairro
//@ prow()+1,000 PSAY sa1->a1_mun+" - "+sa1->a1_est
//@ prow()+1,000 PSAY sa1->a1_cep picture "@R 99999-999"
@ prow()+5,005 PSAY "Encontram-se pendentes  em nossos  controles,  juros e  despesas  bancárias"
@ prow()+1,005 PSAY "do título abaixo discriminado,pago em atraso com relação ao seu vencimento."
@ prow()+5,005 PSAY "No. Titulo: "+se1->e1_prefixo+"-"+se1->e1_num+"-"+se1->e1_parcela
@ prow()+2,005 PSAY "Dt.Emis.      Valor Dt.Vencto Dt.Pgto     Vl.Pago   Dp.Banc   Juros"
//XXX-999999-X 99/99/99 9999.999,99 99/99/99 99/99/99 9999.999,99 9999,99 9999,99
//Dt.Emis.      Valor Dt.Vencto Dt.Pgto     Vl.Pago Dp.Banc   Juros"
//99/99/99 9999.999,99 99/99/99 99/99/99 9999.999,99 9999,99 9999,99
@ prow()+1,005 PSAY se1->e1_emissao
@ prow(),014   PSAY se1->e1_valor  picture "@E 9999,999.99"
@ prow(),026   PSAY se1->e1_vencrea
@ prow(),035   PSAY se1->e1_baixa
@ prow(),044   PSAY se1->e1_valliq   picture "@E 9999,999.99"
//@ prow(),053   PSAY _nrecebido     picture "@E 9999,999.99"
@ prow(),057   PSAY _ndesp        picture "@E 9999.99"
@ prow(),065   PSAY _njuros    picture "@E 9999.99"
@ prow()+2,005 PSAY chr(15)+chr(14)+"Total a pagar ->"+transform(_njuros+_ndesp,"@E 999,999.99")+chr(20)+chr(18)
@ prow()+4,005 PSAY "Caso já  tenha  quitado, favor desconsiderar o presente aviso  e nos enviar"
@ prow()+1,005 PSAY "cópia do comprovante de pagamento, através do FAX(0XX62) 3902-6129."
@ prow()+2,005 PSAY "Certos do atendimento, antecipamos nossos agradecimentos."
@ prow()+5,005 PSAY "Atenciosamente,"
@ prow()+3,005 PSAY sm0->m0_nomecom
@ prow()+1,005 PSAY "Departamento de Crédito e Cobrança"
//@ prow()+2,060 PSAY "["+sa1->a1_cod+"/"+sa1->a1_loja+" - "+se1->e1_vend1+"]"
//eject
//setprc(0,0)
incregua()

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

/*
Pfx-Titulo   Dt.Emis.       Valor Dt.Vencto Dt.Pgto     Vl.Pago Dp.Banc   Juros
XXX-999999-X 99/99/99 9999.999,99 99/99/99 99/99/99 9999.999,99 9999,99 9999,99
*/
