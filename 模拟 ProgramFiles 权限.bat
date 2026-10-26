@echo off
if not "%1"=="" (set "target=%~1") else (set /p "target=请输入目标文件夹完整路径：")
if not exist "%target%" (echo 文件夹不存在！&pause&exit)
echo 正在设置权限，模拟 Program Files，递归所有子项...
echo.

:: 1. 设置所有者为 TrustedInstaller（和真实Program Files一致）
icacls "%target%" /setowner "NT SERVICE\TrustedInstaller" /T /C

:: 2. 清除原有继承权限
icacls "%target%" /inheritance:r /T /C

:: 3. 依次添加ACL，完全复刻Program Files权限
icacls "%target%" /grant "NT SERVICE\TrustedInstaller:(OI)(CI)F" /T /C
icacls "%target%" /grant "NT AUTHORITY\SYSTEM:(OI)(CI)M" /T /C
icacls "%target%" /grant "BUILTIN\Administrators:(OI)(CI)M" /T /C
icacls "%target%" /grant "BUILTIN\Users:(OI)(CI)RX" /T /C

echo.
echo 权限设置完成！
echo 效果：普通用户只能读取浏览，新建/删除/修改会拒绝；管理员操作会弹出UAC盾牌提示，点继续即可修改。
pause
