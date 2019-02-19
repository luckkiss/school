# -*- coding:utf-8 -*-
from Common.util import *
from Common.Const import Const
from Common.svn import *
import signal
import os
import sys
class WeixinCodeCommit:
    def __init__(self, *args, **kwargs):
        self.codePath = r'F:\LayaProjects\H5Client_2nd\release\wxproject'
        self.batPath = r'D:\微信web开发者工具\cli.bat'#r'D:\layaair_dev\微信web开发者工具\cli.bat'
        self.version = '0'
        if len(args) > 0:
            self.codePath = args[0]
            self.version = args[1]
        # 上传路径 /Users/username/demo 下的项目，指定版本号为 1.0.0，版本备注为 initial release
        #cli -u 1.0.0@/Users/username/demo --upload-desc 'initial release'
    def commit(self):
        version = self.version
        desc = '自动构建'
        cmd = self.batPath + ' -u ' + version + '@' + self.codePath + ' --upload-desc ' + desc
        runCommand(cmd,'UTF-8',self.killTools)
        self.killTools()
    def killTools(self):
        os.system("taskkill /F /IM wechatdevtools.exe")
if __name__ == '__main__':
    WeixinCodeCommit().commit()
