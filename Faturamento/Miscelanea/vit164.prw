/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT164 ³ Autor ³ Heraildo C. de Freitas³ Data ³ 30/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao dos Arquivos para Forca de Vendas                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit164()
_cperg:="PERGVT164N"
_pergsx1()
if pergunte(_cperg,.t.) .and.;
	msgyesno("Confirma geracao dos arquivos para forca de vendas?")
	
	processa({|| _geraarq()})
	msginfo("Arquivo(s) gerado(s) com sucesso!")
endif
return()

static function _geraarq()
_cfilda0:=xfilial("DA0")
_cfilda1:=xfilial("DA1")
_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsa4:=xfilial("SA4")
_cfilsa6:=xfilial("SA6")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsct:=xfilial("SCT")
_cfilsd2:=xfilial("SD2")
_cfilse1:=xfilial("SE1")
_cfilse3:=xfilial("SE3")
_cfilse4:=xfilial("SE4")
_cfilsf4:=xfilial("SF4")
_cfilsf2:=xfilial("SF2")
_cfilsz8:=xfilial("SZ8")
_cfilsz9:=xfilial("SZ9")

procregua(sa3->(lastrec()))

_cquery:=" SELECT"
_cquery+=" A3_COD,"
_cquery+=" A3_NOME,"
_cquery+=" A3_COMIS"

_cquery+=" FROM "
_cquery+=  retsqlname("SA3")+" SA3"

_cquery+=" WHERE"
_cquery+="     SA3.D_E_L_E_T_<>'*'"
_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
_cquery+=" AND A3_POCKET='S'"
_cquery+=" AND A3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"

_cquery+=" ORDER BY"
_cquery+=" A3_COD"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","A3_COMIS","N",05,2)

