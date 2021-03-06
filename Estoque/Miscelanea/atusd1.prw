#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � ATUSD1         � Autor �                  � Data �         潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao 矨tualiza o campo D1_BASIMP5,D1_BASIMP6,D1_VALIMP5,D1_VALIMP6潮�
北�          � D1_ALIQIMP5,D1_ALIQIMP6 e D1_CUSTO                         潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
  Alert("Atualiza玢o terminada!")
return
