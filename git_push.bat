@echo off

:: 工作目錄
set WORK_DIR=C:\Users\ahua\桌面\zotero-sync

cd /d "%WORK_DIR%"

:: 程式啟動時執行 git pull
echo Pulling latest changes from remote repository...
git pull origin main


:: 等待 Zotero 關閉
echo Waiting for Zotero to exit...
:CHECK_PROCESS
tasklist | findstr /I "zotero" >nul
if %errorlevel% equ 0 (
    timeout /t 5 >nul
    goto CHECK_PROCESS
)

:: Zotero 關閉後執行 git add、commit 和 push
echo Zotero closed. Running git add, commit, and push...
git add .
git commit -m "Sync on %date% %time%"
git push origin main

exit
