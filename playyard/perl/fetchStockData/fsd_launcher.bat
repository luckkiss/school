:: 抓取页面链接
:: @teppei, 2014/8/21

@echo off
setlocal enabledelayedexpansion

title 抓取页面链接@teppei

set launcher_pageUrl="http://game.qq.com/"
set launcher_indexName=""
set launcher_savePath="out/qgame_!date:~0,4!!date:~5,2!!date:~8,2!!time:~0,2!!time:~3,2!!time:~6,2!"
set launcher_log="log_!date:~0,4!!date:~5,2!!date:~8,2!!time:~0,2!!time:~3,2!!time:~6,2!.log"

rmdir %launcher_savePath% /S /Q 2>nul
mkdir %launcher_savePath%
perl htmlExtractor.pl %launcher_pageUrl% %launcher_indexName% %launcher_savePath% %launcher_log%

: END
endlocal enabledelayedexpansion
@pause