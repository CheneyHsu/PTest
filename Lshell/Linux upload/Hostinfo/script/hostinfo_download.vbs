Dim WshShell, curDir, file
Set WshShell = WScript.CreateObject("WScript.Shell")
Set FileSystem = WScript.CreateObject("Scripting.FileSystemObject")
Set OutPutFile = FileSystem.OpenTextFile("upftp.dll",2,True) 

OutPutFile.WriteLine "open 10.200.8.87" 
OutPutFile.WriteLine "hostinfo"
OutPutFile.WriteLine "hostinfo"
OutPutFile.WriteLine "bin"
OutPutFile.WriteLine "prompt off"
OutPutFile.WriteLine "cd /hostinfo/hostinfo/script" 
OutPutFile.WriteLine "mget hostinfo10.200.8.87.exe" 
OutPutFile.WriteLine "bye" 'Quit.
OutPutFile.Close
'���� ϵͳ���ù���ű�
Wshshell.run "ftp -s:"&"upftp.dll",1,true 
'Set WshShell = Nothing
'Set FileSystem = Nothing
'Set OutPutFile = Nothing
'WScript.Quit(0)

FileSystem.deletefile "upftp.dll"          'ɾ����ʱ�ļ�


'��ѹ�ű�
WshShell.run "hostinfo10.200.8.87.exe",1,true          


'ϵͳ���ù���ű����붨ʱ����
f = WshShell.CurrentDirectory    
wscript.echo f                       '��ѯ��ǰĿ¼
WshShell.CurrentDirectory = f &"\sysadmin\hostinfo\bin"    '���õ�ǰĿ¼
WshShell.run "setup.bat",1,true                       
'Wscript.Echo WshShell.CurrentDirectory

