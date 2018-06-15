# Obtenemos el historico de menciones 
load("datos/historico_menciones.RData")

# Obtenemos la ultima informacion de las ultimas menciones
menciones.nuevas = search_tweets2(q                = usuarios$mencion, 
                                  n                = 99999,     
                                  lang             = "es",
                                  include_rts      = TRUE,
                                  retryonratelimit = TRUE) 

menciones.nuevas <- mutate(menciones.nuevas, 
                           text         = Limpiar_texto(text),
                           retweet_text = Limpiar_texto(retweet_text),
                           extraccion   = Sys.Date())

# Juntamos la nueva informacion con la antigua
historico.menciones <- anti_join(historico.menciones, menciones.nuevas, by = "status_id") %>% 
                       bind_rows(menciones.nuevas)

save(historico.menciones, file = "datos/historico_menciones.RData")
