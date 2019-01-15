import re, subprocess, shlex, platform
from Common.util import *

svntool = r'svn'

def add(svnPath):
    return execCmd(svntool + ' add ' + svnPath)

def addUnversioned(svnPath):
    return execCmd(svntool + ' add --force --parents --no-ignore ' + svnPath)

def update(svnPath):
    return execCmd(svntool + ' up ' + svnPath)

def getVersion(svnPath):
    command=svntool + " log "+ svnPath + ' -l 1'
    info = execCmd(command)
    return re.search('r(\d+)', info).group(1)

def commit(svnPath, message):
    cmd = svntool + ' ci ' + svnPath + ' -m "' + message + '"'
    print (cmd)
    return execCmd(cmd)

def revert(svnPath):
    cmd = svntool + ' revert ' + svnPath + ' -R'
    print (cmd)
    return execCmd(cmd)
    
def cleanup(svnPath):
    cmd = svntool + ' cleanup ' + svnPath
    print (cmd)
    return execCmd(cmd)
    
def cleanupunversioned(svnPath):
    cmd = svntool + ' cleanup ' + svnPath + ' --remove-unversioned' 
    print (cmd)
    return execCmd(cmd)

def copy(src, dst, msg, add) :
    cmd = svntool + ' copy --parents ' + src + ' ' + dst + ' -m "' + msg + '"' + ' ' + add
    print (cmd)
    return execCmd(cmd)
    
def delete(src, msg, add) :
    cmd = svntool + ' delete ' + src + ' -m "' + msg + '"' + ' ' + add
    print (cmd)
    return execCmd(cmd)
    
def lock(src) :
    cmd = svntool + ' lock ' + src
    print (cmd)
    return execCmd(cmd)
    
def unlock(src) :
    cmd = svntool + ' unlock ' + src
    print (cmd)
    return execCmd(cmd)

def execCmd(cmd):
    print('cmd:' + cmd)
    if platform.system().find('Windows') < 0: cmd = shlex.split(cmd)
    p = subprocess.Popen(cmd, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, shell = False)
    stdout, stderr = p.communicate()
    if p.returncode != 0: raise Exception(stderr.decode('UTF-8', errors='ignore')) 
    return stdout.decode('UTF-8', errors='ignore')

