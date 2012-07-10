/**
 *  @file
 *  NADashing.h
 *  NuAS Amethyst Graphics System
 *
 *  This header defines basic functions of the NuAS Amethyst Graphics
 *  library. It defines functions and data types for supporting
 *  pre-defined dashing styles in 2D data-related chart curves.
 *
 *  @note: Dash sizes are constant and fixed now! The size is
 *         appropriate for both iPhone and iPad.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NADASHING_H__
#define __NADASHING_H__

#include <CoreGraphics/CoreGraphics.h>
#include "NABase.h"


/** Styles of dashing a line can be drawn with. */
typedef enum _NADashingStyle {
    kDashingSolid,
    kDashingDotted,
    kDashingDashed,
    kDashingDashDotted
} NADashingStyle;

/** Predefined fixed dashing styles (constant length). */
extern const NAFloat kStyleDot[];
extern const NAFloat kStyleDash[];
extern const NAFloat kStyleDashDot[];


void NAContextSetLineDash(const CGContextRef,
                          const NADashingStyle);


#endif /* __NADASHING_H__ */

