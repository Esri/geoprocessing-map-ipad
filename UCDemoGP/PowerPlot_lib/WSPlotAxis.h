///
///  WSPlotAxis.h
///  PowerPlot
///
///  This class plots the coordinate axis, usually consisting of the
///  axis lines with ticks, labels and (possibly) an enclosing box.
///  The appearance can be adjusted with a wide range of options.
///
///
///  Created by Wolfram Schroers on 25.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSPlot.h"


/** Configuration of default axis appearance (in bounds coordinates). */
#define kAPaddingX 30.0
#define kAPaddingY 40.0
#define kAOverhangX 5.0
#define kAOverhangY 10.0
#define kAArrowLength 14.4
#define kAStrokeWidth 3.0
#define kDefaultTicksDistance 75.0
#define kALabelFont [UIFont systemFontOfSize:12.0]

@class WSData;
@class WSTicks;
@class WSAxisProperties;

@interface WSPlotAxis : WSPlot {

@protected
    UIColor *_axisColor;
    NAFloat _axisArrowLength, _axisStrokeWidth;
    BOOL _drawBoxed;
    WSTicks *_ticksX, *_ticksY;
    NAFloat _gridStrokeWidth;
    UIColor *_gridColor;
}

@property (retain, nonatomic) WSAxisProperties *axisX; ///< Style of X-axis.
@property (retain, nonatomic) WSAxisProperties *axisY; ///< Style of Y-axis.
@property (copy, nonatomic) UIColor *axisColor;        ///< Color of both axis.
@property (nonatomic) NAFloat axisArrowLength;         ///< Length of axis arrows.
@property (nonatomic) NAFloat axisStrokeWidth;         ///< Axis Stroke width.
@property (nonatomic) BOOL drawBoxed;                  ///< Should the axis form a box.
@property (retain, nonatomic) WSTicks *ticksX;         ///< Tick marks on X-axis.
@property (retain, nonatomic) WSTicks *ticksY;         ///< Tick marks on Y-axis.
@property (nonatomic) NAFloat gridStrokeWidth;         ///< Grid bars stroke width.
@property (copy, nonatomic) UIColor *gridColor;        ///< Colors of grid bars.

/** @brief Set the X-axis major ticks using a given data set.
 
    The X-values will be used to set the ticks. If this instance's
    data delegate is set to the same data set used in a data plot in
    the chart, this method can simply be called with [&lt;instance&gt;
    dataD] as a parameter. Otherwise, the data (possibly form another
    data source) has to be supplied. This method does not use the
    plot's own delegate on purpose.
  
    @param data WSData input data from which to take the X-values.
 */
- (void)setTicksXDWithData:(WSData *)data;

/** @brief Set the major ticks and labels using a given data set.
 
    The X-values and the annotations in the input data will be used to
    set the ticks. If this instance's data delegate is set to the same
    data set used in a data plot in the chart, this method can simply
    be called with [&lt;instance&gt; dataD] as a parameter. Otherwise,
    the data (possibly form another data source) has to be
    supplied. This method does not use the plot's own delegate on
    purpose.
  
    @param data WSData input data from which to take the information.
 */
- (void)setTicksXDAndLabelsWithData:(WSData *)data;

/** @brief Set the major ticks and labels using a given data set.
 
    The X-values and the annotations in the input data will be used to
    set the ticks. However, it will only use those labels that are at
    least "distance" points in bounds coordinates away. Hence this
    method - unlike the previous one - will not clutter the axis of a
    plot if too many X-values are available.

    If this instance's data delegate is set to the same data set used
    in a data plot in the chart, this method can simply be called with
    [&lt;instance&gt; dataD] as a parameter. Otherwise, the data
    (possibly from another data source) has to be supplied as the
    parameter. This method does not use the plot's own delegate on
    purpose.
    
    @param data WSData input data from which to take the information.
    @param distance Minimum distance in bounds coordinates.
 */
- (void)setTicksXDAndLabelsWithData:(WSData *)data
                        minDistance:(NAFloat)distance;

/** @brief Set the X-axis major ticks automatically.
 
    This method needs an appropriately setup coordinate system to
    work.  One way to make sure it works well is to set the data
    delegate to the same one that handles the plots with data in the
    chart. Another one is to use the methods in WSChart to keep the
    coordinate systems in all plots synchronized. This is the setting
    in all default charts, but the user has the choice to use
    different coordinate systems and even different axis in a chart if
    she so wishes.

    @note Unlike previous methods, this method will use the plot's own
          WSDataDelegate!
 */
- (void)autoTicksXD;

/** @brief Set the Y-axis major ticks automatically.
 
    This method needs an appropriately setup coordinate system to
    work.  One way to make sure it works well is to set the data
    delegate to the same one that handles the plots with data in the
    chart. Another one is to use the methods in WSChart to keep the
    coordinate systems in all plots synchronized. This is the setting
    in all default charts, but the user has the choice to use
    different coordinate systems and even different axis in a chart if
    she so wishes.

    @note Unlike previous methods, this method will use the plot's own
          WSDataDelegate!
 */
- (void)autoTicksYD;

/** @brief Set the X-axis ticks automatically to powers of ten of 1, 2 and 5.
 
    This method provides a "nicer" way to set tick labels than the
    standard equi-distant method used above.
 
    @note This method also sets the tick labels to an appropriate number
          of digits!
 */
- (void)autoNiceTicksXD;

/** @brief Set the Y-axis ticks automatically to powers of ten of 1, 2 and 5.
 
    This method provides a "nicer" way to set tick labels than the
    standard equi-distant method used above.

    @note This method also sets the tick labels to an appropriate number
          of digits!
*/
- (void)autoNiceTicksYD;

/** @brief Set the X-tick label strings.
 
    This method uses the existing major tick positions and generates a
    label at each point using a default decimal style formatter.
 */
- (void)setTickLabelsX;

/** @brief Set the Y-tick label strings.

    This method uses the existing major tick positions and generates a
    label at each point using a default decimal style formatter.
 */
- (void)setTickLabelsY;

/** Set the X-tick labels using a default NSNumberFormatter style. */
- (void)setTickLabelsXWithStyle:(NSNumberFormatterStyle)style;

/** Set the Y-tick labels using a default NSNumberFormatter style. */
- (void)setTickLabelsYWithStyle:(NSNumberFormatterStyle)style;

/** Set the X-tick labels using a custom formatter. */
- (void)setTickLabelsXWithFormatter:(NSNumberFormatter *)formatter;

/** Set the Y-tick labels using a custom formatter. */
- (void)setTickLabelsYWithFormatter:(NSNumberFormatter *)formatter;

@end
