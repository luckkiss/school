:: ´úÂë»ìÏı½Å±¾
:: @teppei, 2018/12/1

@echo off
setlocal enabledelayedexpansion

title ´úÂë»ìÏı@teppei

type readme.txt

set launcher_jsPath="..\..\bin\h5\Root.maxe2b77.js"

perl confuser.pl %launcher_jsPath% 1

: END
endlocal enabledelayedexpansion
@pause