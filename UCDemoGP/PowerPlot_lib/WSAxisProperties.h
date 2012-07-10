///
///  WSAxisProperties.h
///  PowerPlot
///
///  This class describes the customizable properties of a coordinate
///  axis in a WSPlotAxis plot. WSPlotAxis has two instances of this
///  class, one for the X- and one for the Y-axis.
///
///
///  Created by Wolfram Schroers on 1/22/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSCustomProperties.h"
#import "NAAmethyst.h"


/** Possible styles of a coordinate axis. */
typedef enum _WSAxisStyle {
    kAxisNone = -1,             ///< Do not show the axis.
    kAxisPlain,                 ///< Plain line for axis.
    kAxisArrow,                 ///< Line with axis arrow.
    kAxisArrowFilledHead,       ///< Line with axis arrow that has a solid arrowhead.
    kAxisArrowInverse,          ///< Line with axis arrow pointing at the other direction.
    kAxisArrowFilledHeadInverse ///< Line with solid arrowhead pointing at the other direction.
} WSAxisStyle;

/** Possible styles of a grid. */
typedef enum _WSGridStyle {
    kGridNone = -1, ///< No grid.
    kGridPlain,     ///< Solid grid lines at major axis ticks.
    kGridDotted     ///< Dotted grid lines at major axis ticks.
} WSGridStyle;

/** Location of an axis label. */
typedef enum _WSLabelStyle {
    kLabelNone = -1, ///< Do not show axis label.
    kLabelCenter,    ///< Axis label at center (will be rotated on Y-axis).
    kLabelEnd,       ///< Axis label at end of axis.
    kLabelInside     ///< Axis label on the reverse side (data side).
} WSLabelStyle;

@interface WSAxisProperties : WSCustomProperties

@property (nonatomic) WSAxisStyle axisStyle;     ///< Style of axis.
@property (nonatomic) NAFloat axisOverhang;      ///< Axis extend beyond the end.
@property (nonatomic) NAFloat axisPadding;       ///< Axis offset from bounds rectangle.
@property (nonatomic) WSGridStyle gridStyle;     ///< Style of coordinate grid.
@property (nonatomic) WSLabelStyle labelStyle;   ///< Location of axis label.
@property (nonatomic) NAFloat labelOffset;       ///< Additional offset of the axis label.
@property (copy, nonatomic) NSString *axisLabel; ///< Axis label text.
@property (copy, nonatomic) UIFont *labelFont;   ///< Axis label font.
@property (copy, nonatomic) UIColor *labelColor; ///< Axis label color.

@end
