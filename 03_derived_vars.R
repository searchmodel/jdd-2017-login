library(compiler)
library(lubridate)

setkey(login, id)
setorder(login, id, -timestamp)
setkey(trade, id)
setorder(trade, id, -timestamp)
## logging vars
derived_vars <- cmpfun(Vectorize(function(row_key) {
    trade_info <- trade[rowkey == row_key]

    ### historical login
    login_info <- login[id == trade_info$id &
                        timestamp <= trade_info$timestamp]

}))
