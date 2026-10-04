typedef struct { float x, y; } V2;
typedef struct { float x, y, z; } V3;
typedef struct { double a, b, c, d; } Big;
typedef struct { int a; char b; } Small;
typedef struct { long long a; double b; } Mixed;
typedef struct { double b; long long a; } Mixed2;
typedef struct { long long a, b, c; } Large;
V2 add_v2(V2 p, V2 q) { V2 r = {p.x + q.x, p.y + q.y}; return r; }
V3 scale_v3(V3 v, float k) { V3 r = {v.x * k, v.y * k, v.z * k}; return r; }
Big make_big(double base) { Big r = {base, base + 1, base + 2, base + 3}; return r; }
double sum_big(Big b) { return b.a + b.b + b.c + b.d; }
Small make_small(int a, char b) { Small r = {a, b}; return r; }
Mixed swap_mixed(Mixed2 m) { Mixed r = {m.a, m.b}; return r; }
Large add_large(Large x, Large y) { Large r = {x.a + y.a, x.b + y.b, x.c + y.c}; return r; }
V2 apply(V2 (*f)(V2, Big, Small), V2 v, Big b, Small s) { return f(v, b, s); }
Big apply_big(Big (*f)(Big, int)) { Big b = {1, 2, 3, 4}; return f(b, 10); }
Small apply_small(Small (*f)(Small)) { Small s = {7, 3}; return f(s); }
