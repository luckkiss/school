# -*- coding:utf-8 -*- 
# quan min da tan ke
import os, re, sys, codecs

__error = False
def error():
    return __error
def checkError(logstr):  
    _printSvnError(logstr)
    _printPythonError(logstr)
    _printFileNameCheckError(logstr)
    _printWxcodeUploadError(logstr)
def _printSvnError(logstr):
    p = re.compile(r'svn: E.*', re.M)
    _printError('svn operation failed', logstr, p)
def _printFileNameCheckError(logstr):
    p = re.compile(r'invalid name: E.*', re.M)
    _printError('检测到有文件名不合法', logstr, p)
def _printWxcodeUploadError(logstr):
    p = re.compile(r'StatusCodeError:*', re.M)
    _printError('微信上传失败', logstr, p)
def _printPythonError(logstr):
    p = re.compile(r'except Exception -- catch error:*', re.M)
    _printError('python错误', logstr, p)
def _printError(tag, logstr, p):
    arr = p.findall(logstr)
    if ( len(arr) == 0 ): return

    global __error
    __error = True
    print ('--%s! %d error(s):'%(tag, len(arr)))
    for a in arr :
        print(a)
    
if __name__ == '__main__':
    logstr = r'''
[UIAtlasUtil::CompressAtlas] invalid atlas: aaa.png
'Assets/Scenes/chapter10/2011010.unity' is an incorrect path for a scene file. BuildPlayer expects paths relative to the project folder.
'Assets/Scenes/chapter10/2011010.unity' is an incorrect path for a scene file. BuildPlayer expects paths relative to the project folder.
DXT1 compressed textures are not supported when publishing to iPhone.
Compilation failed: 1 error(s), 57 warnings
Assets/Scripts/HappyShop.cs(65,38): error CS1061: Type `MainUILogic' does not contain a definition for `m_isShowHappyShop' and no extension method `m_isShowHappyShop' of type `MainUILogic' could be found (are you missing a using directive or an assembly reference?)
Updating Assets/Resources/Textures/vip/11.jpg - GUID: 3ddcf203d5a17564091eb61e3a7806c9...
Can not compress a non-square texture with Sprites to PVRTC format. However Sprites may still be packed to a compressed atlas if packing tag is specified.
Building - Failed to write file: resources.assets
Building - failed to write file: resources.assetsaaa
raw/AssetBundles/ui/altas/commonback/vip进度.ab: error: Invalid filename.  Unable to add
svn: E155004: '/Users/felix/documents/fymclient' is already locked.
Fatal error! It looks like another Unity instance is running with this project open.
Fatal Error! It looks like another Unity instance is running with this project open
DirectoryNotFoundException: Directory '/Users/felix/Documents/mgame/develop/client/project/publish/assets/android/shader' not found
'''
    print(logstr)
    checkError(logstr)
 
