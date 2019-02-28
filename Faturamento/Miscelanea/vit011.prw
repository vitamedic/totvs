/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT011   ³ Autor ³ Heraildo C. de Freitas³ DATA ³15/01/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transferencia dos Dados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit011()

if sm0->m0_codigo<>"02" .or.;
	(upper(alltrim(getenvserver()))<>"BACKUP" .and. upper(alltrim(getenvserver()))<>"BKP")
	msgstop("Este programa so pode ser executado na empresa 02, ambiemte backup!")
	return
endif

if tclink("oracle/siga","10.1.1.25")<>0
	msgstop("Falha de conexao com o banco!")
	tcquit()
	return
endif          
            

if msgyesno("Confirma transferencia dos arquivos?")
	processa({|| _grava()})
	msginfo("Transferencia finalizada com sucesso!")
endif
tcquit()
return

static function _grava()
procregua(19)

_abretop("SA1010",1)
_abretop("SA2010",1)
_abretop("SA3010",1)
_abretop("SA4010",1)
_abretop("SAH010",1)
_abretop("SB1010",1)
_abretop("SBM010",1)
_abretop("SC5010",1)
_abretop("SC6010",1)
_abretop("SC9010",1)
_abretop("SD2010",3)
_abretop("SD3010",2)
_abretop("SE1010",1)
_abretop("SE4010",1)
_abretop("SED010",1)
_abretop("SF2010",4)
_abretop("SF4010",1)
_abretop("SM2010",1)
_abretop("SRA010",1)
_abretop("DA0010",1)
_abretop("DA1010",1)
_abretop("SZB010",)


dbcreate("\data\tmpsd2",sd2010->(dbstruct()))
dbusearea(.t.,,"\data\tmpsd2","TMPSD2",.f.,.f.)
dbcreate("\data\tmpse1",se1010->(dbstruct()))
dbusearea(.t.,,"\data\tmpse1","TMPSE1",.f.,.f.)
dbcreate("\data\tmpsf2",sf2010->(dbstruct()))
dbusearea(.t.,,"\data\tmpsf2","TMPSF2",.f.,.f.)

sd3010->(dbgobottom())
_cdoc:=soma1(sd3010->d3_doc,6)

incproc("Gerando arquivos temporarios")
sf2010->(dbseek("01"+"R  "))
while ! sf2010->(eof()) .and.;
		sf2010->f2_filial=="01" .and.;
		sf2010->f2_serie=="R  "
	
	tmpsf2->(reclock("TMPSF2",.t.))
	for _i:=1 to sf2010->(fcount())
		tmpsf2->(fieldput(_i,sf2010->(fieldget(_i))))
	next
	tmpsf2->(msunlock())
	
	sd2010->(dbseek("01"+sf2010->f2_doc+sf2010->f2_serie))
	while ! sd2010->(eof()) .and.;
			sd2010->d2_filial=="01" .and.;
			sd2010->d2_doc==sf2010->f2_doc
		if sd2010->d2_serie==sf2010->f2_serie
			tmpsd2->(reclock("TMPSD2",.t.))
			for _i:=1 to sd2010->(fcount())
				tmpsd2->(fieldput(_i,sd2010->(fieldget(_i))))
			next
			tmpsd2->(msunlock())
			sd3010->(reclock("SD3010",.t.))
			sd3010->d3_filial :="01"
			sd3010->d3_tm     :="501"
			sd3010->d3_cod    :=sd2010->d2_cod
			sd3010->d3_um     :=sd2010->d2_um
			sd3010->d3_quant  :=sd2010->d2_quant
			sd3010->d3_cf     :="RE0"
			sd3010->d3_local  :=sd2010->d2_local
			sd3010->d3_doc    :=_cdoc
			sd3010->d3_emissao:=sd2010->d2_emissao
			sd3010->d3_grupo  :=sd2010->d2_grupo
			sd3010->d3_custo1 :=sd2010->d2_custo1
			sd3010->d3_custo2 :=sd2010->d2_custo2
			sd3010->d3_custo3 :=sd2010->d2_custo3
			sd3010->d3_custo4 :=sd2010->d2_custo4
			sd3010->d3_custo5 :=sd2010->d2_custo5
			sd3010->d3_numseq :=sd2010->d2_numseq
			sd3010->d3_segum  :=sd2010->d2_segum
			sd3010->d3_qtsegum:=sd2010->d2_qtsegum
			sd3010->d3_tipo   :=sd2010->d2_tp
			sd3010->d3_chave  :="E0"
			sd3010->d3_lotectl:=sd2010->d2_lotectl
			sd3010->d3_dtvalid:=sd2010->d2_dtvalid
			sd3010->d3_stserv :="1"
			sd3010->(msunlock())
		endif
		sd2010->(dbskip())
	end
	se1010->(dbseek("01"+sf2010->f2_serie+sf2010->f2_doc))
	while ! se1010->(eof()) .and.;
			se1010->e1_filial=="01" .and.;
			se1010->e1_prefixo==sf2010->f2_serie .and.;
			se1010->e1_num==sf2010->f2_doc
		tmpse1->(reclock("TMPSE1",.t.))
		for _i:=1 to se1010->(fcount())
			tmpse1->(fieldput(_i,se1010->(fieldget(_i))))
		next
		tmpse1->(msunlock())
		se1010->(dbskip())
	end
	sf2010->(dbskip())
end

incproc("Transferindo SA1")
dbselectarea("SA1010")
copy to "\data\sa1020"
ferase("\data\sa1020.cdx")

incproc("Transferindo SA2")
dbselectarea("SA2010")
copy to "\data\sa2020"
ferase("\data\sa2020.cdx")

incproc("Transferindo SA3")
dbselectarea("SA3010")
copy to "\data\sa3020"
ferase("\data\sa3020.cdx")

