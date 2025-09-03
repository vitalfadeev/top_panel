module e;

version (NEVER) :
import see;
import can;
import tree;
import loc;
import len;
import hit;
import what;


class
E {
    What
    see (What what) {
        return What ();  // null
    }
}

class
CanSee : E {
    override
    What
    see (What what) {
        return What ();  // null
    }
}

class
CanShape : E {
    bool 
    see (XY xy) {
        return false;
    }
}

class
RectShape : CanShape {
    XYS!2 xys;

    override
    bool
    see (XY xy) {
        return (xy in xys);
    }
}

class
CanClick : CanShape {
    import libinput_d;

    override
    What
    see (What what) {
        // left mouse click
        if (is_left_btn (what) && 
            is_pointer_over (what) )
                return What (/*click*/);
        else
            return What ();  // null
    }

    bool
    is_left_btn (What what) {
        //import input_event_codes : BTN_LEFT,LIBINPUT_BUTTON_STATE_PRESSED;
        enum LIBINPUT_BUTTON_STATE_PRESSED = 1;
        enum BTN_LEFT = 0x110;

        if (what.type == What.Type.POINTER_BUTTON) {
            auto _pointer = what._input.pointer;

            return (
                (_pointer.button       == BTN_LEFT) && 
                (_pointer.button_state == LIBINPUT_BUTTON_STATE_PRESSED)
            );
        }
        else {
            return false;
        }
    }

    bool
    is_pointer_over (What what) {
        //import input_event_codes;

        if (what.type == What.Type.POINTER_BUTTON ||
            what.type == What.Type.POINTER_MOTION ||
            what.type == What.Type.POINTER_MOTION_ABSOLUTE ||
            what.type == What.Type.POINTER_AXIS)
        {
            auto _pointer = what._input.pointer;
            //auto _xy = _pointer.xy;

            //return see (_xy);
            return false;
        }
        else {
            return false;
        }
    }

    void
    emit_click (What what) {
        //
    }
}

struct 
XYS (uint N) {
    XY[N] s;

    auto
    opBinaryRight (string op : "in") (XY xy) if (N == 2) {
        return ((xy >= s[0]) && (xy < s[1]));
    }
}

struct
LL {
    union {
        L[2] s;
        struct {
            L x;
            L y;
        }
    }

    auto
    opCmp (LL b) {
        if ((x < b.x) && (y < b.y))
            return -1;
        else
        if ((x > b.x) && (y > b.y))
            return 1;
        else
        if ((x == b.x) && (y == b.y))
            return 0;

        assert (0);
    }
}
alias XY  = LL;

alias L   = int;

// E
//   see
// CanSee
//   see
// CanShape
//   xy[] cached_xy
//   hit_test = see xy
//     xy in shape
// CanClick
//   see
//   hit_test = see xy
//   emit_click
// CanOver
//   see
//   hit_test = see xy
//   emit_over
// CanKey
//   see
//   on_key
