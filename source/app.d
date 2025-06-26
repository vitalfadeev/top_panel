import std.stdio;
import e;
import lo_level.whats;
import lo_level.what;
import lo_level.see;
import hi_level.main_loop;
import tree : WalkTree;


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
		auto main_e = new E ();
		auto button = new Button ();
		main_e.add_dr (button);

		// main loop
		auto whats = Whats ();
		auto see   = &main_e.see;
		main_loop (whats,see);
	}
}


class 
Button : E {
	override
	void
	see (What what) {
		writeln ("Button.see ()");
		switch (what.type) {
			case 1: break;
			default:
		}
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


