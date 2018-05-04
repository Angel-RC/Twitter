# Aqui esta todo el codigo necesario para extraer informacion de Twitter
#
# Autor: Angel Y Lara
# Date:  19/12/2017
# 
# A lo largo del codigo aparecera la etiqueta #TO.DO cuando parte del codigo necesite ser revisado

source("librerias.R")
source("inicio_twitter.R")
source("funciones.R")
source("variables_globales.R")

# Obtenemos los trending topic de esa zona
trendsValencia <- getTrends( woeid = idValencia)
write.xlsx( trendsValencia,"trendsValencia.xls")

tweets.hashtag <- obtener_menciones(Hashtags,10)

tweets.menciones <- do.call(rbind, tweets.hashtag)  %>% distinct

tweets.menciones <- identificamos_origen (tweets.menciones, 8, Hashtags, tweets.hashtag, 8)




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


