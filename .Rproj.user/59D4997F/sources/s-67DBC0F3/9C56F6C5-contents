
# Usuarios de interes
users = c("generalitat",
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
# Agrupacion de las cuentas
grupos = c("Generalitat",
           "Palau",
           "Inclusion_igualdad",
           "Hacienda",
           "Justicia",
           "Educacion_cultura_deporte",
           "Educacion_cultura_deporte",
           "Sanidad",
           "Economia",
           "Agroambiente",
           "Habitage",
           "Transparencia",
           "Servef",
           "Aivaj")

usuarios <- tibble(users, grupos)

mes               <- month(Sys.Date())
dias.mes.anterior <- days_in_month(mes-1)
primer.dia.mes    <- floor_date(Sys.Date(), "month")

# Ciudades en las que estan disponibles los trends junto con su id
#locs <- availableTrendLocations()
#
## Id de España y Valencia
#locsSpain  <- subset( locs, country == "Spain")
#idSpain    <- subset( locsSpain, name == "Spain")$woeid
#idValencia <- subset( locsSpain, name == "Valencia")$woeid



tweets.necesarios      <- 1000    # Tweets necesarios para ser considerado usuario activo
seguidores.necesarios  <- 10000   # Seguidores necesarios para ser considerado influyente


# Numero de seguidores que añadir en las listas top de activos e influyentes
top.activos      <- 20
top.influyentes  <- 20
top.retweeteados <- 20
top.usuarios     <- 20