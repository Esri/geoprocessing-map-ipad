///
///  WSPlotRegion.h
///  PowerPlot
///
///  This class plots filled regions of data. The regions are bounded
///  by an upper and a lower data set. As such this class can readily
///  be used to display error bands in scientific
///  charts. Alternatively, the input data can also provide regions in
///  the form of contours which allows this class to be used for
///  contour plots as well.
///
///  The data provides the region boundary by x- and y-values in the
///  order they are provided. Note that it necessary to provide the
///  data in the correct order. For this purpose the WSContour
///  category on WSData provides a factory method to generate a
///  contour for an error band plot.
///
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSPlot.h"


/** Styles the region can be drawn. */
typedef enum _WSRegionPlotStyle {
    kRegionPlotNone = -1, ///< Do not show a plot.
    kRegionPlotContour,   ///< Show the contour line only.
    kRegionPlotFilled,    ///< Show only the filled region.
    kRegionPlotAll        ///< Show the filling plus contour.
} WSRegionPlotStyle;

@interface WSPlotRegion : WSPlot {
    
@protected
    NAFloat _lineWidth;
    NADashingStyle _dashStyle;
    UIColor *_lineColor;
    UIColor *_fillColor;    
    WSRegionPlotStyle _style;
}

@property (nonatomic) NAFloat lineWidth;        ///< Width of contour line.
@property (nonatomic) NADashingStyle dashStyle; ///< Dashing of the contour line.
@property (copy, nonatomic) UIColor *lineColor; ///< Color of contour line.
@property (copy, nonatomic) UIColor *fillColor; ///< Filling color of region.
@property (nonatomic) WSRegionPlotStyle style;  ///< Style for drawing the contour plot.

@end
