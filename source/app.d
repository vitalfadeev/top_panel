import std.stdio;
import std.conv;
//import e     : E,CanClick;
//import whats : Whats;
//import what  : What,AppEvent;
import loop  : loop;
import tree  : WalkTree,WalkChilds,childs;
import world;
import loc;
import wayland_struct;
import impl;
import backend;
import types;
import std.traits : ReturnType;


enum GRID_LEN_X   = 128;
enum GRID_LEN_Y   = 128;
enum WINDOW_LEN_X = 640;
enum WINDOW_LEN_Y = 480;

void 
main () {
	// e top_panel
	//  e left
	//   e icon1
	//  e center
	//   e icon2
	//  e right
	//   e icon3

	// tree
	// tree in ray
	// e top_panel, e left, e icon 1, e center, e icon2, e right, e icon 3
	// <- | ->
    Main().go();
}


struct
Main {
    ReturnType!Backend backend;
    Custom_World       world;

    void
    _init () {
        auto backend = Backend (Len (WINDOW_LEN_X,WINDOW_LEN_Y), &world.draw);
        auto _video  = backend.video;
        auto _input  = backend.input;
        auto _draw   = backend.draw;
        auto world   = Custom_World (Grid.Len (GRID_LEN_X,GRID_LEN_Y));  // ubyte.max = 255
    }

    void
    go () {
        _init ();
        loop ();
    }

    void
    loop () {
        foreach (ref event; backend.input) {
            writeln ();
            writeln (event);
            world.main (&world,&event);
        }
    }
}

// Vid
//   Vid
//     Vid
// e
//   e
//     e klass_1 klass_2
struct
Vid {
    // enable     - Walk able
    bool   able;
    // left right - DList
    Vid*   l;
    Vid*   r;
    // in         - DList container
    Vid*   in_l;
    Vid*   in_r;
    // out
    Vid*   outer;

    // grid
    Len    grid_len;
    // loc len
    Loc    loc;
    Len    len;

    // klasses     - DList
    Klass* klass_l;
    Klass* klass_r;

    // inp
    INP_FN
    inp = 
        (_this,ctx) {
            // klass_1.inp ()
            // klass_2.inp ()
        };

    // vid
    VID_FN
    vid = 
        (_this,ctx,pixels) {
            // klass_1.vid ()
            // klass_2.vid ()
        };

    alias INP_FN = void function (typeof(this)* _this, Context* ctx);
    alias VID_FN = void function (typeof(this)* _this, Context* ctx, Pixels* pixels);
}

struct
Klass {
    // DList
    Klass* l;
    Klass* r;

    // inp
    INP_FN
    inp = 
        (_this,ctx) {
            // ctx.inp
        };

    // vid
    VID_FN
    vid = 
        (_this,ctx,pixels) {
            //
        };

    alias INP_FN = void function (typeof(this)* _this, Context* ctx);
    alias VID_FN = void function (typeof(this)* _this, Context* ctx, Pixels* pixels);
}

struct
Context {
    Input  input;
    Vid*   vid;

    this (ARGS...) (ARGS args) {
        _init ();
        _loop ();
    }

    void
    _init () {
        vid = new Vid ();
    }

    void
    _loop () {
        while (input) {
            writeln ();
            writeln (input.event);
            vid.inp (vid,&this);
        }
    }
}

struct
Input {
    Event event;

    bool
    opCall () {
        // poll  event
        // read  event
        // check for quit
        return true;
    }

    struct
    Event {
        //
    }
}

