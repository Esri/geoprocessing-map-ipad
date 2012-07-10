/**
 *  @file
 *  NALineIntersection.h
 *  NuAS Amethyst Graphics System
 *
 *  This header defines a function that finds an intersecting point of
 *  two lines (if it exists). If the two lines are identical (i.e.,
 *  they have infinitely many intersection points) or if they never
 *  intersect, CGPoint(NAN, NAN) is returned. Otherwise, the
 *  coordinates of the intersection point are returned.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NALINEINTERSECTION_H__
#define __NALINEINTERSECTION_H__

#include <CoreGraphics/CoreGraphics.h>
#include "NABase.h"


CGPoint NALineIntersection(const CGPoint,
                           const CGPoint,
                           const CGPoint,
                           const CGPoint);


#endif /* __NALINEINTERSECTION_H__ */

