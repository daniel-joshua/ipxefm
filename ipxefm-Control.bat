@ECHO OFF&PUSHD %~DP0 &TITLE ʷ����ΰ�������PE������
set root=%systemroot%\system32
if not exist %~dp0client md %~dp0client
mode con cols=36 lines=36

color 0f

:menu

cls

echo.

echo ����minipeִ��ʲô����

echo ==============================

echo.

echo ����1�������¡-ghost

echo.

echo ����2������ͬ��-netcopy

echo.

echo ����3��ȫ�Զ�����-P2P����[MBR]

echo.
echo ����4��ȫ�Զ�����-P2P����[GPT]

echo.
echo ����5��ȫ�Զ�����-�ಥ����[MBR]

echo.
echo ����6��ȫ�Զ�����-�ಥ����[GPT]

echo.
echo ����7����P2P����[������]

echo.
echo ����b��ǿ����ֹ��ǰ����

echo.
echo ����s���Զ���ִ������[cmd����]

echo.
echo ����c����տͻ����б�

echo.
echo ����r���ָ���һ�οͻ����б�

echo.
echo ����k������PE�ͻ�������

echo.


echo ==============================
for /f %%i in ('dir /b %~dp0client\') do (
@echo ���߿ͻ���%%i  
)
set /p user_input=�����룺
if %user_input% equ 1 set job=startup.bat netghost now&&set jobname=�����¡-ghost&&call :dojob
if %user_input% equ 2 set job=startup.bat netcopy now&&set jobname=����ͬ��-netcopy&&call :dojob
if %user_input% equ 3 set job=startup.bat p2pmbr now&&echo ���ݽ���ʧ!�س�����ȷ��&&pause&&pause&&pause&&set jobname=P2P�Զ�����-MBR&&call :dojob
if %user_input% equ 4 set job=startup.bat p2pgpt now&&echo ���ݽ���ʧ!�س�����ȷ��&&pause&&pause&&pause&&set jobname=P2P�Զ�����-GPT&&call :dojob
if %user_input% equ 5 set job=startup.bat dbmbr now&&echo ���ݽ���ʧ!�س�����ȷ��&&pause&&pause&&pause&&set jobname=�ಥ�Զ�����-MBR&&call :dojob
if %user_input% equ 6 set job=startup.bat dbgpt now&&echo ���ݽ���ʧ!�س�����ȷ��&&pause&&pause&&pause&&set jobname=�ಥ�Զ�����-GPT&&call :dojob
if %user_input% equ 7 set job=startup.bat btonly now&&set jobname=��P2P����[������]&&call :dojob
if %user_input% equ b set job=startup.bat kill now&&set jobname=�������н���&&call :dojob
if %user_input% equ c call :mvclient
if %user_input% equ r call :reclient
if %user_input% equ s call :shell
if %user_input% equ k call :vncclient
if %user_input% equ m call :menu
goto menu

:dojob
echo ִ��%jobname%����
for /f %%i in ('dir /b %~dp0client\') do (
echo %%job%%| %~dp0nc64.exe -t %%i  6086
)
exit /b

:shell
echo ����ָ��:[������������format��porn]
echo �ػ�ָ��:wpeutil shutdown
echo ����ָ��:wpeutil reboot
set /p command=�����룺
set jobname=ִ��ָ��Ϊ%command% command
for /f %%i in ('dir /b %~dp0client\') do (
echo startup.bat "%%command%%" shell| %~dp0bin\nc64.exe -t %%i  6086
)
exit /b

:mvclient
if not exist %~dp0client\local md %~dp0client\local
move /y %~dp0client\*.* %~dp0client\local.
exit /b

:reclient
if not exist %~dp0client\local md %~dp0client\local
move /y %~dp0client\local\*.* %~dp0client\
exit /b

:vncclient
cls
echo ��ǰ���߿ͻ���:
setlocal enabledelayedexpansion
set n=0
for /f %%i in ('dir /b %~dp0client\') do (
set /a n+=1
set pc!n!=%%i
@echo !n!.%%i  
)
set /p sel=��ҪԶ�̵���̨��: 
echo ѡ�� !pc%sel%!
start "" %~dp0bin\tvnviewer.exe !pc%sel%!
call :menu
exit /b 