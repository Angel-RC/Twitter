# Obtenemos la informacion de historico
load("datos/historico_seguidores.RData")
# Obtenemos los seguidores de cada user en un elemento de la lista
seguidores <- sapply(users ,get_followers, 
                            n = 30000, 
                            retryonratelimit = TRUE,
                            simplify = FALSE) %>% 
              
              map2(users,cbind) %>% 
              do.call(rbind, .) %>% 
              rename( origen = ".y[[i]]")

rownames(seguidores) = NULL
# Obtenemos la informacion de dichos seguidores
info.seguidores <- obtener_informacion( seguidores) 

# Obtenemos informacion del alcance y repercusion
nuevo <- repercusion(users, info.seguidores)

# Añadimos fecha de extracción
nuevo$repercusion$extraccion <- format(Sys.Date(), "%d/%m/%y")

# Añadimos la nueva informacion al historico
historico.seguidores <- rbind(historico.seguidores, nuevo$repercusion)

# Guardamos los datos en el historico
save(historico.seguidores, file = "datos/historico_seguidores.RData")

 
