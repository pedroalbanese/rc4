; ====================================================
; ============= Encryption Tool With GUI =============
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
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <WindowsConstants.au3>
#include <GUIEdit.au3>
#include <WinAPI.au3>

#include <StaticConstants.au3>
#include <B64UFD.au3>

; #include files for encryption and GUI constants

; Creates window
GUICreate('RC4 Encrypt 1.0 - ALBANESE Research Lab ' & Chr(169) & ' 2017-2019', 590, 400, -1, -1, -1, $WS_EX_ACCEPTFILES)
GUISetFont(9, 400, 1, "Consolas")


; Creates main edit
Local $idEditText = GUICtrlCreateEdit('', 5, 5, 580, 350, $ES_AUTOVSCROLL + $WS_VSCROLL)
GUICtrlSetState($idEditText, $GUI_DROPACCEPTED)

Local $idInputPass = GUICtrlCreateInput('', 5, 360, 200, 20, $ES_PASSWORD)
GUICtrlSetState($idInputPass, $GUI_DROPACCEPTED)

; Encryption/Decryption buttons
Local $idEncryptButton = GUICtrlCreateButton('Encrypt', 410, 360, 85, 35)
Local $idDecryptButton = GUICtrlCreateButton('Decrypt', 500, 360, 85, 35)

GUICtrlCreateLabel('Password', 5, 385)


; Create dummy for accelerator key to activate
$hSelAll = GUICtrlCreateDummy()

; Shows window
GUISetState()

	; Set accelerators for Ctrl+a
Dim $AccelKeys[1][2]=[["^a", $hSelAll]]
GUISetAccelerators($AccelKeys)

Local $dEncrypted

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop

		Case $idEncryptButton
			; When you press Encrypt

			; Calls the encryption. Sets the data of editbox with the encrypted string
			$dEncrypted = base64(_StringEncryptRC4(GUICtrlRead($idEditText), GUICtrlRead($idInputPass)), true)     ; Encrypt the text with the new cryptographic key.
			GUICtrlSetData($idEditText, StringReplace($dEncrypted, @LF, @CRLF))

		Case $idDecryptButton
			; When you press Decrypt

			; Calls the encryption. Sets the data of editbox with the encrypted string
			$dEncrypted = _StringDecryptRC4(base64(StringReplace(GUICtrlRead($idEditText), @CRLF, @LF), False), GUICtrlRead($idInputPass))     ; Decrypt the data using the generic password string. The return value is a binary string.
			GUICtrlSetData($idEditText, $dEncrypted)
       Case $hSelAll
            _SelAll()
	EndSwitch
WEnd

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
;	$text = BinaryToString('0x' & $text)
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

Func _SelAll()
    $hWnd = _WinAPI_GetFocus()
    $class = _WinAPI_GetClassName($hWnd)
    If $class = 'Edit' Then _GUICtrlEdit_SetSel($hWnd, 0, -1)
EndFunc   ;==>_SelAll