@echo off
if not "%1"=="" (set "target=%~1") else (set /p "target=请输入目标文件夹完整路径：")
if not exist "%target%" (echo 文件夹不存在！&pause&exit)
echo 正在恢复文件夹权限...
takeown /f "%target%" /r /d y
icacls "%target%" /setowner administrators /T /C
icacls "%target%" /inheritance:e /T /C
icacls "%target%" /grant everyone:F /T /C
echo 权限恢复完毕
pause
