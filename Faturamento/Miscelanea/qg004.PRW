/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ QG004    ³ Autor ³ Edson G. Barbosa      ³ Data ³ 05/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alterar MOD na Tabela SD3                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Para as OPs que Foram Abertas Antes de 31/03/04.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function qg004()
If msgyesno("Confirma atualizacao do SD3 para as MOD,"+chr(10)+"periodo de 01/04/04 ate a data corrente ?")
	processa({|| _acerta()})
	msginfo("Acerto finalizado com sucesso!")
endif
return

static function _acerta()

_cfilsd3:=xfilial("SD3")
_cfilsg1:=xfilial("SG1")
_cfilsb1:=xfilial("SB1")
sd3->(dbsetorder(1))
sg1->(dbsetorder(1))
sb1->(dbsetorder(1))

_cindsd3:=criatrab(,.f.)
_cchave :='D3_OP+D3_NUMSEQ+D3_COD'
_cfiltro:='DTOS(D3_EMISSAO) >= "20040401" .AND. (SUBSTR(D3_COD,1,3) = "MOD" .OR. D3_CF$"PR0/ER0")'
//_cfiltro:='D3_OP = "00332401001" .and. (SUBSTR(D3_COD,1,3) = "MOD" .OR. D3_CF$"PR0/ER0")'
sd3->(indregua("SD3",_cindsd3,_cchave,,_cfiltro,"Selecionando registros..."))

procregua(sd3->(reccount()))

SD3->(DBGOTOP())
While !sd3->(eof())
	IncProc("Ordem Producao: "+sd3->d3_op)
	
	If SUBSTR(sd3->D3_COD,1,3) <> "MOD" .and. SB1->(dbseek(_cfilsb1+sd3->d3_cod))
		cProduto:=SD3->D3_COD
		nPerda  :=SD3->D3_PERDA
		nQProd  :=SD3->D3_QUANT
		nB1QB   :=sb1->b1_qb
		cCondSD3:= "SD3->(D3_OP+D3_NUMSEQ) == '"+SD3->(D3_OP+D3_NUMSEQ)+"'"
		sd3->(dbskip())
		While !sd3->(eof()) .AND. &cCondSD3
			incproc()
			If SUBSTR(sd3->D3_COD,1,3) == "MOD" .and. sg1->(dbseek(_cfilsg1+cproduto+sd3->d3_cod))
		      nQuant  := 0
				If nQProd == 0
					nQuant:=(nPerda/nB1QB) * SG1->G1_QUANT
				Else
					nQuant:=(nQProd/nB1QB) * SG1->G1_QUANT
				Endif
				If int(nQuant) <> int(SD3->D3_QUANT)
					sd3->(reclock("SD3",.f.))
					sd3->d3_quant:=nQuant
					sd3->d3_qtsegum:=SD3->D3_QUANT
					sd3->(msunlock())
				Endif
			Endif
			sd3->(dbskip())
		End
	Else
		sd3->(dbskip())
	Endif
End

sd3->(retindex("SD3"))
_cindsd3+=sd3->(ordbagext())
ferase(_cindsd3)
return

