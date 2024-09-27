#Requires AutoHotkey v2.0
#SingleInstance Force
;Toggle helper by u/PixelPerfect41, Enjoy!

;-------Program Settings-------
GUI_Mode := true
RUN_RIGHT_OFF := false
TIMER_DURATION_SECONDS := 0.1
;------------------------------

;---------GUI Settings---------
ALWAYS_ON_TOP := true
;------------------------------

;---------Main Program---------
/*
    Some examples:
    MButton::HoldToToggle("MButton") ;Hold middle mouse button to enable and release to disable toggle
    q::HoldToToggle("q") ;Hold "q" to enable and release to disable toggle
    w::EnableToggle() ;Enable toggle with w key
    ^w::DisableToggle() ;Disable toggle with ctrl+w key
    b::SwitchToggle() ;If toggle is on turns it off, If toggle is off turns it on
*/
q::HoldToToggle("q") ;Hold "q" to enable and release to disable toggle
RUNNING := false
if(GUI_Mode){
    UI := CreateGUI()
    UI.Show("w200 h124")
}
;------------------------------

;----------------------------------Customisable functions------------------------------------
RunOnceWhenToggled(){
    ;Inside of this function will run once when toggled
    Run("notepad",,,&oPID)
    WinWait("ahk_pid " oPID)
    WinActivate("ahk_pid " oPID)
}

RunPeriodicallyWhenToggled(){
    ;Inside of this function will run continuosly with set amount of delay when toggle in on
    Send("e")
}

RunWhenToggleIsDisabled(){
    ;Inside of this function will run once the toggle is turned off
    if(WinExist("ahk_exe notepad.exe")){
        WinKill("ahk_exe notepad.exe")
    }
}
;--------------------------------------------------------------------------------------------

EnableToggle(){
    global RUNNING
    RunOnceWhenToggled()
    if(RUN_RIGHT_OFF){
        SetTimer(RunPeriodicallyWhenToggled,-1) ;Run immediately when start is pressed
    }
    SetTimer(RunPeriodicallyWhenToggled,TIMER_DURATION_SECONDS*1000) ;Repeat every 2 minutes
    RUNNING := true
    if(GUI_Mode){
        global UI
        UI["Ctrl_StartStop"].Text := "STOP"
    }
}

DisableToggle(){
    global RUNNING
    SetTimer(RunPeriodicallyWhenToggled,0) ;Disable the timer
    RunWhenToggleIsDisabled()
    RUNNING := false
    if(GUI_Mode){
        global UI
        UI["Ctrl_StartStop"].Text := "START"
    }

}

HoldToToggle(key){
    EnableToggle()
    KeyWait(key)
    DisableToggle()
}

SwitchToggle(){
    if(RUNNING){
        DisableToggle()
    }else{
        EnableToggle()
    }
}

onClick(Button,*){ ;When the button is clicked
    if(RUNNING){
        DisableToggle()
    }else{
        EnableToggle()
    }
}

GetGUIOptions(){
	opt := ""
	if(ALWAYS_ON_TOP){
		opt := opt "+AlwaysOnTop"
	}
	return opt
}

CreateGUI(){
    UI := Gui(GetGUIOptions())
    UI.Title := "YOUR TITLE"
    UI.OnEvent('Close', (*) => ExitApp())
    UI.SetFont("s18")

    StartStop := UI.Add("Button","w200 h124 x0 y0 vCtrl_StartStop","START")
    StartStop.OnEvent("Click",onClick) ;Bind the click event to button

    return UI
}