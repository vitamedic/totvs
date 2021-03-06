#include "rwmake.ch"  
#INCLUDE "TOPCONN.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � VIT016   矨utor � Gardenia Ilany        矰ata � 25/01/02   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ordem de Producao                                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitamedic                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矨lteracoes� 28/10/05 - Alex J鷑io - Inclus鉶 da Descricao Cientifica,  潮�
北�          � n� de Rev e Data da Revis鉶. Corre珲es no Layout.          潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

user function Vit016(cOp,cItem)
titulo  := "ORDEM DE PRODUCAO"
cdesc1  := "Este programa ira emitir a OP"
cdesc2  := ""
cdesc3  := ""
tamanho := "P"
limite  := 132
cstring :="SC2"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT016"
aLinha  :={}
nlastkey:=0
lcontinua:=.t.

mpag := 0
nqtdparc:=0
cumemp:='  '
cum := '  '
cperg:="PERGVIT016"

_pergsx1()
pergunte(cperg,.f.)
wnrel:="VIT016"+Alltrim(cusername)

if cOp == Nil
	wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)
Else
   mv_par01 := cOp
   mv_par02 := cOp
   mv_par03 := cItem
	wnrel:=setprint(cstring,wnrel,     ,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)
EndIf

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

ntipo := if(areturn[4]==1,15,18)

if nlastkey==27
   set filter to
   return
endif

rptstatus({|| rptdetail()})
return

//*******************************************
//Funcao RptDetail - Impressao do Relatorio
//*******************************************
Static  Function RptDetail()
cbcont := 0
m_pag  := 1
li     := 132
cbtxt  := space(10)

cfilsb1:=xfilial("SB1")
cfilsc2:=xfilial("SC2")
cfilsd4:=xfilial("SD4")
cfilsg1:=xfilial("SG1")
cfilsdc:=xfilial("SDC")
_cfilqdh:=xfilial("QDH")
sb1->(dbsetorder(1))
sd4->(dbsetorder(2))
sdc->(dbsetorder(2))
sc2->(dbsetorder(1))
sg1->(dbsetorder(1))
qdh->(dbsetorder(1))

sc2->(dbseek(cfilsc2+mv_par01,.t.))
while c2_filial ==cfilsc2 .and. c2_num >=mv_par01 .and. c2_num <=mv_par02 .and. !eof()
	if sc2->c2_item <> mv_par03
    	sc2->(dbskip())
    	loop
   endif	
   sb1->(dbseek(cfilsb1+sc2->c2_produto))
	cproduto:=sc2->c2_produto
	cdesc:=sb1->b1_desc
   _cdesccien:= sb1->b1_desccie
	nprvalid:=sb1->b1_prvalid
	cum:=sb1->b1_um
	capres:= sb1->b1_apres
	nle:=sb1->b1_le
	nqtdlote:=sc2->c2_quant
	cop:=sc2->c2_num+mv_par03
   qdh->(dbseek(_cfilqdh+"OP-"+substr(sb1->b1_cod,1,13)))
   _ddata:= ctod(space(08))
   While (qdh->qdh_filial == _cfilqdh .and. qdh->qdh_docto == "OP-"+substr(sb1->b1_cod,1,13) .and. !qdh->(EOF()))
       if  qdh->qdh_obsol <> "S" .and. !Empty(qdh->qdh_dtvig)
		   _ddata := qdh->qdh_dtvig
		   _crev  := qdh->qdh_rv
      endif
      qdh->(DBSkip())

	EndDo

	impemp() // imprime materias primas
	sc2->(reclock("SC2",.f.))
	sc2->(msunlock())
	sc2->(dbskip())
end

Set Device To Screen

If ( aReturn[5]==1 )
	Set Print to
	dbCommitall()
	ourspool(wnrel)
EndIf

MS_Flush()
Return

Static Function impemp()
//   Primeira pagina da OP
sd4->(dbseek(cfilsd4+cop,.t.))
mfirst := .t.
cab016()
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
if mv_par03 <>"02" .and. mv_par03 <> "03"
	@ prow()+1,000 PSAY "|                                   REQUISICAO DE MATERIA PRIMA                               |"
else
	@ prow()+1,000 PSAY "|                                   REQUISICAO DE INSUMOS                                     |"
