#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} q215fim
Ponto de Entrada na Liberacao / Rejeicao do Controle de
Qualidade. Utilizado para Realizar o Enderecamento Automatico
das Liberacoes de Material de Embalagem via Inspecao de Entradas.

@author Alex Junio de Miranda
@since 13/05/11
@version 1.0

@type function
/*/
user function q215fim()
	Local _LocRep   := GetMV("MV_XLOCRE2")
	Local _EndRep   := GetMV("MV_XENDREP")
	Local _LocAmo   := GetMV("MV_XLOCAMO")
	Local _EndAmo   := GetMV("MV_XENDAMO")

	if sm0->m0_codigo=="01"

		_aarea   :=getarea()
		_aareasa2:=sa2->(getarea())
		_aareasb1:=sb1->(getarea())
		_aareasd4:=sd4->(getarea())
		_aareasd7:=sd7->(getarea())
		_aareasda:=sda->(getarea())

		_cfilsa2:=xfilial("SA2")
		_cfilsb1:=xfilial("SB1")
		_cfilsd4:=xfilial("SD4")
		_cfilsd7:=xfilial("SD7")
		_cfilsda:=xfilial("SDA")

		if sd7->d7_origlan=="CP" // COMPRAS

			_cnumero :=sd7->d7_numero
			_dtentrada:=sd7->d7_data

			sd7->(dbsetorder(1))
			sd7->(dbseek(_cfilsd7+_cnumero))

			while ! sd7->(eof()) .and.;
			sd7->d7_filial==_cfilsd7 .and.;
			sd7->d7_numero==_cnumero

				//verificando a data de entrada
				if _dtentrada > sd7->d7_data
					_dtentrada = sd7->d7_data
				endif

				if sd7->d7_tipo==0 // QUANTIDADE ORIGINAL
					_nqtdori:=sd7->d7_saldo
				elseif (sd7->d7_tipo==1 .and. sd7->d7_estorno<>"S") .or.;
				(sd7->d7_tipo==2 .and. (sd7->d7_locdest==_LocRep .or. sd7->d7_locdest==_LocAmo) /*'10'*/ .and. sd7->d7_estorno<>"S")// LIBERACAO

					//Acrescentados os tipos MP e PA  à pedido do Sr. Guilherme em 15/05/2017

					if sb1->b1_tipo $"EE/EN/MP/PA"
						_cde_me      :=getmv("MV_WFMAIL")
						_cconta_me   :=getmv("MV_WFACC")
						_csenha_me   :=getmv("MV_WFPASSW")
						_cpara_me    :="glogistica@vitapan.com.br;almoxarifado@vitapan.com.br;almoxarifado2@vitapan.com.br;"
						_cpara_me    +="almoxarifado3@vitapan.com.br"
						_ccc_me      :="a.almeida@vitapan.com.br" // com copia
						_ccco_me     :="" // com copia oculta
						_cassunto_me :="LiberaÃ§Ã£o pelo CQ da "+alltrim(sb1->b1_tipo)+": "+alltrim(sd7->d7_produto)+" lote: "+sd7->d7_lotectl

						_cmensagem_me:="Produto: "+alltrim(sd7->d7_produto)+" - "+alltrim(sb1->b1_desc)+"<P>"
						_cmensagem_me+="Quantidade original: "+transform(_nqtdori,"@E 999,999,999.99")+"<P>"
						_cmensagem_me+="Quantidade Liberada: "+transform(sd7->d7_qtde,"@E 999,999,999.99")+"<P>"
						_cmensagem_me+="ArmazÃ©m destino: "+sd7->d7_locdest+"<P>"
						_cmensagem_me+="Documento: "+sd7->d7_numero+"<P>"
						_cmensagem_me+="Data base: "+dtoc(sd7->d7_data)+"<P>"
						_cmensagem_me+="Lote: "+sd7->d7_lotectl+"<P>"
						_cmensagem_me+="Usuario: "+cusername+"<P>"
						_cmensagem_me+="Data: "+dtoc(date())+"<P>"
						_cmensagem_me+="Hora: "+time()+"<P>"

						_canexos_me  :="" // caminho completo dos arquivos a serem anexados, separados por ;
						_lavisa_me   :=.f.
						u_envemail(_cde_me,_cconta_me,_csenha_me,_cpara_me,_ccc_me,_ccco_me,_cassunto_me,_cmensagem_me,_canexos_me,_lavisa_me)
					endif

					// FAZ ENDERECAMENTO AUTOMATICO
					if ! empty(sd7->d7_localiz) .and.;
					substr(sd7->d7_localiz,1,10)<>"QUARENTENA" .and.;
					sd7->d7_locdest<>'01' .and.;
					sd7->d7_locdest<>'92' .and.;
					sd7->d7_locdest<>'94' .and.;
					sd7->d7_locdest<>'95'

						sda->(dbsetorder(1))
						sda->(dbseek(_cfilsda+sd7->d7_produto+sd7->d7_locdest+sd7->d7_numseq+sd7->d7_numero))

						if sda->da_saldo>=sd7->d7_qtde

							lmserroauto:=.f.

							_acab:={}
							aadd(_acab,{"DA_PRODUTO",sd7->d7_produto,nil})
							aadd(_acab,{"DA_QTDORI" ,sd7->d7_qtde   ,nil})
							aadd(_acab,{"DA_SALDO"  ,sd7->d7_qtde   ,nil})
							aadd(_acab,{"DA_DATA"   ,sd7->d7_data   ,nil})
							aadd(_acab,{"DA_LOTECTL",sd7->d7_lotectl,nil})
							aadd(_acab,{"DA_LOCAL"  ,sd7->d7_locdest,nil})
							aadd(_acab,{"DA_DOC"    ,sd7->d7_numero ,nil})
							aadd(_acab,{"DA_ORIGEM" ,"SD3"          ,nil})
							aadd(_acab,{"DA_NUMSEQ" ,sd7->d7_numseq ,nil})
							aadd(_acab,{"DA_QTSEGUM",sd7->d7_qtsegum,nil})
							aadd(_acab,{"DA_QTDORI2",sd7->d7_qtsegum,nil})

							//-- Alteração Marcos Natã 13-12-2017
							//-- Quantidades rejeitadas serão endereçadas em "AMOSTRAGEM C.Q."
							If SD7->D7_TIPO <> 2
								_aitem:={{{"DB_ITEM"   ,"0001"          ,nil},;
								{"DB_LOCALIZ",sd7->d7_localiz,nil},;
								{"DB_QUANT"  ,sd7->d7_qtde   ,nil},;
								{"DB_DATA"   ,ddatabase      ,nil}}}
							Else
								_aitem:={{{"DB_ITEM"   ,"0001"          ,nil},;
								{"DB_LOCALIZ","AMOSTRAGEM C.Q.",nil},; //-- Somenta para rejeitados
								{"DB_QUANT"  ,sd7->d7_qtde   ,nil},;
								{"DB_DATA"   ,ddatabase      ,nil}}}
							EndIf
							//-- Fim alteração 13-12-2017

							// CHAMAR VIA STARTJOB POIS QUANDO UTILIZADO O MÓDULO DE INSPEÇÃO DE ENTRADAS DÁ ERRO
							startjob("U_VIT289",getenvserver(),.t.,sm0->m0_codigo,sm0->m0_codfil,_acab,_aitem)

							// CHAMAR VIA STARTJOB POIS QUANDO UTILIZADO O MÓDULO DE INSPEÇÃO DE ENTRADAS DÁ ERRO
							if sb1->b1_tipo $"EE/EN"
								_nQtdLib := sd7->d7_qtde
								//U_VIT383(_nQtdLib)
							endif

						endif
					endif
				endif
				sd7->(dbskip())
			end
		endif
		sa2->(restarea(_aareasa2))
		sb1->(restarea(_aareasb1))
		sd4->(restarea(_aareasd4))
		sd7->(restarea(_aareasd7))
		sda->(restarea(_aareasda))
	endif
return