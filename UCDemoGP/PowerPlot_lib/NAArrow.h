/**
 *  @file
 *  NAArrow.h
 *  NuAS Amethyst Graphics System
 *
 *  This header defines basic functions of the NuAS Amethyst Graphics
 *  library. It defines functions and data types for supporting
 *  pre-defined dashing styles in 2D data-related chart curves.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NAARROW_H__
#define __NAARROW_H__

#include <CoreGraphics/CoreGraphics.h>
#include "NABase.h"


/** Styles an arrow can be plotted. */
typedef enum _NAArrowStyle {
    kArrowLineNone,
    kArrowLinePlain,
    kArrowLineArrow,
    kArrowLineFilledHead,
} NAArrowStyle;

/** Predefined fixed arrow drawing angle. */
extern const NAFloat kArrowAngle;


void NAContextAddLineArrow(const CGContextRef,
                           const NAArrowStyle,
                           const CGPoint,
                           const CGPoint,
                           const NAFloat,
                           const NAFloat);

void NAContextAddLineDoubleArrow(const CGContextRef,
                                 const NAArrowStyle,
                                 const CGPoint,
                                 const CGPoint,
                                 const NAFloat,
                                 const NAFloat);


#endif /* __NAARROW_H__ */

