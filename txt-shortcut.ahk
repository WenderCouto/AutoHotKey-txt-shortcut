#Requires AutoHotkey v2.0

^+t:: {
    for window in ComObject("Shell.Application").Windows {
        if (window.HWND = WinActive("ahk_class CabinetWClass") || window.HWND = WinActive("ahk_class Explorer")) {
            CurrentDir := window.document.folder.self.path
            break
        }
    }

    if CurrentDir {
        FileName := "NovoArquivo.txt"
        FullPath := CurrentDir . "\" . FileName

        if !FileExist(FullPath) {
            try FileAppend("", FullPath)
            catch {
                ; Reexecuta com elevação se necessário
                RunAsAdmin(CurrentDir)
                return
            }
        }
        Run("notepad.exe " FullPath)
    } else {
        MsgBox("A janela ativa não é uma janela do Explorer.")
    }
}

RunAsAdmin(CurrentDir) {
    Cmd := A_ProgramFiles . "\AutoHotkey\AutoHotkey.exe"
    Params := '"' A_ScriptFullPath '" create_file "' CurrentDir '"'
    Run('*RunAs "' Cmd '" ' Params)
}

create_file(CurrentDir) {
    FileName := "NovoArquivo.txt"
    FullPath := CurrentDir . "\" . FileName
    try FileAppend("", FullPath)
    catch {
        MsgBox("Erro ao criar o arquivo. Verifique permissões.")
        return
    }
    Run("notepad.exe " FullPath)
}
