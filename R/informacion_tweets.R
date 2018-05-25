# Filtros
filtros$usuarios <- c("generalitat",
                     "ChicoteAngel")

filtros$fecha.inicio <- as_date("2018-03-18")
filtros$fecha.final  <- as_date("2018-06-18")

# Aplicamos los filtros
tweets.filtrados <- historico.tweets %>% filter(screen_name %in% filtros$usuarios) 



cuentas.separadas <- tweets.filtrados %>% indicadores_tweets %>% nest(-users)
