double Rand(void);
double RandN(void);
double GammaRand(double a);
double BetaRand(double a, double b);
size_t BinoRand(double p, size_t n);
unsigned BinoRand32(double p, unsigned n);

void ResetSeed(void);
void SetSeed(long new_ix, long new_iy, long new_iz);
void GetSeed(long *ix_out, long *iy_out, long *iz_out);

double logSum(double a, double b);
double pochhammer(double x, int n);
double di_pochhammer(double x, int n);
double tri_pochhammer(double x, int n);
double gammaln2(double x, double d);
double gammaln(double x);
double digamma(double x);
double trigamma(double x);
double tetragamma(double x);

unsigned *ismember_sorted(double *a, unsigned a_len, double *s, unsigned s_len);
