/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VIT468 º Autor ³ Ricardo Moreira        º Data ³  22/09/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Acompanhamento de Produção					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic		                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit468()

_cfilsra:=xfilial("SC2")
_cfilsrd:=xfilial("SH6")
_cfilrcg:=xfilial("SG2")
SC2->(dbsetorder(1))
SH6->(dbsetorder(1))
SG2->(dbsetorder(1))

_dataini  := ctod("  /  /  ")
_datafim  := ctod("  /  /  ")

@ 000,000 to 130,200 dialog odlg1 title "Relatorio de Acompanhamento de Produção - Excel"
@ 005,005 say "Da Data"
@ 005,045 get _dataini size 040,10
@ 020,005 say "Ate a Data"
@ 020,045 get _datafim size 040,10

@ 040,020 bmpbutton type 1 action TExcel2()
@ 040,055 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered

return()

static function TExcel2()
//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

Private _aCabec := {}
Private _aDados := {}
Private _aSaldo := {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

If (_dataini = ctod("  /  /  ")) .or. (_datafim = ctod("  /  /  "))
	MsgAlert("Informar Datas de Inicio e Fim do Período") 
	Return
endif                                          

_aCabec :={"Ordem Produção","Lote","Emissão", "Encerramento","Lote Padrão","Produto","Descrição", "Roteiro","Operação","Desc Operação","Mão de Obra","Tempo Padrão","Recurso","Desc Recurso",;
            "Centro de Custo","Data Inicial","Hora Inicial","Data Final","Hora Final","Dias","Qtd Produto","Qtd Perda","Total/Parcial","Data Apontamento","Ident Op Pai","Tempo Real","Data Produção"}

processa({|| _querys()})
TMP1->(dbgotop())

While !TMP1->(Eof())         
   
		AAdd(_aDados, {TMP1->OP,;
				   TMP1->Lote,;    
				   stod(TMP1->Emissao),; 
				   stod(TMP1->Encerramento),;
				   TMP1->LotePadrao,;
				   TMP1->Produto,;
				   POSICIONE("SB1",1,xFilial("SB1")+TMP1->Produto,"B1_DESC"),;
				   TMP1->Roteiro,;                   
				   TMP1->Operacao,;
     			   TMP1->DescOper,;
     			   TMP1->MaoDeObra,;
     			   TMP1->TempoPadrao,;
     			   TMP1->Recurso,;
     		       POSICIONE("SH1",1,xFilial("SH1")+TMP1->Recurso,"H1_DESCRI"),;
     		       POSICIONE("SH1",1,xFilial("SH1")+TMP1->Recurso,"H1_CCUSTO"),;  			   
				   stod(TMP1->H6_DATAINI),;
				   stod(TMP1->H6_HORAINI),;
				   stod(TMP1->H6_DATAFIN),;
				   stod(TMP1->H6_HORAFIN),;
				   TMP1->Dias,; 
				   TMP1->H6_QTDPROD,; 
				   TMP1->H6_QTDPERD,;
				   IIF(TMP1->H6_PT=='T',"TOTAL","PARCIAL"),;				   
   				   stod(TMP1->H6_DTAPONT),;
   				   TMP1->H6_IDENT,;
   				   TMP1->H6_TEMPO,;
				   stod(TMP1->H6_DTPROD)})			   

	TMP1->(dbSkip())
End
				  
DlgToExcel({ {"ARRAY", "Relatorio de Acompanhamento de Produção - Excel", _aCabec, _aDados} })
TMP1->(dbclosearea())
return


static function _querys()       
_cQry := " "
_cQry += "SELECT DISTINCT H6_OP Op,H6_LOTECTL Lote, C2_DATPRI Emissao,C2_DATPRF Encerramento, C2_QUANT LotePadrao, C2_ROTEIRO Roteiro, H6_PRODUTO Produto, H6_OPERAC Operacao, "      
_cQry += " G2_DESCRI DescOper ,G2_MAOOBRA MaoDeObra, G2_TEMPAD TempoPadrao, G2_RECURSO Recurso, H6_QTDPROD, H6_QTDPERD,H6_DATAINI, H6_HORAINI, H6_DATAFIN, H6_HORAFIN, H6_PT, H6_DTAPONT, "      
_cQry += " round((to_date(H6_DATAINI,'yyyy-mm-dd')) - round(to_date(H6_DATAFIN,'yyyy-mm-dd')),0) Dias ,H6_IDENT , H6_TEMPO, H6_DTPROD "      
_cQry += "FROM " + retsqlname("SH6")+" SH6 "
_cQry += "INNER JOIN " + retsqlname("SC2")+" SC2 ON H6_FILIAL = C2_FILIAL AND H6_PRODUTO = C2_PRODUTO AND H6_LOTECTL = C2_LOTECTL "  
_cQry += "INNER JOIN " + retsqlname("SG2")+" SG2 ON H6_FILIAL = G2_FILIAL AND H6_PRODUTO = G2_PRODUTO AND H6_OPERAC = G2_OPERAC AND H6_RECURSO = G2_RECURSO "  
_cQry += "WHERE SC2.D_E_L_E_T_ <> '*' "
_cQry += "AND SH6.D_E_L_E_T_ <> '*' " 
_cQry += "AND SG2.D_E_L_E_T_ <> '*' " 
_cQry += "AND C2_DATPRI BETWEEN '"+dtos(_dataini)+"' AND '"+dtos(_datafim)+"' "
_cQry += "ORDER BY  H6_LOTECTL, H6_PRODUTO, H6_OPERAC "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP1"
 
return    
