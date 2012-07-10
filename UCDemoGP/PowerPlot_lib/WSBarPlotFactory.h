///
///  WSBarPlotFactory.h
///  PowerPlot
///
///  This category defines a series of factory methods providing
///  common designs for charts with bar plots. The user can choose
///  several default styles. Note that it is still possible to
///  configure all properties of charts generated this way and that it
///  is similarly possible to add custom plots, too. The factory
///  methods in this category will generate either a bar chart with a
///  single set of bars or a bar chart with multiple bars as this is a
///  typical use case.  For multiple bars the user can choose the
///  appearance of how the bars are drawn relative to each
///  other. Either the bars are drawn at the same point, possibly
///  covering each other (kChartBarPlain); this arrangement can also
///  be used for stacked bars. Bars can also be drawn with a
///  displacement that allow bars to be side-by-side (kChartBarTouch)
///  or with a displacement that causes them to overlap
///  (kChartBarDisplaced).  The default colors for multiple bars are
///  picked as different darker of the default primary color and can
///  be customized by the user if desired by modifying the default bar
///  style property of each WSPlotBar view.
///
///  Charts with multiple bars will have different coordinate systems
///  which correspond to the different bar locations. They should have
///  consistent X-values, otherwise the resulting graph may be
///  inconsistent.
///
///  @note The style of
///        barPlotWithFrame:withData:withStyle:withColorScheme: is
///        either kChartBarEmpty or kChartBarPlain. All other choices
///        are equivalent to kChartBarPlain.
///
///
///  Created by Wolfram Schroers on 20.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSChart.h"
#import "WSPlotFactoryDefaults.h"


/** Styles a bar chart can be generated using this category. */
typedef enum _BPStyle {
    kChartBarEmpty = -1, ///< Do not draw anything.
    kChartBarPlain,      ///< Chart with bars (multiple bars are stacked).
    kChartBarTouch,      ///< Chart with multiple touching bars.
    kChartBarDisplaced   ///< Chart with multiple bars that are displaced.
} BPStyle;

@interface WSChart (WSBarPlotFactory)

/** Return an autoreleased chart with a coordinate system and a bar plot.
 
    @param frame The frame of the resulting WSChart view.
    @param data A single input data set.
    @param style Style of the resulting chart.
    @param colors Resulting color scheme.
    @return New chart with single bar plot.
 */
+ (id)barPlotWithFrame:(CGRect)frame
                  data:(WSData *)data
                 style:(BPStyle)style
           colorScheme:(LPColorScheme)colors;

/** Return an autoreleased chart with a coordinate system and several bar plots.
 
    @param frame The frame of the resulting WSChart view.
    @param data NSArray of WSData corresponding to the input data sets.
    @param style Style of the resulting chart.
    @param colors Resulting color scheme.
    @return New chart with multiple bar plot.
 */
+ (id)multiBarPlotWithFrame:(CGRect)frame
                       data:(NSArray *)data
                      style:(BPStyle)style
                colorScheme:(LPColorScheme)colors;

/** @brief Return an autoreleased chart.

    The chart has a coordinate system and a bar plot with individual
    colors.
 
    @param frame The frame of the resulting WSChart view.
    @param data A single input data set.
    @param barCols Individual bar colors. [barCols count] must equal [data count].
    @param style Style of the resulting chart.
    @param colors Resulting color scheme.
    @return New chart with single bar plot. */
+ (id)barPlotWithFrame:(CGRect)frame
                  data:(WSData *)data
             barColors:(NSArray *)barCols
                 style:(BPStyle)style
           colorScheme:(LPColorScheme)colors;

/** @brief Configure the current chart instance.
 
    The instance will have all previous data removed and contain a
    line plot and an axis plot with appropriate configuration.
 
    @param data NSArray of WSData corresponding to the input data set(s).
    @param style Style of the resulting chart.
    @param colors Resulting color scheme.
 */
- (void)configureWithData:(NSArray *)data
                    style:(BPStyle)style
              colorScheme:(LPColorScheme)colors;

@end
