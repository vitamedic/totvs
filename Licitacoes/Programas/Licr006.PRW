#INCLUDE "rwmake.ch"
#INCLUDE "avprint.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³			  ³ LICR006 Autor³ Lúcia Valéria           ³ Data ³  30/01/03   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatorio - Proposta de Licitacao						        ³±±
±±³          ³ Modelo Usado para Orgao Publico.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Licitacoes                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LICR006(cPropos)

PRIVATE _cPerg := "PERGLIC006"
PRIVATE nTotProp := 0
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
dbSetOrder(5)
dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO)
while !SZM->(Eof()) .and. SZL->ZL_NUMPRO==SZM->ZM_NUMPRO
	
	nLinAtual := oDesLinha(nLinAtual)
	
	SZM->(dbskip())
	
enddo
nLinAtual := oDesTotal(nLinAtual)
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

//oPrn:Say( 3200, 2000, "Página :" + alltrim(str(nPag)))     

oPrn:Say( 500, 350, SZP->ZP_NOMLIC,oFontT12B)
oPrn:Say( 550, 350, mv_par02,oFontT12)
oPrn:Say( 600, 350, mv_par03,oFontT12)
//oPrn:Say( 500, 350, Posicione("SA3",1,xFilial("SA3")+SZL->ZL_REPRES,"A3_NOME") ,oFontT12,100)

oPrn:Say( 700, 350, "PROPOSTA DE PREÇOS" ,oFontT12B,100)
oPrn:Say( 750, 350, "Proponente: ",oFontT12B,100)
oPrn:Say( 750, 650, GetNewPar("MV_LICRAZ","Vitamedic Ind.Farmaceutica Ltda"),oFontT12,100)

oPrn:Say( 800, 350, "Endereço: ",oFontT12B,100)
oPrn:Say( 800, 650, Alltrim(SM0->M0_ENDENT) + ", "+Alltrim(SM0->M0_COMPENT) + " - " + Alltrim(SM0->M0_BAIRENT) + ", " + Alltrim(SM0->M0_CIDENT) + "-" + Alltrim(SM0->M0_ESTENT),oFontT12,100)

oPrn:Say( 850, 350, "C.G.C.: ",oFontT12B,100)              
_nCGC := Val(GetNewPar("MV_LICCGC",SM0->M0_CGC))
oPrn:Say( 850, 650, TRANSFORM(_nCGC, "@E 99,999,999/9999-99"),oFontT12,100)

oPrn:Say( 850, 1300, "I.E.:",oFontT12B,100)              

oPrn:Say( 850, 1400, "      10.197.801-4",oFontT12,100)              
//_nCGC := Val(GetNewPar("MV_LICCGC",SM0->M0_CGC))
//oPrn:Say( 850, 650, TRANSFORM(_nCGC, "@E 99,999,999/9999-99"),oFontT12,100)

oPrn:Say( 900, 350, "Edital: ",oFontT12B,100)
oPrn:Say( 900, 650, RetModal(SZL->ZL_MODAL)+" n° "+SZL->ZL_NUMEDI,oFontT12)

oPrn:Say( 950, 350, "Data: ",oFontT12B,100)
oPrn:Say( 950, 650, dtoc(SZL->ZL_DTABER),oFontT12)

oPrn:Say( 1000, 350, "Hora: ",oFontT12B,100)
oPrn:Say( 1000, 650, SZL->ZL_HRABER,oFontT12)

if lProd
	oPrn:Say( 1100, 350, "Oferecemos a seguir os produtos de nossa fabricação e procedência nacional:",oFontT12B,100)
	nRet := 1150
else
	
	oPrn:Say( 550, 350, "**** CONTINUAÇÃO ****",oFontT10,100)
	
	nRet := 800
endif


Return(nRet)


Static Function oDesLinha(nLin)
Local _aImpTxt := {}
PRIVATE nLins := 0      
PRIVATE nTam := 0

// Desnha linhas da grade e retorna o valor que deve ser retornado por esta função
// ou seja, a linha onde terminou o box

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SZM->ZM_CODPRO)