endif	
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "| Codigo| Materia Prima                            |Endereco   |   Peso Balanca|UM|Lote       |"
@ prow()+1,000 PSAY "|-------|------------------------------------------|-----------|---------------|--|-----------|"
while ! sd4->(eof()) .and. sd4->d4_filial==cfilsd4 .and.;
	left(sd4->d4_op,8)==cop
	if sd4->d4_local <> "02" .and. sd4->d4_local <> "01"  .and. sd4->d4_local <> "91" 
    	sd4->(dbskip())
    	loop
   endif	
  	sb1->(dbseek(cfilsb1+sd4->d4_cod))
  	sdc->(dbseek(cfilsdc+sd4->d4_cod+sd4->d4_local+sd4->d4_op+sd4->d4_trt+sd4->d4_lotectl))
	nqtdparc:=nqtdparc+sd4->d4_qtdeori
	@ prow()+1,000 PSAY "|"
	@ prow(),001 PSAY left(sd4->d4_cod,6)
	@ prow(),008 PSAY "|"
	sb1->(dbseek(cfilsb1+sd4->d4_cod))
	cumemp:=sb1->b1_um
	@ prow(),010 PSAY sb1->b1_desc
	@ prow(),051 PSAY "|"
	@ prow(),052 PSAY substr(sdc->dc_localiz,1,11)
	@ prow(),063 PSAY "|"
	@ prow(),064 PSAY sd4->d4_qtdeori picture "@E 9999,999.999999"
	@ prow(),079 PSAY "|"
	@ prow(),080 PSAY cumemp
	@ prow(),082 PSAY "|"
	@ prow(),083 PSAY sd4->d4_lotectl
	@ prow(),094 PSAY "|"
	if prow()> 49  .and.! sd4->(eof())
	  cab016()
	endif  
  	sd4->(dbskip())
end  
@ prow()+1,00 PSAY "|---------------------------------------------------------------------------------------------|"
@ prow()+1,00 PSAY "|                                                          |                                  |"
@ prow()+1,00 PSAY "|Remetido por:__________________________   Data:___/___/___|                                  |"
@ prow()+1,00 PSAY "|                                                          |                                  |"
@ prow()+1,00 PSAY "|Separado por:__________________________   Data:___/___/___|                                  |"
@ prow()+1,00 PSAY "|                                                          |                                  |"
@ prow()+1,00 PSAY "|Pesado por  :__________________________   Data:___/___/___|                                  |"
@ prow()+1,00 PSAY "|                                                          |__________________________________|"
@ prow()+1,00 PSAY "|Material recebido na producao                             |DCQ:                              |"
@ prow()+1,00 PSAY "|                                                          |                                  |"
@ prow()+1,00 PSAY "|Conferido por:_________________________   Data:___/___/___|__________________________________|"
@ prow()+1,00 PSAY "|                                                                                             |"
@ prow()+1,00 PSAY "|Observacoes:_________________________________________________________________________________|"
@ prow()+1,00 PSAY "|                                                                                             |"
@ prow()+1,00 PSAY "|_____________________________________________________________________________________________|"
@ prow()+1,00 PSAY "|                                                                                             |"
@ prow()+1,00 PSAY "|_____________________________________________________________________________________________|"

// Segunda pagina da OP
cab016()
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
if mv_par03 <>"02"  .and. mv_par03 <> "03"
	@ prow()+1,000 PSAY "|                                   CONFERENCIA DE PESAGEM DE MATERIA PRIMA                   |"
else
	@ prow()+1,000 PSAY "|                                   CONFERENCIA DE PESAGEM DE INSUMOS                         |"
endif	
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "| Codigo| Materia Prima                            |Endereco   |Peso Balanca    |UM|Lote      |"
@ prow()+1,000 PSAY "|-------|------------------------------------------|-----------|----------------|--|----------|"

