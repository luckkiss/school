# -*- coding:utf-8 -*-
from Publish.PublishProject import PublishProject
from Common.util import *
from Common.Const import Const
from Common.svn import *
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
        self.zipAtlas(self.binH5Path)
        self.layaPublishCMD()
        self.checkPublishFilesInvalidName()
        self.movePublishFilesToWebFolder()
        deleteFile(combineUrl(self.webFolder,'code.js'))
        self.setWanbaIndexHtml()
        # 在打md5之前执行一些可能修改文件的操作，比如混淆
        self.beforeSetFilesVersion()
        self.versionInfo = self.setFilesVersion(self.webFolder,['index.html'])
        self.setVersionConfigMD5(self.webFolder)
        self.repalceJSFolder()
        deleteFile(combineUrl(self.webFolder,'js','subpackage'))
        self.copyWebFiles()
        self.repalceImageFolder()
        self.replaceBackgroundInfo()
        
    def beforeSetFilesVersion(self):
        compressJavaScript(self.webFolder, 'Root.max.js')

    def setWanbaIndexHtml(self):
        copyFile(combineUrl(self.projectFilesCommonFolder,'index_wanba.html'),combineUrl(self.webFolder,'index.html'))
        projectName = self.readProjectName(self.buildConfig)
        print('projectName = ' + projectName)
        if not projectName == '':
            self.replaceProjectName(combineUrl(self.webFolder,'index.html'),projectName)
        svrlistUrl = self.readSvrlistUrl(self.buildConfig)
        print('svrlist_url = ' + svrlistUrl)
        if not svrlistUrl == '':
            self.replaceSvrlistUrl(combineUrl(self.webFolder,'index.html'),svrlistUrl)
    def readProjectName(self,srcConfig):
        s = codecsReadTextUT8(srcConfig)
        searchObj = re.search(r'public const gamename:String = "(.+)";', s)
        if searchObj:
            return searchObj.group(1)
        else:
            return ''
    def readSvrlistUrl(self,srcConfig):
        s = codecsReadTextUT8(srcConfig)
        searchObj = re.search(r'public const svrurl:String = "(.+)";', s)
        if searchObj:
            return searchObj.group(1)
        else:
            return ''
    def replaceProjectName(self,indexHtml,name):
        s = codecsReadTextUT8(indexHtml)
        s = s.replace("<title>凡仙H5</title>","<title>" + name + "</title>")
        codecsWriteTextUT8(indexHtml,s)
    def replaceSvrlistUrl(self,indexHtml,newUrl):
        s = codecsReadTextUT8(indexHtml)
        s = re.sub(r"(?<=mcParams.defaultSvrListUrl = ').+(?=')", newUrl + "svrlist.php", s)
        codecsWriteTextUT8(indexHtml,s)
    def initProjectSetting(self):
        deleteFile(self.projectModuleConfig)
        copyFile(self.buildConfig,self.buildConfigCode)
        self.writeBuildCodeVersion()
    def getRootMaxMd5FileName(self):
        return self.getFileMD5Name(self.versionInfo, "Root.max.js")
    #def replaceHtmlContent(self):
    #    rootFileName = self.getRootMaxMd5FileName()
    #    fileSize = os.path.getsize(combineUrl(self.webFolder,rootFileName))
    #    self.replaceRootMaxInfo(self.webFolder, rootFileName, 'index.html',
    #    fileSize)
    #    self.replaceBackgroundInfo()
    #def replaceRootMaxInfo(self, dst, rootMaxJsName, htmlFileName, jsSize):
    #    indexHtml = combineUrl(dst,htmlFileName)
    #    if os.path.exists(indexHtml) and rootMaxJsName != "":
    #        print('change root ver: ' + indexHtml + ' as ' + rootMaxJsName)
    #        s = codecsReadTextUT8(indexHtml)

    #        if jsSize > 0:
    #            s = re.sub(r'(?<="url": \'Root.max.js\', "size": )\d+',
    #            str(jsSize), s) #Root.max.js的md5
    #        s = s.replace("Root.max.js",rootMaxJsName) #Root.max.js的md5
    #        codecsWriteTextUT8(indexHtml,s)
    def replaceBackgroundInfo(self):
        serverListCSS = combineUrl(self.webFolder,'js','serverList.css')
        s = codecsReadTextUT8(serverListCSS)
        
        bgMD5Name = self.getFileMD5Name(self.versionInfo, "res/login/008.jpg")
        print('replaceBackgroundInfo bg',serverListCSS,bgMD5Name)
        s = s.replace("res/login/008.jpg", bgMD5Name) #008.jpg的md5
        
        giftBarMD5Name = self.getFileMD5Name(self.versionInfo, "ui/loading/giftBar.png")
        print('replaceBackgroundInfo giftBar',serverListCSS,giftBarMD5Name)
        s = s.replace("ui/loading/giftBar.png", giftBarMD5Name) #008.jpg的md5
        
        codecsWriteTextUT8(serverListCSS,s)
    def copyWebFiles(self):
        copyFile(combineUrl(self.projectFilesCommonFolder,'serverList.css'),combineUrl(self.webFolder,'js','serverList.css'))
        copyFile(combineUrl(self.projectFilesCommonFolder,'serverListTx.js'),combineUrl(self.webFolder,'js','serverListTx.js'))
    def repalceImageFolder(self):
        self.repalceWebFolderFiles('images')
    def createTestCodeHtml(self,htmlFileName,testFileName,output):
        indexHtml = combineUrl(self.webFolder,htmlFileName)
        s = codecsReadTextUT8(indexHtml)
        testCode = codecsReadTextUT8(combineUrl(self.wanbaProjectFilesHtmlTestCodeFolder,testFileName))
        print("createTestCodeHtml:",indexHtml,testCode)
        codecsWriteTextUT8(combineUrl(self.webFolder,output),s.replace("<script src='js/md5",testCode + "<script src='js/md5"))
    def getRootMaxFileSize(self):
        rootFileName = self.getRootMaxMd5FileName()
        fileSize = os.path.getsize(combineUrl(self.webFolder,rootFileName))
        return fileSize
    def replaceHtmlRootMaxInfo(self,indexHtml):
        fileSize = self.getRootMaxFileSize()
        s = codecsReadTextUT8(indexHtml)
        s = re.sub(r'(?<="url": \'Root.max.js\', "size": )\d+', str(fileSize), s) 
        s = s.replace("Root.max.js",self.getRootMaxMd5FileName())
        
        # 写入statement.png的md5
        statementMD5Name = self.getFileMD5Name(self.versionInfo, "ui/loading/statement.png")
        s = s.replace("ui/loading/statement.png", statementMD5Name)
        
        codecsWriteTextUT8(indexHtml,s)

