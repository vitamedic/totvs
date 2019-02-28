/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa ³  VIT355  ³Autor ³Alex Júnio de Miraanda ³ Data ³  15/04/2010³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
±±³Descricao ³ Emite Relatorio com Rastreamento de Entradas               ´±±
±±³          ³ Movimentacoes de Produtos Acabados - Excel                 ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit355()
nordem	:= ""
tamanho := "G"
limite  := 220
titulo  := "RELATORIO DE CONTROLE DE DIST. DE PRODUTOS POR LOTE"
cdesc1  := "Este programa ira emitir o relatorio das Distribuicoes dos"
cdesc2  := "Produtos por Lote de acordo com os parametros"
cdesc3  := ""
cstring := "SB1"
areturn := {"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:= "VIT355"
wnrel   := "VIT355"+Alltrim(cusername)
alinha  := {}
nlastkey:= 0
aordem	:={}
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT355"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()

_cfilsb1:=xfilial("SB1")
_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
_cfilsf5:=xfilial("SF5")
_cfilsf4:=xfilial("SF4")
_cfilsd1:=xfilial("SD1")
_cfilsd2:=xfilial("SD2")
_cfilsd3:=xfilial("SD3")
_cfilsc2:=xfilial("SC2")
_cfilsb8:=xfilial("SB8")

sb1->(dbsetorder(1))    
sa1->(dbsetorder(1))    
sa2->(dbsetorder(1))    
sf5->(dbsetorder(1))
sf4->(dbsetorder(1))
sd1->(dbsetorder(1))
sd2->(dbsetorder(1))
sd3->(dbsetorder(1))
sc2->(dbsetorder(1))
sb8->(dbsetorder(3))

nTotVend:= 0
nTotdev := 0
nTotBal := 0
nTotPro := 0
nTotRes := 0
nTotVen := 0
nTot    := 0


//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

_aCabec := {}
_aDados := {}
_aSaldo := {}

if !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   return
endif

SeleTrab()

_aCabec := {" ", " ", " ", " ", " ", " ", " ", " "}

ImpCabec()

_historico:= ""
_quant  := 0
_nome   := ""
_cnpj   := ""
_vlrliq := 0
_prcfab := 0
_prcmax := 0
_pedido := ""
_nf		:= ""
_end    := ""
cEnt    := 0

if mv_par04<>1
	// ENTRADAS
	tra1->(dbgotop())
	if !tra1->(eof())
		cEnt := 1
	endif

	if !tra2->(eof())
		cEnt := 1
	endif
	if cEnt == 1
		AAdd(_aDados, {"ENTRADAS", " ", " ", " ", " ", " ", " ", " "})
	endif

	tra1->(dbgotop())
	if !tra1->(eof())
		cTotPrin := 1
		SetRegua(Recno())

		while ! tra1->(eof())

			IncRegua()
			_historico:= ""
			_quant := 0

			dDatEmis := tra1->d3_emissao
//			dDatEmis := ctod(substr(tra1->d3_emissao,7,2)+"/"+substr(tra1->d3_emissao,5,2)+"/"+substr(tra1->d3_emissao,3,2))

			if ! sf5->(dbSeek(_cfilsf5+tra1->d3_tm))
				if tra1->D3_DOC == "INVENT"
					_historico:="INVENTARIO "
				endif			
				_historico+=tra1->d3_doc
			else
				if tra1->d3_tm <> "104" 
					_historico += substr(sf5->f5_texto,1,20) 
					_historico += tra1->d3_doc
				elseif mv_par05==1         
					_historico += substr(sf5->f5_texto,1,20)
					_historico += tra1->d3_doc
				endif				
			endif
			if tra1->d3_tm <> "104"                        
				if mv_par05==3
					_quant:= tra1->d3_quant/2
				else
					_quant:= tra1->d3_quant
				endif
		
				nTotBal += if(mv_par05==3,tra1->d3_quant/2,tra1->d3_quant)		
			elseif mv_par05==1
				_quant:= tra1->d3_quant
				nTotBal += if(mv_par05==3,tra1->d3_quant/2,tra1->d3_quant)
			endif
			tra1->(dbskip())
	
			AAdd(_aDados, {dDatEmis,_historico,_quant, " ", " ", " ", " ", " "})
		end
		
		AAdd(_aDados, {" "," ",nTotBal, " ", " ", " ", " ", " "})
	endif

	tra2->(dbgotop())
	if ! tra2->(eof())
		cTotPrin := 1

		SetRegua(recno())

		while ! tra2->(eof())
			IncRegua()

			dDatEmis := tra2->d3_emissao
//			dDatEmis := ctod(substr(tra2->d3_emissao,7,2)+"/"+substr(tra2->d3_emissao,5,2)+"/"+substr(tra2->d3_emissao,3,2))
			_historico:= ""
			_quant := 0
			
			if ! sf5->(dbseek(_cfilsf5+tra2->d3_tm))
				if tra1->d3_doc == "INVENT"
					_historico:="INVENTARIO "
				endif                                     
				_historico+= tra2->d3_doc
			else
				if tra2->d3_tm <> "104"   
					_historico+= substr(sf5->f5_texto,1,20)
					_historico+= tra2->d3_doc
				elseif mv_par05==1
					_historico+= substr(sf5->f5_texto,1,20)
					_historico+= tra2->d3_doc					
				endif				
			endif
			if tra2->d3_tm <> "104" 
				_historico += if(mv_par05==3,tra2->d3_quant/2,tra2->d3_quant)				
				nTotPro += if(mv_par05==3,tra2->d3_quant/2,tra2->d3_quant)
			elseif mv_par05==1
				_historico += tra2->d3_quant
				nTotPro += if(mv_par05==3,tra2->d3_quant/2,tra2->d3_quant)
			endif

			tra2->(dbskip())
			AAdd(_aDados, {dDatEmis,_historico,_quant, " ", " ", " ", " ", " "})
		end
		
		AAdd(_aDados, {" "," ",nTotPro, " ", " ", " ", " ", " "})
	endif

	if cTotPrin == 1
		AAdd(_aDados, {"TOTAL ENTRADAS"," ",nTotBal+nTotPro, " ", " ", " ", " ", " "})
	endif
endif

// SAÍDAS
tra3->(dbgotop())

if ! tra3->(eof())
	cSai := 1
endif

tra4->(dbgotop())
if !tra4->(eof())
	cSai := 1
endif

If cSai == 1
	if cEnt == 1
		AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})
	endif	
	AAdd(_aDados, {"SAIDAS", " ", " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})
endif

tra4->(dbgotop())
ntot := 0

If ! tra4->(eof())
	cTotPrin := 1
	AAdd(_aDados, {"VENDAS", " ", " ", " ", " ", " ", " ", " "})

	SetRegua(Recno())
	
	while ! tra4->(eof())
		IncRegua()

		_nome   := ""
		_cnpj   := ""
		_end    := ""
		_vlrliq := 0
		_prcfab := 0
		_prcmax := 0
				
		if tra4->d2_quant-tra4->d2_qtdedev <=0
			tra4->(dbskip())
			loop
		endif

		sf4->(dbseek(_cfilsf4+tra4->d2_tes))

		if sf4->f4_duplic<>"S"
			tra4->(dbskip())
			loop
		endif        		
		if (nTotVen >= (nTotBal + nTotPro) .and. mv_par05==2)
			tra4->(dbskip())
			loop
		endif
		
		dDatEmis := tra4->d2_emissao
		sa1->(dbseek(_cfilsa1+tra4->d2_cliente+tra4->d2_loja))

		if mv_par04<>1	
			_nome:= sa1->a1_nome
			if mv_par03 = 1
				_pedido:= tra4->d2_pedido
				_nf:= tra4->d2_doc + "-" + tra4->d2_serie
			endif
			_fatorpos:=0.7234
			if sa1->a1_est = "RJ"
				_fatorneg:=0.7523
			elseif sa1->a1_est = "SP#RS#MG#SC#PR"
				_fatorneg:=0.7519
			elseif sa1->a1_est = "AM#AC#AP#RO"
				_fatorneg:=0.7234
			else
				_fatorneg:=0.7516
			endif
			_nprmax := 0
			if sb1->b1_categ=="N  "
				_nprmax:=round(tra4->d2_prunit/_fatorneg,6)
			else
				_nprmax:=round(tra4->d2_prunit/_fatorpos,6)
			endif
			
			_quant  := if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev)
            _vlrliq := tra4->d2_prcven
			_prcfab := tra4->d2_prunit
			_prcmax := _nprmax

			AAdd(_aDados, {dDatEmis, _nome, _pedido, _nf, _quant, _vlrliq, _prcfab, _prcmax})

		else
			_cnpj:= transform(sa1->a1_cgc,"@R 99.999.999/9999-99")
			_nome:= sa1->a1_nome
			_nf := tra4->d2_doc+"-"+tra4->d2_serie
            _quant:= if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev)
			_vlrliq:= tra4->d2_prcven
			_end := rtrim(sa1->a1_end)+", "+rtrim(sa1->a1_bairro)+", "+rtrim(sa1->a1_mun)+" - "+sa1->a1_est
			AAdd(_aDados, {_cnpj, _nome, dDatEmis, _nf, _quant, _vlrliq, _end, " "})
		endif

		nTotVen += if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev)
		tra4->(dbskip())
	end

	if mv_par04 <> 1 .and. nTotVen > 0
		AAdd(_aDados, {"TOTAL VENDAS"," ",nTotVen, " ", " ", " ", " ", " "})
		AAdd(_aDados, {" "," "," ", " ", " ", " ", " ", " "})		
	endif
