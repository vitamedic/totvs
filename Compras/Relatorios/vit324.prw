#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT324  ³ Autor ³ Reuber A. Moura Jr.   ³ Data ³ 14/08/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Adiciona Botão a Tela de Pedidos de Compra                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Abre tela de Follow-up para Pedidos de Compra              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


User function MT120BRW()


aadd(aRotina, { "Follow Up","U_GradeSZX" , 0 , 2}) 

Return

User Function GradeSZX(_nOpcao)

//PRIVATE _nOpc := _nOpcao
PRIVATE _nOpc := 3

PRIVATE oGrade2,btnOk,btCancela,btnConc,oGrp6,lblTeste,oSay9,oSay13,oSay14,oSay29,oSay21,oSBtn22,oSay23,oSay25,oSay17
oGrade2 := MSDIALOG():Create()
oGrade2:cName := "oGrade2"
oGrade2:cCaption := "Adicionando Follow-up"
oGrade2:nLeft := 0
oGrade2:nTop := 0
oGrade2:nWidth := 602
oGrade2:nHeight := 436
oGrade2:lShowHint := .F.
oGrade2:lCentered := .T.

btnOk := SBUTTON():Create(oGrade2)
btnOk:cName := "btnOk"
btnOk:cCaption := "Ok"
btnOk:cMsg := "Ok"
btnOk:cToolTip := "Ok"
btnOk:nLeft := 471
btnOk:nTop := 374
btnOk:nWidth := 52
btnOk:nHeight := 22
btnOk:lShowHint := .T.
btnOk:lReadOnly := .F.
btnOk:Align := 0
btnOk:lVisibleControl := .T.
btnOk:nType := 1
btnOk:bLClicked := {|| Confirma() }

btCancela := SBUTTON():Create(oGrade2)
btCancela:cName := "btCancela"
btCancela:cCaption := "Cancela"
btCancela:cMsg := "Cancela"
btCancela:cToolTip := "Cancela"
btCancela:nLeft := 530
btCancela:nTop := 373
btCancela:nWidth := 51
btCancela:nHeight := 23
btCancela:lShowHint := .T.
btCancela:lReadOnly := .F.
btCancela:Align := 0
btCancela:lVisibleControl := .T.
btCancela:nType := 2
btCancela:bLClicked := {|| Cancela() }


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦ú¿
//³Inicio de definições Manuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦úÙ
ENDDOC*/                         
dbSelectArea("SZX")
dbSetOrder(1)

dbSelectArea("SC7")

cNum   := SC7->C7_Num

oGrade2:Refresh()

aCampos := {"ZX_ITEM   ","ZX_DATA   ","ZX_OBS    " }

aHeader := U_CriaHeader("SZX",aCampos)          
aCols   := U_CriaSZM("SZX",1,"ZX_NUM",cNum,aHeader)

aCols := Asort(aCols,,,{|x,y|x[1]<y[1]})

nPosITEM   	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZX_ITEM"})
nPosDATA  	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZX_DATA"})
nPosOBS   	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZX_OBS"})


@ 15,05 TO 175,295 MULTILINE MODIFY DELETE VALID .t.

oGrade2:Activate()

Return(.t.)


Static Function Cancela()

Close(oGrade2)

Return(.t.)



Static Function Confirma()

if !empty(SC7->C7_Num) 
	if MsgYesNo("Confirmar os Dados?")
		GravaCols()
	endif
	
	Close(oGrade2)
	
	/*ENVIANDO WORKFLOW*/
	U_ENV324A()
	
else

	MsgBox("Campos obrigatórios não preenchidos!")
	
endif

Static Function GravaCols()
	dbSelectArea("SZX")
	dbSetOrder(1)
	/* Verificando se todos os itens estão preenchidos */
	vproxitem:=0
	for i := 1 to len(aCols)
	    if val(aCols[i][1]) >= vproxitem
           vproxitem:=val(aCols[i][1])+1
	    endif
	next
	for i := 1 to len(aCols)
	    if val(aCols[i][1]) = 0
   	       aCols[i][1]:=strzero(vproxitem,3)
           vproxitem:=vproxitem+1
	    endif
	next
	
	/*termino*/
	
	for i := 1 to len(aCols)
		if aCols[i][len(aHeader)+1]==.t.
			if dbSeek(xFilial("SZX")+cNum+aCols[i][1])
				RecLock("SZX",.f.)
				dbDelete()				
				MsUnlock()
			endif
		else
			if dbSeek(xFilial("SZX")+cNum+aCols[i][1])
				RecLock("SZX",.f.)
				SZX->ZX_ITEM    := aCols[i][nPosITEM]
				SZX->ZX_DATA  	:= aCols[i][nPosDATA]
				SZX->ZX_OBS    	:= aCols[i][nPosOBS]
				MsUnlock()
			else
				RecLock("SZX",.t.)
				SZX->ZX_FILIAL	:= xFilial("SZX")
				SZX->ZX_NUM     := SC7->C7_Num
				SZX->ZX_ITEM    := aCols[i][nPosITEM]
				SZX->ZX_DATA  	:= aCols[i][nPosDATA]
				SZX->ZX_OBS    	:= aCols[i][nPosOBS]
				MsUnlock()
			endif
		endif
    next i