tmp1->(dbgotop())
while ! tmp1->(eof())
	incproc("Representante "+tmp1->a3_cod+"-"+tmp1->a3_nome)
	
	_lcontinua:=.t.
	
	// CADASTRO DE CLIENTES ORDENADO PELO NOME+LOJA
	_carqv1:="\pocket\origem\"+tmp1->a3_cod+"clidesc.txt"
	_narqv1:=fcreate(_carqv1,0)
	if _narqv1<0
		msginfo("Erro na criacao do arquivo "+_carqv1)
		_lcontinua:=.f.
	endif
	
	// CADASTRO DE CLIENTES ORDENADO PELO CODIGO+LOJA
	_carqv2:="\pocket\origem\"+tmp1->a3_cod+"cliente.txt"
	_narqv2:=fcreate(_carqv2,0)
	if _narqv2<0
		msginfo("Erro na criacao do arquivo "+_carqv2)
		_lcontinua:=.f.
	endif
	
	// PRODUTOS EM PROMOCAO
	_carqv3:="\pocket\origem\"+tmp1->a3_cod+"propromo.txt"
	_narqv3:=fcreate(_carqv3,0)
	if _narqv3<0
		msginfo("Erro na criacao do arquivo "+_carqv3)
		_lcontinua:=.f.
	endif
	
	// TABELA DE PRECOS
	_carqv4:="\pocket\origem\"+tmp1->a3_cod+"tabprec.txt"
	_narqv4:=fcreate(_carqv4,0)
	if _narqv4<0
		msginfo("Erro na criacao do arquivo "+_carqv4)
		_lcontinua:=.f.
	endif
	
	// ITENS DA TABELA DE PRECOS
	_carqv5:="\pocket\origem\"+tmp1->a3_cod+"ittab.txt"
	_narqv5:=fcreate(_carqv5,0)
	if _narqv5<0
		msginfo("Erro na criacao do arquivo "+_carqv5)
		_lcontinua:=.f.
	endif
	
	// TRANSPORTADORAS
	_carqv6:="\pocket\origem\"+tmp1->a3_cod+"transp.txt"
	_narqv6:=fcreate(_carqv6,0)
	if _narqv6<0
		msginfo("Erro na criacao do arquivo "+_carqv6)
		_lcontinua:=.f.
	endif
	
	// FATURA
	_carqv7:="\pocket\origem\"+tmp1->a3_cod+"fatura.txt"
	_narqv7:=fcreate(_carqv7,0)
	if _narqv7<0
		msginfo("Erro na criacao do arquivo "+_carqv7)
		_lcontinua:=.f.
	endif
	
	// COMIS
	_carqv8:="\pocket\origem\"+tmp1->a3_cod+"comis.txt"
	_narqv8:=fcreate(_carqv8,0)
	if _narqv8<0
		msginfo("Erro na criacao do arquivo "+_carqv8)
		_lcontinua:=.f.
	endif
	
	// NOTAS
	_carqv9:="\pocket\origem\"+tmp1->a3_cod+"notas.txt"
	_narqv9:=fcreate(_carqv9,0)
	if _narqv9<0
		msginfo("Erro na criacao do arquivo "+_carqv9)
		_lcontinua:=.f.
	endif
	
	// ITNOTAS
	_carqv10:="\pocket\origem\"+tmp1->a3_cod+"itnotas.txt"
	_narqv10:=fcreate(_carqv10,0)
	if _narqv10<0
		msginfo("Erro na criacao do arquivo "+_carqv10)
		_lcontinua:=.f.
	endif
	
	// PENDENCIA
	_carqv11:="\pocket\origem\"+tmp1->a3_cod+"pendencia.txt"
	_narqv11:=fcreate(_carqv11,0)
	if _narqv11<0
		msginfo("Erro na criacao do arquivo "+_carqv11)
		_lcontinua:=.f.
	endif
	
	// ITPENDCLI
	_carqv12:="\pocket\origem\"+tmp1->a3_cod+"itpendcli.txt"
	_narqv12:=fcreate(_carqv12,0)
	if _narqv12<0
		msginfo("Erro na criacao do arquivo "+_carqv12)
		_lcontinua:=.f.
	endif
	
	// ITPEND
	_carqv13:="\pocket\origem\"+tmp1->a3_cod+"itpend.txt"
	_narqv13:=fcreate(_carqv13,0)
	if _narqv13<0
		msginfo("Erro na criacao do arquivo "+_carqv13)
		_lcontinua:=.f.
	endif
	
	// METMES
	_carqv14:="\pocket\origem\"+tmp1->a3_cod+"metmes.txt"
	_narqv14:=fcreate(_carqv14,0)
	if _narqv14<0
		msginfo("Erro na criacao do arquivo "+_carqv14)
		_lcontinua:=.f.
	endif
	
	// METANO
	_carqv15:="\pocket\origem\"+tmp1->a3_cod+"metano.txt"
	_narqv15:=fcreate(_carqv15,0)
	if _narqv15<0
		msginfo("Erro na criacao do arquivo "+_carqv15)
		_lcontinua:=.f.
	endif
	
	// RELPED
	_carqv16:="\pocket\origem\"+tmp1->a3_cod+"relped.txt"
	_narqv16:=fcreate(_carqv16,0)
	if _narqv16<0
		msginfo("Erro na criacao do arquivo "+_carqv16)
		_lcontinua:=.f.
	endif
	
	// RELPEDITN
	_carqv17:="\pocket\origem\"+tmp1->a3_cod+"relpeditn.txt"
	_narqv17:=fcreate(_carqv17,0)
	if _narqv17<0
		msginfo("Erro na criacao do arquivo "+_carqv17)
		_lcontinua:=.f.
	endif
	
	// RELFAT
	_carqv18:="\pocket\origem\"+tmp1->a3_cod+"relfat.txt"
	_narqv18:=fcreate(_carqv18,0)
	if _narqv18<0
		msginfo("Erro na criacao do arquivo "+_carqv18)
		_lcontinua:=.f.
	endif
	
	// RELABC
	_carqv19:="\pocket\origem\"+tmp1->a3_cod+"relabc.txt"
	_narqv19:=fcreate(_carqv19,0)
	if _narqv19<0
		msginfo("Erro na criacao do arquivo "+_carqv19)
		_lcontinua:=.f.
	endif
	
	if _lcontinua
		_acli   :={}
		_aest   :={}
		_atransp:={}
		
		sa1->(dbordernickname("SA1VIT01"))
		sa1->(dbseek(_cfilsa1+tmp1->a3_cod))
		while ! sa1->(eof()) .and.;
			sa1->a1_filial==_cfilsa1 .and.;
			sa1->a1_vend==tmp1->a3_cod
			
			if sa1->a1_categ<>"I "
				
				aadd(_acli,{sa1->a1_cod,sa1->a1_loja,sa1->a1_nome,sa1->a1_end,sa1->a1_bairro,sa1->a1_mun,;
				sa1->a1_est,sa1->a1_cep,sa1->a1_ddd,sa1->a1_tel,sa1->a1_contato,sa1->a1_cgc,;
				sa1->a1_inscr,sa1->a1_autoriz,sa1->a1_transp,sa1->a1_desc,sa1->a1_cond,;
				sa1->a1_ultcom,sa1->a1_msaldo,sa1->a1_metr,sa1->a1_liminar})
				
				_ni:=ascan(_aest,sa1->a1_est)
				if _ni==0
					aadd(_aest,sa1->a1_est)
				endif
				if ! empty(sa1->a1_transp)
					_ni:=ascan(_atransp,sa1->a1_transp)
					if _ni==0
						aadd(_atransp,sa1->a1_transp)
					endif
				endif
			endif
			
			sa1->(dbskip())
		end
		
		// CADASTRO DE CLIENTES ORDENADO PELO NOME+LOJA
		_aclinome:=asort(_acli,,,{|x,y| x[3]+x[2]<y[3]+y[2]})
		for _ni:=1 to len(_aclinome)
			fwrite(_narqv1,_aclinome[_ni,03]) // A1_NOME
			fwrite(_narqv1,_aclinome[_ni,01]) // A1_COD
			fwrite(_narqv1,_aclinome[_ni,02]) // A1_LOJA
			fwrite(_narqv1,chr(13)+chr(10))
		next
		
		// CADASTRO DE CLIENTES ORDENADO PELO CODIGO+LOJA
		_aclicod:=asort(_acli,,,{|x,y| x[1]+x[2]<y[1]+y[2]})
		for _ni:=1 to len(_aclicod)
			_cultcom:=strzero(day(_aclicod[_ni,18]),2)+strzero(month(_aclicod[_ni,18]),2)+strzero(year(_aclicod[_ni,18]),4)
			fwrite(_narqv2,_aclicod[_ni,01]) // A1_COD
			fwrite(_narqv2,_aclicod[_ni,02]) // A1_LOJA
			fwrite(_narqv2,_aclicod[_ni,03]) // A1_NOME
			fwrite(_narqv2,_aclicod[_ni,04]) // A1_END
			fwrite(_narqv2,_aclicod[_ni,05]) // A1_BAIRRO
			fwrite(_narqv2,_aclicod[_ni,06]) // A1_MUN
			fwrite(_narqv2,_aclicod[_ni,07]) // A1_EST
			fwrite(_narqv2,_aclicod[_ni,08]) // A1_CEP
			fwrite(_narqv2,_aclicod[_ni,09]) // A1_DDD
			fwrite(_narqv2,_aclicod[_ni,10]) // A1_TEL
			fwrite(_narqv2,_aclicod[_ni,11]) // A1_CONTATO
			fwrite(_narqv2,_aclicod[_ni,12]) // A1_CGC
			fwrite(_narqv2,_aclicod[_ni,13]) // A1_INSCR
			fwrite(_narqv2,_aclicod[_ni,14]) // A1_AUTORIZ
			fwrite(_narqv2,_aclicod[_ni,15]) // A1_TRANSP
			fwrite(_narqv2,strzero(_aclicod[_ni,16],2)) // A1_DESC
			fwrite(_narqv2,_aclicod[_ni,17]) // A1_COND
			fwrite(_narqv2,_cultcom) // A1_ULTCOM
			fwrite(_narqv2,strzero(round(_aclicod[_ni,19]*100,0),17)) // A1_MSALDO
			fwrite(_narqv2,strzero(round(_aclicod[_ni,20]*100,0),10)) // A1_METR
			fwrite(_narqv2,_aclicod[_ni,21]) // A1_LIMINAR
			fwrite(_narqv2,chr(13)+chr(10))
		next
		
		da0->(dbsetorder(1))
		da0->(dbseek(_cfilda0))
		_ltab :=.t.
		_nfatorneg:=0
		_nfatorpos:=0
		
		while ! da0->(eof()) .and.;
			da0->da0_filial==_cfilda0			
			_lachou:=.f.
			for _ni:=1 to len(_aest)
				if _aest[_ni]$da0->da0_estado
					_lachou:=.t.
				endif
			next
			if _lachou .and.;
				(empty(da0->da0_datate) .or. da0->da0_datate>=date())
				
				if da0->da0_desc3==5.68
					_nfatorpos:=0.7234
					_nfatorneg:=0.7516
				elseif da0->da0_desc3==6.82
					_nfatorpos:=0.7234
					_nfatorneg:=0.7519
				elseif da0->da0_desc3==7.95
					_nfatorpos:=0.7234
					_nfatorneg:=0.7523
				endif
				
				// PRODUTOS EM PROMOCAO
				if empty(da0->da0_status) .and. _ltab
					sb1->(dbsetorder(2))
					sb1->(dbseek(_cfilsb1+"PA"))
					_ltab :=.f.

					while ! sb1->(eof()) .and.;
						sb1->b1_filial==_cfilsb1 .and.;
						sb1->b1_tipo=="PA"
						if sb1->b1_promoc$"PMF"
							if sb1->b1_categ=="N  "
								_ccateg:="N"
							else
								_ccateg:="P"
							endif
							
							da1->(dbsetorder(2))
							da1->(dbseek(_cfilda1+sb1->b1_cod+da0->da0_codtab))
							_nprecoliq:=da1->da1_prcven*(da0->da0_desc1/100)
							_nprecoliq:=_nprecoliq-(_nprecoliq*(da0->da0_desc2/100))
							_nprecoliq:=_nprecoliq-(_nprecoliq*(da0->da0_desc3/100))
							_nprecoliq:=_nprecoliq-(_nprecoliq*(sb1->b1_descmax/100))
							
							// PROPROMO

							fwrite(_narqv3,substr(sb1->b1_cod,1,6))
							fwrite(_narqv3,sb1->b1_desc)
							fwrite(_narqv3,sb1->b1_apres)
							fwrite(_narqv3,strzero(sb1->b1_cxpad,3))
							fwrite(_narqv3,sb1->b1_anvisa)
							fwrite(_narqv3,sb1->b1_codbar)
							fwrite(_narqv3,sb1->b1_posipi)
							fwrite(_narqv3,_ccateg)
							fwrite(_narqv3,strzero(sb1->b1_prvalid,4))
							fwrite(_narqv3,sb1->b1_promoc)
							fwrite(_narqv3,strzero(round(sb1->b1_descmax*100,0),5))
							fwrite(_narqv3,strzero(round(_nprecoliq*100,0),9))
							fwrite(_narqv3,chr(13)+chr(10))
						endif
						sb1->(dbskip())
					end
				endif
				
				// TABELA DE PRECOS
				if da0->da0_status<>"R" .and.;
					da0->da0_ativo<>"2" .and. ;
					da0->da0_codtab<> "999"
					
					if da0->da0_status=="L" //.OR. da0->da0_status=="R" //empty(da0->da0_status)
						_ncomis:=5						
						_ndescavista:=3						
					else
						_ncomis:=tmp1->a3_comis
						_ndescavista:=5						
					endif					
