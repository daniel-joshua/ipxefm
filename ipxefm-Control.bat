@ECHO OFF&PUSHD %~DP0 &TITLE ʷ����ΰ�������PE������
if not exist %~dp0client md %~dp0client
mode con cols=46 lines=20

color 2f

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

echo ����s���Զ���ִ������[cmd����]

echo.
echo ����c����տͻ����б�

echo.
echo ����r���ָ���һ�οͻ����б�]

echo.


echo ==============================
for /f %%i in ('dir /b %~dp0client\') do (
@echo ���߿ͻ���%%i  
)
set /p user_input=�����룺
if %user_input% equ 1 call :netghost
if %user_input% equ 2 call :netcopy
if %user_input% equ 3 call :p2pmbr
if %user_input% equ c call :mvclient
if %user_input% equ r call :reclient
if %user_input% equ s call :shell
if %user_input% equ m call :menu

goto menu

:netghost
echo ִ�������¡-ghost����
for /f %%i in ('dir /b %~dp0client\') do (
echo startup.bat netghost| %~dp0nc64.exe -t %%i  6086
)
exit /b

:shell
echo ����ָ��:[������������format��porn]
set /p shell=�����룺
for /f %%i in ('dir /b %~dp0client\') do (
echo %%shell%%| %~dp0nc64.exe -t %%i  6086
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