// Imprime as descrições de produto e apresentação
if SZL->ZL_PROPOS="00065/03"                                                                            
 if SZM->ZM_NUMITEM = "001"
  _mnum := "490"
 elseif  SZM->ZM_NUMITEM = "002"
   _mnum := "12.977"
 elseif  SZM->ZM_NUMITEM = "003"
   _mnum := "4.675"
 elseif  SZM->ZM_NUMITEM = "004"
   _mnum := "709"
 elseif  SZM->ZM_NUMITEM = "005"
   _mnum := "712"
 elseif  SZM->ZM_NUMITEM = "006"
   _mnum := "7.518"
 elseif  SZM->ZM_NUMITEM = "007"
   _mnum := "719"
 elseif  SZM->ZM_NUMITEM = "008"
   _mnum := "666"
 endif
elseif !empty(szm->ZM_OBS)
  _mnum := SUBSTR(SZM->ZM_OBS,1,6)
else  
  _mnum := SZM->ZM_NUMITEM
endif  

if SZL->ZL_PROPOS<>"00122/03"                                                                            
	nLin := nLin+50
if nLin > 3000
	oPrn:Say( 3200, 350, "**** CONTINUA ****" ,oFontT10)
	oPrn:Say( 3200, 2000, "Página :" + alltrim(str(nPag)))     
	AVENDPAGE
	AVPAGE
	nPag := nPag + 1
	nLin := 400 //nRet + 150
endif  
endif
oPrn:Say( nLin,  350, "ITEM " +_mnum,oFontT10B)

nLin := oSomaLinha(nLin,50,.f.)
oPrn:Say( nLin,  360, "Produto: " ,oFontT10B)
cDescProd := alltrim(SB1->B1_DESCCIE)+" "+alltrim(SB1->B1_APRES)
oWWSay(nLin,720,60, cDescProd,.t.)
nLin := oDesBox(nLin,50*nLins) //- nTam

//  Imprime Nome Comercial - Marca
nLin := oSomaLinha(nLin,0,.f.)
oPrn:Say( nLin,  360, "Marca: " ,oFontT10B)
oWWSay(nLin,720,60, alltrim(SB1->B1_MARCA), .t.)
nLin := oDesBox(nLin,50*nLins) //- nTam

//  Imprime Num.Registro                           
_nvalid := ALLTRIM(STR((SB1->B1_PRVALID/365)*12))+" meses"
nLin := oSomaLinha(nLin,0,.f.)
oPrn:Say( nLin,  360, "N° Reg. MS: " ,oFontT10B)
oWWSay(nLin,720,60, alltrim(SB1->B1_ANVISA), .t.)
oPrn:Say(nLin,1600, "| Validade Produto: "+_nvalid,oFontT10)
//oWWSay(nLin,2400,10,_nvalid, .t.)
nLin := oDesBox(nLin,50*nLins) //- nTam

// Imprime Quantidade e Unidade de Medida solicitada na proposta
if SZL->ZL_UMPROP=="1"
	nQtde := SZM->ZM_QTDE1
	cUM   := SZM->ZM_UM1
else
	nQtde := SZM->ZM_QTDE2
	cUM   := SZM->ZM_UM2
endif

cUm := Posicione("SAH",1,xFilial("SAH")+cUM,"AH_UMRES")
if cUm == "COMPRIMID"
  cUm := "COMPRIMIDOS"
endif  

cQtd := Extenso(nQtde)
nPos := Rat("REA",cQtd)
cQtd := Alltrim(SubStr(cQtd,1,nPos-1)) + " " + Alltrim(cUm)

nLin := oSomaLinha(nLin,0,.f.)
					
oPrn:Say( nLin,  360, "Unidade: " ,oFontT10B,100)
oWWSay(nLin,720,60, Alltrim(cUM), .f.)
nLin := oDesBox(nLin,50*nLins) //- nTam

nLin := oSomaLinha(nLin,0,.f.)
oPrn:Say( nLin, 360, "Quantidade: " ,oFontT10B,100)
cTexto := Right(space(14) + alltrim(TRANSFORM(nQtde, "@E 999,999,999,999")),17) 
oWWSay(nLin,720,20, cTexto, .f.)
cTexto := lower("(" + cQtd + ")")
oWWSay(nLin,1110,50, cTexto, .f.)
nLin := oDesBox(nLin,50*nLins) 

// Imprime Preço Unitário
cCasas := Replicate("9",SZL->ZL_CASASD)
cMascara := "@E 9,999"+"."+ cCasas

//cValTxt := alltrim(TRANSFORM(SZM->ZM_PRCUNI, cMascara))
if SZL->ZL_UMPROP =="2"
	cValTxt := TRANSFORM(SZM->ZM_PRCUN2, cMascara)
else                                             
	cValTxt := TRANSFORM(SZM->ZM_PRCUNI, cMascara)
