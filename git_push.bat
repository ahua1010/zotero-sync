@echo off
tasklist | findstr /I "zotero" >nul
if %errorlevel% equ 0 (
    echo Commit failed, please exit Zotero first!
    pause
) else (
    echo Running git pull, add, commit, and push...
    cd "C:\Users\ahua\桌面\zotero-sync"
    git pull origin main
    git add .
    git commit -m "%date% %time%"
    git push origin main
)
