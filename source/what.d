version (NEVER) :
import appinput : __Event;

alias What = __Event!AppEvent;

struct
AppEvent {
    Type type;

    enum 
    Type : ushort {
        _                   = 0,     
        // APP
        APP                 = 2^^14,  // 16384
        START               = APP + 1,
        // GUI
        GUI                 = 2^^15,  // 32768
        DRAW                = GUI + 2,
    }
}