endif	

nPos := Rat(",",cValTxt)
cPartInt := SubStr(cValTxt,1,nPos-1)
nPartInt := Val(cPartInt)

cPartFrac := SubStr(cValTxt,nPos+1,SZL->ZL_CASASD)
if nPartInt <> 0
nCorte := 0              
for i := 1 to Len(cPartFrac)
	if SubStr(cPartFrac,Len(cPartFrac)-i+1,1)=="0"
		nCorte := nCorte + 1
	else
		i := Len(cPartFrac)
	endif
next i
cPartFrac := SubStr(cPartFrac,1,Len(cPartFrac)-nCorte)

endif


nPartFrac := Val(cPartFrac)

if Len(cPartFrac) ==4  .and. nPartInt <=1
	cFinal := "MILIONESIMOS"
elseif Len(cPartFrac) ==3 .and. nPartInt <=1
	cFinal := "MILESIMOS"
elseif Len(cPartFrac) ==2 .and. nPartInt <=1 //SZL->ZL_CASASD==2 // .or.  Len(cPartFrac)==1
	cFinal := "CENTAVOS"
elseif Len(cPartFrac) ==1 .and. nPartInt <=1 //SZL->ZL_CASASD==1
	cFinal := "DECIMOS"
else
   cFinal := ""
endif

If (Len(cPartFrac) <=2 .or.  Len(cPartFrac)==1 ) 
	cValExt  := Alltrim(Extenso(Val(cPartInt + "." + cPartFrac)))
   if SZL->ZL_CASASD==4
     cValExt := strtran(cValExt,"Centavos","Milionesimos",,,) 
   elseif SZL->ZL_CASASD==3
     cValExt := strtran(cValExt,"Centavos","Milesimos",,,)         
   endif 
	if nPartInt==1
		nPos := Rat("REA",cValExt)
		cValExt := SubStr(cValExt,1,nPos-1) + "REAL " + SubStr(cValExt,nPos+6,Len(cValExt))
	EndIf
Else            
	if nPartInt==1
		cExt1 := "Um Real"
	else
		cExt1 := Extenso(nPartInt)
	endif    
   cExt2 := Extenso(nPartFrac)  
	nPos := Rat("REA",cExt2)
	cExt2 := SubStr(cExt2,1,nPos-1) + " " + cFinal
	if nPartInt >=1  
     cExt2 := cExt2  
   endif 
	
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
/*if SZM->ZM_NUMITEM = "065"
   cValExt := " um real e quinze centavos"  
endif   */

nLin := oSomaLinha(nLin,0,.f.)
oPrn:Say( nLin,  360, "Pço Unitário: " ,oFontT10B,100)
cTexto := Right(space(14) + alltrim(cValTxt),14) 
oWWSay(nLin,720,20,"R$ " + cTexto, .t.)

cTexto := lower("(" + cValExt + ")")
oWWSay(nLin,1100,50, cTexto, .t.)
nLin := oDesBox(nLin,50*nLins) //- nTam

// Imprime preço total
if SZL->ZL_UMPROP =="2"
	nPrcTotal :=  Round((SZM->ZM_PRCUN2 * nQtde),2)
else
	nPrcTotal :=  Round((SZM->ZM_PRCUNI * nQtde),2)
endif	
// Acumula o Valor Total da Proposta que será impresso no rodapé
nTotProp := nTotProp + nPrcTotal

//nLin := oDesBox(nLin-50,nTam)
nLin := oSomaLinha(nLin,0,.f.)
oPrn:Say( nLin,  360, "Pço Total: " ,oFontT10B,100)
cTexto := Right(space(14) + alltrim(TRANSFORM(nPrcTotal, "@E 999,999,999.99")),14) 
oWWSay(nLin,720,20, "R$ " + cTexto, .t.)

cTexto := lower("(" + Extenso(nPrcTotal) + ")")
oWWSay(nLin,1100,50, cTexto, .t.)
nLin := oDesBox(nLin,50*nLins) //- nTam

Return(nLin)

Static Function oDesRodape(nLin)

if SZL->ZL_PROPOS<>"00122/03"                                                                            
  nLin := oSomaLinha(nLin,050,.f.)
endif  

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
oPrn:Say( nLin, 350, "Tipo Fornecimento: ",oFontT12B,100)
if SZL->ZL_TIPOFOR="U"
	oPrn:Say( nLin, 900, "Único",oFontT12,100)