struct
Custom_World {
    World _super;
    alias _super this;

    this (Grid.Len len) {
        _super = World (len);

        // world
        auto c1 = this ~= new Custom_Container (Container (Container.Way.r, Container.Balance.l, Grid.Loc (0,0),              Grid.Loc (Grid.L.max/3,1)));
        auto c2 = this ~= new Custom_Container (Container (Container.Way.r, Container.Balance.c, Grid.Loc (Grid.L.max/3,0),   Grid.Loc (Grid.L.max/3,1)));
        auto c3 = this ~= new Custom_Container (Container (Container.Way.l, Container.Balance.r, Grid.Loc (Grid.L.max/3*2,0), Grid.Loc (Grid.L.max,1)));

        auto a  = *c1 ~= new Custom_Widget (Widget (Grid.Len (100,100)));
        auto b  = *c1 ~= new Custom_Widget (Widget (Grid.Len (1,1)));
        auto c  = *c2 ~= new Custom_Widget (Widget (Grid.Len (1,1)));
        auto d  = *c3 ~= new Custom_Widget (Widget (Grid.Len (1,1)));
        auto e  = *c3 ~= new Custom_Widget (Widget (Grid.Len (1,1)));

        foreach (_widget; [a]) {
            _widget.grid.min_loc = Grid.Loc (0,0);
            _widget.grid.max_loc = Grid.Loc (100,100);
        }
        foreach (_widget; [b,c,d,e]) {
            _widget.grid.min_loc = Grid.Loc (100,100);
            _widget.grid.max_loc = Grid.Loc (101,101);
        }
        
        a.main =
            (_this,event) {
                if (event.input_event.type == 1)
                if (event.input_event.sources.inp.front.type == event.input_event.sources.inp.front.Type.POINTER_MOTION) {
                    writeln ("  poiner over widget: ", _this);
                }
            };        
    }

    MAIN_FN 
    main = 
        (_this, event) {
            event.world  = _this;
            event.widget =  null;
            event.loc    =  Loc ();

            final
            switch (event.input_event.type) {
                case 0 : break;
                case 1 : _this._input_event (event); break;
            }
        };

    alias MAIN_FN = void function (typeof(this)* _this, Event* event);

    T*
    opOpAssign (string op : "~",T) (T* b) {
        return _super.opOpAssign!"~" (b);
    }

    void
    _input_event (Event* event) {
        switch (event.input_event.sources.inp.front.type) {
            case event.input_event.sources.inp.front.Type.NONE           : break;
            case event.input_event.sources.inp.front.Type.POINTER_BUTTON : break;
            case event.input_event.sources.inp.front.Type.POINTER_MOTION : _pointer_motion_event (event); break;
            default:
        }
    }

    void 
    _pointer_motion_event (Event* event) {
        // find widget
        event.loc     = Loc (
            event.input_event.sources.inp.front.pointer.x, 
            event.input_event.sources.inp.front.pointer.y);
        auto grid_loc = _loc_to_grid_loc (event.loc);  // from event

        foreach (_widget; this.get_widgets (grid_loc)) {
            event.widget = _widget;

            // callback
            if (auto _widget_main = (cast (Custom_Widget*) _widget).main) {
                _widget_main (cast (Custom_Widget*) _widget,event);
            }
        }    
    }

    static
    void
    draw (wayland_ctx* ctx, uint* pixels /* xrgb8888 */) {
        // go to World elements
        // .each
        //   .draw (pixels)

        // Draw checkerboxed background
        with (ctx) {
            for (int y = 0; y < height; ++y) {
                for (int x = 0; x < width; ++x) {
                    if ((x + y / 32 * 32) % 64 < 32)
                        pixels[y * width + x] = 0xFF666666;
                    else
                        pixels[y * width + x] = 0xFFEEEEEE;
                }
            }
        }
    }
}

struct
Custom_Container {
    world.Container container;
    alias container this;
    
    MAIN_FN 
    main = 
        (_this, event) {
            //
        };

    alias MAIN_FN = void function (typeof(this)* _this, Event* event);  // struct {void* _this; void* _cb;}
}

struct
Custom_Widget {
    world.Widget widget;
    alias widget this;
    
    MAIN_FN 
    main = 
        (_this, event) {
            //
        };

    alias MAIN_FN = void function (typeof(this)* _this, Event* event);  // struct {void* _this; void* _cb;}
}



struct
Event {
    // input
    TEvents.Event* input_event;
    void*          _device;
    Loc            _loc;
    // video
    Window*        window;
    // world
    Custom_World*  world;
    Container*     container;
    Widget*        widget;

    // if (event) ...
    bool opCast (T) () if (is (T == bool)) { return (type != Type._); }
}

struct
Window {
    //
}

// events
//   sources
//   dispatch
//     by_time
//   front
// events sources
//   app
//   input
//   world
// event
//   source
//   union
//     app
//     input
//     world
// source
//   event[]

struct
AppEvent {
    Type type;

    enum 
    Type {
        _,
        START,
    }

    // if (AppEvent) ...
    bool opCast (T) () if (is (T == bool)) { return (type != 0); }
}

alias InputEvent = impl.Event;


// loop
//                     === app ====
//   === appinput ====                =========== world ===========
//            dispatch
//   Inp - Inp_Event - to_Wrd_Event - Wrd_Event - World - Wrd_Event -
//   App - App_Event - to_Wrd_Event                                  |
//       - Grd_Event - to_Wrd_Event                                  |
//       - GUI_Event - to_Wrd_Event                                  |
//       - Wrd_Event                                                 |
//    ^                                                              |
//    |                                                              |
//     ------------------------------------------------------------- 

// Inp_Event - Grd_Event - World - find_Widget_is_pointer_over - callback (event)
//                                                               event_cb (event)
// callback = void* function (Event)
// event_cb = void* function (Event, widget)

