/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DEPAATF  ³ Autor ³ Edson G. Barbosa      ³ Data ³05/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alteracao das contas contabeis dos Lancamentos Contabeis   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function depaatf()
if msgyesno("Confirma alteração das contas do Ativo Fixo")
	processa({|| _altera()})
	processa({|| _altera1()})
	msginfo("Alteração finalizada com sucesso!")
endif

return

static function _altera()
dbusearea(.t.,,"\depara\depatf","TMP1",.f.,.f.)

procregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof())
	incproc("Alterando "+tmp1->deconta)

	_ccomando:=" UPDATE"
	_ccomando+=" SN3010"
	_ccomando+=" SET"
	_ccomando+=" N3_CCDEPR='"+tmp1->PACONTA+"'"
	_ccomando+=" WHERE"
	_ccomando+=" N3_CCONTAB='"+tmp1->DECONTA+"'"
	tcsqlexec(_ccomando)
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
Return

static function _altera1()
dbusearea(.t.,,"\depara\custo","TMP1",.f.,.f.)

procregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof())
	incproc("Alterando "+tmp1->decusto)

	_ccomando:=" UPDATE"
	_ccomando+=" SN3010"
	_ccomando+=" SET"
	_ccomando+=" N3_CCUSTO='"+tmp1->PAcusto+"',"
	_ccomando+=" N3_CUSTBEM='"+tmp1->PAcusto+"'"
	_ccomando+=" WHERE"
	_ccomando+=" N3_CCUSTO='"+tmp1->DEcusto+"'"
	tcsqlexec(_ccomando)

	_ccomando:=" UPDATE"
	_ccomando+=" SN4010"
	_ccomando+=" SET"
	_ccomando+=" N4_CCUSTO='"+tmp1->PAcusto+"'"
	_ccomando+=" WHERE"
	_ccomando+=" N4_CCUSTO='"+tmp1->DEcusto+"'"
	tcsqlexec(_ccomando)
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
Return
/*
dbSelectArea("SN4")
dbSetOrder(1)

dbSelectArea("SN3")
dbSetOrder(1)

procregua(SN4->(LASTREC()))

While !SN4->(Eof())
	_cConta := "3102030312339"
	IncProc("Ajustando o bem: "+SN4->N4_CBASE+SN4->N4_ITEM+SN4->N4_TIPO)
	If SN3->(dbSeek(xFilial()+sn4->N4_CBASE+sn4->N4_ITEM+sn4->N4_TIPO));
	   .and. alltrim(SN4->N4_CONTA) == "3102030312339"
      Do Case 
         Case substr(sn3->N3_CCUSTO,1,2)$'29/55/51/52/50'
				_cConta := "3501020218208"
         Case substr(sn3->N3_CCUSTO,1,2)$'60/30/20/21/22/24/33/31'
				_cConta := "4101020213208"
         Case substr(sn3->N3_CCUSTO,1,2)$'23/40/42'
				_cConta := "4101020216208"
		End Case
		SN4->(RECLOCK("SN4",.F.))
		   SN4->N4_CONTA := _cConta
	   SN4->(MSUNLOCK())
   Endif
	sn4->(dbskip())
End
*/
return