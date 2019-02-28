/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT324  ³ Autor ³ Andre Almeida Alves   ³ Data ³ 01/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatório de Ordem de Serviço                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Emissão de relatório de O.S. - HTML                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"

User Function vit381()

_dUsuario     := PSWRET()
_nomeUsuario  := _dUsuario[1][4]
_emailUsuario := _dUsuario[1][14]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Muda o parametro para enviar no corpo do e-mail³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMvAtt := GetMv("MV_WFHTML")
	PutMv("MV_WFHTML",.F.) // No inicio T envia no corpo, F envia anexo.

	cperg:="PERGVIT381"

	_agrpsx1:={}
	aadd(_agrpsx1,{cperg,"01","Numero da Ordem de Serviço ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01",space(15),space(30),space(15),space(15),space(30),space(15),space(15),space(30),space(15),space(15),space(30),space(15),space(15),space(30),"STJ"})
	aadd(_agrpsx1,{cperg,"02","E-mail / Browser ?","mv_ch2","N",01,0,0,"C",space(60),"mv_par02"       ,"E-mail"            ,space(30),space(15),"Browser"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"      "})
	u_pergsx1()

	if pergunte(cperg,.t.)
		_cprocwf:="000010"

		WF1->(dbsetorder(1))
		WF1->(dbseek(xfilial("WF1")+_cprocwf))

		_cpara := _emailUsuario
		_ccc   := ""//alltrim(wf1->wf1_cc)
		_cco   := ""//alltrim(wf1->wf1_cco)


		oprocess:=twfprocess():new(_cprocwf,"Ordem de Serviço")
		oprocess:newtask("000010","\workflow\ordemservico.htm")
		ohtml:=oprocess:ohtml

		STJ->(dbsetorder(1))
		if STJ->(dbseek(xfilial("STJ")+mv_par01))

			TQB->(dbsetorder(1))
			TQB->(dbseek(xfilial("TQB")+STJ->TJ_SOLICI))

			ohtml:valbyname("NUMOS"      	,STJ->TJ_ORDEM)
			ohtml:valbyname("SETOR"      	,Posicione("CTT",1,xFilial("CTT")+STJ->TJ_CCUSTO,"CTT_DESC01"))
			ohtml:valbyname("DATA"      		,dtoc(STJ->TJ_DTORIGI)+"Hora: "+TQB->TQB_HOABER)
			if !empty(TQB->TQB_USUARI)
				ohtml:valbyname("SOLICITANTE"   ,TQB->TQB_USUARI)
			else
				ohtml:valbyname("SOLICITANTE"   ,"O.S. Aberta sem Solicitacao de Servico")
			endif
			ohtml:valbyname("CCUSTO"			,STJ->TJ_CCUSTO)
			ohtml:valbyname("EQUIP"		    ,Posicione("ST9",1,xFilial("ST9")+STJ->TJ_CODBEM,"T9_NOME"))
			ohtml:valbyname("TAG"			,STJ->TJ_CODBEM)
			_cDescri	:= Alltrim(STJ->TJ_OBSERVA)
			if len(_cDescri) < 85
				ohtml:valbyname("DESC1"			,substr(_cDescri,1,84))
			elseif len(_cDescri) >= 85 .and. len(_cDescri) < 170
				ohtml:valbyname("DESC1"			,substr(_cDescri,1,84))
				ohtml:valbyname("DESC2"			,substr(_cDescri,85,169))
			elseif len(_cDescri) >= 170 .and. len(_cDescri) < 255
				ohtml:valbyname("DESC1"			,substr(_cDescri,1,84))
				ohtml:valbyname("DESC2"			,substr(_cDescri,85,169))
				ohtml:valbyname("DESC3"			,substr(_cDescri,170,254))
			elseif len(_cDescri) >= 255 .and. len(_cDescri) < 340
				ohtml:valbyname("DESC1"			,substr(_cDescri,1,84))
				ohtml:valbyname("DESC2"			,substr(_cDescri,85,169))
				ohtml:valbyname("DESC3"			,substr(_cDescri,170,254))
				ohtml:valbyname("DESC4"			,substr(_cDescri,255,339))
			endif

			ohtml:valbyname("TIPOSERV"		,Posicione("STE",1,xFilial("STE")+STJ->TJ_TIPO,"TE_NOME"))
			ohtml:valbyname("CATEG"			,Posicione("STD",1,xFilial("STD")+STJ->TJ_CODAREA,"TD_NOME"))

			if !ExistDir("C:\temp\")
				MakeDir("C:\temp\")
			endif
			if mv_par02 = 2
				_cpara := " "
			endif
			oprocess:csubject:="Ordem de Serviço - "+Alltrim(STJ->TJ_ORDEM)
			oprocess:cto:=_cpara
			oprocess:ccc:=_ccc
			oprocess:cbcc:=""
			oprocess:breturn:=""
			oprocess:btimeout:={}
			oprocess:start()

			_carquivo:=oprocess:aattfiles[1]
			_cArq := substr(_carquivo,22,24)
			cpys2t(_carquivo,"C:\temp\",.t.)
			wfsendmail()

			if mv_par02 = 2
				shellexecute("open",_cArq,"","C:\temp\",1)
			endif
    	else
    		Alert("Não foi encontrado uma O.S. com este Código.")
    	endif
	endif
	PutMv("MV_WFHTML",cMvAtt) //No Final
return
