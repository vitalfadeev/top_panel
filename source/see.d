module see;


mixin template 
See (T,What) {
    Brain brain;

    void
    see (What what) {
        import std.stdio : writeln;
        writeln ("E.see ()");
        if (able (what)) 
        if (auto action = (what in brain))
            action ();

        // childs
        foreach (_e; WalkChilds (this))
            _e.see (what);

    }

    struct
    Brain {
        // map

        auto
        opBinaryRight (string op : "in",What) (What b) {
            return &action;
        }

        void 
        action () {
            //
        }
    }
}
