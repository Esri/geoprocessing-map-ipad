///
///  @file
///  WSPlotTemplate.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotTemplate.h"


@implementation WSPlotTemplate


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Paste your own initialization code here.
    }
    return self;
}

/*
 // Return YES if a subclass can plot (or otherwise handle) data.
 // Otherwise, WSPlot returns NO.
 - (BOOL)hasData {
     return YES;
 }
 */


#pragma mark - Plot handling

/*
 - (void)setAllDisplaysOff {
 // Override this method if a plots presents something on the canvas.
 // Reset the chart to use only no-display parameters in all customizable values.
 }
 */


/*
 // Override this method if a subclass plots something to provide a
 // sample. (E.g. something that is inserted in legends etc.)
 - (void)plotSample:(CGPoint)aPoint {
 // Drawing code
 }
 */


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
