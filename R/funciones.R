# Extraemos la informacion de los usuarios para cuando tienes mas de 90000
# -----------------------------------------------------------------------------

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
    
    info.seguidores <- inner_join(info.seguidores, seguidores, by="user_id") %>%  
                       arrange(statuses_count)
    
    return(info.seguidores)
}


Limpiar_texto <- function(texto) {

    nice.str <- iconv(texto,'UTF-8','latin1', sub = NA) %>%
                gsub("[[:space:]]"," ",.) %>% 
                tolower
    
    return(nice.str)
}


# Calculamos la informacion de repercusion y lista de seguidores top activos e influyentes
# ----------------------------------------------------------------------------------------

repercusion <- function(info.seguidores) {

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
# -----------------------------------------------------------------------------


indicadores_cuentas <- function (cuentas){
    
 indicadores <- transmute(cuentas, users               = name,
                                   mes                 = format(extraccion, "%b %y"),
                                   n.tweets            = statusesCount,
                                   n.seguidores        = followersCount,
                                   creacion            = format(created, "%d/%m/%y"),
                                   dias.creacion       = (Sys.time() - created) %>% as.integer(),
                                   n.favoritos         = favoritesCount,
                                   n.amigos            = friendsCount,
                                   ratio.likes.cuentas = favoritesCount*100/friendsCount)
    
    return(indicadores)
    
}

# Obtenemos los indicadores de los tweets por meses y el filtro que queramos
# -----------------------------------------------------------------------------

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
# -----------------------------------------------------------------------------

indicadores_menciones <- function(menciones, filtro, periodo="month") {
    
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


