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
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <GUIEdit.au3>

Main()

Func Main()
    Local $hGUI = GUICreate('RC4 File Crypter 1.0 - ALBANESE Lab ' & Chr(169) & ' 2016', 425, 100)
	GUISetFont(9, 400, 1, "Consolas")
    Local $idSourceInput = GUICtrlCreateInput("", 5, 5, 350, 20)
    Local $idSourceBrowse = GUICtrlCreateButton("...", 360, 5, 35, 20)

    Local $idDestinationInput = GUICtrlCreateInput("", 5, 30, 350, 20)
    Local $idDestinationBrowse = GUICtrlCreateButton("...", 360, 30, 35, 20)

    GUICtrlCreateLabel("Password:", 5, 60, 200, 20)
    Local $idPasswordInput = GUICtrlCreateInput("", 5, 75, 200, 20, $ES_PASSWORD)

    Local $idDecrypt = GUICtrlCreateButton("Decrypt", 355, 70, 65, 25)
    Local $idEncrypt = GUICtrlCreateButton("Encrypt", 285, 70, 65, 25)
    GUISetState(@SW_SHOW, $hGUI)

    Local $sDestinationRead = "", $sFilePath = "", $sPasswordRead = "", $sSourceRead = ""
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop

            Case $idSourceBrowse
                $sFilePath = FileOpenDialog("Select a file to encrypt.", "", "All files (*.*)") ; Select a file to encrypt.
                If @error Then
                    ContinueLoop
                EndIf
                GUICtrlSetData($idSourceInput, $sFilePath) ; Set the inputbox with the filepath.

            Case $idDestinationBrowse
                $sFilePath = FileSaveDialog("Save the file as ...", "", "All files (*.*)") ; Select a file to save the encrypted data to.
                If @error Then
                    ContinueLoop
                EndIf
                GUICtrlSetData($idDestinationInput, $sFilePath) ; Set the inputbox with the filepath.

            Case $idEncrypt
                $sSourceRead = GUICtrlRead($idSourceInput) ; Read the source filepath input.
                $sDestinationRead = GUICtrlRead($idDestinationInput) ; Read the destination filepath input.
                $sPasswordRead = GUICtrlRead($idPasswordInput) ; Read the password input.
                If StringStripWS($sSourceRead, $STR_STRIPALL) <> "" And StringStripWS($sDestinationRead, $STR_STRIPALL) <> "" And StringStripWS($sPasswordRead, $STR_STRIPALL) <> "" And FileExists($sSourceRead) Then ; Check there is a file available to encrypt and a password has been set.
					$full = FileRead($sSourceRead, 300000000)
					FileOpen($sDestinationRead, 2)
					FileWrite($sDestinationRead, _StringEncryptRC4($full, $sPasswordRead))
					FileClose($sDestinationRead)
					MsgBox($MB_SYSTEMMODAL, "Success", "Operation succeeded.")
                Else
                    MsgBox($MB_SYSTEMMODAL, "Error", "Please ensure the relevant information has been entered correctly.")
                EndIf
			Case $idDecrypt
                $sSourceRead = GUICtrlRead($idSourceInput) ; Read the source filepath input.
                $sDestinationRead = GUICtrlRead($idDestinationInput) ; Read the destination filepath input.
                $sPasswordRead = GUICtrlRead($idPasswordInput) ; Read the password input.
                If StringStripWS($sSourceRead, $STR_STRIPALL) <> "" And StringStripWS($sDestinationRead, $STR_STRIPALL) <> "" And StringStripWS($sPasswordRead, $STR_STRIPALL) <> "" And FileExists($sSourceRead) Then ; Check there is a file available to encrypt and a password has been set.
					$full = FileRead($sSourceRead, 300000000)
					FileOpen($sDestinationRead, 2)
					FileWrite($sDestinationRead, _StringDecryptRC4($full, $sPasswordRead))
					FileClose($sDestinationRead)
					MsgBox($MB_SYSTEMMODAL, "Success", "Operation succeeded.")
                Else
                    MsgBox($MB_SYSTEMMODAL, "Error", "Please ensure the relevant information has been entered correctly.")
                EndIf
        EndSwitch
    WEnd

    GUIDelete($hGUI) ; Delete the previous GUI and all controls.
EndFunc   ;==>Main

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
