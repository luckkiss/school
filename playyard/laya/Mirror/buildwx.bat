:: 微信构建测试
:: @teppei, 2019/2/18

@echo off
setlocal enabledelayedexpansion

title 微信构建测试@teppei

python build\PythonBuildApplication\PythonBuildApplication\PythonBuildApplication.py weixin publish True

: END
endlocal enabledelayedexpansion
@pause