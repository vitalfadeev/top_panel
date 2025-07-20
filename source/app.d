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
	    auto world = new World (Len (ubyte.max,ubyte.max));  // ubyte.max = 255

	    auto c1 = world.container (Container.Way.r, Container.Balance.l, Loc (0,0), Loc (L.max/3,1));
	    auto c2 = world.container (Container.Way.r, Container.Balance.c, Loc (L.max/3,0), Loc (L.max/3,1));
	    auto c3 = world.container (Container.Way.l, Container.Balance.r, Loc (L.max/3*2,0), Loc (L.max,1));

	    auto a  = world.widget (c1, Len (1,1));
	    auto b  = world.widget (c1, Len (1,1));
	    auto c  = world.widget (c2, Len (1,1));
	    auto d  = world.widget (c3, Len (1,1));
	    auto e  = world.widget (c3, Len (1,1));

	    foreach (_widget; [b,c,d,e]) {
	    	_widget.grid.min_loc = Loc (1,1);
	    	_widget.grid.max_loc = Loc (2,1);
	    }

	    // loop
	    //foreach (event; events) {
	    //    //auto grid_event_loc = event.loc.to!(Grid.Loc);
	    //    auto wordable_event = event.to_wordable_event ();
	    //    world.see (&wordable_event);
	    //}

	    //auto whats = events ();
	    
	    // 
	    alias EVENT_CB = void function (Event* event);  // struct {void* _this; void* _cb;}

	    EVENT_CB 
	    widget_event_callback = (event) {
		    if (event.input.type == InputEvent.Type.POINTER) {
		        writeln ("  poiner over widget: ", event.world.widget);
		    }
	    };

	    a.cust.callback = widget_event_callback;

		// loop
		//loop (&whats,&see);
		foreach (ref event; events) {
	    	// What -> World -> What
	    	//   to_world  to_what
	    	writeln (event);
			auto _wevent = &event.world;

			world.see (_wevent);
			writeln (event.world.widget);

			if (auto _widget = _wevent.widget.widget)
			if (auto _cb     = cast (EVENT_CB) _widget.cust.callback) {
				_cb (&event);
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

auto
events () {
    return [
    	Event (
    		Event.Type.INPUT, 
    		InputEvent (InputEvent.Type.POINTER), 
    		AppEvent (),
    		World.Event (
    			Grid.Event (Loc (0,0)),
    			Container.Event (),
    			Widget.Event (),
    			/* is_gridable */ true,
    			/* is_containerable */ true,
    			/* is_widgetable */ true
			) 
		),
	];
}


World.Event*
to_world (Event* event) {
	// What -> World.Event
	return &event.world;
}

auto 
world_see (World.Event event, World* world) {
	return world.see (&event);
}

Event
to_what (World.Event* wable) {
	// World.Event -> What
	return Event (Event.Type._, InputEvent(), AppEvent(), *wable);  // new converted What
}


struct
Event {
	Type 		type;
    InputEvent  input;
    AppEvent    app;
    World.Event world;

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



class
Main : CanClick {
	override
	What
	see (What what) {
		writefln ("%s", what);
		if (what.type == What.Type.POINTER_BUTTON) {
			// return What (What.Type.DRAW);
			// return What (AppEvent (AppEvent.Type.DRAW));
			return What (AppEvent.Type.DRAW);
		}
		else
			return What ();
	}
}


class 
Button : CanClick {	
	override
	What
	see (What what) {
		import libinput_d;
		writeln ("Button.see ()");
		switch (what.type) {
			case What.Type.POINTER_BUTTON: break;
			default:
		}

		return What (What.Type._);
	}

	override
	R
	next (this R) () {
		return cast (R) null;
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
