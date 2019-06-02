import sys
import datetime
import tushare as ts
import json

arg_cnt = len(sys.argv)
if arg_cnt == 1:
    print(sys.argv)
    print('code required, for example: 000001.SZ')
    exit(1)
code = sys.argv[1]  # like 000001.SZ
if arg_cnt > 2:
    sdate = sys.argv[2]  # like 20190101
else:
    sdate = datetime.datetime.now().strftime('%Y0101')

if arg_cnt > 3:
    edate = sys.argv[3]  # like 20190101
else:
    edate = datetime.datetime.now().strftime('%Y%m%d')

print('code=%s, start_date=%s, end_date=%s' % (code, sdate, edate))

ts.set_token('ee00561a7b96f2e6a6a8fb19677b4017f6c47f794b2893287fe8f417')
pro = ts.pro_api()

df = ts.pro_bar(ts_code=code, adj='qfq', start_date=sdate, end_date=edate)
df.to_csv(code + '.csv')

data_arr = []
with open(code + '.csv', 'r') as f:
	lines = f.readlines()
	for i in range(1, len(lines)):
		line = lines[i].split(',')
		trade_date = line[2]
		trade_date = trade_date[0:4] + '/' + str(int(trade_date[4:6])) + '/' + str(int(trade_date[6:]))
		open_price = line[3]
		close_price = line[6]
		low_price = line[5]
		high_price = line[4]
		data_arr.append((trade_date, float(open_price), float(close_price), float(low_price), float(high_price)))

data_arr = data_arr[::-1]
data_str = json.dumps(data_arr)

with open('tmpl.html', 'r', encoding='UTF-8') as f:
	html_content = f.read()
	html_content = html_content.replace('<stock_code>', code).replace('<data_str>', data_str)
	with open(code + '.html', 'w', encoding='UTF-8') as fw:
	    fw.write(html_content)