else
	oPrn:Say( nLin, 900, "Parcelado em " + alltrim(str(SZL->ZL_PERIODO)) + " vezes",oFontT12,100)
endif

nLin := oSomaLinha(nLin,50,.f.)
oPrn:Say( nLin, 350, "Pedido Minimo: ",oFontT12B,100)
cExt := lower(GetNewPar("MV_LVLMIN","1200"))
oPrn:Say( nLin, 900, "R$  " + ALLTRIM(TRANSFORM( Val(cExt),"@E 999,999,999.99" )),oFontT12,100)

nLin := oSomaLinha(nLin,50,.f.)
oPrn:Say( nLin, 350, "Processo: ",oFontT12B,100)
oPrn:Say( nLin, 900, AllTrim(SZL->ZL_PROCESS),oFontT12,100)

nLin := oSomaLinha(nLin,50,.f.)
oPrn:Say( nLin, 350, "Dados Bancários:",oFontT12B,100)
oPrn:Say( nLin, 900, "Banco do Brasil - Agência: 3388-X c/c: 6040-2",oFontT12,100)

IF !EMPTY(SUBSTR(SZL->ZL_OBS1,01,055))
  nLin := oSomaLinha(nLin,50,.f.)
  oPrn:Say( nLin, 350, "Obs.:     ",oFontT12B,100)
  oPrn:Say( nLin, 900, AllTrim(SUBSTR(SZL->ZL_OBS1,01,055)),oFontT12,100)
  if !EMPTY(SUBSTR(SZL->ZL_OBS1,56,055))
    nLin := nLin + 50
    oPrn:Say( nLin, 900, AllTrim(SUBSTR(SZL->ZL_OBS1,56,55)),oFontT12,100)
  endif                                
  if !EMPTY(SUBSTR(SZL->ZL_OBS1,111,055))
	  nLin := nLin + 50
	  oPrn:Say( nLin, 900, AllTrim(SUBSTR(SZL->ZL_OBS1,111,55)),oFontT12,100)
  endif  
  if !EMPTY(SUBSTR(SZL->ZL_OBS1,111,055))
	  nLin := nLin + 50
	  oPrn:Say( nLin, 900, AllTrim(SUBSTR(SZL->ZL_OBS1,166,55)),oFontT12,100)
	endif  
endif   

nLin := oSomaLinha(nLin,50,.f.)
//oPrn:Say( nLin, 350, "Garantia de Preço:",oFontT12B,100)
//oPrn:Say( nLin, 900, "Garantia Máxima de preço: 06 meses.",oFontT12,100)

if SZL->ZL_PROPOS<>"00122/03"                                                                            
  nLin := oSomaLinha(nLin,100,.f.)
else                              
  nLin := oSomaLinha(nLin,050,.f.)
endif  
oPrn:Say( nLin, 350, "Declaramos que concordamos com  as normas do  presente edital,  bem como ",oFontT12,100)
//nLin := nLin + 50               
nLin := oSomaLinha(nLin,050,.f.)
oPrn:Say( nLin, 350, "as Leis Federais n° 8.666/93  e  n° 8.883/94 e  Lei Estadual n° 6.544/89 ",oFontT12,100)
nLin := oSomaLinha(nLin,050,.f.)
//nLin := nLin + 50
oPrn:Say( nLin, 350, "bem como as demais leis, decretos, portarias  e  resoluções cujas normas ",oFontT12,100)
//nLin := nLin + 50
nLin := oSomaLinha(nLin,050,.f.)
oPrn:Say( nLin, 350, "regem a presente Licitação.",oFontT12,100)

if SZL->ZL_PROPOS<>"00122/03"                                                                              
  nLin := oSomaLinha(nLin,200,.f.)
else 
  nLin := oSomaLinha(nLin,100,.f.)
endif  

if !empty(mv_par04)
	oPrn:Say( nLin,350, Alltrim(mv_par04),oFontT12,100)
	nLin := oSomaLinha(nLin,050,.f.)
	oPrn:Say( nLin,350, Alltrim(mv_par05),oFontT12,100)
	nLin := oSomaLinha(nLin,050,.f.)
	oPrn:Say( nLin,350, Alltrim(mv_par06),oFontT12,100)
endif

/*
if !Empty(mv_par04)
	nLin := oSomaLinha(nLin,050,.f.)
	oPrn:Say( nLin,350, "RG: " + Alltrim(mv_par04),oFontT12,100)
endif

if !Empty(mv_par05)
	nLin := oSomaLinha(nLin,050,.f.)
	oPrn:Say( nLin,350, "CPF: " + Alltrim(mv_par05),oFontT12,100)
endif
*/

