//------------------------------------------------
//               Ch05_02.cpp
//------------------------------------------------
#include <iomanip>
#include <iostream>
// No need for Windows-specific headers like <tchar.h> or <windows.h>

using namespace std;

// Corrected function signature with pointers for _sa and _vol
extern "C" void CalcSphereAreaVolume_(double r, double *_sa, double *_vol);

int main(int argc, char *argv[]) { // Use main and char* for portable code
  double r[] = {0.0, 1.0, 2.0, 3.0, 5.0, 10.0, 20.0, 32.0};
  size_t num_r = sizeof(r) / sizeof(double);

  cout << setprecision(8);
  cout << "\n--------- Results for CalcSphereAreaVol -----------\n";

  for (size_t i = 0; i < num_r; i++) {
    double sa = -1, vol = -1;
    // Pass the radius (r[i]) by value
    // Pass the addresses (&sa, &vol) for the assembly function to write to
    CalcSphereAreaVolume_(r[i], &sa, &vol);
    cout << "i: " << i << "  ";
    cout << "r: " << setw(6) << r[i] << "  ";
    cout << "sa: " << setw(11) << sa << "  ";
    cout << "vol: " << setw(11) << vol << '\n';
  }
  return 0;
}
