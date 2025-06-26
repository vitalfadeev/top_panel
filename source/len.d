module len;

import l;


mixin template 
Len (T) {
    From from;
    To   to;

    struct
    From {
        LC lc;
    }

    struct
    To {
        import l : L;
        L[2] s;
    }
}


struct
LC {
    L length;
    L capacity;
}
