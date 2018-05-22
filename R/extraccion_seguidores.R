# Obtenemos la informacion de historico
load("datos/historico_seguidores.RData")

# Obtenemos los seguidores de cada user en un elemento de la lista
seguidores <- map(users, get_followers, 
                         n                = 99999999, 
                         retryonratelimit = TRUE) %>% 
              map2_df(users, cbind) %>% 
              rename( "cuenta" = ".y[[i]]") %>% 
              obtener_informacion

# Obtenemos informacion del alcance y repercusion
resumen.seg <- resumen_seguidores(seguidores) %>% 
               mutate(extraccion = Sys.Date(),
                      mes        = format(Sys.Date(), "%m/%Y"))


# Junto nueva informacion con la de meses anteriores
historico.seguidores <- anti_join(historico.seguidores, resumen.seg, by = c("cuenta", "mes")) %>% 
    bind_rows(resumen.seg)

# Guardamos los datos en el historico
save(historico.seguidores, file = "datos/historico_seguidores.RData")

 
