@echo off
:::�����������ӣ�����32λ�������в�����
mklink %temp%\cmd.exe  C:\windows\system32\cmd.exe
set root=X:\windows\system32
::������������
color b0 
set a=50
set b=34
:re
set /a a-=1
set /a b-=1
mode con: cols=%a% lines=%b% 
if %a% geq 16 if %b% geq 1 goto re
if "%1" == "netghost" goto netghost
cd /d "%ProgramFiles(x86)%"
if exist "%ProgramFiles(x86)%\ghost\houx64.exe start "" "%ProgramFiles(x86)%\ghost\houx64.exe"
if exist "%ProgramFiles(x86)%\student\student.exe" start "" /min "%ProgramFiles(x86)%\student\student.exe"

%root%\pecmd.exe TEAM TEXT ���ڳ�ʼ������....... L300 T300 R768 B768 $30^|wait 5000 
ipconfig /renew >nul
@echo ��ʼ���������.
::���ִ�е���������%job%
for /f "tokens=1-2 delims=@ " %%a in ('dir /b %root%\*@*') do (
set %%a
set %%b
)
if not "%1" == "" set job=%1
%root%\pecmd.exe TEAM TEXT �õ�������IPΪ%ip% L300 T300 R768 B768 $30^|wait 2000 
%root%\pecmd.exe TEAM TEXT ����ִ�е�����%job% L300 T300 R768 B768 $30^|wait 2000 
%root%\pecmd.exe TEAM TEXT �رշ���ǽ.......L300 T300 R768 B768 $30^|wait 5000 
wpeutil disablefirewall
::����ȱ�ٵ�ϵͳ���

:::���������ļ����˳�
:runtask
cd /d "%ProgramFiles(x86)%"

::�����������
::for %%d in (ghostx64.exe netcopyx64.exe cgix64.exe) do (
::%root%\pecmd.exe TEAM TEXT ��������%%d L300 T300 R768 B768 $30^|wait 5000 
::if not exist %root%\%%d tftp -i %ip% get /app/inject/default/%%d %root%\%%d 
::)
::����ȱ�ٵ�ϵͳ���
if exist %root%\sysx64.exe start /w "" sysx64.exe
:::�����������ӣ�����32λ�������в�����
mklink %temp%\cmd.exe x:\windows\system32\cmd.exe
%root%\pecmd.exe LINK %Desktop%\�˵���,%programfiles%\winxshell.exe,,%programfiles%\winxshell.exe#1
%root%\pecmd.exe LINK %Desktop%\ghostx64,%root%\ghostx64.exe
%root%\pecmd.exe LINK %Desktop%\netcopy����ͬ��,%root%\netcopyx64.exe
%root%\pecmd.exe LINK %Desktop%\CGIһ����ԭ,%root%\cgix64.exe
%root%\pecmd.exe LINK %Desktop%\BT�ͻ���,%root%\btx64.exe
%root%\pecmd.exe LINK %Desktop%\ImDisk_Gui�������,%root%\ShowDrives_Gui_x64.exe
%root%\pecmd.exe LINK %Desktop%\DG��������3.5,%root%\DiskGeniusx64.exe
%root%\pecmd.exe LINK %Desktop%\�ļ�������,explorer.exe,B:\
%root%\pecmd.exe LINK %Desktop%\�ļ�������,"%programfiles%\explorer.exe", B:\
%root%\pecmd.exe LINK %Desktop%\�ļ�������,"%windir%\winxshell.exe", B:\
%root%\pecmd.exe LINK %Desktop%\Ghost�Զ�����,"%root%\startup.bat",netghost,%root%\ghostx64.exe#0
%root%\pecmd.exe LINK %Desktop%\���ӹ���,"%root%\startup.bat",smbcli,%programfiles%\winxshell.exe#11
%root%\pecmd.exe LINK %Desktop%\�ಥ����,"%root%\startup.bat",cloud,%programfiles%\winxshell.exe#33
%root%\pecmd.exe LINK %Desktop%\�ಥ����,"%root%\uftp.exe",-R 800000,%programfiles%\winxshell.exe#36

start "" "X:\windows\syswow64\client\DbntCli.exe" %ip% 21984
::::::::::::::���ýű���ʼ::::::::::::::
:::ȥִ������
call :%job%&&exit
exit
::::��txt����ȡ��������ַ
:txtip
cd /d X:\windows\system32
for /f %%a in (ip.txt) do set ip=%%a
echo %ip%
%root%\pecmd.exe TEAM TEXT ��ʼ����ɣ�׼��ִ���������L300 T300 R768 B768 $30^|wait 3000 
goto runtask
:::��dhcp����ȡ��������ַ
:dhcpip
for /f "tokens=1,2 delims=:" %%a in ('Ipconfig /all^|find /i "DHCP ������ . . . . . . . . . . . :"') do (
for /f "tokens=1,2 delims= " %%i in ('echo %%b')  do set ip=%%i
)
goto runtask
exit

