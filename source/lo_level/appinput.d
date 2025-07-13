module lo_level.appinput;

import std.container : DList;
import lo_level.what : What;

//struct
//AppInput {
//    // empty
//    // popFront
//    // front
//    // opOpAssign (string op : "~") (What b)
//}
struct
AppInput {
    DList!Event _super;
    alias _super this;

    void
    popFront () {
        _super.removeFront ();
    }
}


struct
Event {
    Type type;

    enum 
    Type : ushort {
        _                   = 0,     
        APP                 = 2^^14,  // 16384
        START               = APP + 1,
        DRAW                = APP + 2,
    }
}

