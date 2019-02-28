/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ QG006   ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acerta Series de Notas Fiscais do SF1 E SF3 de Acordo com  ³±±
±±³          ³ o SD1.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"

user function qg006()
if msgyesno("Confirma acerto das séries do SF1 e SF3?")
	processa({|| _atualiza()})
	msginfo("Acerto das séries finalizado com sucesso!")
endif
return()

static function _atualiza()
_cfilsd1:=xfilial("SD1")
_cfilsf1:=xfilial("SF1")
_cfilsf3:=xfilial("SF3")

procregua(sf1->(lastrec())+sf3->(lastrec()))

sf1->(dbsetorder(0))
sf1->(dbgotop())
while ! sf1->(eof())
	incproc("Atualizando SF1 "+alltrim(str(sf1->(recno()))))
	
	_aserie:={}
	_lachou:=.f.
	sd1->(dbsetorder(1))
	sd1->(dbseek(sf1->f1_filial+sf1->f1_doc))
	while ! sd1->(eof()) .and.;
		sd1->d1_filial==sf1->f1_filial .and.;
		sd1->d1_doc==sf1->f1_doc
		
		if sd1->d1_tipo==sf1->f1_tipo .and.;
			sd1->d1_fornece==sf1->f1_fornece .and.;
			sd1->d1_loja==sf1->f1_loja .and.;
			sd1->d1_emissao==sf1->f1_emissao .and.;
			sd1->d1_dtdigit==sf1->f1_dtdigit
			
			_ni:=ascan(_aserie,{|x| x[1]==sd1->d1_serie})
			if _ni==0
				aadd(_aserie,{sd1->d1_serie,sd1->d1_total})
			else
				_aserie[_ni,2]+=sd1->d1_total
			endif
			_lachou:=.t.
		endif
		sd1->(dbskip())
	end
	if _lachou
		for _ni:=1 to len(_aserie)
			if _aserie[_ni,1]<>sf1->f1_serie .and.;
				_aserie[_ni,2]==sf1->f1_valmerc
				
				sf1->(reclock("SF1",.f.))
				sf1->f1_serie:=_aserie[_ni,1]
				sf1->(msunlock())
			endif
		next
	endif
	sf1->(dbskip())
end

sf3->(dbsetorder(0))
sf3->(dbgotop())
while ! sf3->(eof())
	incproc("Atualizando SF3 "+alltrim(str(sf3->(recno()))))
	
	if sf3->f3_cfo<"5"
		_lachou:=.f.
		sf1->(dbsetorder(1))
		sf1->(dbseek(sf3->f3_filial+sf3->f3_nfiscal))
		while ! sf1->(eof()) .and.;
			sf1->f1_filial==sf3->f3_filial .and.;
			sf1->f1_doc==sf3->f3_nfiscal .and.;
			! _lachou
			
			if sf1->f1_especie==sf3->f3_especie .and.;
				sf1->f1_fornece==sf3->f3_cliefor .and.;
				sf1->f1_loja==sf3->f3_loja .and.;
				sf1->f1_emissao==sf3->f3_emissao .and.;
				sf1->f1_dtdigit==sf3->f3_entrada .and.;
				sf1->f1_valbrut==sf3->f3_valcont
				
				_lachou:=.t.
			else
				sf1->(dbskip())
			endif
		end
		if _lachou .and.;
			sf3->f3_serie<>sf1->f1_serie
			
			sf3->(reclock("SF3",.f.))
			sf3->f3_serie:=sf1->f1_serie
			sf3->(msunlock())
		endif
	endif
	sf3->(dbskip())
end
return()
