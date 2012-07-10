///
///  @file
///  WSPlotController.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 06.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotController.h"
#import "WSCoordinate.h"
#import "WSCoordinateDelegate.h"
#import "WSDataDelegate.h"
#import "WSPlot.h"
#import "WSData.h"
#import "WSDataOperations.h"
#import "WSDatum.h"


/** Configuration of default axis orgin (in bounds coordinates). */
#define kALocationX 70.0
#define kALocationY 80.0

/// Manual KVO notifications for the 'dataD.values' property.
#define KVO_VALUES @"values"

@interface WSPlotController ()

/** Scroll in response to a pan gesture. */
- (void)handlePan:(UIPanGestureRecognizer *)sender;

/** Zoom in response to a pinch gesture. */
- (void)handlePinch:(UIPinchGestureRecognizer *)sender;

/** Handle a single tap. */
- (void)handleTap:(UITapGestureRecognizer *)sender;

@end

@implementation WSPlotController

@synthesize dataD = _dataD;

@synthesize view = _view;
@synthesize axisLocationX = _axisLocationX;
@synthesize axisLocationY = _axisLocationY;
@synthesize coordX = _coordX;
@synthesize coordY = _coordY;
@synthesize scrollEnabled = _scrollEnabled;
@synthesize zoomEnabled = _zoomEnabled;
@synthesize tapEnabled = _tapEnabled;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize pinchGestureRecognizer = _pinchGestureRecognizer;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize scrollRangeXD = _scrollRangeXD;
@synthesize scrollRangeYD = _scrollRangeYD;
@synthesize zoomRangeXD = _zoomRangeXD;
@synthesize zoomRangeYD = _zoomRangeYD;
@synthesize hitTestMethod = _hitTestMethod;
@synthesize hitResponseMethod = _hitResponseMethod;
@synthesize delegate = _delegate;
@synthesize bindingsEnabled = _bindingsEnabled;


- (id)init {
    self = [super init];
    if (self) {
        _coordX = [[WSCoordinate alloc] init];
        _coordY = [[WSCoordinate alloc] init];
        _dataD = [[WSData alloc] init];
        _axisLocationX = [[WSAxisLocation alloc] init];
        _axisLocationY = [[WSAxisLocation alloc] init];

        [_coordX setDirect:kCoordinateDirectionX];
        [_coordY setDirect:kCoordinateDirectionY];
        [_axisLocationX setDirect:kCoordinateDirectionX];
        [_axisLocationY setDirect:kCoordinateDirectionY];
        [_axisLocationX setCoordDelegate:self];
        [_axisLocationY setCoordDelegate:self];
        [_axisLocationX setBounds:kALocationX];
        [_axisLocationY setBounds:kALocationY];
        [[self coordY] setInverted:YES];
        
        _scrollEnabled = NO;
        _zoomEnabled = NO;
        _tapEnabled = NO;
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handlePan:)];
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(handlePinch:)];
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleTap:)];
        [_panGestureRecognizer setDelegate:self];
        [_pinchGestureRecognizer setDelegate:self];
        [_panGestureRecognizer setMinimumNumberOfTouches:1];
        [_tapGestureRecognizer setNumberOfTapsRequired:1];
        [_tapGestureRecognizer setNumberOfTouchesRequired:1];
        [_tapGestureRecognizer requireGestureRecognizerToFail:_panGestureRecognizer];
        [_tapGestureRecognizer requireGestureRecognizerToFail:_pinchGestureRecognizer];
        [_panGestureRecognizer setEnabled:NO];
        [_pinchGestureRecognizer setEnabled:NO];
        [_tapGestureRecognizer setEnabled:NO];
        
        _scrollRangeXD = NARANGE_INVALID;
        _scrollRangeYD = NARANGE_INVALID;
        _zoomRangeXD = NARANGE_INVALID;
        _zoomRangeYD = NARANGE_INVALID;
        
        _delegate = nil;
        
        _bindingsEnabled = NO;
    }
    return self;
}

- (void)setView:(id)aPlot {
    [aPlot setAxisDelegate:self];
    [aPlot setCoordDelegate:self];
    [aPlot setDataDelegate:self];
    [aPlot setPlotController:self];
    [_view setPlotController:nil];
    [_view removeGestureRecognizer:_panGestureRecognizer];
    [_view removeGestureRecognizer:_pinchGestureRecognizer];
    [_view removeGestureRecognizer:_tapGestureRecognizer];
    
    _view = aPlot;
    if ([_view hasData]) {
        [_view addGestureRecognizer:_panGestureRecognizer];
        [_view addGestureRecognizer:_pinchGestureRecognizer];
        [_view addGestureRecognizer:_tapGestureRecognizer];
        [_view setUserInteractionEnabled:YES];
    } else {
        [_view setUserInteractionEnabled:NO];
    }
}

