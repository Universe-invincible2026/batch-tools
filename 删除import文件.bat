@echo off
echo 即将删除 当前文件夹 及 所有子文件夹 下的 .import 文件
echo.
echo 待删除文件：
dir /b /s "%~dp0*.import"
echo.
set /p "confirm=确认删除吗(y_是/n_否)："
if /i "%confirm%"=="y" (
    del /s /q "%~dp0*.import"
    echo 删除完成
) else (
    echo 已取消
)
pause