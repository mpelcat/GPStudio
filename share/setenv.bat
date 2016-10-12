@echo off

set GPSPATH=%~dp0
set GPSBIN="%GPSPATH%bin"
set PHPBIN="%GPSPATH%thirdparts\php"
set THIRDBIN="%GPSPATH%thirdparts"
set PATH=%PATH%;%GPSBIN%;%PHPBIN%;%THIRDBIN%
