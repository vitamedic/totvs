/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MODELO3 ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

User Function AxModelo3(cMaster,cDetail,cCpoMas,cCpoDet,cCpoKey, cTitulo,cOpcoes,aCores,cFiltro)

LOCAL 	i	// contador para loops
LOCAL 	aOpc		:= {"P","V","I","A","E","N","L"}  // opções para habilitar as chamadas
LOCAL 	aChamadas	:= {{ "Pesquisar","AxPesqui", 0 , 1},;
{ "Visualizar","U_Mod3Exec(2)", 0 , 2},;
{ "Incluir","U_Mod3Exec(1)", 0 , 3},;
{ "Alterar","U_Mod3Exec(3)", 0 , 4, 20 },;
{ "Excluir","U_Mod3Exec(4)", 0 , 5, 21 },;
{ "Env.Prop.","U_EnvProp()", 0 , 2 },;
{ "Legenda","U_leg002()", 0 , 2}}

// inicializa variáveis do mBrowse
PRIVATE cCADASTRO 	:= cTitulo
PRIVATE	aRotina 	:= {}


// utiliza variáveis privadas para acesso em outras funções
PRIVATE _cMaster,_cDetail,_cCpoMas,_cCpoDet, _cCpoKey, _cTitulo
_cMaster := cMaster
_cDetail := cDetail
_cCpoMas := cCpoMas
_cCpoDet := cCpoDet
_cCpoKey := cCpoKey
_cTitulo := cTitulo


// monta array de rotinas com as opções passadas como parâmetro
// obs: o array aRotina é utilizado pela função mBrowse
for i := 1 to len(aChamadas)
	if aOpc[i] $ cOpcoes
		AADD(aRotina, aChamadas[i])
	endif
next i

dbselectarea("SZL")
SZL->(DbSetFilter({|| SZL->ZL_PROPOS<>space(8)},"szl->zl_propos<>'        '"))

// executa a mBrowse
dbSelectArea(cMaster)
dbSetOrder(3)

mBrowse( 6,  01,22,75, cMaster,,,,cFiltro,,aCORES)

dbselectarea("SZL")
dbSetOrder(1)
szl->(dbclearfil())

Return(NIL)


// Processa Modelo 3 de acordo com a chamada (Incluir, Visualizar, Alterar ou Excluir)
User Function Mod3exec(_nOpc)

LOCAL i
Local _mArea     := {"SB1","SZL","SZM","SZN","SZP","SA3"}
Local _mAlias    := {}

PRIVATE nOpcE		:=	3
PRIVATE nOpcG		:=	3
PRIVATE nUsado		:=	0
PRIVATE aHeader     := {}
PRIVATE aCols		:= {}        
PRIVATE M->ZM_CODPRO := ""

/*if (SZL->ZL_STATUS=="3" .or. SZL->ZL_STATUS=="4") .and. (_nOpc==3 .or. _nOpc==4)
	MsgBox("Não é permitido alterar/excluir propostas já enviadas ou finalizadas!")
	return()
endif*/

_nRet := 0

_mAlias := U_SalvaAmbiente(_mArea)

// configura variáveis do modelo 3 de acordo com a chamada em nOpc
Do Case
	Case _nOpc==1 ; nOpcE:=3 ; nOpcG:=3
	Case _nOpc==2 ; nOpcE:=2 ; nOpcG:=2
	Case _nOpc==3 ; nOpcE:=3 ; nOpcG:=3
	Case _nOpc==4 ; nOpcE:=2 ; nOpcG:=2
EndCase

// inicializa variaveis de memoria da Enchoice (Master)
dbSelectArea(_cMaster)
RegToMemory(_cMaster,_nOpc==1)

// monta array com campos da enchoice (Master) de acordo com o SX3
aCpoEnchoice := {}
dbSelectArea("SX3")
dbSetorder(1)
dbSeek(_cMaster)
While !Eof().And.(x3_arquivo==_cMaster)
	If X3USO(x3_usado) .And.cNivel>=x3_nivel
		Aadd( aCpoEnchoice, x3_campo )
	endif
	dbSkip()
