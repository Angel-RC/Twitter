# Obtenemos el historico de menciones 
load("datos/historico_menciones.RData")
# Obtenemos la ultima informacion de las ultimas menciones
menciones.nuevas <- sapply( paste("@", users, sep = ""),
                            search_tweets,
                            n      = 3,
                            lang   = "es",
                            retryonratelimit = TRUE,
                            simplify = FALSE) %>% 
    
                    map2( users,cbind)

    
menciones.nuevas <- do.call(rbind, menciones.nuevas) 
rename(menciones.nuevas, origen = ".y[[i]]")
rownames(menciones.nuevas) = NULL

menciones.nuevas <- mutate(menciones.nuevas, 
                           text         = Limpiar_texto(text),
                           retweet_text = Limpiar_texto(retweet_text),
                           extraccion   = Sys.Date())

# Juntamos la nueva informacion con la antigua
historico.menciones <- anti_join(historico.menciones, menciones.nuevas, by="status_id") %>% 
                       bind_rows(menciones.nuevas)

save(historico.menciones, file = "datos/historico_menciones.RData")
