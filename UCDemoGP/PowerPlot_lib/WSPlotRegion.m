///
///  @file
///  WSPlotRegion.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotRegion.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSCoordinateDelegate.h"
#import "WSDataDelegate.h"


@implementation WSPlotRegion

@synthesize lineWidth = _lineWidth;
@synthesize dashStyle = _dashStyle;
@synthesize lineColor = _lineColor;
@synthesize fillColor = _fillColor;
@synthesize style = _style;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // Setup reasonable default values.
        _lineWidth = 1.0;
        _dashStyle = kDashingSolid;
        _lineColor = [UIColor blackColor] ;
        _fillColor = [UIColor blueColor] ;
        _style = kRegionPlotAll;
    }
    return self;
}


// Return YES if a subclass can plot (or otherwise handle) data.
// Otherwise, WSPlot returns NO.
- (BOOL)hasData {
    return YES;
}


#pragma mark - Plot handling

- (void)setAllDisplaysOff {
    // Override this method if a plots presents something on the canvas.
    // Reset the chart to use only no-display parameters in all customizable values.
    [self setStyle:kRegionPlotNone];
}


/*
 // Override this method if a subclass plots something to provide a
 // sample. (E.g. something that is inserted in legends etc.)
 - (void)plotSample:(CGPoint)aPoint {
 // Drawing code
 }
 */


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    // Plot a curve with the data from the data source delegate.
    if (([[[self dataDelegate] dataD] count] > 0) &&
        ([self style] != kRegionPlotNone)) {
        WSDatum *pointD = [[[self dataDelegate] dataD] datumAtIndex:0];
        CGContextMoveToPoint(myContext, 
                             [[self coordDelegate] boundsWithDataXD:[pointD valueX]], 
                             [[self coordDelegate] boundsWithDataYD:[pointD value]]);
        for (WSDatum *aPointD in [[self dataDelegate] dataD]) {
            CGContextAddLineToPoint(myContext,
                                    [[self coordDelegate] boundsWithDataXD:[aPointD valueX]],
                                    [[self coordDelegate] boundsWithDataYD:[aPointD value]]);
        }
        CGContextClosePath(myContext);
        CGContextSetLineWidth(myContext, [self lineWidth]);
        [[self lineColor] set];
        [[self fillColor] setFill];
        CGContextDrawPath(myContext, kCGPathFillStroke);
    }
}




@end
