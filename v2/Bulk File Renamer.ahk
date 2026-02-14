; ==============================
; Bulk File Renamer (AHK v2)
; Hotkey: Ctrl+Shift+R
; Renames selected Explorer files to BaseName_1.ext, BaseName_2.ext, ...
; ==============================

#Requires AutoHotkey v2.0
#SingleInstance Force

^+r:: { ; Ctrl+Shift+R
    ; (Optional) ensure File Explorer is active
    if !(WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass")) {
        MsgBox "Select one or more files in File Explorer first.", "Bulk File Renamer", 48
        return
    }

    ; Save clipboard, copy selection from Explorer
    clipSaved := ClipboardAll()
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(1) || A_Clipboard = "" {
        A_Clipboard := clipSaved
        MsgBox "No files selected!", "Bulk File Renamer", 48
        return
    }

    ; Parse newline-separated file paths (trim quotes/CRLF)
    fileArray := []
    for line in StrSplit(A_Clipboard, "`n", "`r") {
        line := Trim(line, "`r`n" "")
        if line != ""
            fileArray.Push(line)
    }

    if fileArray.Length = 0 {
        A_Clipboard := clipSaved
        MsgBox "No valid files selected!", "Bulk File Renamer", 48
        return
    }

    ; Ask for base name (AHK v2: InputBox returns an object)
    result := InputBox("Enter base name for " fileArray.Length " file(s):", "Bulk File Renamer")
    if (result.Result = "Cancel" || result.Value = "") {
        A_Clipboard := clipSaved
        return
    }
    baseName := result.Value

    ; Optional settings
    startIndex := 1
    zeroPad := 0   ; e.g., 3 -> 001, 002 ...

    index := startIndex
    for filePath in fileArray {
        SplitPath filePath, &fileName, &fileDir, &fileExt, &fileNameNoExt, &drive
        num := (zeroPad > 0) ? Format("{:0" zeroPad "}", index) : index
        newName := baseName "_" num (fileExt ? "." fileExt : "")
        newPath := fileDir "\" newName

        ; Ensure uniqueness if the name exists already
        while FileExist(newPath) {
            index++
            num := (zeroPad > 0) ? Format("{:0" zeroPad "}", index) : index
            newName := baseName "_" num (fileExt ? "." fileExt : "")
            newPath := fileDir "\" newName
        }

        FileMove filePath, newPath
        index++
    }

    ; Restore clipboard
    A_Clipboard := clipSaved

    MsgBox "Renamed " fileArray.Length " file(s) to '" baseName "_*'", "Done", 64
}