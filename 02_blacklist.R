### blacklist of logs
log_blacklist <- trade_log_map[rowkey %in% trade[is_risk == 1]$rowkey]
log_blacklist <- merge(log_blacklist,
                       log_blacklist[, .(latest_time = max(timestamp_login)), by = rowkey],
                       by.x = c('rowkey', 'timestamp_login'),
                       by.y = c('rowkey', 'latest_time'))
log_blacklist <- merge(log_blacklist,
                       login[, .(log_id, device, ip)],
                       by = 'log_id')

ip_blacklist <- log_blacklist[, .(timestamp = min(timestamp_trade)), by = ip]
device_blacklist <- log_blacklist[, .(timestamp = min(timestamp_trade)), by = device]
setkey(ip_blacklist, ip, timestamp)
setkey(device_blacklist, device, timestamp)
remove(log_blacklist, trade_log_map)