enddo

// monta array de cabeçalho com informações dos campos do aCols (PICTURE, TAMANHO, F3, etc) de acordo com o SX3
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(_cDetail)
aHeader:={}

While !SX3->(Eof()).And.(sx3->x3_arquivo==_cDetail)
	// não considera o campo de amarração
	If Alltrim(x3_campo)==_cCpoDet
		dbSkip()
		Loop
	Endif
	// inclui no aHeader somente se está em uso e de acordo com o nivel de usuario
	If X3USO(x3_usado) .And.cNivel>=x3_nivel .and. x3_campo<>"ZM_QTDE   " .and. x3_campo<>"ZM_GERAPV " .and. x3_campo<>"ZM_SALDO  "
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )    // cria o array com as definições do SX3
	Endif

	sx3->(dbSkip())
Enddo


nPosCODPRO 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_CODPRO"})
nPosNUMITEM	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_NUMITEM"})
nPosDESC 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_DESC"})
nPosQTDE1 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE1"})
nPosUM1		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_UM1"})
nPosQTDE2 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE2"})
nPosUM2		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_UM2"})
nPosPRCUNI 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUNI"})
nPosPRCUN2 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUN2"})
nPosTOTITEM	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_TOTITEM"})
nPosCOLOC 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_COLOC"})
nPosFORMA 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_FORMA"})
nPosOBS 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_OBS"})

If _nOpc==1

	// Na inclusão inicializa os campos vazios
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
Else
	aCols:={}
	dbSelectArea(_cDetail)
	dbSetOrder(1)
	cVar := "M->"+_cCpoMas
	dbSeek(xFilial()+&cVar.) // procura os itens de acordo com a amarração Master x Detail
	While !eof() .and. (&_cCpoDet. == &cVar.) // Executa loop para carregar os registros no aCols
		AADD(aCols,Array(nUsado+1)) // inicializa a linha do aCols
		For _ni:=1 to nUsado  // carrega os campos do arquivo
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F. // incializa campo de delatado com falso (não deletado)
		dbSkip()
	Enddo
	
	if Empty(aCols)
		aCols:={Array(nUsado+1)}
		aCols[1,nUsado+1]:=.F.
		For _ni:=1 to nUsado
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Next
	endif	
Endif

If Len(aCols)>0
	cAliasEnchoice	:=	_cMaster
	cAliasGetD		:=	_cDetail
	cLinOk			:=	"U_ValLinha()"
	cTudOk			:=	"U_LICPropNum()"
	cFieldOk		:=	"U_ValCampo()"

	aCols := Asort(aCols,,,{|x,y|x[1]<y[1]})
	
