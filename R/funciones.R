# Extraemos la informacion de los usuarios para cuando tienes mas de 90000
# ··············································································

obtener_informacion <- function(seguidores) {
    
    seguidores.unicos <- seguidores %>% select(user_id) %>% distinct()
    N                 <- dim(seguidores.unicos)[1]
    max.users         <- 90000
    total.rep         <- ceiling(N / max.users)
    info.seguidores   <- tibble()
    
    for (i in 1:total.rep) {
        inicio <- (i - 1) * max.users + 1
        final  <- min(i * max.users, N)
        
        info.seguidores <- rbind(info.seguidores, lookup_users(seguidores.unicos[inicio:final,]))
    }
    
    info.seguidores <- inner_join(info.seguidores, seguidores, by="user_id")
    
    return(info.seguidores)
}


Limpiar_texto <- function(texto) {

    nice.str <- iconv(texto,'UTF-8','latin1', sub = '') %>%
                gsub("[[:space:]]"," ",.) %>% 
                tolower
    
    return(nice.str)
}


# Calculamos la informacion de repercusion de cada usuario segun sus seguidores
# ····················································································

resumen_seguidores <- function(info.seguidores) {

    resultado   <-  group_by(info.seguidores, cuenta) %>% 
                    summarise(n.seguidores    = n(),
                              n.activos       = sum( statuses_count > tweets.necesarios),
                              n.influyentes   = sum(followers_count > seguidores.necesarios),
                              n.segundo.salto = sum(followers_count),
                              n.tweets.segui  = sum(statuses_count),
                              n.amigos.segui  = sum(friends_count),
                              n.listas.segui  = sum(listed_count))
                              
        return(resultado)
    
}

# Obtenemos los indicadores de las cuentas por meses
# ··············································································


indicadores_cuentas <- function (cuentas){
    
 indicadores <- transmute(cuentas, users               = name,
                                   mes                 = mes,
                                   n.tweets            = statuses_count,
                                   n.seguidores        = followers_count,
                                   n.favoritos         = favourites_count,
                                   n.amigos            = friends_count,
                                   n.listas            = listed_count,
                                   ratio.likes.cuentas = round(favourites_count * 100 / friends_count, 2),
                                   creacion            = account_created_at,
                                   dias.creacion       = (Sys.time() - account_created_at) %>% as.integer())
    
    return(indicadores)
    
}

# Obtenemos los indicadores de los tweets por meses y el filtro que queramos
# ··············································································

indicadores_tweets <- function(tweets, filtro = "users"){
    
indicadores <- right_join(usuarios, tweets, by = c("users" = "screen_name")) %>% 
               group_by(mes = floor_date(created_at, "month")) %>% 
               group_by_(filtro, add = TRUE) %>% 
               summarise(n.tweets                  = n() ,
                         n.tweets.propios          = sum(is_retweet == FALSE),
                         n.tweets.retweets         = sum(is_retweet == TRUE),
                         n.tweets.respuestas       = sum(!is.na(reply_to_user_id)),
                         n.retweets                = sum(retweet_count),
                         n.like                    = sum(favorite_count),
                         n.like.tweets.propios     = sum(favorite_count[is_retweet == FALSE]),
                         n.retweets.tweets.propios = sum(retweet_count[is_retweet == FALSE])) %>% 
              ungroup()
    return(indicadores)
}

# Obtenemos los indicadores de las menciones por meses y el filtro que queramos
# ··············································································

indicadores_menciones <- function(menciones, filtro, periodo = "month") {
    
  indicadores <- inner_join( usuarios, menciones, by = c("mencion" = "query")) %>% 
                 group_by( periodo = floor_date(created_at, periodo)) %>% 
                 group_by_( filtro, add = TRUE) %>% 
                 summarise( n.menciones           = n(),
                            n.menciones.propias   = sum(!is_retweet),
                            n.menciones.retweets  = sum(is_retweet),
                            n.usuarios            = length(table(user_id)),
                            n.likes               = sum(favorite_count))
    
    return(indicadores)
    
}


# Obtenemos las series correspondientes para el data.frame 
# ··············································································

obtener_series <- function(datos,tipo) {
    
    if(tipo == "users"){
        
    vector <- c("followers_count",
                "friends_count",
                "listed_count",
                "statuses_count",
                "favourites_count")
    
    inicio <- min(historico.cuentas$extraccion)
    
    }
    
    serie.temporal <-  ts(datos[, vector], 
                          start = c(year(inicio), month(inicio)), 
                          frequency = 12)
    return(serie.temporal)
}



# Aplicamos filtros a los historicos para hacer busquedas mas concretas
# ··············································································

aplicar_filtros <- function(datos, filtros) {
    
    datos2 <- datos %>% inner_join(usuarios, by = c("screen_name" = "users")) %>% 
                        filter(screen_name %in% filtros$usuarios) %>% 
                        filter(grupos %in% filtros$grupos)
                        filter(between(extraccion, filtros$extraccion.inicio, filtros$extraccion.final)) %>% 
                        filter(between(as_date(match("created_at")), filtros$creacion.inicio, filtros$creacion.final))
              
    
    
    
}