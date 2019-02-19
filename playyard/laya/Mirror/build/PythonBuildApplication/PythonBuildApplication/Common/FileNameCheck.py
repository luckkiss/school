import os
import re
class FileNameCheck:
    @staticmethod
    def findFiles(basepath, ext=''):
        rfiles = []

        for root, dirs, files in os.walk(basepath):
            for file in files:
                if re.match(r"^[@a-zA-Z0-9_\./-]+$",file, re.IGNORECASE) == None:
                    fileName = root + os.sep + file
                    fileName = fileName.replace(basepath,'')
                    rfiles.append(fileName)
                 
        return rfiles
    @staticmethod
    def checkInvalidName(path):
        print(path)
        list = FileNameCheck.findFiles(path)
        index = 0
        msg = ''
        if len(list) == 0:
            return 0
        for f in list:
            index = index + 1
            s = 'invalid name: E.-' + str(index) + ':' + str(f).replace(path,'')
            msg+=s + '\n'
        print(msg)
        return 1
    @staticmethod
    def rfc(file):
        rfc = ["{", "}", "|", "\\", "^", "~", "[", "]",  "`"]
        for s in rfc:
            if s in file:
                return True
        return False
if __name__ == '__main__':
    current_path = os.path.split(os.path.realpath(__file__))[0]
    print(current_path)
    list = FileNameCheck.findFiles(current_path)
    file = open(current_path + "\\files.txt",'w')
    file.write(str(len(list)) + ':\n')
    index = 0
    for f in list:
        index = index + 1
        s = str(f).replace(current_path,'')
        print('invalid name: E. - ' + str(index) + ':' + s)
        file.write(str(index) + ':' + s + '\n')
    file.close()
