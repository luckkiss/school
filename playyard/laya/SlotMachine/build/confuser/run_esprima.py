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

if __name__ == "__main__":
    cmd = 'node esprima.js ../../ ../../bin/h5/ Root.max.js tmp false true true false'
    runCommand(cmd)