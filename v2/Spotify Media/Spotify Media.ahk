#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JsonHelper.ahk  ; JSON parser (JsonLoad / JsonDump)

; ==============================
; 🔹 Global State
; ==============================
global lastTrackId := ""
global lastPlaying := false
global pollInterval := 5000
global skipCooldown := 0
global gToast := ""

; ==============================
; 🔹 Load Config
; ==============================
cfgPath := A_ScriptDir "\config.json"
try {
    jsonText := FileRead(cfgPath, "UTF-8")
    cfg := JsonLoad(&jsonText)
    if (cfg.Has("poll_interval_ms"))
        pollInterval := cfg["poll_interval_ms"]
} catch {
    ; fallback if config missing/broken
}

; ==============================
; 🔹 Hotkeys
; ==============================
^+Right:: {
    Send "{Media_Next}"
    Toast("Next ▶", 500)
    skipCooldown := A_TickCount + 2000
    Sleep(1000)
    UpdatePlaybackState(true)
}

^+Left:: {
    Send "{Media_Prev}"
    Toast("Previous ◀", 500)
    skipCooldown := A_TickCount + 2000
    Sleep(1000)
    UpdatePlaybackState(true)
}

^+Down:: {
    Send "{Media_Play_Pause}"
    Toast("Play/Pause ⏯", 500)
    skipCooldown := A_TickCount + 2000
}

; Debug hotkeys
F11:: Toast(GetNowPlaying(), 4000)

; Force refresh token
F12:: {
    cfgPath := A_ScriptDir "\config.json"
    cfgJson := FileRead(cfgPath, "UTF-8")
    cfg := JsonLoad(&cfgJson)

    req := ComObject("WinHttp.WinHttpRequest.5.1")
    req.Open("POST", "https://accounts.spotify.com/api/token", false)
    auth := "Basic " . Base64Encode(cfg["client_id"] . ":" . cfg["client_secret"])
    req.SetRequestHeader("Authorization", auth)
    req.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    req.Send("grant_type=refresh_token&refresh_token=" . cfg["refresh_token"])

    if (req.Status != 200) {
        MsgBox "Error forcing token refresh: " req.Status "`n" req.ResponseText
        return
    }

    jsonText := req.ResponseText
    data := JsonLoad(&jsonText)

    newToken := data["access_token"]
    expiresIn := data["expires_in"] * 1000

    cfg["access_token"] := newToken
    cfg["expires_at"] := A_TickCount + expiresIn - 60000

    FileDelete cfgPath
    FileAppend JsonDump(cfg, "  "), cfgPath, "UTF-8"

    Toast("Access token refreshed ✅", 3000)
}

; ==============================
; 🔹 Main Timer Loop
; ==============================
SetTimer(UpdatePlaybackState, pollInterval)

UpdatePlaybackState(force := false) {
    global skipCooldown, lastTrackId, lastPlaying, lastTrackChange

    if (!force && A_TickCount < skipCooldown)
        return

    data := GetCurrentTrack()
    if !data
        return

    track := ExtractTrackInfo(data)
    if !track
        return

    ; Track change
    if (track.id != lastTrackId) {
        lastTrackId := track.id
        lastTrackChange := A_TickCount
        if (track.isPlaying)
            ShowTrackToast(track, 4000)
    }

    ; Pause/resume detection
    if (track.isPlaying != lastPlaying) {
        lastPlaying := track.isPlaying
        if (A_TickCount - lastTrackChange > 3000) {
            if track.isPlaying
                Toast("Playback Resumed ▶", 2000)
            else
                Toast("Playback Paused ⏸", 2000)
        }
    }
}

; ==============================
; 🔹 Spotify Helpers
; ==============================
GetNowPlaying() {
    accessToken := GetAccessToken()
    req := ComObject("WinHttp.WinHttpRequest.5.1")
    req.Open("GET", "https://api.spotify.com/v1/me/player/currently-playing", false)
    req.SetRequestHeader("Authorization", "Bearer " accessToken)
    req.Send()

    if (req.Status = 204)
        return "Nothing playing"
    if (req.Status != 200)
        return "Error " req.Status

    jsonText := req.ResponseText
    data := JsonLoad(&jsonText)
    try {
        title := data["item"]["name"]
        artist := data["item"]["artists"][1]["name"]
        return title " - " artist
    } catch as e {
        return "Parse error: " e.Message
    }
}

