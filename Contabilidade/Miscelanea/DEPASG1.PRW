/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DEPASG1  ³ Autor ³ Edson G. Barbosa      ³ Data ³19/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alteracao da quantidade basica conforme o LE do PAI        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function depasg1()
if msgyesno("Confirma alteração da estrutura de produtos,"+chr(13)+;
            "considerando como quantidade basica lote economico?")
	processa({|| _altera()})
	msginfo("Alteração finalizada com sucesso!")
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