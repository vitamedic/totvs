/*
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  Ё LICGEN  Ё Autor Ё                       Ё Data Ё           Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao Ё                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё                                                            Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ЁVersao    Ё 1.0                                                        Ё╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
*/

#include "rwmake.ch"


USER Function SalvaAmbiente(mArea)
Local x := 0
Local mAlias := {}
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Salvando ambiente antes de executar a funcao do usuario que altera ponteiro de tabelas
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

AaDd(mAlias,{Alias(),IndexOrd(),Recno()})

For x := 1 to Len(mArea)
	DbSelectArea(mArea[x])
	AaDd(mAlias,{Alias(),IndexOrd(),Recno()})
next x


Return (mAlias)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaurando o ambiente apos a execucao da funcao de usuario que altera ponteiros de tabelas
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

USER Function VoltaAmbiente(mAlias)

Local x := 0

For x:= 1 to Len(mAlias)
	
	DbSelectArea(mAlias[x,1])
	DbSetOrder(mAlias[x,2])
	DbGoto(mAlias[x,3])
	
Next x

DbSelectArea(mAlias[1,1])
DbSetOrder(mAlias[1,2])
DbGoto(mAlias[1,3])



Return NIL

