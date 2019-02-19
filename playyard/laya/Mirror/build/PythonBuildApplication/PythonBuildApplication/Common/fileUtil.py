# -*- coding:utf-8 -*-
import os
import re
import codecs
import shutil
import hashlib

def md5(s):
    return hashlib.md5(s).hexdigest()

class FileUtil:
    @staticmethod
    def findFiles(basepath, ext=''):
        rfiles = []
        for root, dirs, files in os.walk(basepath):
            for file in files:
                if ext != '' and re.search(r'\.(' + ext + r')$', file, re.IGNORECASE) == None: continue
                rfiles.append(root + os.sep + file)
        return rfiles
    @staticmethod
    def write(fname, s):
        with open(fname,'w') as f:
            f.write(s)
    @staticmethod
    def cwrite(filePath,u,encoding="utf_8_sig"):
        with codecs.open(filePath,"w",encoding) as f:
            f.write(u)
    @staticmethod
    def read(fname, mod='rb'):
        with open(fname, mod) as f:
            return f.read()
    @staticmethod
    def makeDirsIfNoExists(path):
        if not os.path.exists(path):
            os.makedirs(path)
    @staticmethod
    def makeFileIfNoExists(path):
        if os.path.exists(path): 
            return
        FileUtil.makeDirsIfNoExists(os.path.dirname(path))
        FileUtil.write(path, '')
    @staticmethod
    def xcp(srcpath, despath, ext=''):
        files = FileUtil.findFiles(srcpath, ext)
        print('copy files count:' + str(len(files)))
        for f in files:
            df = f.replace(srcpath, despath)
            ddir = os.path.dirname(df)
            if not os.path.exists(ddir):
                os.makedirs(ddir)
            shutil.copy(f, df)
        print('copy finished!')
    @staticmethod
    def exists(path):
        return os.path.exists(path)
    @staticmethod
    def getsize(path):
        return os.path.getsize(path)
    @staticmethod
    def filesHash(path, base, ext):
        files = FileUtil.findFiles(path, ext)
        files.sort()
        base = base.replace('\\', '/')
        m = ''
        for f in files:
            f = f.replace('\\', '/')
            m = m + f[f.find(base):] + md5(FileUtil.read(f, 'rb'))
        return md5(m.encode('utf8'))
    @staticmethod
    def fileHash(file):
        return md5(FileUtil.read(file, 'rb'))
    @staticmethod
    def cread(fname, mod='rb',encoding="utf8"):
        try:
            with codecs.open(fname,mod,encoding) as f:
                return f.read()
        except Exception as e:
            print('FileUtil cread:' + fname + ',error:' + str(e))
            return None