- (void)setAxisLocationX:(WSAxisLocation *)axisLocation {
    [axisLocation setCoordDelegate:self];
    [_axisLocationX setCoordDelegate:nil];
    
    _axisLocationX = axisLocation ;
}

- (void)setAxisLocationY:(WSAxisLocation *)axisLocation {
    [axisLocation setCoordDelegate:self];
    [_axisLocationY setCoordDelegate:nil];
  
    _axisLocationY = axisLocation;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    [_panGestureRecognizer setEnabled:scrollEnabled];
}

- (void)setZoomEnabled:(BOOL)zoomEnabled {
    [_pinchGestureRecognizer setEnabled:zoomEnabled];
}

- (void)setTapEnabled:(BOOL)tapEnabled {
    [_tapGestureRecognizer setEnabled:tapEnabled];
}

- (void)setMaximumZoomScaleXD:(NAFloat)maxZoomXD
           maximumZoomScaleYD:(NAFloat)maxZoomYD
           minimumZoomScaleXD:(NAFloat)minZoomXD
           minimumZoomScaleYD:(NAFloat)minZoomYD {
    NSAssert(maxZoomXD >= 1.0, @"maxZoomXD out of range");
    NSAssert(maxZoomYD >= 1.0, @"maxZoomYD out of range");
    NSAssert(minZoomXD <= 1.0, @"minZoomXD out of range");
    NSAssert(minZoomYD <= 1.0, @"minZoomYD out of range");
    
    NAFloat cxrmin = [self boundsWithDataXD:[[self coordX] coordRangeD].rMin];
    NAFloat cxrmax = [self boundsWithDataXD:[[self coordX] coordRangeD].rMax];
    NAFloat cyrmin = [self boundsWithDataYD:[[self coordY] coordRangeD].rMin];
    NAFloat cyrmax = [self boundsWithDataYD:[[self coordY] coordRangeD].rMax];
    NAFloat centerx = (cxrmin + cxrmax) / 2;
    NAFloat centery = (cyrmin + cyrmax) / 2;
    NAFloat newrxMax = (cxrmax - cxrmin) / 2 / minZoomXD;
    NAFloat newryMax = (cyrmax - cyrmin) / 2 / minZoomYD;
    NAFloat newrxMin = (cxrmax - cxrmin) / 2 / maxZoomXD;
    NAFloat newryMin = (cyrmax - cyrmin) / 2 / maxZoomYD;

    [self setScrollRangeXD:NARangeMake([self dataWithBoundsX:(centerx - newrxMax)],
                                       [self dataWithBoundsX:(centerx + newrxMax)])];
    [self setScrollRangeYD:NARangeMake([self dataWithBoundsY:(centery - newryMax)],
                                       [self dataWithBoundsY:(centery + newryMax)])];
    [self setZoomRangeXD:NARangeMake(([self dataWithBoundsX:(centerx + newrxMin)] -
                                      [self dataWithBoundsX:(centerx - newrxMin)]),
                                     ([self dataWithBoundsX:(centerx + newrxMax)] -
                                      [self dataWithBoundsX:(centerx - newrxMax)]))];
    [self setZoomRangeYD:NARangeMake(([self dataWithBoundsY:(centery + newryMin)] -
                                      [self dataWithBoundsY:(centery - newryMin)]),
                                     ([self dataWithBoundsY:(centery + newryMax)] -
                                      [self dataWithBoundsY:(centery - newryMax)]))];
}


#pragma mark -

