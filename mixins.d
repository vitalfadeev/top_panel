// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/format/internal/write.d(1993,40)
(in ref int a) => a

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/functional.d(449,16)
cast(T)a < cast(T) b

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/format/spec.d(170,13)
private ubyte _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf;@property bool flDash() @safe pure nothrow @nogc const { return (_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf & 1U) != 0;}
@property void flDash(bool v) @safe pure nothrow @nogc { if (v) _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf |= 1U;else _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf &= cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))(-1-cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))1U);}
@property bool flZero() @safe pure nothrow @nogc const { return (_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf & 2U) != 0;}
@property void flZero(bool v) @safe pure nothrow @nogc { if (v) _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf |= 2U;else _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf &= cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))(-1-cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))2U);}
@property bool flSpace() @safe pure nothrow @nogc const { return (_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf & 4U) != 0;}
@property void flSpace(bool v) @safe pure nothrow @nogc { if (v) _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf |= 4U;else _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf &= cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))(-1-cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))4U);}
@property bool flPlus() @safe pure nothrow @nogc const { return (_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf & 8U) != 0;}
@property void flPlus(bool v) @safe pure nothrow @nogc { if (v) _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf |= 8U;else _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf &= cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))(-1-cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))8U);}
@property bool flHash() @safe pure nothrow @nogc const { return (_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf & 16U) != 0;}
@property void flHash(bool v) @safe pure nothrow @nogc { if (v) _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf |= 16U;else _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf &= cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))(-1-cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))16U);}
@property bool flEqual() @safe pure nothrow @nogc const { return (_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf & 32U) != 0;}
@property void flEqual(bool v) @safe pure nothrow @nogc { if (v) _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf |= 32U;else _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf &= cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))(-1-cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))32U);}
@property bool flSeparator() @safe pure nothrow @nogc const { return (_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf & 64U) != 0;}
@property void flSeparator(bool v) @safe pure nothrow @nogc { if (v) _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf |= 64U;else _flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf &= cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))(-1-cast(typeof(_flDash_flZero_flSpace_flPlus_flHash_flEqual_flSeparator__bf))64U);}

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/functional.d(449,16)
cast(T)a < cast(T) b

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/functional.d(219,13)
alias a = __a ;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/functional.d(220,13)
alias b = __b ;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/functional.d(221,20)
a == b

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(445,13)
enum int data = 0;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(445,13)
enum int count = 0;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(624,9)
alias _0LU = Identity!(field[0LU]);alias data = _0LU;alias _1LU = Identity!(field[1LU]);alias count = _1LU;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(624,9)
alias _0LU = Identity!(field[0LU]);alias _1LU = Identity!(field[1LU]);

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7004,17)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7021,21)

    case '\u0000':..case '\u0008':case '\u000E':..case '\u001F':case '\u007F':..
    case '\u0084':case '\u0086':..case '\u009F': case '\u0009':..case '\u000C': case '\u0085':

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7030,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7034,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7040,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7044,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7049,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7056,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7060,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7068,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7082,13)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7004,17)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7021,21)

    case '\u0000':..case '\u0008':case '\u000E':..case '\u001F':case '\u007F':..
    case '\u0084':case '\u0086':..case '\u009F': case '\u0009':..case '\u000C': case '\u0085':

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7030,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7034,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7040,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7044,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7049,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7056,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7060,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7068,21)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/uni/package.d(7082,13)

            static if (getValue)
                grapheme ~= ch;
            range.popFront();
        

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs < rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs < rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs == rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs < rhs

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/std/typecons.d(517,31)
lhs < rhs

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at 
.object.size_t h = 0;foreach (i, T; typeof(p.tupleof))    static if(is(T* : const(.object.Object)*))         h = h * 33 + typeid(const(.object.Object)).getHash(cast(const void*)&p.tupleof[i]);    else         h = h * 33 + typeid(T).getHash(cast(const void*)&p.tupleof[i]);return h;

// expansion at /usr/lib/ldc/x86_64-linux-gnu/include/d/core/atomic.d(576,9)
*cast(T*)&val+=mod

