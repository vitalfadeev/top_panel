module able;


mixin template 
Able (T) {
    AbleMask ablemask;

    auto
    able (What) (What what) {
        return (what.type & ablemask);
    }

    enum 
    AbleMask {
        _     = 0x00,
        key   = 0x01,
        mouse = 0x02,
        draw  = 0x04,
    }
}
