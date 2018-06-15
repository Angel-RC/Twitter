# cargamos las librerias
source("R/librerias.R")

# cargamos datos de ventas de casas en Corvallis
load("dataset/sales.RData")
load("dataset/wards_sales.RData")

# vemos las localizaciones de los datos con ggplot
ggplot() +   geom_point(aes(lon, lat), data = sales)

# definimos una localizacion
corvallis <- c(lon = -123.2620, lat = 44.5646)

# conseguimos el mapa desde Google maps
mapa.corvallis <- get_map(location = corvallis,
                zoom = 13,
                maptype = "terrain",
                scale = 1)

# dibujamos el mapa
ggmap(mapa.corvallis)

# ahora juntamos ambas vistas (mezclando ggplot y gg_map)
ggmap(mapa.corvallis) +  geom_point(aes(lon, lat), data = sales)

# otra forma de juntarlas es mediante base_layer
ggmap(mapa.corvallis, base_layer = ggplot(sales, aes(lon, lat))) +  geom_point()

# añadiremos mas variables para conocer mejor nuestros datos
ggmap(mapa.corvallis) +  geom_point(aes(lon, lat, color = year_built), data = sales)

# para dibujar un mapa por cada tipo de casa
ggmap(mapa.corvallis,
      base_layer = ggplot(sales, aes(lon, lat, color = class))) +
  geom_point() + 
  facet_wrap(~class)

# para dibujar poligonos
# geom_path une los puntos en orden del data.frame si son del mismo grupo
ggplot(wards_sales, aes(lon, lat)) +
  geom_path(aes(group = group))

# para hacer poligonos y colorear en funcion de una variable
ggplot(wards_sales, aes(lon, lat)) +
  geom_polygon(aes(group = group, fill = ward))


# para juntarlo con el mapa
ggmap(mapa.corvallis,
      base_layer = ggplot(wards_sales,
                          aes(lon, lat))) +
  geom_polygon(aes(group = group, fill = ward))








