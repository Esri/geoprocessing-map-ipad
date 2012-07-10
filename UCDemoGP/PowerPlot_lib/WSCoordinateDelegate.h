///
///  WSCoordinateDelegate.h
///  PowerPlot
///
///  This protocol defines methods that deal with coordinate
///  transformations between data coordinates (used by all Data Model
///  objects and all View and Controller objects (and their respective
///  variables) whose names end with a capital "D") and bounds
///  (screen) coordinates that are used for drawing to the current
///  view.
///
///  These methods must be implemented by a controller class that
///  knows about the views - and hence the bounds coordinates - and
///  the coordinate system used - and thus also the data coordinates.
///
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <UIKit/UIKit.h>
#import "NARange.h"
#import "WSCoordinate.h"


@protocol WSCoordinateDelegate <NSObject>

@required

@property (nonatomic, readonly) CGRect viewBounds; ///< The bounds of the view.
@property (nonatomic) NARange rangeXD; ///< The X-coordinate axis range.
@property (nonatomic) NARange rangeYD; ///< The Y-coordinate axis range.

/** Return the X-coordinate inverted flag. */
- (BOOL)invertedX;

/** Return the Y-coordinate inverted flag. */
- (BOOL)invertedY;

/** Return the X bound coordinate of a given data coordinate. */
- (NAFloat)boundsWithDataXD:(NAFloat)aDatumD;

/** Return the Y bound coordinate of a given data coordinate. */
- (NAFloat)boundsWithDataYD:(NAFloat)aDatumD;

/** Return the X-data coordinate of a given bounds coordinate. */
- (NAFloat)dataWithBoundsX:(NAFloat)aDatum;

/** Return the Y-data coordinate of a given bounds coordinate. */
- (NAFloat)dataWithBoundsY:(NAFloat)aDatum;

/** Transform the sender from data to bounds coordinates. */
- (NAFloat)boundsWithDataD:(NAFloat)aDatumD
                 direction:(WSCoordinateDirection)direction;

/** Transform the sender from bounds to data coordinates. */
- (NAFloat)dataWithBounds:(NAFloat)aDatum
                direction:(WSCoordinateDirection)direction;

/** Return the size of the current view (bounds.size.[width|height]). */
- (NAFloat)boundsSizeForDirection:(WSCoordinateDirection)direction;

/** Return the offset of the current view (bounds.origin.[x|y]). */
- (NAFloat)boundsOffsetForDirection:(WSCoordinateDirection)direction;


@optional

/** Set the X- and Y-coordinate axis scale methods. */
- (void)setCoordinateScaleX:(WSCoordinateScale)scaleX
                     scaleY:(WSCoordinateScale)scaleY;

@end
