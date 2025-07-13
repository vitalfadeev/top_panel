module can;


mixin template 
Can (T) {
    CanMask canmask;

    auto
    can (What) (What what) {
        return (what.type & canmask);
    }

    bool
    can_focus (What) (What what) {
        return false;
    }

    enum 
    CanMask {
        _     = 0x00,
        key   = 0x01,
        mouse = 0x02,
        draw  = 0x04,
        focus = 0x04,
    }
}
