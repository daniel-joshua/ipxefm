@echo off
set root=X:\windows\system32
if defined desktop (
    echo desktop ok!
) else (
set desktop=%USERPROFILE%\desktop
)
::����ȱ�ٵ�ϵͳ���
if exist %root%\sysx64.exe start /w "" sysx64.exe
:::�����������ӣ�����32λ�������в�����
mklink %temp%\cmd.exe x:\windows\system32\cmd.exe
::ע��ܷ�����Ҽ��˵�
if exist %root%\ShowDrives_Gui_x64.exe start "" %root%\ShowDrives_Gui_x64.exe --Reg-All
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
%root%\pecmd.exe LINK %Desktop%\TightVNC Viewer,"%root%\tightvnc\tvnviewer.exe" 

::���ִ�е���������%job%
for /f "tokens=1-2 delims=@ " %%a in ('dir /b %root%\*@*') do (
set %%a
set %%b
)
if not "%1" == "" set job=%1
echo ������IP��ַΪ  %ip%
echo ����ִ�е�����  %job%
::������������
color b0 
set a=50
set b=34
:re
set /a a-=1
set /a b-=1
mode con: cols=%a% lines=%b% 
if %a% geq 16 if %b% geq 1 goto re
:::�ɵĲ���ip��ʽ
:::for /f "tokens=2 delims==" %%a in ('dir /b %root%\serverip*') do set ip=%%a
:�ж�ipֵ
if defined ip (
    goto runtask
) else (
%root%\pecmd.exe TEAM TEXT ��ȡ������IP�У����ϵͳĿ¼������ip.txt L300 T300 R768 B768 $30^|wait 5000 
if exist X:\windows\system32\ip.txt @echo �ļ�����.׼����ȡ...&&goto txtip
if not exist X:\windows\system32\ip.txt @echo �ļ�������.dhcp��Ϊ��������ַ...&&goto dhcpip
)

:::���������ļ����˳�
:runtask
cd /d "%ProgramFiles(x86)%"
%root%\pecmd.exe TEAM TEXT �õ�������IPΪ%ip% L300 T300 R768 B768 $30^|wait 2000 
echo 
cls
%root%\pecmd.exe TEAM TEXT ���ڳ�ʼ�����磡L300 T300 R768 B768 $30^|wait 9000 
ipconfig /renew>nul
::::::::::::::���ýű���ʼ::::::::::::::
:::ȥִ������
::::����tightvnc
::����reg add "HKCU\SOFTWARE\TightVNC\Server" /v Password /t REG_BINARY /d F0E43164F6C2E373 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v UseVncAuthentication /t REG_DWORD /d 0x0 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v UseControlAuthentication /t REG_DWORD /d 0x0 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v DisconnectClients /t REG_DWORD /d 0x0 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v DisconnectAction /t REG_DWORD /d 0x0 /f
start "" %root%\tightvnc\tvnserver.exe -run
::��������ģʽstart "" "%root%\tightvnc\tvnserver.exe" -controlapp -connect %ip%
::::����githtvnc

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
set p2pfile=I:\system.wim
set smbfile=b:\system.wim
set diskpartdir=mbr
::set diskpartfile=
call :checkdiskspace
call :initdiskpart
call :checksmbfile
start "" %root%\btx64.exe
call :cloud
goto checkp2pfile
exit /b

:p2pgpt
set p2pfile=I:\system.wim
set smbfile=b:\system.wim
set diskpartdir=gpt
::set diskpartfile=
call :checkdiskspace
call :initdiskpart
call :checksmbfile
start "" %root%\btx64.exe
goto checkp2pfile
call :cloud
exit /b

::::::ִ������
:dbmbr
set p2pfile=I:\system.wim
set smbfile=b:\system.wim
set diskpartdir=mbr
::set diskpartfile=
call :checkdiskspace
call :initdiskpart
call :checksmbfile
call :cloud
exit /b

:dbgpt
set p2pfile=I:\system.wim
set smbfile=b:\system.wim
set diskpartdir=gpt
::set diskpartfile=
call :checkdiskspace
call :initdiskpart
call :checksmbfile
call :cloud
exit /b