endif

//BONIFICAÇÃO
nTotbon := 0
_la := .t.

tra4->(dbgotop())

If !tra4->(eof())
	cTotPrin := 1
	SetRegua(Recno())

	while ! tra4->(eof())
		IncRegua()
		_nome   := ""
		_cnpj   := ""
		_end    := ""
		_vlrliq := 0
		_prcfab := 0
		_prcmax := 0	

		if tra4->d2_quant-tra4->d2_qtdedev <=0
			tra4->(dbskip())
			loop
		endif
		if ((nTotVen+nTotbon >= nTotBal + nTotPro) .and. mv_par05==2)
			tra4->(dbskip())
			loop
		endif
		
		sf4->(dbSeek(_cfilsf4+tra4->d2_tes))

		if sf4->f4_duplic=="S"
			tra4->(dbskip())
			loop
		endif

		if sf4->f4_tpmov=="V"
			tra4->(dbskip())
			loop
		endif

		dDatEmis := tra4->d2_emissao
//		dDatEmis := ctod(substr(tra4->d2_emissao,7,2)+"/"+substr(tra4->d2_emissao,5,2)+"/"+substr(tra4->d2_emissao,3,2))

		dbSelectArea("SA1")
		dbSetOrder(1)
		sa1->(dbseek(_cfilsa1+tra4->d2_cliente+tra4->d2_loja))

		if mv_par04<>1
			if _la
				AAdd(_aDados, {"VENDAS", " ", " ", " ", " ", " ", " ", " "})
				_la := .f.
			endif

			_nome:= sa1->a1_nome

			if mv_par03 = 1
				_pedido:= tra4->d2_pedido
				_nf := (tra4->d2_doc + "-" + tra4->d2_serie)
			endif

			_quant:= if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev) 

			AAdd(_aDados, {dDatEmis, _nome, _pedido, _nf, _quant, " ", " ", " "})
		else
			_cnpj :=  transform(sa1->a1_cgc,"@R 99.999.999/9999-99")
			_nome := sa1->a1_nome
			_nf := (tra4->d2_doc + "-" + tra4->d2_serie)
			_quant := if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev)
			AAdd(_aDados, {_cnpj, _nome, dDatEmis, _nf, _quant, _end, " ", " "})
		endif

		nTotbon += if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev)
		tra4->(dbskip())
	end

	if mv_par04 <> 1 .and. nTotbon > 0
		AAdd(_aDados, {"TOTAL BONIFICACAO"," ",nTotBon, " ", " ", " ", " ", " "})
		AAdd(_aDados, {" "," "," ", " ", " ", " ", " ", " "})		
	endif
