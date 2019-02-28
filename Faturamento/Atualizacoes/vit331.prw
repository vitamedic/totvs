#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT331    � Autor � Thiago Barbosa    � Data �  09/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � MBrowser para Gerar Arquivo XML para Teste.                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MP8 IDE                                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

User Function VIT331


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

DbSelectArea("SF2")
DbSetOrder(1)

aRotina	:= { {"Pesquisar","AxPesqui" , 0, 1},;
			 {"Gerar XML","U_VIT331Ger", 0, 2} }

mBrowse(06,03,22,75,"SF2",,,,,,)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VIT331Ger � Autor � Thiago Barbosa    � Data �  09/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Auxiliar na Geracao do Arquivo XML.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function VIT331Ger(cAlias,nReg,nOpc)


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
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