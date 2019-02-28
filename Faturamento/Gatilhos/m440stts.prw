/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M440STTS  ³Autor ³ Ricardo Fiuza's        ³Data ³ 14/10/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para liberação do Pedido de Venda         ³±±
±±³          ³  														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#include "TBICONN.ch"
#include "Protheus.ch"

User Function M440STTS()
  
//msginfo("teste")

//If SD3->D3_CF == "PR0" .AND.  SD3->D3_QUANT > 0  
	_cde_pa      :=Alltrim(getmv("MV_WFMAIL"))
	_cconta_pa   :=Alltrim(getmv("MV_WFMAIL"))
	_csenha_pa   :=Alltrim(getmv("MV_WFPASSW"))

	_cpara_pa    := "m440stts@vitamedic.ind.br"      
	_ccc_pa      :=" "
	_ccco_pa     :=" " // com copia oculta
	_cassunto_pa :="Liberação de Pedido de Venda - Pedido: "+sc5->c5_num
    
	_cmensagem_pa:="Pedido: "+sc5->c5_num+"<P>"
	_cmensagem_pa+="Emissão: "+dtoc(sc5->c5_emissao)+"<P>"
    cDescCLi  := Posicione("SA1",1,xFilial("SA1")+sc5->c5_cliente+sc5->c5_lojacli,'A1_NOME')			
	_cmensagem_pa+="Cliente/Loja: "+alltrim(sc5->c5_cliente)+" / "+sc5->c5_lojacli+"<P>"
	_cmensagem_pa+="Nome: "+cDescCLi+"<P>" 
  	//_cmensagem_pa+="Data Liberacao: "+dtoc(sc9->c9_datalib)+"<P>"
   //	_cmensagem_pa+="Lote: "+sh6->h6_lotectl+"<P>"
	_cmensagem_pa+="Usuario: "+cusername+"<P>"
   	_cmensagem_pa+="Data: "+dtoc(date())+"<P>"
	_cmensagem_pa+="Hora: "+time()+"<P>"
					
	_canexos_pa  :="" // caminho completo dos arquivos a serem anexados, separados por ;
	_lavisa_pa   :=.f.
	u_envemail(_cde_pa,_cconta_pa,_csenha_pa,_cpara_pa,_ccc_pa,_ccco_pa,_cassunto_pa,_cmensagem_pa,_canexos_pa,_lavisa_pa)
//EndIf

			
return()   
