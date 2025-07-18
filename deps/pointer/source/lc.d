struct
LC {               // 64
    int length;    // 32
    int capacity;  // 32

    auto
    muldiv (int b) {
        return (b * length) >> capacity;
    }
}


version (XXX):
// 24.8
struct
Fixed_24_8 {
    int a;

    auto length   () { return a >> 8; }
    auto capacity () { return a & 0xff; }

    void
    muldiv (int b) {  // SIMD
        // load EAX, b
        // load EBX, a
        // movz ECX, AL   // save 8bit capacity
        //             
        // mul  EAX, EBX  // (b * a) >> R
        // shr  EAX, CL
        // shr  EAX, 8    // remove 8/bit capacity
        __m128i vec = _mm_cvtsi32_si128(b);
        return _mm_cvtsi128_si32 (vec);
    }
}
