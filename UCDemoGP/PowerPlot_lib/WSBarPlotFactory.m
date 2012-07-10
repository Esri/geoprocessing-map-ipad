///
///  @file
///  WSBarPlotFactory.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 20.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSBarPlotFactory.h"
#import "WSBarProperties.h"
#import "WSColorScheme.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSPlot.h"
#import "WSPlotAxis.h"
#import "WSAxisProperties.h"
#import "WSPlotBar.h"
#import "WSPlotController.h"
#import "WSTicks.h"


@implementation WSChart (WSBarPlotFactory)

+ (id)barPlotWithFrame:(CGRect)frame
                  data:(WSData *)data
                 style:(BPStyle)style
           colorScheme:(LPColorScheme)colors {
    
    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];
    
    // Configure the chart.
    [chart configureWithData:[NSArray arrayWithObject:data]
                       style:style
                 colorScheme:colors];

    // And return it.
    return chart;
}

+ (id)multiBarPlotWithFrame:(CGRect)frame
                       data:(NSArray *)data
                      style:(BPStyle)style
                colorScheme:(LPColorScheme)colors {
    
    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];
    
    // Configure the chart.
    [chart configureWithData:data
                       style:style
                 colorScheme:colors];
    
    // And return it.
    return chart;    
}

+ (id)barPlotWithFrame:(CGRect)frame
                  data:(WSData *)data
             barColors:(NSArray *)barCols
                 style:(BPStyle)style
           colorScheme:(LPColorScheme)colors {
    
    NSParameterAssert([data count] == [barCols count]);
    
    
    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];
    
    // Configure the chart.
    [chart configureWithData:[NSArray arrayWithObject:data]
                       style:style
                 colorScheme:colors];

    // Set appropriate individual colors.
    NSUInteger i = 0;
    WSPlotBar *barPlot = (WSPlotBar *)[[chart plotAtIndex:0] view];
    [barPlot distributeDefaultPropertiesToAllCustomDatum];
    [barPlot setStyle:kCustomStyleIndividual];
    for (WSDatum *datum in [[barPlot dataDelegate] dataD]) {
        WSBarProperties *prop = (WSBarProperties *)[datum customDatum];
        if ([prop respondsToSelector:@selector(setBarColor:)]) {
             [prop setBarColor:(UIColor *)[barCols objectAtIndex:i]];
        }
        i++;
    }
    
    // And return it.
    return chart;
}

