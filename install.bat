
vcredist_x86.exe /q:a /c:"msiexec /i vcredist.msi /qb! /l*v %temp%\vcredist_x86.log"

RunDll32 advpack.dll,LaunchINFSection <file.inf>,DefaultInstall
