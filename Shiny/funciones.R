
show_tabla <- function(datos, fijar = 0) {
    
    res <- DT::datatable(select_if(datos,negate(is.list)), 
                         rownames   = FALSE,
                         extensions = c('ColReorder',
                                        'Buttons',
                                        'FixedColumns',
                                        'FixedHeader',
                                        'Scroller'),
                         
                         options    = list(
                                           fixedHeader  = TRUE,
                                           dom          = 'Bfrtip',
                                           fixedColumns = list(leftColumns = fijar),
                                           pageLength   = 300,
                                           scrollY      = "500px",
                                           scrollX      = TRUE,
                                           colReorder   = TRUE,
                                           buttons = list('colvis','copy', list(extend  = 'collection',
                                                                                buttons = c('csv', 'pdf'),
                                                                                text    = 'Download'))
                                           )
    )
    return(res)
}






