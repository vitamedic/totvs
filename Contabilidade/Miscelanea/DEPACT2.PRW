/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DEPArat  ³ Autor ³ Edson G. Barbosa      ³ Data ³15/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alteracao das contas contabeis dos rateios externos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function depact2()
if msgyesno("Confirma alteração das contas do rateio externo?")
	processa({|| _altera()})
	msginfo("Alteração finalizada com sucesso!")
endif
return

static function _altera()

dbusearea(.t.,,"\depara\rateio","TMP1",.f.,.f.)

procregua(tmp1->(lastrec()))

_cfilsf1:=xfilial("SF1")
sf1->(dbsetorder(1))
_cfilsde:=xfilial("SDE")
sde->(dbsetorder(1))

tmp1->(dbgotop())
//_carquivo:=  retsqlname("SDE")
while ! tmp1->(eof())
	incproc("Alterando SDE deb->"+tmp1->dconta+" para "+tmp1->paconta)
   _conta:= strtran(tmp1->paconta,".")
	sde->(dbgotop())
	while ! sde->(eof())
		sf1->(dbseek(_cfilsf1+sde->de_doc+sde->de_serie+sde->de_fornece+sde->de_loja))
		if sf1->f1_doc==sde->de_doc .and.;
		  sf1->f1_serie==sde->de_serie .and.;
		  sf1->f1_fornece==sde->de_fornece.and.;
		  sf1->f1_loja==sde->de_loja .and.;
		   sf1->f1_dtdigit >=ctod("01/01/04")
			if alltrim(sde->de_conta) == alltrim(tmp1->dconta)
				SDE->(RECLOCK("SDE",.F.))
			   SDE->DE_CONTA := _Conta
			   SDE->(MSUNLOCK())
			 endif  
		endif   
	   sde->(dbskip())
	end
	tmp1->(dbskip())
end
tmp1->(dbclosearea())


return