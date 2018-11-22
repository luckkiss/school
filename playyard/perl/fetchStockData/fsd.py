import urllib.request
import re
import os
import codecs

def downback(a,b,c):
##    ''''
##    a:已经下载的数据块
##    b:数据块的大小
##    c:远程文件的大小
##   '''
    per = 100.0 * a * b / c
    if per > 100 :
        per = 100
    print('%.2f%%' % per)

stock_CodeUrl = 'http://quote.eastmoney.com/stocklist.html'

# fetch all stock list
def urlTolist(url):
    allCodeList = []
    html = urllib.request.urlopen(url).read()
    html = html.decode('gbk')
    s = r'<li><a target="_blank" href="http://quote.eastmoney.com/\S\S(.*?).html">'
    pat = re.compile(s)
    code = pat.findall(html)
    for item in code:
        if item[0]=='6' or item[0]=='3' or item[0]=='0':
            allCodeList.append(item)
    return allCodeList
    
allCodelist = urlTolist(stock_CodeUrl)

savePath = '..\\..\\laya\\KLine\\bin\\h5\\res\\data'
tmpSavePath = savePath + '\\tmp'
if not os.path.exists(savePath): 
    os.makedirs(savePath)
if not os.path.exists(tmpSavePath): 
    os.makedirs(tmpSavePath)
for code in allCodelist:
    print('fatching code data of %s...' % code)
    if code[0]=='6':
        url = 'http://quotes.money.163.com/service/chddata.html?code=0'+code+\
        '&end=20161231&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP'
    else:
        url = 'http://quotes.money.163.com/service/chddata.html?code=1'+code+\
        '&end=20161231&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP'
    urllib.request.urlretrieve(url, tmpSavePath + '\\' + code + '.csv')
    
for root, dirs, files in os.walk(tmpSavePath):
    for file_name in files:
        src_file_name = os.path.join(root, file_name)
        
        f = codecs.open(src_file_name, 'r', 'gb2312')
        s = f.read()
        f.close()
        
        file_arr = os.path.splitext(file_name)
        saveFileName = savePath + '\\' + file_arr[0] + '.csv'
        f = codecs.open(saveFileName, 'w', 'utf-8')
        f.write(s)
        f.close()

print('all finished!')