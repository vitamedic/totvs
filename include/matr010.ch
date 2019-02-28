#ifdef SPANISH
	#define STR0001 "Detalle de materiales"
	#define STR0002 "Emision del registro de materiales "
	#define STR0003 "Imprimirálos datos de los productos de acuerdo"
	#define STR0004 "con la configuracion del usuario."
	#define STR0005 "A Rayas"
	#define STR0006 "Administracion"
	#define STR0007 "DETALLE COMPLETO DEL ARCHIVO DE MATERIALES "
	#define STR0008 " Por Codigo         "
	#define STR0009 " Por Tipo           "
	#define STR0010 " Por Descripcion    "
	#define STR0011 " Por Grupo          "
	#define STR0012 "Lista de Productos"
	#define STR0013 "Este informe muestra una lista con los productos registrados"
#else
	#ifdef ENGLISH
		#define STR0001 "List of Material    "
		#define STR0002 "Material File Printing"
		#define STR0003 "It will print the products data according "
		#define STR0004 "to the user`s configurations.     "
		#define STR0005 "Z.Form "
		#define STR0006 "Management    "
		#define STR0007 "Material File - Detailed List - By Code"
		#define STR0008 " By Code            "
		#define STR0009 " By Type            "
		#define STR0010 " By Description     "
		#define STR0011 " By Group           "
		#define STR0012 "List of Products"
		#define STR0013 "This report presents a list of registered products"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relação De Materiais", "Relacao de Materiais" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Emissão Do Registo De Materiais", "Emissao do Cadastro de Materiais" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Irá imprimir os dados dos artigos de acordo", "Ira imprimir os dados dos produtos de acordo" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Com a configuração do utilizador.", "com a configuracao do usuario." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Relação Completa Do Registo De Materiais", "RELACAO COMPLETA DO CADASTRO DE MATERIAIS" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", " por código         ", " Por Codigo         " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " por tipo           ", " Por Tipo           " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", " por descrição      ", " Por Descricao      " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " por grupo          ", " Por Grupo          " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Listagem De Artigos", "Listagem de Produtos" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Este relatório apresenta uma relação dos artigos registados", "Este relatório apresenta uma relação dos produtos cadastrados" )
	#endif
#endif
