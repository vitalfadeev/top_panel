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
	    //foreach (event; events) {
	    //    //auto grid_event_loc = event.loc.to!(Grid.Loc);
	    //    auto wordable_event = event.to_wordable_event ();
	    //    world.see (&wordable_event);
	    //}

		// loop
		loop (events,&world.see);
	}
}

auto
events () {
    return _Events ([What ()]);
}
struct
_Events {
    What[] s;

    import std.range;
    
    World_Able_Event*  
    	   front    () { _wevent = s.front.to_wordable_event; return &_wevent; }
    bool   empty    () { return s.empty; }
    void   popFront () { s.popFront; }
	
	void 
	opOpAssign (string op : "~") (World_Able_Event event) {
	    //
	}

    World_Able_Event _wevent;  

}

World_Able_Event
to_wordable_event (Event) (Event event) {
	return World_Able_Event ();
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
