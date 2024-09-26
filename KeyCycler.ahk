#Requires AutoHotkey v2.0 

c := Cycler() ;Create a new "Cycler" object
c.Delay := 100 ;Set delay between key presses to 100 ms
c.AddKey("q") ;Add q key to cycle
c.AddKey("w") ;Add w key to cycle
c.AddKey("MButton") ;Add middle mouse button to cycle

;Quick tip always use '$' before hotkeys to prevent infinite triggering from script
$q::c.EnableKey("q") ;Press (Ctrl + q) to add q to cycle
$^q::c.DisableKey("q") ;Press (q) to remove q from the cycle
$^v::c.Start() ;Press (Ctrl + t) to start cycling until stopped
$v::c.Stop() ;Press (t) to stop cycling



;----------Don't touch here----------

class CycleKey{
    __New(key,state:=true){
        this.key := key
        this.state := state
    }
}

class Cycler{
    AddedKeys := Array()
    KeyMap := Map()
    Running := false
    Delay := 100 ;In miliseconds

    AddKey(key,state:=true){
        cKey := CycleKey(key,state)
        this.AddedKeys.Push(cKey)
        this.KeyMap[cKey.key] := this.AddedKeys.Length
    }

    EnableKey(key){
        this.AddedKeys[this.KeyMap[key]].state := true
    }

    DisableKey(key){
        this.AddedKeys[this.KeyMap[key]].state := false
    }

    CycleKeys(){
        for i,cKey in this.AddedKeys{
            if(cKey.state){
                Send("{" cKey.key "}")
                Sleep(this.Delay)
            }
            if(not this.Running){
                break
            }
        }
    }

    Start(){
        this.Running := true
        while(this.Running){
            this.CycleKeys()
        }
    }
    
    Stop(){
        this.Running := false
    }
}