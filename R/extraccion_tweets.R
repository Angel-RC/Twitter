# Obtenemos el historico de tweets 
load("datos/historico_tweets.RData")

# Obtenemos la ultima informacion de los ultimos tweets
tweets.nuevos <- get_timeline(user = users,
                              n    = 99900,
                              home = FALSE) %>% 
                 mutate(text         = Limpiar_texto(text),
                        retweet_text = Limpiar_texto(retweet_text),
                        extraccion   = Sys.Date())

# Juntamos la nueva informacion con la antigua
historico.tweets <- anti_join(historico.tweets, tweets.nuevos, by = "status_id") %>% 
                    bind_rows(tweets.nuevos)

save(historico.tweets, file = "datos/historico_tweets.RData")



