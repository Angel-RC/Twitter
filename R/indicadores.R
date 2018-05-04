###################################################################################
#Obtenemos los indicadores para elaborar el informe
###################################################################################

#informacion obtenida de tweets_propios
interaccion.mes <- obtener_interaccion(tweets.cuentas)
actividad.mes <- obtener_actividad(tweets.cuentas)
#informacion obtenida de info_usuarios
indicadores.creacion <- obtener_indicadores(cuentasGVA_df)
#informacion obtenida de seguidores