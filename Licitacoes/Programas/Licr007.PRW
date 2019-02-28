#INCLUDE "rwmake.ch"
#INCLUDE "avprint.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR006 ³Autor³ Lúcia Valéria           ³Data ³  30/01/03  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatorio - Proposta de Licitacao						        ³±±
±±³          ³ Modelo Usado para Orgão Publico.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Licitacoes                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LICR007(cPropos)

PRIVATE _cPerg := "PERGLIC007"

_pergsx1()

	pergunte(_cPerg,.T.)

	if cPropos<>nil
	   mv_par01 := cPropos
	endif

RptStatus({|| RunReport()})

Return


Static Function RunReport()

SetPrvt("oFontA10,oFontA10B,oFontA12,oFontA12B,oFontA14,oFontA14B,nPag")
SetPrvt("oFontT10,oFontT1BB,oFontT12,oFontT12B,oFontT14,oFontT14B, oPrn, nTotProp")

//----------------------------------------------------------------------------//
// Definições do objeto de impressão AVPRINT
//----------------------------------------------------------------------------//
/*
#xcommand AVPRINT [ <oPrint> ] ;
[ <name:TITLE,NAME,DOC> <cDocument> ] ;
[ <user: FROM USER> ] ;
[ <prvw: PREVIEW> ] ;
[ TO  <xModel> ] ;
=> ;
[ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPRINTER [ <oPrint> ] ;
[ <name:NAME,DOC> <cDocument> ] ;
[ <user: FROM USER> ] ;
[ <prvw: PREVIEW> ] ;
[ TO  <xModel> ] ;
=> ;
[ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPAGE       => AvPageBegin()
#xcommand AVENDPAGE    => AvPageEnd()
#xcommand AVNEWPAGE    => AvPageEnd()  ; AvPageBegin()
#xcommand AVENDPRINT   => AvPrintEnd() ; //AvSetPortrait()
#xcommand AVENDPRINTER => AvPrintEnd() ; //AvSetPortrait()
*/

//------------------------------------------------------------------------------//

AVPRINT oPrn NAME "Proposta de Licitação"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definições de Fontes que serão utilizadas pelo relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oFontA10  	:=  oSend(TFont(),"New","ARIAL"          ,0,10,,.F.,,,,,,,,,,,oPrn )
oFontA10B 	:=  oSend(TFont(),"New","ARIAL"          ,0,10,,.T.,,,,,,,,,,,oPrn )
oFontA12 	:=  oSend(TFont(),"New","ARIAL"          ,0,12,,.F.,,,,,,,,,,,oPrn )
oFontA12B 	:=  oSend(TFont(),"New","ARIAL"          ,0,12,,.T.,,,,,,,,,,,oPrn )
oFontA14 	:=  oSend(TFont(),"New","ARIAL"          ,0,14,,.F.,,,,,,,,,,,oPrn )
oFontA14B 	:=  oSend(TFont(),"New","ARIAL"          ,0,14,,.T.,,,,,,,,,,,oPrn )

oFontT10 	:= oSend(TFont(),"New","Times New Roman"          ,0,10,,.F.,,,,,,,,,,,oPrn )
oFontT10B 	:= oSend(TFont(),"New","Times New Roman"          ,0,10,,.T.,,,,,,,,,,,oPrn )
oFontT12 	:= oSend(TFont(),"New","Times New Roman"          ,0,12,,.F.,,,,,,,,,,,oPrn )
oFontT12B 	:= oSend(TFont(),"New","Times New Roman"          ,0,12,,.T.,,,,,,,,,,,oPrn )
oFontT14 	:= oSend(TFont(),"New","Times New Roman"          ,0,14,,.F.,,,,,,,,,,,oPrn )
oFontT14B 	:= oSend(TFont(),"New","Times New Roman"          ,0,14,,.T.,,,,,,,,,,,oPrn )
oFontT16 	:= oSend(TFont(),"New","Times New Roman"          ,0,16,,.F.,,,,,,,,,,,oPrn )
oFontT16B 	:= oSend(TFont(),"New","Times New Roman"          ,0,16,,.T.,,,,,,,,,,,oPrn )
oFontT18 	:= oSend(TFont(),"New","Times New Roman"          ,0,18,,.F.,,,,,,,,,,,oPrn )
oFontT18B 	:= oSend(TFont(),"New","Times New Roman"          ,0,18,,.T.,,,,,,,,,,,oPrn )

AVPAGE

dbSelectArea("SZL")
dbSetOrder(3)
dbSeek(xFilial("SZL")+mv_par01)

dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xFilial("SZP")+SZL->ZL_LICITAN)

nPag := 1

nLinAtual := oDesCabec(.t.)

