

void
go () {
    // world
    // on world grid
    // on grid container
    // in container widget

    // init
    auto world = World (Len (ubyte.max,ubyte.max));  // ubyte.max = 255

    auto c1 = world.container (Container.Way.r, Container.Balance.l, Loc (0,0), Loc (L.max/3,1));
    auto c2 = world.container (Container.Way.r, Container.Balance.c, Loc (L.max/3,0), Loc (L.max/3,1));
    auto c3 = world.container (Container.Way.l, Container.Balance.r, Loc (L.max/3*2,0), Loc (L.max,1));

    auto a  = world.widget (c1, Len (1,1));
    auto b  = world.widget (c1, Len (1,1));
    auto c  = world.widget (c2, Len (1,1));
    auto d  = world.widget (c3, Len (1,1));
    auto e  = world.widget (c3, Len (1,1));

    // loop
    foreach (event; events) {
        auto grid_event_loc = event.loc.to!(Grid.Loc);
        world.see (&event);
    }
}

auto
events () {
    return [GridEvent ()];
}

struct
World {
    // grid
    Len        len;
    // Containers
    Containers containers;
    // Widgets
    Widgets    widgets;
    // Worlds
    World*     next;

    Container*
    container (Container.Way way, Container.Balance balance, Loc min_loc, Loc max_loc) {
        auto container = new Container (way,balance,min_loc,max_loc);
        containers ~= container;
        return container;
    }

    Widget*
    widget (Container* container, Len fix_len) {
        auto widget = new Widget ();
        widget.container = container;
        widget.fix_len   = fix_len;
        widgets ~= widget;
        return widget;
    }

    void
    see (GridEvent* event) {
        // сначала верхнй мир
        // затем нижний мир
        //   для решения "widget поверх мир"
        auto visitor = Visitor (event,&this);

        foreach (widget; widgets)
            widget.see (&visitor);
    }
}

struct
Container {
    // Containers DList
    Container* l;
    Container* r;
    // Able
    bool       able = true;
    // Grid                // Сеточные координаты
    Loc        min_loc;    // начало, включая границу
    Loc        max_loc;    // конец, включая границу
    // Container
    Way        way     = Way.r;
    Balance    balance = Balance.l;


    this (Way way, Balance balance, Loc min_loc, Loc max_loc) {
        this.way     = way;
        this.balance = balance;
        this.min_loc = min_loc;
        this.max_loc = max_loc;
    }

    enum
    Way {
        r,
        l,
    }

    enum
    Balance {
        r,
        c,
        l,
    }
}

struct
Hbox_Container {
    Container _super;
    alias _super this;
}

struct
Containers {  // DList
    Container* l;
    Container* r;

    void
    opOpAssign (string op : "~") (Container* b) {
        if (this.l is null) {
            this.l = b;
            this.r = b;
        }
        else {
            link (this.r, b);
            this.r = b;
        }
    }

    pragma (inline,true)
    void
    link (Container* a, Container* b) {
        b.l = a.r;
        a.r = b;
    }
}

struct
Widget {
    // Widgets DList
    Widget*    l;
    Widget*    r;
    // Able
    bool       able = true;
    // Grid                // Сеточные координаты
    Loc        min_loc;    // начало, включая границу
    Loc        max_loc;    // конец, включая границу
    // Container           // Контейнерные кооринаты
    Container* container;  // id контейнера = указатель
    Len        fix_len;    // fixed len, in gris-coord, 0 = auto

    //
    void
    see (Visitor* visitor) {
        if (visitor.event.type == GridEvent.Type.POINTER) {
            if (Grid.between (visitor.event.loc,  min_loc, max_loc)) {
                // poiner over widget
            }
        }
    }

    void
    rasterize () {
        // min_loc -> window coord
        auto kx = 1366 / L.max;  // 1024  // бижайшее цело степень двойки
        auto ky =  768 / L.max;  //  512  // бижайшее цело степень двойки
                                 //       // хвосты влево и вправо
        auto windowed_x = min_loc.x * kx;
        auto windowed_y = min_loc.y * ky;
    }
}

struct
Widgets {  // DList
    Widget* l;
    Widget* r;

    pragma (inline,true)
    void
    link (Widget* a, Widget* b) {
        b.l = a.r;
        a.r = b;
    }

    void
    opOpAssign (string op : "~") (Widget* b) {
        if (this.l is null) {
            this.l = b;
            this.r = b;
        }
        else {
            link (this.r, b);
            this.r = b;
        }
    }
    int
    opApply (int delegate (Widget*) dg) {
        if (this.l !is null)
        for (auto _widget = this.l; _widget !is null; _widget = _widget.r)
            if (auto result = dg (_widget))
                return result;

        return 0;    
    }
}

struct
Visitor {
    // Event
    GridEvent* event;
    // 
    World*     current_world;
}

struct 
GridEvent {
    Type type;
    Loc  loc;
    union {
        PointerEvent pointer;
    }

    enum
    Type {
        _,
        POINTER,
    }
}
struct 
PointerEvent {
    //
}

struct
Grid {  // SIMD
    alias L   =  ubyte;
    alias Loc = .TLoc!L;
    alias Len = .TLen!L;

    static
    auto
    between (Loc loc, Loc min_loc, Loc max_loc) {
        return false;
    }
}

auto
to (T,A) (A a) {
    static if (is (T == Grid.Loc)) {
        return _loc_to_grid_loc (a);
    }
    else {
        import std.conv : std_conv_to = to;
        return a.std_conv_to!T;
    }
}

Grid.Loc
_loc_to_grid_loc (Loc) (Loc loc) {
    return Grid.Loc ();
}


struct
TLen (L) {  // SIMD
    L[2] xy;

    this (int x, int y) {
        xy[0] = x.to!L;
        xy[1] = y.to!L;
    }
}

struct
TLoc (L) {  // SIMD
    L[2] xy;

    auto x () { return xy[0]; }
    auto y () { return xy[1]; }

    this (int x, int y) {
        xy[0] = x.to!L;
        xy[1] = y.to!L;
    }
}

alias L   = Grid.L;
alias Loc = Grid.Loc;
alias Len = Grid.Len;



// world 
// 256x256
// ------------------------
//  1 ab  | 2  c   | 3  de
// ------------------------
// 3 containers
//   1
//   2
//   3
// widgets
//   a
//   b
//   c
//   d
//   e
//
// Widget a
//   l         = null
//   r         = &b
//   min_loc   = calculated_by_container
//   maz_loc   = calculated_by_container
//   able      = true
//   container = &container_1
//   fix_len   = Len (0,0)
//
// Container 1
//   l = null
//   r = &container_2
