/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � DEPASG1  � Autor � Edson G. Barbosa      � Data �19/03/2004潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Alteracao da quantidade basica conforme o LE do PAI        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function depasg1()
if msgyesno("Confirma altera玢o da estrutura de produtos,"+chr(13)+;
            "considerando como quantidade basica lote economico?")
	processa({|| _altera()})
	msginfo("Altera玢o finalizada com sucesso!")
endif
return

static function _altera()
Local _nQBNew := _nQBOld := 0

DbSelectarea("SG1")
dbsetorder(1)

DbSelectarea("SB1")
dbsetorder(1)

procregua(sg1->(lastrec()))

sg1->(dbgotop())
_cfilsg1:=xFilial("SG1")
_cfilsb1:=xFilial("SB1")

While !eof()
	_cCond:= "SG1->G1_COD == '"+SG1->G1_COD+"' .AND. SG1->G1_FILIAL == '"+SG1->G1_FILIAL+"'"
  	If sb1->(dbseek(_cfilsb1+sg1->g1_cod)) .and. substr(SB1->b1_cod,1,6)="000054"   //000147-problema na estrutura original 
      _nQbOld := sb1->b1_qb
      sb1->(reclock("SB1",.f.))
          sb1->b1_qb := b1_le
      MsUnlock()    
      _nQbNew := sb1->b1_qb
	   While ! sg1->(eof()) .and. &_cCond 
			IncProc("Ajustando estrutura "+sg1->g1_cod+" comp. "+sg1->g1_comp)
	   	If sb1->(dbseek(_cfilsb1+sg1->g1_comp)) .and. sg1->g1_fixvar=="V" ;
	   		.and. substr(sg1->g1_comp,1,3)<> "MOD"
   			sg1->(reclock("SG1"),.f.)
	   			sg1->g1_quant := _nQbNew * (sg1->g1_quant/_nQbOld)
				MsUnlock()
	   	Endif
	   	sg1->(dbskip())
	   End
	Else
   	sg1->(dbskip())
	EndIf
End
return