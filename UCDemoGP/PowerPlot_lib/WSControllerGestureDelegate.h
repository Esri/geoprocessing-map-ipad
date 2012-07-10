///
///  WSControllerGestureDelegate.h
///  PowerPlot
///
///  This protocol is implemented by a delegate for control gestures
///  of a WSPlotController. The most common use is a single tap
///  gesture, where the delegate receives information about the
///  potential target.
///
///
///  Created by Wolfram Schroers on 1/22/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "NAAmethyst.h"

@class WSPlotController;

@protocol WSControllerGestureDelegate <NSObject>

@optional

/** @brief The range for a hit-test on data points.
 
    The return value specifies the allowed range between a tap
    location and the resulting data point. The controller's
    hitTestMethod property will determine whether the range will be
    used at all or if it used for the distance in X-, Y-direction or
    both.
 
    If this function is not defined or returns a value <= 0., the
    range is assumed to be infinite.
 
    @return Allowed distance between tap and data.
 */
- (NAFloat)singleTapRange;

/** @brief Return closest datum to current tap location.
 
    This method is called when the controller's hitResponseMethod is
    set to kHitResponseDatum.
 
    If no data point is found within singleTapRange around the tap
    location, -1 is returned. If several data points are found, the
    one closest to the tap location is returned. The definition of
    'close' is based on the hitTestMethod property of the controller.
 
    @param controller The controller who manages the gesture recognizer.
    @param i The index of the resulting datum.
 */
- (void)controller:(WSPlotController *)controller
  singleTapAtDatum:(NSInteger)i;

/** Return actual coordinates of the tap in the controller's view.

    This method is called when the controller's hitResponseMethod is
    set to kHitResponseLocationBounds.
 
    @param controller The controller who manages the gesture recognizer.
    @param aPoint The point in bounds coordinates.
 */
- (void)controller:(WSPlotController *)controller
  singleTapAtPoint:(CGPoint)aPoint;

/** Return actual coordinates of the tap in the controller's view.

    This method is called when the controller's hitResponseMethod is
    set to kHitResponseLocationData.

    @param controller The controller who manages the gesture recognizer.
    @param aPointD The point in data coordinates.
 */
- (void)controller:(WSPlotController *)controller
 singleTapAtPointD:(CGPoint)aPointD;

@end
