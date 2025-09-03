import types;
version (VIDEO_WAYLAND) 
    import impl;
version (INPUT_WAYLAND) 
    import impl;

struct 
_Backend (Video,Input,Draw) {
    Video video;
    Input input;
    Draw  draw;
}

alias DRAW_FN = void function (wayland_ctx* ctx, uint* pixels /* xrgb8888 */);

auto
Backend (Len window_len, DRAW_FN draw) {
    version (VIDEO_WAYLAND)
        auto video = Wayland (window_len.x,window_len.y,draw);
    version (INPUT_WAYLAND)
        auto input = Events (&video);
    auto backend = 
        _Backend!(Wayland,Events,DRAW_FN) (
            video,
            input,
            draw
        );

    return backend;
}

import events     : Base_Events     = Events;
import app_events : Base_App_Events = App;
version (INPUT_WAYLAND) 
    alias TEvents = Base_Events!(Base_App_Events,impl.Events);

version (INPUT_WAYLAND) 
struct
Events {
    TEvents _events;
    Event    front;

    this (Wayland* wayland) {
        _events = TEvents (App (), impl.Events (wayland));
    }

    bool  
    empty () {
        auto ret = _events.empty;
        if (!ret) {
            ret = check_exit ();
            front.input_event = &_events.front;
        }
        return ret;
    }

    void 
    popFront () {
        _events.popFront ();
    }    

    bool
    check_exit () {
        if (front.input_event.type == 1)
        switch (front.input_event.type) {
            case front.input_event.sources.inp.front.Type.POINTER_BUTTON: 
                if (front.input_event.sources.inp.front.pointer.button == BTN_LEFT)
                    return true;
                break;
            case front.input_event.sources.inp.front.Type.KEYBOARD_KEY: 
                if (front.input_event.sources.inp.front.keyboard.key == KEY_ESC)
                    return true;
                break;
            default:
        }

        return false;
    }
}
