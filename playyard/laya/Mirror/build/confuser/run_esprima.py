# -*- coding:utf-8 -*-
import os
import execjs
import json
import codecs
import subprocess

def runCommand(s):
    print("command:" + s)
    p = subprocess.Popen(s, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.STDOUT, shell = False)
    print(p.communicate()[0].decode('gbk', errors='ignore'))
    print("returncode: " + str(p.returncode))
    return p
def codecsReadTextUT8(path):
    f = codecs.open(path,'r', 'utf-8')
    txt = f.read()
    f.close()
    return txt
def codecsWriteTextUT8(path,content):
    f = codecs.open(path, 'w', 'utf-8')
    f.write(content)
    f.close()
    
def getFileBaseName(path): 
    return os.path.splitext(os.path.basename(path))[0]
def getFileExtension(path): 
    return os.path.splitext(path)[1] 
    
def formatPath(path):
    return path.replace('\\','/')
def combineUrl(*parts):
    url = ''
    cnt = len(parts)
    for i in range(cnt - 1):
        p = parts[i]
        url = url + p
        if not p.endswith('/'):
            url = url + '/'
    url = url + parts[cnt - 1]
    url = formatPath(url).replace('//','/')
    return url
    
def copyFile(src,dst):
    open(dst, "wb").write(open(src, "rb").read())   
    
def compressJavaScript(path,jsFile,nomangle=False):
    if not path.endswith('/') or not path.endswith('\\'):
       path = path + '/'
    filePath = combineUrl(path,jsFile)
    if not os.path.exists(filePath):
       print('compressJavaScript:' + filePath + ' file do not exists')
       return
    uglifyjsExe = '\"' + os.getenv('APPDATA') + '\\npm\\uglifyjs.cmd' + '\"'
    srcJs = path + jsFile
    output = path + jsFile.replace(getFileExtension(jsFile),"") + '_uglifyjs_temp_file.js'
    op = ' --compress --mangle --output '
    if nomangle == True:
       op = ' --compress --output '
    cmd = uglifyjsExe + op + output + ' -- ' + srcJs
    runCommand(cmd)
    copyFile(output,srcJs)

if __name__ == "__main__":   
    # 因uglifyjs会将computed member expression改为普通的，可能导致一些字符串literal被变成identifier，所以得先混淆，防止literal被混淆掉，比如.ls这些类型名
    cmd = 'node esprima.js ../../ ../../bin/h5/ Root.max.js ~ tmp false false true c'
    runCommand(cmd)
    
    compressJavaScript('../../bin/h5/', 'Root.max.js')
    
    cmd = 'node esprima.js ../../ ../../bin/h5/ Root.max.js ~ tmp false false true i'
    runCommand(cmd)