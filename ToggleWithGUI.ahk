#Requires AutoHotkey v2.0
#SingleInstance Ignore
;Toggle with gui by u/PixelPerfect41, Enjoy!

;-----------Settings-----------
ALWAYS_ON_TOP := true
RUN_RIGHT_OFF := false
TIMER_DURATION_SECONDS := 1
;------------------------------

;---------Main Program---------
^q::EnableToggle()
^s::DisableToggle()
RUNNING := false
UI := CreateGUI()
UI.Show("w200 h124")
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
    global UI
    RunOnceWhenToggled()
    if(RUN_RIGHT_OFF){
        SetTimer(RunPeriodicallyWhenToggled,-1) ;Run immediately when start is pressed
    }
    SetTimer(RunPeriodicallyWhenToggled,TIMER_DURATION_SECONDS*1000) ;Repeat every 2 minutes
    RUNNING := true
    UI["Ctrl_StartStop"].Text := "STOP"
}

DisableToggle(){
    global RUNNING
    global UI
    SetTimer(RunPeriodicallyWhenToggled,0) ;Disable the timer
    RUNNING := false
    UI["Ctrl_StartStop"].Text := "START"

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