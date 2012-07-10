/**
 *  @file
 *  NABezierControlPoints.h
 *  NuAS Amethyst Graphics System
 *
 *  This header defines the function for computing Bezier cubic spline
 *  control points. The points are computed based on the continuity
 *  condition for the first two derivatives.
 *
 *  Details and an example algorithm can be found at
 *  http://www.codeproject.com/KB/graphics/BezierSpline.aspx
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NABEZIERCONTROLPOINTS_H__
#define __NABEZIERCONTROLPOINTS_H__

#include <CoreGraphics/CoreGraphics.h>
#include "NABase.h"


int NABezierControlPoints(const int,
                          const CGPoint[],
                          CGPoint**,
                          CGPoint**);

void solve_eqsys(NAFloat[],
                 const NAFloat[],
                 NAFloat[],
                 const unsigned);


#endif /* __NABEZIERCONTROLPOINTS_H__ */