return(.t.)


/***************************************************************************************************************************************/
// Monta vetor tipo Cols de acordo com os parametros
User Function CriaSZM(cAlias,nIndice,cCpoAmarr,cChave,aHeader,cFiltro)

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
			    aRet[1][i] := date()
			case aHeader[i][8]=="L"
			    aRet[1][i] := .t.
		endcase
	next i
    aRet[1][len(aHeader)+1] := .f. //Flag de Delecao
    aRet[1][1] := '001' //item
endif	
dbSelectArea(cAliasAnt)
dbSetOrder(nIndAnt)

Return(aRet)
/***************************************************************************************************************************************/

USER FUNCTION ENV324A()
_aareasc7:=sc7->(getarea())
_aareasa2:=sa2->(getarea())
_aareaszx:=szx->(getarea())
_aarease4:=se4->(getarea())

_cfilsa2:=xfilial("SA2")
_cfilsc7:=xfilial("SC7")
_cfilse4:=xfilial("SE4")
_cfilszx:=xfilial("SZX")

_cquery:=" SELECT SC7.C7_NUM, "
_cquery+="        SC7.C7_ITEM, "
_cquery+="        SC7.C7_PRODUTO, "
_cquery+="        SC7.C7_DESCRI, "
_cquery+="        SC7.C7_UM, "
_cquery+="        SC7.C7_QUANT, "
_cquery+="        SC7.C7_LOCAL, "
_cquery+="        SC7.C7_PRECO, "
_cquery+="        SC7.C7_TOTAL, "
_cquery+="        SC7.C7_DATPRF, "
_cquery+="        SC7.C7_FORNECE, "
_cquery+="        SC7.C7_LOJA, "
_cquery+="        SA2.A2_NREDUZ, "
_cquery+="        SA2.A2_TEL, "
_cquery+="        SC7.C7_CONTATO, "
_cquery+="        SC7.C7_EMISSAO, "
_cquery+="        SC7.C7_COND, "
_cquery+="        SE4.E4_COND "
_cquery+=" FROM  "
_cquery+=  retsqlname("SC7")+" SC7,"
_cquery+=  retsqlname("SA2")+" SA2,"
_cquery+=  retsqlname("SE4")+" SE4"
_cquery+=" WHERE SC7.C7_NUM = '"+SC7->C7_NUM+"'"
_cquery+=" AND SC7.C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND SA2.A2_FILIAL='"+_cfilsa2+"'"
_cquery+=" AND SE4.E4_FILIAL='"+_cfilse4+"'"
_cquery+=" AND SC7.D_E_L_E_T_ = ' ' "
_cquery+=" AND SA2.D_E_L_E_T_ = ' ' "
_cquery+=" AND SE4.D_E_L_E_T_ = ' ' "
_cquery+=" AND SC7.C7_FORNECE = SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA "
_cquery+=" AND SC7.C7_COND = SE4.E4_CODIGO "
_cquery+=" ORDER BY SC7.C7_ITEM"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","C7_EMISSAO" ,"D",08,0)
tcsetfield("TMP1","C7_DATPRF" ,"D",08,0)
tcsetfield("TMP1","C7_QUANT","N",15,2)
tcsetfield("TMP1","C7_PRECO","N",17,6)
tcsetfield("TMP1","C7_TOTAL","N",15,2)



_cquery:=" SELECT ZX_ITEM, "
_cquery+="        ZX_DATA, "
_cquery+="        ZX_OBS "
_cquery+=" FROM  "
_cquery+=  retsqlname("SZX")+" SZX "
_cquery+=" WHERE ZX_NUM = '"+SC7->C7_NUM+"'"
_cquery+=" AND SZX.D_E_L_E_T_ = ' ' "
_cquery+=" ORDER BY ZX_ITEM"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP2"
tcsetfield("TMP2","ZX_DATA" ,"D",08,0)


oProcess := TWFProcess():New( "000001", "FOLLOW-UP PEDIDO DE COMPRA" )

oProcess:NewTask( "000001", "\workflow\wpedcompra.htm" )

oProcess:cSubject := "FOLLOW-UP PEDIDO N.o: "+SC7->C7_NUM+" - "+TMP1->A2_NREDUZ

oProcess:bReturn := ""

oProcess:bTimeOut := {}

oHTML := oProcess:oHTML                      

