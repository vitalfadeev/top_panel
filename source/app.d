import std.stdio;
import std.conv;
import e     : E,CanClick;
import whats : Whats;
import what  : What,AppEvent;
import loop  : loop;
import tree  : WalkTree,WalkChilds,childs;
import world;
import loc;
import wayland_struct;
import impl;


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
	version (NEVER)
	{
		// tree
		auto main_e = new Main ();

		// main loop
		auto whats = Whats ();
		loop (whats,&main_e.see);
	}

	{
	    // init
        auto wayland = Wayland (640,480,&draw);        
	    auto world = new Custom_World (
            World (null,null,true, List!Container(null,null), List!Widget(null,null), Grid.Len (ubyte.max,ubyte.max)));  // ubyte.max = 255

	    auto c1 = world.containers ~= new Container (Container.Way.r, Container.Balance.l, Grid.Loc (0,0), Grid.Loc (Grid.L.max/3,1));
	    auto c2 = world.containers ~= new Container (Container.Way.r, Container.Balance.c, Grid.Loc (Grid.L.max/3,0), Grid.Loc (Grid.L.max/3,1));
	    auto c3 = world.containers ~= new Container (Container.Way.l, Container.Balance.r, Grid.Loc (Grid.L.max/3*2,0), Grid.Loc (Grid.L.max,1));

	    auto a  = world.widgets ~= &(new Custom_Widget (Widget (c1, Grid.Len (1,1)))).widget;
	    auto b  = world.widgets ~= &(new Custom_Widget (Widget (c1, Grid.Len (1,1)))).widget;
	    auto c  = world.widgets ~= &(new Custom_Widget (Widget (c2, Grid.Len (1,1)))).widget;
	    auto d  = world.widgets ~= &(new Custom_Widget (Widget (c3, Grid.Len (1,1)))).widget;
	    auto e  = world.widgets ~= &(new Custom_Widget (Widget (c3, Grid.Len (1,1)))).widget;

	    foreach (_widget; [b,c,d,e]) {
	    	_widget.grid.min_loc = Grid.Loc (1,1);
	    	_widget.grid.max_loc = Grid.Loc (2,1);
	    }
	    
	    (cast (Custom_Widget*) a).main =
            (_this,event) {
                if (event.input.type == event.input.Type.POINTER_BUTTON) {
                    writeln ("  poiner over widget: ", event.widget);
                }
            };

        Event base_event;

        // event loop
        foreach (event; wayland.events) {
            writeln (*event);
            switch (event.type) {
                case event.Type.POINTER_BUTTON: 
                    if (event.pointer.button == BTN_LEFT)
                        wayland.ctx.done = true;
                    break;
                case event.Type.KEYBOARD_KEY: 
                    if (event.keyboard.key == KEY_ESC)
                        wayland.ctx.done = true;
                    break;
                default:
            }

            base_event.type   = base_event.Type.INPUT;
            base_event.input  = event;
            base_event.world  = world;
            base_event.widget = null;
            world.main (world,&base_event);
        }

		//auto
		//events () {
		//    return [
		//    	Event (
		//    		Event.Type.INPUT, 
		//    		InputEvent (InputEvent.Type.POINTER), 
		//    		AppEvent (),
		//		),
		//	];
		//}
	}
}

struct
Custom_World {
    World _super;
    alias _super this;

    MAIN_FN main = 
        (Custom_World* _this, Event* event) {
            event.world = _this;

            final
            switch (event.type) {
                case Event.Type._     : break;
                case Event.Type.INPUT : _input_event (_this,event); break;
                case Event.Type.APP   : break;
                case Event.Type.WORLD : break;
            }
        };

    alias MAIN_FN = void function (Custom_World* _this, Event* event);
}


void
_input_event (Custom_World* world, Event* event) {
	switch (event.input.type) {
		case InputEvent.Type.NONE           : break;
		case InputEvent.Type.POINTER_BUTTON : _pointer_button_event (world,event); break;
        default:
	}
}

void 
_pointer_button_event (Custom_World* world, Event* event) {
	// find widget
	auto grid_loc = _loc_to_grid_loc (event.loc);  // from event

	foreach (_widget; world.get_widgets (grid_loc)) {
		event.widget = cast (Widget*) _widget;

		// callback
		if (auto _widget_main = (cast (Custom_Widget*) _widget).main) {
			_widget_main (cast (Custom_Widget*) _widget,event);
		}
	}    
}

void
draw (wayland_ctx* ctx, uint* pixels /* xrgb8888 */) {
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

struct
Custom_Widget {
    world.Widget widget;
    MAIN_FN      main = 
        (_this, event) {
            //
        };

    alias MAIN_FN = void function (Custom_Widget* _this, Event* event);  // struct {void* _this; void* _cb;}
}

struct
Event {
	Type 		  type;
    InputEvent    input;
    AppEvent      app;
    Custom_World* world;
    Widget*       widget;
    Loc           loc;

    // if (event) ...
    bool opCast (T) () if (is (T == bool)) { return (type != Type._); }

	enum 
	Type {
	    _,
	    INPUT,
	    APP,
	    WORLD,
	}
}

struct
InputEvent {
    impl.Event *_super;
    alias _super this;

    // if (InputEvent) ...
    bool opCast (T) () if (is (T == bool)) { return (type != 0); }
    void opAssign (impl.Event* b) { _super = b; }
}

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

alias Len = TLen!L;
alias Loc = TLoc!L;
alias L   = int;


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

