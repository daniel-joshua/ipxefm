@echo off
mode con cols=50 lines=10
title=GhostServer
echo �Զ�ȷ��һ�㶼Ҫ�� -sure
echo ��¡��������� -rb
echo gpt��¡���������� -ntexact
echo linux��¡��� -ib

cd /d %~dp0bin
start "" %~dp0bin\GhostSrv64.EXE
echo 
pause
exit