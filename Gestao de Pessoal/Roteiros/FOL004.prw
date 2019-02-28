#INCLUDE "rwmake.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FOL004    ³ Autor ³ FERNANDA MACHADO   ³ Data ³  17/09/07   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Codigo gerado pelo AP6 IDE.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6 IDE                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function FOL004


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  

_cMes := subStr(dToS(dDataBase),5,2)
_cAno := subStr(dToS(dDataBase),1,4)

DbSelectArea("RCF")
DbSetOrder(1)//-FILIAL+ANO+MES
DbSeek(xFilial("RCF")+ _cAno + _cMes+SRA->RA_TNOTRAB+"  ")

_nDias  := RCF->RCF_DIATRA
_nDiasU := RCF->RCF_DUTILT

If SRA->RA_CATFUNC <> "E"
	If SRA->RA_REFEICA == "S" 
		If SRA->RA_TNOTRAB $ "003/004/009/012/013/014/017/018/019/020/024/028/033/034/035/037/038/039/040/048/058/063/064/065/066/067"

			M_REFEICAO := M_REFEICAO * _nDias
			fGeraVerba("552",M_REFEICAO,_nDias,,,,,,,,.t.)
		Else
			M_REFEICAO := M_REFEICAO * _nDiasU
			fGeraVerba("552",M_REFEICAO,_nDiasU,,,,,,,,.t.)
		Endif
	Endif
  
	If SRA->RA_CAFE == "S" 
			If !(SRA->RA_TNOTRAB $ "003/004/009/012/013/014/017/018/019/020/024/028/033/034/035/037/038/039/040/048/058/063/064/065/066/067")
				M_CAFE := M_CAFE * _nDiasU
				fGeraVerba("572",M_CAFE,_nDiasU,,,,,,,,.t.)
			Else   
				M_CAFE := M_CAFE * _nDias
				fGeraVerba("572",M_CAFE,_nDias,,,,,,,,.t.)
			Endif 
	Endif
   
Endif

Return              
