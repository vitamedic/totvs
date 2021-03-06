#INCLUDE "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT331    � Autor � Thiago Barbosa    � Data �  09/07/08   潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � MBrowser para Gerar Arquivo XML para Teste.                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � MP8 IDE                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function VIT331


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Declaracao de Variaveis                                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

DbSelectArea("SF2")
DbSetOrder(1)

aRotina	:= { {"Pesquisar","AxPesqui" , 0, 1},;
			 {"Gerar XML","U_VIT331Ger", 0, 2} }

mBrowse(06,03,22,75,"SF2",,,,,,)

Return


/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  � VIT331Ger � Autor � Thiago Barbosa    � Data �  09/07/08   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao � Auxiliar na Geracao do Arquivo XML.                        罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � MP8 IDE                                                    罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/

User Function VIT331Ger(cAlias,nReg,nOpc)


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Declaracao de Variaveis                                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
Local nOpcao
Local cTipo
Local cSerie
Local cNota
Local cCliFor
Local cLoja

Local aRetNF

cTipo 	:= "1"

If cTipo == "1"
	cSerie  := SF2->F2_SERIE
	cNota	:= SF2->F2_DOC
	cClieFor:= SF2->F2_CLIENTE
	cLoja	:= SF2->F2_LOJA
	aMotivoCont :=" "
	cVerAmb      := "2.00"
	cAmbiente	  := " "
	cNotaOri  := " "
	cSerieOri := " "
Else
	cSerie  := SF1->F1_SERIE
	cNota	:= SF1->F1_DOC
	cClieFor:= SF1->F1_FORNECE
	cLoja	:= SF1->F1_LOJA
	aMotivoCont 	  :=" "
	cVerAmb     	  := "2.00"
	cAmbiente		  := " "
	cNotaOri  := " "
	cSerieOri := " "

EndIf

aRetNF := U_XmlNfeSef(cTipo,cSerie,cNota,cClieFor,cLoja,cNotaOri,cSerieOri)

nOpcao := Aviso("XML NF-e",aRetNf[2], {"Ok"})

MemoWrite("c:\temp\Chave.txt", aRetNF[1])
Memowrite("c:\temp\NFe.XML", aRetNF[2])

Return