# zotero_sync
與我的 Zotero 庫關聯的文件（主要是 pdf）的存儲

我按照[此處](https://ikashnitsky.github.io/2019/zotero/)的說明進行操作，但是在 zotero 7中 zotFile 已失效，因此改用attanger。
此設定允許 Zotero 管理元資料的同步，同時讓使用者控製檔案本身的同步（此處為 GitHub）。

這使得可以在多台電腦上使用 Zotero 並將檔案與 Git 同步。例如，如果我在筆記型電腦上向 Zotero 新增參考和 PDF，我可以將檔案「git push」到 GitHub，然後在桌面上「git pull」來取得 PDF。 Zotero 本身負責同步元資料以及 PDF 中的反白、評論和註釋。

我還在儲存庫中包含了一個批次檔腳本，檢查 Zotero 是否關閉，然後執行本機儲存庫的git pull、 add、commit和push。

# 操作說明
## 在設定過的電腦操作
1. 將此存儲庫clone到你的電腦
2. 安裝[Zotero](https://www.zotero.org)
3. 安裝Zotero的[Attanger](https://github.com/MuiseDestiny/zotero-attanger)擴展
4.安裝 Zotero 的 [Better BibTeX](https://retorque.re) 擴展(可選
5. 啟用 Zotero Sync 並登入您的帳戶
6. 檢查 Zotero 設定是否與以下圖片中的選項相符。
![image](https://github.com/user-attachments/assets/c4588fc5-e3b1-43c6-b4bf-854305fe2976)
![image](https://github.com/user-attachments/assets/3254063d-5ca9-4887-8746-69a2114859c6)
  <img width="757" alt="螢幕擷取畫面 2025-01-16 180610" src="https://github.com/user-attachments/assets/00d822bb-547f-4835-b25e-5a175a72253f" />
  <img width="754" alt="螢幕擷取畫面 2025-01-16 180718" src="https://github.com/user-attachments/assets/484908dd-f9ec-45e0-a842-91abd5710125" />

## 設定工作排程器以同步到 Git
### 啟用 「application start」 紀錄記錄
1. 打開「運行」或按 win+R 輸入 secpol.msc
2. 導航到本機原則/稽核原則
3. 按二下 「稽核程序追蹤」並啟用"成功"
現在，如果您啟動任何應用程式，如果您查看 Event Viewer/Security Log，則每次啟動應用程式時，您都會看到一個 Process Creation 事件 4688。

### 設定工作排程器以自動同步
1. 打開 工作排程器 並創建新工作
2. 在 一般 選項卡上，為任務命名
3. 在 觸發 選項卡上，創建一個新觸發器，然後選擇 On an event （事件發生時） 作為觸發器
4. 選擇 Custom （自定義），然後按兩下 Edit Event Filter （編輯事件過濾器）
5. 更改 Filter （過濾器） 設定，如下所示：
![image](https://github.com/user-attachments/assets/0fe1ca89-6bd5-4859-9a5a-4f7d06903a3e)
6. 現在切換到 XML 選項卡，並手動啟用編輯查詢，並輸入
    ```
    <QueryList>
      <Query Id="0" Path="Security">
        <Select Path="Security">
         *[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and Task = 13312 and (band(Keywords,9007199254740992)) and (EventID=4688)]] 
       and
         *[EventData[Data[@Name='NewProcessName'] and (Data='Your_Process_Path')]]
        </Select>
      </Query>
    </QueryList>
    ```
    Your_Process_Path 請改為您的Zotero.exe所在位置
    然後按兩下Ok關閉觸發器對話框。此觸發器可以監測zotero程序的啟動
7. 同樣的方式，創建第二個觸發器，過濾器輸入:
    ```
    <QueryList>
      <Query Id="0" Path="Security">
        <Select Path="Security">
         *[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and Task = 13312 and (band(Keywords,9007199254740992)) and (EventID=4688)]] 
       and
         *[EventData[Data[@Name='NewProcessName'] and (Data='Your_Process_Path')]]
        </Select>
      </Query>
    </QueryList>
    ```
    Your_Process_Path 請改為您的Zotero.exe所在位置
    然後按兩下Ok關閉觸發器對話框。此觸發器可以監測zotero程序的終止
8. 在 動作 選項卡上，新增動作"啟動程式"
9. 設定"程式或指令碼"為複製下來的檔案夾中的 git_push.bat 的路徑
10. 開始位置設定為複製下來的檔案夾位置
![image](https://github.com/user-attachments/assets/200a8345-1670-4572-a6df-94ba08cbef16)


這會將所有變更或附加檔案推送到 GitHub，並以日期作為提交訊息。

## 手動新增引用

您也可以下載該檔案並將其拖曳到 Zotero 中。右鍵單擊該文件並選擇管理附件 -> 重新命名和移動。

這也適用於向現有 Zotero 參考新增補充文件。

您也可以全選整個庫並執行“重新命名和移動”所有內容。

## 更新/資料元數據

如果 Zotero 不會自動提取元數據（通常適用於較舊的參考），您可以自行添加元數據，只需確保按照上述說明重命名和移動文件即可。

## 刪除檔案/引用

由於檔案現在儲存在 Zotero 目錄之外，因此刪除 Zotero 中的引用不會刪除實際檔案。為此，右鍵單擊引用 -> 顯示文件位置，然後刪除那裡的文件。
