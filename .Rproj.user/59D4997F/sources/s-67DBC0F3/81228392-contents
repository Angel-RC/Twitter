# Aqui esta todo el codigo necesario para extraer informacion de Twitter
#
# Autor: Angel Y Lara (RIP)
# Date:  19/12/2017
# 
# A lo largo del codigo aparecera la etiqueta #TO.DO cuando parte del codigo necesite ser revisado


# Inicializamos todo lo necesario
source("R/librerias.R")
source("R/inicio_twitter.R")
source("R/variables_globales.R")
source("R/funciones.R")

# Fase 1. Extraccion de datos desde la api
source("R/info_users.R")
source("R/info_tweets.R")
source("R/info_seguidores.R")
source("R/info_menciones.R")


# Fase 2. Realizamos el informe
source("informes/informe_provisional.Rmd")











# Obtenemos los trending topic de esa zona
trendsValencia <- getTrends( woeid = idValencia)
write.xlsx( trendsValencia,"trendsValencia.xls")


#Creamos la nube de hastaghs
mach_tweets = searchTwitter("Pedroche", n=10, lang="es")
mach_text = sapply(mach_tweets, function(x) x$getText())
mach_corpus = Corpus(VectorSource(mach_text))
tdm = TermDocumentMatrix(mach_corpus,
                         control = list(removePunctuation = TRUE,
                                        stopwords         = c( "yevar?a", stopwords("spanish")),
                                        removeNumbers     = TRUE, 
                                        tolower           = TRUE))
#Para obtener los hastaghs seg?n sus frecuencias
m = as.matrix(tdm)
word_freqs = sort(rowSums(m), decreasing=TRUE)
dm = data.frame(word=names(word_freqs), freq=word_freqs)

png("PruebaCloud.png", width=12, height=8, units="in", res=300)

wordcloud(words        = dm$word, 
          freq         = dm$freq, 
          min.freq     = 3,
          max.words    = Inf,
          random.order = FALSE, 
          colors       = brewer.pal(8, "Dark2"))
dev.off()


#############################################################################################




#Codigo R_Cuentas y tweets                                                                                      


# Obtenemos informacion de los usuarios 
cuentasGVA <- lookupUsers(users)
cuentasGVA_df<-twListToDF(cuentasGVA)

## lara
# 1.ACTIVIDAD (VOLUMEN)

##En el mes


##Desde la creacion de la cuenta

recuento_tweets              = cuentasGVA_df$statusesCount 

fecha_creacion_cuenta        = as.Date(cuentasGVA_df$created)

dif_dias=difftime(Sys.time(), cuentasGVA_df$created, units="days") #Cuantos dias han transcurrido a fecha de hoy desde la creación de la cuenta
dif_dias2=floor(dif_dias) #dias es una unidad entera
diferencia_dias=as.vector(dif_dias2)

media_tweets_dia             = cuentasGVA_df$statusesCount/diferencia_dias

recuento_likes_atweetsotros  = cuentasGVA_df$favoritesCount

recuento_cuentas_sigue       = cuentasGVA_df$friendsCount

ratio_likes_100cuentas       = (cuentasGVA_df$favoritesCount*100)/cuentasGVA_df$friendsCount


tabla=rbind(recuento_tweets,fecha_creacion_cuenta,media_tweets_dia,recuento_likes_atweetsotros,recuento_cuentas_sigue,ratio_likes_100cuentas)
colnames(tabla, do.NULL = FALSE)
colnames(tabla) <- c("generalitat",
                     "palauGVA",
                     "GVAinclusio",
                     "GVAhisenda",
                     "GVAjusticia",
                     "GVAeducacio",
                     "GVAculturesport",
                     "GVAsanitat",
                     "GVAeconomia",
                     "GVAagroambient",
                     "GVAhabitatge",
                     "GVAoberta",
                     "GVAservef",
                     "GVAivaj")
rownames(tabla) <- c("N? de tweets", 
                     "Fecha creaci?n cuenta", 
                     "Media tweets por d?a", 
                     "N? likes a tweets de otros", 
                     "N? cuentas a las que sigue", 
                     "Ratio likes por cada 100 cuentas a las que sigue")

# 2. RED DE SEGUIDORES

recuento_seguidores                  = cuentasGVA_df$followersCount

evol_seguidores_respecto_mesant 

ratio_seguidores_cuentasquesigue     = cuentasGVA_df$followersCount / cuentasGVA_df$friendsCount

recuento_listas_pertenece            = cuentasGVA_df$listedCount

num_medio_seguidores_por_seguidor


