import sys
import datetime
import tushare as ts
import json

ts.set_token('ee00561a7b96f2e6a6a8fb19677b4017f6c47f794b2893287fe8f417')
pro = ts.pro_api()

data = pro.stock_basic(exchange='', list_status='L', fields='ts_code,symbol,name,area,industry,list_date')
data.to_csv('stock_basic.csv')