/*					if da0->da0_status=="L"
					else
					endif*/
					
					fwrite(_narqv4,da0->da0_codtab)
					fwrite(_narqv4,da0->da0_descri)
					fwrite(_narqv4,strzero(round(da0->da0_desc3*100,0),4))
					fwrite(_narqv4,strzero(round(da0->da0_desc1*100,0),4))
					fwrite(_narqv4,strzero(round(da0->da0_desc2*100,0),4))
					fwrite(_narqv4,strzero(round(_ncomis*100,0),5))
					fwrite(_narqv4,strzero(round(_ndescavista*100,0),4))
					fwrite(_narqv4,chr(13)+chr(10))
					
					// ITENS DA TABELA DE PRECOS
					da1->(dbsetorder(1))
					da1->(dbseek(_cfilda1+da0->da0_codtab))
					while ! da1->(eof()) .and.;
						da1->da1_filial==_cfilsa1 .and.;
						da1->da1_codtab==da0->da0_codtab
						
						sb1->(dbsetorder(1))
						sb1->(dbseek(_cfilsb1+da1->da1_codpro))
						
						if sb1->b1_categ=="N  "
							_nmaxcons:=da1->da1_prcven/_nfatorneg
						else
							_nmaxcons:=da1->da1_prcven/_nfatorpos
						endif
						
						fwrite(_narqv5,da1->da1_codtab)
						fwrite(_narqv5,substr(da1->da1_codpro,1,6))
						fwrite(_narqv5,strzero(round(da1->da1_prcven*100,0),9))
						fwrite(_narqv5,strzero(round(_nmaxcons*100,0),9))
						fwrite(_narqv5,chr(13)+chr(10))
						
						da1->(dbskip())
					end
				endif
			endif
			da0->(dbskip())
		end
		
		// TRANSPORTADORAS
		_atransps:=asort(_atransp)
		for _ni:=1 to len(_atransps)
			sa4->(dbsetorder(1))
			sa4->(dbseek(_cfilsa4+_atransps[_ni]))
			
			fwrite(_narqv6,sa4->a4_cod)
			fwrite(_narqv6,sa4->a4_nome)
			fwrite(_narqv6,chr(13)+chr(10))
		next
		
		// FATURA
		_cquery:=" SELECT"
		_cquery+=" E1_CLIENTE,"
		_cquery+=" E1_LOJA,"
		_cquery+=" E1_PREFIXO,"
		_cquery+=" E1_NUM,"
		_cquery+=" E1_PARCELA,"
		_cquery+=" E1_TIPO,"
		_cquery+=" E1_EMISSAO,"
		_cquery+=" E1_VENCREA,"
		_cquery+=" E1_VALOR,"
		_cquery+=" E1_SALDO,"
		_cquery+=" E1_PORCJUR,"
		_cquery+=" E1_COMIS1,"
		_cquery+=" E1_BAIXA,"
		_cquery+=" E1_SITUACA,"
		_cquery+=" E1_PORTADO,"
		_cquery+=" E1_DESCONT,"
		_cquery+=" E1_VALLIQ,"
		_cquery+=" E1_JUROS,"
		_cquery+=" E1_VEND1"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SA1")+" SA1,"
		_cquery+=  retsqlname("SE1")+" SE1"
		
		_cquery+=" WHERE"
		_cquery+="     SA1.D_E_L_E_T_<>'*'"
		_cquery+=" AND SE1.D_E_L_E_T_<>'*'"
		_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
		_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
		_cquery+=" AND E1_CLIENTE=A1_COD"
		_cquery+=" AND E1_LOJA=A1_LOJA"
		_cquery+=" AND A1_VEND='"+tmp1->a3_cod+"'"
		_cquery+=" AND E1_FLAGFAT<>'S'"
		_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
		
		_cquery+=" ORDER BY"
		_cquery+=" E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","E1_EMISSAO","D",08,0)
		tcsetfield("TMP2","E1_VENCREA","D",08,0)
		tcsetfield("TMP2","E1_VALOR"  ,"N",15,2)
		tcsetfield("TMP2","E1_SALDO"  ,"N",15,2)
		tcsetfield("TMP2","E1_PORCJUR","N",05,2)
		tcsetfield("TMP2","E1_COMIS1" ,"N",06,2)
		tcsetfield("TMP2","E1_BAIXA"  ,"D",08,0)
		tcsetfield("TMP2","E1_DESCONT","N",15,2)
		tcsetfield("TMP2","E1_VALLIQ" ,"N",15,2)
		tcsetfield("TMP2","E1_JUROS"  ,"N",15,2)
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_cemissao:=strzero(day(tmp2->e1_emissao),2)+strzero(month(tmp2->e1_emissao),2)+strzero(year(tmp2->e1_emissao),4)
			_cvencrea:=strzero(day(tmp2->e1_vencrea),2)+strzero(month(tmp2->e1_vencrea),2)+strzero(year(tmp2->e1_vencrea),4)
			_cbaixa  :=strzero(day(tmp2->e1_baixa),2)+strzero(month(tmp2->e1_baixa),2)+strzero(year(tmp2->e1_baixa),4)
			
			_csituaca:="                    "
			if tmp2->e1_situaca =="0"
				_csituaca:="CARTEIRA            "
			elseif tmp2->e1_situaca =="1"
				_csituaca:="COBRANCA SIMPLES    "
			elseif tmp2->e1_situaca =="2"
				_csituaca:="COBRANCA DESCONTADA "
			elseif tmp2->e1_situaca =="3"
				_csituaca:="CHEQUE              "
			elseif tmp2->e1_situaca =="4"
				_csituaca:="COBRANCA VINCULADA  "
			elseif tmp2->e1_situaca =="5"
				_csituaca:="COBRANCA ADVOGADO   "
			elseif tmp2->e1_situaca =="6"
				_csituaca:="TITULO PROTESTADO   "
			elseif tmp2->e1_situaca =="7"
				_csituaca:="CHEQUE DESCONTADO   "
			endif
			
			sa6->(dbsetorder(1))
			sa6->(dbseek(_cfilsa6+tmp2->e1_portado))
			
			se3->(dbsetorder(3))
			se3->(dbseek(_cfilse3+tmp2->e1_vend1+tmp2->e1_cliente+tmp2->e1_loja+tmp2->e1_prefixo+tmp2->e1_num+tmp2->e1_parcela+tmp2->e1_tipo))
			_ce3data:=strzero(day(se3->e3_data),2)+strzero(month(se3->e3_data),2)+strzero(year(se3->e3_data),4)
			
			fwrite(_narqv7,tmp2->e1_cliente)
			fwrite(_narqv7,tmp2->e1_loja)
			fwrite(_narqv7,tmp2->e1_prefixo)
			if alltrim(tmp2->e1_prefixo)=='2'
				fwrite(_narqv7,substr(tmp2->e1_num,4,6))
			else
				fwrite(_narqv7,alltrim(tmp2->e1_num))
			endif
			//fwrite(_narqv7,tmp2->e1_num)
			fwrite(_narqv7,tmp2->e1_parcela)
			fwrite(_narqv7,_cemissao)
			fwrite(_narqv7,_cvencrea)
			fwrite(_narqv7,strzero(round(tmp2->e1_valor*100,0),15))
			fwrite(_narqv7,strzero(round(tmp2->e1_saldo*100,0),15))
			fwrite(_narqv7,strzero(round(tmp2->e1_porcjur*100,0),8))
			fwrite(_narqv7,strzero(round(tmp2->e1_comis1*100,0),5))
			fwrite(_narqv7,_cbaixa)
			fwrite(_narqv7,_csituaca)
			fwrite(_narqv7,sa6->a6_nome)
			fwrite(_narqv7,strzero(round(tmp2->e1_descont*100,0),15))
			fwrite(_narqv7,strzero(round(tmp2->e1_valliq*100,0),15))
			fwrite(_narqv7,strzero(round(tmp2->e1_juros*100,0),15))
			fwrite(_narqv7,strzero(round(se3->e3_comis*100,0),15))
			fwrite(_narqv7,_ce3data)
			fwrite(_narqv7,tmp2->e1_tipo)
			fwrite(_narqv7,chr(13)+chr(10))
			
			// COMIS
			fwrite(_narqv8,tmp2->e1_cliente)
			fwrite(_narqv8,tmp2->e1_loja)
			fwrite(_narqv8,tmp2->e1_prefixo)
			if alltrim(tmp2->e1_prefixo)=='2'
				fwrite(_narqv8,substr(tmp2->e1_num,4,6))
			else
				fwrite(_narqv8,alltrim(tmp2->e1_num))
			endif
			//fwrite(_narqv8,tmp2->e1_num)
			fwrite(_narqv8,tmp2->e1_parcela)
			fwrite(_narqv8,_cemissao)
			fwrite(_narqv8,_cvencrea)
			fwrite(_narqv8,strzero(round(tmp2->e1_valor*100,0),15))
			fwrite(_narqv8,strzero(round(tmp2->e1_saldo*100,0),15))
			fwrite(_narqv8,strzero(round(tmp2->e1_porcjur*100,0),8))
			fwrite(_narqv8,strzero(round(tmp2->e1_comis1*100,0),5))
			fwrite(_narqv8,_cbaixa)
			fwrite(_narqv8,_csituaca)
			fwrite(_narqv8,sa6->a6_nome)
			fwrite(_narqv8,strzero(round(tmp2->e1_descont*100,0),15))
			fwrite(_narqv8,strzero(round(tmp2->e1_valliq*100,0),15))
			fwrite(_narqv8,strzero(round(tmp2->e1_juros*100,0),15))
			fwrite(_narqv8,strzero(round(se3->e3_comis*100,0),15))
			fwrite(_narqv8,_ce3data)
			fwrite(_narqv8,tmp2->e1_tipo)
			fwrite(_narqv8,chr(13)+chr(10))
			
			tmp2->(dbskip())
		end
		tmp2->(dbclosearea())
		
		// NOTAS
		_cquery:=" SELECT"
		_cquery+=" F2_DOC,"
		_cquery+=" F2_SERIE,"
		_cquery+=" F2_CLIENTE,"
		_cquery+=" F2_LOJA,"
		_cquery+=" F2_VEND1,"
		_cquery+=" F2_EMISSAO,"
		_cquery+=" F2_VALFAT,"