sd4->(dbseek(cfilsd4+cop,.t.))
while ! sd4->(eof()) .and. sd4->d4_filial==cfilsd4 .and.;
	left(sd4->d4_op,8)==cop
	if sd4->d4_local <> "02" .and. sd4->d4_local <> "01" .and. sd4->d4_local <> "91" 
    	sd4->(dbskip())
    	loop
   endif	
  	sb1->(dbseek(cfilsb1+sd4->d4_cod))
  	sdc->(dbseek(cfilsdc+sd4->d4_cod+sd4->d4_local+sd4->d4_op+sd4->d4_trt+sd4->d4_lotectl))
	nqtdparc:=nqtdparc+sd4->d4_qtdeori
	@ prow()+1,000 PSAY "|"
	@ prow(),001 PSAY left(sd4->d4_cod,6)
	@ prow(),008 PSAY "|"
	sb1->(dbseek(cfilsb1+sd4->d4_cod))
	cumemp:=sb1->b1_um
	@ prow(),010 PSAY sb1->b1_desc
	@ prow(),051 PSAY "|"
	@ prow(),052 PSAY substr(sdc->dc_localiz,1,11)
	@ prow(),063 PSAY "|"
	@ prow(),080 PSAY "|"
	@ prow(),081 PSAY cumemp
	@ prow(),083 PSAY "|"
	@ prow(),084 PSAY sd4->d4_lotectl
	@ prow(),094 PSAY "|"
	if prow()> 52  .and.! sd4->(eof())
	  cab016()
	endif  
   @ prow()+1,000 PSAY "|-------|------------------------------------------|-----------|----------------|-------------|"
	sd4->(dbskip())
end  
//if mimprime                                                                                      	
	@ prow()+1,00 PSAY "|---------------------------------------------------------------------------------------------|"
	@ prow()+1,00 PSAY "|MATERIAL RECEBIDO NA PRODUCAO                                                                |"
	@ prow()+1,00 PSAY "|                                                                                             |"
	@ prow()+1,00 PSAY "|---------------------------------------------------------------------------------------------|"
	@ prow()+1,00 PSAY "|Conferido por:__________________________  Data:___/___/___                                   |"
	@ prow()+1,00 PSAY "|                                                                                             |"
	@ prow()+1,00 PSAY "|Revisado  por:__________________________  Data:___/___/___                                   |"
	@ prow()+1,00 PSAY "|               Encarregado Setor                                                             |"                      
	@ prow()+1,00 PSAY "|Observacoes:_________________________________________________________________________________|"
	@ prow()+1,00 PSAY "|                                                                                             |"
	@ prow()+1,00 PSAY "|_____________________________________________________________________________________________|"
	@ prow()+1,00 PSAY "|                                                                                             |"
	@ prow()+1,00 PSAY "|_____________________________________________________________________________________________|"
//endif

// Terceira pagina da OP - primeira parte
sd4->(dbseek(cfilsd4+cop,.t.))
cab016()
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "|           REQUISICAO DE MATERIAL DE EMBALAGEM                                                                                         |"
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "| Codigo| Material                                |Endereco  |         Requerido|UM|Lote      | Qtde    |Separador|Conferente  |Data    |"
@ prow()+1,000 PSAY "|       |                                         |          |                  |  |          | Separada|         |            |        |"
@ prow()+1,000 PSAY "|-------|-----------------------------------------|----------|------------------|--|----------|---------|---------|------------|--------|"
while ! sd4->(eof()) .and. sd4->d4_filial==cfilsd4 .and.;
	left(sd4->d4_op,8)==cop
	if sd4->d4_local == "02" .or. sd4->d4_local == "01" .or. sd4->d4_local == "91" .or. sd4->d4_local=="80"  
    	sd4->(dbskip())
    	loop
   endif	

   
	sb1->(dbseek(cfilsb1+sd4->d4_cod))
  	sdc->(dbseek(cfilsdc+sd4->d4_cod+sd4->d4_local+sd4->d4_op+sd4->d4_trt+sd4->d4_lotectl))
	nqtdparc:=nqtdparc+sd4->d4_qtdeori
	cumemp:=sb1->b1_um
	@ prow()+1, 000 PSAY "|"
	@ prow(),001 PSAY left(sd4->d4_cod,6)
	@ prow(),008 PSAY "|"            
	@ prow(),010 PSAY sb1->b1_desc
	@ prow(),050 PSAY "|"
	@ prow(),051 PSAY substr(sdc->dc_localiz,1,10)
	@ prow(),061 PSAY "|"
	@ prow(),062 PSAY sd4->d4_qtdeori picture "@E 999,999,999.999999"
	@ prow(),080 PSAY "|"
	@ prow(),081 PSAY cumemp
	@ prow(),083 PSAY "|"
	@ prow(),084 PSAY sd4->d4_lotectl
   @ prow(),094 PSAY "|         |         |            |        |"                        
   @ prow()+1,000 PSAY "|-------|-----------------------------------------|----------|------------------|--|----------|---------|---------|------------|--------|"
	if prow()> 60 .and.! sd4->(eof())
	  cab016()
	endif  
  	sd4->(dbskip())