/*
Private _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,,,,,,,400)
Parametros:
lRet=Retorno .T. Confirma / .F. Abandona
cTitulo=Titulo da Janela
cAlias1=Alias da Enchoice
cAlias2=Alias da GetDados
aMyEncho=Array com campos da Enchoice
cLinOk=LinOk
cTudOk=TudOk
nOpcE=nOpc da Enchoice
nOpcG=nOpc da GetDados
cFieldOk=validacao para todos os campos da GetDados
lVirtual=Permite visualizar campos virtuais na enchoice
nLinhas=Numero Maximo de linhas na getdados
aAltEnchoice=Array com campos da Enchoice Alteraveis
nFreeze=Congelamento das colunas.
aButtons= array com botões de usuário na enchoicebar
aCordW = coordenadas da janela
nSizeHeader = altura da enchoice

*/
//	_lRet	:=	Modelo3(_cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	_lRet	:=	Modelo3(_cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,,,,,{135,000,800,1232},250)

	if _lRet
	
		if _nOpc==1 .or. _nOpc==3 .or. _nOpc==4 // Incluir, alterar ou excluir
			// Grava os campos de cabeçalho
			if _nOpc==1 .or. _nOpc==3  // incluir ou alterar
			   M->ZL_STATUS := VerForma()
				
				dbSelectArea(_cMaster)
				Reclock(_cMaster,_nOpc==1)
				FieldPut(1,xFilial(_cMaster))
				For i := 1 to len(aCpoEnchoice)
					cCampo := "M->" + aCpoEnchoice[i]
					cConteudo := &cCampo.
					FieldPut(FieldPos(aCpoEnchoice[i]),cConteudo)
				next i
				MsUnlock()
				
				if _nOpc==1
					ConfirmSX8()
				endif
			endif
			
			// inclui registros de detalhe
			if _nOpc==1  // incluir
				dbSelectArea(_cDetail)
				For i := 1 to Len(aCols)
					if aCols[i][Len(aHeader)+1] == .f.
						Reclock(_cDetail,.t.)
						FieldPut(1,xFilial(_cDetail))
						FieldPut(FieldPos(_cCpoDet), &_cCpoMas.)
						for j := 1 to Len(aHeader)
							FieldPut(FieldPos(aHeader[j][2]),aCols[i][j])
						next j
                  
						// ATUALIZA CAMPOS QUE NÃO PODEM SER VISUALIZADOS NA PROPOSTA
						if SZL->ZL_UMPROP == "1" 
							SZM->ZM_QTDE 	:= SZM->ZM_QTDE1
							SZM->ZM_SALDO 	:= SZM->ZM_QTDE1
						else
							SZM->ZM_QTDE 	:= SZM->ZM_QTDE2
							SZM->ZM_SALDO 	:= SZM->ZM_QTDE2
						endif
												
						MsUnlock()
					endif
				Next i
			endif
			
			// altera registros antigos, apaga deletados e grava novos itens
			if _nOpc==3  // alterar
				
				// Procura e guarda a posição do campo chave de ligação
				For i := 1 to Len(aHeader)
					if alltrim(aHeader[i][2])==alltrim(_cCpoKey)
						nPosKey := i
					endif
				Next i
				
				// verifica registros anteriores, atualizando-os
				dbSelectArea(_cDetail)
				dbSetOrder(1)
				cVar := "M->"+_cCpoMas
				dbSeek(xFilial()+&cVar.)
				While !eof() .and. (&_cCpoDet. == &cVar.)
					For i := 1 to Len(aCols)
						if aCols[i][nPosKey] == &_cCpoKey.
							if aCols[i][Len(aHeader)+1] == .t.
								Reclock(_cDetail,.f.)
								dbDelete()
								MsUnlock()
							else
								Reclock(_cDetail,.f.)
								
								for j := 1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[j][2]),aCols[i][j])
								next j
								
								// ATUALIZA CAMPOS QUE NÃO PODEM SER VISUALIZADOS NA PROPOSTA
								if SZL->ZL_UMPROP == "1" 
									SZM->ZM_QTDE 	:= SZM->ZM_QTDE1
									SZM->ZM_SALDO 	:= SZM->ZM_QTDE1
								else
									SZM->ZM_QTDE 	:= SZM->ZM_QTDE2
									SZM->ZM_SALDO 	:= SZM->ZM_QTDE2
								endif

								MsUnlock()
								aCols[i][Len(aHeader)+1] := .t.
							endif
						endif
					Next i
					dbSkip()
				enddo
				
				// inclui novos itens
				For i := 1 to Len(aCols)
					if aCols[i][Len(aHeader)+1] == .f.
						Reclock(_cDetail,.t.)
						FieldPut(1,xFilial(_cDetail))
						FieldPut(FieldPos(_cCpoDet), &_cCpoMas.)
						for j := 1 to Len(aHeader)
							FieldPut(FieldPos(aHeader[j][2]),aCols[i][j])
						next j

						// ATUALIZA CAMPOS QUE NÃO PODEM SER VISUALIZADOS NA PROPOSTA
						if SZL->ZL_UMPROP == "1" 
							SZM->ZM_QTDE 	:= SZM->ZM_QTDE1
							SZM->ZM_SALDO 	:= SZM->ZM_QTDE1
						else
							SZM->ZM_QTDE 	:= SZM->ZM_QTDE2
							SZM->ZM_SALDO 	:= SZM->ZM_QTDE2
						endif

						MsUnlock()
						aCols[i][Len(aHeader)+1] := .t.
					endif
				Next i
				
			endif
			
			// Exclusão
			if _nOpc==4 // apagar
				
				// apaga o cabeçalho
				dbSelectArea(_cMaster)
				Reclock(_cMaster,.f.)
				dbDelete()
				MsUnlock()
				
				// apaga os detalhes
				dbSelectArea(_cDetail)
				dbSetOrder(1)
				cVar := "M->"+_cCpoMas
				dbSeek(xFilial()+&cVar.)
				While !eof() .and. (&_cCpoDet. == &cVar.)
					Reclock(_cDetail,.f.)
					dbDelete()
					MsUnlock()
					dbSkip()
				enddo
			endif
			
		endif
	endif	
	
