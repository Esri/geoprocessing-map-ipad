///
///  WSDataPointProperties.h
///  PowerPlot
///
///  This class describes the customizable properties of a data point
///  in a WSPlotData plot. Instances can be stored inside the
///  customDatum property of a WSDatum object for use of individual
///  point styles or used as a generic description for all points in
///  the plot.
///
///
///  Created by Wolfram Schroers on 1/19/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSObject.h"
#import "NAAmethyst.h"
#import "WSCustomProperties.h"


/// Default symbol appearance.
#define kSymbolSize 5.0
#define kErrorBarLen 10.0
#define kErrorBarWdith 1.5

/// Styles the error bars can be drawn.
typedef enum _WSErrorStyle {
    kErrorNone = 0, ///< Do not draw error bars.
    kErrorYFlat,    ///< Draw Y error bars with no delimiter bars.
    kErrorYCapped,  ///< Draw Y error bars with delimiter bars (caps).
    kErrorXYFlat,   ///< Draw X, Y error bars with no delimiter bars.
    kErrorXYCapped  ///< Draw X, Y error bars with delimiter bars (caps).
} WSErrorStyle;

@interface WSDataPointProperties : WSCustomProperties

@property (nonatomic) NASymbolStyle symbolStyle;    ///< Symbol for data points.
@property (nonatomic) NAFloat symbolSize;           ///< Size of data point symbol.
@property (copy, nonatomic) UIColor *symbolColor;   ///< Symbol color.
@property (nonatomic) NAFloat errorBarLen;          ///< Length of the error bar delimiter.
@property (nonatomic) NAFloat errorBarWidth;        ///< Width of the error bar lines.
@property (copy, nonatomic) UIColor *errorBarColor; ///< Color of error bars.
@property (nonatomic) WSErrorStyle errorStyle;      ///< Error bars-style.

@end
