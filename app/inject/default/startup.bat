::���ýű�1�������������������ִ������
@echo off
set root=X:\windows\system32
set wait=pecmd wait 2000 
if not exist "X:\Program Files\WinXShell.exe" (
set say=%root%\pecmd.exe TEAM TEXT "
set font="L300 T300 R768 B768 $30^|wait 2000 
set wait=::::
set xsay=::::
set show=::::
) else (
set say=start "" "X:\Program Files\WinXShell.exe" -ui -jcfg wxsUI\UI_led.zip -text
:::set say=start "" "X:\Program Files\WinXShell.exe" -ui -jcfg wxsUI\UI_led.zip -wait 5 -scroll -top -text
set show=start "" "X:\Program Files\WinXShell.exe" -ui -jcfg wxsUI\UI_show.zip -text
set xsay=start "" "X:\Program Files\WinXShell.exe" -code "QuitWindow(nil,'UI_LED')"
set wait=%root%\pecmd.exe wait 2000
)
if not "%2" == "" set args1=%1&&set args2=%2&&goto startjob
::���ýű�1����


::������������
color b0 
set a=51
set b=35
:re
set /a a-=2
set /a b-=2
mode con: cols=%a% lines=%b% 
if %a% geq 16 if %b% geq 1 goto re
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

:::�ɵĲ���ip��ʽ
:::for /f "tokens=2 delims==" %%a in ('dir /b %root%\serverip*') do set ip=%%a
:�ж�ipֵ
if defined ip (
    goto runtask
) else (
%say% "��ȡ������IP�У����ϵͳĿ¼�µ�ip.txt" %font%
if exist X:\windows\system32\ip.txt @echo �ļ�����.׼����ȡ...&&goto txtip
if not exist X:\windows\system32\ip.txt @echo �ļ�������.dhcp��Ϊ��������ַ...&&goto dhcpip
)

:::���������ļ����˳�
:runtask
cd /d "%ProgramFiles(x86)%"
echo 
cls
%say% "���ڳ�ʼ������" %font%
%wait%
%xsay%

::ipconfig /renew>nul
::::::::::::::���ýű���ʼ::::::::::::::

::�ϱ�����ip��������
for /f "tokens=1,2 delims=:" %%a in ('Ipconfig^|find /i "IPv4 ��ַ . . . . . . . . . . . . :"') do (
for /f "tokens=1,2 delims= " %%i in ('echo %%b')  do set myip=%%i
)
%show% %myip% 
%say% "����ip:%myip% �ϱ���" %font%
%wait%
%xsay%
echo .>%myip%
tftp %ip% put %myip% client/%myip%
%say% "�ϱ����!" %font%
%wait%
%xsay%
:::�ϱ�ip
::::::ִ������
::nc�ܿط����
if exist %root%\nc.bat pecmd exec -hide %root%\nc.bat
::����tightvnc
%root%\pecmd.exe kill tvnserver.exe
::����reg add "HKCU\SOFTWARE\TightVNC\Server" /v Password /t REG_BINARY /d F0E43164F6C2E373 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v UseVncAuthentication /t REG_DWORD /d 0x0 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v UseControlAuthentication /t REG_DWORD /d 0x0 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v DisconnectClients /t REG_DWORD /d 0x0 /f
reg add "HKCU\SOFTWARE\TightVNC\Server" /v DisconnectAction /t REG_DWORD /d 0x0 /f
start "" %root%\tightvnc\tvnserver.exe -run
::��������ģʽstart "" "%root%\tightvnc\tvnserver.exe" -controlapp -connect %ip%
::::����tightvnc
call :%job%&&exit
exit
::::��txt����ȡ��������ַ
:txtip
cd /d X:\windows\system32
for /f %%a in (ip.txt) do set ip=%%a
echo %ip%
%say% "��ʼ����ɣ�׼��ִ���������" %font%
%wait%
%xsay%
goto runtask
:::��dhcp����ȡ��������ַ
:dhcpip
for /f "tokens=1,2 delims=:" %%a in ('Ipconfig /all^|find /i "DHCP ������ . . . . . . . . . . . :"') do (
for /f "tokens=1,2 delims= " %%i in ('echo %%b')  do set ip=%%i
)
goto runtask
exit

:startjob 
pecmd exec -hide %root%\nc.bat
if "%args2%" == "shell" (
%say% "���յ��Զ�������[%args1%]" %font%
%wait%
%xsay%
::ȥ��˫���������Զ�������
%args1:"=%
) else (
%say% "���յ�����[%args1%]" %font%
%wait%
%xsay%
call :%args1%
)
exit/b

:kill
%say% "���ڽ�������" %font%
%wait%
%xsay%
for %%i in (cgix64.exe ghostx64.exe uftp.exe uftpd.exe netcopy64.exe btx64.exe tvnserver.exe diskgeniusx64.exe qbittorrent.exe) do (
%root%\pecmd.exe kill %%i
)
exit /b