endif

//
_historico:= ""
_quant  := 0
_nome   := ""
_cnpj   := ""
_vlrliq := 0
_prcfab := 0
_prcmax := 0
_pedido := ""
_nf		:= ""
_end    := ""
_m := .t.

tra3->(dbgotop())

if ! tra3->(eof())
	cTotPrin := 1
	SetRegua(Recno())

	while ! tra3->(eof())
		IncRegua()
		_historico := ""
		_nome   := ""
		_cnpj   := ""
		_end    := ""
		_vlrliq := 0
		_prcfab := 0
		_prcmax := 0	

		if ((nTotVen+nTotbon+nTotRes) >= (nTotBal + nTotPro) .and. mv_par05==2)
			tra3->(dbskip())
			loop
		endif
		if _m
			AAdd(_aDados, {"SAIDAS", " ", " ", " ", " ", " ", " ", " "})
			_m := .f.
		endif	
		
		dDatEmis := tra3->c9_datalib
//		dDatEmis := ctoD(substr(tra3->c9_datalib,7,2)+"/"+substr(tra3->c9_datalib,5,2)+"/"+substr(tra3->c9_datalib,3,2))

		if ! sa1->(dbSeek(_cfilsa1+tra3->c9_cliente+tra3->c9_loja))
			if tra1->d3_doc == "INVENT"
				_nome:= "INVENTARIO" 
			endif
		else
			_nome:= sa1->a1_nome
		endif

		_quant:= if(mv_par05==3,tra3->c9_qtdlib/2,tra3->c9_qtdlib) 

		nTotRes += if(mv_par05==3,tra3->c9_qtdlib/2,tra3->c9_qtdlib)
		tra3->(dbskip())

		AAdd(_aDados, {dDatEmis, _nome, " ", " ", _quant, " ", " ", " "})
	end
	
	if nTotRes > 0
		AAdd(_aDados, {"TOTAL SAIDAS"," ",nTotRes, " ", " ", " ", " ", " "})
		AAdd(_aDados, {" "," "," ", " ", " ", " ", " ", " "})		
		ntot += nTotRes
	endif	
