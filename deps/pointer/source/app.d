import std.stdio;
import math;

void 
main () {
	auto p = Pointer (Loc (0,0));
	auto w = Widget (_4_angle (Nangle!4 ([
		Loc (0,0), Loc (1,0), Loc (1,1), Loc (0,1)])
	));

	writeln ("  is p over w: ", (p & w));
}
// /usr/lib/x86_64-linux-gnu/libGLESv2.so.2.1.0
// /usr/include/GLES/gl.h
// /usr/include/GLES/egl.h
// /usr/include/GLES2/gl2.h
// /usr/include/GLES2/gl2ext.h
//
// /usr/include/GL/glx.h

//
// Elements
//
struct
_1_angle {
	Nangle!1 _super;  // point. 1 loc
	alias _super this;    
}
struct
_2_angle {
	Nangle!2 _super;  // line. 2 loc
	alias _super this;    
}
struct
_3_angle {
	Nangle!3 _super;  // tri. 3 loc
	alias _super this;    
}
struct
_4_angle {
	Nangle!4 _super;  // rect. 4 loc
	alias _super this;    
}
struct
Nangle (uint N_ANGLES) {
	// 1
	// loc 1
	// loc 2
	// loc 3
	union {
		Loc[N_ANGLES] angles;
		struct {
			static if (N_ANGLES >= 1)
			Loc a;
			static if (N_ANGLES >= 2)
			Loc b;
			static if (N_ANGLES >= 3)
			Loc c;
			static if (N_ANGLES >= 4)
			Loc d;
		}
	}
	// 2
	Loc min_loc;
	Loc max_loc;  // if (len == 0) (min_loc == max_loc)
	Len max_len () { return Len (max_loc - min_loc); }

	//
	bool
	loc_over (Loc loc) {
	_check_1:
		// check 1
		// 2D rect, 3D cube
		if (loc_between_locs (loc, min_loc, max_loc))
			goto _check_2;

	    return false;

	_check_2:
		// check 2
		// border lines
		static if (N_ANGLES == 0) { /* skip */ }
		static if (N_ANGLES == 1) { /* skip */ }
		static if (N_ANGLES == 2) {
			// xy on xy,xy
		}
		static if (N_ANGLES >= 3) {
		static foreach (i; 0..N_ANGLES-1)  // triangle 0,1,2
		if (loc_over_line (loc, angles[i], angles[i+1]))
			return true;
		}

		return false;

	_check_3:
		// check 3
		// body
		// a,b,c
		//  p > ab
		//  p < ac
		//  p < bc
		static if (N_ANGLES == 0) { /* skip */ }
		static if (N_ANGLES == 1) { /* skip */ }
		static if (N_ANGLES == 2) {
			// xy on xy,xy
		}
		static if (N_ANGLES == 3) {
			return is_point_in_triangle (loc, &this);
		}
		static if (N_ANGLES >= 4) {
			return false;
		}

		return false;
	}
}


// auto a = simd_float4 (1.0, 2.0, 3.0, 4.0)
// auto b = simd_float4 (2.0, 3.0, 4.0, 5.0)
// auto
// auto dotProduct   = simd_dot (a, b)
// auto crossProduct = simd_cross (a, b)
// auto length       = simd_length (a)
// auto shuffled     = simd_shuffle (a, b, (1, 0, 3, 2))


//
struct
Widget {
	_4_angle _super;  // rect. 4 loc
	alias _super this;    

    auto
    opBinary (string op : "&") (Pointer b) {
    	return _super.loc_over (b.loc);
    }
    auto
    opBinaryRight (string op : "&") (Pointer b) {
    	return _super.loc_over (b.loc);
    }
}

struct
Pointer {
    Loc loc;
}


//
// Loc
//
struct
Len {
    Loc _super;
    alias _super this;

	this (Loc loc) {
		_super = loc;
	}
	this (ARGS...) (ARGS args) {
		_super = typeof (_super) (args);
	}
}

struct
Loc {
	union {
    L[N] ls;  // xy.  SIMD optimized, CPU-Register optimized
              // int32x2
              // ls[0] x, ls[1] y
              //
              // SIMD
              // simd_cross
              // simd_sub
              // simd_add
              // simd_mul_each
    struct {
    	static if (N >= 1)
    	L x;
    	static if (N >= 2)
    	L y;
    	static if (N >= 3)
    	L z;
    }
	}

    enum N = 2;

    static if (N == 2)
    this (L x, L y) {
    	this.ls[0] = x;
    	this.ls[1] = y;
    }

    L
    opIndex (size_t i) {
    	return ls[i];
    }

    Loc
    opBinary (string op : "-") (Loc b) {
    	return Loc (this.ls[0] - b.ls[0], this.ls[1] - b.ls[1]);
    }
}

alias L = int;  // x | y | z  | ...
