import std.conv : to;


void
go () {
    auto world       = World (Len (256,256));
    auto container_1 = world.containers.container (Container.Way.r, Container.Balance.l);
    auto container_2 = world.containers.container (Container.Way.r, Container.Balance.c);
    auto container_3 = world.containers.container (Container.Way.l, Container.Balance.r);

    auto widget_a = world.widgets.widget (container_1, Len (1,1));
    auto widget_b = world.widgets.widget (container_1, Len (1,1));
    auto widget_c = world.widgets.widget (container_2, Len (1,1));
    auto widget_d = world.widgets.widget (container_3, Len (1,1));
    auto widget_e = world.widgets.widget (container_3, Len (1,1));

    foreach (Event event; events) {
        auto visitor = Visitor (event);
        world.see (visitor);
    }
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
    // Words
    World*     next;

    void
    see (Visitor visitor) {
        foreach (widget; widgets)
            widget.see (visitor);
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
    see (Visitor visitor) {
        //
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

    this (int x, int y) {
        xy[0] = x.to!L;
        xy[1] = y.to!L;
    }
}

alias L = ubyte;



// world 
// 256x256
// -----------------------
//  1 ab  | 2  c   | 3  de
// -----------------------
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
