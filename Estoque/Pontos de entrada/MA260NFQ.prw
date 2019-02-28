#INCLUDE "PROTHEUS.CH"
/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��        
���Fun��o    � MA260NFQ � Autor � Henrique Correa      � Data � 20/04/2017 ���
��������������������������������������������������������������������������Ĵ��
���Localiza��o � Programa de Transferencias Mod II                         ���
��������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                    ���
��������������������������������������������������������������������������Ĵ��
�� P.E. para que nao seja exibida                                           ��
�� a tela para selecao de materiais a serem transferidos para o CQ, quan-   ��
�� do houver integracao com o Quality.									    ��
��������������������������������������������������������������������������Ĵ��
�� Famoso pulo-do-gato                                                      ��
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function MA260NFQ()
Local aArea      := GetArea()
Local lRet       := .f.
Local cCodProd   := If((nPos := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_COD'    }))>0,aCols[n, nPos],'')
Local cLocOrig   := If((nPos := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_LOCAL'  }))>0,aCols[n, nPos],'')
Local cLoteCTL   := If((nPos := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_LOTECTL'}))>0,aCols[n, nPos],'')
Local cNumLote   := If((nPos := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_NUMLOTE'}))>0,aCols[n, nPos],'')

if Empty(cCodProd) .or. Empty(cLoteCTL)
	Return(.f.)
endif

dbSelectArea("SD1")
dbSetOrder(14)

if !( lRet := dbSeek(XFilial("SD1")+cCodProd+cLoteCTL) )

	RestArea(aArea)

endif

Return(lRet)