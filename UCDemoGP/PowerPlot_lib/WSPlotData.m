///
///  @file
///  WSPlotData.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 26.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotData.h"
#import "WSDatum.h"
#import "WSData.h"
#import "WSBarProperties.h"
#import "WSDataPointProperties.h"


@implementation WSPlotData

@synthesize propDefault = _propDefault;
@synthesize style = _style;
@synthesize lineWidth = _lineWidth;
@synthesize lineColor = _lineColor;
@synthesize fillColor = _fillColor;
@synthesize lineStyle = _lineStyle;
@synthesize dashStyle = _dashStyle;
@synthesize intStyle = _intStyle;
@synthesize fillGradient = _fillGradient;

@synthesize shadowEnabled = _shadowEnabled;
@synthesize shadowScale = _shadowScale;
@synthesize shadowColor = _shadowColor;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // Setup reasonable default values.
        _propDefault = [[WSDataPointProperties alloc] init];
        _style = kCustomStyleUnified;
        _lineStyle = kLineRegular;
        _dashStyle = kDashingSolid;
        _intStyle = kInterpolationStraight;
        _lineWidth = kLineWidth;
        _lineColor = [UIColor blueColor] ;
        _fillColor = [UIColor grayColor] ;
        NAFloat locs[2];
        CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
        NSMutableArray *myColors = [NSMutableArray arrayWithCapacity:2];
        UIColor *aColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];
        [myColors addObject:(id)[aColor CGColor]];
        locs[0] = 0.0;
        aColor = [UIColor colorWithRed:0.7 green:0.85 blue:0.7 alpha:1.0];
        [myColors addObject:(id)[aColor CGColor]];
        locs[1] = 1.0;
        _fillGradient = CGGradientCreateWithColors(mySpace, (__bridge CFArrayRef)myColors, locs);
        CGColorSpaceRelease(mySpace);
        _shadowEnabled = NO;
        _shadowScale = kShadowScale;
        _shadowColor = [UIColor blackColor] ;
    }
    return self;
}

- (BOOL)hasData {
    // Return YES if a subclass can plot (or otherwise handle) data.
    return YES;
}


#pragma mark - Plot handling

