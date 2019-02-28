#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VitQ001   � Autor � AP6 IDE            � Data �  12/02/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastrdo de amarra��o de documento x produto              ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Vitq001()
//� Declaracao de Variaveis                                             �
Local cVldAlt := "U_VitqAlt(QZ1_PROD,QZ1_DOCTO)" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "QZ1"

dbSelectArea("QZ1")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Amarra��o Documento x Produto",cVldExc,cVldAlt)

Return

User function VitqAlt(cProd,cDoc)
//msgalert(cProd+cDoc)
iRet := .t.
IF INCLUI
	Dbselectarea("QZ1")
   	dbseek(xFilial("QZ1")+cProd+cDoc)
	IF QZ1->QZ1_PROD == cProd .and. QZ1->QZ1_DOCTO == cDoc
		iRet := .f.
		msginfo("Ja existe um registro com esse Produto/Documento !!","VITQ001 - Aten�ao ")
  	endif
  	DBCLOSEAREA()
Else
		iRet := .f.
		msgstop("Nao e Permitido Altera��o !"+chr(13)+"Apenas exclusao e inclusao !!","VITQ001 - Aten�ao ")

Endif
Return iRet
