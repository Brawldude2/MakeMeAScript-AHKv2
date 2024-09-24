#Requires AutoHotkey v2.0
#SingleInstance Ignore
;Toggle with gui by u/PixelPerfect41, Enjoy!

RUNNING := false
RUN_RIGHT_OFF := false
TIMER_DURATION_SECONDS := 1

UI := CreateGUI()
UI.Show("w200 h124")

RunOnceWhenToggled(){
    Run("notepad",,,&oPID)
    WinWait("ahk_pid " oPID)
    WinActivate("ahk_pid " oPID)
}

RunPeriodicallyWhenToggled(){
    Send("e")
}

onClick(Button,*){ ;When the button is clicked
    global RUNNING
    if(RUNNING){
        SetTimer(RunPeriodicallyWhenToggled,0) ;Disable the timer
        RUNNING := false
        Button.Text := "START"
    }else{
        RunOnceWhenToggled()
        if(RUN_RIGHT_OFF){
            SetTimer(RunPeriodicallyWhenToggled,-1) ;Run immediately when start is pressed
        }
        SetTimer(RunPeriodicallyWhenToggled,TIMER_DURATION_SECONDS*1000) ;Repeat every 2 minutes
        RUNNING := true
        Button.Text := "STOP"
    }
}

CreateGUI(){
    UI := Gui()
    UI.Title := "YOUR TITLE"
    UI.OnEvent('Close', (*) => ExitApp())
    UI.SetFont("s18")

    StartStop := UI.Add("Button","w200 h124 x0 y0 vCtrl_StartStop","START")
    StartStop.OnEvent("Click",onClick) ;Bind the click event to button

    return UI
}