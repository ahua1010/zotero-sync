@echo off
:: 定義Zotero執行檔名稱和Git儲存庫路徑
set ProgramName=zotero
set RepoPath=C:\Users\ahua\桌面\zotero-sync

:: 檢查程式是否開啟
tasklist | findstr /I "%ProgramName%" >nul
if %errorlevel% equ 0 (
    echo "%ProgramName% is running. Performing git pull..."
    cd "%RepoPath%"
    git pull origin main
    echo Git pull completed.
) else (
    echo "%ProgramName% is not running. Performing git push..."
    cd "%RepoPath%"
    git add .
    git commit -m "%date% %time%"
    git push origin main
    echo Git push completed.
    

)	

exit
