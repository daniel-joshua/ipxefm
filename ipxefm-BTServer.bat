@echo off
mode con cols=50 lines=4
title=���ӷַ�

cd /d %~dp0
start "" %~dp0app\inject\default\btx64.exe
exit