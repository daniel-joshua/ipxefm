-- ��ȡϵͳ������
systemdrive = os.getenv("systemdrive")

-- ִ��ipconfig /all�����ȡ���
local exitcode, text = winapi.execute("ipconfig /all")
text = text:gsub("\r\n", "\n")

-- �����ȡ�������Ƶĺ���
function getcardname(netcard)
    -- �����������ƹؼ��ʺͽ����ؼ���
    local netcardsname = {"��̫�������� ��̫��", "��̫�������� Ethernet"} 
    local end_pattern = "TCPIP �ϵ� NetBIOS"
    local netcard = ""
    local recording = false
    -- ���������ÿһ��
    for line in text:gmatch("[^\r\n]+") do
        -- ����Ƿ�����������ƹؼ���
        for _, start_pattern in ipairs(netcardsname) do
            if line:find(start_pattern) then
                recording = true
                break
            end
        end
        -- ��������ؼ��ʣ����¼����
        if recording then
            netcard = netcard .. line .. "\n"
        end
        -- ������������ؼ��ʣ���ֹͣ��¼
        if line:find(end_pattern) then
            recording = false
        end
    end
    return netcard
	
end

-- �����ȡ���������ĺ���
function get_myenv()
    -- ��ȡ������Ϣ
    netcard = getcardname()
    -- ��ȡIP���������롢Ĭ�����غ�����������
	adapter = string.match(netcard, "��̫��������%s*(.-):")
    myip = netcard:match("IPv4 ��ַ .-: (%d+%.%d+%.%d+%.%d+)")
    mymask = netcard:match("�������� .-: (%d+%.%d+%.%d+%.%d+)")
    mygw = string.match(netcard, "Ĭ������.-%s*(%d+%.%d+%.%d+%.%d+)%s*DHCP ������")
    if mygw == nil then mygw = netcard:match("Ĭ������. . . . . . . . . . . . . : (%d+%.%d+%.%d+%.%d+)") end
   	return myip,mymask,mygw,adapter
end

-- ��������IP�ĺ���
function wtip()
    get_myenv()
    -- ���ϵͳ������ΪX:����ʹ��pecmd.exe����IP
    if systemdrive == "X:" then
        exec("pecmd.exe PCIP " .. myip .. "," .. mymask .. "," .. mygw .. "," .. mygw .. ";223.5.5.5,0")
    else
        -- ����ʹ��netsh��������IP��DNS
        local cmd_wtip = string.format('netsh interface ip set address "' .. adapter .. '" static %s %s %s', myip, mymask, mygw)
        exec("/hide",cmd_wtip)
        exec("/hide",'netsh interface ip add dns "' .. adapter .. '" ' .. mygw .. ' index=1')
        exec("/hide",'netsh interface ip add dns "' .. adapter .. '" 223.5.5.5 index=2')
    end
end

-- ��������IP�ĺ���
wtip()

 