- (void)configureWithData:(NSArray *)data
                    style:(BPStyle)style
              colorScheme:(LPColorScheme)colors {

    NSUInteger i;
    NSUInteger num = [data count];

    
    // Remove all previous data.
    [self removeAllPlots];
    if (style == kChartBarEmpty) {
        return;
    }

    // Initialize the plots.
    WSPlotAxis *axis = [[WSPlotAxis alloc] initWithFrame:[self bounds]];
    NSMutableArray *barPlots = [[NSMutableArray alloc]
                                initWithCapacity:num];
    for (i=0; i<num; i++) {
        [barPlots addObject:(WSPlotBar *)[[WSPlotBar alloc]
                                            initWithFrame:[self bounds]]
                                          ];
    }
    
    // Initialize the controllers.
    WSPlotController *axisController = [[WSPlotController alloc] init];
    NSMutableArray *barControllers = [[NSMutableArray alloc]
                                      initWithCapacity:num];
    [axisController setView:axis];
    [[axisController coordY] setInverted:YES];
    for (i=0; i<num; i++) {
        WSPlotController *ctl = [[WSPlotController alloc] init];
        [ctl setView:[barPlots objectAtIndex:i]];
        [ctl setDataD:[data objectAtIndex:i]];
        [[ctl coordY] setInverted:YES];
        [barControllers addObject:ctl];
       
    }
    
    // Add plot controllers.
    for (WSPlotController *ctl in barControllers) {
        [self addPlot:ctl];
    }
    [self addPlot:axisController];

    // Scale axis and adjust coordinate systems.
    [self autoscaleAllAxisX];
    [self autoscaleAllAxisY];
    [self setAllAxisLocationXD:[self dataRangeXD].rMin];
    [self setAllAxisLocationYD:[self dataRangeYD].rMin];

    
    // Configure the axis.
    [[axis ticksX] setMinorTicksNum:0];
    [[axis ticksY] setMinorTicksNum:1];
    [[axis ticksX] setTicksStyle:kTicksLabelsSlanted];
    [[axis ticksX] setTicksDir:kTDirectionOut];
    [[axis ticksY] setTicksStyle:kTicksLabelsSlanted];
    [[axis ticksY] setTicksDir:kTDirectionInOut];
    [axis setTicksXDAndLabelsWithData:[data objectAtIndex:0]];
    [[axis ticksY] autoTicksWithRange:[self dataRangeYD]
                               number:5];
    [[axis ticksY] setTickLabels];
    [[axis axisX] setAxisStyle:kAxisPlain];
    [[axis axisY] setAxisStyle:kAxisArrow];

    
    // Configure the color scheme.
    WSColorScheme *cs = [[WSColorScheme alloc] initWithScheme:colors];
    
    // Set colors for the axis.
    [[axis axisX] setLabelColor:[cs foreground]];
    [[axis axisY] setLabelColor:[cs foreground]];
    [axis setAxisColor:[cs foreground]];
    
    // Configure and set colors for the bar plot(s).
    NARange datRangeD = [self dataRangeXD];
    NARange datRange = NARangeMake([axisController boundsWithDataXD:datRangeD.rMin],
                                   [axisController boundsWithDataXD:datRangeD.rMax]);
    NAFloat barWidth = [self bounds].size.width / 2.0;
    NSUInteger colIndex = 0;
    NSArray *barCols = [cs highlightArray];
    for (WSPlotBar *bar in barPlots) {
        [bar setStyle:kCustomStyleUnified];
        NAFloat thisWidth = (NARangeLen(datRange) /
                             ([[[bar dataDelegate] dataD] count] * 2.0));
        barWidth = fmin(thisWidth, barWidth);
        WSBarProperties *defaults = [bar propDefault];
        [defaults setStyle:kBarFilled];
        [defaults setShadowEnabled:NO];
        [defaults setShadowColor:[cs shadow]];
        [defaults setOutlineColor:[cs spotlight]];
        [defaults setBarColor:[barCols objectAtIndex:colIndex]];
        colIndex++;
        if (colIndex == [barCols count]) {
            colIndex = 0;
        }
    }
    switch (style) {
        case kChartBarPlain:
            break;
        case kChartBarTouch:
            barWidth /= num;
            break;
        case kChartBarDisplaced:
            if (num > 1) {
                barWidth /= (num / 2);
            }
            break;
        default:
            break;
    }
    for (WSPlotBar *bar in barPlots) {
        [[bar propDefault] setBarWidth:barWidth];
    }
    if (num == 1) {
        [[[barPlots objectAtIndex:0] propDefault] setShadowEnabled:YES];
    }
    
    // Configure the bar controller(s) for alerting (optional).
    for (WSPlotBar *bar in barPlots) {
        WSBarProperties *defaults = (WSBarProperties *)[bar propDefault];
        [[bar plotController] setStandardProperties:defaults];
        [[bar plotController] setAlertedProperties:defaults];
        [((WSBarProperties *)[[bar plotController] alertedProperties])
         setBarColor:[cs alert]];
        [((WSBarProperties *)[[bar plotController] alertedProperties])
         setOutlineColor:[cs alertSecondary]];
    }

    // Correct Y-axis location based on bar width.
    NAFloat shift = fmax(2.0*[[axis ticksY] majorTicksLen], 1.5*barWidth);
    [self setAllAxisLocationX:([[axis axisDelegate] axisBoundsX] - shift)];
    [[axis axisDelegate] setAxisPreserveOnChangeX:kPreserveData];
    
    
    // Set own background color.
    [self setBackgroundColor:[cs background]];


    // Bar displacement.
    NAFloat displaced = 0.0;
    NAFloat current;
    switch (style) {
        case kChartBarPlain:
            break;
        case kChartBarTouch:
            for (i=0; i<num; i++) {
                current = [[[barControllers objectAtIndex:i] coordX] coordOrigin];
                [[[barControllers objectAtIndex:i] coordX] setCoordOrigin:(current + displaced)];
                displaced += barWidth;
            }
            break;
        case kChartBarDisplaced:
            for (i=0; i<num; i++) {
                current = [[[barControllers objectAtIndex:i] coordX] coordOrigin];
                [[[barControllers objectAtIndex:i] coordX] setCoordOrigin:(current + displaced)];
                displaced += barWidth / num;
            }
            break;
        default:
            break;
    }


    
}

@end
