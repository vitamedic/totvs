/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT450FIM  矨utor � Ricardo Fiuza's        矰ata � 09/10/14 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada para libera玢o do Pedido de Venda         潮�
北�          �  														  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       �                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

User Function MT450FIM()
  
//msginfo("teste")

//If SD3->D3_CF == "PR0" .AND.  SD3->D3_QUANT > 0  
	_cde_pa      :=Alltrim(getmv("MV_WFMAIL"))
	_cconta_pa   :=Alltrim(getmv("MV_WFMAIL"))
	_csenha_pa   :=Alltrim(getmv("MV_WFPASSW"))

	_cpara_pa    := "MT450FIM@vitamedic.ind.br" //mt681inc@vitamedic.ind.br"   
	_ccc_pa      :=" " //"report@vitamedic.ind.br"  com copia
	_ccco_pa     :=" " // com copia oculta
	_cassunto_pa :="Libera玢o de Credito - Pedido: "+sc5->c5_num
    
	_cmensagem_pa:="Pedido: "+sc5->c5_num+"<P>"
	_cmensagem_pa+="Emiss鉶: "+dtoc(sc5->c5_emissao)+"<P>"
    cDescCLi  := Posicione("SA1",1,xFilial("SA1")+sc5->c5_cliente+sc5->c5_lojacli,'A1_NOME')			
	_cmensagem_pa+="Cliente/Loja: "+alltrim(sc5->c5_cliente)+" / "+sc5->c5_lojacli+"<P>"
	_cmensagem_pa+="Nome: "+cDescCLi+"<P>" 
	
	_cmensagem_pa+="Data Liberacao: "+dtoc(sc9->c9_datalib)+"<P>"
   //	_cmensagem_pa+="Lote: "+sh6->h6_lotectl+"<P>"
	_cmensagem_pa+="Usuario: "+cusername+"<P>"
   //	_cmensagem_pa+="Data: "+dtoc(date())+"<P>"
	_cmensagem_pa+="Hora: "+time()+"<P>"
					
	_canexos_pa  :="" // caminho completo dos arquivos a serem anexados, separados por ;
	_lavisa_pa   :=.f.
	u_envemail(_cde_pa,_cconta_pa,_csenha_pa,_cpara_pa,_ccc_pa,_ccco_pa,_cassunto_pa,_cmensagem_pa,_canexos_pa,_lavisa_pa)
//EndIf

			
return()   

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un玢o    � SomaValorPed   矨utor � Ricardo Fiuza's  矰ata � 05/08/14  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Funcao para somar o valor dos itens na SC9				  潮�
北�          � 	                                                          潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�


Static Function sPValor
                     
Private _G1Pvc := " "

	_G1Pvc := Posicione("SC2",1,xFilial("SC2")+alltrim(cblOp)+"01",'C2_PRODUTO')

	_cQuery 	:= " select "
	_cQuery 	+= " sg1.g1_trt trtpvc from "
	_cQuery 	+= retsqlname("SG1")+" SG1 "
	_cQuery 	+= " where sg1.d_e_l_e_t_ <> '*'"
	_cQuery 	+= " and g1_filial = '01'"
	_cQuery 	+= " and sg1.g1_cod = '"+_G1Pvc+"'"
	_cQuery 	+= " and sg1.g1_comp ='"+cblCodPvc+"'"
	
	_cQuery :=changequery(_cQuery)
	MEMOWRIT("\sql\Destrtpvc.sql",_cQuery)
   	tcquery _cQuery new alias "TMP3"
   	_cTrtPvc := tmp3->trtpvc
	TMP3->(DBCLOSEAREA())   

return(_cTrtPvc)    

*/