- (void)setBindingsEnabled:(BOOL)bindings {
    if (bindings == _bindingsEnabled) {
        return;
    } else {
        _bindingsEnabled = bindings;
        
        if (bindings == YES) {
            [[self dataD] addObserver:self
                           forKeyPath:KVO_VALUES
                              options:0
                              context:NULL];
        } else {
            [[self dataD] removeObserver:self
                              forKeyPath:KVO_VALUES
                                 context:NULL];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self dataDidUpdate];
}


#pragma mark - UIGestureRecognizerDelegate.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (((gestureRecognizer == _panGestureRecognizer) &&
         (otherGestureRecognizer == _pinchGestureRecognizer)) ||
        ((gestureRecognizer == _pinchGestureRecognizer) &&
         (otherGestureRecognizer == _panGestureRecognizer))) {
        return YES;
    }
    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint panTranslation = [sender translationInView:[self view]];

    // @note This code assumes a linear coordinate transformation!
    NAFloat cxrmin = [self boundsWithDataXD:[[self coordX] coordRangeD].rMin] - panTranslation.x;
    NAFloat cxrmax = [self boundsWithDataXD:[[self coordX] coordRangeD].rMax] - panTranslation.x;
    NAFloat cyrmin = [self boundsWithDataYD:[[self coordY] coordRangeD].rMin] - panTranslation.y;
    NAFloat cyrmax = [self boundsWithDataYD:[[self coordY] coordRangeD].rMax] - panTranslation.y;
    NAFloat newxminD = [self dataWithBoundsX:cxrmin];
    NAFloat newxmaxD = [self dataWithBoundsX:cxrmax];
    NAFloat newyminD = [self dataWithBoundsY:cyrmin];
    NAFloat newymaxD = [self dataWithBoundsY:cyrmax];
    
    // Check and (if necessary) correct the scrolling ranges.
    if ((newxminD >= [self scrollRangeXD].rMin) &&
        (newxmaxD <= [self scrollRangeXD].rMax)) {
        [[self coordX] setCoordRangeD:NARangeMake(newxminD, newxmaxD)];
        [[self view] chartSetNeedsDisplay];
    }
    if ((newyminD >= [self scrollRangeYD].rMin) &&
        (newymaxD <= [self scrollRangeYD].rMax)) {
        [[self coordY] setCoordRangeD:NARangeMake(newyminD, newymaxD)];    
        [[self view] chartSetNeedsDisplay];
    }

    [sender setTranslation:CGPointMake(0., 0.)
                    inView:[self view]];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender {
    NAFloat scale = [sender scale];
    CGPoint location = [sender locationInView:[self view]];
    
    // @note This code assumes a linear coordinate transformation!
    NAFloat cxrmin = [self boundsWithDataXD:[[self coordX] coordRangeD].rMin];
    NAFloat cxrmax = [self boundsWithDataXD:[[self coordX] coordRangeD].rMax];
    NAFloat cyrmin = [self boundsWithDataYD:[[self coordY] coordRangeD].rMin];
    NAFloat cyrmax = [self boundsWithDataYD:[[self coordY] coordRangeD].rMax];
    NAFloat newxmin = location.x - (location.x - cxrmin) / scale;
    NAFloat newxmax = location.x + (cxrmax - location.x) / scale;
    NAFloat newymin = location.y - (location.y - cyrmin) / scale;
    NAFloat newymax = location.y + (cyrmax - location.y) / scale;
    NAFloat newxminD = [self dataWithBoundsX:newxmin];
    NAFloat newxmaxD = [self dataWithBoundsX:newxmax];
    NAFloat newyminD = [self dataWithBoundsY:newymin];
    NAFloat newymaxD = [self dataWithBoundsY:newymax];

    // Check the zooming and scrolling ranges.
    if (((newxmaxD - newxminD) <= [self zoomRangeXD].rMax) &&
        ((newymaxD - newyminD) <= [self zoomRangeYD].rMax) &&
        ((newxmaxD - newxminD) >= [self zoomRangeXD].rMin) && 
        ((newymaxD - newyminD) >= [self zoomRangeYD].rMin) &&
        (newxminD >= [self scrollRangeXD].rMin) &&
        (newxmaxD <= [self scrollRangeXD].rMax)) {
        // Adjust the scaling.
        [[self coordX] setCoordRangeD:NARangeMake(newxminD, newxmaxD)];
        [[self coordY] setCoordRangeD:NARangeMake(newyminD, newymaxD)];
        [[self view] chartSetNeedsDisplay];
    }

    [sender setScale:1];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    CGPoint tapLocation = [sender locationInView:[self view]];
    
    if (([self hitResponseMethod] == kHitResponseNone) ||
        (![[self view] hasData])) {
        return;
    }
    
    if ([self hitResponseMethod] == kHitResponseLocationBounds) {
        if ([[self delegate]
             respondsToSelector:@selector(controller:singleTapAtPointD:)]) {
            [[self delegate] controller:self
                      singleTapAtPointD:tapLocation];
        }
        return;
    }
    
    CGPoint tapLocationD = CGPointMake([self dataWithBoundsX:tapLocation.x], 
                                       [self dataWithBoundsY:tapLocation.y]);
    if ([self hitResponseMethod] == kHitResponseLocationData) {
        if ([[self delegate]
             respondsToSelector:@selector(controller:singleTapAtPoint:)]) {
            [[self delegate] controller:self
                       singleTapAtPoint:tapLocationD];
        }
        return;
    }
    
    NSInteger result = -1;
    NAFloat maxDistance = INFINITY;
    if (([self hitTestMethod] & kHitTestWithRange) &&
        ([[self delegate] respondsToSelector:@selector(singleTapRange)])) {
        maxDistance = [[self delegate] singleTapRange];
    }
    if ([self hitTestMethod] & kHitTestX) {
        if ([self hitTestMethod] & kHitTestY) {
            result = [[self dataD] datumClosestToLocation:tapLocationD
                                          maximumDistance:maxDistance];
        } else {
            result = [[self dataD] datumClosestToValueX:tapLocationD.x
                                        maximumDistance:maxDistance];
        }
    } else {
        if ([self hitTestMethod] & kHitTestY) {
            result = [[self dataD] datumClosestToValueY:tapLocationD.y
                                        maximumDistance:maxDistance];
        }
    }
    
    if ([[self delegate]
         respondsToSelector:@selector(controller:singleTapAtDatum:)]) {
        [[self delegate] controller:self
                   singleTapAtDatum:result];
    }
}


