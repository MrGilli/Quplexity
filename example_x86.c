#include <stdio.h>
#include <xmmintrin.h>
#include <math.h>

extern void _PX( double *qubit );
extern void _PZ( double *qubit );
extern void _H( double *qubit );
extern void _CNOT( double *qc, double *qt );
extern void _CCNOT( double *q1, double *q2, double *q3 );
extern void _CZ( double *qc, double *qt );

static inline double* init(double x, double y){
	double* q = _mm_malloc(2 * sizeof(double), 16);
	q[0] = x;
	q[1] = y;
	return q;
}

int main () {
	double* qubit = init(0.0, 1.0) ;
	_H( qubit ) ;
	printf( "%lf, %lf \n" , qubit[0] , qubit[1] ) ;

	double* control = init(0.0, 1.0);
	double* target = init(1.0, 0.0);
	_CNOT( control, target );
	printf( "target is now %lf, %lf \n", target[0], target[1] );

	_CZ( control, target );
	printf( "target is now %lf, %lf \n", target[0], target[1] );

	double* q1 = init(0.0, 1.0); // |1>
	double* q2 = init(0.0, 1.0); // |1>
	double* q3 = init(1.0, 0.0); // |0>
	_CCNOT( q1, q2, q3 );
	printf( "target q3 is now %lf, %lf \n", q3[0], q3[1] );

	return 0 ;
}