endif

U_VoltaAmbiente(_mAlias)

Return()


// Monta vetor tipo Header de acordo com o vetor aCampos
User Function CriaHeader(cAlias,aCampos)

aRet := {}

cAliasAnt := Alias()
nIndAnt := IndexOrd()
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
nUsado := 0
while SX3->(!Eof()) .and. SX3->X3_ARQUIVO==cAlias
	If !Empty(X3_USADO) .and. (cNivel >= X3_NIVEL) .and. ASCAN(aCampos, X3_CAMPO)<>0
      nUsado := nUsado + 1
		AADD(aRet,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
			X3_TAMANHO, X3_DECIMAL, X3_VALID,;
			X3_USADO, X3_TIPO, X3_ARQUIVO } )
	endif
	SX3->(dbSkip())
enddo

dbSelectArea(cAliasAnt)
dbSetOrder(nIndAnt)

Return(aRet)


// Monta vetor tipo Cols de acordo com os parametros
User Function CriaCols(cAlias,nIndice,cCpoAmarr,cChave,aHeader,cFiltro)

cAliasAnt := Alias()
nIndAnt := IndexOrd()

if cFiltro==nil
	cFiltro := "1==1"
endif

dbSelectArea(cAlias)
dbSetOrder(nIndice)
dbSeek(xFilial(cAlias)+cChave)
nCnt := 0
while !Eof() .and. (&cCpoAmarr. == cChave) .and. &cFiltro.
	nCnt := nCnt + 1
	dbSkip()
enddo
                                             	
if nCnt<>0
	aRet := Array(nCnt,len(aHeader)+1)
	nCnt := 0
	dbSeek(xFilial(cAlias)+cChave)
	while !Eof() .and. (&cCpoAmarr. == cChave) .and. &cFiltro.
		nCnt := nCnt + 1
		For i := 1 to Len(aHeader)
		    aRet[nCnt][i] := &(cAlias+"->"+aHeader[i][2])
		next i
	    aRet[nCnt][len(aHeader)+1] := .f. //Flag de Delecao
    
		dbSkip()
	enddo
else
	aRet := Array(1,len(aHeader)+1)
	For i := 1 to Len(aHeader)
		do case
			case aHeader[i][8]=="C"
			    aRet[1][i] := space(aHeader[i][4])
			case aHeader[i][8]=="N"
			    aRet[1][i] := 0
			case aHeader[i][8]=="D"
			    aRet[1][i] := CTOD("  /  /  ")
			case aHeader[i][8]=="L"
			    aRet[1][i] := .t.
		endcase
	next i
    aRet[1][len(aHeader)+1] := .f. //Flag de Delecao
endif	


dbSelectArea(cAliasAnt)
dbSetOrder(nIndAnt)

Return(aRet)

User Function ConverteUM(_cProd, _nVal, _cUM)

Local _mArea     := {"SB1"}
Local _mAlias    := {}
_nRet := 0

_mAlias := U_SalvaAmbiente(_mArea)

