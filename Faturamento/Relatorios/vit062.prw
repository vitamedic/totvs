#include "rwmake.ch"
#include "topconn.ch"
#define DESLOC_ETQ  57

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT062   ³ Autor ³ Luis Marcelo          ³ Data ³ 03/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas para Mala Direta de Clientes                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMKR021(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGATMK                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


User Function VIT062()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo := "Etiquetas para mala-direta"
LOCAL cDesc1 := "Este programa   ira emitir as etiquetas"
LOCAL cDesc2 := "para a mala-direta de clientes         "
LOCAL cDesc3 := ""
LOCAL wnrel
LOCAL tamanho:= "G"
LOCAL cString:= "SA1"
LOCAL aOrd      := { ' Etiqueta - 36 X 81mm  4 colunas ' }
LOCAL aImp      := 0

PRIVATE aReturn := { "Etiqueta", 1,"Producao", 2, 2, 1, "",1 }
PRIVATE nomeprog:="VIT062"
PRIVATE aLinha  := { },nLastKey := 0

cPerg   :="PERGVIT062"
_pergsx1()
pergunte(cperg,.f.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Codigo inicial                    	 ³
//³ mv_par02        	// Codigo final                          ³
//³ mv_par03        	// A partir do CEP                       ³
//³ mv_par04        	// ate o CEP                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="VIT062"+Alltrim(cusername)            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,tamanho,"",.t.)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

ntipo:=if(areturn[4]==1,15,18)

If nLastKey == 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C021Imp(@lEnd,wnRel,cString)},Titulo)
Return(.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ C021IMP  ³ Autor ³ Luis Marcelo          ³ Data ³ 03/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TeleMarketing                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C021Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt
LOCAL titulo := "Etiquetas para mala-direta"
LOCAL cDesc1 := "Este programa   ira emitir as etiquetas"
LOCAL cDesc2 := "para a mala-direta de clientes         "
LOCAL cDesc3 := ""
LOCAL nTipo, nOrdem
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:= "P"
LOCAL limite := 80
LOCAL lContinua := .T.
LOCAL aEtiq[8,4]
LOCAL nEtiqueta := I := J := 1
LOCAL aOrd      := { ' Etiqueta - 36 X 81mm  4 colunas ' }
LOCAL aImp      := 0
LOCAL nEstaOk   := 0
LOCAL nContCol  := 1
LOCAL cPedi     := ""

#IFDEF WINDOWS
	Local lRet      := .F.
	Local cCadastro := "Etiquetas de Mala-direta"
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do cabecalho e tipo de impressao do relatorio      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 0
col      := 0
m_pag    := 1

titulo := "ETIQUETAS PARA MALA-DIRETA"
cabec1 := ""
cabec2 := ""

nTipo  := 18

nOrdem := aReturn[8]


_cfilsa1:=xfilial("SA1")
sa1->(dbsetorder(1))

processa({|| _querys()})


//dbSelectArea("SA1")
//Set SoftSeek On
//dbSeek(xFilial("SA1")+mv_par01)
//Set SoftSeek Off

//SetRegua(RecCount())		// Total de Elementos da regua
setregua(tmp1->(lastrec()))
tmp1->(dbgotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY AvalImp(Limite)

While ! tmp1->(eof()) .and. Lcontinua
	
	IncRegua()
	
	
	#IFNDEF WINDOWS
		If LastKey() = 286    //ALT_A
			lEnd := .t.
		Endif
	#ENDIF
	
	IF lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		EXIT
	ENDIF
	
	
	For I:=1 to 4
		cX := str(I,1)
		
		If nOrdem == 1
			If aImp == 0
				#IFNDEF WINDOWS
					Sav_Tel=savescreen(16,7,20,74)
					While nEstaOk != 2
						Set Devi To Print
						_n_Lin := pRow()
						_n_Col := pCol()
						@ _n_Lin,_n_Col PSAY chr( getMV( "MV_COMP" ) )
						setPrc( _n_Lin,_n_Col )
						For A := 1 To 8
							nContCol := 0
							For B := 1 to 4
								@ Li,nContCol PSAY Replicate("X",49)
								nContCol += DESLOC_ETQ
							Next B
							Li ++
						Next A
						MS_FLUSH()
						Li ++
						Set Devi to Screen
						Sav_Cor=SetColor()
						Screendraw("smt152",16,8,-1,1)
						nEstaOk := Menuh({"Nao","Sim"},18,57,"b/bg,w+/n,r/bg","NS","",1) //"Nao, Sim"
						Setcolor("&Sav_Cor")
					End
					RestScreen(16,7,20,74,Sav_Tel)
					Set Devi to Print
				#ELSE
					// Somente se for impressa a etiqueta emite a mensagem
					If aReturn[5] <> 1
						While !lRet
							lRet := (MsgYesNo("O Alinhamento da Impressora esta correto ?","Aten‡„o"))
						End
					Else
						lRet := .T.
					Endif
				#ENDIF
			Endif
			
			_n_Lin := pRow()
			_n_Col := pCol()
			@ _n_Lin,_n_Col PSAY chr( getMV( "MV_COMP" ) )
			setPrc( _n_Lin,_n_Col )
			
			aEtiq[1,nEtiqueta] := "Cliente: "+tmp1->cod
			aEtiq[2,nEtiqueta] := tmp1->nome
			aEtiq[3,nEtiqueta] := IIF(!empty(tmp1->ender),Subs(tmp1->ender,1,49),Subs(tmp1->endent,1,49))
			aEtiq[4,nEtiqueta] := AllTrim(tmp1->mun)+" - "+tmp1->est
			aEtiq[5,nEtiqueta] := "Cep: "+Trans(tmp1->cep,"@R 99999-999")
			aEtiq[6,nEtiqueta] := " "
			aEtiq[7,nEtiqueta] := " "
			aEtiq[8,nEtiqueta] := " "
			
			Do Case
				Case nEtiqueta <= 3
					nEtiqueta++
					
				Case nEtiqueta == 4
					
					nEtiqueta := 1
					For I:= 1 TO 8
						For J:=1 TO 4
							@Li , COL  PSAY aEtiq[I,J]
							COL += DESLOC_ETQ
						Next j
						Li++
						COL := 0
					Next I
					
					For I:= 1 TO 8
						For J:=1 TO 4
							aEtiq[I,J] := " "
						NEXT J
					NEXT I
					Li++
					
			EndCase
		EndIf
		
		
		tmp1->(dbskip())
	Next I
	
End

If nOrdem == 1
	For I:= 1 TO 8
		For J:=1 TO 4
			If !EMPTY(aEtiq[I,J])
				@Li , COL  PSAY aEtiq[I,J]
				COL += DESLOC_ETQ
			EndIf
		NEXT J
		Li++
		COL := 0
	Next I
EndIf
@ Li+1,0 PSAY " "
Setprc(0,0)

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return .t.

static function _querys()

//FILTRO DO RELATORIO
_filtro := aReturn[7]
_filtro := STRTRAN (_filtro,".And."," And " )
_filtro := STRTRAN (_filtro,".and."," And " )
_filtro := STRTRAN (_filtro,".Or."," Or ")
_filtro := STRTRAN (_filtro,".or."," Or ")
_filtro := STRTRAN (_filtro,"=="," = ")
_filtro := STRTRAN (_filtro,'"',"'")
_filtro := STRTRAN (_filtro,'Alltrim',"LTRIM")
_filtro := STRTRAN (_filtro,'$',"Like")

//Monta a Query de acordo com os parametros
_cquery:=" SELECT"
_cquery+=" A1_COD COD,"
_cquery+=" A1_NOME NOME,"
_cquery+=" A1_LOJA LOJA,"
_cquery+=" A1_END ENDER,"
_cquery+=" A1_ENDENT ENDENT,"
_cquery+=" A1_MUN MUN,"
_cquery+=" A1_EST EST,"
_cquery+=" A1_CEP CEP"
_cquery+=" FROM "
_cquery+=  retsqlname("SA1")+" SA1"
_cquery+=" WHERE"
_cquery+="     SA1.D_E_L_E_T_=' '"
_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
_cquery+=" AND A1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND A1_CEP BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND A1_ULTCOM BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"

// Considera filtro se não estiver vazio
if !empty(_filtro)
	_cquery+=" AND ("+_filtro+")"
endif

_cquery+=" ORDER BY A1_EST,A1_MUN,A1_NOME,A1_COD,A1_LOJA"  

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"

return




static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Cliente          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"02","Ate Cliente         ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"03","A partir do CEP     ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o CEP           ?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da Dt. Ult. Compra  ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate Dt. Ult. compra ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
