///
///  @file
///  WSPlotDisc.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotDisc.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSDiscProperties.h"


@implementation WSPlotDisc

@synthesize style = _style;
@synthesize propDefault = _propDefault;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _propDefault = [[WSDiscProperties alloc] init];        
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
    [[self propDefault] setDiscStyle:kDiscPlotNone];
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
    
    // Plot the discs with the data from the data source delegate.
    if (([[[self dataDelegate] dataD] count] > 0) &&
        ([self style] != kCustomStyleNone)) {
        CGContextSaveGState(myContext);
        for (WSDatum *pointD in [[self dataDelegate] dataD]) {
            WSDiscProperties *propStyle = nil;
            switch ([self style]) {
                case kCustomStyleUnified:
                    propStyle = [self propDefault];
                    break;
                    
                case kCustomStyleIndividual:
                    propStyle = (WSDiscProperties *)[pointD customDatum];
                    break;
                    
                default:
                    break;
            }

            [[propStyle lineColor] set];
            [[propStyle fillColor] setFill];
            CGContextSetLineWidth(myContext, [propStyle lineWidth]);
            
            NAFloat centerXD = [pointD valueX];
            NAFloat centerYD = [pointD valueY];
            NAFloat errorXD = fmax([pointD errorMinX], [pointD errorMaxX]);
            NAFloat errorYD = fmax([pointD errorMinY], [pointD errorMaxY]);
            if ((errorXD == 0) || (errorYD == 0)) {
                continue;
            }
            NAFloat centerX = [[self coordDelegate] boundsWithDataXD:centerXD];
            NAFloat centerY = [[self coordDelegate] boundsWithDataYD:centerYD];
            CGRect embed = CGRectMake(([[self coordDelegate] boundsWithDataXD:(centerXD-errorXD)] -
                                       centerX),
                                      ([[self coordDelegate] boundsWithDataYD:(centerYD-errorYD)] -
                                       centerY),
                                      ([[self coordDelegate] boundsWithDataXD:(centerXD + errorXD)] -
                                       [[self coordDelegate] boundsWithDataXD:(centerXD - errorXD)]),
                                      ([[self coordDelegate] boundsWithDataYD:(centerYD + errorYD)] -
                                       [[self coordDelegate] boundsWithDataYD:(centerYD - errorYD)]));
            NAFloat angle = -[pointD errorCorr]*M_PI/4.0;
            CGContextRotateCTM(myContext, angle);
            CGContextTranslateCTM(myContext,
                                  (centerX*cos(angle) + centerY*sin(angle)),
                                  (centerY*cos(angle) - centerX*sin(angle)));
            CGContextAddEllipseInRect(myContext, embed);
            switch ([propStyle discStyle]) {
                case kDiscPlotNone:
                    break;
                    
                case kDiscPlotContour:
                    CGContextDrawPath(myContext, kCGPathFill);
                    break;
                    
                case kDiscPlotFilled:
                    CGContextDrawPath(myContext, kCGPathStroke);
                    break;
                    
                case kDiscPlotAll:
                    CGContextDrawPath(myContext, kCGPathFillStroke);
                    break;
                    
                default:
                    break;
            }
            CGContextTranslateCTM(myContext,
                                  -(centerX*cos(angle) + centerY*sin(angle)),
                                  -(centerY*cos(angle) - centerX*sin(angle)));
            CGContextRotateCTM(myContext, -angle);
        }
        CGContextRestoreGState(myContext);
    }
}

- (void)distributeDefaultPropertiesToAllCustomDatum {
    for (WSDatum *item in [[self dataDelegate] dataD]) {
        [item setCustomDatum:[self propDefault]];
    }
}




@end