::::::ִ�м��Ӳ����������
:checkdiskspace
set seldisk=masterdisk&&set disknum=0&&call :checkdisk
set seldisk=slaverdisk&&set disknum=1&&call :checkdisk
::[����]
if not "%masterdisk%"=="" (
set masterdiskpartfile=%root%\diskpart\%diskpartdir%\master\%masterdisk%_%diskpartdir%
%root%\pecmd.exe TEAM TEXT ��⵽��������Ϊ%masterdisk% ������%masterdisk%_%diskpartdir%�ű� L300 T300 R768 B768 $30^|wait 5000 
) else (
%root%\pecmd.exe TEAM TEXT ��ⲻ����Ӳ�����������ֹ�����ָ��������ΪI�� L300 T300 R768 B768 $30^|wait 5000
)
::[����]
if not "%slaverdisk%"=="" (
set slaverdiskpartfile=%root%\diskpart\%diskpartdir%\slaver\%slaverdisk%_%diskpartdir%
%root%\pecmd.exe TEAM TEXT ��⵽��������Ϊ%slaverdisk% ������%slaverdisk%_%diskpartdir%�ű� L300 T300 R768 B768 $30^|wait 5000
) else (
%root%\pecmd.exe TEAM TEXT ��ⲻ����Ӳ������ L300 T300 R768 B768 $30^|wait 5000 
echo .
)
exit /b

::::::ִ�м��Ӳ����������
:checkdisk
for /f "tokens=1-2,4-5" %%i in ('echo list disk ^| diskpart ^| find ^"���� %disknum%^"') do (
	echo %%i %%j %%k %%l
	if %%k gtr 101 if %%k lss 221 set %seldisk%=120G
	if %%k gtr 222 if %%k lss 233 set %seldisk%=240G
    if %%k gtr 234 if %%k lss 257 set %seldisk%=256G
    if %%k gtr 446 if %%k lss 501 set %seldisk%=500G
    if %%k gtr 882 if %%k lss 999 set %seldisk%=1t
    if %%k gtr 1862 if %%k lss 1999 set %seldisk%=2t
)>nul
exit /b
::::::ִ�з�������
:initdiskpart
mode con: cols=40 lines=10 

if not "%masterdisk%"== "" (
%root%\pecmd.exe TEAM TEXT ���棡������������Ӳ��%masterdisk%���ݽ���ʧ!!!! L300 T300 R768 B768 $30^|wait 5000 
ping 127.0 -n 10 >nul
diskpart /s %masterdiskpartfile%
) else (
%root%\pecmd.exe TEAM TEXT ��ⲻ����Ӳ�����������ֹ�����ָ��������ΪI�� L300 T300 R768 B768 $30^|wait 5000
)
if not "%slaverdisk%"== "" (
%root%\pecmd.exe TEAM TEXT ���棡��������������%slaverdisk%���ݽ���ʧ!!!! L300 T300 R768 B768 $30^|wait 5000 
ping 127.0 -n 10 >nul
diskpart /s %slaverdiskpartfile%
) else (
echo ..
)
call :smbdp
%root%\pecmd.exe TEAM TEXT ������ɣ�׼����������! L300 T300 R768 B768 $30^|wait 5000 
exit /b

:checkp2pfile
%root%\pecmd.exe TEAM TEXT ��������%p2pfile%����ȴ�........! L300 T1 R1000 B768 $30^|wait 8000
ping 127.0 -n 2 >nul
if exist %p2pfile% ( 
 %root%\pecmd.exe TEAM TEXT ������ɣ�׼����ԭ%p2pfile%��L300 T1 R1000 B768 $30^|wait 8000
 start "" %root%\cgix64 dp.ini
 exit /b
) else (
goto checkp2pfile
)
exit /b

:checksmbfile
if exist %smbfile% ( 
%root%\pecmd.exe TEAM TEXT B�̷���%smbfile%,׼����ԭ%smbfile%��L300 T1 R1000 B768 $30^|wait 8000
cd /d "X:\windows\system32" >nul
start "" /w %root%\cgix64.exe dp.ini
exit 
) else (
exit /b
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


