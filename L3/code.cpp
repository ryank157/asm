#include <iostream>
#include <iomanip>
#include <bitset>
#include <typeinfo>

typedef unsigned int uint;
using namespace std;

extern "C" int IntegerShift_(uint a, uint count, uint* a_shl, uint* a_shr); // Example external function

static void PrintResult(const char* s, int rc, uint a, uint count, uint a_shl, uint a_shr){
    bitset<32> a_bs(a);
    bitset<32> a_shl_bs(a_shl);
    bitset<32> a_shr_bs(a_shr);
    const int w=10;
    const char nl = '\n';

    cout << s << nl;
    cout << "count = " << setw(w) << count << nl;
    cout << "a =     " << setw(w) << a << " (0b" << a_bs << ")" << nl;

    if (rc == 0) {
        cout << "Invalid shift count" << nl;
    } else {

    cout << "a_shl = " << setw(w) << a_shl << " (0b" << a_shl_bs << ")" << nl;
    cout << "a_shr = " << setw(w) << a_shr << " (0b" << a_shr_bs << ")" << nl;
    }

    cout << nl;
}

int main() {
    int rc;
    uint a, count, a_shl, a_shr;

    a = 3119;
    count = 6;
    rc = IntegerShift_(a, count, &a_shl, &a_shr);
    PrintResult("Test1", rc, a, count, a_shl, a_shr);

    a = 0x00800080;
    count = 4;
    rc = IntegerShift_(a, count, &a_shl, &a_shr);
    PrintResult("Test2", rc, a, count, a_shl, a_shr);

    a = 0x80000001;
    count = 31;
    rc = IntegerShift_(a, count, &a_shl, &a_shr);
    PrintResult("Test3", rc, a, count, a_shl, a_shr);

    a = 0x55555555;
    count = 32;
    rc = IntegerShift_(a, count, &a_shl, &a_shr);
    PrintResult("Test4", rc, a, count, a_shl, a_shr);

    return 0;
}
