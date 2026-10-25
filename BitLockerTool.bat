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
::cxY6rQJ7JhzQF1fEqQJhZk4aHErSXA==
::ZQ05rAF9IBncCkqN+0xwdVsFAlHMbCXqZg==
::ZQ05rAF9IAHYFVzEqQISIQ94QweJOXmOCboQiA==
::eg0/rx1wNQPfEVWB+kM9LVsJDCaLKEe1Bb4Z+tz04ObJp1UYNA==
::fBEirQZwNQPfEVWB+kM9LVsJDCaLKEe1Bb4Z+tz04Obn
::cRolqwZ3JBvQF1fEqQISIQ94QweJOXk/7lOZBDJyGwsCbLeVkyG2jG5eDXELxTdz
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATE100gMQldSwyWfCO5T/VOuLqtjw==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRmm/VYcJxhfSRYH1I0/6m+VHAl+IRAPZY6UoAO6r0peP2Pu
::Zh4grVQjdCyDJGmL5lYxKhdRDCKLMG6pOpcV/MT07OGCsH0cV+kDWobP9ruNK+UB3krredgozn86
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@setlocal EnableDelayedExpansion
@echo off
Title BitLocker 锁盘工具
mode con cols=75 lines=22
color 0F
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
pushd "%CD%"
CD /D "%~dp0"

:inputDrive
cls
echo.
echo                    ===== BitLocker 锁盘工具 =====
echo.
set "drive="
set /p drive="请输入要操作的盘符(不要有冒号)："
for /f "delims= " %%i in ("!drive!") do set "drive=%%i"
if "!drive!"=="" (
    echo 盘符不能为空，按任意键重新输入
    pause >nul
    goto inputDrive
)
::转大写，界面显示用
for /f %%a in ('powershell -c "$env:drive.ToUpper()"') do set "dispDrive=%%a"
::命令调用必须带冒号，仅内部使用
set "cmdDrive=!dispDrive!:"

:menu
cls
echo.
echo                    ===== BitLocker 锁盘工具 =====
echo  当前选择磁盘：!dispDrive!盘
echo.
echo 【警告】锁定时会临时关闭资源管理器，桌面短暂消失！
echo.
echo [L] 锁定 !dispDrive!盘(BitLocker)
echo [U] 解锁 !dispDrive!盘(BitLocker)
echo [C] 重新选择盘符
echo [Q] 退出
echo.
choice /C:LUcq /N
if errorlevel 4 goto exit
if errorlevel 3 goto inputDrive
if errorlevel 2 goto unlockd
if errorlevel 1 goto lockd

:lockd
cls
echo 正在锁定 !dispDrive!盘，释放磁盘占用句柄...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 /nobreak >nul
for /f "delims=" %%r in ('powershell -Command "manage-bde -lock !cmdDrive! *>&1 | Out-Null; Write $LASTEXITCODE"') do set ret=%%r
powershell -Command "Start-Sleep -Milliseconds 500"
start explorer.exe
if !ret! equ 0 (
    echo.
    echo 【成功】!dispDrive!盘锁定命令执行成功
) else (
    echo.
    echo 【失败】!dispDrive!盘锁定失败
    echo 常见原因：磁盘仍被程序占用 / 盘未启用BitLocker / 已处于锁定状态
)
echo.
pause
goto menu

:unlockd
cls
echo 正在解锁 !dispDrive!盘，请输入密码
echo.
for /f "delims=" %%r in ('powershell -Command "manage-bde -unlock !cmdDrive! -Password *>&1 | Out-Null; Write $LASTEXITCODE"') do set ret=%%r
if !ret! equ 0 (
    echo.
    echo 【成功】!dispDrive!盘解锁命令执行成功
) else (
    echo.
    echo 【失败】!dispDrive!盘解锁失败
    echo 检查：密码是否正确、磁盘状态、是否已经解锁
)
echo.
pause
goto menu

:exit
popd
powershell -Command "$scrDir='%~dp0'.TrimEnd('\');$tmpDir=$env:temp.TrimEnd('\');if($scrDir -eq $tmpDir){exit 0}else{exit 1}" >nul
if !errorlevel! equ 0 (
    start "" cmd /c "timeout /t 1 /nobreak >nul && del /f /q ""%~f0"" 2>nul"
)
endlocal
exit
