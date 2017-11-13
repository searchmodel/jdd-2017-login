library(compiler)
setkey(login, id)
setorder(login, id, -timestamp)
setkey(trade, id)
setorder(trade, id, -timestamp)
## logging vars
derived_vars <- Vectorize(cmpfun(row_key) {
    trade_info <- trade[rowkey == row_key]

    ### last login
    login_info <- login[id == trade_info$id]

})
