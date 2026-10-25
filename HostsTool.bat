::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGmL5lYxKhdRDCKLMG6pOpcV/MT07OGCsH0cV+kDKcHS2bvu
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZkkaHErSXA==
::ZQ05rAF9IBncCkqN+0xwdVsFAlbMbCXqZg==
::ZQ05rAF9IAHYFVzEqQIYJwhAXzCNM2fa
::eg0/rx1wNQPfEVWB+kM9LVsJDCyNL3+pMroT5Kb+9+/n
::fBEirQZwNQPfEVWB+kM9LVsJDCyNL3+pMroT5Ig=
::cRolqwZ3JBvQF1fEqQI4JwhAX4FV+e5f0dU=
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATE100gMQldSwyWfCO5T/VOuLqtjw==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRmM+1EkO56DiYFn6ws=
::Zh4grVQjdCyDJGmL5lYxKhdRDCKLMG6pOp0T+/zo2+WIrnE1W/Era7vU1bjAJfgWig==
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
chcp 936 >nul
title Hosts工具
set "CORRECT_PWD=1234"
cls
set "USER_PW="
set /p USER_PW=请输入密码：
if not "%USER_PW%"=="%CORRECT_PWD%" (
echo 密码错误，退出
timeout /t 2 /nobreak>nul
exit
)
set "SYSHOST=%SystemRoot%\System32\drivers\etc\hosts"
set "BAKHOST=%SYSHOST%.bak"
set "TMPHOST=%temp%\__tmp_hosts.txt"

:MENU
cls
echo ======================================
echo        Hosts双配置管理工具
echo 1.载入配置1
echo 2.载入配置2
echo 3.恢复系统原始hosts备份
echo 4.退出
echo ======================================
set /p sel=请输入数字选择：
if "%sel%"=="1" goto SET1
if "%sel%"=="2" goto SET2
if "%sel%"=="3" goto RESTORE_BAK
if "%sel%"=="4" goto EXIT
goto MENU

:: 获取hosts写入权限
:GET_HOSTS_PERM
takeown /f "%SYSHOST%" >nul 2>&1
icacls "%SYSHOST%" /grant Administrators:F >nul 2>&1
goto :EOF

:: 恢复hosts原生系统权限
:RESTORE_HOSTS_PERM
icacls "%SYSHOST%" /setowner "NT AUTHORITY\SYSTEM" >nul 2>&1
icacls "%SYSHOST%" /inheritance:r >nul 2>&1
icacls "%SYSHOST%" /grant "NT AUTHORITY\SYSTEM:(F)" >nul 2>&1
icacls "%SYSHOST%" /grant "BUILTIN\Administrators:(RX)" >nul 2>&1
icacls "%SYSHOST%" /grant "BUILTIN\Users:(RX)" >nul 2>&1
goto :EOF

:SET1
if not exist "%BAKHOST%" call :GET_HOSTS_PERM & copy "%SYSHOST%" "%BAKHOST%" >nul
(
echo 0.0.0.0 www.bilibili.com
echo 0.0.0.0 bilibili.com
echo 0.0.0.0 api.bilibili.com
echo 0.0.0.0 app.bilibili.com
echo 0.0.0.0 s1.hdslb.com
echo 0.0.0.0 upos-sz.bilivideo.com
echo 0.0.0.0 search.bilibili.com/all
echo 0.0.0.0 search.bilibili.com
) >"%TMPHOST%"
call :GET_HOSTS_PERM
copy /y "%TMPHOST%" "%SYSHOST%" >nul
call :RESTORE_HOSTS_PERM
ipconfig /flushdns >nul
echo 完成：已加载配置1，DNS刷新完毕
pause
goto MENU

:SET2
if not exist "%BAKHOST%" call :GET_HOSTS_PERM & copy "%SYSHOST%" "%BAKHOST%" >nul
(
echo 0.0.0.0 www.bilibili.com
echo 0.0.0.0 bilibili.com
echo 0.0.0.0 api.bilibili.com
echo 0.0.0.0 app.bilibili.com
echo 0.0.0.0 s1.hdslb.com
echo 0.0.0.0 upos-sz.bilivideo.com
echo 0.0.0.0 codinghou.cn
echo 0.0.0.0 doubao.com
echo 0.0.0.0 www.doubao.com
echo 0.0.0.0 www.ccw.site
echo 0.0.0.0 ccw.site
echo 0.0.0.0 search.bilibili.com/all
echo 0.0.0.0 search.bilibili.com
) >"%TMPHOST%"
call :GET_HOSTS_PERM
copy /y "%TMPHOST%" "%SYSHOST%" >nul
call :RESTORE_HOSTS_PERM
ipconfig /flushdns >nul
echo 完成：已加载配置2，DNS刷新完毕
pause
goto MENU

:RESTORE_BAK
if exist "%BAKHOST%" (
call :GET_HOSTS_PERM
copy /y "%BAKHOST%" "%SYSHOST%" >nul
call :RESTORE_HOSTS_PERM
ipconfig /flushdns >nul
echo 完成：已恢复系统原始hosts备份
) else (
echo 警告：未找到备份，请先加载任意配置生成备份
)
pause
goto MENU

:EXIT
del /f /q "%TMPHOST%" 2>nul
exit
