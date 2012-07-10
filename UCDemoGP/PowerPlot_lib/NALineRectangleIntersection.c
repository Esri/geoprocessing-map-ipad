/*
 *  NALineRectangleIntersection.c
 *  NuAS Amethyst Graphics System
 *
 *
 *  Created by Wolfram Schroers on 11.10.10.
 *  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#include "NALineRectangleIntersection.h"
#include "NALineIntersection.h"
#include "NABase.h"
#include "math.h"


/** @brief Return the intersection of a line with a rectangle.
 
    This function returns the intersection points of a line and a
    rectangle. One point of the line has to lie inside the rectangle
    and the other one outside. If these conditions are not met,
    CGPoint(NAN, NAN) is returned. Otherwise, the coordinates of the
    intersection point are returned.
 
    @return Intersection point.
    @param start Line starting point.
    @param end Line end point.
    @param rectangle The CGRect describing the rectangle.
 */
CGPoint NALineInternalRectangleIntersection(const CGPoint start,
                                            const CGPoint end,
                                            const CGRect rectangle) {

    /* Are the conditions fulfilled? */
    CGPoint myStart = start;
    CGPoint myEnd = end;
    if (CGRectContainsPoint(rectangle, start)) {
        /* Always place the ending point in the rectangle. */
        CGPoint tmp = start;
        myStart = end;
        myEnd = tmp;
    }

    if (!((!CGRectContainsPoint(rectangle, myStart)) &&
          (CGRectContainsPoint(rectangle, myEnd)))) {
        return CGPOINT_INVALID;
    }
    
    /* At this point there is only one intersection. Find and return it. */
    CGPoint result = NALineIntersection(myStart,
                                        myEnd,
                                        rectangle.origin,
                                        CGPointMake(rectangle.origin.x,
                                                    rectangle.origin.y+rectangle.size.height));
    if (!isnan(result.x)) {
        return result;
    }
    
    result = NALineIntersection(myStart,
                                myEnd,
                                CGPointMake(rectangle.origin.x,
                                            rectangle.origin.y+rectangle.size.height),
                                CGPointMake(rectangle.origin.x+rectangle.size.width,
                                            rectangle.origin.y+rectangle.size.height));
    if (!isnan(result.x)) {
        return result;
    }

    result = NALineIntersection(myStart,
                                myEnd,
                                CGPointMake(rectangle.origin.x+rectangle.size.width,
                                            rectangle.origin.y+rectangle.size.height),
                                CGPointMake(rectangle.origin.x+rectangle.size.width,
                                            rectangle.origin.y));
    if (!isnan(result.x)) {
        return result;
    }
    
    result = NALineIntersection(myStart,
                                myEnd,
                                CGPointMake(rectangle.origin.x+rectangle.size.width,
                                            rectangle.origin.y),
                                rectangle.origin);

    return result;
}
