@echo off
mode con cols=90 lines=15
title TFTP�������ʵ���
if exist Boot\BCD del /q /f Boot\BCD
:bd_bcd
set pxeid={19260817-6666-8888-f00d-caffee000009}
bcdedit.exe /createstore Boot\BCD
bcdedit.exe /store Boot\BCD /create {ramdiskoptions} /d "Ramdisk options"
bcdedit.exe /store Boot\BCD /set {ramdiskoptions} ramdisksdidevice boot
bcdedit.exe /store Boot\BCD /set {ramdiskoptions} ramdisksdipath \Boot\boot.sdi
bcdedit.exe /store Boot\BCD /create %pxeid% /d "winpe boot image" /application osloader
bcdedit.exe /store Boot\BCD /set %pxeid% device ramdisk=[boot]\sources\boot.wim,{ramdiskoptions} 
rem bcdedit.exe /store Boot\BCD /set %pxeid% path \windows\system32\winload.exe 
bcdedit.exe /store Boot\BCD /set %pxeid% osdevice ramdisk=[boot]\sources\boot.wim,{ramdiskoptions} 
bcdedit.exe /store Boot\BCD /set %pxeid% systemroot \windows
bcdedit.exe /store Boot\BCD /set %pxeid% detecthal Yes
bcdedit.exe /store Boot\BCD /set %pxeid% winpe Yes
bcdedit.exe /store Boot\BCD /create {bootmgr} /d "boot manager"
bcdedit.exe /store Boot\BCD /set {bootmgr} timeout 30 
bcdedit.exe /store Boot\BCD -displayorder %pxeid% -addlast
rem �ر�metro����
bcdedit /store Boot\BCD /set %pxeid% bootmenupolicy legacy
cls
echo ����BCD�����˵����...
:tftpblocksizemenu
echo.
echo �޸Ĵ������ʣ���ѡ��һ��ѡ��!
echo 1. ������ [���ܲ��ȶ�]
echo 2. ����   [�Ƽ�]
echo 3. �е�
echo 4. ����   [���粻�ȶ�ѡ��]
echo.
set /p choice=���������ѡ��1-4��Ȼ�󰴻س���:
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' set blocksize=16384
if '%choice%'=='2' set blocksize=8192
if '%choice%'=='3' set blocksize=4096
if '%choice%'=='4' set blocksize=512
if '%choice%'=='' echo ��Ч��ѡ��, ����������. &&goto menu
bcdedit /store Boot\BCD /set {ramdiskoptions} ramdisktftpblocksize %blocksize%
echo �޸����
timeout 2 /nobreak
exit /b