// Inp_Event - Event - World
//                     - find_widget_at_loc - widget - Event.widget
// event loop
//   event
//   event.loc.to_grid -> grid_loc
//   world.find_widget_at_loc (grid_loc) -> widget
//   event.widget = widget
//   callbacks...
//     event
//       MOTION : callback (event /* .widget */)
//       BTN    : callback (event /* .widget */)



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
    return Grid.Loc (
        loc.x * GRID_LEN_X / WINDOW_LEN_X, 
        loc.y * GRID_LEN_Y / WINDOW_LEN_Y
    );
}



version (NEVER) {
    /*
    auto
    see (World.Event* event) {
        // Grid able
        //   сетка матчит по сеточным координатам
        //     сеточные координаты лежат в event, туда попадают из конвертора
        //   pointer events
        //     motion
        //     button
        // Hot key
        //   key events
        // World events

        // key
        //   -> focused
        // pointer
        //   -> widgets


        // Grid able
        //   сначала верхнй мир
        //   затем нижний мир
        //     для решения "widget поверх мир"

        if (event.is_widgetable)
        if (event.is_gridable)
        foreach (widget; widgets.walk) {
            if (widget.grid.match (event.grid.loc)) {
                event.widget.widget = widget;
            }
        }

        return World.Event ();
    }
    */

    void
    rasterize (Len,FILL_FN) (Len window_len, FILL_FN fill) {
        // min_loc -> window coord
        version (NEVER) {
            auto kx = 1366 / L.max;  // 1024  // бижайшее цело степень двойки
            auto ky =  768 / L.max;  //  512  // бижайшее цело степень двойки
                                     //       // хвосты влево и вправо

             auto wind_x = near_2_int (window_len.x);
             auto grid_x = near_2_int (L.max);
             auto rest_x = wind_x - grid_x;  //хвосты влево и вправо
             auto padl_x = rest_x / 2; 

             // на сколько сдвигать биты ?
             auto wind_x_msb = msb (window_len.x);
             auto grid_x_msb = msb (L.max);

             int shift;
             int shift_left;
             if (wind_x_msb > grid_x_msb) {
                shift      = (wind_x_msb - grid_x_msb);
                shift_left = true;
            }
            else {
                shift      = (grid_x_msb - wind_x_msb);
                shift_left = false;
            }
        }

        foreach (_widget; widgets) {  // SIMD
            // fast vetsion
            auto min_loc = _widget.min_loc;
            auto max_loc = _widget.max_loc;
            if (shift_left) {
                auto windowed_min_x = min_loc.x << shift;
                auto windowed_min_y = min_loc.y << shift;
                auto windowed_max_x = max_loc.x << shift;
                auto windowed_max_y = max_loc.y << shift;

                fill (
                    padl_x + windowed_min_x, windowed_min_y,
                    padl_x + windowed_max_x, windowed_max_y);
            }
            else {
                auto windowed_min_x = min_loc.x >> shift;
                auto windowed_min_y = min_loc.y >> shift;
                auto windowed_max_x = max_loc.x >> shift;
                auto windowed_max_y = max_loc.y >> shift;

                fill (
                    padl_x + windowed_min_x, windowed_min_y,
                    padl_x + windowed_max_x, windowed_max_y);
            }
            // slow version
            version (NEVER) {
            auto min_loc = _widget.min_loc;
            auto max_loc = _widget.max_loc;
            auto windowed_min_x = min_loc.x * window_len.x / L.max;
            auto windowed_min_y = min_loc.y * window_len.y / L.max;
            auto windowed_max_x = max_loc.x * window_len.x / L.max;
            auto windowed_max_y = max_loc.y * window_len.y / L.max;
            }
        }
    }
	
}

// top panel
//  left  center  right
//   icon  icon    icon

// e
//  see
//   in brain
//    actions
//
// e[]

// see (what)
//  what in brain
//    actions

// what
//  fields
//    field1 field2 field3

// brain
//  field1 = value
//  field2 & mask
//  field3 regex (pattern)
//
//  actions


//"versions"     : ["SDL", "SDL_2_26", "SDL_Image_2_6", "SDL_TTF_2_20"],
//"dependencies" : {
//	"bindbc-sdl"    : {"path": "./deps/bindbc-sdl"},
//	"bindbc-common" : {"path": "./deps/bindbc-common"},
//	"bindbc-loader" : {"path": "./deps/bindbc-loader"},
//	"bindbc-sdlgfx" : {"path": "./deps/bindbc-sdlgfx"},
//},


// VF
// DTK
// DGUI
// Tiny Core Linux

// font
//        3
//     2        
//           C  
//     1  
//
//            ^
//      3   --o--
//            v
//     2      |
//          < o >
//     1      |
//            ^
//          --o--
//            v

// TOP_PANEL
// e root window
//   e container left
//     e button start
//   e container center
//     e button clock
//   e container right
//     e tray
//     e button volume