class LocalTestWanba(WanbaPlatform):
    def __init__(self,pf,mode, *args, **kwargs):
        super(LocalTestWanba,self).__init__(pf,mode,*args, **kwargs)
        self.tomcatFolder = r"E:\tomcat\webapps\web"
        if len(args) > 1:
            self.tomcatFolder = args[1]
        print('tomcatFolder:' + self.tomcatFolder)
    def startUp(self, *args, **kwargs):
        super(LocalTestWanba,self).startUp(*args, **kwargs)
        self.replaceHtmlRootMaxInfo(combineUrl(self.webFolder,'index.html'))
        self.createTestCodeHtml('index.html','localTestHtmlCode.txt','test_index.html')
        self.makePatchFiles(self.md5ConfigPath,self.patchFolder,self.webFolder)
        copyFiles(self.patchFolder,self.tomcatFolder)
        self.commitProjectConfigs()
    def beforeSetFilesVersion(self):
        esprimaJavaScript(self.projectPath,self.webFolder,'Root.max.js')
        super(LocalTestWanba,self).beforeSetFilesVersion()
        esprimaJavaScript(self.projectPath,self.webFolder,'Root.max.js','~','i')


class PublishWanba(WanbaPlatform):
    def __init__(self, pf,mode,*args, **kwargs):
        super(PublishWanba,self).__init__(pf,mode,*args, **kwargs)
    def startUp(self, *args, **kwargs):
        super(PublishWanba,self).startUp(*args, **kwargs)
        self.replaceHtmlRootMaxInfo(combineUrl(self.webFolder,'index.html'))
        self.createTestCodeHtml('index.html','internetTestCode.txt','test_index.html')
        self.createRCHtml()
        self.makePatchFiles(self.md5ConfigPath,self.patchFolder,self.webFolder)
        self.commitProjectConfigs()
    def createRCHtml(self):
        indexHtml = combineUrl(self.webFolder,'index.html')
        rcHtml = combineUrl(self.webFolder,'rc_index.html')
        copyFile(indexHtml,rcHtml)
        s = codecsReadTextUT8(rcHtml)
        codecsWriteTextUT8(rcHtml,s.replace("window.isRCVersion = false;","window.isRCVersion = true;"))