- (void)setAllDisplaysOff {
    // Override this method if a plots presents something on the canvas.
    // Reset the chart to use only no-display parameters in all customizable values.
    [[self propDefault] setSymbolStyle:kSymbolNone];
    [[self propDefault] setErrorStyle:kErrorNone];
    [self setLineStyle:kLineNone];
    [self setIntStyle:kInterpolationStraight];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext;
    NAFloat centerX, centerY,
            errorMinX, errorMaxX, errorMinY, errorMaxY;
    NSInteger cpNum = 0;
    CGPoint *interpol1,
            *interpol2;
    WSDatum *extrPointD;
    

    // Order matters for x-values. 
    WSData *sortedD = [[[self dataDelegate] dataD] sortedDataUsingValueX];
      
    // Compute Bezier spline interpolation points if necessary.
    switch (self.intStyle) {
        case kInterpolationNone:
        case kInterpolationStraight:
            cpNum = 0;
            break;

        case kInterpolationSpline: {
            CGPoint *source;
            NSUInteger len = [sortedD count];
            
            source = (CGPoint *)malloc(len * sizeof(CGPoint));
            interpol1 = (CGPoint *)malloc(len * sizeof(CGPoint));
            interpol2 = (CGPoint *)malloc(len * sizeof(CGPoint));
            NSAssert(source != NULL, @"Severe allocation error!");
            NSAssert(interpol1 != NULL, @"Severe allocation error!");
            NSAssert(interpol2 != NULL, @"Severe allocation error!");
            for (NSUInteger i=0; i<len; i++) {
                source[i] = CGPointMake([[self coordDelegate]
                                         boundsWithDataXD:[[sortedD datumAtIndex:i]
                                                          valueX]], 
                                        [[self coordDelegate]
                                         boundsWithDataYD:[[sortedD datumAtIndex:i]
                                                          valueY]]);
            }
            cpNum = NABezierControlPoints(len, source, &interpol1, &interpol2);
            free(source);
        }
        
        default:
            break;
    }
    
    // First, draw the filling below the line connecting the data.
    myContext = UIGraphicsGetCurrentContext();
    [[self fillColor] set];
    if (([self lineStyle] == kLineFilledColor) ||
        ([self lineStyle] == kLineFilledGradient)) {
        // Close the line to draw a polygon that can be filled with
        // a color or a gradient.
        if ([sortedD count] > 0) {
            CGContextBeginPath(myContext);
            extrPointD = [sortedD rightMostDatum];
            centerX = [[self coordDelegate] boundsWithDataXD:[extrPointD valueX]];
            centerY = [[self coordDelegate] boundsWithDataYD:[extrPointD valueY]];
            NAFloat aLocY = [[self axisDelegate] axisBoundsY];
            CGContextMoveToPoint(myContext, centerX, centerY);
            CGContextAddLineToPoint(myContext,
                                    centerX,
                                    aLocY);
            extrPointD = [sortedD leftMostDatum];
            centerX = [[self coordDelegate] boundsWithDataXD:[extrPointD valueX]];
            centerY = [[self coordDelegate] boundsWithDataYD:[extrPointD valueY]];
            CGContextAddLineToPoint(myContext,
                                    centerX,
                                    aLocY);
            CGContextAddLineToPoint(myContext, centerX, centerY);
            WSDatum *pointD;
            for (NSUInteger i=1; i<[sortedD count]; i++) {
                pointD = [sortedD datumAtIndex:i];
                centerX = [[self coordDelegate] boundsWithDataXD:[pointD valueX]];
                centerY = [[self coordDelegate] boundsWithDataYD:[pointD value]];
                switch (self.intStyle) {
                    case kInterpolationNone:
                    case kInterpolationStraight:
                        CGContextAddLineToPoint(myContext, centerX, centerY);
                        break;
                        
                    case kInterpolationSpline:
                        CGContextAddCurveToPoint(myContext, 
                                                 interpol1[i-1].x, 
                                                 interpol1[i-1].y, 
                                                 interpol2[i-1].x, 
                                                 interpol2[i-1].y, 
                                                 centerX, 
                                                 centerY);
    
                    default:
                        break;
                }
            }
            switch ([self lineStyle]) {
                case kLineFilledColor:
                    CGContextDrawPath(myContext, kCGPathFillStroke);
                    break;            
                case kLineFilledGradient:
                    CGContextClip(myContext);
                    CGContextDrawLinearGradient(myContext,
                                                [self fillGradient],
                                                CGPointMake([self bounds].origin.x +
                                                            [self bounds].size.width/2,
                                                            [self bounds].origin.y),
                                                CGPointMake([self bounds].origin.x +
                                                            [self bounds].size.width/2,
                                                            [self bounds].origin.y +
                                                            [self bounds].size.height),
                                                0);
                    break;
                default:
                    break;
            }
        }
    }
    
    // Next, draw the line connecting the data itself.
    if ([self isShadowEnabled]) {
        NAFloat scale = [self shadowScale];
        CGContextSetShadowWithColor(myContext,
                                    CGSizeMake(scale, scale),
                                    scale,
                                    [[self shadowColor] CGColor]);
    } else {
        CGContextSetShadowWithColor(myContext, CGSizeMake(1, 1), 1, NULL);
    }
    if ([self lineStyle] != kLineNone) {
        // First, configure the path.
        [[self lineColor] set];
        CGContextSetLineWidth(myContext, [self lineWidth]);
        CGContextSetLineJoin(myContext, kCGLineJoinRound);
        NAContextSetLineDash(myContext, [self dashStyle]);

        // Draw the line connecting the data.
        CGContextBeginPath(myContext);
        if ([sortedD count] > 0) {
            centerX = [[self coordDelegate] boundsWithDataXD:[sortedD valueXAtIndex:0]];
            centerY = [[self coordDelegate] boundsWithDataYD:[sortedD valueAtIndex:0]];
            CGContextMoveToPoint(myContext, centerX, centerY);
        }
        WSDatum *pointD;
        for (NSUInteger i=1; i<[sortedD count]; i++) {
            pointD = [sortedD datumAtIndex:i];
            centerX = [[self coordDelegate] boundsWithDataXD:[pointD valueX]];
            centerY = [[self coordDelegate] boundsWithDataYD:[pointD value]];
            switch (self.intStyle) {
                case kInterpolationNone:
                case kInterpolationStraight:
                    CGContextAddLineToPoint(myContext, centerX, centerY);
                    break;
                    
                case kInterpolationSpline:
                    CGContextAddCurveToPoint(myContext, 
                                             interpol1[i-1].x, 
                                             interpol1[i-1].y, 
                                             interpol2[i-1].x, 
                                             interpol2[i-1].y, 
                                             centerX, 
                                             centerY);
                    
                default:
                    break;
            }
        }
        CGContextDrawPath(myContext, kCGPathStroke);
    }
   
    sortedD = nil;
    
    // Next, draw the error bars.
    NAContextSetLineDash(myContext, kDashingSolid);
    CGContextBeginPath(myContext);
    for (WSDatum *pointD in [[self dataDelegate] dataD]) {
        // Compute the central values and error bars in bounds coordinates.
        centerX = [[self coordDelegate] boundsWithDataXD:[pointD valueX]];
        centerY = [[self coordDelegate] boundsWithDataYD:[pointD value]];
        errorMinX = -1.0;
        errorMaxX = -1.0;
        errorMinY = -1.0;
        errorMaxY = -1.0;
        if ([pointD hasErrorX]) {
            // Note: By convention, if "errorMinX" exists, so will "errorMaxX".
            errorMinX = [[self coordDelegate] boundsWithDataXD:([pointD valueX] - [pointD errorMinX])];
            errorMaxX = [[self coordDelegate] boundsWithDataXD:([pointD valueX] + [pointD errorMaxX])];
        }
        if ([pointD hasErrorY]) {
            // Note: By convention, if "errorMinY" exists, so will "errorMaxY".
            errorMinY = [[self coordDelegate] boundsWithDataYD:([pointD value] - [pointD errorMinY])];
            errorMaxY = [[self coordDelegate] boundsWithDataYD:([pointD value] + [pointD errorMaxY])];
        }

        // Accumulate the different error bar features.
        WSErrorStyle errorStyle;
        NAFloat errorBarLen, errorBarWidth;
        UIColor *errorBarColor;
        WSDataPointProperties *customProperties = nil;

        switch ([self style]) {
            case kCustomStyleNone:
                errorStyle = kErrorNone;
                errorBarLen = 0.;
                errorBarWidth = 0.;
                errorBarColor = nil;
                break;
                
            case kCustomStyleUnified:
                errorStyle = [[self propDefault] errorStyle];
                errorBarLen = [[self propDefault] errorBarLen];
                errorBarWidth = [[self propDefault] errorBarWidth];
                errorBarColor = [[self propDefault] errorBarColor];
                break;
                
            case kCustomStyleIndividual:
                customProperties = (WSDataPointProperties *)[pointD customDatum];
                errorStyle = [customProperties errorStyle];
                errorBarLen = [customProperties errorBarLen];
                errorBarWidth = [customProperties errorBarWidth];
                errorBarColor = [customProperties errorBarColor];
                break;
                
            default:
                break;
        }
        [errorBarColor set];
        CGContextSetLineWidth(myContext, errorBarWidth);

        switch (errorStyle) {
            case kErrorNone:
                break;
            case kErrorXYCapped:
                // This draws the caps for X error bars.
                if (errorMinX > 0) {
                    CGContextMoveToPoint(myContext, errorMinX, centerY-errorBarLen);
                    CGContextAddLineToPoint(myContext, errorMinX, centerY+errorBarLen);
                    CGContextMoveToPoint(myContext, errorMaxX, centerY-errorBarLen);
                    CGContextAddLineToPoint(myContext, errorMaxX, centerY+errorBarLen);
                }
            case kErrorYCapped:
                // This draws the caps for the Y error bars.
                if (errorMinY > 0) {
                    CGContextMoveToPoint(myContext, centerX-errorBarLen, errorMinY);
                    CGContextAddLineToPoint(myContext, centerX+errorBarLen, errorMinY);
                    CGContextMoveToPoint(myContext, centerX-errorBarLen, errorMaxY);
                    CGContextAddLineToPoint(myContext, centerX+errorBarLen, errorMaxY);
                }
            case kErrorXYFlat:
                // This draws the X error bar.
                if (errorMinX > 0) {
                    CGContextMoveToPoint(myContext, errorMinX, centerY);
                    CGContextAddLineToPoint(myContext, errorMaxX, centerY);
                }
            case kErrorYFlat:
                // This draws the Y error bar.
                if (errorMinY > 0) {
                    CGContextMoveToPoint(myContext, centerX, errorMinY);
                    CGContextAddLineToPoint(myContext, centerX, errorMaxY);
                }
            default:
                break;
        }
    }
    CGContextDrawPath(myContext, kCGPathStroke);

    // Finally, draw the symbols at the data points.
    for (WSDatum *pointD in [[self dataDelegate] dataD]) {
        UIColor *symbolColor = nil;
        NASymbolStyle symbolStyle = kSymbolNone;
        NAFloat symbolSize = 0.;
        WSDataPointProperties *customProperties = nil;
        
        switch ([self style]) {
            case kCustomStyleNone:
                break;
                
            case kCustomStyleUnified:
                symbolStyle = [[self propDefault] symbolStyle];
                symbolSize = [[self propDefault] symbolSize];
                symbolColor = [[self propDefault] symbolColor];
                break;
                
            case kCustomStyleIndividual:
                customProperties = (WSDataPointProperties *)[pointD customDatum];
                symbolStyle = [customProperties symbolStyle];
                symbolSize = [customProperties symbolSize];
                symbolColor = [customProperties symbolColor];
                break;
                
            default:
                break;
        }
        [symbolColor set];
        centerX = [[self coordDelegate] boundsWithDataXD:[pointD valueX]];
        centerY = [[self coordDelegate] boundsWithDataYD:[pointD value]];
        NAContextAddSymbol(myContext,
                           symbolStyle,
                           CGPointMake(centerX, centerY),
                           symbolSize);
    }
    
    // Free interpolation if needed.
    if (cpNum > 0) {
        free(interpol1);
        free(interpol2);
    }
}

- (void)distributeDefaultPropertiesToAllCustomDatum {
    for (WSDatum *item in [[self dataDelegate] dataD]) {
        [item setCustomDatum:[[self propDefault] copy] ];
    }
}
    

#pragma mark - Plot configuration

- (void)setFillGradientFromColor:(UIColor *)color1
                         toColor:(UIColor *)color2 {
    NAFloat locs[2];
    CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *myColors = [NSMutableArray arrayWithCapacity:2];

    CGGradientRelease(_fillGradient);
    [myColors addObject:(id)[color1 CGColor]];
    locs[0] = 0.0;
    [myColors addObject:(id)[color2 CGColor]];
    locs[1] = 1.0;
    _fillGradient = CGGradientCreateWithColors(mySpace, (__bridge CFArrayRef)myColors, locs);
    CGColorSpaceRelease(mySpace);
}




@end
