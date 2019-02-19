# -*- coding:utf-8 -*-
import hashlib
import subprocess
import os
import time
import shlex
import platform
import json
import shutil
import codecs
import re
import Common.LogParser
import sys
import base64
from PIL import Image
def md5(s):
    return hashlib.md5(s).hexdigest()
def runCommand(s,encode='UTF-8',errorFunc=None):
    print("command:" + s)
    p = subprocess.Popen(s, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.STDOUT, shell = False)
    log = p.communicate()[0].decode(encode, errors='ignore')
    print(log)
    Common.LogParser.checkError(str(log))
    if Common.LogParser.error() == True:
        if errorFunc != None:
            errorFunc()
        sys.exit(1)
def syscall(s, successMsg='', forceExec=False, needStdOut=False):
    print('cmd:' + s)
    if platform.system().find('Windows') < 0: s = shlex.split(s)
    p = subprocess.Popen(s, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, shell = False)
    stdout, stderr = p.communicate()
    if p.returncode != 0:
        if needStdOut: print(stdout.decode('UTF-8', errors='ignore'))
        print(stderr.decode('UTF-8', errors='ignore'))
        if forceExec: return 'error: cmd exec failed'
        exit(1)
    if successMsg != '': print(successMsg)
    return stdout.decode('UTF-8', errors='ignore')
def mangleImage(path):
    #修改0,0像素的RGB值
    img = Image.open(path)    
    if img.mode not in ('RGB','RGBA'):    
        img = img.convert('RGBA')   
    arr = img.getpixel((0, 0))
    r,g,b,a = (0,0,0,0)
    if len(arr) == 3:
        r, g, b = img.getpixel((0, 0)) 
    else:
        r, g, b,a = img.getpixel((0, 0)) 
    newb = 0
    if b == 255:
        newb = 254
    else:
        newb = b + 1
    if len(arr) == 3:
        img.putpixel((0, 0),(r,g,newb))
    else:
        img.putpixel((0, 0),(r,g,newb,a))
    img.save(path)
#def combinedir(path, *paths):
#    return os.path.abspath(combineUrl(path, *paths))
def getModifyTime(f):
    statinfo = os.stat(f)
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(statinfo.st_mtime))
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
def writeText(path,content):
    f = open(path,'w')
    f.write(content)
    f.close()
def readText(path):
    f = open(path,'r')
    txt = f.read()
    f.close()
    return txt
def codecsReplaceContentUT8(fileName,pattern,repl):
    s = codecsReadTextUT8(fileName)
    s = re.sub(pattern, repl, s)
    codecsWriteTextUT8(fileName,s)
def codecsReadTextUT8(path):
    f = codecs.open(path,'r', 'utf-8')
    txt = f.read()
    f.close()
    return txt
def codecsWriteTextUT8(path,content):
    f = codecs.open(path, 'w', 'utf-8')
    f.write(content)
    f.close()
def removeKeyWords(jsFilePath):
    s = codecsReadTextUT8(jsFilePath)
    s = re.sub(r'KW\.[\w|\_|\d]+\s?=\s?\d+;\s*', '', s) 
    s = re.sub(r'Macros\.[\w|\_|\d]+\s?=\s?\d+;\s*', '', s) 
    s = re.sub(r'ErrorId\.[\w|\_|\d]+\s?=\s?\d+;\s*', '', s)
    # 删除表格结构定义
    # s = re.sub(r"\/\/class automatic\.cfgs\.(\n|.)*?\}\)\(\)", "", s)
    
    codecsWriteTextUT8(jsFilePath,s)
