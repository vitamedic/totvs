/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ VIT003   ³ AUTOR ³ Heraildo C. de Freitas³ DATA ³20/12/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Validacao da Tabela de Precos na Digitacao de Pedidos de   ³±±
±±³          ³ Venda nao Permitindo Tabelas que nao Sejam Validas para    ³±±
±±³          ³ o Estado do Cliente.                                       ³±±
±±³          ³ Usado Tambem para Preencher os Dados do Vendedor 2 e 3,    ³±±
±±³          ³ e Comissao 2 e 3 com os Dados do Supervisor e Gerente.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
user function vit003()
if m->c5_tabela=="999" .or. m->c5_tipo<>"N"
	return .t.
endif	
_lok:=.t.    
_mal :=.t.
m->c5_licitac:="N"
sa1->(dbsetorder(1))
sa1->(dbseek(xfilial("SA1")+m->c5_cliente+alltrim(m->c5_lojacli)))

/*if !empty(m->c5_lojacli) .and.;
	sa1->a1_categ == "I "  
	
	_lok:=.f.
	msginfo("Cliente Inativo!")     
	return(_lok)
endif                         */
if !empty(m->c5_tabela)
	_cfilda0:=xfilial("DA0")
	da0->(dbsetorder(1))
	da0->(dbseek(_cfilda0+m->c5_tabela))
	if ! sa1->a1_est$da0->da0_estado
		_lok:=.f.
		msginfo("Tabela de precos invalida para este cliente! Estado invalido.")
	endif
	if da0->da0_status=="R" 
		_lok:=.f.
		msginfo("Tabela de precos invalida para inclusão de pedido!")
	endif            
//	if (da0->da0_status<>"Z" .and. da0->da0_status<>"L" .and. da0->da0_status<>"R").and. !empty(sa1->a1_codmun)
	if (!da0->da0_status$"Z").and. !empty(sa1->a1_codmun)
			_lok:=.f.
		msginfo("Tabela de precos invalida, cliente Zona Franca!")		
	endif            
	if (da0->da0_status$"Z") .and. empty(sa1->a1_codmun)
			_lok:=.f.
		msginfo("Tabela de precos invalida, cliente não tem codigo na Zona Franca!")		
	endif            		
	if (da0->da0_status$"L#R") .and. !empty(sa1->a1_codmun)
			_lok:=.f.
		msginfo("Tabela de precos invalida, cliente Zona Franca!")		
	endif            		
endif
if _lok
	if empty(sa1->a1_autoriz) .and. m->c5_tipo ="N"  //.and. _lok
		msginfo("Este cliente não possui codigo de autorização Anvisa,verifique com o Dpto.Cadastro!")
	endif  
	_cfilsa3:=xfilial("SA3")
	sa3->(dbsetorder(1))
	sa3->(dbseek(_cfilsa3+sa1->a1_vend))
	_nregsa3:=sa3->(recno())
	m->c5_vend2:=sa3->a3_super
	m->c5_vend3:=sa3->a3_geren
	sa3->(dbseek(_cfilsa3+m->c5_vend2))
	m->c5_comis2:=sa3->a3_comis
	sa3->(dbseek(_cfilsa3+m->c5_vend3))
	m->c5_comis3:=sa3->a3_comis
	sa3->(dbgoto(_nregsa3)) 
	if da0->da0_status=="L" .OR. da0->da0_status=="R" 
		m->c5_licitac:="S"       
		//m->c5_comis1:=5     	// Alterado em 02/04/2009 por solicitação da Diretoria Executiva. Alex
	endif
endif
return(_lok) 


user function vit003A()        
if m->c5_tabela=="999" .or. m->c5_tipo<>"N"
	return .t.
endif	
_lok:=.t.    
_mal :=.t.
m->c5_licitac:="N"
sa1->(dbsetorder(1))
sa1->(dbseek(xfilial("SA1")+m->c5_cliente+alltrim(m->c5_lojacli)))
//msgstop(m->c5_cliente+alltrim(m->c5_lojacli))
if !empty(m->c5_lojacli) .and.;
	sa1->a1_categ == "I "  
	_lok:=.f.
	msginfo("Cliente Inativo!")     
	return(_lok)
endif                                                       
if !empty(m->c5_tabela)
	_cfilda0:=xfilial("DA0")
	da0->(dbsetorder(1))
	da0->(dbseek(_cfilda0+m->c5_tabela))
	if ! sa1->a1_est$da0->da0_estado
		_lok:=.f.
		msginfo("Tabela de precos invalida para este cliente! Estado invalido.")
	endif
	if da0->da0_status=="R" 
		_lok:=.f.
		msginfo("Tabela de precos invalida para inclusão de pedido!")
	endif
	if da0->da0_status<>"Z"  .and. !empty(sa1->a1_codmun)
			_lok:=.f.
		msginfo("Tabela de precos invalida, cliente Zona Franca!")		
	endif            
	if da0->da0_status=="Z"  .and. empty(sa1->a1_codmun)
			_lok:=.f.
		msginfo("Tabela de precos invalida, cliente não tem codigo na Zona Franca!")		
	endif            		
	if (da0->da0_status$"L#R") .and. !empty(sa1->a1_codmun)
			_lok:=.f.
		msginfo("Tabela de precos invalida, cliente Zona Franca!")		
	endif            		
endif
if _lok
	if empty(sa1->a1_autoriz) .and. m->c5_tipo ="N"  //.and. _lok
		msginfo("Este cliente não possui codigo de autorização Anvisa,verifique com o Dpto.Cadastro!")
	endif  
	_cfilsa3:=xfilial("SA3")
	sa3->(dbsetorder(1))
	sa3->(dbseek(_cfilsa3+sa1->a1_vend))
	_nregsa3:=sa3->(recno())
	m->c5_vend2:=sa3->a3_super
	m->c5_vend3:=sa3->a3_geren
	sa3->(dbseek(_cfilsa3+m->c5_vend2))
	m->c5_comis2:=sa3->a3_comis
	sa3->(dbseek(_cfilsa3+m->c5_vend3))
	m->c5_comis3:=sa3->a3_comis
	sa3->(dbgoto(_nregsa3)) 
	if da0->da0_status=="L" .OR. da0->da0_status=="R" 
		m->c5_licitac:="S"       
		//m->c5_comis1:=5     	// Alterado em 02/04/2009 por solicitação da Diretoria Executiva. Alex
	endif
endif
return(_lok)
