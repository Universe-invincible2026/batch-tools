@echo off
chcp 65001 >nul
if not "%1"=="" (set "target=%~1") else (set /p "target=请输入目标文件完整路径：")
if not exist "%target%" (echo 文件不存在！&pause&exit)
echo 正在设置权限，复刻系统hosts文件权限...
echo.
:: 1. 设置所有者为 SYSTEM（hosts真实所有者）
icacls "%target%" /setowner "NT AUTHORITY\SYSTEM" /C
:: 2. 关闭继承父文件夹权限（hosts不继承上级目录ACL）
icacls "%target%" /inheritance:r /C
:: 3. 复刻hosts的ACL权限
icacls "%target%" /grant "NT AUTHORITY\SYSTEM:(F)" /C
icacls "%target%" /grant "BUILTIN\Administrators:(RX)" /C
icacls "%target%" /grant "BUILTIN\Users:(RX)" /C
echo.
echo 权限设置完成！
echo 效果：普通用户、管理员默认只有读取权限，直接写入保存会拒绝访问，行为和原生hosts一致。
pause
