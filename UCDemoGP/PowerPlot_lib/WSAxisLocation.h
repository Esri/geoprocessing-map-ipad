///
///  WSAxisLocation.h
///  PowerPlot
///
///  Stores the position of an axis. This class stores the location of
///  a coordinate axis in bounds coordinates, data coordinates and
///  relative bounds coordinates (corresponding to 0...1 for
///  left/right and top/bottom). When any property (the bounds of the
///  view or the data coordinate range) changes, it returns an updated
///  axis position such some condition picked by the user is
///  fulfilled. To do this it uses the flag preserveOnChange which
///  determines which property is held fixed: either the axis location
///  in bounds coordinates, the axis locaiton in data coordinates or
///  the relative location is preserved.
///
///  Whenever one of the properties change by a property setter, the
///  flag preserveOnChange is automatically set to the property which
///  has been modified. Furthermore, the other properties are
///  automatically updated based on the current status of the view and
///  the coordinates.
///
///  Thus, to initially set the X-axis location to the data origin 0
///  and subsequently keep it at the current relative position on
///  screen, use:
///
///  WSAxisLocation *axisLoc = [...];
///  [axisLoc setDataD:0.];
///  [axisLoc setPreserveOnChange:kPreserveRelative];
///
///  From this point on, any retrieval of of any of the properties
///  return the location of the axis such that it is fixed to the
///  relative position on screen when it had been set to the data
///  origin 0.
///
///
///  Created by Wolfram Schroers on 12/19/11.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSObject.h"
#import "WSCoordinateDelegate.h"
#import "WSCoordinateDirection.h"
#import "NAAmethyst.h"


/** The properties of an axis that can be preserved. */
typedef enum _WSAxisLocationPreservationStyle {
    kPreserveNone = -1, ///< Simply return unmodified values.
    kPreserveBounds,    ///< Preserve the bounds location.
    kPreserveData,      ///< Preserve the data location.
    kPreserveRelative   ///< Preserve the relative location on screen.
} WSAxisLocationPreservationStyle;

@interface WSAxisLocation : WSObject

@property (assign, nonatomic) id<WSCoordinateDelegate> coordDelegate; ///< Coordinate helper.

@property (nonatomic) WSCoordinateDirection direct; ///< Direction of this coordinate.
@property (nonatomic) NAFloat bounds;   ///< Position in bounds coordinates.
@property (nonatomic) NAFloat dataD;    ///< Position in data coordinates.
@property (nonatomic) NAFloat relative; ///< Position in relative bounds coordinates.

@property (nonatomic) WSAxisLocationPreservationStyle preserveOnChange; ///< Which property is fixed.

@end