//		_cquery+=" F2_VALBRUT,"
		_cquery+=" F2_VOLUME1,"
		_cquery+=" F2_TRANSP,"
		_cquery+=" F2_COND"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SA1")+" SA1,"
		_cquery+=  retsqlname("SF2")+" SF2,"
		
		_cquery+=" WHERE"
		_cquery+="     SA1.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF2.D_E_L_E_T_<>'*'"	

		_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
		_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"

		_cquery+=" AND F2_CLIENTE=A1_COD"
		_cquery+=" AND F2_LOJA=A1_LOJA"
		_cquery+=" AND A1_VEND='"+tmp1->a3_cod+"'"
		_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
		
		_cquery+=" ORDER BY"
		_cquery+=" F2_CLIENTE,F2_LOJA,F2_DOC"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","F2_EMISSAO","D",08,0)
		tcsetfield("TMP2","F2_VOLUME1","N",06,0)
		tcsetfield("TMP2","F2_VALFAT","N",14,2)
//		tcsetfield("TMP2","F2_VALBRUT","N",14,2)
		
		_aitem:={}
		_nreal:=0
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_cemissao:=strzero(day(tmp2->f2_emissao),2)+strzero(month(tmp2->f2_emissao),2)+strzero(year(tmp2->f2_emissao),4)
			
			sa4->(dbsetorder(1))
			sa4->(dbseek(_cfilsa4+tmp2->f2_transp))
			
			sd2->(dbsetorder(3))
			sd2->(dbseek(_cfilsd2+tmp2->f2_doc+tmp2->f2_serie))
			sc5->(dbsetorder(1))
			sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
			
			// NOTAS
			fwrite(_narqv9,tmp2->f2_cliente)
			fwrite(_narqv9,tmp2->f2_loja)
			if alltrim(tmp2->f2_serie)=='2'
				fwrite(_narqv9,substr(tmp2->f2_doc,4,6))
			else
				fwrite(_narqv9,alltrim(tmp2->f2_doc))
			endif			
			//fwrite(_narqv9,tmp2->f2_doc)
			fwrite(_narqv9,tmp2->f2_serie)
			fwrite(_narqv9,_cemissao)
			fwrite(_narqv9,strzero(round(tmp2->f2_valfat*100,0),14))
			fwrite(_narqv9,strzero(round(tmp2->f2_volume1*1,0),6))
			fwrite(_narqv9,sa4->a4_nome)
			fwrite(_narqv9,tmp2->f2_cond)
			fwrite(_narqv9,sc5->c5_tabela)
			fwrite(_narqv9,chr(13)+chr(10))
			
			// RELFAT
			fwrite(_narqv18,tmp2->f2_cliente)
			fwrite(_narqv18,tmp2->f2_loja)
			fwrite(_narqv18,strzero(round(tmp2->f2_valfat*100,0),16))
			fwrite(_narqv18,_cemissao)
			fwrite(_narqv18,chr(13)+chr(10))
			
			while ! sd2->(eof()) .and.;
				sd2->d2_filial==_cfilsd2 .and.;
				sd2->d2_doc==tmp2->f2_doc .and.;
				sd2->d2_serie==tmp2->f2_serie
				
				aadd(_aitem,{sd2->d2_doc,sd2->d2_serie,sd2->d2_cod,sd2->d2_prcven,sd2->d2_quant,sd2->d2_pedido,;
								 sd2->d2_cliente,sd2->d2_loja,sd2->d2_total,_cemissao})
				
				if month(sd2->d2_emissao)==month(date()) .and. year(sd2->d2_emissao)==year(date())
					_nreal+=sd2->d2_total
				endif
				
				sd2->(dbskip())
			end
			
			tmp2->(dbskip())
		end
		
		_aitens:=asort(_aitem,,,{|x,y| x[1]+x[2]+x[3]<y[1]+y[2]+y[3]})
		for _ni:=1 to len(_aitens)
			// ITNOTAS
			if alltrim(_aitens[_ni,2])=='2'
				fwrite(_narqv10,substr(_aitens[_ni,1],4,6)) // D2_DOC
			else 
				fwrite(_narqv10,alltrim(_aitens[_ni,1])) // D2_DOC				
			endif		
			//fwrite(_narqv10,_aitens[_ni,1]) // D2_DOC
			fwrite(_narqv10,_aitens[_ni,2]) // D2_SERIE
			fwrite(_narqv10,substr(_aitens[_ni,3],1,6)) // D2_COD
			fwrite(_narqv10,strzero(round(_aitens[_ni,4]*1000000,0),18)) // D2_PRCVEN
			fwrite(_narqv10,strzero(round(_aitens[_ni,5]*100,0),14)) // D2_QUANT
			fwrite(_narqv10,_aitens[_ni,6]) // D2_PEDIDO
			fwrite(_narqv10,chr(13)+chr(10))
		next
		
		_aitens2:=asort(_aitem,,,{|x,y| x[3]+x[7]+x[8]<y[3]+y[7]+y[8]})
		for _ni:=1 to len(_aitens2)
			// RELABC
			fwrite(_narqv19,substr(_aitens2[_ni,3],1,6)) // D2_COD
			fwrite(_narqv19,_aitens2[_ni,7]) // D2_CLIENTE
			fwrite(_narqv19,_aitens2[_ni,8]) // D2_LOJA
			fwrite(_narqv19,strzero(round(_aitens2[_ni,5]*100,0),16)) // D2_QUANT
			fwrite(_narqv19,strzero(round(_aitens2[_ni,9]*100,0),16)) // D2_TOTAL
			fwrite(_narqv19,_aitens2[_ni,10]) // D2_EMISSAO
			fwrite(_narqv19,chr(13)+chr(10))
		next
		
		// METMES

		// Verificar data de cadastro da meta (último dia do mês) em 09/05/2006
		_datameta:="  /  /  "
		_mesmeta:=0
		_anometa:=0
		_diameta:=0
		
		_mesmeta:= strzero(month(mv_par04),2)
		_anometa:= strzero(year(mv_par04),4) 

		if (_mesmeta="01") .or. (_mesmeta="03") .or. (_mesmeta="05") .or. (_mesmeta="07") .or.;
			(_mesmeta="08") .or. (_mesmeta="10") .or. (_mesmeta="12")
			_diameta:="31"
		elseif (_mesmeta == "02")
			_diameta:="28"
		else            
			_diameta:="30"		
		endif           
		
		_datameta:=ctod(_diameta+"/"+_mesmeta+"/"+_anometa)

		// Incluído até aqui em 09/05/2006

		_nprevisto:=0
		_cdescri  :=space(20)

		sct->(dbsetorder(2))
		sct->(dbseek(_cfilsct+dtos(_datameta)))
		
		while ! sct->(eof()) .and.;
			sct->ct_filial==_cfilsct .and.;
			sct->ct_data==_datameta

			if empty(sct->ct_produto) .and.;
				sct->ct_vend==tmp1->a3_cod
				
				_nprevisto+=sct->ct_valor
				_cdescri:=sct->ct_descri
			endif
			sct->(dbskip())
		end
		fwrite(_narqv14,substr(_cdescri,1,20))
		fwrite(_narqv14,strzero(round(_nprevisto*100,0),15))
		fwrite(_narqv14,strzero(round(_nreal*100,0),15))
		fwrite(_narqv14,chr(13)+chr(10))
		
		tmp2->(dbclosearea())
		
		// METANO
		_ddataini:=ctod("01/01/"+strzero(year(date()),4))
		_ddatafim:=ctod("31/12/"+strzero(year(date()),4))
		
		_cquery:=" SELECT"
		_cquery+=" F2_DOC,"
		_cquery+=" F2_SERIE,"
		_cquery+=" F2_CLIENTE,"
		_cquery+=" F2_LOJA,"
		_cquery+=" F2_VEND1,"
		_cquery+=" F2_EMISSAO,"
		_cquery+=" F2_VALFAT,"
		_cquery+=" F2_VOLUME1,"
		_cquery+=" F2_TRANSP,"
		_cquery+=" F2_COND,"
		_cquery+=" D2_PEDIDO,"
		_cquery+=" SUM(D2_TOTAL) D2_TOTAL"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SA1")+" SA1,"
		_cquery+=  retsqlname("SD2")+" SD2,"
		_cquery+=  retsqlname("SF2")+" SF2,"
		_cquery+=  retsqlname("SF4")+" SF4"
		
		_cquery+=" WHERE"
		_cquery+="     SA1.D_E_L_E_T_<>'*'"
		_cquery+=" AND SD2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
		_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
		_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND F2_CLIENTE=A1_COD"
		_cquery+=" AND F2_LOJA=A1_LOJA"
		_cquery+=" AND D2_DOC=F2_DOC"
		_cquery+=" AND D2_SERIE=F2_SERIE"
		_cquery+=" AND A1_VEND='"+tmp1->a3_cod+"'"  
		_cquery+=" AND D2_TES=F4_CODIGO"
		_cquery+=" AND F4_DUPLIC='S'"
		_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
		
		_cquery+=" GROUP BY"
		_cquery+=" F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_VEND1,F2_EMISSAO,F2_VALFAT,F2_VOLUME1,F2_TRANSP,F2_COND,D2_PEDIDO"