endif

//// DOAÇÕES
nTotdoa := 0
_la := .t.

tra4->(dbgotop())

if !tra4->(eof())
	cTotPrin := 1
	SetRegua(Recno())

	_historico := ""
	_nome   := ""
	_cnpj   := ""
	_end    := ""
	_vlrliq := 0
	_prcfab := 0
	_prcmax := 0	

	while ! tra4->(eof())
		IncRegua()

		_historico := ""
		_nome   := ""
		_cnpj   := ""
		_end    := ""
		_vlrliq := 0
		_prcfab := 0
		_prcmax := 0	

		if tra4->d2_quant-tra4->d2_qtdedev <=0
			tra4->(dbskip())
			loop
		endif
		if ((nTotVen+nTotdoa >= nTotBal + nTotPro) .and. mv_par05==2)
			tra4->(dbskip())
			loop
		endif
			
		sf4->(dbseek(_cfilsf4+tra4->d2_tes))

		if sf4->f4_duplic=="S"
			tra4->(dbskip())
			loop
		endif

		if sf4->f4_tpmov<>"V"
			tra4->(dbskip())
			loop
		endif

		dDatEmis := tra4>-d2_emissao
//		dDatEmis := ctod(substr(tra4->d2_emissao,7,2)+"/"+substr(tra4->d2_emissao,5,2)+"/"+substr(tra4->d2_emissao,3,2))

		sa1->(dbseek(_cfilsa1+tra4->d2_cliente+tra4->d2_loja))
		if mv_par04<>1
			if _la
				AAdd(_aDados, {"DOACOES", " ", " ", " ", " ", " ", " ", " "})
				_la := .f.
			endif                                                            
			
			_nome:= sa1->a1_nome

			if mv_par03 = 1
				_pedido:= tra4->d2_pedido
				_nf := (tra4->d2_doc + "-" + tra4->d2_serie)
			endif

			_quant:= if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev) 
			AAdd(_aDados, {dDatEmis, _nome, _pedido, _nf, _quant, " ", " ", " "})
		else
			_cnpj := transform(sa1->a1_cgc,"@R 99.999.999/9999-99")
			_nome := sa1->a1_nome
			_nf := (tra4->d2_doc + "-" + tra4->d2_serie)
			_end := rtrim(sa1->a1_end)+", "+rtrim(sa1->a1_bairro)+", "+rtrim(sa1->a1_mun)+" - "+sa1->a1_est
			_quant := if(mv_par05==3,(tra4->d2_quant-tra4->d2_qtdedev)/2,tra4->d2_quant-tra4->d2_qtdedev)
			AAdd(_aDados, {_cnpj, _nome, dDatEmis, _nf, _quant, _end, " ", " "})			
		endif

		nTotdoa += if(mv_par05==3,(TRA4->D2_QUANT-TRA4->D2_QTDEDEV)/2,TRA4->D2_QUANT-TRA4->D2_QTDEDEV)
		tra4->(dbskip())
	end
	if mv_par04 <> 1 .and. nTotdoa > 0
		AAdd(_aDados, {"TOTAL DOACOES"," ",nTotdoa, " ", " ", " ", " ", " "})
		AAdd(_aDados, {" "," "," ", " ", " ", " ", " ", " "})		
		ntot += nTotdoa
	endif
