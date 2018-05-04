
# nombre de la app
appname <- "R en Twitter"
# api key
key <- "NvzzcGwdz7Y8Be9AcCzLpkL3l"
# api secret 
secret <- "Mn8kf4a8NWw2eEGoDlPEPVSugXLx6h3jN3c6BlW82vmYRGwXuc"
# generamos los token
twitter_token <- create_token( app             = appname,
                               consumer_key    = key,
                               consumer_secret = secret)

# Permisos para usar la API de Twitter
setup_twitter_oauth( consumer_key    = key,
                     consumer_secret = secret,
                     access_token    = twitter_token$credentials$oauth_token,
                     access_secret   = twitter_token$credentials$oauth_token_secret )




