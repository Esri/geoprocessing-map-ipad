/*
 *  NALineIntersection.c
 *  NuAS Amethyst Graphics System
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#include "NALineIntersection.h"
#include "math.h"


/** @brief Return the intersection of two lines.
 
    This function returns the intersection points of two straight
    lines.  If the two lines are identical (i.e., they have infinitely
    many intersection points) or if they never intersect, CGPoint(NAN,
    NAN) is returned. Otherwise, the coordinates of the intersection
    point are returned.
 
    @return Intersection point.
    @param start1 Starting point line 1.
    @param end1 End point line 1.
    @param start2 Starting point line 2.
    @param end2 End point line 2.
 */

CGPoint NALineIntersection(const CGPoint start1,
                           const CGPoint end1,
                           const CGPoint start2,
                           const CGPoint end2) {
    
    /* Setup the system of equations. */
    CGFloat a = end1.x - start1.x;
    CGFloat b = -end2.x + start2.x;
    CGFloat c = end1.y - start1.y;
    CGFloat d = -end2.y + start2.y;
    
    CGFloat det = a * d - b * c;
    
    /* Check if the system is singular. */
    if (IS_EPSILON(det)) {
        return CGPOINT_INVALID;
    }
    
    /* Otherwise, find the intersection point. */
    CGFloat aInv = d / det;
    CGFloat bInv = -b / det;
    CGFloat cInv = -c / det;
    CGFloat dInv = a / det;
    
    CGFloat x = aInv * (start2.x - start1.x) + bInv * (start2.y - start1.y);
    CGFloat y = cInv * (start2.x - start1.x) + dInv * (start2.y - start1.y);

    /* If the intersection point does not lie within the line segments,
       also return CGPOINT_INVALID. */
    if ((x < 0.0) || (x > 1.0) || (y < 0.0) || (y > 1.0)) {
        return CGPOINT_INVALID;
    }
    
    /* Otherwise return the result. */
    return CGPointMake(start1.x + x * (end1.x - start1.x),
                       start1.y + x * (end1.y - start1.y));
}
