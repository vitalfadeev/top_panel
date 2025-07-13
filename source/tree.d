module tree;


mixin template 
Tree (T) {
    T l;
    T r;
    T u;
    T dl;
    T dr;

    void
    add_dr (T b) {
        auto _dr = dr;
        if (_dr is null) {            
            dr = b;    // child
            dl = b;    // child
        }
        else {
            dr = b;     // child
            _dr.r = b;  // link l r
            b.l = _dr;  //
        }
    }

    R
    next (this R) () {
        try_down:
            auto _next = dl;
            
            if (_next !is null)
                return cast (R) _next;

        //
        try_right:
            _next = r;

            if (_next !is null)
                return cast (R) _next;

        //
        try_up_right:
            _next = u;

            if (_next !is null) {
                _next = _next.r;
                if (_next !is null)
                    return cast (R) _next;
                else
                    goto try_up_right;
            }

        //
        return cast (R) null;
    }

    //auto
    //childs () {
    //    return Childs (this);
    //}

    //struct
    //Childs {
    //    T e;

    //    int
    //    opApply (int delegate (T _e) dg) {
    //        for (auto _e = e.dl; _e !is null; _e = _e.r)
    //            if (auto result = dg (_e))
    //                return result;

    //        return 0;    
    //    }    
    //}
}

auto
WalkTree (E) (E e) {
    return _WalkTree!E (e);
}
struct
_WalkTree (E) {
    E e;

    int
    opApply (int delegate (E _e) dg) {
        for (auto _e = this.e; _e !is null; _e = _e.next)
            if (auto result = dg (_e))
                return result;

        return 0;    
    }    
}


auto
WalkChilds (E) (E e) {
    return _WalkChilds!E (e);
}
alias childs = WalkChilds;
struct
_WalkChilds (E) {
    E e;

    int
    opApply (int delegate (E _e) dg) {
        for (auto _e = e.dl; _e !is null; _e = _e.r)
            if (auto result = dg (_e))
                return result;

        return 0;    
    }    
}

