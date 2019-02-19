# -*- coding:utf-8 -*-
from Publish.Weixin.WeixinPlatform import PublishWeixin
from Common.util import *
import base64

class WeixinXinghan(PublishWeixin):
    def __init__(self, pf,mode,*args, **kwargs):
        super(WeixinXinghan,self).__init__(pf,mode,*args, **kwargs)
        self.jsonNames = ''
    def mangleImages(self):
        super(WeixinXinghan,self).mangleImages()
        for root, dirs, files in os.walk(self.webFolder):
            for fileName in files:
                ext = getFileExtension(fileName).lower()
                if ext == '.jpg' or ext == '.png':
                    path = (combineUrl(root,fileName))
                    mangleImage(path)
    def mangleJsons(self):
        super(WeixinXinghan,self).mangleJsons()
        for root, dirs, files in os.walk(self.webFolder):
            for fileName in files:
                ext = getFileExtension(fileName).lower()
                if ext == '.atlas' or ext == '.lh' or ext == '.lmat' or ext == '.ls' or ext == '.lav':
                    path = (combineUrl(root,fileName))
                    content = codecsReadTextUT8(path)
                    content+=" "
                    codecsWriteTextUT8(path,content)
    def mangleVersion(self):
        path = combineUrl(self.webFolder, 'version.json')
        content = codecsReadTextUT8(path)
        result = {}
        config = json.loads(content)
        for key in config:
            rkey = getBase64Str(key)
            result[rkey] = config[key]
        codecsWriteTextUT8(path,json.dumps(result))
    def mangleFilesName(self):
        excludeList = self.keepNameRealList()
        folder = self.webFolder
        for root, dirs, files in os.walk(folder):
            for fileName in files:
                exclude = fileName in excludeList
                fileArr = os.path.splitext(fileName)
                fileFullPath = combineUrl(root, fileName)
                relativePath = fileFullPath.replace(folder + '/','')
                fileMangleName = ""
                if not exclude:
                    fileMangle = getBase64Str(fileArr[0])
                    fileMangleName = fileMangle + fileArr[1]
                    fileVCFullPath = combineUrl(root, fileMangleName)
                    deleteFile(fileVCFullPath)
                    os.rename(fileFullPath,fileVCFullPath)
                    if re.match('total\d\.json', fileName) or re.match('total\w{6}\.json', fileName):
                        if self.jsonNames != '':
                            self.jsonNames += ','
                        self.jsonNames += fileMangle
    def repalceJSFolder(self):
        super(WeixinXinghan,self).repalceJSFolder()
        copyFiles(combineUrl(self.wxProjectFiles,'xhsdk'),combineUrl(self.webFolder,'xhsdk'))
    def writeVersion(self):
        self.gameJs = combineUrl(self.wxPublishProjectFolder,'game.js')
        codecsReplaceContentUT8(self.gameJs,r'window.xhsdk={}',r"window.xhsdk={}\nwindow.xhsdk.version=" + "\"" + self.getShowProjectVersionText() + "\"")
    def getWxprojcetFolder(self):
        return super(WeixinXinghan,self).getWxprojcetFolder() + ['xhsdk']
    def commitWeixinCode(self):
        if self.debug == True:
            return
        print("WeixinXinghan commit:",self.projectReleaseVersion)
        self.writeVersion()
        super(WeixinXinghan,self).commitWeixinCode()
    def compressSpeciallyJS(self):
        esprimaJavaScript(self.projectPath,self.webFolder,'code.js,js\subpackage\package_sub.js',self.jsonNames)
        super(WeixinXinghan,self).compressSpeciallyJS()
        esprimaJavaScript(self.projectPath,self.webFolder,'code.js,js\subpackage\package_sub.js',self.jsonNames,'i')
         
