#include <cstdint>
#include <iostream>

using namespace std;

typedef int8_t i8;
typedef uint8_t u8;
typedef int16_t i16;
typedef uint16_t u16;
typedef int32_t i32;
typedef uint32_t u32;
typedef int64_t i64;
typedef uint64_t u64;

extern "C" i64 IntegerMul_(i8 a, i16 b, i32 c, i64 d, i8 e, i16 f, i32 g, i64 h);
extern "C" i64 UIntegerDiv_(u8 a, u16 b, u32 c, u64 d, u8 e, u16 f, u32 g, u64 h, u64* quo, u64* rem);

void IntegerMul(void){
    i8 a = 2;
    i16 b = -3;
    i32 c = 8;
    i64 d = 4;
    i8 e = 3;
    i16 f = -7;
    i32 g = -5;
    i64 h = 10;

    //Calc mul all toghether
    i64 prod1 = a * b * c * d * e * f * g * h;
    i64 prod2 = IntegerMul_(a, b, c, d, e, f, g, h);
    cout << "\nResults for IntegerMul\n";
    cout << "a = " << (int)a << ", b = " << b << ", c = " << c << ' ';
    cout << "d = " << d << ", e = " << (int)e << ", f = " << f << ' ';
    cout << "g = " << g << ", h = " << h << '\n';
    cout << "prod1 = " << prod1 << '\n';
    cout << "prod2 = " << prod2 << '\n';
}

void UnsignedIntegerDiv(void)
{
    uint8_t a = 12;
    uint16_t b = 17;
    uint32_t c = 71000000;
    uint64_t d = 90000000000;
    uint8_t e = 101;
    uint16_t f = 37;
    uint32_t g = 25;
    uint64_t h = 5;
    uint64_t quo1, rem1;
    uint64_t quo2, rem2;
    quo1 = (a + b + c + d) / (e + f + g + h);
    rem1 = (a + b + c + d) % (e + f + g + h);
    UIntegerDiv_(a, b, c, d, e, f, g, h, &quo2, &rem2);
    cout << "\nResults for UnsignedIntegerDiv\n";
    cout << "a = " << (unsigned)a << ", b = " << b << ", c = " << c << ' ';
    cout << "d = " << d << ", e = " << (unsigned)e << ", f = " << f << ' ';
    cout << "g = " << g << ", h = " << h << '\n';
    cout << "quo1 = " << quo1 << ", rem1 = " << rem1 << '\n';
        cout << "quo2 = " << quo2 << ", rem2 = " << rem2 << '\n';
}

int main(){
    // IntegerMul();
    UnsignedIntegerDiv();
    return 0;
}
