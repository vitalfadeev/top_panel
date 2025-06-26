module e;

import see;
import able;
import tree;
import loc;
import len;
import lo_level.what;


class
E {
    mixin See !(typeof(this),What);
    mixin Able!(typeof(this));
    mixin Tree!(typeof(this));
    mixin Len !(typeof(this));
    mixin Loc !(typeof(this));
}
