# -*- coding:utf-8 -*-
from Common.Const import Const
from Publish.Wanba.WanbaPlatform import LocalTestWanba,PublishWanba
class Factory(object):
    @staticmethod
    def createPublishProject(pf,mode,*args):
        print('Factory.createPublishProject',pf,mode,args)
        if pf == Const.WAN_BA and mode == Const.LOCAL_TEST:
           return LocalTestWanba(pf,mode,*args)
        if pf == Const.WAN_BA and mode == Const.PUBLISH:
            return PublishWanba(pf,mode,*args)