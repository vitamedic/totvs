/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT267   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 25/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Confirmacao do Embarque de Notas Fiscais de Saida          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

user function vit267()
cperg:="PERGVIT267"
_pergsx1()
if pergunte(cperg,.t.)
	_cfilac8:=xfilial("AC8")
	_cfilsa1:=xfilial("SA1")
	_cfilsa3:=xfilial("SA3")
	_cfilsa4:=xfilial("SA4")
	_cfilsb1:=xfilial("SB1")
	_cfilsc5:=xfilial("SC5")
	_cfilsd2:=xfilial("SD2")
	_cfilse1:=xfilial("SE1")
	_cfilsf2:=xfilial("SF2")
	_cfilsu5:=xfilial("SU5")
	_cfilszb:=xfilial("SZB")
	
	_cquery:=" SELECT"
	_cquery+=" '    ' OK,"
	_cquery+=" A1_NOME,"
	_cquery+=" F2_CLIENTE,"
	_cquery+=" F2_LOJA,"
	_cquery+=" F2_DOC,"
	_cquery+=" F2_SERIE,"
	_cquery+=" F2_EMISSAO,"
	_cquery+=" F2_VOLUME1,"
	_cquery+=" F2_VEND1,"
	_cquery+=" ' ' C5_LICITAC"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SA1")+" SA1,"
	_cquery+=  retsqlname("SF2")+" SF2"
	
	_cquery+=" WHERE"
	_cquery+="     SA1.D_E_L_E_T_=' '"
	_cquery+=" AND SF2.D_E_L_E_T_=' '"
	_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
	_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
	_cquery+=" AND F2_CLIENTE=A1_COD"
	_cquery+=" AND F2_LOJA=A1_LOJA"
	_cquery+=" AND F2_TIPO='N'"
	_cquery+=" AND F2_TRANSP='"+mv_par01+"'"
	_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'"
	_cquery+=" AND F2_CONFEMB<>'S'"
	
	_cquery+=" ORDER BY"
	_cquery+=" 1,2,3,4,5"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","F2_EMISSAO","D",08,0)
	tcsetfield("TMP1","F2_VOLUME1","N",06,0)
	
	tmp1->(dbgotop())
	if ! tmp1->(eof())
		_carqtmp1:=criatrab(,.f.)
		
		copy to &_carqtmp1
		
		tmp1->(dbclosearea())
		
		dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)
		
		tmp1->(dbgotop())
		while ! tmp1->(eof())
			
			sd2->(dbsetorder(3))
			sd2->(dbseek(_cfilsd2+tmp1->f2_doc+tmp1->f2_serie))
			sc5->(dbsetorder(1))
			sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
			
			if sc5->c5_licitac=="S"
				tmp1->c5_licitac:="S"
			else
				tmp1->c5_licitac:="N"
			endif
			
			tmp1->(dbskip())
		end
		
		_cindtmp1:=criatrab(,.f.)
		_cchave  :="A1_NOME+F2_CLIENTE+F2_LOJA+C5_LICITAC+F2_DOC+F2_SERIE"
		tmp1->(indregua("TMP1",_cindtmp1,_cchave))
		
		sa4->(dbsetorder(1))
		sa4->(dbseek(_cfilsa4+mv_par01))
		
		ccadastro:="Confirmacao do embarque "+mv_par01+"-"+alltrim(sa4->a4_nome)
		
		arotina:={}
		aadd(arotina,{'Confirmar','U_VIT267A()',0,1})
		
		_acampos1:={}
		aadd(_acampos1,{"OK"        ,," "})
		aadd(_acampos1,{"A1_NOME"   ,,"Nome"})
		aadd(_acampos1,{"F2_CLIENTE",,"Codigo"})
		aadd(_acampos1,{"F2_LOJA"   ,,"Loja"})
		aadd(_acampos1,{"F2_DOC"    ,,"Nota"})
		aadd(_acampos1,{"F2_SERIE"  ,,"Serie"})
		aadd(_acampos1,{"F2_EMISSAO",,"Emissao"})
		aadd(_acampos1,{"F2_VOLUME1",,"Volumes","@E 999,999"})
		aadd(_acampos1,{"C5_LICITAC",,"Licitacao"})
		
		cmarca  :=getmark(,"TMP1","OK")
		lgrade  :=.f.
		if mv_par04==1
			linverte:=.t.
		else
			linverte:=.f.
		endif
		
		tmp1->(dbgotop())
		markbrowse("TMP1","OK",,_acampos1,linverte,cmarca)
		
		tmp1->(dbclosearea())
		
		ferase(_carqtmp1+getdbextension())
		ferase(_cindtmp1+ordbagext())
	else
		tmp1->(dbclosearea())
		msginfo("Nao foram encontradas notas fiscais com os parametros informados!")
	endif
