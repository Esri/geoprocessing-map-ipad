///
///  @file
///  WSPlotBar.m
///  WSplot
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotBar.h"
#import "WSBarProperties.h"
#import "WSData.h"
#import "WSDatum.h"


@implementation WSPlotBar

@synthesize style = _style;
@synthesize propDefault = _propDefault;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _style = kCustomStyleUnified;
        _propDefault = [[WSBarProperties alloc] init];
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
    [self setStyle:kCustomStyleNone];
    [(WSBarProperties *)[self propDefault] setStyle:kBarNone];
}

/*
 // Override this method if a subclass plots something to provide a
 // sample. (E.g. something that is inserted in legends etc.)
 - (void)plotSample:(CGPoint)aPoint {
 // Drawing code
 }
 */

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    WSBarProperties *current = (WSBarProperties *)[self propDefault];
    NAFloat centerX, topY;
    NAFloat aLocY;
    NAFloat locs[2];
    locs[0] = 0.0;
    locs[1] = 1.0;

    
    if ([self style] == kCustomStyleNone) {
        return;
    }

    // Set the axis location.
    aLocY = [[self axisDelegate] axisBoundsY];

    // Remove previous labels (if any).
    for (UIView* label in [self subviews]) {
        [label removeFromSuperview];
    }
    
    // Loop over all data points.
    for (WSDatum *item in [[self dataDelegate] dataD]) {
        centerX = [[self coordDelegate] boundsWithDataXD:[item valueX]];
        topY = [[self coordDelegate] boundsWithDataYD:[item valueY]];
        switch ([self style]) {
            case kCustomStyleNone:
            case kCustomStyleUnified:
                break;
            case kCustomStyleIndividual:
                if ([[item customDatum] isKindOfClass:[WSBarProperties class]]) {
                    current = (WSBarProperties *)[item customDatum];
                } else {
                    current = (WSBarProperties *)[self propDefault];
                }
                break;
            default:
                break;
        }
        
        // Draw the bar solid/gradient fill (if needed).
        switch ([current style]) {
            case kBarOutline:
                break;
            case kBarFilled:
                if ([current isShadowEnabled]) {
                    NAFloat scale = [current shadowScale];
                    CGContextSetShadowWithColor(myContext,
                                                CGSizeMake(scale, scale),
                                                scale,
                                                [[current shadowColor] CGColor]);
                } else {
                    CGContextSetShadowWithColor(myContext,
                                                CGSizeMake(1, 1),
                                                1,
                                                NULL);
                }
                CGContextBeginPath(myContext);
                [[current barColor] set];
                CGContextSetLineWidth(myContext, [current outlineStroke]);
                CGContextMoveToPoint(myContext,
                                     centerX - ([current barWidth]/2.0),
                                     aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        topY);
                CGContextAddLineToPoint(myContext, 
                                        centerX + ([current barWidth]/2.0), 
                                        topY);
                CGContextAddLineToPoint(myContext,
                                        centerX + ([current barWidth]/2.0),
                                        aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        aLocY);
                CGContextDrawPath(myContext, kCGPathFill);
                CGContextSetShadowWithColor(myContext,
                                            CGSizeMake(1, 1),
                                            1,
                                            NULL);
                break;
            case kBarGradient:
                CGContextSaveGState(myContext);
                CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
                NSMutableArray *myColors = [NSMutableArray arrayWithCapacity:2];
                [myColors addObject:(id)[[current barColor] CGColor]];
                [myColors addObject:(id)[[current barColor2] CGColor]];
                CGGradientRef fillGradient = CGGradientCreateWithColors(mySpace,
                                                                        (__bridge_retained CFArrayRef)myColors,
                                                                        locs);
                CGContextBeginPath(myContext);
                CGContextSetLineWidth(myContext, [current outlineStroke]);
                CGContextMoveToPoint(myContext,
                                     centerX - ([current barWidth]/2.0),
                                     aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        topY);
                CGContextAddLineToPoint(myContext, 
                                        centerX + ([current barWidth]/2.0), 
                                        topY);
                CGContextAddLineToPoint(myContext,
                                        centerX + ([current barWidth]/2.0),
                                        aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        aLocY);
                CGContextClip(myContext);
                CGContextDrawLinearGradient(myContext,
                                            fillGradient,
                                            CGPointMake([self bounds].origin.x +
                                                        [self bounds].size.width/2,
                                                        [self bounds].origin.y),
                                            CGPointMake([self bounds].origin.x +
                                                        [self bounds].size.width/2,
                                                        [self bounds].origin.y +
                                                        [self bounds].size.height),
                                            0);   
                CGGradientRelease(fillGradient);   
                CGColorSpaceRelease(mySpace);
                CGContextRestoreGState(myContext);
                break;
           
        }
        
        // Draw the bar outline.
        CGContextBeginPath(myContext);
        [[current outlineColor] set];
        CGContextSetLineWidth(myContext, [current outlineStroke]);
        CGContextMoveToPoint(myContext,
                             centerX - ([current barWidth]/2.0),
                             aLocY);
        CGContextAddLineToPoint(myContext,
                                centerX - ([current barWidth]/2.0),
                                topY);
        CGContextAddLineToPoint(myContext, 
                                centerX + ([current barWidth]/2.0), 
                                topY);
        CGContextAddLineToPoint(myContext,
                                centerX + ([current barWidth]/2.0),
                                aLocY);
        CGContextDrawPath(myContext, kCGPathStroke);
    }
}

- (void)distributeDefaultPropertiesToAllCustomDatum {
    for (WSDatum *item in [[self dataDelegate] dataD]) {
        [item setCustomDatum:[[self propDefault] copy] ];
    }
}


#pragma mark - Bars configuration

- (BOOL)isDistanceConsistent {
    NSUInteger i;
    NAFloat distD;
    WSData *dataD = [[self dataDelegate] dataD];
    
    if ([dataD count] > 2) {
        distD = ([dataD valueXAtIndex:1] -
                 [dataD valueXAtIndex:0]);
        for (i=0; i<([dataD count] - 1); i++) {
            NAFloat thisDistD = ([dataD valueXAtIndex:i+1] -
                                 [dataD valueXAtIndex:i]);
            if (!(IS_EPSILON((distD - thisDistD)/distD))) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)widthTouchingBars {
    NAFloat dist;
    
    if ([self isDistanceConsistent]) {
        if ([[[self dataDelegate] dataD] count] > 1) {
            dist = ([[self coordDelegate] boundsWithDataXD:[[[self dataDelegate] dataD] valueXAtIndex:1]] -
                    [[self coordDelegate] boundsWithDataXD:[[[self dataDelegate] dataD] valueXAtIndex:0]]);
        }
        else {
            dist = [self bounds].size.width / 2.0;
        }
        [(WSBarProperties *)[self propDefault] setBarWidth:(dist / 2.0)];
    }
}



@end
