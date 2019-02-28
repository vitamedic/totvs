#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT373    ³ Autor ³ Andre Almeida       ³ Data ³ 19/03/12  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Envia Relatorio de Nota de Débito E-Mail                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/



User Function vit373

_dUsuario     := PSWRET()
_nomeUsuario  := _dUsuario[1][4]
_emailUsuario := _dUsuario[1][14]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Muda o parametro para enviar no corpo do e-mail³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMvAtt := GetMv("MV_WFHTML")
	PutMv("MV_WFHTML",.F.) // No inicio T envia no corpo, F envia anexo.

	cperg:="PERGVIT373"

	_agrpsx1:={}
	aadd(_agrpsx1,{cperg,"01","Numero da Nota de Debito        ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01",space(15),space(30),space(15),space(15),space(30),space(15),space(15),space(30),space(15),space(15),space(30),space(15),space(15),space(30),"SZ6"})
	u_pergsx1()
	if pergunte(cperg,.t.)	
		_cprocwf:="000008"
		
		WF1->(dbsetorder(1))
		WF1->(dbseek(xfilial("WF1")+_cprocwf))
		
		_cpara := _emailUsuario
//		_cpara := "gti@vitamedic.ind.br"//alltrim(wf1->wf1_para)
		_ccc   := ""//alltrim(wf1->wf1_cc)
		_cco   := ""//alltrim(wf1->wf1_cco)
		
		
		oprocess:=twfprocess():new(_cprocwf,wf1->wf1_descr)
		oprocess:newtask("000008","\workflow\nota_debito.htm")
		ohtml:=oprocess:ohtml

		SZ6->(dbsetorder(1))
		if SZ6->(dbseek(xfilial("SZ6")+mv_par01))
			
			ohtml:valbyname("NUMERO"      ,SZ6->Z6_NUMERO)
			ohtml:valbyname("MOTIVO"      ,SZ6->Z6_MOTIVO)
			ohtml:valbyname("LOCAL"       ,SZ6->Z6_LOCAL)
			ohtml:valbyname("DATA"        ,DTOC(SZ6->Z6_DATA))
			ohtml:valbyname("VEND"        ,SZ6->Z6_VEND)
			ohtml:valbyname("CCLI"        ,SZ6->Z6_CLI)
			ohtml:valbyname("RAZAO"       ,SZ6->Z6_RAZAO)
			ohtml:valbyname("END"      	  ,SZ6->Z6_END)
			ohtml:valbyname("BAIRRO"      ,SZ6->Z6_BAIRRO)
			ohtml:valbyname("CIDADE"      ,SZ6->Z6_MUN)
			ohtml:valbyname("CEP"         ,Transform(SZ6->Z6_CEP,"@R 99999-999"))
			ohtml:valbyname("UF"      	  ,SZ6->Z6_UF)
			ohtml:valbyname("TEL"         ,SZ6->Z6_TEL)
			ohtml:valbyname("FAX"         ,SZ6->Z6_FAX)
			ohtml:valbyname("CNPJ"        ,Transform(SZ6->Z6_CNPJ,"@999.999.999/9999-99"))
			ohtml:valbyname("INSC"        ,Transform(SZ6->Z6_INSC,"@999.999.999"))
			ohtml:valbyname("PBRUTO"      ,SZ6->Z6_PBRUTO)
			ohtml:valbyname("PLIQUIDO"    ,SZ6->Z6_PLIQUID)
			ohtml:valbyname("COD1"        ,SZ6->Z6_COD1)
			ohtml:valbyname("DESC1"       ,SZ6->Z6_DESC1)
			ohtml:valbyname("UNIT1"       ,SZ6->Z6_QTUNT1)
			ohtml:valbyname("PRCUNIT1"    ,Transform(SZ6->Z6_PRC1,"@E 99,999,999,999.99",18,2))
			ohtml:valbyname("TOTAL1"      ,Transform(SZ6->Z6_TOT1,"@E 99,999,999,999.99",18,2))
			if !empty(SZ6->Z6_cod2)
				ohtml:valbyname("COD2"        ,SZ6->Z6_COD2)
				ohtml:valbyname("DESC2"       ,SZ6->Z6_DESC2)
				ohtml:valbyname("UNIT2"       ,SZ6->Z6_QTUNT2)
				ohtml:valbyname("PRCUNIT2"    ,Transform(SZ6->Z6_PRC2,"@E 99,999,999,999.99",18,2))
				ohtml:valbyname("TOTAL2"      ,Transform(SZ6->Z6_TOT2,"@E 99,999,999,999.99",18,2))
				if !empty(SZ6->Z6_cod3)			
					ohtml:valbyname("COD3"        ,SZ6->Z6_COD3)
					ohtml:valbyname("DESC3"       ,SZ6->Z6_DESC3)
					ohtml:valbyname("QTUNIT3"     ,SZ6->Z6_QTUNT3)
					ohtml:valbyname("PRCUNIT3"    ,Transform(SZ6->Z6_PRC3,"@E 99,999,999,999.99",18,2))
					ohtml:valbyname("TOTAL3"      ,Transform(SZ6->Z6_TOT3,"@E 99,999,999,999.99",18,2))
				endif
			endif
			ohtml:valbyname("TOTVOL"      ,SZ6->Z6_TOTVOL)
			ohtml:valbyname("VLPED"       ,SZ6->Z6_VLPED)
			ohtml:valbyname("VLPROD"      ,SZ6->Z6_VLPROD)
			ohtml:valbyname("INFORM"      ,SZ6->Z6_INFORMA)
	
			oprocess:csubject:="Nota de débito da Transportadora - "+Alltrim(SZ6->Z6_RAZAO)
			oprocess:cto:=_cpara
			oprocess:ccc:=_ccc
			oprocess:cbcc:=""
			oprocess:breturn:=""
			oprocess:btimeout:={}
			oprocess:start()
			wfsendmail()
    	else
    		Alert("Não foi encontrado um Nota de Debito com este Código.")
    	endif
	endif
	PutMv("MV_WFHTML",cMvAtt) //No Final
return