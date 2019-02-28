#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � UXmlTag 		� Autor � Danilo Brito	 � Data � 05/08/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para montar uma tag XML de acrodo com nome.		  ���
���          � Abre a Tag, insere conte�do e fecha tag.        			  ���
�������������������������������������������������������������������������͹��
���Uso       � Maraj�                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Exemplo
//U_UXmlTag("TESTE","conteudo da tag aqui")
//retorno: <TESTE>conteudo da tag aqui</TESTE>
User Function UXmlTag(cNmTag, cContent, lEOL, cComplem)

	Local cRet := ""
	Default lEOL := .F.
	Default cComplem := ""
    
    cRet += "<"+cNmTag+cComplem+">"
    if lEOL
    	cRet += chr(13)+chr(10)
    endif    
    cRet += cContent     
	cRet += "</"+cNmTag+">"
	cRet += chr(13)+chr(10)
	
Return cRet
