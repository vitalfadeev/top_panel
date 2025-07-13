import std.stdio;
import std.conv;
import e : E,CanClick;
import lo_level.whats;
import lo_level.what;
import lo_level.see;
import hi_level.main_loop;
import tree : WalkTree,WalkChilds,childs;


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
	{
		// tree
		auto main_e = new Main ();
		//auto button = new Button ();
		//main_e.add_dr (button);

		// main loop
		auto whats = Whats ();
		main_loop (whats,&main_e.see);
	}
}


class
Main : CanClick {
	override
	What
	see (What what) {
		import lo_level.appinput : AppEvent = Event;
		import libinput_d        : LIBINPUT_EVENT_POINTER_BUTTON;

		writefln ("%s", what);
		if (what.type == What.Type.POINTER_BUTTON){
		//if (what.type == What.Type.INPUT && what._input.type == LIBINPUT_EVENT_POINTER_BUTTON){
			return What (AppEvent (AppEvent.Type.DRAW));
		}
		
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
