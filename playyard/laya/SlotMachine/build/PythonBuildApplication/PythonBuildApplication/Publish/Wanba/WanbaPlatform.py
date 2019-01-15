# -*- coding:utf-8 -*-
from Publish.PublishProject import PublishProject
from Common.util import *
from Common.Const import Const
import codecs
class WanbaPlatform(PublishProject):
    def __init__(self,pf,mode, *args, **kwargs):
        super(WanbaPlatform,self).__init__(pf,mode,*args, **kwargs)
        self.wanbaProjectFiles = combineUrl(self.projectFiles,self.platform,self.publishMode)
        self.projectFilesCommonFolder = combineUrl(self.projectFiles,self.platform,'common')
        self.wanbaProjectFilesHtmlTestCodeFolder = combineUrl(self.projectFilesCommonFolder,'htmlTestCode')
        self.buildConfig = combineUrl(self.projectFilesCommonFolder,'BuildConfig.as')
        self.patchFolder = combineUrl(self.wanbaProjectFiles,'patch') 
    def startUp(self, *args, **kwargs):
        super(WanbaPlatform,self).startUp(*args, **kwargs)
        self.initProjectSetting()
        self.layaPublishCMD()
        self.movePublishFilesToWebFolder()
        deleteFile(combineUrl(self.webFolder,'code.js'))
        self.versionInfo = self.setFilesVersion(self.webFolder,['index.html'])
        self.setVersionConfigMD5(self.webFolder)
        self.repalceJSFolder()
        deleteFile(combineUrl(self.webFolder,'js','subpackage'))
    def initProjectSetting(self):
        self.writeBuildCodeVersion()
    def getRootMaxMd5FileName(self):
        return self.getFileMD5Name(self.versionInfo, "Root.max.js")
    def getRootMaxFileSize(self):
        rootFileName = self.getRootMaxMd5FileName()
        fileSize = os.path.getsize(combineUrl(self.webFolder,rootFileName))
        return fileSize
    def replaceHtmlRootMaxInfo(self,indexHtml):
        fileSize = self.getRootMaxFileSize()
        s = codecsReadTextUT8(indexHtml)
        s = re.sub(r'(?<="url": \'Root.max.js\', "size": )\d+', str(fileSize), s) 
        s = s.replace("Root.max.js",self.getRootMaxMd5FileName())
        
        codecsWriteTextUT8(indexHtml,s)

class LocalTestWanba(WanbaPlatform):
    def __init__(self,pf,mode, *args, **kwargs):
        super(LocalTestWanba,self).__init__(pf,mode,*args, **kwargs)
        self.tomcatFolder = r"\\192.168.1.6\www\h5"
        if len(args) > 1:
            self.tomcatFolder = args[1]
        print('tomcatFolder:' + self.tomcatFolder)
    def startUp(self, *args, **kwargs):
        super(LocalTestWanba,self).startUp(*args, **kwargs)
        esprimaJavaScript(self.projectPath,self.webFolder,self.getRootMaxMd5FileName())
        compressJavaScript(self.webFolder,self.getRootMaxMd5FileName())
        self.replaceHtmlRootMaxInfo(combineUrl(self.webFolder,'index.html'))
        self.makePatchFiles(self.md5ConfigPath,self.patchFolder,self.webFolder)
        copyFiles(self.patchFolder,self.tomcatFolder)
        self.commitProjectConfigs()


class PublishWanba(WanbaPlatform):
    def __init__(self, pf,mode,*args, **kwargs):
        super(PublishWanba,self).__init__(pf,mode,*args, **kwargs)
    def startUp(self, *args, **kwargs):
        super(PublishWanba,self).startUp(*args, **kwargs)
        esprimaJavaScript(self.projectPath,self.webFolder,self.getRootMaxMd5FileName())
        compressJavaScript(self.webFolder,self.getRootMaxMd5FileName())
        self.replaceHtmlRootMaxInfo(combineUrl(self.webFolder,'index.html'))
        self.makePatchFiles(self.md5ConfigPath,self.patchFolder,self.webFolder)
        self.commitProjectConfigs()