endif
return

user function vit267a()
if msgyesno("Confirma o embarque das notas fiscais selecionadas para transportadora "+mv_par01+"-"+alltrim(sa4->a4_nome)+"?")
	
	processa({|| _confirma()})
	
	msginfo("Embarque concluido com sucesso!")
	
	tmp1->(dbgotop())
	sysrefresh()
endif
return()

static function _confirma()
procregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof())
	if tmp1->(marked("OK"))
		incproc("Confirmando o embarque da nota fiscal "+tmp1->f2_doc+"/"+tmp1->f2_serie)
		
		_cpara:=""
		
		sa1->(dbsetorder(1))
		sa1->(dbseek(_cfilsa1+tmp1->f2_cliente+tmp1->f2_loja))
		ac8->(dbsetorder(2))
		ac8->(dbseek(_cfilac8+"SA1"+sa1->a1_filial+sa1->a1_cod+sa1->a1_loja))
		while ! ac8->(eof()) .and.;
			ac8->ac8_filial==_cfilac8 .and.;
			ac8->ac8_entida=="SA1" .and.;
			ac8->ac8_filent==sa1->a1_filial .and.;
			substr(ac8->ac8_codent,1,8)==sa1->a1_cod+sa1->a1_loja
			
			_cemail:=""
			
			su5->(dbsetorder(1))
			su5->(dbseek(_cfilsu5+ac8->ac8_codcon))
			if ! empty(su5->u5_email)
				if tmp1->c5_licitac=="S" .and.;
					alltrim(su5->u5_tipoeml)=="L"
					
					_cemail:=su5->u5_email
				elseif alltrim(su5->u5_tipoeml)=="E" .and.;
					empty(_cemail)
					
					_cemail:=su5->u5_email
				endif
			endif
			
			if ! empty(_cemail)
				_cpara+=alltrim(_cemail)+";"
			endif
			
			ac8->(dbskip())
		end
		
		sa3->(dbsetorder(1))
//		sa3->(dbseek(_cfilsa3+tmp1->f2_vend1))  Estava incorreto quando a 1ª nota era bonificação (sem vendedor)
		sa3->(dbseek(_cfilsa3+sa1->a1_vend))
		
		if ! empty(sa3->a3_email) .and. sa3->a3_ativo <> 'N'  //nao mandar para email de representante inativo
			_cpara+=alltrim(sa3->a3_email)+";"
		endif
		
		szb->(dbsetorder(3))
		szb->(dbseek(_cfilszb+mv_par01+"S"+sa1->a1_est+sa1->a1_local))
		_npzentre:=szb->zb_pzentre
		
		_ccliente:=tmp1->f2_cliente
		_cloja   :=tmp1->f2_loja
		_clicitac:=tmp1->c5_licitac
		
		_lproc:=.f.
		_afaturas:={}
		while ! tmp1->(eof()) .and.;
			tmp1->f2_cliente==_ccliente .and.;
			tmp1->f2_loja==_cloja .and.;
			tmp1->c5_licitac==_clicitac
			
			if tmp1->(marked("OK"))
				
				if ! empty(_cpara) .and.;
					! _lproc
					
					_lproc:=.t.
					
					oProcess := TWFProcess():New( "000002", "CONFIRMACAO DE EMBARQUE" )
					
					oProcess:NewTask( "000001", "\workflow\confirmacao de embarque2.htm" )
					
					oProcess:cSubject := "Vitamedic - Confirmacao de embarque"
					
					oProcess:bReturn := ""
					
					oProcess:bTimeOut := {}
					
					oHTML := oProcess:oHTML
					
					oHTML:ValByName("DIA"    ,strzero(day(date()),2))
					oHTML:ValByName("MES"    ,mesextenso(date()))
					oHTML:ValByName("ANO"    ,strzero(year(date()),4))
					oHTML:ValByName("CLIENTE",alltrim(sa1->a1_nome))
					if _npzentre==0
						oHTML:ValByName("ENTREGA"," ")
					elseif _npzentre==1
						oHTML:ValByName("ENTREGA","A previsão de entrega para estes produtos é de "+alltrim(str(_npzentre,3))+" dia útil da coleta.")
					else
						oHTML:ValByName("ENTREGA","A previsão de entrega para estes produtos é de "+alltrim(str(_npzentre,3))+" dias úteis da coleta.")
					endif
				endif
					
				sf2->(dbsetorder(1))
				sf2->(dbseek(_cfilsf2+tmp1->f2_doc+tmp1->f2_serie))
				
				sf2->(reclock("SF2",.f.))
