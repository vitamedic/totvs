#include "rwmake.ch"    

User Function vit112d() 


	SetPrvt("COPCAO,NOPCE,NOPCG,ACPOENCHOICE,NUSADO,AHEADER")
	SetPrvt("ACOLS,CFILSD1,I,CTITULO,CALIASENCHOICE,CALIASGETD")
	SetPrvt("CLINOK,CTUDOK,CFIELDOK,")

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³ VIT112D  ³ Autor ³ 	Gardenia            ³ Data ³ 18/10/02  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao ³ Visualizacao das notas fiscais                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Especifico para Vitapan                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±³Versao    ³ 1.0                                                        ³±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/

	sf1->(dbsetorder(1)) 
	sf1->(dbseek(xfilial("SF1")+tmp->d1_doc+tmp->d1_serie+tmp->d1_fornece+tmp->d1_loja))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Opcoes de acesso para a Modelo 3                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	copcao:="VISUALIZAR"
	nopce :=2
	nopcg :=2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria aHeader e aCols da GetDados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	acpoenchoice:={}
	SX3->( dbSetOrder(1) )// X3_ARQUIVO+X3_ORDEM - ordeno a tabela pelo indice - g.sampaio 25/05/2018
	sx3->(dbseek("SF1"))
	while ! sx3->(eof()) .and. sx3->x3_arquivo=="SF1"
		if x3uso(sx3->x3_usado) .and. cnivel>=sx3->x3_nivel
			aadd(acpoenchoice,alltrim(sx3->x3_campo))
		endif
		sx3->(dbskip())
	end

	SX3->(dbGoTop())// volto o ponteiro pro registro da tabela - g.sampaio 25/05/2018

	nusado:=0
	aheader:={}
	SX3->( dbSetOrder(1) )// X3_ARQUIVO+X3_ORDEM - ordeno a tabela pelo indice - g.sampaio 25/05/2018
	sx3->(dbseek("SD1"))
	while ! sx3->(eof()) .and. sx3->x3_arquivo=="SD1"
		if x3uso(sx3->x3_usado) .and. cnivel>=sx3->x3_nivel
			if alltrim(SX3->X3_CAMPO) # "D1_ITEMMED" // desconsidero o campo D1_ITEMMED, campo virtual - g.sampaio 25/05/2018
				nusado:=nusado+1
				aadd(aheader,{trim(sx3->x3_titulo),sx3->x3_campo,sx3->x3_picture,;
				sx3->x3_tamanho,sx3->x3_decimal,sx3->x3_valid,;
				sx3->x3_usado,sx3->x3_tipo,sx3->x3_arquivo,sx3->x3_context})
			endif
		endif
		sx3->(dbskip())
	end

	acols:={}
	cfilsd1:=xfilial("SD1")
	sd1->(dbsetorder(1))
	sd1->(dbseek(cfilsd1+tmp->d1_doc+tmp->d1_serie+tmp->d1_fornece+tmp->d1_loja))
	while ! sd1->(eof()) .and. sd1->d1_filial==cfilsd1 .and.;
	sd1->d1_doc==sf1->f1_doc .and. sd1->d1_serie==sf1->f1_serie
		aadd(acols,array(nusado+1))
		for i:=1 to nusado
			if alltrim(SX3->X3_CAMPO) # "D1_ITEMMED" // desconsidero o campo D1_ITEMMED, campo virtual - g.sampaio 25/05/2018
				if alltrim(aheader[i,2])=="D1_DESCPRO"
					acols[len(acols),i]:=getadvfval("SB1","B1_DESC",xfilial("SB1")+sd1->d1_cod,1)
				else
					acols[len(acols),i]:=sd1->(fieldget(fieldpos(aheader[i,2])))
				endif
			endif
		next 
		acols[len(acols),nusado+1]:=.f.
		sd1->(dbskip())
	end

	if len(acols)>0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa a Modelo 3                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ctitulo        := "Nota fiscal"
		caliasenchoice := "SF1"
		caliasgetd     := "SD1"
		clinok         := "allwaystrue()"
		ctudok         := "allwaystrue()"
		cfieldok       := "allwaystrue()"
		modelo3(ctitulo,caliasenchoice,caliasgetd,acpoenchoice,clinok,ctudok,nopce,nopcg,cfieldok)
	endif
return