dbSelectArea("SB1")
dbSetOrder(1)
if dbSeek(xFilial("SB1")+_cProd)
	if _cUM=="1"
	    if SB1->B1_TIPCONV=="M"
			_nRet := _nVal * SB1->B1_CONV
		elseif SB1->B1_TIPCONV=="D"
			_nRet := _nVal / SB1->B1_CONV
		else
			_nRet := _nVal	
		endif
	else
	    if SB1->B1_TIPCONV=="M"
			_nRet := _nVal / SB1->B1_CONV
		elseif SB1->B1_TIPCONV=="D"
			_nRet := _nVal * SB1->B1_CONV
		else
			_nRet := _nVal	
		endif
	endif	
else
	_nRet := _nVal
endif

If _nRet % 1 <> 0
   _nret := Int(_nRet) + 1
EndIf
   
U_VoltaAmbiente(_mAlias)

Return(_nRet)

User Function RetUMSB1(_cProd,_cUM)

Local _mArea     := {"SB1"}
Local _mAlias    := {}

_mAlias := U_SalvaAmbiente(_mArea)

_cRet := "  "
dbSelectArea("SB1")
dbSetOrder(1)
if dbSeek(xFilial("SB1")+_cProd)
	if _cUM="1"
		_cRet := SB1->B1_UM    
	else
		_cRet := SB1->B1_SEGUM    
	endif		
endif		

U_VoltaAmbiente(_mAlias)

Return(_cRet)


// Atualiza o numero da proposta com o proximo numero
User Function LICPropNum()

if empty(M->ZL_PROPOS)

	dbSelectArea("SZL")

	nReg := recno()

/*	
	// As linhas abaixo foram substituídas pelo select Max pois o comando DbgoBottom estava apresentando falhas - Alex - 27/03/11
	dbSetOrder(3)
	dbGoBottom()
   

	_cNum := strzero(Val(SubStr(SZL->ZL_PROPOS,1,5))+1,5)
	_cAno := substr(dtoc(ddatabase),7,2)
	_cRet := _cNum+"/"+_cAno
*/

	_cquery:=" SELECT"
	_cquery+=" MAX(ZL_PROPOS) ZL_PROPOS"
	_cquery+=" FROM "
	_cquery+=retsqlname("SZL")+" SZL"
	_cquery+=" WHERE D_E_L_E_T_=' '"
	_cquery+=" AND ZL_FILIAL='"+xfilial("SZL")+"'"

	_cquery:=changequery(_cquery)
				
	tcquery _cquery new alias "TMP1"
	tmp1->(dbgotop())

	_cNum := strzero(Val(SubStr(tmp1->zl_propos,1,5))+1,5)
	_cAno := substr(dtoc(ddatabase),9,2)
	_cRet := _cNum+"/"+_cAno
	
	tmp1->(dbclosearea())
	
	dbSelectArea("SZL")
	dbGoto(nReg)

	M->ZL_PROPOS := _cRet

endif

Return(.t.)                               


User Function ChkSA1(cCGC)

Local _mArea     := {"SA1"}
Local _mAlias    := {}
Local lRet := .t.

_mAlias := U_SalvaAmbiente(_mArea)

dbSelectArea("SA1")
dbSetOrder(3)  
dbSeek(xFilial("SA1")+cCGC)
if !Eof()
	M->ZP_NOMLIC 	:= SA1->A1_NOME
	M->ZP_CODCLI 	:= SA1->A1_COD
	M->ZP_LJCLI 	:= SA1->A1_LOJA
	M->ZP_CODREP	:= SA1->A1_VEND
	M->ZP_UF			:= SA1->A1_EST
	M->ZP_FONE		:= SA1->A1_TEL
	M->ZP_FAX		:= SA1->A1_FAX
ENDIF	
	
U_VoltaAmbiente(_mAlias)

Return(lRet)


User Function ValCampo()

LOCAL _i
LOCAL _lRet := .t.
Local _mArea     := {"SB1"}
Local _mAlias    := {}

_mAlias := U_SalvaAmbiente(_mArea)
_ncasas := M->ZL_CASASD // Alterado para buscar da Memoria