_ctopcp :=.f.
_ctocq  :=.f.
_ctolog :=.f.
_ctoman :=.f.

oHTML:ValByName("NUMPED"    ,tmp1->c7_num)
oHTML:ValByName("EMISSAO"   ,tmp1->c7_emissao)
oHTML:ValByName("CONDPAGTO" ,tmp1->e4_cond)
oHTML:ValByName("FORNECEDOR",tmp1->c7_fornece+"/"+tmp1->c7_loja+"->"+tmp1->a2_nreduz)
oHTML:ValByName("FONE"      ,tmp1->a2_tel)
oHTML:ValByName("CONTATO"   ,tmp1->c7_contato)

tmp1->(dbgotop())     
vtotitens:=0
vdatprf:=tmp1->c7_datprf
while ! tmp1->(eof())
	aadd((oHtml:valByName("SC7.ITP"))      ,tmp1->c7_item)
	aadd((oHtml:valByName("SC7.CODIGO"))   ,tmp1->c7_produto)
	aadd((oHtml:valByName("SC7.DESCRICAO")),tmp1->c7_descri)
	aadd((oHtml:valByName("SC7.UN"))       ,tmp1->c7_um)
	aadd((oHtml:valByName("SC7.DATPRF"))   ,tmp1->c7_datprf)
	aadd((oHtml:valByName("SC7.QUANT"))    ,alltrim(transform(tmp1->c7_quant,"@E 999,999,999.99")))
	aadd((oHtml:valByName("SC7.PRECO"))    ,alltrim(transform(tmp1->c7_preco,"@E 9,999,999.999999")))
	aadd((oHtml:valByName("SC7.TOTAL"))    ,alltrim(transform(tmp1->c7_total,"@E 999,999,999.99")))
	vtotitens:=vtotitens+tmp1->c7_total
	if tmp1->c7_datprf > vdatprf 
   	   vdatprf:=tmp1->c7_datprf
	endif

	if (tmp1->c7_local=="02") .or. (tmp1->c7_local=="03")
		_ctopcp := .t.
	elseif (tmp1->c7_local=="05")
		_ctolog := .t.		
	elseif (tmp1->c7_local=="06")
		_ctocq  := .t.		
	elseif (tmp1->c7_local=="07")
		_ctoman := .t.		
	endif
	tmp1->(dbskip())

end
oHTML:ValByName("TOTITENS"   ,alltrim(transform(vtotitens,"@E 999,999,999.99")))


tmp2->(dbgotop())
while ! tmp2->(eof())
	
	aadd((oHtml:valByName("SZX.ITF"))    ,tmp2->zx_item)
	aadd((oHtml:valByName("SZX.DATAF"))  ,tmp2->zx_data)
	aadd((oHtml:valByName("SZX.ASSUNTO")),tmp2->zx_obs)
	
	tmp2->(dbskip())
end                     
              
_send:=.f.

if vdatprf <= date()  
	if (tmp1->c7_local=="02") .or. (tmp1->c7_local=="03")
		_ctopcp := .t.
	elseif (tmp1->c7_local=="05")
		_ctolog := .t.		
	elseif (tmp1->c7_local=="06")
		_ctocq  := .t.		
	elseif (tmp1->c7_local=="07")
		_ctoman := .t.		

	elseif _ctopcp

		oProcess:cto := "report_comercial@vitamedic.ind.br;report_pcp@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;"    // Guilherme Teodoro em 08/07/2016 - Correção dos emails
	elseif _ctolog
		oProcess:cto := "report_comercial@vitamedic.ind.br;report_logistica@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_almoxarifado@vitamedic.ind.br;"
	elseif _ctocq
		oProcess:cto := "report_comercial@vitamedic.ind.br;report_cql@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;"
	elseif _ctoman
		oProcess:cto := "report_comercial@vitamedic.ind.br;report_manutencao@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;"
	else
		oProcess:cto := "report_comercial@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;"
	endif
	_send:=.t.

elseif _ctopcp

	oProcess:cto := "report_pcp@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;"
	_send:=.t.
elseif _ctolog
	oProcess:cto := "report_logistica@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;report_almoxarifado@vitamedic.ind.br;"	
	_send:=.t.
elseif _ctocq
	oProcess:cto := "report_cql@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;"	
	_send:=.t.
elseif _ctoman
	oProcess:cto := "report_manutencao@vitamedic.ind.br;report_suprimentos@vitamedic.ind.br;report_logistica@vitamedic.ind.br;"	
	_send:=.t.
endif


if _send
	oProcess:ccc := ""
	
	oProcess:UserSiga := "__cuserid"
	
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'100001')
	oProcess:Start()
	
	wfsendmail()
endif	
tmp1->(dbclosearea())
tmp2->(dbclosearea())

return(.t.)


