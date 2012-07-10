///
///  WSDiscProperties.h
///  PowerPlot
///
///  This class describes the customizable properties of a disc in a
///  WSPlotDisc plot. Instances can be stored inside the customDatum
///  property a WSDatum object for use of individual discs or as a
///  generic object describing all discs in a WSPlotDisc.
///
///
///  Created by Wolfram Schroers on 1/22/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSCustomProperties.h"
#import "NAAmethyst.h"


/** Styles the discs can be drawn. */
typedef enum _WSDiscStyle {
    kDiscPlotNone = -1, ///< Do not draw any discs.
    kDiscPlotContour,   ///< Show the outline only.
    kDiscPlotFilled,    ///< Show only the filled disc.
    kDiscPlotAll        ///< Show the filling plus outline.
} WSDiscStyle;

@interface WSDiscProperties : WSCustomProperties

@property (nonatomic) NAFloat lineWidth;        ///< Width of outline.
@property (copy, nonatomic) UIColor *lineColor; ///< Color of outline.
@property (copy, nonatomic) UIColor *fillColor; ///< Filling color.
@property (nonatomic) WSDiscStyle discStyle;    ///< Style for drawing the discs.

@end