// Valida codigo do produto para puxar a descricao
if alltrim(__READVAR)=="M->ZM_CODPRO" .and. !Empty(M->ZM_CODPRO) .and. !aCols[n][len(aHeader)+1]

	dbSelectArea("SB1")
	dbSetOrder(1)
	if dbSeek(xFilial("SB1")+M->ZM_CODPRO)     
		aCols[n][nPosDESC] 		:= SB1->B1_DESC
		aCols[n][nPosUM1] 		:= SB1->B1_UM
		aCols[n][nPosUM2] 		:= SB1->B1_SEGUM
//		aCols[n][nPosQTDE1] 		:= M->ZM_QTDE1
//		aCols[n][nPosQTDE2] 		:= M->ZM_QTDE2
		aCols[n][nPosPRCUNI]		:= Round(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]),_ncasas) 
		aCols[n][nPosPRCUN2]		:= ROUND(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]) / ConvUM(1,aCols[n][nPosCODPRO]),_ncasas) 
//		aCols[n][nPosTOTITEM] 	:= M->ZM_TOTITEM   
	else
		_lRet := .f.
		MsgBox("Codigo de Produto Não Encontrado!")
	endif

/*	if PrecoTab(M->ZL_TAB,M->ZM_CODPRO)==0
		_lRet := .f.
		MsgBox("Produto não encontrado na tabela de preços informada!")
	endif*/
		
endif

// Converte campos de quantidade
if M->ZL_UMPROP == "1"
if alltrim(__READVAR)=="M->ZM_QTDE1" .and. !Empty(M->ZM_QTDE1)
	aCols[n][nPosQTDE2] 		:= U_Conv1to2(aCols[n][nPosCODPRO], M->ZM_QTDE1)
	aCols[n][nPosPRCUNI]		:= Round(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]),_ncasas)                  
	aCols[n][nPosPRCUN2]		:= Round(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]) / ConvUM(1,aCols[n][nPosCODPRO]),4)
	aCols[n][nPosTOTITEM] 	:= aCols[n][nPosPRCUNI] * M->ZM_QTDE1
endif
if alltrim(__READVAR)=="M->ZM_QTDE2" .and. !Empty(M->ZM_QTDE2) 
	aCols[n][nPosQTDE1] 		:= U_Conv2to1(aCols[n][nPosCODPRO], M->ZM_QTDE2)
	aCols[n][nPosPRCUNI]		:= Round(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]),_nCasas)
	aCols[n][nPosPRCUN2]		:= PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]) / ConvUM(1,aCols[n][nPosCODPRO])
	aCols[n][nPosTOTITEM] 	:= aCols[n][nPosPRCUN2] * M->ZM_QTDE2
endif                 
else 
if alltrim(__READVAR)=="M->ZM_QTDE1" .and. !Empty(M->ZM_QTDE1)
	aCols[n][nPosQTDE2] 		:= U_Conv1to2(aCols[n][nPosCODPRO], M->ZM_QTDE1)
	aCols[n][nPosPRCUNI]		:= Round(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]),_ncasas)                  
	aCols[n][nPosPRCUN2]		:= PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]) / ConvUM(1,aCols[n][nPosCODPRO])
	aCols[n][nPosTOTITEM] 	:= aCols[n][nPosPRCUNI] * M->ZM_QTDE1 
endif
if alltrim(__READVAR)=="M->ZM_QTDE2" .and. !Empty(M->ZM_QTDE2) 
	aCols[n][nPosQTDE1] 		:= U_Conv2to1(aCols[n][nPosCODPRO], M->ZM_QTDE2)
	aCols[n][nPosPRCUNI]		:= Round(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]),_nCasas)
	aCols[n][nPosPRCUN2]		:= ROUND(PrecoTab(M->ZL_TAB,aCols[n][nPosCODPRO]) / ConvUM(1,aCols[n][nPosCODPRO]),_ncasas)
	aCols[n][nPosTOTITEM] 	:= aCols[n][nPosPRCUN2] * M->ZM_QTDE2 
endif                 

endif


// calcula preço total com base na quantidade e na unidade de medida escolhida
                                                                    

