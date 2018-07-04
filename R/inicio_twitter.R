
# nombre de la app
appname <- "R en Twitter"
# api key
key     <- "LbNF0Fe3dWqFnEHhmqVr0NaGT"
# api secret 
secret  <- "k4kYkU3ZfwcO0nTKWP55F5VgU3s7CwF8yFq2V5xcEoffTNJ9hU"

# generamos los token
twitter_token <- create_token( app             = appname,
                               consumer_key    = key,
                               consumer_secret = secret)

# Permisos para usar la API de Twitter
setup_twitter_oauth( consumer_key    = key,
                     consumer_secret = secret,
                     access_token    = twitter_token$credentials$oauth_token,
                     access_secret   = twitter_token$credentials$oauth_token_secret)




 