nTotProp := 0
dbSelectArea("SZM")
dbSetOrder(1)
dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO)
while !SZM->(Eof()) .and. SZL->ZL_NUMPRO==SZM->ZM_NUMPRO
	
	nLinAtual := oDesLinha(nLinAtual)
	
	SZM->(dbskip())
	
enddo

nLinAtual := oDesRodape(nLinAtual)

AVENDPAGE

AVENDPRINT

MS_FLUSH()

Return


Static Function oDesCabec(lProd)

//oPrn:SayBitmap( 10,50,"LGLIC.BMP",300,200 )

//oPrn:Say( 100, 1000, "Proposta de Preços para Produtos em Licitação",oFontT18B)

oPrn:Say( 350, 350, "Anápolis, " + U_DataExt(dDatabase),oFontT12)

oPrn:Say( 350, 1850, "Cotação :" +SZL->ZL_PROPOS,oFontT12)

oPrn:Say( 450, 350, SZP->ZP_NOMLIC,oFontT12)
oPrn:Say( 500, 350, Posicione("SA3",1,xFilial("SA3")+SZL->ZL_REPRES,"A3_NOME") ,oFontT12,100)

oPrn:Say( 600, 350, "PROPOSTA DE PREÇOS" ,oFontT12B,100)
oPrn:Say( 650, 350, "Proponente: ",oFontT12B,100)
oPrn:Say( 650, 650, GetNewPar("MV_LICRAZ","Vitamedic Ind.Farmaceutica Ltda"),oFontT12,100)

oPrn:Say( 700, 350, "Endereço: ",oFontT12B,100)
oPrn:Say( 700, 650, Alltrim(SM0->M0_ENDENT) + ", " + Alltrim(SM0->M0_BAIRENT) + ", " + Alltrim(SM0->M0_CIDENT) + "-" + Alltrim(SM0->M0_ESTENT),oFontT12,100)

oPrn:Say( 750, 350, "C.G.C.: ",oFontT12B,100)              
_nCGC := Val(GetNewPar("MV_LICCGC",SM0->M0_CGC))
oPrn:Say( 750, 650, TRANSFORM(_nCGC, "@E 99,999,999/9999-99"),oFontT12,100)

oPrn:Say( 2200, 2700, "Pág. " + alltrim(str(nPag)),oFontT10)

oPrn:Say( 850, 350, "Edital: ",oFontT12B,100)
oPrn:Say( 850, 650, RetModal(SZL->ZL_MODAL)+" n° "+SZL->ZL_NUMEDI,oFontT12)

oPrn:Say( 900, 350, "Data: ",oFontT12B,100)
oPrn:Say( 900, 650, dtoc(SZL->ZL_DTABER),oFontT12)

oPrn:Say( 950, 350, "Hora: ",oFontT12B,100)
oPrn:Say( 950, 650, SZL->ZL_HRABER,oFontT12)

if lProd
	oPrn:Say( 1050, 350, "Oferecemos a seguir os produtos de nossa fabricação e procedência nacional:",oFontT12B,100)
	
	nRet := 1150
else
	
	oPrn:Say( 550, 350, "**** CONTINUAÇÃO ****",oFontT10,100)
	
	nRet := 800
endif
oPrn:Say( 2800, 2200, "Pág. " + alltrim(str(nPag)),oFontT12)	

Return(nRet)


Static Function oDesLinha(nLin)

PRIVATE nLins := 0

// Desnha linhas da grade e retorna o valor que deve ser retornado por esta função
// ou seja, a linha onde terminou o box

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SZM->ZM_CODPRO)

oPrn:Say( nLin,  350, "ITEM "  + SZM->ZM_NUMITEM ,oFontT10B,100)

// Imprime as descrições de produto e apresentação
nLin := oDesBox(nLin+50) - 50
oPrn:Say( nLin,  360, "Produto: " ,oFontT10B,100)
cDescProd := alltrim(SB1->B1_DESC)
oWWSay(nLin,720,150, cDescProd,.t.)

//  Imprime Nome Comercial - Marca
nLin := oDesBox(nLin+50) - 50
oPrn:Say( nLin,  360, "Marca: " ,oFontT10B,100)
oWWSay(nLin,720,150, alltrim(SB1->B1_MARCA), .t.)

//  Imprime Num.Registro
nLin := oDesBox(nLin+50) - 50
oPrn:Say( nLin,  360, "N° Reg. MS: " ,oFontT10B,100)
oWWSay(nLin,720,200, alltrim(SB1->B1_ANVISA), .t.)

// Imprime Quantidade e Unidade de Medida solicitada na proposta
if SZL->ZL_UMPROP=="1"
	nQtde := SZM->ZM_QTDE1
	cUM   := SZM->ZM_UM1
else
	nQtde := SZM->ZM_QTDE2
	cUM   := SZM->ZM_UM2
