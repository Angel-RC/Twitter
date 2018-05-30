
mostrar_datos <- function(datos, filtro.column) {
    
    res <- DT::datatable(datos[, filtro.column, drop = FALSE], 
                         options = list(
                         lengthMenu = list(c(10, 25, 50, 100, -1), c('10', '25', '50', '100', 'All')),
                         pageLength = 10)
    )
    
    return(res)
}

