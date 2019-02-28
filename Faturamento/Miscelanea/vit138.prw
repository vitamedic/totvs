/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT138   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 16/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Receber Arquivos do FTP da SEFAZ-GO (Passe Fiscal)         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteracao ³ FTPSETTYPE,FTPPASV ³Autor ³ Edson G.Barbosa³ Data ³19/04/04³±±
±±³          ³ Tratamento e Exlusao do Arquivo no FTP.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/



#include "rwmake.ch"

user function vit138()
//lFireWall := .F.
_afiles:={}
//_cperg:="VIT138"
//_pergsx1()
if	msgyesno("Confirma a recepcao dos arquivos?") //.and. pergunte(_cperg,.t.)
	_cdir:="\passe\retorno\"  //alltrim(mv_par01)
	if right(_cdir,1)<>"\"
		_cdir+="\"
	endif
	cserverftp:="recebepasse.sefaz.go.gov.br"
	nport     := nil
	cuser     :="43362"
	cpassword :="43VI@%ta"
   cAtrib    :=""                 
   cMasc     :="*.*"

	if !ftpconnect(cserverftp,nport,cuser,cpassword)
		msgstop("Falha de conexao com o servidor "+cserverftp)
	else
      FTPSetType(0)    //para definir o tipo de transferência...
                       //0 – ASCII, 1 – BINARY, 2-DEFAULT
      FTPSETPASV(.f.)  // .t. para ligar o modo passivo e .f. para desligar
		_afiles:=ftpdirectory(cMasc)
		if len(_afiles)==0
			msgstop("Nao existe nenhum arquivo no servidor!")
		else
			for _i:=1 to len(_afiles)
				_carq:=_cdir+_afiles[_i,1]
				_lret:=.t.
				msgrun("Aguarde, recebendo arquivo "+_afiles[_i,1],,{|| _lret:=ftpdownload(_carq,_afiles[_i,1])})
				if ! _lret
					msgstop("Falha na recepcao do arquivo "+_afiles[_i,1])
				Else
				   frename(_carq,"\passe\retorno\"+substr(_afiles[_i,1],1,at(".",_afiles[_i,1])-1)+".##r")
				   If MsgYesNo("Apaga o arquivo "+_afiles[_i,1]+" ?")
   				   _lret:=.t.
	   			   msgrun("Aguarde, eliminando arquivo "+_afiles[_i,1],,{|| _lret:=ftperase(_afiles[_i,1])})
		   		   if _lret
			   	   	msgstop("Arquivo "+_afiles[_i,1]+" eliminado com sucesso!")
                  Endif
					Endif
				endif
			next
			msginfo("Fim da recepcao dos arquivos!")
		endif
		ftpdisconnect()
	endif
endif
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Diretorio          ?","mv_ch1","C",40,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return