incproc("Transferindo SA4")
dbselectarea("SA4010")
copy to "\data\sa4020"
ferase("\data\sa4020.cdx")

incproc("Transferindo SAH")
//dbselectarea("SAH010")
//copy to "\data\sah020"
//ferase("\data\sah020.cdx")

incproc("Transferindo SB1")
dbselectarea("SB1010")
copy to "\data\sb1030"
ferase("\data\sb1030.cdx")

incproc("Transferindo SBM")
dbselectarea("SBM010")
copy to "\data\sbm030"
ferase("\data\sbm030.cdx")

incproc("Transferindo SC5")
dbselectarea("SC5010")
copy to "\data\sc5020" for right(c5_num,1)=="R"
ferase("\data\sc5020.cdx")

incproc("Transferindo SC6")
dbselectarea("SC6010")
copy to "\data\sc6020" for right(c6_num,1)=="R"
ferase("\data\sc6020.cdx")

incproc("Transferindo SC9")
dbselectarea("SC9010")
copy to "\data\sc9020" for right(c9_pedido,1)=="R"
ferase("\data\sc9020.cdx")

incproc("Transferindo SE4")
dbselectarea("SE4010")
copy to "\data\se4020"
ferase("\data\se4020.cdx")

incproc("Transferindo SED")
dbselectarea("SED010")
copy to "\data\sed020"
ferase("\data\sed020.cdx")

incproc("Transferindo DA0")
dbselectarea("DA0010")
copy to "\data\da0020"
ferase("\data\da0020.cdx")

incproc("Transferindo DA1")
dbselectarea("DA1010")
copy to "\data\da1020"
ferase("\data\da1020.cdx")

incproc("Transferindo SF4")
dbselectarea("SF4010")
copy to "\data\sf4020"
ferase("\data\sf4020.cdx")

incproc("Transferindo SM2")
if select("SM2")<>0
	_lsm2:=.t.
	sm2->(dbclosearea())
else
	_lsm2:=.f.
endif
dbselectarea("SM2010")
copy to "\data\sm2020"
ferase("\data\sm2020.cdx")
if _lsm2
	chkfile("SM2")
endif

/*
incproc("Transferindo SRA")
dbselectarea("SRA010")
copy to "\data\sra020"
ferase("\data\sra020.cdx")
dbusearea(.t.,,"\data\sra020.dbf","SRA",.f.,.f.)
sra->(dbgotop())
while ! sra->(eof())
	sra->ra_pgctsin:="N"
	sra->ra_depir  :="  "
	sra->ra_depsf  :="  "
	sra->ra_adtpose:="******"
	sra->ra_valeref:="  "
	sra->(dbskip())
end
sra->(dbclosearea())
*/
tmpsd2->(dbclosearea())
tmpse1->(dbclosearea())
tmpsf2->(dbclosearea())

incproc("Transferindo SD2")
dbusearea(.t.,,"\data\sd2020","SD2",.f.,.f.)
append from "\data\tmpsd2"
sd2->(dbclosearea())
ferase("\data\sd2020.cdx")

incproc("Transferindo SE1")
dbusearea(.t.,,"\data\se1020","SE1",.f.,.f.)
append from "\data\tmpse1"
se1->(dbclosearea())
ferase("\data\se1020.cdx")

incproc("Transferindo SF2")
dbusearea(.t.,,"\data\sf2020","SF2",.f.,.f.)
append from "\data\tmpsf2"
sf2->(dbclosearea())
ferase("\data\sf2020.cdx")

incproc("Transferindo SZB")
dbselectarea("SZB010")
copy to "\data\szb2020"
ferase("\data\szb020.cdx")

sa1010->(dbclosearea())
sa2010->(dbclosearea())
sa3010->(dbclosearea())
sa4010->(dbclosearea())
sah010->(dbclosearea())
sb1010->(dbclosearea())
sbm010->(dbclosearea())
sc5010->(dbclosearea())
sc6010->(dbclosearea())
sc9010->(dbclosearea())
sd2010->(dbclosearea())
sd3010->(dbclosearea())
se1010->(dbclosearea())
se4010->(dbclosearea())
sed010->(dbclosearea())
sf2010->(dbclosearea())
sf4010->(dbclosearea())
sm2010->(dbclosearea())
sra010->(dbclosearea())
da0010->(dbclosearea())
da1010->(dbclosearea())
szb010->(dbclosearea())
  

incproc("Limpando dados")
_ccomando:=" DELETE"
_ccomando+=" FROM "
_ccomando+=" SD2010"
_ccomando+=" WHERE"
_ccomando+="     D2_FILIAL='"+"01"+"'"
_ccomando+=" AND D2_SERIE='R  '"
tcsqlexec(_ccomando)

_ccomando:=" DELETE"
_ccomando+=" FROM "
_ccomando+=" SE1010"
_ccomando+=" WHERE"
_ccomando+="     E1_FILIAL='"+"01"+"'"
_ccomando+=" AND E1_PREFIXO='R  '"
tcsqlexec(_ccomando)

_ccomando:=" DELETE"
_ccomando+=" FROM "
_ccomando+=" SF2010"
_ccomando+=" WHERE"
_ccomando+="     F2_FILIAL='"+"01"+"'"
_ccomando+=" AND F2_SERIE='R  '"
tcsqlexec(_ccomando)
return

static function _abretop(_carq,_nordem)
_calias:=left(_carq,3)
dbusearea(.t.,"TOPCONN",_carq,_carq,.t.,.f.)
six->(dbseek(_calias))
while ! six->(eof()) .and.;
		six->indice==_calias
	dbsetindex(_carq+six->ordem)
	six->(dbskip())
end
dbsetorder(_nordem)
return