def esprimaJavaScript(projPath,webPath,jsFile,jsonNames='~',workMode='c',useConfuseRecord=False):
    if not webPath.endswith('/') or not webPath.endswith('\\'):
       webPath = webPath + '/'
    # 允许传入以逗号分隔的多个文件名
    jsFileArr = re.split(r',\s*',jsFile)
    for jf in jsFileArr:
        filePath = combineUrl(webPath,jf)
        if not os.path.exists(filePath):
           print('esprimaJavaScript:' + filePath + ' file do not exists')
           return
        #先将keyword等常量删除
        removeKeyWords(filePath)    
    #使用esprima将函数和变量名进行混淆
    confuseWorkFolder = 'confuserTmp'
    if not os.path.exists(confuseWorkFolder):
        os.mkdir(confuseWorkFolder)
    esprimaCmd = 'node build\\confuser\\esprima.js ' + projPath + ' ' + webPath + ' ' + jsFile + ' ' + jsonNames + ' ' + confuseWorkFolder
    if useConfuseRecord:
        esprimaCmd += ' true'
    else:
        esprimaCmd += ' false'
    esprimaCmd += ' true true ' + workMode
    syscall(esprimaCmd)
def compressJavaScript(path,jsFile,nomangle=False):
    if not path.endswith('/') or not path.endswith('\\'):
       path = path + '/'
    filePath = combineUrl(path,jsFile)
    if not os.path.exists(filePath):
       print('compressJavaScript:' + filePath + ' file do not exists')
       return
    uglifyjsExe = '\"' + os.getenv('APPDATA') + '\\npm\\uglifyjs.cmd' + '\"'
    srcJs = path + jsFile#'js\subpackage\package_sub.js'
    output = path + jsFile.replace(getFileExtension(jsFile),"") + '_uglifyjs_temp_file.js'#'js\subpackage\package_sub_min.js'
    op = ' --compress --mangle --output '
    if nomangle == True:
       op = ' --compress --output '
    cmd = uglifyjsExe + op + output + ' -- ' + srcJs
    runCommand(cmd)
    os.remove(srcJs)
    os.rename(output,srcJs)
def getFileBaseName(path): 
    return os.path.splitext(os.path.basename(path))[0]
def getFileExtension(path): 
    return os.path.splitext(path)[1] 
def copyFileToFolder(file,src,dst):
    copyFile(combineUrl(src,file),combineUrl(dst,file))
def copyFile(src,dst):
    createFolder(os.path.dirname(dst))
    #if not os.path.exists(src):
    #    print('No such file or directory src:' + src + ';')
    #if not os.path.exists(dst):
    #    print('No such file or directory dst:' + dst + ';')
    open(dst, "wb").write(open(src, "rb").read())    
def moveFiles(src,dst):
    createFolder(os.path.dirname(dst))
    shutil.move(src,dst)
def copyFiles(src,dst):
    for f in os.listdir(src):   
        srcPath = combineUrl(src, f)  
        dstPath = combineUrl(dst, f)   
        if os.path.isfile(srcPath):   
            #创建目录
            if not os.path.exists(dst): 
                os.makedirs(dst)   
            copyFile(srcPath,dstPath)
        if os.path.isdir(srcPath):   
            copyFiles(srcPath, dstPath)   
def deleteFile(path):
    if not os.path.exists(path):
        return
    if os.path.isfile(path):
        os.remove(path)
        return
    filelist = []
    rootdir = path
    filelist = os.listdir(rootdir)
    for f in filelist:
        filepath = combineUrl(rootdir, f)
        if os.path.isfile(filepath):
            os.remove(filepath)
        elif os.path.isdir(filepath):
            shutil.rmtree(filepath,True)
def createFolder(path):
    if not os.path.exists(path) and path != '':
        os.makedirs(path)  
def getMD5(filename):
    if not os.path.isfile(filename):
        return
    myhash = hashlib.md5()
    f = open(filename,'rb')
    while True:
        b = f.read(8096)
        if not b :
            break
        myhash.update(b)
    f.close()
    return myhash.hexdigest().lower()
def getBase64Str(key):
    encodestr = base64.b64encode(key.encode('utf-8'))
    rkey = (str(encodestr,'utf-8'))
    return rkey