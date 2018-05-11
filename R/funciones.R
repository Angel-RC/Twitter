
####
# Extraemos la informacion de los usuarios para cuando tienes mas de 90000
####
get_mentions("generalitat")

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

####
# Obtener tweets que contienen ciertas palabras
####
obtener_menciones <- function(palabras,N){
    
           menciones  = map( palabras,
                             search_tweets,
                             n      = N,
                             lang   = "es",
                             retryonratelimit = TRUE) %>% 
                        map2_dfr(palabras, cbind) %>% 
                        as.tibble() %>% 
                        rename( "palabra" = ".y[[i]]")
           
    return(menciones)
}

Limpiar_texto <- function(texto) {

    nice.str <- iconv(texto,'UTF-8','latin1', sub = NA) %>%
                gsub("[[:space:]]"," ",.) %>% 
                tolower
    
    return(nice.str)
}


####
# Calculamos la informacion de repercusion y lista de seguidores top activos e influyentes
#

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


####
# Obtenemos los indicadores de las cuentas por meses
####

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


####
# Obtenemos los indicadores de los tweets por meses y el filtro que queramos
####

indicadores_tweets <- function(tweets, filtro = "screen_name"){
    
    tweets <- left_join(tweets,usuarios, by = c("screen_name" = "users"))
    colnames(tweets)[ colnames(tweets) == filtro] = "filtro"
    
    indicadores <- group_by(tweets, filtro, mes = floor_date(created_at,"month")) %>% 
                   summarise(n.tweets                  = n() ,
                             n.tweets.propios          = sum(is_retweet == FALSE),
                             n.tweets.retweets         = sum(is_retweet == TRUE),
                             n.tweets.respuestas       = sum(!is.na(reply_to_user_id)),
                             n.retweets                = sum(retweet_count),
                             n.like                    = sum(favorite_count),
                             n.like.tweets.propios     = sum(favorite_count[is_retweet == FALSE]),
                             n.retweets.tweets.propios = sum(retweet_count[is_retweet == FALSE])) %>% 
                   ungroup()
    colnames(indicadores)[ colnames(indicadores) == "filtro"] = filtro
    return(indicadores)
}

####
# Obtenemos los indicadores de las menciones por meses y el filtro que queramos
####

indicadores_menciones <- function(menciones, filtro, periodo="month") {
    
    menciones <- left_join(menciones, usuarios, by = c("cuentas" = "users"))
    colnames(menciones)[ colnames(menciones) == filtro] = "filtro"
    
    indicadores <- group_by(menciones, filtro, periodo = floor_date(created_at,periodo)) %>% 
                   summarise( n.menciones           = n(),
                              n.menciones.propias   = sum(!is_retweet),
                              n.menciones.retweets  = sum(is_retweet),
                              n.usuarios            = length(table(user_id)),
                              n.likes               = sum(favorite_count))
    
    return(indicadores)
    
}


