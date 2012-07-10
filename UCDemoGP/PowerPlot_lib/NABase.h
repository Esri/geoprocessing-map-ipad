/**
 *  @file
 *  NABase.h
 *  NuAS Amethyst Graphics System
 *
 *  This header interfaces basic definitions of interfaces to
 *  functions of the NuAS Amethyst Graphics library.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NABASE_H__
#define __NABASE_H__

/** Generic definition of floating point numbers. */
#define NAFloat CGFloat

/** Constant: Golden ratio. */
#define M_GOLDENRATIO 1.6180339887498949

/** Constant: 1/sqrt(2). */
#define M_ISQRT2 0.70710678118654746

/** Constant: Invalid CGPoint. */
#define CGPOINT_INVALID CGPointMake(NAN, NAN)

/** Check for screen-coordinate singularity. */
#define IS_EPSILON(a) (fabs(a) < 1.0e-08)


#endif /* __NABASE_H__ */