:btonly
set p2pfile=I:\system.wim
set smbfile=b:\system.wim
::set diskpartfile=
call :checksmbfile
start "" %root%\btx64.exe
call :cloud
%say% "��������%p2pfile%����ȴ�..." %font%
goto checkp2pfile
exit /b

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
%say% "��������%p2pfile%����ȴ�..." %font%
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
%say% "��������%p2pfile%����ȴ�..." %font%
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
%xsay%
set seldisk=masterdisk&&set disknum=0&&call :checkdisk
set seldisk=slaverdisk&&set disknum=1&&call :checkdisk
::[����]
if not "%masterdisk%" == "" (
set masterdiskpartfile=%root%\diskpart\%diskpartdir%\master\%masterdisk%_%diskpartdir%
%say% "��⵽��������Ϊ%masterdisk% ������%masterdisk%_%diskpartdir%�ű�" %font%
%wait%
) else (
%say% "��ⲻ����Ӳ�����������ֹ�����ָ��������ΪI��" %font%
%wait%
)
::[����]
%xsay%
if not "%slaverdisk%" == "" (
set slaverdiskpartfile=%root%\diskpart\%diskpartdir%\slaver\%slaverdisk%_%diskpartdir%
%say% "��⵽��������Ϊ%slaverdisk% ������%slaverdisk%_%diskpartdir%�ű�" %font%
%wait%
) else (
%say% "��ⲻ����Ӳ������" %font%
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
%xsay%
mode con: cols=40 lines=10 
if not "%masterdisk%" == "" (
%say% "���棬��������,��Ӳ��%masterdisk%���ݽ���ʧ!!!!" %font%
ping 127.0 -n 10 >nul
diskpart /s %masterdiskpartfile%
) else (
%say% "��ⲻ����Ӳ�����������ֹ�����ָ��I��[�ž���]" %font%
%wait%
)
%xsay%
if not "%slaverdisk%" == "" (
%say% "���棬��������,��Ӳ��%slaverdisk%���ݽ���ʧ!!!!" %font%
ping 127.0 -n 10 >nul
%xsay%
%say% "���ڷ�������" %font%
diskpart /s %slaverdiskpartfile%
%wait%
exit /b
) else (
%say% "��ⲻ����Ӳ������" %font%
%wait%
)
%xsay%
call :smbdp
%xsay%
%say% "������ɣ�׼����������!" %font%
%xsay%
exit /b

:checkp2pfile
ping 127.0 -n 2 >nul
if exist %p2pfile% ( 
%say% "������ɣ�׼����ԭ%p2pfile%" %font%
start "" %root%\cgix64 dp.ini
exit /b
) else (
goto checkp2pfile
)
exit /b

:checksmbfile
%xsay%
if exist %smbfile% ( 
%say% "B�̷���%smbfile%,׼����ԭ%smbfile%" %font%
%wait%
cd /d "X:\windows\system32" >nul
start "" /w %root%\cgix64.exe dp.ini
) else (
echo ..
)
exit /b
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::����ΪΣ�սű�
::::::ִ�жಥ����
:cloud
color 07
mode con: cols=40 lines=4 
%say% "����׼���ಥ���ն�..." %font%
%wait%
%xsay%
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
%say% "���ӻỰ����Ϊmousedos��ghostsrv����" %font%
%wait%
%xsay%
%root%\pecmd.exe kill ghostx64.exe >nul
cd /d "X:\windows\system32" >nul
ghostx64.exe -ja=mousedos -batch >nul
if errorlevel 1 goto netghost
exit

::::::ִ��netcopyͬ������
:netcopy
%say% "����׼��netcopy�ͻ���,��ȡ���л��ɷ���ģʽ." %font%
%wait%
%xsay%

%root%\pecmd.exe kill netcopyx64.exe >nul
cd /d "X:\windows\system32" >nul
netcopyx64.exe
exit /b

::::::ִ�ж�γ���ӳ�乲������
:smbcli
net use * /delete /y >nul
%say% "����\\%ip%\pxeΪB��" %font%
%wait%
%xsay%
net use B: \\%ip%\pxe "" /user:guest
if "%errorlevel%" == "0" ( 
%say% "���ӷ������ɹ�����������!" %font%
%wait%
%xsay%
%xsay%
exit /b
) else (
%say% "���ӳ�ʱ����ȷ�Ϲ�����ΪPXE��PEδ������������!" %font%
%wait%
%xsay%
%xsay%
goto runtask
)
exit /b
::::::ִ��һ���Գ���ӳ������
:smbdp
net use * /delete /y >nul
%say% "����\\%ip%\pxeΪB��" %font%
net use B: \\%ip%\pxe "" /user:guest
%xsay%
%xsay%
exit /b


