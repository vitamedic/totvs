#include 'totvs.ch'
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "Ap5Mail.ch"
#include "tbicode.ch"
#include "dialog.ch"
#INCLUDE "protheus.ch"

/*/{Protheus.doc} vit394

@author André Almeida Alves

@since 13/02/2014

@version P11

@param Nome, Caracter, Nome do Candidato

@return Caracter, Resultado da Pesquisa

@description Função para verificar se existe vinculo de parentesco com possivel candidato, as pesquisa deve conter o nome exato do nome ou sobrenome do candidato.

@example Digite o nome ou parte do nome e clique em OK.

/*/

User Function vit394() 
Static oDlg
Static oButton1
Static oButton2
Static oGet1
Static cGet1 := SPACE(150) //Espaço de 150 caraceteres
Static oSay1

  DEFINE MSDIALOG oDlg TITLE "Pesquisa de Parentesco" FROM 000, 000  TO 100, 300 COLORS 0, 16777215 PIXEL
    @ 034, 040 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlg action(pOk())PIXEL
    @ 034, 080 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg action(pSair())PIXEL
    @ 003, 004 SAY oSay1 PROMPT "Digite o Nome que deseja pesquisar se existe parentesco" SIZE 180, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 020, 004 MSGET oGet1 VAR cGet1 SIZE 145, 010 OF oDlg COLORS 0, 16777215 PIXEL
  ACTIVATE MSDIALOG oDlg

Return

static function pOk()
	_lOk	:= .f.
	
	IF(SELECT("TMP1") > 0)
		TMP1->(DBCLOSEAREA())
	ENDIF

	cquery:=" SELECT RA_NOME FROM "
	cquery+=  retsqlname("SRA")+" SRA"
	cquery+="  WHERE SRA.D_E_L_E_T_=' '"
	cquery+="  AND RA_SITFOLH<>'D'"
	cquery+="  AND (RA_PAI LIKE '%"+Alltrim(upper(cGet1))+"%'"
	cquery+="  OR RA_MAE LIKE '%"+Alltrim(upper(cGet1))+"%'"
	cquery+="  OR RA_NOME LIKE '%"+Alltrim(upper(cGet1))+"%')"
	
	cquery+="  UNION ALL 
 
	cquery+="  SELECT RA_NOME"
	cquery+="  FROM SRA010 SRA, SRB010 SRB"
	cquery+="  WHERE SRA.D_e_L_E_T_ = ' '"
	cquery+="  AND SRB.D_E_L_E_T_ = ' '"
	cquery+="  AND RA_MAT = RB_MAT"
	cquery+="  AND RB_NOME LIKE '%"+Alltrim(upper(cGet1))+"%'"	
	
	MemoWrite("/sql/vit394_tmp1.sql",cquery)
	tcquery cquery new alias "TMP1"
	
	while !tmp1->(eof())
		ApMsgInfo("Esta pessoa tem parentesco com: "+tmp1->ra_nome)
		_lOk	:= .t.
		tmp1->(dbskip())
	end	
	if !_lOk
		Alert("Não Existe parentesco para esta pessoa")
	endif
return()           

static function pSair()
	oDlg:END()
	return()
return()


