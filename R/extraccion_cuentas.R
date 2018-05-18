# Obtenemos la informacion de historico
load("datos/historico_cuentas.RData")

# Extraemos la información de los users
cuentasGVA <- lookup_users(users) 

# Añadimos fecha de extracción
cuentasGVA$extraccion <- Sys.Date()
cuentasGVA$mes        <- format(Sys.Date(), "%m/%Y")


# Junto nueva informacion con la de meses anteriores
historico.cuentas <- anti_join(historico.cuentas, cuentasGVA, by = c("user_id", "mes")) %>% 
                     bind_rows(cuentasGVA)

#Añadimos los nuevos datos
save(historico.cuentas, file = "datos/historico_cuentas.RData")
