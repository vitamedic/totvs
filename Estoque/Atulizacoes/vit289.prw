#include "rwmake.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} vit289
	Executa a MSEXECAUTO da Rotina de Enderecamento (MATA265) Via STARTJOB Chamado do Ponto de Entrada A175GRV
@author Heraildo C. Freitas
@since 10/01/07
@version 1.0
@return ${return}, ${return_description}
@param _cempresa, , descricao
@param _cfilial, , descricao
@param _acab, , descricao
@param _aitem, , descricao
@type function
/*/
user function vit289(_cempresa,_cfilial,_acab,_aitem)
prepare environment empresa _cempresa filial _cfilial modulo "EST"

lmserroauto:=.f.

msexecauto({|x,y,z| mata265(x,y,z)},_acab,_aitem,3)

if lmserroauto
	mostraerro("\temp\","vit289.txt")
/*

	_cde_me      :="Servidor Protheus - Aviso <"+getmv("MV_WFMAIL")+">"
	_cconta_me   :=getmv("MV_WFACC")
	_csenha_me   :=getmv("MV_WFPASSW")

	_ccc_me      :="" // com copia
	_ccco_me     :="" // com copia oculta
	_cassunto_me :="Erro na Liberação pelo CQ de "+alltrim(_acab[1,2])+": lote: "+_acab[5,2]
					
	_cmensagem_me:="Produto: "+alltrim(_acab[1,2])+"<P>"
	_cmensagem_me+="Quantidade original: "+transform(_acab[2,2],"@E 999,999,999.99")+"<P>"
	_cmensagem_me+="Quantidade Endereçada: "+transform(_item[3,2],"@E 999,999,999.99")+"<P>"
	_cmensagem_me+="Endereço: "+_item[2,2]+"<P>"
	_cmensagem_me+="Armazém destino: "+_acab[6,2]+"<P>"
	_cmensagem_me+="Documento: "+_acab[7,2]+"<P>"
	_cmensagem_me+="Data base: "+dtoc(_acab[4,2])+"<P>"
	_cmensagem_me+="Lote: "+_acab[5,2]+"<P>"
	_cmensagem_me+="Usuario: "+cusername+"<P>"
	_cmensagem_me+="Data: "+dtoc(date())+"<P>"
	_cmensagem_me+="Hora: "+time()+"<P>"
					
	_canexos_me  :="\temp\vit289.txt" // caminho completo dos arquivos a serem anexados, separados por ;
	_lavisa_me   :=.f.
	u_envemail(_cde_me,_cconta_me,_csenha_me,_cpara_me,_ccc_me,_ccco_me,_cassunto_me,_cmensagem_me,_canexos_me,_lavisa_me)
*/
endif

reset environment
return()
