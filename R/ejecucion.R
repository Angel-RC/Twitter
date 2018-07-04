#
# Autor: Angel Y Lara 
# Date:  19/12/2017
# 
# A lo largo del codigo aparecera la etiqueta #TO.DO cuando parte del codigo necesite ser revisado


# Inicializamos todo lo necesario
source("R/librerias.R")
source("R/inicio_twitter.R")
source("R/variables_globales.R")
source("R/funciones.R")

# Fase 1. Extraccion de datos desde la api
source("R/extraccion_cuentas.R")
source("R/extraccion_tweets.R")
source("R/extraccion_seguidores.R")
source("R/extraccion_menciones.R")

# Fase 2. Obtenemos informacion desde los datos ya obtenidos
source("R/informacion_cuentas.R")
source("R/informacion_tweets.R")
source("R/informacion_seguidores.R")
source("R/informacion_menciones.R")

# Fase 3. Realizamos el informe
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



