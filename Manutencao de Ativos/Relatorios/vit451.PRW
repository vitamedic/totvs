#Include 'Protheus.ch'
#Include 'Colors.ch'
#Include 'Tbiconn.ch'       
#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VIT425    º Autor ³ Leandro Fiuza    º Data ³  18/05/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ordem de serviço de manutenção  							  º±±
±±º          ³                                                  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitapan                                        			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function vit451()  //u_vit451()
Local aArea   			:= GetArea()
Local aOrd  			:= {}
Local cDesc1 			:= "Ordem De Serviço De Manutenção."
Local cDesc2 			:= ""
Local cDesc3 			:= ""

Private nRowProd := 0
Private nomeprog 		:= "O.S"
Private cPerg    		:= "vit451" //perguntas                              
//aReturn[4] 1- Retrato, 2- Paisagem
//aReturn[5] 1- Em Disco, 2- Via Spool, 3- Direto na Porta, 4- Email
Private aReturn  		:= {"Zebrado", 1,"Administracao", 1, 3, 1, "",1 }	//"Zebrado"###"Administracao"
Private Tamanho			:= "G"
Private wnrel        	:= "O.S"            //Nome Default do relatorio em Disco
Private cString     	:= ""
Private titulo  		:= "Ordem De Serviço De Manutenção."
Private nPage			:= 1                                                          

Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
Private oFont12		:= TFONT():New("Courier new",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
Private oFont12N	:= TFONT():New("Courier new",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
Private oFont14		:= TFONT():New("Courier new",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
Private oFont14N	:= TFONT():New("Courier new",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
Private oFont16  	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
Private oFont16N	:= TFONT():New("Courier new",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
Private teste1 			:= 0
Private nLin 			:= 0
Private nCol 			:= 0
Private nLin2           := 0
Private nLin3			:= 0
Private Cont			:= 0
Private Cont1			:= 0
Private Cont2			:= 0
Private nLinhas			:= ""
Private nLrat			:= 0
Private cTxtLinha		:= ""
Private _obs			:= ""
Private colTexto:= 1       
Private ntamtexto:= 0
Private wTotal			:= 0
Private numRpa 			:= 0
Private m1 := [0]
Private desc1 := ""
Private nXi := 0
Private nI := 0
Private IncLinha := 0
Public _oPrint
Private cLogoD
Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
//   cLogoD     := cStartPath + "LGRL" + cFilAnt + ".IBMP"
cLogoD     :=  "LGRLM" + cEmpAnt+ ".BMP"
//	path += IF(RIGHT(path,1) <> "\","\","")

pergunte(cperg,.T.)   
wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho)
SetDefault(aReturn,cString,,,Tamanho,,)

nOrdem :=  aReturn[8]

//GeraX1(cPerg)
IIf(Pergunte(cPerg, .F.,"Parametros do Relatório",.F.),Nil,Nil) //aBRE OS PARAMETROS DUAS VEZES
//SetDefault(aReturn,cString,,,nTamanho,,)   //ABRE A TELA DO DIRETORIO PRA SALVAR SE É PREVIEW NAÕ TEM NECESSIDADE
If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| lPrint(@lEnd,wnRel)},Titulo)  // Chamada do Relatorio

If !Empty(aArea)                                                     
	RestArea(aArea)
	//aArea
EndIf
return nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Layout do Relatorio                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function lPrint(lEnd,WnRel)

oPrint := TMSPrinter():New()

oPrint:SetPortrait() //retrato
//oPrint:SetLandscape() //paisagem

If oPrint:nLogPixelY() < 300
	MsgInfo("Impressora com baixa resolução o modo de compatibilidade será acionado!")
	oPrint:SetCurrentPrinterInUse()
EndIf

//Chama função para buscar dados
Dados()
If Select("TEMP") > 0
	//Posiciona no inicio do arquivo
	TEMP->(DbGoTop())
	//Chama função para imprimir dados
	getHeader(@nPage)
	//quebraDePg(@nLin,@nPage)
endif

oPrint:EndPage()
oPrint:Preview()

//Libera o arquivo do relatório
MS_FLUSH()
Return Nil                         



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function getHeader(nPage)

//Chama função para buscar dados
Dados()

dbselectarea("TEMP")
cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
nLin+=100

nLin+=100

oPrint:SayBitmap(20, 10, cStartPath + cLogoD , 300, 220)	///Impressao da Logo

oPrint:Say(nLin,750, "Ordem De Serviço Programada " + TEMP->tj_ordem, oFont16N)
oPrint:Say(nLin+70,50,"Inicio: " + temp->dt_inicio +" "+ temp->hr_inicio,oFont10)
oPrint:Say(nLin+70,750,"Fim: " + temp->dt_fim +" "+ temp->hr_fim,oFont10)         
oPrint:Say(nLin+150,50,"Execução Inicio: ___/___/___ Hora: __:__   Fim:___/___/___ Hora: __:__",oFont10)
oPrint:Say(nLin+230,750,"Bem / Localização",oFont16N)
oPrint:Say(nLin+310,50,"Bem....: "+alltrim(temp->t9_codbem) +" "+temp->t9_nome,oFont10)
oPrint:Say(nLin+370,50,"C.Custo: "+alltrim(temp->t9_ccusto) +" "+temp->ctt_desc01,oFont10)
oPrint:Say(nLin+430,50,"C.Trab.: "+alltrim(temp->t9_codfami)+" "+t6_nome,oFont10)
oPrint:Say(nLin+510,750,"Manutenção",oFont16N)
oPrint:Say(nLin+590,50,"Serviço..: "+alltrim(temp->tf_servico)+" "+temp->tf_nomeman,oFont10)
oPrint:Say(nLin+670,50,"Área.....: "+alltrim(temp->tf_codarea)+" "+td_nome,oFont10)
oPrint:Say(nLin+750,50,"Tipo.....: "+alltrim(temp->tf_tipo)   +" "+temp->te_nome,oFont10)
oPrint:Say(nLin+830,50,"Parada...: Antes:           ___/___/___           Depois:           ___/___/___",oFont10)
oPrint:Say(nLin+910,750,"Descrição do serviço a executar",oFont16N)                                                                   

nLin:= nLin+990
nCol:= 50    
desc1:= StrTran(temp->tf_descric,"  ","")
if !empty(temp->tf_descric1)
	desc1+= StrTran(temp->tf_descric1,"  ","")
Endif
desc2:= StrTran(temp->tj_observa,"  ","")
_obs := desc1+"  "+desc2

For nXi := 1 To MLCount(_obs,,,.T.)
     If ! Empty(MLCount(_obs,,,.T.))
          If ! Empty(MemoLine(_obs,,nXi))
			   oPrint:Say(nLin,50,Alltrim(MemoLine(_obs,,nXi)),oFont8N)
          EndIf
     EndIf
     nLin:= nLin+ 50
     nCol:= nCol+ 100
Next nXi             

If nXi >= 13 // Quebrar pagina caso a Descrição do serviço a executar fique maior que suportado.
oPrint:EndPage() 
oPrint:StartPage()

nLin := 0 

oPrint:Say(nLin+100,750,"Ocorrências",oFont16N)
oPrint:Say(nLin+150,50,"Solução: ",oFont10)                                           

nLin:= 155
While cont1 < 16
oPrint:Say(nLin,50,"____________________________________________________________________________________________________________________",oFont10)
cont1:= cont1 + 1
nLin:= nLin + 40
EndDo                 

nLin:= 0

oPrint:Say(nLin+820,750,"Materiais Utilizados",oFont16N)                              
oPrint:Say(nLin+850,50," Código ",oFont10)                                           
oPrint:Say(nLin+850,300," Qtd",oFont10)
oPrint:Say(nLin+850,500," Descrição ",oFont10)                                           

nLin:= 855  

while cont < 20
oPrint:Say(nLin,50,"|____________|_________|____________________________________________________________________________________________|",oFont10)
cont := cont+1
nLin:= nLin + 40
EndDo

nLin:= 1640 
                                                  
oPrint:Say(nLin+100,750,"Executado Por",oFont16N)                              
oPrint:Say(nLin+150,50," Data",oFont10)                                                                                                 
oPrint:Say(nLin+150,300," Hora Início",oFont10)                  	                                                                    
oPrint:Say(nLin+150,571," Hora Fim ",oFont10)                  	                                                                    
oPrint:Say(nLin+150,870," Técnico ",oFont10)                                           

nLin:= 1800 
nCol:= 57

while cont2 < 12
oPrint:Say(nLin,50,"|___________|______________|______________|___________________________________________________________________________|",oFont10)
cont2 := cont2+1
nLin:= nLin + 40
EndDo

nLin := 2350

oPrint:Say(nLin+150,50,(" Data:___/___/___"), oFont10n)
oPrint:Say(nLin+150,400,(" Ass.PCM/Gerência:_________________________________________________________________________________ "), oFont10n)           

Return
EndIf

nLin := 1810 
oPrint:Say(nLin,750,"Ocorrências",oFont16N)
nLin := 1834
oPrint:Say(nLin,50,"Solução: ",oFont10)                                           

nLin:= 1835
While cont1 < 16
oPrint:Say(nLin,50,"____________________________________________________________________________________________________________________",oFont10)
cont1:= cont1 + 1
nLin:= nLin + 40
EndDo                 

nLin:= 0

oPrint:Say(nLin+2500,750,"Materiais Utilizados",oFont16N)                              
oPrint:Say(nLin+2550,50," Código",oFont10)                                           
oPrint:Say(nLin+2550,300," Qtd",oFont10)                                              
oPrint:Say(nLin+2550,500," Descrição ",oFont10)                                           

nLin:= 2560

while cont < 20
oPrint:Say(nLin,50,"|____________|_________|____________________________________________________________________________________________|",oFont10)
cont := cont+1
nLin:= nLin + 40
EndDo

oPrint:EndPage() 
oPrint:StartPage()           

nLin:= 0 

oPrint:Say(nLin+100,750,"Executado Por",oFont16N)                              
oPrint:Say(nLin+150,50," Data",oFont10)                                                                                                 
oPrint:Say(nLin+150,300," Hora Início",oFont10)                  	                                                                    
oPrint:Say(nLin+150,570," Hora Fim ",oFont10)                  	                                                                    
oPrint:Say(nLin+150,870," Técnico ",oFont10)                                           

nLin:= 155
nCol:= 57

while cont2 < 12
oPrint:Say(nLin,50,"|___________|______________|______________|___________________________________________________________________________|",oFont10)
cont2 := cont2+1
nLin:= nLin + 40
EndDo

nLin := 750

oPrint:Say(nLin+200,50,(" Data:___/___/___"), oFont10n)
oPrint:Say(nLin+200,400,(" Ass.PCM/Gerência:_________________________________________________________________________________ "), oFont10n)

Return Nil
                                            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca dados para tabela temporaria                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Dados()
Local pedido := ""                                
Local fatura := ""

cQuery:="select "
cQuery+="tj_ordem,substr(tj_dtmpini,7,2)||'/'||substr(tj_dtmpini,5,2)||'/'||substr(tj_dtmpini,1,4) dt_inicio,tj_hompini hr_inicio,substr(tj_dtmpfim,7,2)||'/'||substr(tj_dtmpfim,5,2)||'/'||substr(tj_dtmpfim,1,4) dt_fim,tj_hompfim hr_fim, "
cQuery+="t9_codbem,t9_nome,t9_ccusto,ctt_desc01,t9_codfami,t6_nome,tf_servico,tf_nomeman, "
cQuery+="tf_seqrela,tf_codarea,td_nome,tf_tipo,te_nome, "
//cQuery+="UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(tf_descric, 2000,1))tf_descric,UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(tf_descric, 4000,2000))tf_descric1,
cQuery+="UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(tf_descric, 2000,1))tf_descric,
cQuery+=" trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(tj_observa, 4000,1))) tj_observa "
cQuery+="from "+RetSqlName("stj")+" stj "
cQuery+="inner join st9010 st9 on st9.d_e_l_e_t_ <> '*' and t9_codbem = tj_codbem "
cQuery+="inner join stf010 stf on stf.d_e_l_e_t_ <> '*' and tf_codbem = tj_codbem and tf_codarea = tj_codarea "
cQuery+="inner join ctt010 ctt on ctt.d_e_l_e_t_ <> '*' and ctt_custo = t9_ccusto "
//cQuery+="inner join shb010 shb on shb.d_e_l_e_t_ <> '*' and hb_cod = t9_codfami "
cQuery+="inner join st6010 st6 on st6.d_e_l_e_t_ <> '*' and t6_codfami = t9_codfami " 
cQuery+="inner join std010 std on std.d_e_l_e_t_ <> '*' and td_codarea = tf_codarea "
cQuery+="inner join ste010 ste on ste.d_e_l_e_t_ <> '*' and te_tipoman = tf_tipo "
cQuery+="where stj.d_e_l_e_t_ <> '*' and tj_ordem = '"+mv_par01+"' and tf_servico = '"+mv_par02+"'"

Memowrite('C:\TOTVS\OS.txt', cQuery)

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TEMP") <> 0
	DbSelectArea("TEMP")
	DbCloseArea()
ENDIF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TEMP",.T.,.T.)  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSx1      ³ Autor ³ Leandro José     ³ Data ³23/02/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta SX1                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ A partir do Release 4                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSx1()

Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}
Local cHelp		:= ""
Local aPrgs		:= {}
Local aArea		:= SX1->(GetArea())

/*X1_GRUPO|X1_ORDEM|X1_PERGUNT          |X1_PERSPA          |X1_PERENG          |X1_VARIAVL|X1_TIPO|X1_TAMANHO|X1_DECIMAL|X1_PRESEL|X1_GSC|X1_VALID  |X1_VAR01  |X1_DEF01|X1_DEFSPA1|X1_DEFENG1|X1_CNT01|X1_VAR02|X1_DEF02|X1_DEFSPA2|X1_DEFENG2|X1_CNT02|X1_VAR03|X1_DEF03 |X1_DEFSPA3|X1_DEFENG3|X1_CNT03 |X1_VAR04|X1_DEF04 |X1_DEFSPA4|X1_DEFENG4|X1_CNT04|X1_VAR05 |X1_DEF05    |X1_DEFSPA5  |X1_DEFENG5  |X1_CNT05 |X1_F3|X1_PYME|X1_GRPSXG|X1_HELP|X1_PICTURE|X1_IDFIL*/
/*0        |1       |2                   |3                  |4                  |5         |6      |7         |8         |9        |0     |1         |2         |3       |4         |5         |6 	   |7       |8       |9         |0         |1       |2 	     |3        |4         |5         |6        |7       |8        |9         |0 		|1       |2        |3           |4 	         |5 	      |6 	    |7    |8 	  |9    	|0 	    |1		   |2       */
PutSx1("vit451"  ,"01"    ,"Ordem Serviço?"		   ,"Ordem Serviço?"	   ,"Ordem Serviço?"   ,"mv_ch1"  ,"C"    ,06        ,0         ,0        ,"G"   ,""		,"mv_par01",""      ,""        ,""		  ,""	   ,""      ,""      ,""        ,""        ,""	    ,""      ,""       ,""	      ,""		 ,""	   ,""	    ,""       ,""        ,"" 	    ,""      ,""	   ,""	        , ""	     ,""		  ,""	    ,""	  ,""	  ,""	    ,""	    ,""        ,"")
PutSx1("vit451"  ,"02"    ,"Tipo Serviço?"		   ,"Tipo Serviço?"	   ,"Tipo Serviço?"   ,"mv_ch2"  ,"C"    ,06        ,0         ,0        ,"G"   ,""		,"mv_par02",""      ,""        ,""		  ,""	   ,""      ,""      ,""        ,""        ,""	    ,""      ,""       ,""	      ,""		 ,""	   ,""	    ,""       ,""        ,"" 	    ,""      ,""	   ,""	        , ""	     ,""		  ,""	    ,""	  ,""	  ,""	    ,""	    ,""        ,"")

ValidPerg( aPrgs, "vit451", .T.)

RestArea( aArea )
Return Nil