//				sf2->f2_dataemb:=date()
//				sf2->f2_horaemb:=time()
				sf2->f2_confemb:="S"
				sf2->(msunlock())
				
				aadd((oHtml:valByName("TB.NF")),'Nº NF: '+sf2->f2_doc+"/"+sf2->f2_serie)
				
				aadd((oHtml:valByName("TB.NF")),'DATA: '+dtoc(sf2->f2_emissao))
				
				aadd((oHtml:valByName("TB.NF")),'TRANSPORTADORA: '+alltrim(sa4->a4_nome)+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; VOLUMES: '+alltrim(transform(sf2->f2_volume1,"@E 999,999")))
				
				_ctabela:='<table width="600" border="1" cellpadding="0" cellspacing="0" bordercolor="#111111" style="border-collapse: collapse">'
				
				_ctabela+='<tr>'
				_ctabela+='<td width="10%" align="center"><font size="2" face="Arial, Helvetica, sans-serif">PRODUTO</font></td>'
				_ctabela+='<td width="36%" align="center"><font size="2" face="Arial, Helvetica, sans-serif">DESCRIÇÃO</font></td>'
				_ctabela+='<td width="6%" align="center"><font size="2" face="Arial, Helvetica, sans-serif">UM</font></td>'
				_ctabela+='<td width="10%" align="center"><font size="2" face="Arial, Helvetica, sans-serif">QTDE.</font></td>'
				_ctabela+='<td width="15%" align="center"><font size="2" face="Arial, Helvetica, sans-serif">V. UNITÁRIO</font></td>'
				_ctabela+='<td width="15%" align="center"><font size="2" face="Arial, Helvetica, sans-serif">V. TOTAL</font></td>'
				_ctabela+='<td width="8%" align="center"><font size="2" face="Arial, Helvetica, sans-serif">LOTE</font></td>'
				_ctabela+='</tr>'
				
				_ntotal:=0
				
				sd2->(dbsetorder(3))
				sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
				
				while ! sd2->(eof()) .and.;
					sd2->d2_filial==_cfilsd2 .and.;
					sd2->d2_doc==sf2->f2_doc .and.;
					sd2->d2_serie==sf2->f2_serie
					
					sb1->(dbsetorder(1))
					sb1->(dbseek(_cfilsb1+sd2->d2_cod))
					
				
					_ctabela+='<tr>'
					_ctabela+='<td width="10%" align="left"><font size="1" face="Arial, Helvetica, sans-serif">&nbsp; '+alltrim(sd2->d2_cod)+'</font></td>'
					_ctabela+='<td width="36%" align="left"><font size="1" face="Arial, Helvetica, sans-serif">&nbsp; '+alltrim(sb1->b1_desc)+'</font></td>'
					_ctabela+='<td width="6%" align="center"><font size="1" face="Arial, Helvetica, sans-serif">'+sd2->d2_um+'</font></td>'
					_ctabela+='<td width="10%" align="right"><font size="1" face="Arial, Helvetica, sans-serif">'+alltrim(transform(sd2->d2_quant,"@E 99,999,999.99"))+'</font></td>'
					_ctabela+='<td width="15%" align="right"><font size="1" face="Arial, Helvetica, sans-serif">'+alltrim(transform(sd2->d2_prcven,"@E 99,999,999,999.999999"))+'</font></td>'
					_ctabela+='<td width="15%" align="right"><font size="1" face="Arial, Helvetica, sans-serif">'+alltrim(transform(sd2->d2_total,"@E 99,999,999,999.99"))+'</font></td>'
					_ctabela+='<td width="8%" align="left"><font size="1" face="Arial, Helvetica, sans-serif">&nbsp; '+alltrim(sd2->d2_lotectl)+'</font></td>'
					_ctabela+='</tr>'
					
					_ntotal+=sd2->d2_total
					
					sd2->(dbskip())
				end
				_ctabela+='</table>'
				
				_ctabela+='<table width="600" border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" style="border-collapse: collapse">'
				_ctabela+='<tr>'
				_ctabela+='<td width="10%" align="left"><font size="1" face="Arial, Helvetica, sans-serif"><b>&nbsp;</b></font></td>'
				_ctabela+='<td width="36%" align="left"><font size="1" face="Arial, Helvetica, sans-serif"><b>&nbsp;</b></font></td>'
				_ctabela+='<td width="6%" align="left"><font size="1" face="Arial, Helvetica, sans-serif"><b>&nbsp;</b></font></td>'
				_ctabela+='<td width="10%" align="left"><font size="1" face="Arial, Helvetica, sans-serif"><b>&nbsp;</b></font></td>'
				_ctabela+='<td width="15%" align="right"><font size="1" face="Arial, Helvetica, sans-serif"><b>TOTAL NF</b></font></td>'
				_ctabela+='<td width="15%" align="right"><font size="1" face="Arial, Helvetica, sans-serif"><b>'+alltrim(transform(_ntotal,"@E 99,999,999,999.99"))+'</b></font></td>'
				_ctabela+='<td width="8%" align="left"><font size="1" face="Arial, Helvetica, sans-serif"><b>&nbsp;</b></font></td>'
				_ctabela+='</tr>'
				_ctabela+='</table>'
				
				_ctabela+='<br>'
				
				aadd((oHtml:valByName("TB.NF")),_ctabela)
				
				se1->(dbsetorder(1))
				se1->(dbseek(_cfilse1+sf2->f2_prefixo+sf2->f2_dupl))
				while ! se1->(eof()) .and.;
					se1->e1_filial==_cfilse1 .and.;
					se1->e1_prefixo==sf2->f2_prefixo .and.;
					se1->e1_num==sf2->f2_dupl
					
					if se1->e1_tipo=="NF "
						if empty(se1->e1_fatura)
							aadd(_afaturas,{se1->e1_prefixo,se1->e1_num,se1->e1_parcela,se1->e1_tipo,se1->e1_vencto,se1->e1_valor})
						else
							_cfatpref:=se1->e1_fatpref
							_cfatura :=se1->e1_fatura
							
							_ni:=ascan(_afaturas,{|x| x[1]==_cfatpref .and. x[2]==_cfatura})
							if _ni==0
								_nregse1:=se1->(recno())
								
								se1->(dbseek(_cfilse1+_cfatpref+_cfatura))
								while ! se1->(eof()) .and.;
									se1->e1_filial==_cfilse1 .and.;
									se1->e1_prefixo==_cfatpref .and.;
									se1->e1_num==_cfatura
									
									if se1->e1_tipo=="FT "
										aadd(_afaturas,{se1->e1_prefixo,se1->e1_num,se1->e1_parcela,se1->e1_tipo,se1->e1_vencto,se1->e1_valor})
									endif
									
									se1->(dbskip())
								end
								
								se1->(dbgoto(_nregse1))
							endif
						endif
					endif
					
					se1->(dbskip())
				end
				tmp1->(dbdelete())
			endif
			tmp1->(dbskip())
		end
		
		if _lproc	
			for _ni:=1 to len(_afaturas)
				aadd((oHtml:valByName("FT.FATURA"))    ,_afaturas[_ni,1]+" "+_afaturas[_ni,2]+" "+_afaturas[_ni,3])
				aadd((oHtml:valByName("FT.VENCIMENTO")),dtoc(_afaturas[_ni,5]))
				aadd((oHtml:valByName("FT.VALOR"))     ,alltrim(transform(_afaturas[_ni,6],"@E 99,999,999,999.99")))
			next
			_crodape:='<table width="600" border="0">'
			_crodape+='<tr><td>
			_crodape+='<font size="2" face="Arial, Helvetica, sans-serif"><p align="justify">Caso ocorra algum atraso, avaria ou para maiores informa&ccedil;&otilde;es '
			_crodape+='solicitamos entrar em contato com nosso setor de atendimento comercial atrav&eacute;s do e-mail <a href="mailto:sac@vitamedic.com.br">sac@vitamedic.com.br</a> '
			_crodape+='ou do telefone 0800 62 2929.</p><br><br>'
			_crodape+='Atenciosamente,<br><br>'
//			_crodape+='Depto. Comercial'+_cpara+'<br>'
			_crodape+='Depto. Comercial<br>'
			_crodape+='<a href="mailto:sac@vitamedic.com.br">sac@vitamedic.com.br</a><br>'
			_crodape+='0800 62 2929<br><br><br><br>'
			_crodape+='Destinatários: '+_cpara+'</font></td></tr></table>'
			
			oHTML:ValByName("RODAPE",_crodape)
			
			oProcess:cto := _cpara // PARA
			oProcess:ccc := "report_comercial@vitamedic.ind.br" // COM COPIA
			oProcess:cbcc:= "report_ti@vitamedic.ind.br" // "analista@vitamedic.ind.br" // COM COPIA OCULTA
							
			oProcess:UserSiga := "__cuserid"
			
			RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'100001')
			
			oProcess:Start()
			wfsendmail()
		endif
	else
		tmp1->(dbskip())
	endif
end
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Transportadora     ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"02","Da emissao         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Ate a emissao      ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Trazer marcado     ?","mv_ch4","N",01,0,0,"C",space(60),"mv_par04"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return
