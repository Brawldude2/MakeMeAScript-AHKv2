#Requires AutoHotkey v2.0
#SingleInstance Ignore
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
MButton::HoldToToggle("MButton") ;Example with the middle mouse button
q::HoldToToggle("q") ;Example with the q key
RUNNING := false
if(GUI_Mode){
    UI := CreateGUI()
    UI.Show("w200 h124")
}
;------------------------------

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