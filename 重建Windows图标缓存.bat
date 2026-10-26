@echo off
taskkill /f /im explorer.exe
del /f /q "%localappdata%\IconCache.db"
del /f /q "%localappdata%\Microsoft\Windows\Explorer\iconcache_*.db"
del /f /q "%localappdata%\Microsoft\Windows\Explorer\thumbcache_*.db"
start explorer.exe
