/**
 *  @file
 *  NALineRectangleIntersection.h
 *  NuAS Amethyst Graphics System
 *
 *  This header defines functions for testing line/rectangle
 *  intersections.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NALINERECTANGLEINTERSECTION_H__
#define __NALINERECTANGLEINTERSECTION_H__

#include <CoreGraphics/CoreGraphics.h>
#include "NABase.h"


CGPoint NALineInternalRectangleIntersection(const CGPoint,
                                            const CGPoint,
                                            const CGRect);


#endif /* __NALINERECTANGLEINTERSECTION_H__ */

