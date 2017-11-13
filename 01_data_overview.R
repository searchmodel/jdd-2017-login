library(data.table)
rm(list = ls())

trade <- fread('data/t_trade.csv',
               colClasses = c(
                   rowkey = 'integer',
                   id = 'integer',
                   is_risk = 'integer'
               ))
login <- fread('data/t_login.csv',
               colClasses = c(
                   log_id = 'character',
                   timelong = 'integer',
                   device = 'integer',
                   log_from = 'integer',
                   ip = 'integer',
                   is_scan = 'logical',
                   is_sec = 'logical'
               ))

Sys.setenv(TZ = 'Asia/Shanghai')
invisible(trade[, time := as.POSIXct(time, format = '%Y-%m-%d %H:%M:%OS')])
invisible(trade[, timestamp := as.integer(time)])
invisible(login[, time := as.POSIXct(time, format = '%Y-%m-%d %H:%M:%OS')])
invisible(login[, timestamp := as.integer(time)])

# library(RMySQL)
# conx <- dbConnect(MySQL(), "jd_risk_detect",
#                   user = "siyuany",
#                   password = "Ysy1989..")
# dbWriteTable(conx, name = "trade", value = trade)
# dbWriteTable(conx, name = "login", value = login)
# dbDisconnect(conx)

trade_log_map <-
    merge(trade[, .(rowkey, id, timestamp)], login[, .(log_id, id, timestamp)],
          by = 'id', all.x = TRUE, allow.cartesian = TRUE,
          suffixes = c('_trade', '_login'))
trade_log_map <- trade_log_map[timestamp_trade >= timestamp_login]
setorder(trade_log_map, rowkey, id, timestamp_trade, timestamp_login)
