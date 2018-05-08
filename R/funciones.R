
####
# Extraemos la informacion de los usuarios para cuando tienes mas de 90000
####

obtener_informacion <- function(seguidores) {
    
    seguidores.unicos <- seguidores %>% select(user_id) %>% distinct()
    N                 <- length(seguidores.unicos)
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
    
    return(info.users)
}

####
# Obtener tweets que contienen ciertas palabras
####
obtener_menciones <- function(users,N){
    
           menciones  = apply( as_tibble(paste("@",users,sep="")), 1,
                             search_tweets,
                             n      = 2,
                             lang   = "es",
                             retryonratelimit = TRUE) %>% 
                        map2( users, cbind) %>% 
                        do.call(rbind,.)
    return(menciones)
}


####
# Limpiamos el texto pasando a minusculas, quitando caracteres extraños y urls
####
Limpiar_texto <- function(texto) {
    nice.str <- c()
    
    for(i in 1:length(texto)){
        
    str <- iconv(texto[i],'UTF-8','latin1', sub = '') %>%  gsub("[[:space:]]"," ",.)
    
    words <- unlist(strsplit(str, " "))
#   urls  <- grep("http",words)
#   if(!is.empty(urls)){
#   words <- words[-urls]
#   }
    in.alphabet <- grep(words, pattern = "[a-z|0-9]", ignore.case = T)
    
    nice.str[i] <- paste(words[in.alphabet], collapse = " ") %>% tolower
    }
    return(nice.str)
}


####
# Calculamos la informacion de repercusion y lista de seguidores top activos e influyentes 
#

repercusion <- function(users,info.seguidores) {

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


"%!in%" <- function(x, table) match(x, table, nomatch = 0) == 0

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

indicadores_menciones <- function(menciones, filtro) {
    
    menciones <- left_join(menciones, usuarios, by = c("cuentas" = "users"))
    colnames(menciones)[ colnames(menciones) == filtro] = "filtro"
    
    indicadores <- group_by(menciones, filtro, mes = floor_date(created_at,"month")) %>% 
                   summarise( n.menciones           = n(),
                              n.menciones.propias   = sum(!is_retweet),
                              n.menciones.retweets  = sum(is_retweet),
                              n.usuarios            = sum(table(user_id)),
                              n.likes               = sum(favorite_count))
    
    return(indicadores)
    
}


