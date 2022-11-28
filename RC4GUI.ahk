; ====================================================
; ================ AHK Encryption GUI ================
; ====================================================
; AutoHotKey version: 2.0 RC
; Language:           English
; Author:             Pedro F. Albanese
; Modified:           -
;
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

#Requires AutoHotkey v2.0-
#Include Class_CNG.ahk
myGui := Gui()
myGui.OnEvent("Close", GuiClose)
myGui.MarginX := "20", myGui.MarginY := "10"
myGui.SetFont("s10", "Courier New")
ogcEditInput := myGui.Add("Edit", "w600 r10 vInput")
myGui.SetFont()
ogcButtonEncode := myGui.Add("Button", , "Encode")
ogcButtonEncode.OnEvent("Click", Encode.Bind("Normal"))
ogcButtonDecode := myGui.Add("Button", "x+m yp", "Decode")
ogcButtonDecode.OnEvent("Click", Decode.Bind("Normal"))
ogcEditKey := myGui.Add("text", "x160 y190 w200 h20", "Key:")
ogcEditKey := myGui.Add("Edit", "x190 y190 w200 h20 vKey", "")
ogcEditKey := myGui.Add("text", "x400 y190 w200 h20", "IV:")
ogcEditIV := myGui.Add("Edit", "x420 y190 w200 h20 vIV", "")
myGui.SetFont("s10", "Courier New")
ogcEditResult := myGui.Add("Edit", "xm w600 r10 vResult +ReadOnly")
myGui.Title := "AHK Encryption Tool " Chr(169) " 2020-2023 - ALBANESE Reasearch Lab"
myGui.Show()
return

GuiClose(*)
{ 
	ExitApp()
} 

Encode(A_GuiEvent, GuiCtrlObj, Info, *)
{ 
	oSaved := myGui.Submit("0")
	Input := oSaved.Input
	Key := oSaved.Key
	IV := oSaved.IV
	Result := oSaved.Result
	ogcEditResult.Value := Encrypt.String("RC4", "", Input, Key, "")
	return
} 

Decode(A_GuiEvent, GuiCtrlObj, Info, *)
{ 
	oSaved := myGui.Submit("0")
	Input := oSaved.Input
	Key := oSaved.Key
	IV := oSaved.IV
	Result := oSaved.Result
	ogcEditResult.Value := Decrypt.String("RC4", "", Input, Key, "")
	return
} 
