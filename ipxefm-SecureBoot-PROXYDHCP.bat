@echo off
mode con cols=90 lines=8
title=building......
@taskkill /f /im pxesrv.exe
@taskkill /f /im hfs.exe
cd /d %~dp0
if not "%SystemDrive%" == "C:" echo WinPE&&goto start 
:: ��ȡ����ԱȨ������������
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" 1>nul 2>nul
exit /b
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" ) 1>nul 2>nul
::��Ŀ¼��everyone���Ȩ��
echo Y|cacls %~dp0. /t /p everyone:f
echo Y|cacls %~dp0*.* /t /p everyone:f
:start
cd /d %~dp0
cls
call :buildwim
call :makejob


(
echo [arch]
echo 00007=bootmgr.efi
echo [dhcp]
echo start=1
echo proxydhcp=1
echo httpd=0
echo bind=1
echo poolsize=998
echo root=%~dp0
echo filename=bootmgr.bios
)>%~dp0bin\config.INI

start "" /min %~dp0bin\hfs.exe -c active=yes

start "" /min %~dp0bin\pxesrv.exe
exit

:buildwim
if not exist bootmgr.efi copy /y app\wimboot\bootmgfw.efi bootmgr.efi
copy /y app\wimboot\boot.sdi  boot\Boot.sdi
copy /y app\wimboot\bcd boot\BCD
if not exist sources mkdir sources
copy /y mini.wim sources\boot.wim
exit /b



:makejob
set wimlib="bin\wimlib.exe"
if "%SystemDrive%" == "X:" set wimlib="X:\Program Files\GhostCGI\wimlib64\wimlib-imagex.exe"
echo ������Ҫִ�е���������:netghost;netcopy;smbcli;p2pmbr;p2pgpt;dbmbr;dbp2p;btonly;
set /p job=
::����ip(����B����)
::����ip(����B����)
echo ������Ҫ���ӵķ�����ip:
set /p ip=
:::::::::::::::::::::::::::::::
if not exist %~dp0sources (
echo sourcesĿ¼�����ڣ������޷�ʹ��! 
pause&&exit
) else (
call :cpwim
call :injectfiles
call :wtip
call :wtjob
call :buildwim
call :buildiso
)
exit /b

:cpwim
echo ����mini.wim��buildĿ¼....
copy %~dp0mini.wim %~dp0sources\boot.wim /y
exit /b

:injectfiles
::ע��injectĿ¼���ļ�
for /f %%i in ('dir /b app\inject\default\*.*') do (
echo ע��%%i ��boot.wim!
%wimlib% update %~dp0sources\boot.wim --command="add 'app\inject\default\%%i' '\Windows\system32\%%i'"
)
exit /b

:wtip
echo д��ip������
del /q %~dp0sources\*@* /f
echo . >%~dp0sources\@ip^=%ip%@job^=%job%
exit /b

:wtjob
:::ע������
for /f %%i in ('dir /b %~dp0sources\*@*') do (
echo ע��%%i ��boot.wim!
%wimlib% update %~dp0sources\boot.wim --command="add 'sources\%%i' '\Windows\system32\%%i'"
)
echo д����ɣ�ipΪ%ip% ����Ϊ%job%....
exit /b

:buildwim
%wimlib% optimize %~dp0sources\boot.wim
exit /b