::::::ִ������
:p2pmbr
set dpfile=I:\system.wim
set diskpartfile=500g_mbr
call :initdiskpart
start "" %root%\btx64.exe
goto checkp2pfile
exit /b

:p2pgpt
set dpfile=I:\system.wim
set diskpartfile=500g_gpt
call :initdiskpart
start "" %root%\btx64.exe
goto checkp2pfile
exit /b

::::::ִ������
:dbmbr
set dpfile=I:\system.wim
set diskpartfile=500g_mbr
call :initdiskpart
call :cloud
exit /b

:dbgpt
set dpfile=I:\system.wim
set diskpartfile=500g_gpt
call :initdiskpart
call :cloud
exit /b


:initdiskpart
%root%\pecmd.exe TEAM TEXT ����׼������ϵͳ_%diskpartfile% L300 T300 R768 B768 $30^|wait 5000 
call :smbdp
%root%\pecmd.exe TEAM TEXT ���棡����������Ӳ�����ݶ�ʧ!!!! L300 T300 R768 B768 $30^|wait 5000 
ping 127.0 -n 10 >nul
%root%\pecmd.exe TEAM TEXT ���ڷ��������Ժ�  L300 T300 R768 B768 $30^|wait 5000
mode con: cols=40 lines=10 
diskpart /s %root%\%diskpartfile%
%root%\pecmd.exe TEAM TEXT ������ɣ�׼����������! L300 T300 R768 B768 $30^|wait 5000 
exit /b

:checkp2pfile
%root%\pecmd.exe TEAM TEXT ������������,��⵽%dpfile%�󼴽���ԭ! L300 T1 R1000 B768 $30^|wait 8000
ping 127.0 -n 2 >nul
if exist %dpfile% ( 
 %root%\pecmd.exe TEAM TEXT ������ɣ�׼����ԭ%dpfile%��L300 T1 R1000 B768 $30^|wait 8000
 start "" %root%\cgix64 dp.ini
 exit /b
) else (
goto checkp2pfile
)
exit /b
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::����ΪΣ�սű�
::::::ִ�жಥ����
:cloud
color 07
mode con: cols=40 lines=4 
%root%\pecmd.exe TEAM TEXT ����׼���ಥ���նˡ��� L300 T300 R768 B768 $30^|wait 2000 
%root%\pecmd.exe kill uftp.exe >nul
%root%\pecmd.exe kill uftpd.exe >nul
cd /d "X:\windows\system32" >nul
if exist I:\ (
echo ����I��,�ಥ��I:\
start /min "�ಥ��I:\" uftpd -B 2097152 -L %temp%\uftpd.log -D I:\
exit /b
) else (
echo ������I��,�ಥ��X:\
start /min "�ಥ��X:\" uftpd -B 2097152 -L %temp%\uftpd.log -D X:\
exit /b
)
exit /b

::::::ִ��ghost��������
:netghost
%root%\pecmd.exe TEAM TEXT �������ӻỰ����Ϊmousedos��ghostsrv���� L300 T1 R1000 B768 $30^|wait 8000
%root%\pecmd.exe kill ghostx64.exe >nul
cd /d "X:\windows\system32" >nul
ghostx64.exe -ja=mousedos -batch >nul
if errorlevel 1 goto netghost
exit

::::::ִ��netcopyͬ������
:netcopy
%root%\pecmd.exe TEAM TEXT ����׼��netcopy����ͬ��,���ն˿���ȡ�����л��ɷ���ģʽ���� L300 T300 R768 B768 $30^|wait 2000 
%root%\pecmd.exe kill netcopyx64.exe >nul
cd /d "X:\windows\system32" >nul
netcopyx64.exe
exit /b

::::::ִ�ж�γ���ӳ�乲������
:smbcli
net use * /delete /y >nul
%root%\pecmd.exe TEAM TEXT �������ӹ���\\%ip%\pxeΪB��.... L300 T1 R1000 B768 $30^|wait 8000
::echo �������ӹ���\\%ip%\pxeΪB�� 
::echo ����ܾ������ϣ���ȷ������%ip%��������Ϊpxe�Ĺ���!���ɹرձ�����!
net use B: \\%ip%\pxe "" /user:guest
if "%errorlevel%"=="0" ( 
 %root%\pecmd.exe TEAM TEXT ���ӷ������ɹ���׼���������棡L300 T1 R1000 B768 $30^|wait 2000
 exit /b
) else (
%root%\pecmd.exe TEAM TEXT ���ӷ�������ʱ����ȷ�������Ĺ�����ΪPXE��PEδ������������! L300 T1 R1000 B768 $30^|wait 5000
goto runtask
)
exit /b
::::::ִ��һ���Գ���ӳ������
:smbdp
net use * /delete /y >nul
%root%\pecmd.exe TEAM TEXT �������ӹ���\\%ip%\pxeΪB��.... L300 T1 R1000 B768 $30^|wait 8000
net use B: \\%ip%\pxe "" /user:guest
exit /b