end

// Terceira pagina da OP - segunda parte
sd4->(dbseek(cfilsd4+cop,.t.))
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "|           REQUISICAO DE MATERIAIS ADICIONAIS                                                                                          |"
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "| Codigo| Material                                |Endereco  |Qtde.    |Requerido|UM|Lote      | Qtde    |Separador|Conferente |Data    |"
@ prow()+1,000 PSAY "|       |                                         |          |Requerida|Por:     |  |          | Separada|         |           |        |"
@ prow()+1,000 PSAY "|-------|-----------------------------------------|----------|---------|---------|--|----------|---------|---------|-----------|--------|"
while ! sd4->(eof()) .and. sd4->d4_filial==cfilsd4 .and.;
	left(sd4->d4_op,8)==cop
	if sd4->d4_local == "02" .or. sd4->d4_local == "01" .or. sd4->d4_local == "91" .or. sd4->d4_local=="80"  
    	sd4->(dbskip())
    	loop
   endif	
	sb1->(dbseek(cfilsb1+sd4->d4_cod))
	nqtdparc:=nqtdparc+sd4->d4_qtdeori
	cumemp:=sb1->b1_um
	@ prow()+1, 000 PSAY "|"
	@ prow(),001 PSAY left(sd4->d4_cod,6)
	@ prow(),008 PSAY "|"            
	@ prow(),010 PSAY sb1->b1_desc
	@ prow(),050 PSAY "|          |         |"
//	@ prow(),062 PSAY sd4->d4_qtdeori picture "@E 999,999,999.999999"
	@ prow(),081 PSAY "|"
	@ prow(),082 PSAY cumemp
	@ prow(),084 PSAY "|"
//	@ prow(),84 PSAY sd4->d4_lotectl
   @ prow(),95 PSAY "|         |         |           |        |"                       
   @ prow()+1,000 PSAY "|-------|-----------------------------------------|----------|---------|---------|--|----------|---------|---------|-----------|--------|"
	if prow()> 52  .and.! sd4->(eof())
	  cab016()
	endif  
	sd4->(dbskip())
end 


// Terceira pagina da OP - terceira parte
sd4->(dbseek(cfilsd4+cop,.t.))
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "|           DEVOLUCAO  DE MATERIAIS ADICIONAIS                                                                                          |"
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "| Codigo| Material                                |Endereco  |         Quantidade|UM|Lote      |Devolvido          |Conferente |Data    |"
@ prow()+1,000 PSAY "|       |                                         |          |          Devolvida|  |          |Por:               |           |        |"
@ prow()+1,000 PSAY "|-------------------------------------------------|----------|-------------------|--|----------|-------------------|-----------|--------|"
while ! sd4->(eof()) .and. sd4->d4_filial==cfilsd4 .and.;
	left(sd4->d4_op,8)==cop
	if sd4->d4_local == "02" .or. sd4->d4_local == "01" .or. sd4->d4_local == "91".or. sd4->d4_local=="80"  
    	sd4->(dbskip())
    	loop
   endif	
	sb1->(dbseek(cfilsb1+sd4->d4_cod))
	nqtdparc:=nqtdparc+sd4->d4_qtdeori
	cumemp:=sb1->b1_um
	@ prow()+1, 000 PSAY "|"
	@ prow(),001 PSAY left(sd4->d4_cod,6)
	@ prow(),008 PSAY "|"            
	@ prow(),010 PSAY sb1->b1_desc
	@ prow(),050 PSAY "|          |"
//	@ prow(),062 PSAY sd4->d4_qtdeori picture "@E 999,999,999.999999"
	@ prow(),081 PSAY "|"
	@ prow(),082 PSAY cumemp
	@ prow(),083 PSAY "|"