#pragma mark - WSCoordinateDelegate

- (NAFloat)boundsWithDataD:(NAFloat)aDatumD
                 direction:(WSCoordinateDirection)direction {
    switch (direction) {
        case kCoordinateDirectionX:
            return [self boundsWithDataXD:aDatumD];
            break;
            
        case kCoordinateDirectionY:
            return [self boundsWithDataYD:aDatumD];
            break;
            
        default:
            return NAN;
            break;
    }
}

- (NAFloat)dataWithBounds:(NAFloat)aDatum
                direction:(WSCoordinateDirection)direction {
    switch (direction) {
        case kCoordinateDirectionX:
            return [self dataWithBoundsX:aDatum];
            break;
            
        case kCoordinateDirectionY:
            return [self dataWithBoundsY:aDatum];
            break;
            
        default:
            return NAN;
            break;
    }
}

- (NAFloat)boundsSizeForDirection:(WSCoordinateDirection)direction {
    switch (direction) {
        case kCoordinateDirectionX:
            return [self viewBounds].size.width;
            break;
            
        case kCoordinateDirectionY:
            return [self viewBounds].size.height;
            break;
            
        default:
            return NAN;
            break;
    }
}

- (NAFloat)boundsOffsetForDirection:(WSCoordinateDirection)direction {
    switch (direction) {
        case kCoordinateDirectionX:
            return [self viewBounds].origin.x;
            break;
            
        case kCoordinateDirectionY:
            return [self viewBounds].origin.y;
            break;
            
        default:
            return NAN;
            break;
    }
}


#pragma mark - WSAxisLocationDelegate

- (NAFloat)axisBoundsX {
    return [[self axisLocationX] bounds];
}

- (NAFloat)axisBoundsY {
    return [[self axisLocationY] bounds];
}

- (NAFloat)axisDataXD {
    return [[self axisLocationX] dataD];
}

- (NAFloat)axisDataYD {
    return [[self axisLocationY] dataD];
}

- (NAFloat)axisRelativeX {
    return [[self axisLocationX] relative];
}

- (NAFloat)axisRelativeY {
    return [[self axisLocationY] relative];
}

- (void)setAxisBoundsX:(CGFloat)axisBounds {
    [[self axisLocationX] setBounds:axisBounds];
}

- (void)setAxisBoundsY:(CGFloat)axisBounds {
    [[self axisLocationY] setBounds:axisBounds];
}

- (void)setAxisDataXD:(CGFloat)axisDataD {
    [[self axisLocationX] setDataD:axisDataD];
}

- (void)setAxisDataYD:(CGFloat)axisDataD {
    [[self axisLocationY] setDataD:axisDataD];
}

- (void)setAxisRelativeX:(CGFloat)axisRelative {
    [[self axisLocationX] setRelative:axisRelative];
}

- (void)setAxisRelativeY:(CGFloat)axisRelative {
    [[self axisLocationY] setRelative:axisRelative];
}

