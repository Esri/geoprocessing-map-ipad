///
///  @file
///  WSAxisLocationDelegate.h
///  PowerPlot
///
///  This protocol is implemented by the controller who handles the
///  axis location. The axis location is needed for WSPlotAxis,
///  WSPlotBar, WSPlotData and others. These plots draw either from
///  the data down to the axis or the axis itself.
///
///
///  Created by Wolfram Schroers on 12/19/11.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSAxisLocation.h"


@protocol WSAxisLocationDelegate <NSObject>

@property (nonatomic) NAFloat axisBoundsX;   ///< X-axis in bounds coordinates.
@property (nonatomic) NAFloat axisBoundsY;   ///< Y-axis in bounds coordinates.
@property (nonatomic) NAFloat axisDataXD;    ///< X-axis in data coordinates.
@property (nonatomic) NAFloat axisDataYD;    ///< Y-axis in data coordinates.
@property (nonatomic) NAFloat axisRelativeX; ///< X-axis in relative bounds coordinates.
@property (nonatomic) NAFloat axisRelativeY; ///< Y-axis in relative bounds coordinates.

@property (nonatomic) WSAxisLocationPreservationStyle axisPreserveOnChangeX; ///< Which property is held fixed for X-axis.
@property (nonatomic) WSAxisLocationPreservationStyle axisPreserveOnChangeY; ///< Which property is held fixed for Y-axis.

@end
