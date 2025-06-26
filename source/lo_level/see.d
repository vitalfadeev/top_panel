module lo_level.see;

import tree;
import std.stdio : writeln;


auto 
See (E) (E e) {
    return _See!E (e);
}
struct
_See (E) {
    E e;

    this (E e) {
        this.e = e;
    }

    void
    opCall (What) (What what) {
        see (e,what);
    }
}

void
see (E,What) (E e, What what) {
    foreach (_e; WalkTree (e))
        _e.see (what);
}

// akternative
//auto see = 
//    (What what) {
//        foreach (_e; WalkTree (main_e))
//            _e.see (what);
//    };
