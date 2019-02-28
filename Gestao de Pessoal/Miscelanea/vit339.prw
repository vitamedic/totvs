/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VIT339 ³ Autor ³ Alex Júnio de Miranda  ³ Data ³  13/02/09  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Rotina para Importação do Arquivo Coparticipação Unimed    ³±±
±±³          ³ (txt) para Folha de Pagamento.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6 IDE                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#INCLUDE "rwmake.ch"
#include "topconn.ch"

User Function vit339
Private _oletxt
Private _cstring := ""

@ 200,1 TO 380,380 DIALOG _oletxt TITLE OemToAnsi("Leitura de Arquivo - Co-Pariticipacao Unimed")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo do arquivo Co-Participacao da"
@ 18,018 Say " Unimed, conforme os parametros definidos pelo usuario, com os"
@ 26,018 Say " registros do arquivo"

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(_oLeTxt)

Activate Dialog _oLeTxt Centered

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Função Executada pelo botão OK
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function OkLeTxt

_carq := "c:\Temp\counimed.txt"
_ceol   :=chr(13)+chr(10)
_nhdl  := fopen(_carq,68)

if _nhdl == -1
    MsgAlert("O arquivo "+_carq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

Processa({|| RunCont() },"Processando...")
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Processamento do arquivo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function RunCont

Local _ntamfile, _ntamlin, _cbuffer, _nbtlidos

_ntamfile := fseek(_nhdl,0,2)
fSeek(_nhdl,0,0)
_ntamlin  := 79+Len(_ceol)
_cbuffer  := space(_ntamlin) // Variavel para criacao da linha do registro para leitura

_nbtlidos := fread(_nhdl,@_cbuffer,_ntamlin) // Leitura da primeira linha do arquivo texto

_cfilsra:=xfilial("SRA")
sra->(dbsetorder(1))
sra->(dbgotop())

ProcRegua(_nTamFile) // Numero de registros a processar

While _nbtlidos >= _ntamlin

    IncProc()
    _codunimed 	:= substr(_cbuffer,6,6)
    _valor 		:= noround(val(substr(_cbuffer,66,79)),02)/100

	_cquery:=" SELECT"
	_cquery+=" RA_MAT MAT,"
	_cquery+=" RA_SITFOLH SITFOLH,"
	_cquery+=" RA_CC CC"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SRA")+" SRA"
	_cquery+=" WHERE"
	_cquery+="     SRA.D_E_L_E_T_<>'*'"
	_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
	_cquery+=" AND RA_UNIMED='"+_codunimed+"'"
	
	_cquery:=changequery(_cquery)
	tcquery _cquery new alias "TMP1"
		
	tmp1->(dbgotop())

	if !Empty(tmp1->mat) 
		if tmp1->sitfolh<>"D"
		
			dbSelectArea("SRC")

			// Cria Array com todos os campos do SRC
			aSRC := array(fCount())
			for i:=1 to FCount()
				aSRC[i] := fieldget(i)
			next
    	
			reclock("SRC",.t.)
    	
				for i:=1 to FCount()
					fieldput(i,aSRC[i])
				next
				replace rc_filial	with "01"
				replace rc_mat      with tmp1->mat
				replace rc_pd      	with '554'
				replace rc_tipo1	with 'V'
				replace rc_horas    with 0
				replace rc_valor    with _valor
				replace rc_data     with ctod("  /  /  ")
				replace rc_semana   with ' '
				replace rc_cc      	with tmp1->cc
				replace rc_parcela  with 0
				replace rc_tipo2    with 'I'
				replace rc_seq      with ' '
				replace rc_qtdsem   with 0
				replace rc_valorba  with 0	
			MSUnlock()        	
		else 
			MsgAlert("Colaborador Demitido!"+tmp1->mat+" - "+substr(_cbuffer,14,50))			
		endif
	else 
		MsgAlert("Código Unimed não localizado!"+_codunimed+" - "+substr(_cbuffer,14,50))
	endif
    //³ Leitura da proxima linha do arquivo texto.                          ³
   	_nbtlidos := fread(_nhdl,@_cbuffer,_ntamlin) // Leitura da proxima linha do arquivo texto

	tmp1->(dbclosearea())

end

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fclose(_nhdl)
close(_oletxt)

sysrefresh()
Return