//	   _cquery+=" 1,2,3,4,5,6,7,8,9,10,11"
		
		_cquery+=" ORDER BY"
		_cquery+=" F2_EMISSAO,F2_DOC,F2_SERIE"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","F2_EMISSAO","D",08,0)
		tcsetfield("TMP2","F2_VOLUME1","N",06,0)
		tcsetfield("TMP2","F2_VALFAT","N",14,2)
		tcsetfield("TMP2","D2_TOTAL"  ,"N",14,2)
		
		_ameta   :=array(12)
		_ametalic:=array(12)
		_areal   :=array(12)
		_areallic:=array(12)
		_adescri :=array(12)
		for _ni:=1 to 12
			_ameta[_ni]   :=0
			_ametalic[_ni]:=0
			_areal[_ni]   :=0
			_areallic[_ni]:=0
			_adescri[_ni] :=space(30)
		next
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			
			sc5->(dbsetorder(1))
			sc5->(dbseek(_cfilsc5+tmp2->d2_pedido))
			
			_ni:=month(tmp2->f2_emissao)
			if sc5->c5_licitac=="N"
				_areal[_ni]+=tmp2->d2_total
			else
				_areallic[_ni]+=tmp2->d2_total
			endif
			
			tmp2->(dbskip())
		end
		
		sct->(dbsetorder(2))
		sct->(dbseek(_cfilsct+dtos(_ddataini),.t.))
		while ! sct->(eof()) .and.;
			sct->ct_filial==_cfilsct
			
			if empty(sct->ct_produto) .and.;
				sct->ct_vend==tmp1->a3_cod
				
				_ni:=month(sct->ct_data)
				if sct->ct_quant==1
					_ameta[_ni]+=sct->ct_valor
				else
					_ametalic[_ni]+=sct->ct_valor
				endif
				_adescri[_ni]:=sct->ct_descri
			endif
			sct->(dbskip())
		end
		for _ni:=1 to 12
			if ! empty(_adescri[_ni])
				fwrite(_narqv15,substr(_adescri[_ni],1,20))
				fwrite(_narqv15,strzero(round((_ameta[_ni]+_ametalic[_ni])*100,0),15))
				fwrite(_narqv15,strzero(round((_areal[_ni]+_areallic[_ni])*100,0),15))
				fwrite(_narqv15,chr(13)+chr(10))
			endif
		next
		tmp2->(dbclosearea())
		
		// PENDENCIA
		_cquery:=" SELECT"
		_cquery+=" C5_CLIENTE,"
		_cquery+=" C5_LOJACLI,"
		_cquery+=" C5_NUM,"
		_cquery+=" C5_EMISSAO,"
		_cquery+=" C6_PRODUTO,"
		_cquery+=" C6_QTDVEN,"
		_cquery+=" C6_QTDENT,"
		_cquery+=" (C6_QTDVEN-C6_QTDENT) QTDPEN,"
		_cquery+=" C6_PRCVEN"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SA1")+" SA1,"
		_cquery+=  retsqlname("SC5")+" SC5,"
		_cquery+=  retsqlname("SC6")+" SC6,"
		_cquery+=  retsqlname("SF4")+" SF4"
		
		_cquery+=" WHERE"
		_cquery+="     SA1.D_E_L_E_T_<>'*'"
		_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
		_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
		_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
		_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND C5_CLIENTE=A1_COD"
		_cquery+=" AND C5_LOJACLI=A1_LOJA"
		_cquery+=" AND C6_NUM=C5_NUM"
		_cquery+=" AND C6_TES=F4_CODIGO"
		_cquery+=" AND A1_VEND='"+tmp1->a3_cod+"'"
		_cquery+=" AND C5_TIPO='N'"
		_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
		_cquery+=" AND (C6_QTDVEN-C6_QTDENT)>0"
		_cquery+=" AND C6_BLQ<>'R '"
		_cquery+=" AND F4_DUPLIC='S'"
		_cquery+=" AND F4_ESTOQUE='S'"
		
		_cquery+=" ORDER BY"
		_cquery+=" C5_CLIENTE,C5_LOJACLI,C5_NUM,C6_PRODUTO"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","C5_EMISSAO","D",08,0)
		tcsetfield("TMP2","C6_QTDVEN" ,"N",06,0)
		tcsetfield("TMP2","QTDPEN"    ,"N",06,0)
		tcsetfield("TMP2","C6_QTDENT" ,"N",06,0)
		tcsetfield("TMP2","C6_PRCVEN" ,"N",18,6)
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_cemissao:=strzero(day(tmp2->c5_emissao),2)+strzero(month(tmp2->c5_emissao),2)+strzero(year(tmp2->c5_emissao),4)
			
			// PENDENCIA
			fwrite(_narqv11,tmp2->c5_cliente)
			fwrite(_narqv11,tmp2->c5_lojacli)
			fwrite(_narqv11,tmp2->c5_num)
			fwrite(_narqv11,_cemissao)
			
			// RELPED
			fwrite(_narqv16,tmp2->c5_cliente)
			fwrite(_narqv16,tmp2->c5_lojacli)
			
			_npend:=0
			_cnum:=tmp2->c5_num
			while ! tmp2->(eof()) .and.;
				tmp2->c5_num==_cnum
				
				_npend+=(tmp2->c6_qtdven-tmp2->c6_qtdent)*tmp2->c6_prcven
				
				// ITPENDCLI
				fwrite(_narqv12,tmp2->c5_cliente)
				fwrite(_narqv12,tmp2->c5_lojacli)
				fwrite(_narqv12,substr(tmp2->c6_produto,1,6))
				fwrite(_narqv12,tmp2->c5_num)
				fwrite(_narqv12,strzero(round(tmp2->c6_qtdven*100,0),14))
				fwrite(_narqv12,strzero(round(tmp2->c6_qtdent*100,0),14))
				fwrite(_narqv12,strzero(round(tmp2->c6_prcven*1000000,6),18))
				fwrite(_narqv12,_cemissao)
				fwrite(_narqv12,chr(13)+chr(10))
				
				// RELPEDITN
				fwrite(_narqv17,tmp2->c5_cliente)
				fwrite(_narqv17,tmp2->c5_lojacli)
				fwrite(_narqv17,substr(tmp2->c6_produto,1,6))
				fwrite(_narqv17,strzero(round(tmp2->qtdpen*100,0),16))
				fwrite(_narqv17,strzero(round(round(tmp2->qtdpen*tmp2->c6_prcven,2)*100,0),16))
				fwrite(_narqv17,tmp2->c5_num)
				fwrite(_narqv17,chr(13)+chr(10))
				
				tmp2->(dbskip())
			end
			
			fwrite(_narqv11,strzero(round(_npend*100,0),14))
			fwrite(_narqv11,chr(13)+chr(10))
			
			fwrite(_narqv16,strzero(round(_npend*100,0),12))
			fwrite(_narqv16,chr(13)+chr(10))
		end
		tmp2->(dbclosearea())
		
		// ITPEND
		_cquery:=" SELECT"
		_cquery+=" C5_CLIENTE,"
		_cquery+=" C5_LOJACLI,"
		_cquery+=" C5_NUM,"
		_cquery+=" C5_EMISSAO,"
		_cquery+=" C6_PRODUTO,"
		_cquery+=" C6_QTDVEN,"
		_cquery+=" C6_QTDENT,"
		_cquery+=" C6_PRCVEN"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SA1")+" SA1,"
		_cquery+=  retsqlname("SC5")+" SC5,"
		_cquery+=  retsqlname("SC6")+" SC6,"
		_cquery+=  retsqlname("SF4")+" SF4"
		
		_cquery+=" WHERE"
		_cquery+="     SA1.D_E_L_E_T_<>'*'"
		_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
		_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
		_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
		_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND C5_CLIENTE=A1_COD"
		_cquery+=" AND C5_LOJACLI=A1_LOJA"
		_cquery+=" AND C6_NUM=C5_NUM"
		_cquery+=" AND C6_TES=F4_CODIGO"
		_cquery+=" AND A1_VEND='"+tmp1->a3_cod+"'"
		_cquery+=" AND C5_TIPO='N'"
		_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
		_cquery+=" AND (C6_QTDVEN-C6_QTDENT)>0"
		_cquery+=" AND C6_BLQ<>'R '"
		_cquery+=" AND F4_DUPLIC='S'"
		_cquery+=" AND F4_ESTOQUE='S'"
		
		_cquery+=" ORDER BY"
		_cquery+=" C5_NUM,C5_CLIENTE,C5_LOJACLI,C6_PRODUTO"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","C5_EMISSAO","D",08,0)
		tcsetfield("TMP2","C6_QTDVEN" ,"N",06,0)
		tcsetfield("TMP2","C6_QTDENT" ,"N",06,0)
		tcsetfield("TMP2","C6_PRCVEN" ,"N",18,6)
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_cemissao:=strzero(day(tmp2->c5_emissao),2)+strzero(month(tmp2->c5_emissao),2)+strzero(year(tmp2->c5_emissao),4)
			
			fwrite(_narqv13,tmp2->c5_num)
			fwrite(_narqv13,substr(tmp2->c6_produto,1,6))
			fwrite(_narqv13,strzero(round(tmp2->c6_qtdven*100,0),14))
			fwrite(_narqv13,strzero(round(tmp2->c6_qtdent*100,0),14))
			fwrite(_narqv13,strzero(round(tmp2->c6_prcven*1000000,6),18))
			fwrite(_narqv13,_cemissao)
			fwrite(_narqv13,chr(13)+chr(10))
			
			tmp2->(dbskip())
		end
		tmp2->(dbclosearea())
		
	endif
	fclose(_narqv1)
	fclose(_narqv2)
	fclose(_narqv3)
	fclose(_narqv4)
	fclose(_narqv5)
	fclose(_narqv6)
	fclose(_narqv7)
	fclose(_narqv8)
	fclose(_narqv9)
	fclose(_narqv10)
	fclose(_narqv11)
	fclose(_narqv12)
	fclose(_narqv13)
	fclose(_narqv14)
	fclose(_narqv15)
	fclose(_narqv16)
	fclose(_narqv17)
	fclose(_narqv18)
	fclose(_narqv19)
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

