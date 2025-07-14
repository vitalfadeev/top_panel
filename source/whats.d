module whats;

auto
Whats () {
    import appinput : Events;
    import what     : AppEvent;
    return Events!AppEvent ();
}
