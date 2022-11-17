; ====================================================
; ============= Hex String Converter CLI =============
; ====================================================
; AutoIt version: 3.3.12.0
; Language:       English
; Author:         Pedro F. Albanese
; Modified:       -
;
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

#NoTrayIcon

If $CmdLineRaw == "" Or $CmdLine[0] == 1 Then
	ConsoleWrite("HEX String 1.0 - ALBANESE Research Lab " & Chr(184) & " 2016" & @CRLF) ;
	ConsoleWrite("Usage: " & @ScriptName & " [-e|d] <string or file.ext>" & @CRLF) ;
Else
	If $CmdLine[2] == '-' Then
		Local $sOutput
		While True
			$sOutput &= ConsoleRead()
			If @error Then ExitLoop
			Sleep(25)
		WEnd
		$full = StringReplace($sOutput, @CRLF, '')
		$full = StringReplace($full, @LF, '')
		If $CmdLine[1] == "-e" Then
			ConsoleWrite(_StringToHexEx($full))
		ElseIf $CmdLine[1] == "-d" Then
			ConsoleWrite(_HexToStringEx($full))
		EndIf
	ElseIf $CmdLine[2] <> '' Then
		if FileExists($CmdLine[2]) Then
			$full = FileRead($CmdLine[2])
		Else
			$full = $CmdLine[2]
		EndIf
		If $CmdLine[1] == "-e" Then
			ConsoleWrite(_StringToHexEx($full))
		ElseIf $CmdLine[1] == "-d" Then
			ConsoleWrite(_HexToStringEx($full))
		EndIf
	EndIf
EndIf
Exit

Func _HexToStringEx($strHex)
	Return BinaryToString("0x" & $strHex)
EndFunc   ;==>_HexToStringEx

Func _StringToHexEx($strChar)
	Return Hex(StringToBinary($strChar))
EndFunc   ;==>_StringToHexEx
