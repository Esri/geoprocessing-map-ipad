/**
 *  @file
 *  NARange.h
 *  NuAS Amethyst Graphics System
 *
 *  NARange is a utility structure that manages intervals of floating
 *  point values. It is implemented similar to NSRange and others and
 *  offers a few additional feature functions.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NARANGE_H__
#define __NARANGE_H__

#include <Foundation/Foundation.h>
#include "NABase.h"


/** Constant: Invalid NARange. */
#define NARANGE_INVALID NARangeMake(NAN, NAN)

/** Accuracy of floating point comparison. */
#define RTOL 1e-04
#define ATOL 1e-07

/** An interval with starting and ending point. */
typedef struct _NARange {
    NAFloat rMin;
    NAFloat rMax;
} NARange;

/** Alias name. */
typedef NARange *NARangePointer;


/** Inline function to quickly define a NARange. */
NS_INLINE NARange NARangeMake(const NAFloat minVal, const NAFloat maxVal) {
    NARange r;
    // Ascertain that the minimum is always the smaller value.
    if (maxVal<minVal) {
        r.rMin = maxVal;
        r.rMax = minVal;
    } else {
        r.rMin = minVal;
        r.rMax = maxVal;
    }
    return r;
}

/** Return the width of a NARange. */
NS_INLINE NAFloat NARangeLen(const NARange range) {
    return fabs(range.rMax - range.rMin);
}

/** Return the center point of a NARange. */
NS_INLINE NAFloat NARangeCenter(const NARange range) {
    return 0.5*(range.rMax + range.rMin);
}

/** Return the maximum range covered by the two ranges supplied. */
NS_INLINE NARange NARangeMax(const NARange range1, const NARange range2) {
    NARange r;
    r.rMin = fmin(range1.rMin, range2.rMin);
    r.rMax = fmax(range1.rMax, range2.rMax);
    return r;
}

/** Return a range stretched by the golden ratio with the same center. */
NS_INLINE NARange NARangeStretchGoldenRatio(const NARange range) {
    NARange r;
    NAFloat center = (range.rMin + range.rMax)/2.0;
    NAFloat halfNewSize = 0.5 * M_GOLDENRATIO * (range.rMax - range.rMin);
    
    r.rMin = center - halfNewSize;
    r.rMax = center + halfNewSize;
    return r;
}

/** Return equality flag of NAFloat numbers. */
NS_INLINE BOOL float_eq(const NAFloat a, const NAFloat b) {
    return (fabs(b-a) < (ATOL+RTOL*fabs(a+b)));
}

/** Return if an NARange has zero width. */
NS_INLINE BOOL NARange_hasZeroLen(const NARange range) {
    return float_eq(NARangeLen(range), 0.);
}

/** Return if an NARange is valid (both boundaries are not NAN). */
NS_INLINE BOOL NARange_isValid(const NARange range) {
    return !(isnan(range.rMin) || isnan(range.rMax));
}


#endif /* __NARANGE_H__ */

