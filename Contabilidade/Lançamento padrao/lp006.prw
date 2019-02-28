/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LP006    ³ Autor ³ Heraildo C. de Freitas³ Data ³ 15/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna o Valor do Lancamento Padronizado de NF Saida      ³±±
±±³          ³ para Contabilizacao de GNR                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function lp006()
_nvalor:=0
if sf2->f2_valfat>0 .and.;
	! sf2->f2_tipo$"DB"
	
	_aareasd2:=sd2->(getarea())
	_aarease1:=se1->(getarea())
	_aareasf4:=sf4->(getarea())
	
	_cfilsd2:=xfilial("SD2")
	_cfilse1:=xfilial("SE1")
	_cfilsf4:=xfilial("SF4")
	
	se1->(dbsetorder(1))            
	if se1->(dbseek(_cfilse1+sf2->f2_serie+sf2->f2_doc+"R"+"NF "+sf2->f2_cliente+sf2->f2_loja))
		
		sd2->(dbsetorder(3))
		sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
		sf4->(dbsetorder(1))
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		
      if sf4->f4_credst=="1" .and.;
      	sf2->f2_icmsret>0
      	
         _nvalor:=0
		else
		   _nvalor:=se1->e1_valor
		endif 
	endif
	
	sd2->(restarea(_aareasd2))
	se1->(restarea(_aarease1))
	sf4->(restarea(_aareasf4))
endif
return(_nvalor)