GetAccessToken() {
    cfgPath := A_ScriptDir "\config.json"
    jsonText := FileRead(cfgPath, "UTF-8")
    cfg := JsonLoad(&jsonText)

    if (cfg["access_token"] != "" && A_TickCount < cfg["expires_at"])
        return cfg["access_token"]

    req := ComObject("WinHttp.WinHttpRequest.5.1")
    req.Open("POST", "https://accounts.spotify.com/api/token", false)
    auth := "Basic " . Base64Encode(cfg["client_id"] . ":" . cfg["client_secret"])
    req.SetRequestHeader("Authorization", auth)
    req.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    req.Send("grant_type=refresh_token&refresh_token=" . cfg["refresh_token"])

    if (req.Status != 200) {
        MsgBox "Error refreshing token: " req.Status "`n" req.ResponseText
        return ""
    }

    respText := req.ResponseText
    data := JsonLoad(&respText)
    newToken := data["access_token"]
    expiresIn := data["expires_in"] * 1000

    cfg["access_token"] := newToken
    cfg["expires_at"] := A_TickCount + expiresIn - 60000

    FileDelete cfgPath
    FileAppend JsonDump(cfg, "  "), cfgPath, "UTF-8"

    Toast("🔄 Token refreshed", 2000)
    return newToken
}

GetCurrentTrack() {
    accessToken := GetAccessToken()
    if (accessToken = "")
        return ""
    req := ComObject("WinHttp.WinHttpRequest.5.1")
    req.Open("GET", "https://api.spotify.com/v1/me/player/currently-playing", false)
    req.SetRequestHeader("Authorization", "Bearer " accessToken)
    req.Send()
    if (req.Status != 200)
        return ""
    jsonText := req.ResponseText
    return JsonLoad(&jsonText)
}

ExtractTrackInfo(data) {
    try {
        track := Map()
        track.id := data["item"]["id"]
        track.title := TrimText(data["item"]["name"], 40)
        track.artist := TrimText(data["item"]["artists"][1]["name"], 30)
        track.isPlaying := data["is_playing"]

        ; Cover image (64x64 fallback)
        images := data["item"]["album"]["images"]
        track.coverUrl := (images.Length >= 3) ? images[3]["url"]
            : (images.Length >= 2) ? images[2]["url"]
                : (images.Length >= 1) ? images[1]["url"]
                    : ""

        return track
    } catch {
        return ""
    }
}

ShowTrackToast(track, ms := 4000) {
    if !track
        return
    ToastTrack(track.title, track.artist, track.coverUrl, ms)
}

; ==============================
; 🔹 Utilities
; ==============================
TrimText(str, maxLen := 30) {
    return (StrLen(str) > maxLen) ? SubStr(str, 1, maxLen - 1) "…" : str
}

Base64Encode(str) {
    bytes := StrPut(str, "UTF-8") - 1
    buf := Buffer(bytes)
    StrPut(str, buf, "UTF-8")

    DllCall("Crypt32.dll\CryptBinaryToStringW"
        , "Ptr", buf, "UInt", bytes, "UInt", 0x1
        , "Ptr", 0, "UIntP", &outLen := 0)

    out := Buffer(outLen * 2)
    DllCall("Crypt32.dll\CryptBinaryToStringW"
        , "Ptr", buf, "UInt", bytes, "UInt", 0x1
        , "Ptr", out, "UIntP", outLen)

    return StrReplace(StrGet(out), "`r`n")
}

