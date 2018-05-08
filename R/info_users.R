# Obtenemos la informacion de historico
load("datos/historico_cuentas.RData")

# Extraemos la información de los users
cuentasGVA <- lookupUsers(users) %>% twListToDF %>% as_tibble

# Añadimos fecha de extracción
cuentasGVA$extraccion <- Sys.Date()

# Junto nueva informacion con la de meses anteriores
historico.cuentas <- rbind(historico.cuentas,cuentasGVA)

#Añadimos los nuevos datos
save(historico.cuentas, file = "datos/historico_cuentas.RData")
