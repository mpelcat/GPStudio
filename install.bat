
vcredist_x86.exe /q:a /c:"msiexec /i vcredist.msi /qb! /l*v %temp%\vcredist_x86.log"

RunDll32 advpack.dll,LaunchINFSection <file.inf>,DefaultInstall

setx /M PATH "%PATH%;%~dp0distrib\thirdparts\win\php"
setx /M PATH "%PATH%;%~dp0..\bin"
