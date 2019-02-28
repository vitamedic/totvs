/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT347   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 24/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Pedido de Compras - Integracao com Microsoft Word          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "msole.ch"

User Function VIT347()
cabec1     :=""
cabec2     :=""
cabec3     :=""
wnrel      :="VIT347"+Alltrim(cusername)
titulo     :="Emissao de pedido de Compras"
cDesc1     :="Emite pedido de Compras no Word"
cDesc2     :=""
cDesc3     :=""
cString    :="SC7"
nElementos := 0
nLastKey   := 0
aReturn    := { "Especial", 1,"Compras", 1, 2, 1, "",1 }
nomeprog   := "VIT347"
cPerg      := "PERGVIT347"
_nLin      := 80
tamanho    := "G"
m_pag      := 1
nTipo      := 15
_nPri      := 1

//-------------------------------------------------------------------
// Verifica as perguntas selecionadas
//-------------------------------------------------------------------

_pergsx1()
pergunte(cperg,.f.)

//-------------------------------------------------------------------
// Variaveis utilizadas para parametros
//-------------------------------------------------------------------
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Do pedido
//¦ mv_par02             // Ate o pedido
//¦ mv_par03             // Arquivo Modelo
//-------------------------------------------------------------------

//-------------------------------------------------------------------
//³ Envia controle para a funcao SETPRINT
//-------------------------------------------------------------------

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"","","","",.F.)

if nLastKey == 27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

//-------------------------------------------------------------------
// rotina RptDetail
//-------------------------------------------------------------------

rptstatus({|| rptdetail()})
return

static function rptdetail()

private _cTotal := 0
private _cImp    := {}
private _cTotDesp := 0
private _aCodPro := {}
private _cTotImp := 0
private _cTotFre := 0
private _cTotGer := 0
private _cTotIpi := 0
private _cTotDes := 0
PRIVATE _cNumSc :=""

_cfilsa2:=xfilial("SA2")
_cfilse4:=xfilial("SE4")
_cfilsc7:=xfilial("SC7")
_cfilsb5:=xfilial("SB5")
_cfilsb1:=xfilial("SB1")
_cfilscr:=xfilial("SCR")
sa2->(dbsetorder(1))
se4->(dbsetorder(1))
sc7->(dbsetorder(1))
sb5->(dbsetorder(1))
sb1->(dbsetorder(1))
scr->(dbsetorder(1))

sc7->(dbseek(_cfilsc7+mv_par01,.f.))

