; ====================================================
; ============= Hex String Converter GUI =============
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
; #include files for encodeion and GUI constants

; Creates window
GUICreate('HEX Encoder - ALBANESE Research Lab ' & Chr(169) & ' 2016', 590, 400)
GUISetFont(9, 400, 1, "Consolas")

; Creates main edit
Local $idEditText = GUICtrlCreateEdit('', 5, 5, 580, 350, $ES_AUTOVSCROLL + $WS_VSCROLL)

; Encodeion/Decodeion buttons
Local $idEncodeButton = GUICtrlCreateButton('Encode', 410, 360, 85, 35)
Local $idDecodeButton = GUICtrlCreateButton('Deccode', 500, 360, 85, 35)

; Create dummy for accelerator key to activate
$hSelAll = GUICtrlCreateDummy()

; Shows window
GUISetState()

; Set accelerators for Ctrl+a
Dim $AccelKeys[1][2] = [["^a", $hSelAll]]
GUISetAccelerators($AccelKeys)

Local $dEncoded

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop

		Case $hSelAll
			_SelAll()

		Case $idEncodeButton
			; When you press Encode

			; Calls the encodeion. Sets the data of editbox with the encodeed string
			$dEncoded = _StringToHexEx(GUICtrlRead($idEditText))     ; Encode the text with the new codeographic key.
			GUICtrlSetData($idEditText, $dEncoded)

		Case $idDecodeButton
			; When you press Decode

			; Calls the encodeion. Sets the data of editbox with the encodeed string
			$dDecoded = _HexToStringEx(StringReplace(GUICtrlRead($idEditText), @CRLF, ""))     ; Decode the data using the generic password string. The return value is a binary string.
			GUICtrlSetData($idEditText, $dDecoded)

	EndSwitch
WEnd

Func _SelAll()
	$hWnd = _WinAPI_GetFocus()
	$class = _WinAPI_GetClassName($hWnd)
	If $class = 'Edit' Then _GUICtrlEdit_SetSel($hWnd, 0, -1)
EndFunc   ;==>_SelAll

Func _HexToStringEx($strHex)
	Return BinaryToString("0x" & $strHex)
EndFunc   ;==>_HexToStringEx

Func _StringToHexEx($strChar)
	Return Hex(StringToBinary($strChar))
EndFunc   ;==>_StringToHexEx
