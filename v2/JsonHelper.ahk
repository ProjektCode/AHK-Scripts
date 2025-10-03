#Requires AutoHotkey v2.0

; =========================================================
; Jxon JSON Library for AutoHotkey v2
; Based on cocobelgica's AHK JSON implementation
; https://github.com/cocobelgica/AutoHotkey-JSON
; =========================================================

JsonLoad(&src, args*) {
    key := "", is_key := false
    stack := [tree := []]
    next := '"{[01234567890-tfn'
    pos := 0

    while ((ch := SubStr(src, ++pos, 1)) != "") {
        if InStr(" `t`n`r", ch)
            continue
        if !InStr(next, ch, true) {
            throw Error("Unexpected character in JSON", -1, ch)
        }

        obj := stack[1]
        is_array := (obj is Array)

        if i := InStr("{[", ch) {
            val := (i = 1) ? Map() : Array()
            is_array ? obj.Push(val) : obj[key] := val
            stack.InsertAt(1, val)
            next := '"' ((is_key := (ch == "{")) ? "}" : "{[]0123456789-tfn")
        } else if InStr("}]", ch) {
            stack.RemoveAt(1)
            next := (stack[1] == tree) ? "" : (stack[1] is Array) ? ",]" : ",}"
        } else if InStr(",:", ch) {
            is_key := (!is_array && ch == ",")
            next := is_key ? '"' : '"{[0123456789-tfn'
        } else {
            if (ch == '"') {
                i := pos
                while i := InStr(src, '"', , i + 1) {
                    val := StrReplace(SubStr(src, pos + 1, i - pos - 1), "\\", "\u005C")
                    if (SubStr(val, -1) != "\")
                        break
                }
                pos := i
                val := StrReplace(val, "\/", "/")
                val := StrReplace(val, '\"', '"')
                val := StrReplace(val, "\b", "`b")
                val := StrReplace(val, "\f", "`f")
                val := StrReplace(val, "\n", "`n")
                val := StrReplace(val, "\r", "`r")
                val := StrReplace(val, "\t", "`t")
                if is_key {
                    key := val, next := ":"
                    continue
                }
            } else {
                val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$", , pos) - pos)
                if IsInteger(val)
                    val += 0
                else if IsFloat(val)
                    val += 0
                else if (val == "true" || val == "false")
                    val := (val == "true")
                else if (val == "null")
                    val := ""
                else if is_key {
                    pos--, next := "#"
                    continue
                }
                pos += i - 1
            }
            is_array ? obj.Push(val) : obj[key] := val
            next := obj == tree ? "" : is_array ? ",]" : ",}"
        }
    }
    return tree[1]
}

JsonDump(obj, indent := "", lvl := 1) {
    if IsObject(obj) {
        if !(obj is Array || obj is Map)
            throw Error("Unsupported object type.")

        if IsInteger(indent) {
            if (indent < 0)
                throw Error("Indent must be >= 0")
            spaces := indent, indent := ""
            loop spaces
                indent .= " "
        }
        indt := ""
        loop indent ? lvl : 0
            indt .= indent
        is_array := (obj is Array)
        lvl += 1, out := ""
        for k, v in obj {
            if !is_array
                out .= JsonDump(k) (indent ? ": " : ":")
            out .= JsonDump(v, indent, lvl) . (indent ? ",`n" . indt : ",")
        }
        if (out != "") {
            out := RTrim(out, ",`n" . indent)
            if (indent != "")
                out := "`n" . indt . out . "`n" . SubStr(indt, StrLen(indent) + 1)
        }
        return is_array ? "[" . out . "]" : "{" . out . "}"
    } else if (obj is Number)
        return obj
    else {
        obj := StrReplace(obj, "\", "\\")
        obj := StrReplace(obj, "`t", "\t")
        obj := StrReplace(obj, "`r", "\r")
        obj := StrReplace(obj, "`n", "\n")
        obj := StrReplace(obj, "`b", "\b")
        obj := StrReplace(obj, "`f", "\f")
        obj := StrReplace(obj, "/", "\/")
        obj := StrReplace(obj, '"', '\"')
        return '"' obj '"'
    }
}
