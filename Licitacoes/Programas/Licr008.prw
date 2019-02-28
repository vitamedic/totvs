#INCLUDE "rwmake.ch"
#INCLUDE "avprint.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR008  ³Autor³ Marcelo Myra Martins   ³Data ³  17/02/03  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatorio - Mapa Comparativo de Precos					    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Licitacoes                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function LICR008()

	PRIVATE _cPerg := "LIC002"

	_pergsx1()

	pergunte(_cPerg,.T.)

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

AVPRINT oPrn NAME "MAPA COMPARATIVO DE PREÇOS"

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

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+SZL->ZL_REPRES)

nPag := 1

nLinAtual := oDesCabec()

nTotProp := 0
dbSelectArea("SZM")
dbSetOrder(2)
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


Static Function oDesCabec()


oPrn:Say( 100, 100, "MAPA COMPARATIVO DE PREÇOS",oFontT18B)


if nPag == 1
	oPrn:Say( 200, 100, "Órgão:     " +Alltrim(SZP->ZP_NOMLIC),oFontT12)
	oPrn:Say( 250, 100, "Representante: "+Alltrim(substr(SA3->A3_NOME,1,20)),oFontT12)
	oPrn:Say( 300, 100, "Licitação: "+Alltrim(SZL->ZL_PROPOS),oFontT12)	
	oPrn:Say( 350, 100, "Abertura:  "+dtoc(SZL->ZL_DTABER),oFontT12)
	oPrn:Say( 400, 100, "Entrega:   "+Alltrim(Str(SZL->ZL_DIASENT)) + " dia(s) "  ,oFontT12)
	oPrn:Say( 450, 100, "Pagamento: "+Alltrim(Posicione("SE4",1,xFilial("SE4")+SZL->ZL_PRAZO,"E4_DESCRI")) + " dia(s)",oFontT12)


/*	oPrn:Line( 250, 100, 250, 800 )
	oPrn:Line( 300, 100, 300, 800 )
	oPrn:Line( 350, 100, 350, 800 )
	oPrn:Line( 400, 100, 400, 800 )
	oPrn:Line( 450, 100, 450, 800 )
	oPrn:Line( 500, 100, 500, 800 )
*/
	oPrn:Say( 250, 1500, "LICITANTES",oFontT12)

	oPrn:Line( 350, 1500, 350, 3000 )
	oPrn:Line( 400, 1500, 400, 3000 )
	oPrn:Line( 450, 1500, 450, 3000 )
	oPrn:Line( 500, 1500, 500, 3000 )
	oPrn:Line( 550, 1500, 550, 3000 )

	oPrn:Say( 300, 1500, "01"+" Vitamedic",oFontT12)
	oPrn:Say( 350, 1500, "02",oFontT12)
	oPrn:Say( 400, 1500, "03",oFontT12)
	oPrn:Say( 450, 1500, "04",oFontT12)
	oPrn:Say( 500, 1500, "05",oFontT12)

	oPrn:Say( 300, 2000, "06",oFontT12)
	oPrn:Say( 350, 2000, "07",oFontT12)
	oPrn:Say( 400, 2000, "08",oFontT12)
	oPrn:Say( 450, 2000, "09",oFontT12)
	oPrn:Say( 500, 2000, "10",oFontT12)

	oPrn:Say( 300, 2500, "11",oFontT12)
	oPrn:Say( 350, 2500, "12",oFontT12)
	oPrn:Say( 400, 2500, "13",oFontT12)
	oPrn:Say( 450, 2500, "14",oFontT12)
	oPrn:Say( 500, 2500, "15",oFontT12)

endif 

oPrn:Line( 600, 1500, 600, 3100 )
oPrn:Line( 650, 100, 650, 3100 )
oPrn:Line( 700, 100, 700, 3100 )

oPrn:Say( 600, 1800, "PRECOS DOS LICITANTES",oFontT12)

oPrn:Line( 650, 100, 700, 100 )
oPrn:Line( 650, 200, 700, 200 )
oPrn:Line( 650, 1100, 700, 1100 )//QTDE
oPrn:Line( 650, 1400, 700, 1400 )//unid
oPrn:Line( 600, 1500, 700, 1500 )//01
oPrn:Line( 650, 1700, 700, 1700 )//02
oPrn:Line( 650, 1800, 700, 1800 )//03
oPrn:Line( 650, 1900, 700, 1900 )//04
oPrn:Line( 650, 2000, 700, 2000 )//05
oPrn:Line( 650, 2100, 700, 2100 )//06
oPrn:Line( 650, 2200, 700, 2200 )//07
oPrn:Line( 650, 2300, 700, 2300 )//08
oPrn:Line( 650, 2400, 700, 2400 )//09
oPrn:Line( 650, 2500, 700, 2500 )//10
oPrn:Line( 650, 2600, 700, 2600 )//11
oPrn:Line( 650, 2700, 700, 2700 )//12
oPrn:Line( 650, 2800, 700, 2800 )//13
oPrn:Line( 650, 2900, 700, 2900 )//14
oPrn:Line( 650, 3000, 700, 3000 )//15
oPrn:Line( 600, 3100, 700, 3100 )//  

