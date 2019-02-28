/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A175GRV  ³ Autor ³ Heraildo C. Freitas   ³ Data ³ 02/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada na Liberacao/Rejeicao do Controle de      ³±±
±±³          ³ Qualidade. Utilizado para Enviar E-Mail Quando for Rejeicao³±±
±±³20/04/06  ³ Tratamento para Bloqueio Automatico da Quantidade Liberada ³±±
±±³          ³ Quando Existir Pendencia no Empenho p/ Produtos do Tipo EN ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function a175grv()
	Local oHTML
	if sm0->m0_codigo=="01"

		_aarea   :=getarea()
		_aareasa2:=sa2->(getarea())
		_aareasb1:=sb1->(getarea())
		_aareasd4:=sd4->(getarea())
		_aareasd7:=sd7->(getarea())
		_aareasda:=sda->(getarea())
		_aareasdd:=sdd->(getarea())
		_aareasz0:=sz0->(getarea())
		// incluindo o motivo da rejeição
		_aareaqel:=qel->(getarea())
		_aareaqek:=qek->(getarea())
		_aareasyp:=syp->(getarea())
		_aareasx5:=sx5->(getarea())

		_cfilsa2:=xfilial("SA2")
		_cfilsb1:=xfilial("SB1")
		_cfilsd4:=xfilial("SD4")
		_cfilsd7:=xfilial("SD7")
		_cfilsda:=xfilial("SDA")
		_cfilsdd:=xfilial("SDD")
		_cfilsz0:=xfilial("SZ0")
		_cfilqel:=xfilial("QEL")
		_cfilqel:=xfilial("QEK")
		_cfilsyp:=xfilial("SYP")
		_cfilsx5:=xfilial("SX5")

		sa2->(dbsetorder(1))
		sa2->(dbseek(_cfilsa2+sd7->d7_fornece+sd7->d7_loja))
		sb1->(dbsetorder(1))
		sb1->(dbseek(_cfilsb1+sd7->d7_produto))

		if sd7->d7_origlan=="CP" // COMPRAS

			_cnumero  :=sd7->d7_numero
			_cProduto :=sd7->d7_produto
			_cLocal   :=sd7->d7_local
			_cSeq     :=sd7->d7_seq
			_dtentrada:=sd7->d7_data

			sd7->(dbsetorder(1))
			sd7->(dbseek(_cfilsd7+_cnumero+_cProduto+_cLocal+_cSeq))
			//		D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL+D7_SEQ+dtos(D7_DATA)

			while ! sd7->(eof()) .and.;
			sd7->d7_filial==_cfilsd7 .and.;
			sd7->d7_numero==_cnumero

				/*verificando a data de entrada*/
				if _dtentrada > sd7->d7_data
					_dtentrada = sd7->d7_data
				endif

				if sd7->d7_tipo==0 // QUANTIDADE ORIGINAL
					_nqtdori:=sd7->d7_saldo
				elseif sd7->d7_tipo==1 .and.;
				sd7->d7_estorno<>"S" // LIBERACAO

					// LIBERAÇÃO DE EMBALAGEM NÃO ESSENCIAL (EN)
					if sb1->b1_tipo=="EN" .and.;
					sb1->b1_localiz<>"S"

						// AVALIA EMPENHOS SEM LOTE APONTADO
						_cquery:=" SELECT"
						_cquery+=" SUM(D4_QUANT) D4_QUANT"

						_cquery+=" FROM "
						_cquery+=  retsqlname("SD4")+" SD4"

						_cquery+=" WHERE"
						_cquery+="     SD4.D_E_L_E_T_<>'*'"
						_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
						_cquery+=" AND D4_COD='"+sd7->d7_produto+"'"
						_cquery+=" AND D4_LOTECTL='          '"
						_cquery+=" AND D4_LOCAL='"+sd7->d7_locdest+"'"
						_cquery+=" AND D4_QUANT>0"

						_cquery:=changequery(_cquery)

						tcquery _cquery new alias "TMP1"
						tcsetfield("TMP1","D4_QUANT","N",11,2)
						tmp1->(dbgotop())
						if tmp1->d4_quant>0
							// CALCULA QUANTIDADE BLOQUEADA POR EMPENHO
							_cquery:=" SELECT"
							_cquery+=" SUM(DD_SALDO) DD_SALDO"

							_cquery+=" FROM "
							_cquery+=  retsqlname("SDD")+" SDD"

							_cquery+=" WHERE"
							_cquery+="     SDD.D_E_L_E_T_<>'*'"
							_cquery+=" AND DD_FILIAL='"+_cfilsdd+"'"
							_cquery+=" AND DD_PRODUTO='"+sd7->d7_produto+"'"
							_cquery+=" AND DD_LOCAL='"+sd7->d7_locdest+"'"
							_cquery+=" AND DD_SALDO>0"
							_cquery+=" AND DD_MOTIVO='EM'"

							_cquery:=changequery(_cquery)

							tcquery _cquery new alias "TMP2"
							tcsetfield("TMP2","DD_SALDO","N",12,2)

							tmp2->(dbgotop())

							if tmp1->d4_quant>tmp2->dd_saldo

								_nquant:=tmp1->d4_quant-tmp2->dd_saldo

								sdd->(dbsetorder(1))
								sdd->(dbgobottom())

								_cdoc:=soma1(sdd->dd_doc,6)

								_abloq:={}

								lmserroauto:=.f.

								aadd(_abloq,{"DD_DOC"    ,_cdoc              ,nil})
								aadd(_abloq,{"DD_PRODUTO",sd7->d7_produto    ,nil})
								aadd(_abloq,{"DD_LOCAL"  ,sd7->d7_locdest    ,nil})
								aadd(_abloq,{"DD_LOTECTL",sd7->d7_lotectl    ,nil})
								if _nquant<=sd7->d7_qtde
									aadd(_abloq,{"DD_QUANT"  ,_nquant            ,nil})
								else
									aadd(_abloq,{"DD_QUANT"  ,sd7->d7_qtde       ,nil})
								endif
								aadd(_abloq,{"DD_MOTIVO" ,"EM"               ,nil})
								aadd(_abloq,{"DD_OBSERVA","PENDENCIA EMPENHO",nil})
								aadd(_abloq,{"DD_DTBLOQ" ,date()             ,nil})

								msexecauto({|x,y| mata275(x,y)},_abloq,3) // BLOQUEAR

								if lmserroauto
									mostraerro()
								else

									// IDENTIFICA EMPENHOS SEM LOTE APONTADO PARA ENVIO DE E-MAIL
									_cquery:=" SELECT"
									_cquery+=" D4_OP,D4_DATA,D4_QUANT"

									_cquery+=" FROM "
									_cquery+=  retsqlname("SD4")+" SD4"

									_cquery+=" WHERE"
									_cquery+="     SD4.D_E_L_E_T_<>'*'"
									_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
									_cquery+=" AND D4_COD='"+sd7->d7_produto+"'"
									_cquery+=" AND D4_LOTECTL='          '"
									_cquery+=" AND D4_LOCAL='"+sd7->d7_locdest+"'"
									_cquery+=" AND D4_QUANT>0"

									_cquery+=" ORDER BY"
									_cquery+=" 1,2"

									_cquery:=changequery(_cquery)

									tcquery _cquery new alias "TMP3"
									tcsetfield("TMP3","D4_DATA" ,"D",08,0)
									tcsetfield("TMP3","D4_QUANT","N",11,2)

									oProcess := TWFProcess():New( "000001", "PENDENCIA DE EMPENHO" )
									oProcess:NewTask( "000001", "\workflow\pendempenho.htm" )
									oProcess:cSubject := "Bloqueio de lote por pendencia de empenho"+alltrim(sdd->dd_produto)+" - "+alltrim(sb1->b1_desc)+" Lote: - "+alltrim(sdd->dd_lotectl)
									oProcess:bReturn := ""
									oProcess:bTimeOut := {}
									oHTML := oProcess:oHTML

									oHTML:ValByName("PRODUTO"   ,alltrim(sdd->dd_produto)+" - "+alltrim(sb1->b1_desc))
									oHTML:ValByName("ARMAZEM"   ,sdd->dd_local)
									oHTML:ValByName("LOTE"      ,sdd->dd_lotectl)
									oHTML:ValByName("DOCUMENTO" ,sdd->dd_doc)
									oHTML:ValByName("QUANTIDADE",alltrim(transform(sdd->dd_quant,"@E 999,999,999.99")))
									oHTML:ValByName("USUARIO"   ,cusername)
									oHTML:ValByName("DATA"      ,dtoc(date()))
									oHTML:ValByName("HORA"      ,time())

									tmp3->(dbgotop())
									while ! tmp3->(eof())

										aadd((oHtml:valByName("TB.OP"))   ,tmp3->d4_op)
										aadd((oHtml:valByName("TB.DATA")) ,tmp3->d4_data)
										aadd((oHtml:valByName("TB.QUANT")),alltrim(transform(tmp3->d4_quant,"@E 999,999,999.99")))

										tmp3->(dbskip())
									end

									oProcess:cto := "report_almoxarifado@vitamedic.ind.br"
									// oProcess:cto := "analista@vitamedic.ind.br"
									oProcess:ccc := ""

									oProcess:UserSiga := "__cuserid"

									RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'100001')

									oProcess:Start()
									wfsendmail()

									tmp3->(dbclosearea())
								endif
							endif
							tmp2->(dbclosearea())
						endif
						tmp1->(dbclosearea())
					endif

					// Inclui automaticamente o lote no cadastro de Responsáveis Técnicos por Lote (SZ0)
					//				if sb1->b1_grupo$("EE02/EE03/EE04/EN01/EN02/EN03") //sb1->b1_resptec=="1"
					if sb1->b1_resptec=="1"

						_filial:="01"
						_produto:=sb1->b1_cod
						_local:=sd7->d7_locdest
						_lotectl:=sd7->d7_lotectl
						_rt:=getmv("MV_VITRT")

						sz0->(dbsetorder(1))
						if !sz0->(dbseek(_cfilsz0+_produto+_local+_lotectl))
							sz0->(dbgobottom())
							sz0->(reclock("SZ0",.t.))
							sz0->z0_filial  := _filial
							sz0->z0_produto  := _produto
							sz0->z0_local	   := _local
							sz0->z0_lotectl := _lotectl
							sz0->z0_resp	:= _rt
							sz0->(msunlock())
						endif
					endif

					// REPROVAÇÃO/REJEIÇÃO
				elseif sd7->d7_tipo==2 .and.;
				sd7->d7_estorno<>"S" // REJEICAO

					//pegando o motivo da rejeição
					_nautolote:=ALLTRIM(sd7->d7_lotectl)
					qel->(dbsetorder(1))
					qel->(dbseek(_cfilqel+sd7->d7_fornece+sd7->d7_loja+sd7->d7_produto+dtos(_dtentrada)+_nautolote))
					// verificando se QEL_LABOR é em branco

					_chavesyp:='000000'
					while !qel->(eof()) .and. _cfilqel = _cfilsd7;
					.and. sd7->d7_fornece = qel->qel_fornece;
					.and. sd7->d7_loja    = qel->qel_lojfor;
					.and. sd7->d7_produto = qel->qel_produt;
					.and. sd7->d7_lotectl = substr(qel->qel_lote,1,10)
						//.and. sd7->d7_data    = qel->qel_dtentr;

						if qel->qel_labor = '      '
							_chavesyp:=qel->qel_chaveh
							syp->(dbsetorder(1))
							syp->(dbseek(_cfilsyp+_chavesyp))
							exit
						endif
						qel->(dbskip())
					end

					// VERIFICANDO O CAMPO MOTIVO DA REJEIÇÃO
					_motreje:= " "
					sx5->(dbsetorder(1))
					if sx5->(dbseek(_cfilsx5+'43'+sd7->d7_motreje))
						_motreje:=alltrim(sx5->x5_descri)
					endif

					_cde      :=getmv("MV_WFMAIL")
					_cconta   :=getmv("MV_WFMAIL")
					_csenha   :=getmv("MV_WFPASSW")
					if _motreje = "AMOSTRAGEM CQ"
						_cpara    :="a175grv1@vitamedic.ind.br"
						_ccc      :=""
					else
						_cpara    :="a175grv2@vitamedic.ind.br"
						_ccc      :="report_comercial@vitamedic.ind.br" // com copia
					endif

					_ccco     :=" " // com copia oculta
					_cassunto :="Rejeicao pelo CQ do produto : "+alltrim(sd7->d7_produto)+" lote: "+sd7->d7_lotectl

					_cmensagem:="Produto: "+alltrim(sd7->d7_produto)+" - "+alltrim(sb1->b1_desc)+"<P>"
					_cmensagem+="Quantidade original: "+transform(_nqtdori,"@E 999,999,999.99")+"<P>"
					_cmensagem+="Quantidade rejeitada: "+transform(sd7->d7_qtde,"@E 999,999,999.99")+"<P>"
					_cmensagem+="Armazém destino: "+sd7->d7_locdest+"<P>"
					_cmensagem+="Documento: "+sd7->d7_numero+"<P>"
					_cmensagem+="Motivo da rejeição: "+_motreje+"<P>"
					_cmensagem+="Justificativa rejeição: "+qel->qel_justla+"<P>"

					// verificando o campo histórico
					if _chavesyp <> '000000'
						//dbselectarea("SYP")
						_cmensagem+="Histórico: "+strtran(syp->yp_texto,"\13\10","")+"<P>"
						syp->(dbskip())
						while !syp->(eof()) .and. syp->yp_chave = _chavesyp
							_cmensagem+="           "+strtran(syp->yp_texto,"\13\10","")+"<P>"
							syp->(dbskip())
						end
					endif

					_cmensagem+="Data base: "+dtoc(sd7->d7_data)+"<P>"
					_cmensagem+="Lote: "+sd7->d7_lotectl+"<P>"
					_cmensagem+="Nota fiscal: "+sd7->d7_doc+"/"+sd7->d7_serie+"<P>"
					_cmensagem+="Fornecedor: "+sd7->d7_fornece+"/"+sd7->d7_loja+"-"+alltrim(sa2->a2_nome)+"<P>"
					_cmensagem+="Usuario: "+cusername+"<P>"
					_cmensagem+="Data: "+dtoc(date())+"<P>"
					_cmensagem+="Hora: "+time()+"<P>"

					_canexos  :="" // caminho completo dos arquivos a serem anexados, separados por ;
					_lavisa   :=.f.
					u_envemail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
				endif
				sd7->(dbskip())
			end

		elseif (sd7->d7_origlan=="PR") // ENTRADA DE PRODUÇÃO
			// LIBERAÇÃO DE PRODUTO ACABADO
			_cnumero :=sd7->d7_numero
			_cProduto :=sd7->d7_produto
			_cLocal   :=sd7->d7_local
			_cSeq     :=sd7->d7_seq
			_dtentrada:=sd7->d7_data

			sd7->(dbsetorder(1))
			sd7->(dbseek(_cfilsd7+_cnumero+_cProduto+_cLocal+_cSeq))

			while ! sd7->(eof()) .and.;
			sd7->d7_filial==_cfilsd7 .and.;
			sd7->d7_numero==_cnumero

				if sd7->d7_tipo==0 // QUANTIDADE ORIGINAL
					_nqtdori:=sd7->d7_saldo
				elseif sd7->d7_tipo==1 .and.;
				sd7->d7_estorno<>"S" // LIBERACAO

					if sb1->b1_tipo="PA"

						_cde_pa      :=Alltrim(getmv("MV_WFMAIL"))
						_cconta_pa   :=Alltrim(getmv("MV_WFMAIL"))
						_csenha_pa   :=Alltrim(getmv("MV_WFPASSW"))

						_cpara_pa    :="liberacaopa@vitamedic.ind.br"
						_ccc_pa      :="report_ti@vitamedic.ind.br" // com copia
						_ccco_pa     :=" " // com copia oculta
						_cassunto_pa :="Liberação pela GQL/CQL do produto : "+alltrim(sd7->d7_produto)+" lote: "+sd7->d7_lotectl

						_cmensagem_pa:="Produto: "+alltrim(sd7->d7_produto)+" - "+alltrim(sb1->b1_desc)+"<P>"
						_cmensagem_pa+="Quantidade original: "+transform(_nqtdori,"@E 999,999,999.99")+"<P>"
						_cmensagem_pa+="Quantidade Liberada: "+transform(sd7->d7_qtde,"@E 999,999,999.99")+"<P>"
						_cmensagem_pa+="Armazém destino: "+sd7->d7_locdest+"<P>"
						_cmensagem_pa+="Documento: "+sd7->d7_numero+"<P>"
						_cmensagem_pa+="Data base: "+dtoc(sd7->d7_data)+"<P>"
						_cmensagem_pa+="Lote: "+sd7->d7_lotectl+"<P>"
						_cmensagem_pa+="Usuario: "+cusername+"<P>"
						_cmensagem_pa+="Data: "+dtoc(date())+"<P>"
						_cmensagem_pa+="Hora: "+time()+"<P>"

						_canexos_pa  :="" // caminho completo dos arquivos a serem anexados, separados por ;
						_lavisa_pa   :=.f.
						u_envemail(_cde_pa,_cconta_pa,_csenha_pa,_cpara_pa,_ccc_pa,_ccco_pa,_cassunto_pa,_cmensagem_pa,_canexos_pa,_lavisa_pa)
					endif

					// FAZ ENDERECAMENTO AUTOMATICO
					if ! empty(sd7->d7_localiz) .and.;
					substr(sd7->d7_localiz,1,10)<>"QUARENTENA"
					//.and. sd7->d7_locdest<>'02'

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

							//-- Alteração Marcos Natã 07-03-2018
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
							//-- Fim alteração 07-03-2018

							msexecauto({|x,y,z| mata265(x,y,z)},_acab,_aitem,3)
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
		sdd->(restarea(_aareasdd))
		sz0->(restarea(_aareasz0))
		qel->(restarea(_aareaqel))
		sx5->(restarea(_aareasx5))
		restarea(_aarea)
	endif
return()
