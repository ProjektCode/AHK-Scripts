#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; 🔹 Hotkey
; =========================================================
^!i:: ShowImageScanGUI()  ; Ctrl + Alt + I

; =========================================================
; 🔹 GUI Picker
; =========================================================
ShowImageScanGUI() {
    try g.Destroy()
    g := Gui("+AlwaysOnTop -Resize", "Image Resolution Prefixer")

    g.AddText("xm ym", "📁 Folder:")
    folderEdit := g.AddEdit("x+5 w300 vFolderPath")
    browseBtn := g.AddButton("x+5 w80", "Browse...")

    browseBtn.OnEvent("Click", (*) => (
        picked := FileSelect("D", "Select a folder to scan:"),
        picked ? folderEdit.Value := picked : ""
    ))

    includeSub := g.AddCheckbox("xm y+10 vIncludeSub", "Include subfolders")
    includeSub.Value := 0

    startBtn := g.AddButton("xm y+15 w390 h30 Default", "Start Scan")
    startBtn.OnEvent("Click", (*) => (
        folder := folderEdit.Value,
        recurse := includeSub.Value,
        (!folder || !DirExist(folder))
            ? MsgBox("❌ Please select a valid folder first.")
            : (g.Hide(), ProcessImages(folder, recurse))
    ))

    g.Show()
}

; ---- Configurable rules ----
MinHeight() => 1080
AcceptedRatios() => [16 / 9, 20 / 9, 11 / 6, 21 / 9]  ; add others like 21/9 → 7/3 if needed
AspectTolerance() => 0.02               ; ±2% tolerance around target ratio

IsAcceptedAspect(w, h) {
    ; Require at least 1080p height
    if (h < MinHeight())
        return false

    ratio := w / h
    for r in AcceptedRatios() {
        if (Abs(ratio - r) <= AspectTolerance())
            return true
    }

    return false
}



; =========================================================
; 🔹 Process all images with progress bar
; =========================================================
ProcessImages(folder, recurse := false) {
    files := []
    loop files folder "\*.*", recurse ? "FR" : "F" {
        if (A_LoopFileExt ~= "i)(jpg|jpeg|png|bmp|webp|tiff|gif)")
            files.Push(A_LoopFileFullPath)
    }

    total := files.Length
    if total = 0 {
        MsgBox "No image files found in folder."
        return
    }

    progressGui := Gui("+AlwaysOnTop", "Scanning...")
    progressGui.AddText("xm ym", "Processing images...")
    bar := progressGui.AddProgress("xm y+5 w350 h20 Range0-" total)
    status := progressGui.AddText("xm y+10 w350", "")
    progressGui.Show()

    renamed := 0

    loop total {
        file := files[A_Index]
        SplitPath file, &name, &dir, &ext, &nameNoExt

        res := GetImageSize(file)
        if !(res is Array)
            continue

        w := res[1], h := res[2]
        if (w = 0 || h = 0)
            continue

        ratio := w / h

        ; ✅ Only rename if roughly 16:9 and at least 1080p tall
        if IsAcceptedAspect(w, h) {
            prefix := w "x" h "_"
            if !InStr(nameNoExt, prefix) {
                newName := prefix nameNoExt "." ext
                newPath := dir "\" newName

                try {
                    FileMove(file, newPath)
                    renamed++
                    status.Value := "Renamed: " newName
                } catch as e {
                    status.Value := "Error: " e.Message
                }
            }
        } else {
            status.Value := Format("Skipped: {} ({}×{})", name, w, h)
        }


        bar.Value := A_Index
        Sleep(40)
    }

    progressGui.Destroy()
    MsgBox Format("✅ Scan complete.`nRenamed: {}`nScanned: {}", renamed, total)
}


; =========================================================
; 🔹 Get image size using GDI+
; =========================================================
GetImageSize(filePath) {
    static token := 0
    if !token {
        si := Buffer(16, 0)
        NumPut("UInt", 1, si)
        DllCall("Gdiplus.dll\GdiplusStartup", "Ptr*", &token, "Ptr", si, "Ptr", 0)
    }

    pBitmap := 0
    if DllCall("Gdiplus.dll\GdipCreateBitmapFromFile", "WStr", filePath, "Ptr*", &pBitmap) != 0 || !pBitmap
        return ""

    w := 0, h := 0
    DllCall("Gdiplus.dll\GdipGetImageWidth", "Ptr", pBitmap, "UIntP", &w)
    DllCall("Gdiplus.dll\GdipGetImageHeight", "Ptr", pBitmap, "UIntP", &h)
    DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)

    return [w, h]
}
