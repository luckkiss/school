# -*- coding:utf-8 -*-
from Publish.PublishProject import PublishProject
from Common.util import *
from Common.Const import Const
from Common.svn import *
from Publish.Weixin.WeixinCodeCommit import WeixinCodeCommit
class WeixinPlatform(PublishProject):
    def __init__(self,pf,mode, *args, **kwargs):
        super(WeixinPlatform,self).__init__(pf,mode,*args, **kwargs)
        self.wxProjectFiles = combineUrl(self.projectFiles,self.platform,self.publishMode)
        self.buildConfig = combineUrl(self.wxProjectFiles,'BuildConfig.as')
        self.patchFolder = combineUrl(self.wxProjectFiles,'patch') 
    def startUp(self, *args, **kwargs):
        super(WeixinPlatform,self).startUp(*args, **kwargs)
        self.initProjectSetting()
        #self.zipAtlas(self.binH5Path)
        self.layaPublishCMD()
        self.checkPublishFilesInvalidName()
        self.movePublishFilesToWebFolder()


class PublishWeixin(WeixinPlatform):
    def __init__(self, pf,mode,*args, **kwargs):
        super(PublishWeixin,self).__init__(pf,mode,*args, **kwargs)
        self.commitCode = False
        self.wxPublishProjectFolder = combineUrl(self.releaseFolder,'wxproject')
        self.wxReplaceList = self.getWxReplaceList()
    def getWxReplaceList(self):
        return ['game.json','game.js','project.config.json','weapp-adapter.js']
    def getWxprojectFileList(self):
        return self.getWxReplaceList() + ['code.js']
    def getWxprojcetFolder(self):
        return ['js']
    def keepNameRealList(self):
        return self.wxReplaceList + ['code.js', 'package_sub.js']
    def startUp(self, *args, **kwargs):
        super(PublishWeixin,self).startUp(*args, **kwargs)
        deleteFile(self.wxPublishProjectFolder)
        self.copyWeixinProjectFiles()
        self.createCodeJS()
        # self.createWeixinFakeLoadingFiles()
        # self.mangleImages()
        # self.mangleJsons()
        # self.mangleFilesName()
        # self.compressSpeciallyJS()
        # self.versionInfo = self.setFilesVersion(self.webFolder,self.keepNameRealList())
        # self.mangleVersion()
        # 将混淆后的package_sub.js复制到bin目录底下，以免repalceJSFolder时被覆盖
        # copyFile(combineUrl(self.webFolder,'js\subpackage\package_sub.js'), combineUrl(self.binH5Path,'js\subpackage\package_sub.js'))
        # self.setVersionConfigMD5(self.webFolder)
        self.repalceJSFolder()
        self.deleteUnWeixinFiles()
        self.moveWxProject()
        self.makePatchFiles(self.md5ConfigPath,self.patchFolder,self.webFolder)
        if self.commitCode:
           self.commitWeixinCode()
        if self.debug != True:
           self.commitProjectConfigs()
    def mangleFilesName(self):
        pass
    def mangleImages(self):
        pass
    def mangleJsons(self):
        pass
    def mangleVersion(self):
        pass
    def deleteUnWeixinFiles(self):
        folder = combineUrl(self.webFolder,'js')
        deleteFile(combineUrl(folder,'serverList.css'))
        deleteFile(combineUrl(folder,'serverListTx.js'))
        deleteFile(combineUrl(folder,'vconsole.min.js'))
        deleteFile(combineUrl(folder,'fyconsole.js'))
    def createWeixinFakeLoadingFiles(self):
        copyFiles(combineUrl(self.wxProjectFiles,'loading'),combineUrl(self.wxPublishProjectFolder,'loading'))
        imageName = ""
        if self.platform == Const.WEI_XIN:
            codeFile = combineUrl(self.srcPath,"ui","LoginViewUI.as")
            content = codecsReadTextUT8(codeFile)
            #'{"top":0,"skin":"res/login/008.jpg",'
            pattern = "\"top\":0,\"skin\":\"(res.+jpg)\""
            imageName = re.search(pattern,content).group(1)
        if self.platform == Const.WEI_XIN_XING_HAN:
            imageName = r"res\login\xhlogo.jpg"
        src = combineUrl(self.webFolder,imageName)
        dst = combineUrl(self.wxPublishProjectFolder,'loading','loading.jpg')
        copyFile(src,dst)
    def commitWeixinCode(self):
        if self.debug == True:
            return
        WeixinCodeCommit(self.wxPublishProjectFolder,self.getShowProjectVersionText()).commit()
    def initProjectSetting(self):
        copyFile(self.srcModuleConfig,self.projectModuleConfig)
        copyFile(self.buildConfig,combineUrl(self.srcPath,'plat','BuildConfig.as'))
    def createCodeJS(self):
        deleteFile(combineUrl(self.webFolder,'code.js'))
        os.rename(combineUrl(self.webFolder,'Root.max.js'),combineUrl(self.webFolder,'code.js'))
    def copyWeixinProjectFiles(self):
        for file in self.wxReplaceList:
            copyFileToFolder(file,self.wxProjectFiles,self.webFolder)

    def compressSpeciallyJS(self):
        compressJavaScript(self.webFolder,'code.js')
        compressJavaScript(self.webFolder,'js\subpackage\package_sub.js')
    def moveWxProject(self):
        wxprojectFileList = self.getWxprojectFileList()
        wxprojcetFolder = self.getWxprojcetFolder()

        for fileName in wxprojectFileList:
            src = combineUrl(self.webFolder,fileName)
            dst = combineUrl(self.wxPublishProjectFolder,fileName)
            if os.path.exists(src):
               moveFiles(src,dst)
        for folder in wxprojcetFolder:
            src = combineUrl(self.webFolder,folder)
            dst = combineUrl(self.wxPublishProjectFolder,folder)
            if os.path.exists(src):
                moveFiles(src,dst)