while !sc7->(eof()) .and.;
	sc7->c7_num <= mv_par02
	
	_cNum    := sc7->c7_num
	
	if sa2->(dbseek(_cfilsa2 + sc7->c7_fornece + sc7->c7_loja))
		_cCodFor  := sa2->a2_cod
		_cLoja	  := sa2->a2_loja
		_cNome    := sa2->a2_nome
		_cEnd     := sa2->a2_end
		_cBai     := sa2->a2_bairro
		_cCid     := alltrim(sa2->a2_mun)
		_cCep	  := transform(sa2->a2_cep,"@R 99999-999")
		_cFone    := alltrim(sa2->a2_ddd)+" - "+alltrim(sa2->a2_tel)
		_cCnpj    := transform(sa2->a2_cgc,"@R 99.999.999/9999-99")
		_CInsc    := sa2->a2_inscr
		_cUf      := sa2->a2_est
	else                         
		_cCodFor  := ""
		_cLoja    := ""
		_cNome    := ""
		_cEnd     := ""
		_cBai     := ""
		_cCid     := ""
		_cCep	  := ""
		_cFone    := ""
		_cCnpj    := ""
		_cInsc    := ""
		_cUf      := ""
	endif
	
	if sc7->(dbseek(_cfilsc7 + sc7->c7_num))
		_cCondpag := sc7->c7_cond
		_dEmissao := sc7->c7_emissao
		_cMenpv1  := sc7->c7_obs
		_cMenpv2  := ""
		_cMenpv3  := ""
		_cTpFrete := sc7->c7_tpfrete   
		_cMoeda   := iif(sc7->c7_moeda==1,"REAIS",iif(sc7->c7_moeda==2,"DÓLAR",iif(sc7->c7_moeda==5,"EURO","OUTRAS")))  
		_cDescp1   := sc7->c7_desc1
		_cDescp2   := sc7->c7_desc2
		_cDescp3   := sc7->c7_desc3
	else
		_cCondpag := ""
		_dEmissao := " / / "
		_cMenpv1  := ""
		_cMenpv2  := ""
		_cMenpv3  := ""             
		_cTpFrete := ""
		_cMoeda   := ""
		_cDescp1   := 0
		_cDescp2   := 0
		_cDescp3   := 0
	endif
	
	if se4->(dbSeek(_cfilse4 + _cCondpag))
		_cCond := se4->e4_descri
	else
		_cCond := ""
	endif
	
	_cNum   := sc7->c7_num
	_nVez   := 1
	_aItem  := {}
	_aRev   := {}
	_aQtd   := {}
	_aUnd   := {}
	_aDesc  := {}
	_aPreco := {}
	_aFrete := {}
	_aPrfin := {}
	_aEntr  := {}
	_aImp   := {}
	_aIpi   := {}
	_cDesc1 := ""
	_aCC	:= {}
	_aSC	:= {}

	_cPath 		:= GETTEMPPATH()
	_cArqWord	:= mv_par03
	_cAux		:= "" 
	_nAt		:= 0

	//	_cArquivo := GetPvProfString(GetEnvServer(),"RootPath","ERROR",GetADV97())
	//	_cArquivo += If(Right(_cArquivo,1) <> "\","\","") + mv_par03
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Verifica se o usuario escolheu um drive local (A: C: D:) caso contrario³
	³busca o nome do arquivo de modelo,  copia para o diretorio temporario  ³
	³do windows e ajusta o caminho completo do arquivo a ser impresso.      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If substr(_cArqWord,2,1) <> ":"
		_cAux 	:= _cArqWord
		_nAt	:= 1
		for nx := 1 to len(_cArqWord)
			_cAux := substr(_cAux,If(nx==1,_nAt,_nAt+1),len(_cAux))
			_nAt := at("\",_cAux)
			If _nAt == 0
				Exit
			Endif
		next nx
		CpyS2T(_cArqWord,_cPath, .T.)
		_cArqWord	:= _cPath+_cAux
	Endif
	

	
	// Inicializa o Ole com o MS-Word 97 ( 8.0 )
	oWord := OLE_CreateLink('TMsOleWord97')
	
	OLE_NewFile(oWord,_cArqWord)
	OLE_SetProperty(oWord, oleWdVisible,.t. )
	OLE_SetProperty(oWord, oleWdPrintBack,.t.)
	
	while !sc7->(Eof()) .and.;
		sc7->c7_num == _cNum .and.;
		_nVez <= 8     //ALTERAR PARA 8 ????????
		

		sb5->(dbseek(_cfilsb5 + sc7->c7_produto))
		_cDesc1:= sb5->b5_ceme
		
		sb1->(dbseek(_cfilsb1 + sc7->c7_produto))
		
		aadd(_aCodPro ,sc7->c7_produto)
		aadd(_aItem   ,sc7->c7_item)
		aadd(_aQtd    ,sc7->c7_quant) 
		aadd(_aRev    ,iif(empty(sb1->b1_revarte)," - ",sb1->b1_revarte))
		aadd(_aUnd    ,sc7->c7_um)
		aadd(_aIpi    ,sc7->c7_ipi)
		
		if upper(mv_par04)=="B5_CEME"
			aadd(_aDesc ,sb5->b5_ceme)
		elseif upper(mv_par04)=="B1_DESC"
			aadd(_aDesc ,sb1->b1_desc)
		else
			aadd(_aDesc ,sc7->c7_descri)
		endif
		
		aadd(_aPreco  ,sc7->c7_preco)
		aadd(_aFrete  ,sc7->c7_valfre)
		aadd(_aPrfin  ,sc7->c7_total)
		aadd(_aEntr   ,sc7->c7_datprf)
		aadd(_aImp    ,sc7->c7_valicm+sc7->c7_valipi)
		aadd(_aCC     ,sc7->c7_cc)
		aadd(_aSC     ,sc7->c7_numsc)
		
		_cTotal   := _cTotal + sc7->c7_total
		_cTotDes  := _cTotDes + sc7->c7_vldesc
		_cTotImp  := (_cTotImp + sc7->c7_valicm + sc7->c7_valipi)
		_cTotIpi  := _cTotIpi + sc7->c7_valipi
		_cTotFre  := _cTotFre + sc7->c7_valfre
		_cTotGer  := (_cTotGer + sc7->c7_total ) //+ SC7->C7_VALIPI + SC7->C7_VALICM + SC7->C7_VALFRE+SC7->C7_SEGURO + SC7->C7_DESPESA)
		_cContato := sc7->c7_contato
		_cTotDesp := sc7->c7_seguro + sc7->c7_despesa
//		_cNumSc   := sc7->c7_numsc
		_nVez     := _nVez + 1
		
		sc7->(dbskip())
		
	end
	
	scr->(dbseek(_cfilscr+"PC"+sc7->c7_num))
	
	_cComprad := UsrFullName(sc7->c7_user)
	
	If !empty(scr->cr_user)
		_cAprov := AllTrim(UsrFullName(scr->cr_user))
	Else
		_cAprov := ""
	endif
	
	OLE_SetDocumentVar(oWord,"cContato"  ,_cContato)	// Nome Contato
	OLE_SetDocumentVar(oWord,"cComprad"  ,_cComprad)	// Nome do Comprador
	OLE_SetDocumentVar(oWord,"cAprov"    ,_cAprov)		// Nome do Aprovador
//	OLE_SetDocumentVar(oWord,"cNumSc"    ,_cNumSc)		// Número da Solicitação de Compras
	OLE_SetDocumentVar(oWord,"cNome"     ,_cNome)		// Nome do Fornecedor
	OLE_SetDocumentVar(oWord,"cCodFor"   ,_cCodFor)		// Código do Fornecedor
	OLE_SetDocumentVar(oWord,"cLoja"     ,_cLoja)		// Loja do Fornecedor
	OLE_SetDocumentVar(oWord,"cEnd"      ,_cEnd)		// Endereço Fornecedor
	OLE_SetDocumentVar(oWord,"cBai"      ,_cBai)		// Bairro Fornecedor
	OLE_SetDocumentVar(oWord,"cCid"      ,_cCid)		// Cidade Fornecedor
	OLE_SetDocumentVar(oWord,"cUf"       ,_cUf)			// UF Fornecedor
	OLE_SetDocumentVar(oWord,"cFone"     ,_cFone)		// Fone Fornecedor
	OLE_SetDocumentVar(oWord,"cCnpj"     ,_cCnpj)		// CNPJ
	OLE_SetDocumentVar(oWord,"cInsc"     ,_cInsc)		// Inscrição Estadual
	OLE_SetDocumentVar(oWord,"cPed"      ,_cNum)		// Número do PC
	OLE_SetDocumentVar(oWord,"cData"     ,_dEmissao)	// Data de Emissão do PC
	OLE_SetDocumentVar(oWord,"cHora"     ,Time())		// Hora atual
	OLE_SetDocumentVar(oWord,"cCond"     ,_cCond)		// Condição de Pagamento
	OLE_SetDocumentVar(oWord,"cMenpv1"   ,_cMenpv1)		// Mensagem 01 PC
	OLE_SetDocumentVar(oWord,"cMenpv2"   ,_cMenpv2)		// Mensagem 02 PC
	OLE_SetDocumentVar(oWord,"cMenpv3"   ,_cMenpv3)		// Mensagem 03 PC
	OLE_SetDocumentVar(oWord,"cTpFrete"  ,iif(_cTpFrete=="C","CIF","FOB"))	// Tipo de Frete
	OLE_SetDocumentVar(oWord,"cMoeda"    ,_cMoeda)		// Moeda
	OLE_SetDocumentVar(oWord,"cDescp1"    ,_cDescp1)	// Desconto 1
	OLE_SetDocumentVar(oWord,"cDescp2"    ,_cDescp2)	// Desconto 2
	OLE_SetDocumentVar(oWord,"cDescp3"    ,_cDescp3)	// Desconto 3
	
	_nLin := Len(_aItem)

	_nVez := 0
	
	for _nCont := 1 to 12
		
		_nVez    := _nVez + 1
		_cItem   := '"cItem'  + str(_nVez,1,0) + '"'
		_cCodPro := '"cCodPro'+ str(_nVez,1,0) + '"'
		_cQtd    := '"cQtd'   + str(_nVez,1,0) + '"'
		_cUnd    := '"cUnd'   + str(_nVez,1,0) + '"'
		_cIpi    := '"cIpi'   + str(_nVez,1,0) + '"'
		_cDesc   := '"cDesc'  + str(_nVez,1,0) + '"'
		_cPreco  := '"cPreco' + str(_nVez,1,0) + '"'
		_cFrete  := '"cFrete' + str(_nVez,1,0) + '"'
		_cImp    := '"cImp'   + str(_nVez,1,0) + '"'
		_cPrfin  := '"cPrfin' + str(_nVez,1,0) + '"'
		_cEntr   := '"cEntr'  + str(_nVez,1,0) + '"'
		_cCC     := '"cCC'    + str(_nVez,1,0) + '"'
		_cSC     := '"cSC'    + str(_nVez,1,0) + '"'
		
		if _nVez <= _nLin
			OLE_SetDocumentVar(oWord,&_cItem    ,_aItem[_nVez])									// Número do Item
			OLE_SetDocumentVar(oWord,&_cCodPro  ,_aCodPro[_nVez])								// Código do Produto
			OLE_SetDocumentVar(oWord,&_cUnd     ,_aUnd [_nVez])									// Unidade de Medida
			OLE_SetDocumentVar(oWord,&_cIpi     ,transform(_aIpi [_nVez],"@E 99.99"))			// IPI
			OLE_SetDocumentVar(oWord,&_cQtd     ,transform(_aQtd[_nVez],"@E 9999,999.99"))		// Quantidade
			OLE_SetDocumentVar(oWord,&_cDesc    ,_aDesc[_nVez])									// Descrição Produto
			OLE_SetDocumentVar(oWord,&_cPreco   ,transform(_aPreco[_nVez],"@E 9999,999.999"))	// Preço 
			OLE_SetDocumentVar(oWord,&_cFrete   ,transform(_aFrete[_nVez],"@E 9999,999.999"))	// Frete
			OLE_SetDocumentVar(oWord,&_cPrfin   ,transform(_aPrfin[_nVez],"@E 9999,999.999"))	// Preço Final
			OLE_SetDocumentVar(oWord,&_cImp     ,transform(_aImp[_nVez],"@E 9999,999.999"))		// Impostos
			OLE_SetDocumentVar(oWord,&_cEntr    ,_aEntr[_nVez])									// Entrega
			OLE_SetDocumentVar(oWord,&_cCC      ,_aCC[_nVez])									// Centro de Custo
			OLE_SetDocumentVar(oWord,&_cSC      ,_aSC[_nVez])									// Solicitação de Compras
		else
			OLE_SetDocumentVar(oWord,&_cItem    ," ")
			OLE_SetDocumentVar(oWord,&_cCodPro  ," ")
			OLE_SetDocumentVar(oWord,&_cUnd     ," ")
			OLE_SetDocumentVar(oWord,&_cIpi     ," ")
			OLE_SetDocumentVar(oWord,&_cQtd     ," ")
			OLE_SetDocumentVar(oWord,&_cDesc    ," ")
			OLE_SetDocumentVar(oWord,&_cPreco   ," ")
			OLE_SetDocumentVar(oWord,&_cFrete   ," ")
			OLE_SetDocumentVar(oWord,&_cPrfin   ," ")
			OLE_SetDocumentVar(oWord,&_cImp     ," ")
			OLE_SetDocumentVar(oWord,&_cEntr    ," ")
			OLE_SetDocumentVar(oWord,&_cCC      ," ")
			OLE_SetDocumentVar(oWord,&_cSC      ," ")
		endif
	next

	OLE_SetDocumentVar(oWord, &('"cTotal"')     ,transform(_cTotal ,"@E 9999,999.999")) 	// Total pedido
	OLE_SetDocumentVar(oWord, &('"cTotImp"')    ,transform(_cTotImp,"@E 9999,999.999")) 	// Total Impostos
	OLE_SetDocumentVar(oWord, &('"cTotFre"')    ,transform(_cTotFre,"@E 9999,999.999")) 	// Total Fretes
	OLE_SetDocumentVar(oWord, &('"cTotGer"')    ,transform(_cTotGer,"@E 9999,999.999")) 	// Total Geral do Pedido
	OLE_SetDocumentVar(oWord, &('"cTotIpi"')    ,transform(_cTotIpi,"@E 9999,999.999"))		// Total Ipi
	OLE_SetDocumentVar(oWord, &('"cTotDes"')    ,transform(_cTotDes,"@E 9999,999.999")) 	// Total Descontos
	OLE_SetDocumentVar(oWord, &('"cTotDesp"')   ,transform(_cTotDesp,"@E 9999,999.999"))	// Total Despesas
	//--Atualiza Variaveis
	OLE_UpDateFields(oWord)
	
	Alert("PAUSA - AGUARDANDO A EMISSAO DO DOCUMENTO")
	
end
Return


//ÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Descricao ³Selecionar os Arquivos do Word                              ³
//ÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
User Function fOpenWord()

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= "Modelo de Documentos(*.DOT)  |*.DOT | "														
Local cNewPathArq	:= cGetFile( cTipo , "Seleccione el archivo *.DOT" )									

IF !Empty( cNewPathArq )
	IF Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( "DOT" ) )	
		Aviso( "Arquivo Selecionado" , cNewPathArq , { "OK" } )
    Else
    	MsgAlert( "Arquivo invalido " )
    	Return
    EndIF
Else
    Aviso("Seleção cancelada!" , "Voce cancelou a selecao do arquivo." ,{ "OK" } )
    Return
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpa o parametro para a Carga do Novo Arquivo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")  
IF lAchou := ( SX1->( dbSeek( cPerg + "03" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par03 := cNewPathArq
	MsUnLock()
EndIF	
dbSelectArea( cSvAlias )
Return( .T. )


//***********************************************************************
static function _pergsx1()
//***********************************************************************


_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do pedido          ?","mv_ch1","C",06,0,0,"G",space(60)       ,"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC7"})
aadd(_agrpsx1,{cperg,"02","Ate o pedido       ?","mv_ch2","C",06,0,0,"G",space(60)       ,"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC7"})
aadd(_agrpsx1,{cperg,"03","Arquivo Modelo     ?","mv_ch3","C",60,0,0,"G","ExecBlock('FOPENWORD',.f.,.f.)","mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Descricao Produto  ?","mv_ch4","C",10,0,0,"G",space(60)       ,"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
