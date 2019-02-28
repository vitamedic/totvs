#ifdef SPANISH
	#define STR0001 "Detalle de Clientes"
	#define STR0002 "Emision del registro de clientes"
	#define STR0003 "Imprimira los datos de los clientes, de "
	#define STR0004 "acuerdo con la configuracion del usuario. "
	#define STR0005 "A Rayas"
	#define STR0006 "Administracion"
	#define STR0007 "DETALLE COMPLETO DEL REGISTRO DE CLIENTES "
	#define STR0008 " Por Codigo         "
	#define STR0009 " Alfabetico         "
	#define STR0010 " Por CUIT           "
	#define STR0011 " Por RUT            "
	#define STR0012 " Por RUC            "
	#define STR0013 " Por RFC            "
	#define STR0014 " Por NIT/C.C        "
	#define STR0015 " Por "
	#define STR0016 "Lista de Clientes"
	#define STR0017 "Este informe trae una lista con los Clientes registrados."
#else
	#ifdef ENGLISH
		#define STR0001 "Customer List      "
		#define STR0002 "Customers File Printing."
		#define STR0003 "It will show Customers data, according "
		#define STR0004 "to the User`s configurations.          "
		#define STR0005 "Z.Form"
		#define STR0006 "Management   "
		#define STR0007 "CUSTOMERS FILE - COMPLETE REPORT"
		#define STR0008 " By Code          "
		#define STR0009 " Alphabetic Order "
		#define STR0010 " By CGC           "
		#define STR0011 " By RUT           "
		#define STR0012 " By RUC           "
		#define STR0013 " By RFC           "
		#define STR0014 " By NIT/C.C       "
		#define STR0015 " By "
		#define STR0016 "Customer list       "
		#define STR0017 "This report lists the registered customers.                   "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relação de clientes", "Relacao de clientes" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Emissão Do Registo De Clientes", "Emissao do Cadastro de Clientes" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Irá imprimir os dados dos clientes      ", "Ira imprimir os dados dos clientes      " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "De acordo com a configuração do utilizador.", "de acordo com a configuracao do usuario." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Relação Completa Do Registo De Clientes", "RELACAO COMPLETA DO CADASTRO DE CLIENTES" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", " por código         ", " Por Codigo         " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " Alfabética         ", " Alfabetica         " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", " por n.º contribuinte           ", " Por CGC           " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " por rut           ", " Por RUT           " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", " por ruc           ", " Por RUC           " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", " por nif           ", " Por RFC           " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", " por c.c       ", " Por NIT/C.C       " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", " por ", " Por " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Listagem De Clientes", "Listagem de Clientes" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Este relatório apresenta uma relação dos clientes registados.", "Este relatório apresenta uma relação dos Clientes cadastrados." )
	#endif
#endif
