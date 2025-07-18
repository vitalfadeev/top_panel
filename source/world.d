import std.conv : to;


void
go () {
    // init
    auto world       = World (Len (ubyte.max,ubyte.max));  // ubyte.max = 255

    auto c1 = world.containers.container (Container.Way.r, Container.Balance.l);
    auto c2 = world.containers.container (Container.Way.r, Container.Balance.c);
    auto c3 = world.containers.container (Container.Way.l, Container.Balance.r);

    auto a  = world.widgets.widget (c1, Len (1,1));
    auto b  = world.widgets.widget (c1, Len (1,1));
    auto c  = world.widgets.widget (c2, Len (1,1));
    auto d  = world.widgets.widget (c3, Len (1,1));
    auto e  = world.widgets.widget (c3, Len (1,1));

    // loop
    foreach (event; events)
        world.see (event);
}

auto
events () {
    return [Event ()];
}

struct
World {
    // grid
    Len        grid_len;
    // Containers
    Containers containers;
    // Widgets
    Widgets    widgets;
    // Worlds
    World*     next;

    void
    see (Event event) {
        auto visitor = Visitor (event,this);

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


    this (Way way, Balance balance) {
        this.way     = way;
        this.balance = balance;
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

    Container*
    container (Container.Way way, Container.Balance balance) {
        auto container = new Container (way,balance);
        if (this.l is null) {
            this.l = container;
            this.r = container;
        }
        else {
            link (this.r, container);
            this.r = container;
        }

        return container;
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
        //
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

    Widget*
    widget (Container* container, Len fix_len) {
        auto widget = new Widget ();
        widget.container = container;
        widget.fix_len   = fix_len;

        if (this.l is null) {
            this.l = widget;
            this.r = widget;
        }
        else {
            link (this.r, widget);
            this.r = widget;
        }

        return widget;
    }

    pragma (inline,true)
    void
    link (Widget* a, Widget* b) {
        b.l = a.r;
        a.r = b;
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
    Event event;
    // 
    World current_world;
}

struct 
Event {
    Type type;

    enum
    Type {
        _,
    }
}


struct
Len {
    L[2] xy;

    this (int x, int y) {
        xy[0] = x.to!L;
        xy[1] = y.to!L;
    }
}

struct
Loc {
    L[2] xy;

    auto x () { return xy[0]; }
    auto y () { return xy[1]; }

    this (int x, int y) {
        xy[0] = x.to!L;
        xy[1] = y.to!L;
    }
}

alias L = ubyte;



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
