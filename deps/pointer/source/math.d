import app : Loc,Len;

//
// Math
//
//   0 - over
// < 0 - right
// > 0 - left
auto
p_and_ab (Loc p, Loc a, Loc b) {  // cross_product  // simd_cross - векторное произведение
    auto t = p - a;
    auto d = b - a;
    return (d[0] * t[1] - d[1] * t[0]);  // can optimize ?
                                         //  d = p - a
                                         //  d.swap_xy
                                         //  d = d * b SIMD
                                         //  result = d[0] - d[1]
                                         //  simd_cross
}
bool
p_right_ab (Loc p, Loc a, Loc b) {
    return p_and_ab (p,a,b) < 0;
}
bool
p_left_ab (Loc p, Loc a, Loc b) {
    return p_and_ab (p,a,b) > 0;
}
bool
p_right_or_over_ab (Loc p, Loc a, Loc b) {
    return p_and_ab (p,a,b) <= 0;
}
bool
p_left_or_over_ab (Loc p, Loc a, Loc b) {
    return p_and_ab (p,a,b) >= 0;
}
bool
p_over_ab (Loc p, Loc a, Loc b) {
    return p_and_ab (p,a,b) == 0;
}


//
// Loc, Len
//
// (loc in (loc,len)
//   x >= loc.x && x < len.x
//   y >= loc.y && y < len.y
//   z >= loc.z && z < len.z
//
// check 1: xy over xy,wh
// check 2: xy over point,line,triangle,rect,poligon,...
//                  loc[1],loc[2],loc[3],loc[4],loc[N]
// 
// check 1
//   loc!2 & (loc!2,len!2)
//     loc[0] >= loc[0]  &&  loc[0] < (loc[0] + len[0])
//     loc[1] >= loc[1]  &&  loc[1] < (loc[1] + len[1])
//
// check 2
//   loc over a,b
//
// check 3
//   loc over Shape (loc1,loc2,loc3)
//
// loc in triangle
//   1: loc over (min_loc,max_loc)
//   2: loc over Lines (loc1,loc2,loc3)
//   3: loc over Shape (loc1,loc2,loc3)
bool
loc_in_loclen (Loc a_loc, Loc b_loc, Len b_len) {
    static foreach (i; 0..Loc.N)  // x,y,z
    if ((a_loc[i] >= b_loc[i]) && (a_loc[i] < (b_loc[i] + b_len[i])))
        return true;

    return false;
}
bool
loc_between_locs (Loc loc, Loc min_loc, Loc max_loc) {
    static foreach (i; 0..Loc.N)  // x,y,z
    if ((loc[i] >= min_loc[i]) && (loc[i] <= max_loc[i]))
        return true;

    return false;
}
bool
loc_over_line (Loc loc, Loc a, Loc b) {
    return p_over_ab (loc, a,b);
}

bool 
is_point_in_triangle (Triangle) (Loc p, Triangle t) {
    return is_point_in_triangle (p, t.a, t.b, t.c);
}
bool 
is_point_in_triangle (Loc p, Loc a, Loc b, Loc c) {
    auto sign1 = (b.x - a.x) * (p.y - a.y) - (p.x - a.x) * (b.y - a.y);
    auto sign2 = (c.x - b.x) * (p.y - b.y) - (p.x - b.x) * (c.y - b.y);
    auto sign3 = (a.x - c.x) * (p.y - c.y) - (p.x - c.x) * (a.y - c.y);
    
    return (sign1 >= 0 && sign2 >= 0 && sign3 >= 0) || 
           (sign1 <= 0 && sign2 <= 0 && sign3 <= 0);

    // SIMD
    // simd_cross (p, a,b)
    // if > 0  // at right ab
    // simd_cross (p, a,c)
    // if < 0  // at left  ac
    // simd_cross (p, b,c)
    // if > 0  // at right bc
}



//
// SIMD
//
//#include <immintrin.h>
import inteli;

auto
_mm_shuffle_ps (alias a, alias b, int imm8) () {
    return inteli._mm_shuffle_ps!imm8 (a,b);
}

// Функция для вычисления векторного произведения
pragma (inline,true) 
float 
simd_cross_product (__m128 vec1, __m128 vec2) {
    // Извлекаем компоненты x и y из первого вектора
    __m128 ax = _mm_shuffle_ps!(vec1, vec1, _MM_SHUFFLE(0, 0, 0, 0));  // ax
    __m128 ay = _mm_shuffle_ps!(vec1, vec1, _MM_SHUFFLE(1, 1, 1, 1));  // ay
    
    // Извлекаем компоненты x и y из второго вектора
    __m128 bx = _mm_shuffle_ps!(vec2, vec2, _MM_SHUFFLE(0, 0, 0, 0));  // bx
    __m128 by = _mm_shuffle_ps!(vec2, vec2, _MM_SHUFFLE(1, 1, 1, 1));  // by
    
    // Вычисляем произведения
    __m128 term1 = _mm_mul_ps (ax, by);  // ax * by
    __m128 term2 = _mm_mul_ps (ay, bx);  // ay * bx
    
    // Вычисляем результат
    __m128 result = _mm_sub_ps(term1, term2);  // ax*by - ay*bx
    
    // Конвертируем результат в скаляр
    return _mm_cvtss_f32(result);
}

// Пример использования
float cross_product(float* a, float* b) {
    __m128 vec1 = _mm_load_ps(a);  // Загрузка первого вектора
    __m128 vec2 = _mm_load_ps(b);  // Загрузка второго вектора
    return simd_cross_product(vec1, vec2);
}
