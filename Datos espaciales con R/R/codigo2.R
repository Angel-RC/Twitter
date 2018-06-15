
# extraemos un mapa de europa
mymap <- gmap("Europe")
plot(mymap)

# selecciono la región que me interesa
select.area <- drawExtent()

# vuelvo a buscar el mapa para la zona que me interesa
mymap <- gmap(select.area)
plot(mymap)+geom_point(aes(lon, lat), data = sales)