- (WSAxisLocationPreservationStyle)axisPreserveOnChangeX {
    return [[self axisLocationX] preserveOnChange];
}

- (WSAxisLocationPreservationStyle)axisPreserveOnChangeY {
    return [[self axisLocationY] preserveOnChange];
}

- (void)setAxisPreserveOnChangeX:(WSAxisLocationPreservationStyle)axisPreserveOnChange {
    [[self axisLocationX] setPreserveOnChange:axisPreserveOnChange];
}

- (void)setAxisPreserveOnChangeY:(WSAxisLocationPreservationStyle)axisPreserveOnChange {
    [[self axisLocationY] setPreserveOnChange:axisPreserveOnChange];
}


#pragma mark - WSCoordinateDelegate

- (CGRect)viewBounds {
    return [[self view] bounds];
}

- (NARange)rangeXD {
    return [[self coordX] coordRangeD];
}

- (NARange)rangeYD {
    return [[self coordY] coordRangeD];
}

- (void)setRangeXD:(NARange)rangeXD {
    [[self coordX] setCoordRangeD:rangeXD];    
}

- (void)setRangeYD:(NARange)rangeYD {
    [[self coordY] setCoordRangeD:rangeYD];    
}

- (void)setCoordinateScaleX:(WSCoordinateScale)scaleX
                     scaleY:(WSCoordinateScale)scaleY {
    [[self coordX] setCoordScale:scaleX];
    [[self coordY] setCoordScale:scaleY];
}

- (BOOL)invertedX {
    return [[self coordX] inverted];
}

- (BOOL)invertedY {
    return [[self coordY] inverted];
}


- (CGFloat)boundsWithDataXD:(CGFloat)aDatumD {
    return [[self coordX] transformData:aDatumD
                                   size:[[self view] bounds].size.width];
}

- (CGFloat)boundsWithDataYD:(CGFloat)aDatumD {
    return [[self coordY] transformData:aDatumD
                                   size:[[self view] bounds].size.height];    
}

- (NAFloat)dataWithBoundsX:(NAFloat)aDatum {
    return [[self coordX] transformBounds:aDatum
                                     size:[[self view] bounds].size.width];
}

- (NAFloat)dataWithBoundsY:(NAFloat)aDatum {
    return [[self coordY] transformBounds:aDatum
                                     size:[[self view] bounds].size.height];
}


#pragma mark - WSDataDelegate

- (NARange)dataRangeXD {
    if ([[self view] hasData])
        return NARangeMake([[self dataD] minimumValueX],
                           [[self dataD] maximumValueX]);
    else
        return NARANGE_INVALID;
}

- (NARange)dataRangeYD {
    if ([[self view] hasData])
        return NARangeMake([[self dataD] minimumValue],
                           [[self dataD] maximumValue]);
    else
        return NARANGE_INVALID;
}

- (void)dataDidUpdate {
#ifdef __IPHONE_4_0
    if ([self alertBlock] != nil) {
        [self updateAlertedData];
    }
#endif ///__IPHONE_4_0
    if ([[self view] respondsToSelector:@selector(chartSetNeedsDisplay)]) {
        [[self view] chartSetNeedsDisplay];
    }
}

- (void)setDataD:(WSData *)dataD {
   
    _dataD = dataD;
    if ([self isBindingsEnabled]) {
        [self dataDidUpdate];
    }
}


#pragma mark -

#ifdef __IPHONE_4_0
@synthesize alertBlock = _alertBlock;
@synthesize standardProperties = _standardProperties;
@synthesize alertedProperties = _alertedProperties;

- (void)updateAlertedData {
    if ([self alertBlock] == nil) {
        return ;
    }
    for (WSDatum *datum in [self dataD]) {
        if ([self alertBlock](datum)) {
            [datum setCustomDatum:(id <NSCoding, NSCopying, NSObject>)[self alertedProperties]];
        } else {
            [datum setCustomDatum:(id <NSCoding, NSCopying, NSObject>)[self standardProperties]];
        }
    }
}
#endif ///__IPHONE_4_0


#pragma mark -

- (NSString *)description {
    return [NSString
            stringWithFormat:@"%@<%@>, coordX: (%@), "
                @"coordY: (%@), data set: (%@)",
            [self class],
            [[self view] class],
            [[self coordX] description],
            [[self coordY] description],
            [[self dataD] description]];
}


@end
