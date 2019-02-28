#INCLUDE "rwmake.ch"
#INCLUDE "avprint.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR009 Autor³ Aline B.Pereira         ³Data ³  20/06/03   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatorio - Declaracao de Co-Responsabilidade              ³±±
±±³          ³ Modelo Usado para Orgao Publico.                           ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Licitacoes                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function LICR009(cPropos)

PRIVATE _cPerg := "PERGLIC009"
PRIVATE nLins := 100
PRIVATE _ma := .f.

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

AVPRINT oPrn NAME "Declaração de co-responsabilidade de entrega"

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
//oFontT12 	:= oSend(TFont(),"New","Microsoft Sans Serif"     ,0,12,,.F.,,,,,,,,,,,oPrn )
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

nLinAtual := oDesRodape(nLinAtual)

AVENDPAGE

AVENDPRINT

MS_FLUSH()

Return


Static Function oDesCabec(lProd)


oPrn:Say( 350, 350,mv_par02,oFontT12B)
oPrn:Say( 350, 1850,"Cotação: "+Alltrim(SZL->ZL_PROPOS),oFontT12)
oPrn:Say( 400, 350, mv_par03,oFontT12)
oPrn:Say( 450, 350, mv_par04,oFontT12)

oPrn:Say( 800, 350, "Ref: ",oFontT12B,100)
oPrn:Say( 800, 450, RetModal(SZL->ZL_MODAL)+" n° "+SZL->ZL_NUMEDI,oFontT12)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SZP->ZP_CODCLI+SZP->ZP_LJCLI)

_memp := Alltrim(SZP->ZP_NOMLIC)+", estabelecida à  "+Alltrim(SA1->A1_END) + ", "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+ "/ "+Alltrim(SA1->A1_EST)+", "+Alltrim(TRANSFORM(SA1->A1_CGC," @R 99.999.999/9999-99"))
_nconc := Alltrim(SZL->ZL_NUMEDI)
_mtipo := Alltrim(RetModal(SZL->ZL_MODAL))
oPrn:Say( 1000, 600, "DECLARAÇÃO DE CO-RESPONSABILIDADE DE ENTREGA",oFontT12B,100)
//oPrn:Say( 1200, 350, "Declaramos para os devidos fins que, na hipótese da empresa "+_memp+", vir a ser a vencedora da Concorrência de Registro de preços nº "+_nconc +", comprometemo-nos a oferecer os itens abaixo relacionados, por ela cotados e de nossa fabricação: " ,oFontT12,100)
nLIN := 1200        
_ndesc := "Declaramos  para  os  devidos fins  que, na hipótese da empresa "+_memp+",  vir  a ser a vencedora da "+_mtipo+" nº "+_nconc +",  comprometemo-nos a fornecer os itens abaixo relacionados, por  ela  cotados e de nossa fabricação: " //,oFontT12,100)
oWWSay(nLin,350,70, _ndesc,.t.,oFontT12)
nRet := 1550
Return(nRet)


Static Function oDesLinha(nLin)
Local _aImpTxt := {}
//PRIVATE nLins := 0      
PRIVATE nTam := 0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SZM->ZM_CODPRO)

// Imprime as descrições de produto e apresentação

_mnum := SZM->ZM_NUMITEM
nLin := oSomaLinha(nLin,50,.f.)
cDescProd := " - "+alltrim(SB1->B1_DESCCIE)+" "+alltrim(SB1->B1_APRES)
oWWSay(nLin,400,090, cDescProd,.t.,oFontT10)
//nLin := nLin + 50

Return(nLin)

Static Function oDesRodape(nLin)
nLin := nLin+150
oPrn:Say( nLin, 350, "Por ser verdade, firmamos a presente.",oFontT12)
nLin := nLin+200
oPrn:Say( nLin,350, "Anápolis, " + U_DataExt(dDatabase),oFontT12)
nLin := nLin+200
oPrn:Say( nLin,350, Alltrim(mv_par05),oFontT12,100)
nLin := nLin+50
oPrn:Say( nLin,350, Alltrim(mv_par06),oFontT12,100)
nLin := nLin+50
oPrn:Say( nLin,350, Alltrim(mv_par07),oFontT12,100)

oPrn:Say( 3200, 2000, "Página :" + alltrim(str(nPag)))     
return(nLin)

//*******************************************************************************
//* FUNÇÕES DE APOIO
//*******************************************************************************

Static Function oSomaLinha(nLin,_nTam,lProd)

nRet := nLin + _nTam

if nRet > 3100
	oPrn:Say( 3200, 350, "**** CONTINUA ****" ,oFontT10)
	oPrn:Say( 3200, 2000, "Página :" + alltrim(str(nPag)))     
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

nLin := oSomaLinha(nLin, nTam,.t.)
if nLin > 3100
	oPrn:Say( 3200, 350, "**** CONTINUA ****" ,oFontT10)
	oPrn:Say( 3200, 2000, "Página :" + alltrim(str(nPag)))     
	AVENDPAGE
	AVPAGE
	nPag := nPag + 1
	nLin := 400 //nRet + 150
endif       

return(nLin)

Static Function oWWSay(nLin,nColI,nCols,cTexto,lLower,cfonte)

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
//		 	if aWords[c] = "C"  //.and. cCaracter = "/"
//    			aWords[c] := lower(aWords[c])+ lower(cCaracter)
//    		else
    			aWords[c] := aWords[c] + lower(cCaracter)
//    		endif	
		else
  		  aWords[c] := aWords[c] + cCaracter		
		endif
	endif	
next i	
_t := 0	

AADD(aTexto,"")
c := 1
for i := 1 to len(aWords)
	if len(aTexto[c] + aWords[i]) > nCols
		AADD(aTexto,"")
		c := c+1
	endif
	aTexto[c] := aTexto[c] + aWords[i] + " "
//   _t := len(aWords)
next i
_t := len(aWords)	
for i := 1 to len(aTexto)
	oPrn:Say( nLin, nColI+20,aTexto[i],cfonte,100)
	nLin := nLin + 50
next i
if len(aTexto)>nLins
	nLins := len(aTexto)
endif

Return(.t.)







Static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Proposta           ?","mv_ch1","C",08,0,1,"G",space(60),"mv_par01"       ,space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(30),"SZL"})
aadd(_agrpsx1,{_cperg,"02","Referencia 1       ?","mv_ch2","C",60,0,1,"G",space(60),"mv_par02"       ,space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),"   "})
aadd(_agrpsx1,{_cperg,"03","Referencia 2       ?","mv_ch3","C",60,0,1,"G",space(60),"mv_par03"       ,space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),"   "})
aadd(_agrpsx1,{_cperg,"04","Referencia 3       ?","mv_ch4","C",60,0,1,"G",space(60),"mv_par04"       ,space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),space(15),space(15)        ,space(60),"   "})
aadd(_agrpsx1,{_cperg,"05","Assinatura         ?","mv_ch5","C",30,0,1,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"06","Cargo              ?","mv_ch6","C",30,0,1,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"07","CPF e/ou RG        ?","mv_ch7","C",30,0,1,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