UrlDownloadToFile(URL, Filename) {
    req := ComObject("WinHttp.WinHttpRequest.5.1")
    req.Open("GET", URL, false)
    req.Send()
    if (req.Status != 200)
        throw Error("Download failed: " req.Status)

    body := req.ResponseBody
    stream := ComObject("ADODB.Stream")
    stream.Type := 1
    stream.Open()
    stream.Write(body)
    stream.SaveToFile(Filename, 2)
    stream.Close()
}

CryptStringToBinary(b64) {
    DllCall("Crypt32.dll\CryptStringToBinaryW"
        , "Str", b64, "UInt", 0, "UInt", 1
        , "Ptr", 0, "UIntP", &size := 0
        , "Ptr", 0, "Ptr", 0)
    buf := Buffer(size)
    DllCall("Crypt32.dll\CryptStringToBinaryW"
        , "Str", b64, "UInt", 0, "UInt", 1
        , "Ptr", buf, "UIntP", &size
        , "Ptr", 0, "Ptr", 0)
    return buf
}

; ==============================
; 🔹 Toast Popup
; ==============================
Toast(msg, ms := 3000) {
    if !msg
        msg := "No data"

    global gToast
    try gToast.Destroy()

    primary := MonitorGetPrimary()
    MonitorGetWorkArea(primary, &L, &T, &R, &B)

    gToast := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    gToast.BackColor := "0x202020"
    gToast.SetFont("s10", "Segoe UI")
    gToast.AddText("xm ym cWhite", msg)

    gToast.Show("AutoSize Hide")
    gToast.GetPos(, , &w, &h)
    x := R - w - 20, y := B - h - 20
    gToast.Show("x" x " y" y " NA")

    SetTimer(() => (gToast && gToast.Destroy(), gToast := ""), -ms)
}

; ==============================
; 🔹 Toast with Album Art + Track Info (no animation)
; ==============================
ToastTrack(title, artist, coverUrl := "", ms := 4000) {
    global gToast
    try gToast.Destroy()

    tmpFile := A_Temp "\cover.jpg"
    hasCover := false
    if (coverUrl != "") {
        try {
            UrlDownloadToFile(coverUrl, tmpFile)
            hasCover := true
        }
    }

    ; Fallback placeholder (writes once)
    if !hasCover {
        placeholder := A_Temp "\placeholder.png"
        if !FileExist(placeholder) {
            placeholderB64 :=
                (
                    "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAm0lEQVR4nO3UsQkCMRAF0af7" .
                    "3zHZCIQkF1dIoh8wZKn6gCj0KwvBNz7ku8YYN+vC8AQAAAAAAAAAAAAAAAADgFQFNgTsjaY9r" .
                    "x1wbmD3P07gho7WZBrvEKQnVzthYia0ct1XQgWUb5pPMFJX9T9FJq8vA/Z6cfXyz8lm9E9LQ9" .
                    "i+VYQkDchuh5f2XAKIfu9MLj4u8qecLQDwAAAAAAAAAAAAAAAAAAgNcAx0L29SkRuHwAAAAA" .
                    "SUVORK5CYII="
                )
            Bin := CryptStringToBinary(placeholderB64)
            f := FileOpen(placeholder, "w"), f.RawWrite(Bin, Bin.Size), f.Close()
        }
        tmpFile := placeholder
    }

    primary := MonitorGetPrimary()
    MonitorGetWorkArea(primary, &L, &T, &R, &B)

    gToast := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    gToast.BackColor := "0x202020"

    gToast.AddPicture("x10 y10 w64 h64", tmpFile)
    gToast.SetFont("s10 bold", "Segoe UI")
    gToast.AddText("x84 y10 cWhite Left", title)
    gToast.SetFont("s9", "Segoe UI")
    gToast.AddText("x84 y+5 cGray Left", artist)

    gToast.Show("AutoSize Hide")
    gToast.GetPos(, , &w, &h)
    x := R - w - 20, y := B - h - 20
    gToast.Show("x" x " y" y " NoActivate")

    WinSetRegion("0-0 w" w " h" h " R15-15", gToast.Hwnd)

    SetTimer(() => (gToast && gToast.Destroy(), gToast := ""), -ms)
}