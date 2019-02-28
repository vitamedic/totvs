/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±
±±³Programa  ³ F460VAL ³Autor ³Heraildo Costa de Freitas  ³ Data ³18/01/07³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Gravação dos Campos Referentes aos Codigos de Vendedores   ³±±
±±³          ³ nos Cheques da Liquidacao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"

user function f460val()
_aarea   :=getarea()
_aarease1:=se1->(getarea())
_aarease5:=se5->(getarea())

_cfilse1:=xfilial("SE1")
_cfilse5:=xfilial("SE5")

_cnumliq:=se1->e1_numliq
_avend  :={}

chkfile("SE1",.f.,"SE1_LIQ")

se5->(dbsetorder(10))
se5->(dbseek(_cfilse5+_cnumliq))
while ! se5->(eof()) .and.;
	se5->e5_filial==_cfilse5 .and.;
	substr(se5->e5_documen,1,6)==_cnumliq
	
	if se5->e5_tipodoc=="BA" .and.;
		se5->e5_motbx=="LIQ"
		
		se1_liq->(dbsetorder(1))
		se1_liq->(dbseek(_cfilse1+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo))
		
		for _ni:=1 to 5
			_cvend  :=se1_liq->(fieldget(fieldpos("E1_VEND"+strzero(_ni,1))))
			_nbascom:=se1_liq->(fieldget(fieldpos("E1_BASCOM"+strzero(_ni,1))))
			_nvalcom:=se1_liq->(fieldget(fieldpos("E1_VALCOM"+strzero(_ni,1))))
			_ncomis :=se1_liq->(fieldget(fieldpos("E1_COMIS"+strzero(_ni,1))))
			_nvalor :=se1_liq->e1_valor
			_nvcom  :=round(_nbascom*(_ncomis/100),2)
			
			if ! empty(_cvend)
				_nj:=ascan(_avend,{|x| x[1]==_cvend})
				if _nj==0
					aadd(_avend,{_cvend,_nbascom,_nvalcom,_nvalor,_nvcom})
				else
					_avend[_nj,2]+=_nbascom
					_avend[_nj,3]+=_nvalcom
					_avend[_nj,4]+=_nvalor
					_avend[_nj,5]+=_nvcom
				endif
			endif
		next
	endif
	se5->(dbskip())
end

reclock("SE1",.f.)
for _ni:=1 to len(_avend)
	_cvend  :=_avend[_ni,1]
	_nbascom:=_avend[_ni,2]
	_nvalcom:=_avend[_ni,3]
	_nvalor :=_avend[_ni,4]
	_nvcom  :=_avend[_ni,5]
	_nbascom:=round((se1->e1_valor/_nvalor)*_nbascom,2)
	_nvalcom:=round((se1->e1_valor/_nvalor)*_nvalcom,2)
	_nvcom  :=round((se1->e1_valor/_nvalor)*_nvcom,2)
	_ncomis :=round((_nvcom/_nbascom)*100,2)
	
	se1->(fieldput(fieldpos("E1_VEND"+strzero(_ni,1)),_cvend))
	se1->(fieldput(fieldpos("E1_BASCOM"+strzero(_ni,1)),_nbascom))
	se1->(fieldput(fieldpos("E1_VALCOM"+strzero(_ni,1)),_nvalcom))
	se1->(fieldput(fieldpos("E1_COMIS"+strzero(_ni,1)),_ncomis))
next
se1->e1_porcjur:=getmv("MV_TXPER")
msunlock()

se1_liq->(dbclosearea())

se1->(restarea(_aarease1))
se5->(restarea(_aarease5))
restarea(_aarea)
return()
