@echo off
mode con cols=50 lines=4
title=�ಥ�ļ�%1��......

cd /d %~dp0
%~dp0bin\uftp.exe -R 800000 %1
exit