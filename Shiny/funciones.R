
show_tabla <- function(datos, filtro.column = names(datos)) {
    
    res <- DT::datatable(datos[, filtro.column, drop = FALSE], 
                         options = list(
                         lengthMenu = list(c(10, 25, 50, 100, -1), c('10', '25', '50', '100', 'All')),
                         pageLength = 10,
                         scrollX = TRUE)
    )
    return(res)
}



show_columnas <- function(datos,id) {
    checkboxGroupInput(inputId  = id,
                       label    = "Columnas disponibles:",
                       choices  = names(datos), 
                       selected = names(datos))
}

