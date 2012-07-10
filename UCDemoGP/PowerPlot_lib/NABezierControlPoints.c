/*
 *  NABezierControlPoints.c
 *  NuAS Amethyst Graphics System
 *
 *
 *  Created by Wolfram Schroers on 11.10.10.
 *  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#include <stdlib.h>
#include "NABezierControlPoints.h"


/** @brief Return control points for a Bezier cubic spline interpolation.
 
    This function computes and allocates two arrays of CGPoint
    structures which contain the control points P1 and P2 for drawing
    smooth (continuous up to the second-order derivative)
    interpolations using Quartz 2D cubic splines. The input data is an
    array of length num, the output consists of two arrays control1
    and control2 of CGPoint which must be free'd by the caller.  The
    length of the array is given by the function's return value.  If
    the return value is smaller than 1, an error has occurred and the
    calculation has been aborted. In that case, the arrays MUST NOT be
    free'd by the caller.
 
    @return Number of control points (> 0 if computation successful).
    @param num Number of input data points.
    @param data Input data points as array.
    @param control1 The array of first control points.
    @param control2 The array of second control points.
 */

int NABezierControlPoints(const int num,
                          const CGPoint data[],
                          CGPoint **control1,
                          CGPoint **control2) {
    
    NAFloat *b, 
            *cprx,
            *cpry,
            *tmp;
    int res = num - 1;
    
    /* Verify there are enough data points. */
    if (res < 1) {
        return 0;
    }
    
    /* Allocate the memory (must be free'd by caller). */
    *control1 = (CGPoint *)malloc(res * sizeof(CGPoint));
    *control2 = (CGPoint *)malloc(res * sizeof(CGPoint));
    
    /* Handle the special case: num = 2. */
    if (res == 1) {
        (*control1)[0] = CGPointMake((2.*data[0].x + data[1].x)/3., 
                                     (2.*data[0].y + data[1].y)/3.);
        (*control2)[0] = CGPointMake(2.*(*control1[0]).x - data[0].x, 
                                     2.*(*control1[0]).y - data[0].y);
        
        return num;
    }
    
    /* Handle the cases num > 2. */
    b = (NAFloat *)malloc(res * sizeof(NAFloat));
    cprx = (NAFloat *)malloc(res * sizeof(NAFloat));
    cpry = (NAFloat *)malloc(res * sizeof(NAFloat));
    tmp = (NAFloat *)malloc(res * sizeof(NAFloat));
    
    /* x-components first. */
    b[0] = data[0].x + 2.*data[1].x;
    b[res-1] = (8.*data[res-1].x + data[res].x)/2.;
    for (int i=1; i<(res-1); i++) {
        b[i] = 4.*data[i].x + 2.*data[i+1].x;
    }
    solve_eqsys(cprx, b, tmp, (unsigned)res);
    
    /* y-components next. */
    b[0] = data[0].y + 2.*data[1].y;
    b[res-1] = (8.*data[res-1].y + data[res].y)/2.;
    for (int i=1; i<(res-1); i++) {
        b[i] = 4.*data[i].y + 2.*data[i+1].y;
    }
    solve_eqsys(cpry, b, tmp, (unsigned)res);

    /* We are done. Free up memory and return result. */
    for (int i=0; i<res; i++) {
        (*control1)[i] = CGPointMake(cprx[i], cpry[i]);
        if (i == (res-1)) {
            (*control2)[i] = CGPointMake((data[res].x + cprx[res-1])/2., 
                                         (data[res].y + cpry[res-1])/2.);
        } else {
            (*control2)[i] = CGPointMake(2.*data[i+1].x - cprx[i+1], 
                                         2.*data[i+1].y - cpry[i+1]);
        }
    }
    free(tmp);
    free(cprx);
    free(cpry);
    free(b);
    
    return res;
}

/** @brief
 
    This function solves the tridiagonal system to get the x- and y-
    components of the control points for Bezier cubic spline
    interpolations. The input data is provided by the array b and the
    output as array cpr. tmp is a temporary array that acts as a
    buffer. All arrays have length n and must be allocated prior to
    the function call. On return, cpr will contain the desired
    solution vector.
 
    @param cpr The solution vector of the system (result).
    @param b The right-hand-side of the system.
    @param tmp A temporary array which will be modified on return.
    @param n The size of each of the previous vectors.
 */

void solve_eqsys(NAFloat cpr[],
                 const NAFloat b[],
                 NAFloat tmp[],
                 const unsigned n) {
    
    NAFloat a = 2.0;

    /* Since the system is tridiagonal, we can solve it in two passes. */
    cpr[0] = b[0] / a;
    for (unsigned i=1; i<n; i++) {
        tmp[i] = 1. / a;
        a = (i<(n-1) ? 4. : 3.5) - tmp[i];
        cpr[i] = (b[i] - cpr[i-1]) / a;
    }
    
    /* Second pass with back-substitution. */
    for (unsigned i=1; i<n; i++) {
        cpr[n-i-1] -= tmp[n-i] * cpr[n-i];
    }
}