incproc("Produtos")

_lcontinua:=.t.

// CADASTRO DE PRODUTOS ORDENADO PELO CODIGO
_carqg1:="\pocket\origem\"+"prodcod.txt"
_narqg1:=fcreate(_carqg1,0)
if _narqg1<0
	msginfo("Erro na criacao do arquivo "+_carqg1)
	_lcontinua:=.f.
endif

// CADASTRO DE PRODUTOS ORDENADO PELA DESCRICAO+CODIGO
_carqg2:="\pocket\origem\"+"proddesc.txt"
_narqg2:=fcreate(_carqg2,0)
if _narqg2<0
	msginfo("Erro na criacao do arquivo "+_carqg2)
	_lcontinua:=.f.
endif

// PRODLANC
_carqg6:="\pocket\origem\"+"prodlanc.txt"
_narqg6:=fcreate(_carqg6,0)
if _narqg6<0
	msginfo("Erro na criacao do arquivo "+_carqg6)
	_lcontinua:=.f.
endif

if _lcontinua
	_aprod:={}
	
	sb1->(dbsetorder(2))
	sb1->(dbseek(_cfilsb1+"PA"))
	while ! sb1->(eof()) .and.;
		sb1->b1_filial==_cfilsb1 .and.;
		sb1->b1_tipo=="PA"
		
		aadd(_aprod,{sb1->b1_cod,sb1->b1_desc,sb1->b1_apres,sb1->b1_cxpad,sb1->b1_anvisa,sb1->b1_codbar,;
		sb1->b1_posipi,sb1->b1_categ,sb1->b1_prvalid,sb1->b1_promoc,sb1->b1_descmax,sb1->b1_apreven,;
		sb1->b1_lanc,sb1->b1_similar})
		
		sb1->(dbskip())
	end
	
	// CADASTRO DE PRODUTOS ORDENADO PELO CODIGO
	_aprodcod:=asort(_aprod,,,{|x,y| x[1]<y[1]})
	for _ni:=1 to len(_aprodcod)
		if _aprodcod[_ni,08]=="N  "
			_ccateg:="N"
		else
			_ccateg:="P"
		endif
		fwrite(_narqg1,substr(_aprodcod[_ni,01],1,6)) // B1_COD
		fwrite(_narqg1,_aprodcod[_ni,02]) // B1_DESC
		fwrite(_narqg1,_aprodcod[_ni,03]) // B1_APRES
		fwrite(_narqg1,strzero(_aprodcod[_ni,04],3)) // B1_CXPAD
		fwrite(_narqg1,_aprodcod[_ni,05]) // B1_ANVISA
		fwrite(_narqg1,_aprodcod[_ni,06]) // B1_CODBAR
		fwrite(_narqg1,_aprodcod[_ni,07]) // B1_POSIPI
		fwrite(_narqg1,_ccateg) // B1_CATEG
		fwrite(_narqg1,strzero(_aprodcod[_ni,09],4)) // B1_PRVALID
		fwrite(_narqg1,_aprodcod[_ni,10]) // B1_PROMOC
		fwrite(_narqg1,strzero(round(_aprodcod[_ni,11]*100,0),5)) // B1_DESCMAX
		fwrite(_narqg1,_aprodcod[_ni,12]) // B1_APREVEN
		fwrite(_narqg1,chr(13)+chr(10))
	next
	
	// CADASTRO DE PRODUTOS ORDENADO PELA DESCRICAO+CODIGO
	_aproddesc:=asort(_aprod,,,{|x,y| x[2]+x[1]<y[2]+y[1]})
	for _ni:=1 to len(_aprodcod)
		fwrite(_narqg2,_aproddesc[_ni,02]) // B1_DESC
		fwrite(_narqg2,substr(_aproddesc[_ni,01],1,6)) // B1_COD
		fwrite(_narqg2,chr(13)+chr(10))
		
		if _aproddesc[_ni,13]=="S" // B1_LANC
			fwrite(_narqg6,substr(_aproddesc[_ni,01],1,6)) // B1_COD
			fwrite(_narqg6,_aproddesc[_ni,02]) // B1_DESC
			fwrite(_narqg6,_aproddesc[_ni,14]) // B1_SIMILAR
			
			_npreco17:=0
			_npreco18:=0
			_npreco19:=0
			_nfatorneg:=0
			_nfatorpos:=0
			
			da1->(dbsetorder(2))
			da1->(dbseek(_cfilda1+_aproddesc[_ni,01])) // B1_COD
			while ! da1->(eof()) .and.;
				da1->da1_filial==_cfilda1 .and.;
				da1->da1_codpro==_aproddesc[_ni,01]
				
				da0->(dbsetorder(1))
				da0->(dbseek(_cfilda0+da1->da1_codtab))
				
				if (empty(da0->da0_datate) .or. da0->da0_datate>=date()) .and.;
					! empty(da0->da0_status)
					
					if da0->da0_desc3==5.68
						_npreco17:=da1->da1_prcven
						_nfatorpos:=0.7234
						_nfatorneg:=0.7516
					elseif da0->da0_desc3==6.82
						_npreco18:=da1->da1_prcven
						_nfatorpos:=0.7234
						_nfatorneg:=0.7519
					elseif da0->da0_desc3==7.95
						_npreco19:=da1->da1_prcven
						_nfatorpos:=0.7234
						_nfatorneg:=0.7523
					endif
				endif
				da1->(dbskip())
			end
			fwrite(_narqg6,strzero(round(_npreco17*100,0),9))
			if _aprodcod[_ni,08]=="N  " // B1_CATEG
				fwrite(_narqg6,strzero(round((_npreco17/_nfatorneg)*100,0),9))
			else
				fwrite(_narqg6,strzero(round((_npreco17/_nfatorpos)*100,0),9))
			endif
			fwrite(_narqg6,strzero(round(_npreco18*100,0),9))
			if _aprodcod[_ni,08]=="N  " // B1_CATEG
				fwrite(_narqg6,strzero(round((_npreco18/_nfatorneg)*100,0),9))
			else
				fwrite(_narqg6,strzero(round((_npreco18/_nfatorpos)*100,0),9))
			endif
			fwrite(_narqg6,strzero(round(_npreco19*100,0),9))
			if _aprodcod[_ni,08]=="N  " // B1_CATEG
				fwrite(_narqg6,strzero(round((_npreco19/_nfatorneg)*100,0),9))
			else
				fwrite(_narqg6,strzero(round((_npreco19/_nfatorpos)*100,0),9))
			endif
			fwrite(_narqg6,chr(13)+chr(10))
		endif
	next