endif

cUm := Posicione("SAH",1,xFilial("SAH")+cUM,"AH_UMRES")

cQtd := Extenso(nQtde)
nPos := Rat("REA",cQtd)
cQtd := Alltrim(SubStr(cQtd,1,nPos-1)) + " " + Alltrim(cUm)
//cTexto := lower(alltrim(TRANSFORM(nQtde, "@E 999,999,999,999")) )// + " (" + cQtd + ")")
cTexto := Right(space(14) + alltrim(TRANSFORM(nQtde, "@E 999,999,999,999")),17) 
cTexto := lower(cTexto + " (" + cQtd + ")")
														
nLin := oDesBox(nLin+50) - 50
oPrn:Say( nLin,  360, "Unidade: " ,oFontT10B,100)
oWWSay(nLin,720,200, Alltrim(cUM), .f.)

nLin := oDesBox(nLin+50) - 50
oPrn:Say( nLin, 360, "Quantidade: " ,oFontT10B,100)
oWWSay(nLin,720,200, cTexto, .f.)
//oWWSay(nLin,820,200, Lower(" (" + cQtd + ")"), .f.)

// Imprime Preço Unitário
cCasas := Replicate("9",SZL->ZL_CASASD)
cMascara := "@E 9,999,999." + cCasas
cValTxt := alltrim(TRANSFORM(SZM->ZM_PRCUNI, cMascara))
nPos := Rat(",",cValTxt)
cPartInt := SubStr(cValTxt,1,nPos-1)
nPartInt := Val(cPartInt)

cPartFrac := SubStr(cValTxt,nPos+1,SZL->ZL_CASASD)
nCorte := 0
for i := 1 to Len(cPartFrac)
	if SubStr(cPartFrac,Len(cPartFrac)-i+1,1)=="0"
		nCorte := nCorte + 1
	else
		i := Len(cPartFrac)
	endif
next i
cPartFrac := SubStr(cPartFrac,1,Len(cPartFrac)-nCorte)

nPartFrac := Val(cPartFrac)

if Len(cPartFrac)==4
	cFinal := "MILIONESIMOS"
elseif Len(cPartFrac)==3
	cFinal := "MILESIMOS"
elseif Len(cPartFrac)==2 .or.  Len(cPartFrac)==1
	cFinal := "CENTAVOS"
else
	cFinal := ""
endif

If Len(cPartFrac) <=2 //.or.  Len(cPartFrac)==1
	cValExt  := Extenso(Val(cPartInt + "." + cPartFrac))
Else
	if nPartInt==1
		cExt1 := "Um Real"
	else
		cExt1 := Extenso(nPartInt)
	endif
	
	cExt2 := Extenso(nPartFrac)
	nPos := Rat("REA",cExt2)
	cExt2 := SubStr(cExt2,1,nPos-1) + " " + cFinal
	
	if !Empty(cExt1) .and. !Empty(cExt2)
		cValExt := cExt1 + " e " + cExt2 
	elseIf !Empty(cExt1)	
		cValExt := cExt1
	else
		cValExt := cExt2
	endif
EndIf
If nPartInt == 0
   cValExt += " de real"
EndIf      

cTexto := Right(space(14) + alltrim(cValTxt),14) 
cTexto := lower(cTexto + " (" + cValExt + ")")

nLin := oDesBox(nLin+50) - 50
oPrn:Say( nLin,  360, "Pço Unitário: " ,oFontT10B,100)
oWWSay(nLin,720,200,"R$ " + cTexto, .t.)
//oWWSay(nLin,820,200, Lower(" (" + cValExt + ")"), .f.)

// Imprime preço total
nPrcTotal :=  Round((SZM->ZM_PRCUNI * nQtde),2)
cTexto := Right(space(14) + alltrim(TRANSFORM(nPrcTotal, "@E 999,999,999.99")),14) 
cTexto := lower(cTexto + " (" + Extenso(nPrcTotal) + ")")

nLin := oDesBox(nLin+50) - 50
oPrn:Say( nLin,  360, "Pço Total: " ,oFontT10B,100)
oWWSay(nLin,720,160, "R$ " + cTexto, .t.)
//oWWSay(nLin,820,200, Lower(" (" + Extenso(nPrcTotal) + ")"), .f.)

Return(nLin+100)

Static Function oDesRodape(nLin)

nLin := oSomaLinha(nLin,100,.f.)
oPrn:Say( nLin, 350, "Validade da Proposta: ",oFontT12B,100)
cExt := lower(Extenso(SZL->ZL_DIASVAL,.t.))
oPrn:Say( nLin, 900, alltrim(str(SZL->ZL_DIASVAL)) + " (" +cExt +") dia(s) - (Pedidos não confirmados neste prazo estarão sujeitos a nova cotação)",oFontT12,100)

