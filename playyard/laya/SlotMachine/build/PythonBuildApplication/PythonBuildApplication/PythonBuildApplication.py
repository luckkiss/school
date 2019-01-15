from Common.Factory import Factory
from Common.Const import Const
import sys
from Common.util import *
class PythonBuildApplication:
    def __init__(self, *args, **kwargs):
       projectPath = sys.path[0].replace('build\PythonBuildApplication\PythonBuildApplication','')
       print(projectPath)
       pf = Const.WEI_XIN_XING_HAN
       mode = Const.PUBLISH
       if len(args) > 2 :
          pf = args[1]
          mode = args[2]
          print('pf:' + pf,'mode:' + mode)
       buildArgs = (projectPath,)
       if len(args) > 3:
          buildArgs = buildArgs + args[3:] 
          print('args',buildArgs)
       publish = Factory.createPublishProject(pf,mode,*buildArgs)
       publish.startUp()
if __name__ == '__main__':
    PythonBuildApplication(*sys.argv)