endif


//// DEVOLUÇÕES
_ndev := 0

tra5->(dbgotop())

If ! tra5->(eof())
	cTotPrin := 1
	
	SetRegua(Recno())
	_ndev := 0
	_m :=.t.
	
	while ! tra5->(eof())
		IncRegua()

		_historico := ""
		_nome   := ""
		_cnpj   := ""
		_end    := ""
		_vlrliq := 0
		_prcfab := 0
		_prcmax := 0	
	
		sf4->(dbseek(_cfilsf4+tra5->d1_tes))
		if sf4->f4_estoque =='N' .and. tra5->d1_doc<>"065308" 
			tra5->(dbskip())
			Loop
		endif                                                 
		
		if _m 
			AAdd(_aDados, {"DEVOLUCOES", " ", " ", " ", " ", " ", " ", " "})
			_m :=.f.
		endif
		
		dDatEmis := tra5->d1_emissao
//		dDatEmis := ctod(substr(tra5->d1_emissao,7,2)+"/"+substr(tra5->d1_emissao,5,2)+"/"+substr(tra5->d1_emissao,3,2))

		sa1->(dbseek(_cfilsa1+tra5->d1_fornece+tra5->d1_loja))
		_nome := sa1->a1_nome
		_nf := tra5->d1_doc+"-"+tra5->d1_serie
		_historico:= "nf orig: "+tra5->d1_nfori +"-"+tra5->d1_seriori
		_quant:= if(mv_par05==3,tra5->d1_quant/2,tra5->d1_quant)

		_ndev += if(mv_par05==3,tra5->d1_quant/2,tra5->d1_quant)
		tra5->(dbskip())
		AAdd(_aDados, {dDatEmis, _nome, _historico, _nf, _quant, " ", " ", " "})

	end   
	if _ndev > 0
		AAdd(_aDados, {"TOTAL DEVOLUCOES"," ",_ndev, " ", " ", " ", " ", " "})
		AAdd(_aDados, {" "," "," ", " ", " ", " ", " ", " "})		
		ntot += _ndev
	endif	
endif

if mv_par04<>1
	if cTotPrin == 1
		AAdd(_aDados, {" "," "," ", " ", " ", " ", " ", " "})		
		AAdd(_aDados, {"TOTAL GERAL DE SAIDASDEVOLUCOES"," ",(nTotRes+nTotbon + nTotVen + _ndev), " ", " ", " ", " ", " "})
		AAdd(_aDados, {" "," "," ", " ", " ", " ", " ", " "})		
	endif
endif

// GERA ARQUIVO EXCEL
DlgToExcel({ {"ARRAY", "RASTREABILIDADE DE LOTE", _aCabec, _aDados} })

tra1->(dbclosearea())
tra2->(dbclosearea())
tra3->(dbclosearea())
tra4->(dbclosearea())
tra5->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPCABEC  ³Autor ³Alex Júnio de Miranda    ³ Data ³ 15/04/2010 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
±±³Descricao ³ GERA O CABEÇALHO DO RELATORIO                                 ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESPECIFICO Vitamedic                                            ³±±
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCabec()

AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})
AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})
AAdd(_aDados, {"VITAMEDIC INDUSTRIA FARMACEUTICA LTDA", " ", " ", " ", " ", " ", " ", " "})
AAdd(_aDados, {"Controle de Estoque de Produtos Acabados", " ", " ", " ", " ", " ", " ", " "})
AAdd(_aDados, {"Ficha do Lote", " ", " ", " ", " ", " ", " ", " "})

sb1->(dbseek(_cfilsb1+mv_par01))

AAdd(_aDados, {"Produto", Alltrim(mv_par01)+"-"+sb1->b1_desc," ", " ", " ", " ", " ", " "})
AAdd(_aDados, {"Lote", Alltrim(mv_par02), " ", " ", " ", " ", " ", " "})

if mv_par04 <> 1  // SOMENTE SAIDAS
	// Buscando a ordem de producao
	//_cindsc2 :=criatrab(,.f.)
	//_cchave :="C2_FILIAL+c2_PRODUTO+C2_LOTECTL"
	//sc2->(indregua("SC2 ",_cindsc2,_cchave))
	sc2->(dbseek(_cfilsc2+mv_par02+"01"+"001"+"  "))

	set softseek  on
	sb8->(dbseek(_cfilsb8+mv_par01+"01"+mv_par02))
	set softseek off
	_qtdlote :=0                   
	_nempenho :=0
	_saldo :=0
	while ! sb8->(eof()) .and.;
		substr(mv_par01,1,6)==substr(sb8->b8_produto,1,6) .and.;
		substr(sb8->b8_lotectl,1,6)==substr(mv_par02,1,6)
		
		_saldo:= sb8->b8_saldo - sb8->b8_empenho
		if _saldo < 0
			_saldo :=0
		endif
		_qtdlote += _saldo
		_nempenho += sb8->b8_empenho
		sb8->(dbskip())
	end	

	set softseek  on
	sb8->(dbseek(_cfilsb8+mv_par01+"01"+mv_par02))
	set softseek off

	AAdd(_aDados, {"Inicio da Producao", dtoc(sc2->c2_datpri), " ", " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {"Validade", dtoc(sb8->b8_dtvalid), " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {"Final da Producao", dtoc(sc2->c2_datrf), " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {"Quantidade Prevista", if(mv_par05==3,sb1->b1_le,sc2->c2_quant), " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {"Quantidade Produzida", if(mv_par05==3,sc2->c2_quje/2,sc2->c2_quje), " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {"Diferenca", if(mv_par05==3,(sc2->c2_quant - sc2->c2_quje)/2,(sc2->c2_quant - sc2->c2_quje)), " ", " ", " ", " ", " ", " "})

	if mv_par05==2
		AAdd(_aDados, {"Quantidade Vendida", sc2->c2_quje-_qtdlote, " ", " ", " ", " ", " ", " "})
	else 
		AAdd(_aDados, {"Quantidade Vendida", if(mv_par05==3,nTotVend/2,nTotVend), " ", " ", " ", " ", " ", " "})
	endif

	AAdd(_aDados, {"Quantidade Devolucao", if(mv_par05==3,nTotDev/2,nTotDev), " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {"Estoque Atual", if(mv_par05==3,_qtdlote/2,_qtdlote), " ", " ", " ", " ", " ", " "})
	AAdd(_aDados, {"Empenho", if(mv_par05==3,_nempenho/2,_nempenho), " ", " ", " ", " ", " ", " "})

//	sc2->(retindex("SC2"))
//	ferase(_cindsc2+sc2->(ordbagext()))
endif

AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})
AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})

if mv_par03 == 1 .and. mv_par04<>1
	AAdd(_aDados, {"DATA", "HISTORICO", "PED/NF DEV", "NF/NF ORIG", "QUANTIDADE", "VLR LIQ", "PRC FAB", "PRC MAX"})
elseif mv_par04 == 1
	AAdd(_aDados, {"CNPJ", "CLIENTE", "DATA", "N FISCAL", "VLR LIQ", "QUANTIDADE", "ENDERECO", " "})
else
	AAdd(_aDados, {"DATA", "HISTORICO", "QUANTIDADE", " ", " ", " ", " ", " "})
endif

AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})
AAdd(_aDados, {" ", " ", " ", " ", " ", " ", " ", " "})

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ SELETRAB  ³Autor ³Gardenia Ilany           ³ Data ³ 31/03/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - Sigafin Versao 6.09 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Funcao de Selecionar os dados para a gravacao no arq. trabalho³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/04/02 ==> Function SeleTrab

