# -*- coding:utf-8 -*-
import codecs
import json
import shutil
import re
from Common.svn import *
from Common.util import *
from Common.Const import Const
from Common.FileNameCheck import FileNameCheck
class PublishProject(object):
    def __init__(self,pf,mode, *args, **kwargs):
        #=========================================================
        print(os.getcwd())
        self.platform = pf
        self.publishMode = mode
        self.projectPath = args[0]#path.replace('build\前置脚本\Script\Script','')
        print('projectPath:',self.projectPath)
        #self.debug = True调试设置成true,不压缩图片，不会更新项目，不生成增量包，不提交差异配置,微信不上传代码到管理端
        self.debug = False
        if args[1] == 'True':
            self.debug = True
        print("PublishProject.debug:" + str(self.debug))
        self.buildPath = combineUrl(self.projectPath,'build')
        self.releaseFolder = combineUrl(self.projectPath,'release')
        self.layaWebFolder = combineUrl(self.releaseFolder,'layaweb')
        self.webFolder = combineUrl(self.releaseFolder,'web')
        self.projectFiles = combineUrl(self.projectPath,'build','projectfiles')
        self.publishProjectFiles = combineUrl(self.projectFiles,self.platform,self.publishMode)
        self.srcModuleConfig = combineUrl(self.projectFiles,'common','module.def')
        self.projectModuleConfig = combineUrl(self.projectPath,'module.def')
        self.buildPath = combineUrl(self.projectPath , 'build')
        self.binPath = combineUrl(self.projectPath , 'bin')
        self.binH5Path = combineUrl(self.projectPath , 'bin','h5')
        self.layaPath = combineUrl(self.projectPath , 'laya')
        self.libsPath = combineUrl(self.projectPath , 'libs')
        self.srcPath = combineUrl(self.projectPath , 'src')
        self.svnFolders = [self.binPath,self.layaPath,self.libsPath,self.srcPath]
        self.imageZipperBatPath = combineUrl(self.projectPath,'build','imageZipper','pngZipper.bat')
        self.projectReleaseVersionPath = combineUrl(r'E:\\configs\\',self.platform,self.publishMode,'version.txt')
        print("projectReleaseVersionPath:" + self.projectReleaseVersionPath)
        self.md5ConfigPath = combineUrl(r'E:\\configs\\',self.platform,self.publishMode,'md5.txt')
        self.buildConfigCode = combineUrl(self.srcPath,'plat','BuildConfig.as')
    def zipAtlas(self,path):
        if self.debug == True:
            return
        cmd = self.imageZipperBatPath + ' ' + combineUrl(path , 'res','atlas').replace('/','\\')
        runCommand(cmd,"gbk")
    def replaceFiles(self):
        resReplacedPath = combineUrl(self.publishProjectFiles , 'res_replaced.txt')
        if os.path.exists(resReplacedPath):
            txt = codecsReadTextUT8(resReplacedPath)
            lineArr = re.split(r'\n',txt)
            for oneLine in lineArr:
                oneLineArr = oneLine.split('->')
                if len(oneLineArr) >= 2:
                    dest = combineUrl(self.binH5Path, oneLineArr[0]).strip()
                    src = combineUrl(self.binH5Path, oneLineArr[1]).strip()
                    print('[replaceFiles]' + dest + '->' + src)
                    if os.path.isdir(src):
                        copyFiles(src, dest)
                    else:
                        copyFile(src, dest)
    def replaceUI(self):
        resReplacedPath = combineUrl(self.publishProjectFiles , 'ui_replaced.txt')
        if os.path.exists(resReplacedPath):
            txt = codecsReadTextUT8(resReplacedPath)
            lineArr = re.split(r'[\r|\n]+',txt)
            for oneLine in lineArr:
                oneLineArr = oneLine.split('->')
                if len(oneLineArr) >= 2:
                    originUI = combineUrl(self.srcPath, 'ui', oneLineArr[0] + '.as')
                    uiMO = re.match(r'(\w+)$', oneLineArr[0])
                    originUIName = uiMO.group(1)
                    newUI = combineUrl(self.srcPath, 'ui', oneLineArr[1] + '.as')
                    print('[replaceUI]' + originUI + '->' + newUI)
                    newUICode = codecsReadTextUT8(newUI)
                    newUICode = re.sub(r'(?<=class )\w+', originUIName, newUICode) 
                    codecsWriteTextUT8(originUI, newUICode)
    def getFileMD5Name(self,versionData,fileName):
        arr = os.path.splitext(fileName)
        md5 = versionData[fileName]
        return arr[0] + md5 + arr[1]
    def setVersionConfigMD5(self,folder):
        versionFileFullPath = combineUrl(folder, 'version.json')
        md5 = getMD5(versionFileFullPath).lower()
        writeText(combineUrl(folder, 'ver_md5.txt'),md5)
        fileArr = os.path.splitext(versionFileFullPath)
        os.rename(versionFileFullPath,fileArr[0] + md5 + fileArr[1])
    def startUp(self, *args, **kwargs):
        if self.debug == False:
           self.svnUpdate()
        deleteFile(self.webFolder)
        deleteFile(self.layaWebFolder)
        self.getProjectReleaseVersion()
        self.replaceFiles()
        self.replaceUI()
    def getProjectReleaseVersion(self):
        if self.debug == True:
            self.projectReleaseVersion = 0
            return
        self.projectReleaseVersion = readText(self.projectReleaseVersionPath)
        self.projectReleaseVersion = int(self.projectReleaseVersion) + 1
        print("getProjectReleaseVersion:",self.projectReleaseVersion)
    def getShowProjectVersionText(self):
        return '0.0.' + str(self.projectReleaseVersion)
    def writeBuildCodeVersion(self):
        content = codecsReadTextUT8(self.buildConfigCode)
        content = content.replace('public const version:String = \'0.0.0\';','public const version:String = \"' + self.getShowProjectVersionText() + '\";')
        codecsWriteTextUT8(self.buildConfigCode,content)
    def checkPublishFilesInvalidName(self):
        code = FileNameCheck.checkInvalidName(self.getLayaPublishFolder())
        if code == 1:
            print('检测到有文件名不合法')
            sys.exit(1)
            return
    def layaPublishCMD(self):
        os.chdir(self.projectPath)
        layaAirCMD = '\"' + os.getenv('APPDATA') + '\\npm\\layaair-cmd.cmd' + '\"'
        #layaair-cmd publish --noUi --noAtlas
        cmd = layaAirCMD + ' publish --noUi --noAtlas'
        runCommand(cmd)
    def movePublishFilesToWebFolder(self):
        folder = self.getLayaPublishFolder()
        if folder == None:
            raise RuntimeError('laya cmd publish folder == None')
            return -1
        copyFiles(folder,self.webFolder)

    def getLayaPublishFolder(self):
       filelist = os.listdir(self.layaWebFolder)
       for f in filelist:
           file = combineUrl(self.layaWebFolder, f)
           if os.path.isdir(file):
               return file
    def svnUpdate(self):
        self.updateRevert(self.buildPath)

        cmd = ""
        for path in self.svnFolders:
            cmd+=path + ' '
        self.updateRevertCleanupunversioned(cmd)
    def updateRevert(self,path):
        cleanup(path)
        revert(path)
        update(path)
        cleanup(path)
        revert(path)
    def updateRevertCleanupunversioned(self,path):
        cleanupunversioned(path)
        revert(path)
        update(path)
        cleanupunversioned(path)
        revert(path)
    def setFilesVersion(self,folder,excludeList=[]):
        version = {}
        for root, dirs, files in os.walk(folder):
            for fileName in files:
                exclude = fileName in excludeList
                fileArr = os.path.splitext(fileName)
                fileFullPath = combineUrl(root, fileName)
                relativePath = fileFullPath.replace(folder + '/','')
                #print('setFilesVersion:',fileFullPath,relativePath)
                shortMD5 = getMD5(fileFullPath)[-5:]
                fileNameVersionControl = ""
                if not exclude:
                    fileNameVersionControl = fileArr[0] + shortMD5 + fileArr[1]
                    version[relativePath] = shortMD5
                    fileVCFullPath = combineUrl(root, fileNameVersionControl)
                    deleteFile(fileVCFullPath)
                    os.rename(fileFullPath,fileVCFullPath)
                else:
                    fileNameVersionControl = fileName
                    version[relativePath] = ''
                newFileName = combineUrl(root, fileNameVersionControl)
        versionFile = combineUrl(folder,'version.json')
        versionContent = json.dumps(version)
        f = open(versionFile,'w')
        f.write(versionContent)
        f.close()
        return version
    def repalceWebFolderFiles(self,folderName):
        dstFolder = combineUrl(self.webFolder,folderName)
        scrFolder = combineUrl(self.binH5Path,folderName)
        deleteFile(dstFolder)
        copyFiles(scrFolder,dstFolder)
    def repalceJSFolder(self):
        #webJSFolder = combineUrl(self.webFolder,'js')
        #scrJSFolder = combineUrl(self.binH5Path,'js')
        #deleteFile(webJSFolder)
        #copyFiles(scrJSFolder,webJSFolder)
        self.repalceWebFolderFiles('js')
    def makePatchFiles(self,md5ConfigPath,patchFolder,sourceFolder):
        if self.debug == True:
            return
        revert(md5ConfigPath)
        update(md5ConfigPath)
        deleteFile(patchFolder)
        sourceMD5 = self.getSourceFolderMD5(sourceFolder)
        list = self.diffWithPreviousVersion(md5ConfigPath,sourceMD5)
        for shortFile in list:
            src = combineUrl(sourceFolder,shortFile)
            dst = combineUrl(patchFolder,shortFile)
            copyFile(src,dst)
        writeText(md5ConfigPath,json.dumps(sourceMD5))
    def commitProjectConfigs(self):
        writeText(self.projectReleaseVersionPath,str(self.projectReleaseVersion))
        commit(self.projectReleaseVersionPath, 'auto commit project release version')
        commit(self.md5ConfigPath, 'auto commit files md5 config')
        print('SVN提交配置',self.projectReleaseVersionPath,self.md5ConfigPath)
    def diffWithPreviousVersion(self,previousConfigPath,workingCopy):
        previous = {}
        if os.path.exists(previousConfigPath):
            revert(previousConfigPath)
            update(previousConfigPath)
            txt = readText(previousConfigPath)
            previous = json.loads(txt)
        result = self.diff(previous,workingCopy)
        return result
    def getSourceFolderMD5(self,dirname):
        filelist = []
        if os.path.isfile(dirname):
            filelist.append(dirname)
        else :
            for root, dirs, files in os.walk(dirname):
                for name in files:
                    filelist.append(combineUrl(root, name))

        jsonObject = {}         
        for tar in filelist:
            arcname = tar[len(dirname) + 1:]
            jsonObject[arcname] = getMD5(tar)
        return jsonObject
    def diff(self,previous,working):
        result = []
        for key in working:
            if working[key] != previous.get(key, ''):
                result.append(key)
        return result   
if __name__ == '__main__':
    print('start..')
    #pf = wanba
    #env = ""
    #cy = ""
    #if len(sys.argv) > 3:
    #   pf = sys.argv[1]
    #   env = sys.argv[2]
    #   cy = sys.argv[3]
    #app = PublishProject()
    #app.startup(pf,env,cy)
    print(combineUrl('a','b'))