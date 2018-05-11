# Obtenemos la informacion de historico
load("datos/historico_seguidores.RData")
# Obtenemos los seguidores de cada user en un elemento de la lista
seguidores <- sapply(users ,get_followers, 
                            n                = 3, 
                            retryonratelimit = TRUE,
                            simplify         = FALSE) %>% 
              map2_df(users,cbind) %>% 
              rename( "cuenta" = ".y[[i]]") %>% 
              obtener_informacion

# Obtenemos informacion del alcance y repercusion
resumen.seg <- repercusion(seguidores)

# Añadimos fecha de extracción
resumen.seg$extraccion <- format(Sys.Date(), "%d/%m/%y")

# Añadimos la nueva informacion al historico
historico.seguidores <- rbind(historico.seguidores, resumen.seg)

# Guardamos los datos en el historico
save(historico.seguidores, file = "datos/historico_seguidores.RData")

 