endif
fclose(_narqg1)
fclose(_narqg2)
fclose(_narqg6)

incproc("Condicoes de pagamento")

_lcontinua:=.t.

// CADASTRO DE CONDICOES DE PAGAMENTO ORDENADO PELO CODIGO
_carqg3:="\pocket\origem\"+"condpag.txt"
_narqg3:=fcreate(_carqg3,0)
if _narqg3<0
	msginfo("Erro na criacao do arquivo "+_carqg3)
	_lcontinua:=.f.
endif

if _lcontinua
	se4->(dbsetorder(1))
	se4->(dbseek(_cfilse4+"500",.t.))
	while ! se4->(eof()) .and.;
		se4->e4_filial==_cfilse4
		
		if se4->e4_ativa<>"N"
			fwrite(_narqg3,se4->e4_codigo)
			fwrite(_narqg3,se4->e4_descri)
			fwrite(_narqg3,chr(13)+chr(10))
		endif
		se4->(dbskip())
	end
endif
fclose(_narqg3)

incproc("Condicoes comerciais")

_lcontinua:=.t.

// CONDICOES COMERCIAIS
_carqg4:="\pocket\origem\"+"condcom.txt"
_narqg4:=fcreate(_carqg4,0)
if _narqg4<0
	msginfo("Erro na criacao do arquivo "+_carqg4)
	_lcontinua:=.f.