nLin := oSomaLinha(nLin,050,.f.)
oPrn:Say( nLin, 350, "Frete: ",oFontT12B,100)
oPrn:Say( nLin, 900, "CIF",oFontT12,100)

nLin := oSomaLinha(nLin,50,.f.)
oPrn:Say( nLin, 350, "Impostos: ",oFontT12B,100)
oPrn:Say( nLin, 900, "Inclusos",oFontT12,100)

nLin := oSomaLinha(nLin,50,.f.)
oPrn:Say( nLin, 350, "Entregas: ",oFontT12B,100)
oPrn:Say( nLin, 900, "Conforme Edital",oFontT12,100)

nLin := oSomaLinha(nLin,50,.f.)
oPrn:Say( nLin, 350, "Processo: ",oFontT12B,100)
oPrn:Say( nLin, 900, AllTrim(SZL->ZL_PROCESS),oFontT12,100)

nLin := oSomaLinha(nLin,100,.f.)
oPrn:Say( nLin, 350, "Declaramos que concordamos com  as normas do  presente edital,  bem como ",oFontT12,100)
nLin := nLin + 50
oPrn:Say( nLin, 350, "as Leis Federais n° 8.666/93 e n° 8.883/94 e Lei Estadual n° 6.544/89 ",oFontT12,100)
nLin := nLin + 50
oPrn:Say( nLin, 350, "bem como as demais leis, decretos, portarias e resoluções cujas normas regem ",oFontT12,100)
nLin := nLin + 50
oPrn:Say( nLin, 350, "a presente Licitação.",oFontT12,100)

nLin := oSomaLinha(nLin,200,.f.)
oPrn:Say( nLin,350, Alltrim(mv_par02),oFontT12,100)

nLin := oSomaLinha(nLin,050,.f.)
oPrn:Say( nLin,350, Alltrim(mv_par03),oFontT12,100)

return(nLin)

//*******************************************************************************
//* FUNÇÕES DE APOIO
//*******************************************************************************

Static Function oSomaLinha(nLin,nTam,lProd)

nRet := nLin + nTam

if nRet > 3000
	oPrn:Say( 3100,350, "**** CONTINUA ****" ,oFontT10)
	AVENDPAGE
	AVPAGE
	nPag := nPag + 1
	//	nRet := oDesCabec(lProd)
	nRet := 350 //nRet + 150
endif

Return(nRet)

Static Function oDesBox(nLin)

nLin := oSomaLinha(nLin,050,.t.)

oPrn:Box(  nLin-050, 350, nLin, 2100 )
oPrn:Line( nLin-050, 700, nLin, 700 )//1

return(nLin)


Static Function oWWSay(nLin,nColI,nCols,cTexto,lLower)

LOCAL aWords := {}
LOCAL aTexto := {}

c := 1
AADD(aWords,"")
for i := 1 to len(cTexto)
	cCaracter := SubStr(cTexto,i,1)
	if cCaracter==" "
		AADD(aWords,"")
		c := c + 1
	else
		if len(aWords[c])>0 .and. lLower
			aWords[c] := aWords[c] + lower(cCaracter)
		else
			aWords[c] := aWords[c] + cCaracter
		endif
	endif
next i

AADD(aTexto,"")

c := 1
for i := 1 to len(aWords)
	if len(aTexto[c] + aWords[i]) > nCols
		AADD(aTexto,"")
		c := c+1
	endif
	aTexto[c] := aTexto[c] + aWords[i] + " "
next i

for i := 1 to len(aTexto)
	oPrn:Say( nLin, nColI+20,aTexto[i],oFontT10,100)
	nLin := nLin + 50
next i

if len(aTexto)>nLins
	nLins := len(aTexto)
endif

Return(.t.)



Static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{_cperg,"01","Proposta           ?","mv_ch1","C",08,0,1,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SZL"})
aadd(_agrpsx1,{_cperg,"02","Nome Solicitante   ?","mv_ch2","C",30,0,1,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Cargo Solicitante  ?","mv_ch3","C",30,0,1,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return


Static Function RetModal(cCod)

cRet := " "
SX5->(DBSeek(xFilial("SX5") + "74" + cCod))
cRet := Alltrim(SX5->X5_DESCRI)

/*/
do case
	case cCod=="CV"
		cRet := "Carta Convite"
	case cCod=="TP"
		cRet := "Tomada Precos"
	case cCod=="CP"
		cRet := "Conc.Publica"
	case cCod=="DL"
		cRet := "Dispensa Licitacao"
	case cCod=="CH"
		cRet := "Conc. Hospitalar"
	case cCod=="RG"
		cRet := "Reg.Precos"
	case cCod=="CD"
		cRet := "Compra Direta"
endcase
/*/
return(cRet)
