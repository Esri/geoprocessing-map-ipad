///
///  WSCoordinateTransform.h
///  PowerPlot
///
///  Protocol which a coordinate transformation needs to implement.
///  Custom coordinate transformations also need to implement this
///  protocol.
///
///
///  Created by Wolfram Schroers on 08.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <UIKit/UIKit.h>
#import "NABase.h"


@protocol WSCoordinateTransform <NSObject>

@required

/** Return the coordinate transformation of a value.

    @param valueD Input location in data coordinates. 
    @return Return value in intermediate scheme with range [0..1].
 */
- (NAFloat)transform:(NAFloat)valueD;

/** Return axis ticks locations.

    @param aRange Range in which to generate tick locations.
    @param labelNum Number of ticks in input range.
    @return NSArray of NSNumber (float) with tick locations in data coordinates.
 */
- (NSArray *)tickLocationsWithRange:(NARange)aRange
                             number:(NAFloat)labelNum;

@optional

/** Reverse a coordinate transformation (inverse of transform). */
- (NAFloat)inverseTransform:(NAFloat)value;

/** Return a custom NSNumberFormatter for this particular transformation. */
- (NSNumberFormatter *)coordinateFormatter;

@end
