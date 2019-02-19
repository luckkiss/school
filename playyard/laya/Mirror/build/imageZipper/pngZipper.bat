

set path=%~d0%~p0

echo %path%
:start
set IMGFOLDER=%1
echo %IMGFOLDER%

dir *.png %IMGFOLDER% /s /a /b > dirlist.txt

FOR /F %%I IN (dirlist.txt) DO ("%path%pngquant.exe" -force -ext .png -verbose 256 %%I )
::for /F %i in (%IMGFOLDER%) do (echo %i) ::

shift
if NOT x%1==x goto start



@pause