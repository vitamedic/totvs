#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ATUSD1         ³ Autor ³                  ³ Data ³         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Atualiza o campo D1_BASIMP5,D1_BASIMP6,D1_VALIMP5,D1_VALIMP6³±±
±±³          ³ D1_ALIQIMP5,D1_ALIQIMP6 e D1_CUSTO                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

USER FUNCTION _ATUSD1()

dbSelectArea("SF4")  //tipos de entrada e saida
dbSetorder(1)

dbSelectArea("SM2")  //Moedas
dbSetorder(1)

dbSelectArea("SD1")  //Itens nf entrada
cFiltro := "D1_FILIAL=='"+xFilial("SD1")+"'.AND.DTOS(D1_DTDIGIT)>='20070101'.AND.DTOS(D1_DTDIGIT)<='20070831' "
cChave:="D1_FILIAL+DTOS(D1_DTDIGIT)"
cArqIndxD1:=CriaTrab(NIL,.F.)

IndRegua("SD1",cArqIndxD1,cChave,,cFiltro,"Filtrando registros...")

nIndice	:=	Retindex("SD1")
#IFNDEF TOP
	dbSetIndex(cArqIndxD1+OrdBagExt())
#ENDIF

sD1->(DbSetOrder(nIndice+1))
sD1->(DbGoTop())

While !sd1->(eof())
	_nValpis:=0
	_nValcof:=0
	_nCusto:=0
	_ncusto2:=0
	_ncusto3:=0
	_ncusto5:=0
	//If sd1->d1_alqimp5==0 .and. sd1->d1_alqimp6==0 .and. sd1->d1_valimp5==0 .and. sd1->d1_valimp6==0
	sf4->(dbseek(xfilial("SF4")+sd1->d1_tes))
	Do case
		case sf4->f4_piscof =='1' .and. sf4->f4_piscred == '1'
			_nValpis:=sd1->d1_total * 0.0165
			_nCusto:= sd1->d1_custo - _nValpis
			
			If sm2->(dbseek(xfilial("SM2")+dtos(sd1->d1_emissao)))
				_ncusto2:= _nCusto/sm2->m2_moeda2
				_ncusto3:= _nCusto/sm2->m2_moeda3
				_ncusto5:= _nCusto/sm2->m2_moeda5
			Endif
			
			Begin Transaction
			dbSelectArea("SD1")
			RecLock("SD1",.F.)
			D1_ALQIMP6 := 1.65
			D1_VALIMP6  := _nValpis
			D1_BASIMP6  := D1_TOTAL
			D1_CUSTO    := _nCusto
			D1_CUSTO2   := _nCusto2
			D1_CUSTO3   := _nCusto3
			D1_CUSTO5   := _nCusto5
			MsUnlock("SD1")
			End Transaction
		case sf4->f4_piscof =='2' .and. sf4->f4_piscred == '1'
			_nValcof:=sd1->d1_total * 0.076
			_nCusto:= sd1->d1_custo - _nValcof
			
			If sm2->(dbseek(xfilial("SM2")+dtos(sd1->d1_emissao)))
				_ncusto2:= _nCusto/sm2->m2_moeda2
				_ncusto3:= _nCusto/sm2->m2_moeda3
				_ncusto5:= _nCusto/sm2->m2_moeda5
			Endif
			
			Begin Transaction
			dbSelectArea("SD1")
			RecLock("SD1",.F.)
			D1_ALQIMP5 := 7.6
			D1_VALIMP5  := _nValcof
			D1_BASIMP5  := D1_TOTAL
			D1_CUSTO    := _nCusto
			D1_CUSTO2   := _nCusto2
			D1_CUSTO3   := _nCusto3
			D1_CUSTO5   := _nCusto5
			MsUnlock("SD1")
			End Transaction
		case sf4->f4_piscof =='3' .and. sf4->f4_piscred == '1'
			_nValpis:=sd1->d1_total * 0.0165
			_nValcof:=sd1->d1_total * 0.076
			_nCusto:= sd1->d1_custo - _nValpis - _nValcof
			
			If sm2->(dbseek(xfilial("SM2")+dtos(sd1->d1_emissao)))
				_ncusto2:= _nCusto/sm2->m2_moeda2
				_ncusto3:= _nCusto/sm2->m2_moeda3
				_ncusto5:= _nCusto/sm2->m2_moeda5
			Endif
			
			Begin Transaction
			dbSelectArea("SD1")
			RecLock("SD1",.F.)
			D1_ALQIMP5 := 7.6
			D1_VALIMP5  := _nValcof
			D1_BASIMP5  := D1_TOTAL
			D1_ALQIMP6 := 1.65
			D1_VALIMP6  := _nValpis
			D1_BASIMP6  := D1_TOTAL
			D1_CUSTO    := _nCusto
			D1_CUSTO2   := _nCusto2
			D1_CUSTO3   := _nCusto3
			D1_CUSTO5   := _nCusto5
			MsUnlock("SD1")
			End Transaction
	Endcase
	//Endif
	
	sd1->(dbskip())
	
End
  Alert("Atualização terminada!")
return