if alltrim(__READVAR)=="M->ZM_PRCUN2" .and. !Empty(M->ZM_PRCUN2)  .and. Alltrim(cUserName) $ Alltrim(Getnewpar("MV_LICAUT","Silvia")) // .or. Alltrim(Substr(cUsuario,7,15))=="Silvia")
	aCols[n][nPosTOTITEM] 	:= M->ZM_PRCUN2 * aCols[n][nPosQTDE2]
	aCols[n][nPosPRCUNI]	:= Round(aCols[n][nPosTOTITEM] / aCols[n][nPosQTDE1],_nCasas)
endif

if alltrim(__READVAR)=="M->ZM_PRCUNI" .and. !Empty(M->ZM_PRCUNI)  .and. Alltrim(cUserName) $ Alltrim(Getnewpar("MV_LICAUT","Silvia")) //.or. Alltrim(Substr(cUsuario,7,15))=="Silvia")
	aCols[n][nPosTOTITEM] 	:= M->ZM_PRCUNI * aCols[n][nPosQTDE1]
	aCols[n][nPosPRCUN2]	:= ROUND(aCols[n][nPosTOTITEM] / aCols[n][nPosQTDE2],_ncasas)
endif

if (Alltrim(__READVAR)=="M->ZM_PRCUNI" .or. Alltrim(__READVAR)=="M->ZM_PRCUN2" ).and. !Alltrim(cUserName) $ Alltrim(Getnewpar("MV_LICAUT","Silvia")) //.and. alltrim(Substr(cUsuario,7,15))<>"Silvia"
	_lRet := .f.
endif

SysRefresh()

U_VoltaAmbiente(_mAlias)

return(_lRet)


User Function ValLinha()

LOCAL _i
LOCAL _lRet := .t.
Local _mArea     := {"SB1"}
Local _mAlias    := {}

_mAlias := U_SalvaAmbiente(_mArea)

if !aCols[n][len(aHeader)+1] // nao deletado
	for _i := 1 to len(aCols)
	
		if _i<>n .and. aCols[_i][2]==aCols[n][2] .and. !aCols[_i][len(aHeader)+1]
			_lRet := .f.
		endif
	next _i           
	
	if Empty(aCols[n][2])
		_lRet := .f.
	endif	

	dbSelectArea("SB1")
	dbSetOrder(1)
	if !dbSeek(xFilial("SB1")+aCols[n][2])
			_lRet := .f.
	endif	
endif

if !_lret
		MsgBox("Produto já informado ou inválido!")
endif	

U_VoltaAmbiente(_mAlias)

return(_lRet)

User Function VerPos(cNum, cProd, cConc)

LOCAL _cNosCod,_nRet
Local _mArea     := {"SZN"}
Local _mAlias    := {}


_mAlias := U_SalvaAmbiente(_mArea)

dbSelectArea("SZN")
dbSetOrder(2)
dbSeek(xFilial("SZN")+cNum+cProd+cConc)
if !SZN->(Eof())
	_nRet := SZN->ZN_COLOC
else
	_nRet := 0
endif

U_VoltaAmbiente(_mAlias)