Static Function SeleTrab()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Entradas                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer1:=" SELECT 
cQuer1+=" D3_EMISSAO, "
cQuer1+=" D3_TM, "
cQuer1+=" D3_DOC, "
cQuer1+=" D3_QUANT "
cQuer1+=" FROM "
cQuer1+= retsqlname("SD3")+" SD3"
cQuer1+=" WHERE"
cQuer1+="     SD3.D_E_L_E_T_ =' '"
cQuer1+=" AND D3_FILIAL= '"+xFilial("SD3")+"'"
cQuer1+=" AND D3_CF<>'DE6'"
cQuer1+=" AND D3_TM>='002'"
cQuer1+=" AND D3_TM<='499'"
cQuer1+=" AND D3_TM<>'999'"
cQuer1+=" AND D3_LOCAL='01'"
cQuer1+=" AND D3_ESTORNO<>'S'"
cQuer1+=" AND D3_COD='"+mv_par01+"'"
cQuer1+=" AND D3_LOTECTL='"+mv_par02+"'"
cQuer1+=" ORDER BY D3_TM, D3_COD, D3_LOTECTL, D3_EMISSAO, D3_DOC"

cquer1:=changequery(cquer1)

tcquery cquer1 new alias "TRA1"
tcsetfield("TRA1","D3_EMISSAO","D")
tcsetfield("TRA1","D3_QUANT","N",12,2)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Producoes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer2:=" SELECT "
cQuer2+=" D3_EMISSAO, "
cQuer2+=" D3_TM, "
cQuer2+=" D3_DOC, "
cQuer2+=" D3_QUANT "
cQuer2+=" FROM "
cQuer2+= RetSqlName("SD3")+" SD3"
cQuer2+=" WHERE"
cQuer2+="     SD3.D_E_L_E_T_=' '"
cQuer2+=" AND D3_FILIAL='"+xFilial("SD3")+"'"
cQuer2+=" AND D3_CF='DE6'"
cQuer2+=" AND D3_TM='499'"
cQuer2+=" AND D3_LOCAL='01'"
cQuer2+=" AND D3_COD='"+mv_par01+"'"
cQuer2+=" AND D3_LOTECTL='"+mv_par02+"'"
cQuer2+=" ORDER BY D3_TM, D3_COD, D3_LOTECTL, D3_EMISSAO, D3_DOC"

cquer2:=changequery(cquer2)

tcquery cquer2 new alias "TRA2"
tcsetfield("TRA2","D3_EMISSAO","D")
tcsetfield("TRA2","D3_QUANT","N",12,2)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Saida                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer3:=" SELECT "
cQuer3+=" C9_DATALIB, "
cQuer3+=" C9_CLIENTE, "
cQuer3+=" C9_LOJA, "
cQuer3+=" C9_QTDLIB "
cQuer3+=" FROM "
cQuer3+= RetSqlName("SC9")+" SC9"
cQuer3+=" WHERE"
cQuer3+="     SC9.D_E_L_E_T_=' '"
cQuer3+=" AND C9_FILIAL='"+xFilial("SC9")+"'"
cQuer3+=" AND C9_LOCAL='01'"
cQuer3+=" AND C9_PRODUTO='"+mv_par01+"'"
cQuer3+=" AND C9_LOTECTL='"+mv_par02+"'"
cQuer3+=" AND C9_SERIENF='R'"
cQuer3+=" ORDER BY C9_PRODUTO,C9_DATALIB,C9_CLIENTE,C9_LOJA"

cquer3:=changequery(cquer3)

