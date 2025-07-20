import std.stdio;
import std.conv;
import e     : E,CanClick;
import whats : Whats;
import what  : What,AppEvent;
import loop  : loop;
import tree  : WalkTree,WalkChilds,childs;
import world;
import loc;


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
	    auto world = new World (Grid.Len (ubyte.max,ubyte.max));  // ubyte.max = 255

	    auto c1 = world.container (Container.Way.r, Container.Balance.l, Grid.Loc (0,0), Grid.Loc (Grid.L.max/3,1));
	    auto c2 = world.container (Container.Way.r, Container.Balance.c, Grid.Loc (Grid.L.max/3,0), Grid.Loc (Grid.L.max/3,1));
	    auto c3 = world.container (Container.Way.l, Container.Balance.r, Grid.Loc (Grid.L.max/3*2,0), Grid.Loc (Grid.L.max,1));

	    auto a  = world.widgets ~= &(new Custom_Widget (Widget (c1, Grid.Len (1,1)))).widget;
	    auto b  = world.widgets ~= &(new Custom_Widget (Widget (c1, Grid.Len (1,1)))).widget;
	    auto c  = world.widgets ~= &(new Custom_Widget (Widget (c2, Grid.Len (1,1)))).widget;
	    auto d  = world.widgets ~= &(new Custom_Widget (Widget (c3, Grid.Len (1,1)))).widget;
	    auto e  = world.widgets ~= &(new Custom_Widget (Widget (c3, Grid.Len (1,1)))).widget;

	    foreach (_widget; [b,c,d,e]) {
	    	_widget.grid.min_loc = Grid.Loc (1,1);
	    	_widget.grid.max_loc = Grid.Loc (2,1);
	    }
	    
	    SEE_FN
	    widget_see = (event) {
		    if (event.input.type == InputEvent.Type.POINTER) {
		        writeln ("  poiner over widget: ", event.widget);
		    }
	    };

	    (cast (Custom_Widget*) a).see = widget_see;

		// loop
		//loop (&whats,&see);
		foreach (ref event; events)
			see (world, &event);
	}
}


void
see (World* world, Event* event) {
	// find widget
	auto grid_loc = _loc_to_grid_loc (event.input.loc);  // from event

	foreach (_widget; world.widgets (grid_loc)) {
		event.world  =  world;
		event.widget = _widget;

		// callback
		if (auto _widget_see = (cast (Custom_Widget*) _widget).see) {
			_widget_see (event);
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

alias SEE_FN = void function (Event* event);  // struct {void* _this; void* _cb;}

struct
Custom_Widget {
    world.Widget widget;
    SEE_FN		 see;
}

auto
events () {
    return [
    	Event (
    		Event.Type.INPUT, 
    		InputEvent (InputEvent.Type.POINTER), 
    		AppEvent (),
		),
	];
}


struct
Event {
	Type 		type;
    InputEvent  input;
    AppEvent    app;
    World*      world;
    Widget*     widget;

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
    Type type;
    Loc  loc;

    enum 
    Type {
        _,
        POINTER,
    }

    // if (InputEvent) ...
    bool opCast (T) () if (is (T == bool)) { return (type != 0); }
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
