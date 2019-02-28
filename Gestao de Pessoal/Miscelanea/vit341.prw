/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VIT341  ³ Autor ³ Alex Júnio de Miranda  ³ Data ³  18/02/09 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Rotina para Importação do Arquivo de Lançamento do         ³±±
±±³          ³ Vale-Card para Folha de Pagamento.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#INCLUDE "rwmake.ch"
#include "topconn.ch"

User Function vit341
Private _odlg1
Private _cstring := ""

@ 200,1 TO 380,380 DIALOG _odlg1 TITLE OemToAnsi("Leitura de Arquivo - Vale Card")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo do arquivo Vale-Card"
@ 18,018 Say " conforme os parametros definidos pelo usuario, com os"
@ 26,018 Say " registros do arquivo"

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(_odlg1)

Activate Dialog _odlg1 Centered

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Função Executada pelo botão OK
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function OkLeTxt

_carq := "c:\valecard.txt"
_ceol   :=chr(13)+chr(10)
_nhdl  := fopen(_carq,68)

if _nhdl == -1
    MsgAlert("O arquivo "+carq+" nao pode ser aberto! Verifique os parametros.","Atencao!")
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
_ntamlin  := 69+Len(_ceol)
_cbuffer  := space(_ntamlin) // Variavel para criacao da linha do registro para leitura

_nbtlidos := fread(_nhdl,@_cbuffer,_ntamlin) // Leitura da primeira linha do arquivo texto

_cfilsra:=xfilial("SRA")     
_cfilsrc:=xfilial("SRC")
sra->(dbsetorder(1))
sra->(dbgotop())

ProcRegua(_nTamFile) // Numero de registros a processar

While _nbtlidos >= _ntamlin

    IncProc()
    _mat 	:= substr(_cbuffer,39,6)
    _valor  := noround(val(substr(_cbuffer,63,4)),02)
    _valor  := _valor + (noround(val(substr(_cbuffer,68,2)),02)/100)
		
	sra->(dbgotop())
	
	if sra->(dbseek(_cfilsra+_mat))
	
		if sra->ra_sitfolh<>"D"

			dbSelectArea("SRC")
			src->(dbsetorder(3))
			src->(dbgotop())    	
			
			if src->(dbseek(_cfilsrc+'326'+_mat+" "))			
				MsgAlert("Lançamento já realizado!"+_mat+" - "+substr(_cbuffer,02,37))							
			else  			
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
					replace rc_mat      with _mat
					replace rc_pd      	with '326'
					replace rc_tipo1	with 'V'
					replace rc_horas    with 0
					replace rc_valor    with _valor
					replace rc_data     with ctod("  /  /  ")
					replace rc_semana   with ' '
					replace rc_cc      	with sra->ra_cc
					replace rc_parcela  with 0
					replace rc_tipo2    with 'I'
					replace rc_seq      with ' '
					replace rc_qtdsem   with 0
					replace rc_valorba  with 0	
				MSUnlock()        	
			endif
		else
			MsgAlert("Colaborador Demitido!"+_mat+" - "+substr(_cbuffer,02,37))				
	    endif
	else 
		MsgAlert("Matrícula Inválida!"+_mat+" - "+substr(_cbuffer,02,37))
	endif
    //³ Leitura da proxima linha do arquivo texto.                          ³
   	_nbtlidos := fread(_nhdl,@_cbuffer,_ntamlin) // Leitura da proxima linha do arquivo texto
end

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fclose(_nhdl)
close(_odlg1)

sysrefresh()
Return
