module hit;

import loc;
import e;


mixin template 
Hit (T) {
    bool
    hit_test (What what) {
        return false;
    }
}