//	@ prow(),84 PSAY sd4->d4_lotectl
   @ prow(),94 PSAY "|                   |           |        |"                       
   @ prow()+1,000 PSAY "|-------------------------------------------------|----------|-------------------|--|----------|-------------------|-----------|--------|"
	sd4->(dbskip())
	if prow()> 52
	  cab016()
	endif  
end 
return 

Static function cab016()
	if mfirst
		setprc(0,0)
		mpag:=1
		mfirst:=.f.
	else
	   mpag:=mpag+1 	
	endif
	@ 000,000 PSAY avalimp(133)
	@ 000,000 PSAY chr(18)
   @ prow()+1,000 PSAY "Vitamedic Industria Farmaceutica Ltda." 
   @ prow()  ,070 PSAY "Pag.: "+strzero(mpag,3,0)
   @ prow()+1,000 PSAY "Produto: "+chr(15)+chr(14)+left(sc2->c2_produto,6)+"-"+cdesc+chr(20)+chr(18)
   @ prow()+1,000 PSAY "D.Quimica: "+substr(_cdesccien,1,53) 
   @ prow(),  064 PSAY "Lote no. "+sc2->c2_lotectl
   @ prow()+1,000 PSAY "Apresent:"+substr(capres,1,50)
   @ prow()  ,062 PSAY "Emissao: "+dtoc(sc2->c2_emissao) 
   if Empty(_ddata)
     @ prow()+1,000 PSAY "Revisao:            Data Revisao:   /   /   "
   else
     @ prow()+1,000 PSAY "Revisao: "+_crev+"        Data Revisao: "+dtoc(_ddata)
   endif  
   @ prow()  ,062 PSAY "Validade: "+strzero((nprvalid/365)*12,2,0)
   @ prow()  ,075 PSAY "meses"
   @ prow()+1,000 PSAY "                                   ORDEM DE PRODUCAO"
   @ prow()  ,057 PSAY "Qtde.Teorica:"
   @ prow()  ,070 PSAY sc2->c2_quant picture "@E 999,999"
   @ prow()  ,077 PSAY cum
   @ prow()+1,000 PSAY replicate("_",79)
   @ prow()+1,000 PSAY chr(15)
 return


/*
|---------------------------------------------------------------------------------------------|
|                                   REQUISICAO DE MATERIA PRIMA                               |
|---------------------------------------------------------------------------------------------|
| Codigo| Materia Prima                            |Endereco |Peso Balanca      |UM|Lote      |
|---------------------------------------------------------------------------------------------|
| 999999|-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |999.999.999,999999|xx |999999   |
|---------------------------------------------------------------------------------------------|
|                                                          |                                  |
|Remetido por:__________________________   Data:___/___/___|                                  |
|                                                          |                                  |
|Separado por:__________________________   Data:___/___/___|                                  |
|                                                          |                                  |
|Pesado por  :__________________________   Data:___/___/___|                                  |
|                                                          |__________________________________|
|Material recebido na producao                             |DCQ:                              |
|                                                          |                                  |
|Conferido por:_________________________   Data:___/___/___|__________________________________|
|                                                                                             |
|Observacoes:_________________________________________________________________________________|
|                                                                                             |
|_____________________________________________________________________________________________|
|                                                                                             |
|_____________________________________________________________________________________________|



|-------------------------------------------------------------------------------------------------------------------|
| 						    	      	REQUISICAO DE MATERIAL DE EMBALAGEM                                                |
|-------------------------------------------------------------------------------------------------------------------|        |
| Codigo| Material                                |Endereco |UM |Lote     |Separador          |Conferente  |Data    |
|-------------------------------------------------|---------|---|---------|-------------------|------------|--------|
| 999999|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |XX |999999   |                   |            |99/99/99|
|-------------------------------------------------------------------------------------------------------------------|        |



|---------------------------------------------------------------------------------------------|
|                                   CONFERENCIA DE PESAGEM DE MATERIA PRIMA                   |
|---------------------------------------------------------------------------------------------|
| Codigo| Materia Prima                            |Endereco |Peso Balanca      |UM |Lote     |
|---------------------------------------------------------------------------------------------|
| 999999|-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |                  |xx |999999   |
|---------------------------------------------------------------------------------------------|
         

*/

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da OP              ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a OP           ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Item               ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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