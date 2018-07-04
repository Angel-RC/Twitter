# Filtros
filtro.usuarios <- c("generalitat"
                     "ChicoteAngel")

fecha.inicio <- as_date("2018-03-18")
fecha.final  <- as_date("2018-07-18")

# Obtenemos la informacion de los usuarios deseados
cuentas.filtradas <- historico.cuentas %>% filter(screen_name %in% filtro.usuarios) 


tabla.visual <- cuentas.filtradas %>%  filter(between(extraccion, fecha.inicio, fecha.final)) %>% 
                                       indicadores_cuentas()



cuentas.separadas <- cuentas.filtradas %>% nest(-screen_name)


# Obtengo las series para cada usuario
series <- map(cuentas.separadas$data, obtener_series, tipo = "users")

if(length(series) == 1) series <- series[[1]]

# Pintamos las series temporales para los usuarios por separado
autoplot(series, 
         ts.linetype = 1, 
         ts.colour   = "black", 
         ts.geom     = "line",
         facets      = TRUE)
