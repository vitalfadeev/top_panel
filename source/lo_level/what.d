module lo_level.what;

import std.stdio : writefln;


version (linux) {  // evdev
version (LIBINPUT) {  // libinput
    import libinput_d;
    import libinput_struct;
    import lo_level.appinput;
    //import libinput_struct : LibInput,Event;

    struct
    What {
        // ushort
        // libinput_event*
        //   ushort
        //   void*
        Type                     type;
        union {
        lo_level.appinput.Event _app;
          libinput_struct.Event _input;  // (event = libinput_get_event (li)) != null
        }

        this (Type type) {
            this.type = type;
        }

        this (lo_level.appinput.Event event) {
            import std.conv : to;
            this.type = event.type.to!(ushort).to!(Type);
            this._app = event;
        }

        this (libinput_struct.Event event) {
            import std.conv : to;
            this.type   = event.type.to!(ushort).to!(Type);
            this._input = event;
        }

        //Type type () { return _event.type; }  // *(libinput_event* _event).type

        enum
        Type : ushort {
            NONE                    = LIBINPUT_EVENT_NONE,
            DEVICE_ADDED            = LIBINPUT_EVENT_DEVICE_ADDED,
            DEVICE_REMOVED          = LIBINPUT_EVENT_DEVICE_REMOVED,
            KEYBOARD_KEY            = LIBINPUT_EVENT_KEYBOARD_KEY,
            POINTER_MOTION          = LIBINPUT_EVENT_POINTER_MOTION,
            POINTER_MOTION_ABSOLUTE = LIBINPUT_EVENT_POINTER_MOTION_ABSOLUTE,
            POINTER_BUTTON          = LIBINPUT_EVENT_POINTER_BUTTON,
            POINTER_AXIS            = LIBINPUT_EVENT_POINTER_AXIS,
            TOUCH_DOWN              = LIBINPUT_EVENT_TOUCH_DOWN,
            TOUCH_UP                = LIBINPUT_EVENT_TOUCH_UP,
            TOUCH_MOTION            = LIBINPUT_EVENT_TOUCH_MOTION,
            TOUCH_CANCEL            = LIBINPUT_EVENT_TOUCH_CANCEL,
            TABLET_TOOL_AXIS        = LIBINPUT_EVENT_TABLET_TOOL_AXIS,
            TABLET_TOOL_PROXIMITY   = LIBINPUT_EVENT_TABLET_TOOL_PROXIMITY,
            TABLET_TOOL_TIP         = LIBINPUT_EVENT_TABLET_TOOL_TIP,
            TABLET_TOOL_BUTTON      = LIBINPUT_EVENT_TABLET_TOOL_BUTTON,
            GESTURE_SWIPE_BEGIN     = LIBINPUT_EVENT_GESTURE_SWIPE_BEGIN,
            GESTURE_SWIPE_UPDATE    = LIBINPUT_EVENT_GESTURE_SWIPE_UPDATE,
            GESTURE_SWIPE_END       = LIBINPUT_EVENT_GESTURE_SWIPE_END,
            GESTURE_PINCH_BEGIN     = LIBINPUT_EVENT_GESTURE_PINCH_BEGIN,
            GESTURE_PINCH_UPDATE    = LIBINPUT_EVENT_GESTURE_PINCH_UPDATE,
            GESTURE_PINCH_END       = LIBINPUT_EVENT_GESTURE_PINCH_END,
            _                       = NONE,  // 0
            APP                     = 1000,  // 16384
            START                   = APP + 1,
            DRAW                    = APP + 2,
            //APP                     = lo_level.appinput.Event.Type.APP,  // 16384
            //START                   = lo_level.appinput.Event.Type.START,
            //DRAW                    = lo_level.appinput.Event.Type.DRAW,
        }

        bool
        is_app () {
            return (type >= Type.APP);
            //return ((type & Type.APP) != 0);
        }

        bool
        is_input () {
            return (type > Type.NONE) && (type < Type.APP);
            //return ((type & Type.APP) == 0) && (type  != Type.NONE);
        }

        string
        toString () {
            import std.format : format;
            import std.conv   : to;

            if (is_app)
                return format!"APP   : %s: %s" (type,_app);
            else
            if (is_input)
                return format!"INPUT : %s: %s" (type,_input);
            else
                return format!"_     : %s    " (type);
        }
    }
}
else
version (EVDEV) {
    import lo_level.input_event_codes;  // EV_, SYN_, KEY_, BTN_, SW_, MSC_, ABS_, LED_, REP_, SND_

    class
    What {
        union {
            Input_Event event;
            struct {
                Timeval time;  // long, long
                ushort  type;  // EV_KEY, EV_REL, EV_ABS, EV_MSC, EV_SW, EV_LED, EV_SND, EV_REP, EV_FF, EV_PWR, EV_FF_STATUS
                ushort  code;
                uint    value;
            }
        }

        // evdev
        //   include/uapi/linux/input-la-codes.h
        //     EV_SYN, EV_KEY, EV_REL, EV_ABS, EV_MSC, EV_SW, EV_LED, EV_SND, EV_REP, EV_FF, EV_PWR, EV_FF_STATUS
        enum 
        Type : ushort {
            syn       = EV_SYN,
            key       = EV_KEY,
            rel       = EV_REL,
            abs       = EV_ABS,
            msc       = EV_MSC,
            sw        = EV_SW,
            led       = EV_LED,
            snd       = EV_SND,
            rep       = EV_REP,
            ff        = EV_FF,
            pwr       = EV_PWR,
            ff_status = EV_FF_STATUS,
            max       = EV_MAX,
            // custom
            draw      = EV_MAX + 1,
        }
    }

    struct
    Input_Event {
        Timeval time;  // event timestamp in milliseconds
        ushort  type;  // EV_KEY, EV_REL, EV_ABS, EV_MSC, EV_SW, EV_LED, EV_SND, EV_REP, EV_FF, EV_PWR, EV_FF_STATUS
        ushort  code;
        uint    value;
    }

    struct 
    Timeval {
        time_t      tv_sec;
        suseconds_t tv_usec;
    }

    alias time_t      = ulong;  // c_long = 'ulong' on 64-bit systen
    alias suseconds_t = ulong;
} // EVDEV
}
else
version (Win64) {
    // same as linux evdev
    //   include/winuser.h 
    //     WM_USER, WM_APP
}
else
version (SDL) {
    import std.format : format;
    import std.conv   : to;
    import bindbc.sdl;

    class
    What {
        union {
            SDL_Event _super;
            UserEvent _user;
        }
        alias _super this;
        alias sdl = _super;

        //Window*       window;
        SDL_Window*   sdl_window;
        SDL_Renderer* sdl_renderer;
        //Klasses*      klasses;
        //Path          path;
        //E             main_e;    // = path[0]
        //E             focused;   // for what.key
        //E[]           m_in;      // for what.mouse
        //E[]           m_over;    // for what.mouse
        //E[]           m_out;     // for what.mouse

        override
        string
        toString () {
            return 
                format!
                    "What (%s,%s)" 
                    (cast (_SDL_EventType_decode) type, 
                    (type == SDL_USEREVENT) ? 
                        (cast (UserEvent.Type) user.code).to!string : 
                        ""
                    );
        }
    }

    enum  
    _SDL_EventType_decode : SDL_EventType {
        SDL_FIRSTEVENT                = 0,
        SDL_QUIT                      = 0x100,
        SDL_APP_TERMINATING           = 0x101,
        SDL_APP_LOWMEMORY             = 0x102,
        SDL_APP_WILLENTERBACKGROUND   = 0x103,
        SDL_APP_DIDENTERBACKGROUND    = 0x104,
        SDL_APP_WILLENTERFOREGROUND   = 0x105,
        SDL_APP_DIDENTERFOREGROUND    = 0x106,
        SDL_WINDOWEVENT               = 0x200,
        SDL_SYSWMEVENT                = 0x201,
        SDL_KEYDOWN                   = 0x300,
        SDL_KEYUP                     = 0x301,
        SDL_TEXTEDITING               = 0x302,
        SDL_TEXTINPUT                 = 0x303,
        SDL_MOUSEMOTION               = 0x400,
        SDL_MOUSEBUTTONDOWN           = 0x401,
        SDL_MOUSEBUTTONUP             = 0x402,
        SDL_MOUSEWHEEL                = 0x403,
        SDL_JOYAXISMOTION             = 0x600,
        SDL_JOYBALLMOTION             = 0x601,
        SDL_JOYHATMOTION              = 0x602,
        SDL_JOYBUTTONDOWN             = 0x603,
        SDL_JOYBUTTONUP               = 0x604,
        SDL_JOYDEVICEADDED            = 0x605,
        SDL_JOYDEVICEREMOVED          = 0x606,
        SDL_CONTROLLERAXISMOTION      = 0x650,
        SDL_CONTROLLERBUTTONDOWN      = 0x651,
        SDL_CONTROLLERBUTTONUP        = 0x652,
        SDL_CONTROLLERDEVICEADDED     = 0x653,
        SDL_CONTROLLERDEVICEREMOVED   = 0x654,
        SDL_CONTROLLERDEVICEREMAPPED  = 0x655,
        SDL_FINGERDOWN                = 0x700,
        SDL_FINGERUP                  = 0x701,
        SDL_FINGERMOTION              = 0x702,
        SDL_DOLLARGESTURE             = 0x800,
        SDL_DOLLARRECORD              = 0x801,
        SDL_MULTIGESTURE              = 0x802,
        SDL_CLIPBOARDUPDATE           = 0x900,
        SDL_DROPFILE                  = 0x1000,
        SDL_USEREVENT                 = 0x8000,
        SDL_LASTEVENT                 = 0xFFFF,
        SDL_RENDER_TARGETS_RESET      = 0x2000,
        SDL_KEYMAPCHANGED             = 0x304,
        SDL_AUDIODEVICEADDED          = 0x1100,
        SDL_AUDIODEVICEREMOVED        = 0x1101,
        SDL_RENDER_DEVICE_RESET       = 0x2001,
        SDL_DROPTEXT                  = 0x1001,
        SDL_DROPBEGIN                 = 0x1002,
        SDL_DROPCOMPLETE              = 0x1003,
        SDL_DISPLAYEVENT              = 0x150,
        SDL_SENSORUPDATE              = 0x1200,
        SDL_LOCALECHANGED             = 0x107,
        SDL_CONTROLLERTOUCHPADDOWN    = 0x656,
        SDL_CONTROLLERTOUCHPADMOTION  = 0x657,
        SDL_CONTROLLERTOUCHPADUP      = 0x658,
        SDL_CONTROLLERSENSORUPDATE    = 0x659,
        SDL_TEXTEDITING_EXT           = 0x305,
        SDL_JOYBATTERYUPDATED         = 0x607,
        SDL_CONTROLLERUPDATECOMPLETE_RESERVED_FOR_SDL3 = 0x65A,
        SDL_CONTROLLERSTEAMHANDLEUPDATED = 0x65B,
    }
}
else {  // default version
    class
    What {
        Type type;

        enum 
        Type {
            _     = 0x00,
            key   = 0x01,
            mouse = 0x02,
            draw  = 0x04,
        }
    }
}


version (SDL) {
    union
    UserEvent {
        SDL_EventType    type = SDL_USEREVENT;
        SDL_UserEvent    user;
        update_UserEvent update;

        this (update_UserEvent ev) {
            this.update = ev;
        }

        enum
        Type : typeof (SDL_UserEvent.code) {  // Sint32
            start = 1,
            update,
            draw,
            redraw,
            click,
            scroll_up_request,
            scroll_dn_request,
            scroll_page_up_request,
            scroll_page_dn_request,
            scroll_start_request,
            scroll_end_request,
            scroll_percent_request,
            update_scrollbar,
        }
    }

    struct
    update_UserEvent {
        SDL_EventType type = SDL_USEREVENT;
        Uint32        timestamp;
        Uint32        windowID;
        Sint32        code = UserEvent.Type.update;
        //E*            e;
        //E*            root;
        //Path          path; // parents
        //Loc[]         locs; // parent loc s
        //Window*       window;

        //this (E* e) {
        //    this.e = e;
        //}
    }
}