Return(_nRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna data por extenso                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User function DataExt(_dData)

_nDia := day(_dData)
_nMes := month(_dData)
_nAno := year(_dData)

do case
	case _nMes==1
		_cMes := "Janeiro"
	case _nMes==2
		_cMes := "Fevereiro"
	case _nMes==3
		_cMes :="Março"
	case _nMes==4
		_cMes := "Abril"
	case _nMes==5
		_cMes := "Maio"
	case _nMes==6
		_cMes := "Junho"
	case _nMes==7
		_cMes := "Julho"
	case _nMes==8
		_cMes := "Agosto"
	case _nMes==9
		_cMes := "Setembro"
	case _nMes==10
		_cMes := "Outubro"
	case _nMes==11
		_cMes := "Novembro"
	case _nMes==12
		_cMes := "Dezembro"
end case

_cRet := Alltrim(str(_nDia)) + " de " + _cMes + " de " + Alltrim(str(_nAno))

Return(_cRet)

// Cria um arquivo Temporário baseado nos parametros
User Function CriaTMP(_cAlias, _cChave, _aCampos, _cPar)
	
	LOCAL _aRet, _cArqTmp, _cIndTmp

	_cArqTmp := Criatrab(_aCampos,.t.)

	dbUseArea(.t.,,_cArqTmp,_cAlias,.f.,.f.)

	_cIndTmp	:= Criatrab(,.f.)
	      
	dbSelectArea(_cAlias)
	Indregua(_cAlias,_cIndTmp,_cChave,_cPar,,"Selecionando registros...")
	
	_aRet := {}
	
	AADD(_aRet, _cArqTmp )
	AADD(_aRet, _cIndTmp )	
	
Return(_aRet)

// Fecha e apaga arquivos temporários
User Function ApagaTMP(_aTmp)

	Local	_lRet := .t.
                	
	if file(_aTmp[1]+GetDBExtension())
		ferase(_aTmp[1]+GetDBExtension())
	else
		_lRet := .f.
	endif

	if file(_aTmp[2]+OrdBagExt())
		ferase(_aTmp[2]+OrdBagExt())
	else
		_lRet := .f.
	endif
		
Return(_lRet)

User Function EnvProp()

PRIVATE _cPerg := "LICENV"   

	if SZL->ZL_STATUS == "2"
		if pergunte(_cPerg,.T.)
		      
	      if mv_par01==1
			   U_LICR002(SZL->ZL_PROPOS)
			elseif mv_par01==2
			   U_LICR006(SZL->ZL_PROPOS)
			endif
							   
			SZL->(Reclock("SZL",.f.))	
			SZL->ZL_STATUS := "3"
			SZL->(MsUnlock())	

       endif
	else
		MsgBox("Esta proposta nao pode ser enviada!")	
	endif
		
Return()

Static Function ConvUM(nVal,cProd)

dbSelectArea("SB1")
dbSetOrder(1)
if dbSeek(xFilial("SB1")+cProd)
	if SB1->B1_TIPCONV=="M"	
		nRet := nVal * SB1->B1_CONV
	elseif SB1->B1_TIPCONV=="D"	
		nRet := nVal / SB1->B1_CONV
	else
		nRet := 0
	endif	
else
	nRet := 0
endif

Return(nRet)


Static Function VerForma()

LOCAL _cRet := "2"

for _i := 1 to Len(aCols)
	if aCols[_i][nPosFORMA] == "S"
		_cRet := "1"
	endif
next _i	

return(_cRet)

User Function Conv1to2(cProd,nQtde)

nRet := 0

dbSelectArea("SB1")
dbSetOrder(1)
if dbSeek(xFilial("SB1")+cProd)
	if SB1->B1_TIPCONV=="M"
		nRet := nQtde * SB1->B1_CONV
	else
		nRet := nQtde / SB1->B1_CONV
	endif
endif

If nRet % 1 <> 0
	nRet := Int(nRet) + 1
EndIf

Return(nRet)

User Function Conv2to1(cProd,nQtde)

nRet := 0

dbSelectArea("SB1")
dbSetOrder(1)
if dbSeek(xFilial("SB1")+cProd)
	if SB1->B1_TIPCONV=="M"
		nRet := nQtde / SB1->B1_CONV
	else
		nRet := nQtde * SB1->B1_CONV
	endif
endif

//If nRet % 1 <> 0
//	nRet := Int(nRet) + 1
//EndIf

Return(nRet)


Static Function PrecoTab(_cTab,_cProd)

Local _mArea     := {"DA1"}
Local _mAlias    := {}

_mAlias := U_SalvaAmbiente(_mArea)

_nRet := 0
dbSelectArea("DA1")
dbSetOrder(1)
if dbSeek(xFilial("DA1")+_ctab+_cProd)
	_nRet := DA1->DA1_PRCVEN
endif

U_VoltaAmbiente(_mAlias)

Return(_nRet)
