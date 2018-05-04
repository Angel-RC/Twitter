tabla_comparacion_tweet <- function(info.tweets) {
    
en.mes <- filter(tweets, mes <  primer.dia.mes,
                              mes >= primer.dia.mes - dias.mes.anterior) %>% 
          select(.,3:6) %>% 
          sapply(.,sum) 

media.mensual <- filter(info.tweets, mes < primer.dia.mes - dias.mes.anterior) %>% 
                 select(.,3:6) %>%  
                 sapply(.,sum)/length(unique(info.tweets$mes))


tabla.tweets <- rbind(en.mes,media.mensual)

row.names(tabla.tweets)=c("En el mes","Promedio mensual")

return(tabla.tweets)
}