oPrn:Say( 650, 0100, "ITEM",oFontT12)
oPrn:Say( 650, 0210, "PRODUTO",oFontT12)
oPrn:Say( 650, 1100, "QTDADE",oFontT12)
oPrn:Say( 650, 1400, "UND",oFontT12)
oPrn:Say( 650, 1500, "01",oFontT12)
oPrn:Say( 650, 1700, "02",oFontT12)
oPrn:Say( 650, 1800, "03",oFontT12)
oPrn:Say( 650, 1900, "04",oFontT12)
oPrn:Say( 650, 2000, "05",oFontT12)
oPrn:Say( 650, 2100, "06",oFontT12)
oPrn:Say( 650, 2200, "07",oFontT12)
oPrn:Say( 650, 2300, "08",oFontT12)
oPrn:Say( 650, 2400, "09",oFontT12)
oPrn:Say( 650, 2500, "10",oFontT12)
oPrn:Say( 650, 2600, "11",oFontT12)
oPrn:Say( 650, 2700, "12",oFontT12)
oPrn:Say( 650, 2800, "13",oFontT12)
oPrn:Say( 650, 2900, "14",oFontT12)
oPrn:Say( 650, 3000, "15",oFontT12)

nRet := 700

Return(nRet)


Static Function oDesLinha(nLin)

oPrn:Line( nLin+50, 100, nLin+50, 3100 )
oPrn:Line( nLin, 100, nLin+50, 100 )
oPrn:Line( nLin, 200, nLin+50, 200 )
oPrn:Line( nLin, 1100, nLin+50, 1100 )
oPrn:Line( nLin, 1400, nLin+50, 1400 )
oPrn:Line( nLin, 1500, nLin+50, 1500 )
oPrn:Line( nLin, 1700, nLin+50, 1700 )
oPrn:Line( nLin, 1800, nLin+50, 1800 )
oPrn:Line( nLin, 1900, nLin+50, 1900 )
oPrn:Line( nLin, 2000, nLin+50, 2000 )
oPrn:Line( nLin, 2100, nLin+50, 2100 )
oPrn:Line( nLin, 2200, nLin+50, 2200 )
oPrn:Line( nLin, 2300, nLin+50, 2300 )
oPrn:Line( nLin, 2400, nLin+50, 2400 )
oPrn:Line( nLin, 2500, nLin+50, 2500 )
oPrn:Line( nLin, 2600, nLin+50, 2600 )
oPrn:Line( nLin, 2700, nLin+50, 2700 )
oPrn:Line( nLin, 2800, nLin+50, 2800 )
oPrn:Line( nLin, 2900, nLin+50, 2900 )
oPrn:Line( nLin, 3000, nLin+50, 3000 )
oPrn:Line( nLin, 3100, nLin+50, 3100 )


oPrn:Say( nLin, 110, SZM->ZM_NUMITEM ,oFontT12,100)
oPrn:Say( nLin, 210, SZM->ZM_DESC ,oFontT10,100)

// Imprime Quantidade e Unidade de Medida solicitada na proposta
if SZL->ZL_UMPROP=="1"
	nQtdeCx := SZM->ZM_QTDE1
	cUMCx   := SZM->ZM_UM1
	nQtde   := SZM->ZM_QTDE2
	cUM     := SZM->ZM_UM2
	cUm := Posicione("SAH",1,xFilial("SAH")+cUM,"AH_UMRES")
	oPrn:Say( nLin, 1110,Right(TRANSFORM(nQtde,"@E 999,999,999"),15),oFontT10,100)
else
	nQtde   := SZM->ZM_QTDE1
	cUM     := SZM->ZM_UM1
	nQtdeCx := SZM->ZM_QTDE2
	cUMCx   := SZM->ZM_UM2
	cUm := Posicione("SAH",1,xFilial("SAH")+cUM,"AH_UMRES")
	oPrn:Say( nLin, 1110,Right(TRANSFORM(nQtdeCx,"@E 999,999,999"),15),oFontT10,100)
endif
	oPrn:Say( nLin, 1410,cUMCx,oFontT10,100)


// Imprime Preço Unitário
cCasas := Replicate("9",SZL->ZL_CASASD)
cMascara := "@E 9,999"+"."+ cCasas
_npreco := if(SZL->ZL_UMPROP=="1",SZM->ZM_PRCUNI,SZM->ZM_PRCUN2) 
cValTxt := Right(TRANSFORM(_npreco, cMascara),10)

oPrn:Say( nLin, 1490,cValTxt,oFontT10,100)

nLin := oSomaLinha(nLin,50)

Return(nLin)
                                               

Static Function oDesRodape(nLin)
nLin := oSomaLinha(nLin,100,.f.)
oPrn:Say( nLin, 100, "OBS:",oFontT12B,100)
nLin := oSomaLinha(nLin,050,.f.)
oPrn:Line(nlin, 200, nlin, 3100 )

nLin := oSomaLinha(nLin,100,.f.)
oPrn:Line(nlin, 100, nlin, 3100 )

nLin := oSomaLinha(nLin,100,.f.)
oPrn:Line(nlin, 100, nlin, 3100 )

nLin := oSomaLinha(nLin,050,.f.)
oPrn:Say( nLin, 100, "Data:___________________ ",oFontT12B,100)
oPrn:Say( nLin, 1500, "Assinatura Representante:____________________________",oFontT12B,100)
return(nLin)

//*******************************************************************************
//* FUNÇÕES DE APOIO
//*******************************************************************************
 
Static Function oSomaLinha(nLin,nTam)

nRet := nLin + nTam

if nRet > 3100
	oPrn:Say( 3200,350, "**** CONTINUA ****" ,oFontT10)     
	oPrn:Say( 3200, 2000, "Página :" + alltrim(str(nPag)),oFontT12)     
	AVENDPAGE
	AVPAGE   
	nPag := nPag + 1
	nRet := oDesCabec()
	nRet := nRet + 100
endif

Return(nRet)


Static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{_cperg,"01","Proposta           ?","mv_ch1","C",08,0,1,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SZL"})
	
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

