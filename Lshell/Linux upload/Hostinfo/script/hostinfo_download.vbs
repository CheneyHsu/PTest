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
'下载 系统配置管理脚本
Wshshell.run "ftp -s:"&"upftp.dll",1,true 
'Set WshShell = Nothing
'Set FileSystem = Nothing
'Set OutPutFile = Nothing
'WScript.Quit(0)

FileSystem.deletefile "upftp.dll"          '删除临时文件


'解压脚本
WshShell.run "hostinfo10.200.8.87.exe",1,true          


'系统配置管理脚本加入定时任务
f = WshShell.CurrentDirectory    
wscript.echo f                       '查询当前目录
WshShell.CurrentDirectory = f &"\sysadmin\hostinfo\bin"    '设置当前目录
WshShell.run "setup.bat",1,true                       
'Wscript.Echo WshShell.CurrentDirectory