endif

// CONDICOES COMERCIAIS
_carqg5:="\pocket\origem\"+"promocao.txt"
_narqg5:=fcreate(_carqg5,0)
if _narqg5<0
	msginfo("Erro na criacao do arquivo "+_carqg5)
	_lcontinua:=.f.
endif

if _lcontinua
	_cobs1:=space(200)
	_cobs2:=space(200)
	_cobs3:=space(200)
	
	sz8->(dbsetorder(1))
	sz8->(dbseek(_cfilsz8))
	while ! sz8->(eof()) .and.;
		sz8->z8_filial==_cfilsz8
		
		if sz8->z8_valcond>=date()
			_cvalcond:=strzero(day(sz8->z8_valcond),2)+strzero(month(sz8->z8_valcond),2)+strzero(year(sz8->z8_valcond),4)
			if sz8->z8_tipo=="C"
				fwrite(_narqg4,"C")
				fwrite(_narqg4,strzero(round(sz8->z8_pedmin*100,0),15))
				fwrite(_narqg4,strzero(round(sz8->z8_dupmin*100,0),15))
				fwrite(_narqg4,strzero(round(sz8->z8_davista*100,0),5))
				fwrite(_narqg4,_cvalcond)
				fwrite(_narqg4,chr(13)+chr(10))
				
				_cobs1:=sz8->z8_obs1
				_cobs2:=sz8->z8_obs2
				_cobs3:=sz8->z8_obs3
			elseif sz8->z8_tipo=="P"
				fwrite(_narqg5,"C")
				fwrite(_narqg5,strzero(sz8->z8_prazo,3))
				fwrite(_narqg5,strzero(round(sz8->z8_davista*100,0),5))
				fwrite(_narqg5,_cvalcond)
				fwrite(_narqg5,chr(13)+chr(10))
				fwrite(_narqg5,"O")
				fwrite(_narqg5,sz8->z8_obs1)
				fwrite(_narqg5,chr(13)+chr(10))
				fwrite(_narqg5,"O")
				fwrite(_narqg5,sz8->z8_obs2)
				fwrite(_narqg5,chr(13)+chr(10))
				fwrite(_narqg5,"O")
				fwrite(_narqg5,sz8->z8_obs3)
				fwrite(_narqg5,chr(13)+chr(10))
			endif
		endif
		sz8->(dbskip())
	end
	sz9->(dbsetorder(1))
	sz9->(dbseek(_cfilsz9))
	while ! sz9->(eof()) .and.;
		sz9->z9_filial==_cfilsz9
		
		fwrite(_narqg4,"I")
		fwrite(_narqg4,strzero(round(sz9->z9_valini*100,0),15))
		fwrite(_narqg4,strzero(round(sz9->z9_valfim*100,0),15))
		fwrite(_narqg4,strzero(round(sz9->z9_desc1*100,0),5))
		fwrite(_narqg4,strzero(round(sz9->z9_desc2*100,0),5))
		fwrite(_narqg4,strzero(round(sz9->z9_desc3*100,0),5))
		fwrite(_narqg4,strzero(sz9->z9_prazo,3,0))
		fwrite(_narqg4,chr(13)+chr(10))
		
		sz9->(dbskip())
	end
	fwrite(_narqg4,"O")
	fwrite(_narqg4,_cobs1)
	fwrite(_narqg4,chr(13)+chr(10))
	fwrite(_narqg4,"O")
	fwrite(_narqg4,_cobs2)
	fwrite(_narqg4,chr(13)+chr(10))
	fwrite(_narqg4,"O")
	fwrite(_narqg4,_cobs3)
	fwrite(_narqg4,chr(13)+chr(10))
endif
fclose(_narqg4)
fclose(_narqg5)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do vendedor        ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{_cperg,"02","Ate o vendedor     ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{_cperg,"03","Da data            ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Ate a data         ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
