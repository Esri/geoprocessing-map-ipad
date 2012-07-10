///
///  WSPlot.h
///  PowerPlot
///  @file
///
///  This is the base class for all objects that deal with plotting
///  entities to the chart. In general they will require delegates to
///  the coordinate systems and to a data set. However, the data set
///  is optional - the coordinate axis, for example, do not require a
///  data set to plot themselves, but they need a set of coordinates.
///
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSView.h"
#import "WSAxisLocationDelegate.h"
#import "WSCoordinateDelegate.h"
#import "WSDataDelegate.h"
#import "WSAxisLocation.h"


@class WSPlotController;

@interface WSPlot : WSView

@property (assign, nonatomic) WSPlotController *plotController;        ///< The plot controller of this plot.
@property (assign, nonatomic) id<WSAxisLocationDelegate> axisDelegate; ///< Provides the axis positioning.
@property (assign, nonatomic) id<WSCoordinateDelegate> coordDelegate;  ///< Provides the coordinate transformations.
@property (assign, nonatomic) id<WSDataDelegate> dataDelegate;         ///< Provides the data model class.

@property (readonly, nonatomic) BOOL hasData; ///< Does this type of plot support data (even if currently empty)?


/** Plot a sample data point at the given CGPoint (e.g. for legends etc.). */
- (void)plotSample:(CGPoint)aPoint;

/** Switch off all elements in the current plot. */
- (void)setAllDisplaysOff;

/** Force redraw of entire chart (this instance's superview). */
- (void)chartSetNeedsDisplay;

@end
