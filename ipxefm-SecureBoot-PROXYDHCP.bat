@echo off
mode con cols=90 lines=15
title=��ȫ����ģʽ�������������......
if "%SystemDrive%"== "X:" pecmd -kill pxesrv.cmd&&pecmd -kill hfs.exe
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
call Secure_BCD.bat

(
echo [arch]
echo 00007=bootmgr.efi
echo [dhcp]
echo start=1
echo proxydhcp=1
echo httpd=0
echo smb=1
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
cls
echo ��������֧��:(��ϸ���з���startup.bat��ο�ipxeboot.txt)
echo netghost(����)��smbcli(���ع���)��cloud(�ಥ)
echo p2pmbr/p2pgpt(p2p��ʽ�Զ���������)
echo dbmbr/dbgpt(�ಥ�Զ���������)
echo smbdp(����ָ�)��btonly��������)��
echo houmbr/hougpt��hou�ಥ�Զ���������)��iscsi(�Զ���iscsi����)
echo gaka(�¿�/������ӽ��ҿͻ���)
echo -----------------------------------------------------------
echo ������Ҫִ�е���������:
echo netghost;netcopy;smbcli;p2pmbr;p2pgpt
echo dbmbr;dbp2p;btonly;smbdp;iscsi;gaka
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
if "%SystemDrive%"== "X:" (
rem д��ԭ�������ļ�
%wimlib% update %~dp0sources\boot.wim --command="add '\Program Files\DiskGenius\DiskGenius.exe' '\Windows\system32\DiskGeniusx86.exe'"
%wimlib% update %~dp0sources\boot.wim --command="add '\Program Files\GhostCGI\CGI-plus_x64.exe' '\Windows\system32\cgix64.exe'"
%wimlib% update %~dp0sources\boot.wim --command="add '\Program Files\GhostCGI\ghost64.exe' '\Windows\system32\ghostx64.exe'"
%wimlib% update %~dp0sources\boot.wim --command="add '\Windows\System32\pecmd.exe' '\Windows\system32\ShowDrives_Gui_x64.exe'"
%wimlib% update %~dp0sources\boot.wim --command="add '\Windows\System32\drivers.7z' '\Windows\system32\drivers.7z'"
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
