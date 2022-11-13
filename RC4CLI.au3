; ====================================================
; ============= Encryption Tool With GUI =============
; ====================================================
; AutoIt version: 3.0.103
; Language:       English
; Author:         "Pedro F. Albanese"
; Modified:       -
;
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

#NoTrayIcon

If $CmdLineRaw == "" Or $CmdLine[0] == "1" Or $CmdLine[0] == "2" Then
	ConsoleWrite("RC4 Encrypt 1.0 - ALBANESE Research Lab " & Chr(184) & " 2016" & @CRLF) ;
	ConsoleWrite("Usage: " & @ScriptName & " [-e|d] <file.ext> <password>" & @CRLF) ;
Else
	If FileExists($CmdLine[2]) Then
		$full = FileRead($CmdLine[2], 300000000)
		If $CmdLine[1] == "-e" Then
			FileOpen($CmdLine[2], 2)
			FileWrite($CmdLine[2], _StringEncryptRC4($full, $CmdLine[3]))
		ElseIf $CmdLine[1] == "-d" Then
			FileOpen($CmdLine[2], 2)
			FileWrite($CmdLine[2], _StringDecryptRC4($full, $CmdLine[3]))
		EndIf
	Else
		ConsoleWrite("Error: """ & $CmdLine[1] & """ not found." & @CRLF) ;
	EndIf
EndIf
Exit

Func _StringEncryptRC4($text, $encryptkey)
	Local $sbox[256]
	Local $key[256]
	Local $temp
	Local $a
	Local $i
	Local $j
	Local $k
	Local $cipherby
	Local $cipher

	$i = 0
	$j = 0

	__RC4Initialize($encryptkey, $key, $sbox)

	For $a = 1 To StringLen($text)
		$i = Mod(($i + 1), 256)
		$j = Mod(($j + $sbox[$i]), 256)
		$temp = $sbox[$i]
		$sbox[$i] = $sbox[$j]
		$sbox[$j] = $temp

		$k = $sbox[Mod(($sbox[$i] + $sbox[$j]), 256)]

		$cipherby = BitXOR(Asc(StringMid($text, $a, 1)), $k)
		$cipher = $cipher & Chr($cipherby)
	Next

	Return StringToBinary($cipher)
EndFunc   ;==>_StringEncryptRC4

Func _StringDecryptRC4($text, $encryptkey)
	Local $sbox[256]
	Local $key[256]
	Local $temp
	Local $a
	Local $i
	Local $j
	Local $k
	Local $cipherby
	Local $cipher
	$text = BinaryToString($text)

	$i = 0
	$j = 0

	__RC4Initialize($encryptkey, $key, $sbox)

	For $a = 1 To StringLen($text)
		$i = Mod(($i + 1), 256)
		$j = Mod(($j + $sbox[$i]), 256)
		$temp = $sbox[$i]
		$sbox[$i] = $sbox[$j]
		$sbox[$j] = $temp

		$k = $sbox[Mod(($sbox[$i] + $sbox[$j]), 256)]

		$cipherby = BitXOR(Asc(StringMid($text, $a, 1)), $k)
		$cipher = $cipher & Chr($cipherby)
	Next
	Return $cipher
EndFunc   ;==>_StringDecryptRC4

; Helper function
Func __RC4Initialize($strPwd, ByRef $key, ByRef $sbox)
	Dim $tempSwap
	Dim $a
	Dim $b

	$intLength = StringLen($strPwd)
	For $a = 0 To 255
		$key[$a] = Asc(StringMid($strPwd, (Mod($a, $intLength)) + 1, 1))
		$sbox[$a] = $a
	Next

	$b = 0
	For $a = 0 To 255
		$b = Mod($b + $sbox[$a] + $key[$a], 256)
		$tempSwap = $sbox[$a]
		$sbox[$a] = $sbox[$b]
		$sbox[$b] = $tempSwap
	Next
EndFunc   ;==>__RC4Initialize

Func Rot47($input)
	Local $rotted = ""
	For $i = 1 To StringLen($input)
		$pos = Asc(StringMid($input, $i, 1))
		If $pos > 79 And $pos < 127 Then ;$pos > 32 And
			$rotted &= Chr($pos - 47)
		ElseIf $pos > 32 And $pos < 80 Then ;And $pos < 127
			$rotted &= Chr($pos + 47)
		Else
			$rotted &= Chr($pos)
		EndIf
	Next
	Return $rotted
EndFunc   ;==>Rot47
