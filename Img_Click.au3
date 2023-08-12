#AutoIt3Wrapper_Change2CUI=Y
#pragma compile(Console, True) 

;Global Enum  $EXITCODE_OK

#include "Constants.au3"
#include "GUIConstantsEx.au3"
#include "ImageSearch2015.au3"

Func findImage($imageFile)
    ;search entire screen area for image, return img coords if found, false if not
    Local $searchAreaX1 = 0
    Local $searchAreaY1 = 0
    Local $searchAreaX2 = @DesktopWidth
    Local $searchAreaY2 = @DesktopHeight
    Local $transparentColor = 0xEA00F6 ;bright magenta color    
    Local $imgX = 0
    Local $imgY = 0
         
    Local $result = _ImageSearchArea($imageFile, 1, $searchAreaX1, $searchAreaY1, $searchAreaX2, $searchAreaY2, $imgX, $imgY, 0, $transparentColor) 
     
    If $result = 1 Then
        Local $imgCoords[2] = [$imgX, $imgY]
        Return $imgCoords
    Else
        Return false    
    EndIf                   
EndFunc 
 
Func waitForImage($imageFile, $waitSecs = 0)        
    Local $timeout = $waitSecs * 1000
    Local $startTime = TimerInit()
 
    ;loop until image is found, or until wait time is exceeded
    While true 
 
        If findImage($imageFile) <> false Then
            Return true
        EndIf
         
        If $timeout > 0 And TimerDiff($startTime) >= $timeout Then
            ExitLoop
        EndIf
        sleep(50)   
    WEnd
     
    Return False
EndFunc
 
Func ClickonImage($imgfile, $click_action)
	waitForImage($imgfile) ;wait until image is found
    Local $result = findImage($imgfile)  
    If $result == false Then
        ;MsgBox(0, 'Error', "Image was not found on screen.")
		ConsoleWrite"Image was not found on screen.")
		Exit
    Else
		If $click_action=="" then
			MouseMove($result[0], $result[1], 10)
		Else
			MouseClick($click_action,$result[0], $result[1])
		EndIf
		ConsoleWrite("position = " & $result[0] & "," & $result[1] )
    EndIf
EndFunc

If ( $cmdLine[0]>0 ) Then
	Local $imgfile =$cmdLine[1] ,$click_action
	If ( $cmdLine[0]>1 ) Then
		$click_action=$cmdLine[2];
	Else
		$click_action=""
	EndIf
	ClickonImage($imgfile,$click_action)
	If ( $cmdLine[0]>2 ) Then
		Send( $cmdLine[3] )
	EndIf
Else
	Local $msg
	$msg = "1 arguments (mouse move) : png_filename" & @CRLF
	$msg = $msg  & "2 arguments (mouse click ) : png_filename left_or_right" & @CRLF
	$msg = $msg  & "3 arguments (click + keys ) : png_filename left_or_right keystrokes" & @CRLF
	ConsoleWrite( $msg )
	;MsgBox(0, 'Error', $msg)
EndIf 
;Global Enum  $EXITCODE_OK
Exit