tcquery cquer3 new alias "TRA3"
tcsetfield("TRA3","C9_DATALIB","D")
tcsetfield("TRA3","C9_QTDLIB","N",12,2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Vendas                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuer4:=" SELECT "
cQuer4+=" D2_CLIENTE, "
cQuer4+=" D2_LOJA, "
cQuer4+=" D2_PEDIDO, "
cQuer4+=" D2_DOC, "
cQuer4+=" D2_SERIE, "
cQuer4+=" D2_SERIE, "
cQuer4+=" D2_EMISSAO, "
cQuer4+=" D2_TES, "
cQuer4+=" D2_QUANT, "
cQuer4+=" D2_QTDEDEV, "
cQuer4+=" D2_PRUNIT, "
cQuer4+=" D2_PRCVEN "
cQuer4+=" FROM "
cQuer4+= RetSqlName("SD2")+" SD2"
cQuer4+=" WHERE"
cQuer4+="     SD2.D_E_L_E_T_=' '"
cQuer4+=" AND D2_FILIAL='"+xFilial("SD2")+"'"
cQuer4+=" AND D2_LOCAL='01'"
cQuer4+=" AND D2_COD='"+mv_par01+"'"
cQuer4+=" AND D2_LOTECTL='"+mv_par02+"'"
cQuer4+=" ORDER BY D2_COD"

cquer4:=changequery(cquer4)

tcquery cquer4 new alias "TRA4"
tcsetfield("TRA4","D2_EMISSAO","D")
tcsetfield("TRA4","D2_QUANT","N",12,2)
tcsetfield("TRA4","D2_QTDEDEV","N",12,2)
tcsetfield("TRA4","D2_PRCVEN","N",12,2)
tcsetfield("TRA4","D2_PRUNIT","N",12,2)

tra4->(dbgotop())

while ! tra4->(eof())

	sf4->(dbseek(_cfilsf4+tra4->d2_tes))

	if sf4->f4_estoque =='N' 
		tra4->(dbskip())
		loop
	endif
	nTotVend += tra4->d2_quant - tra4->d2_qtdedev
	tra4->(dbskip())
end

tra4->(dbgotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta os Movimentos de Devolução                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuer5:=" SELECT "
cQuer5+=" D1_FORNECE, "
cQuer5+=" D1_LOJA, "
cQuer5+=" D1_EMISSAO, "
cQuer5+=" D1_DOC, "
cQuer5+=" D1_SERIE, "
cQuer5+=" D1_TES, "
cQuer5+=" D1_NFORI, "
cQuer5+=" D1_SERIORI, "
cQuer5+=" D1_QUANT "
cQuer5+=" FROM "
cQuer5+= RetSqlName("SD1")+" SD1"
cQuer5+=" WHERE"
cQuer5+="     SD1.D_E_L_E_T_=' '"
cQuer5+=" AND D1_FILIAL='"+xFilial("SD1")+"'"
cQuer5+=" AND D1_LOCAL='93'"
cQuer5+=" AND D1_COD='"+mv_par01+"'"
cQuer5+=" AND D1_LOTECTL='"+mv_par02+"'"
cQuer5+=" ORDER BY D1_COD"

cquer5:=changequery(cquer5)

tcquery cquer5 new alias "TRA5"
tcsetfield("TRA5","D1_EMISSAO","D")
tcsetfield("TRA5","D1_QUANT","N",12,2)

tra5->(dbgotop())

while ! tra5->(eof())

	sf4->(dbseek(_cfilsf4+tra5->d1_tes))
	if sf4->f4_estoque =='N' 
		tra5->(dbskip())
		loop
	endif
	nTotDev := nTotdev + TRA5->D1_QUANT
	tra5->(dbskip())
end

tra5->(dbgotop())

return


Static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Do Lote            ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Coluna de notas    ?","mv_ch3","N",01,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Somente saidas     ?","mv_ch4","N",08,0,0,"C",space(60),"mv_par04"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Tipo Rel.          ?","mv_ch5","N",15,0,0,"C",space(60),"mv_par05"       ,"1-OPFirme"      ,space(30),space(15),"2-OPPrev(*+)"   ,space(30),space(15),"3-OPPrev(*/)"   ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
