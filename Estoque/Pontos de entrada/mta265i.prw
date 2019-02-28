/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA265I  ³ Autor ³ Heraildo C. Freitas   ³ Data ³ 08/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada no Enderecamento de Produtos e            ³±±
±±³          ³ Tratamento para Bloqueio Automatico da Quantidade Liberada ³±±
±±³          ³ Quando Existir Pendencia no Empenho p/ Produtos do Tipo EN ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function mta265i()
Local oHTML
if sm0->m0_codigo=="01" .and.;
	sdb->db_local<>getmv("MV_CQ")
	
	_aarea   :=getarea()
	_aareasb1:=sb1->(getarea())
	_aareasd4:=sd4->(getarea())
	_aareasd7:=sd7->(getarea())
	_aareasdd:=sdd->(getarea())
	_aareasc2:=sc2->(getarea())
	
	_cfilsb1:=xfilial("SB1")
	_cfilsd4:=xfilial("SD4")
	_cfilsd7:=xfilial("SD7")
	_cfilsdd:=xfilial("SDD")
	_cfilsc2:=xfilial("SC2")
	
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+sdb->db_produto))
	
	if sb1->b1_tipo=="EN"
		
		sd7->(dbsetorder(3))
		if sd7->(dbseek(_cfilsd7+sdb->db_produto+sdb->db_numseq))
			// AVALIA EMPENHOS SEM LOTE APONTADO
			_cquery:=" SELECT"
			_cquery+=" SUM(D4_QUANT) D4_QUANT"
			
			_cquery+=" FROM "
			_cquery+=  retsqlname("SD4")+" SD4"
			
			_cquery+=" WHERE"
			_cquery+="     SD4.D_E_L_E_T_<>'*'"
			_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
			_cquery+=" AND D4_COD='"+sdb->db_produto+"'"
			_cquery+=" AND D4_LOTECTL='          '"
			_cquery+=" AND D4_LOCAL='"+sdb->db_local+"'"
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
				_cquery+=" AND DD_PRODUTO='"+sdb->db_produto+"'"
				_cquery+=" AND DD_LOCAL='"+sdb->db_local+"'"
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
					aadd(_abloq,{"DD_PRODUTO",sdb->db_produto    ,nil})
					aadd(_abloq,{"DD_LOCAL"  ,sdb->db_local      ,nil})
					aadd(_abloq,{"DD_LOTECTL",sdb->db_lotectl    ,nil})
					if _nquant<=sdb->db_quant
						aadd(_abloq,{"DD_QUANT"  ,_nquant            ,nil})
					else
						aadd(_abloq,{"DD_QUANT"  ,sdb->db_quant      ,nil})
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
						_cquery+=" D4_OP,B1_COD||'- '||B1_DESC B1_DESC, D4_DATA,D4_QUANT"
						
						_cquery+=" FROM "
						_cquery+=  retsqlname("SD4")+" SD4,"
						_cquery+=  retsqlname("SB1")+" SB1,"
						_cquery+=  retsqlname("SC2")+" SC2"
						
						_cquery+=" WHERE"
						_cquery+="     SD4.D_E_L_E_T_<>'*'"
						_cquery+=" AND SC2.D_E_L_E_T_<>'*'"
						_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
						_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
						_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
						_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"
						_cquery+=" AND D4_COD='"+sdb->db_produto+"'"
						_cquery+=" AND D4_LOTECTL='          '"
						_cquery+=" AND D4_LOCAL='"+sdb->db_local+"'"
						_cquery+=" AND D4_QUANT>0"
						_cquery+=" AND D4_OP=C2_NUM||C2_ITEM||C2_SEQUEN||C2_IDENT"
						_cquery+=" AND C2_PRODUTO=B1_COD"
						
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
							aadd((oHtml:valByName("TB.PRODOP"))   ,tmp3->b1_desc)
							aadd((oHtml:valByName("TB.DATA")) ,tmp3->d4_data)
							aadd((oHtml:valByName("TB.QUANT")),alltrim(transform(tmp3->d4_quant,"@E 999,999,999.99")))
							
							tmp3->(dbskip())
						end
						
						oProcess:cto := "almoxarifado2@vitamedic.ind.br;gti@vitamedic.ind.br;glogistica@vitamedic.ind.br;almoxarifado@vitamedic.ind.br"
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
	endif
	
	sb1->(restarea(_aareasb1))
	sd4->(restarea(_aareasd4))
	sd7->(restarea(_aareasd7))
	sdd->(restarea(_aareasdd))
	sc2->(restarea(_aareasc2))
	restarea(_aarea)
endif
return()