oPrn:Say( 3100, 2000, "Página :" + alltrim(str(nPag)))     
return(nLin)

Static Function oDestotal(nLin)

nRet := oDesBox2(nLin)
nLin := nRet - 50
oPrn:Say( nLin,  351, "Total Proposta",oFontT12B,100)
// Imprime preço total
nPrcTotal :=  Round((nTotProp),2)
cTexto := Right(TRANSFORM(nPrcTotal, "@E 9999,999.99"),15)
oWWSay(nLin,720,20, "R$ " + cTexto, .t.)
cTexto := lower("(" + Extenso(nPrcTotal) + ")")
oWWSay(nLin,1100,50, cTexto, .t.)

Return(nRet)

Static Function oDesBox2(nLin)
nLins := 0
nLin := oSomaLinha(nLin,100,.t.)
if nLin > 3100
	oPrn:Say( 3200,350, "**** CONTINUA ****" ,oFontT10)	
	oPrn:Say( 3200,2000, "Página :" + alltrim(str(nPag)),oFontT12)     
	AVENDPAGE
	AVPAGE   
	nPag := nPag + 1
	nRet := oDesCabec(lProd)
	nRet := nRet + 100
endif
oPrn:Box(  nLin-50, 0350,   nLin, 2300)
oPrn:Line( nLin-50, 0700,   nLin, 0700 )
return(nLin)                                              


//*******************************************************************************
//* FUNÇÕES DE APOIO
//*******************************************************************************

Static Function oSomaLinha(nLin,_nTam,lProd)

nRet := nLin + _nTam

if nRet > 2900
	oPrn:Say( 3000, 350, "**** CONTINUA ****" ,oFontT10)
	oPrn:Say( 3000, 2000, "Página :" + alltrim(str(nPag)))     
	AVENDPAGE
	AVPAGE
	nPag := nPag + 1
	nRet := 400 //nRet + 150
endif       

Return(nRet)

Static Function oDesBox(nLin,nTam)

nLin := nLin + nTam
oPrn:Line( nLin-nTam, 350, nLin-nTam , 2300 )
oPrn:Line( nLin-nTam, 2300, nLin , 2300 )
oPrn:Line( nLin, 2300, nLin , 350 )
oPrn:Line( nLin, 350, nLin-nTam , 350 )

oPrn:Line( nLin-nTam, 700, nLin , 700 )//1

//nLin := oSomaLinha(nLin, nTam,.t.)
if nLin > 2900
	oPrn:Say( 3000, 350, "**** CONTINUA ****" ,oFontT10)
	oPrn:Say( 3000, 2000, "Página :" + alltrim(str(nPag)))     
	AVENDPAGE
	AVPAGE
	nPag := nPag + 1
	nLin := 400 //nRet + 150
endif       

return(nLin)

Static Function oWWSay(nLin,nColI,nCols,cTexto,lLower)

LOCAL aWords := {}
LOCAL aTexto := {}
Local _nTam := 0   
c := 1
AADD(aWords,"")
for i := 1 to len(cTexto)
	cCaracter := SubStr(cTexto,i,1)
	if cCaracter==" "
		AADD(aWords,"")
		c := c + 1
	else        
		if len(aWords[c])>0 .and. lLower 
			if aWords[c] = "C" .and. cCaracter = "/"
      	    aWords[c] := lower(aWords[c])+ lower(cCaracter)
		   else
	    		aWords[c] := aWords[c] + lower(cCaracter)
		   endif	
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
	oPrn:Say( nLin, nColI+20,aTexto[i],oFontT10)
	nLin := nLin + 50
next i

	nLins := len(aTexto)
Return(.t.)



Static Function oImpLin(nLin,nColI, aTexto)


Return(.t.)




Static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{_cperg,"01","Proposta           ?","mv_ch1","C",08,0,1,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SZL"})
aadd(_agrpsx1,{_cperg,"02","Referencia 1       ?","mv_ch2","C",30,0,1,"G",space(30),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Referencia 2       ?","mv_ch3","C",30,0,1,"G",space(30),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Assinatura         ?","mv_ch4","C",30,0,1,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Cargo              ?","mv_ch5","C",30,0,1,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"06","CPF e/ou RG        ?","mv_ch6","C",30,0,1,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
