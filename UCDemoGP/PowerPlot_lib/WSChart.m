///
///  @file
///  WSChart.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSChart.h"
#import "WSPlot.h"
#import "WSPlotAxis.h"
#import "WSPlotController.h"
#import "WSChartAnimationKeys.h"
#import "WSAuxiliary.h"


@interface WSChart ()

/** Private method to reset the view hierarchy after changes to plots. */
- (void)viewHierarchyDidChange;

/** Private chart title and subtitle labels. */
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;

/** Initialize the title and subtitle labels. */
- (void)initTitleLabels;

@end

@implementation WSChart

@synthesize chartTitle = _chartTitleText;
@synthesize subTitle = _subTitleText;
@synthesize chartTitleFont = _chartTitleFont;
@synthesize subTitleFont = _subTitleFont;
@synthesize chartTitleColor = _chartTitleColor;
@synthesize subTitleColor = _subTitleColor;
@synthesize customData = _customData;
@synthesize plotSet = _plotSet;

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;


- (void)printGreetings {
    NSLog(@"%@. %@ version.",
          [self version],
          [self licenseStyle]);
}

- (id)init {
    return [self initWithFrame:CGRectNull];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization.
        [self setCustomData:nil];
        [self resetChart];
        [self initTitleLabels];
#ifndef __NO_VC
        [self printGreetings];
#endif
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization.
        [self setCustomData:nil];
        [self resetChart];
        [self initTitleLabels];
#ifndef __NO_VC
        [self printGreetings];
#endif
    }
    return self;
}

- (void)awakeFromNib {
#ifndef __NO_VC
    [self printGreetings];
#endif
    [self resetChart];
}


- (void)resetChart {
    // Initialize the chart with default values.
    _chartTitleText = @"";
    _subTitleText = @"";
 
    _chartTitleFont = [UIFont systemFontOfSize:24.0];
    _subTitleFont = [UIFont systemFontOfSize:16.0];
    _chartTitleColor = [UIColor blackColor];
    _subTitleColor = [UIColor blackColor];
    [self setBackgroundColor:[UIColor whiteColor]];
    if (_plotSet != nil) {
        _plotSet = nil;
    }
    _plotSet = [[NSMutableArray alloc] initWithCapacity:0];

#ifdef __IPHONE_4_0
    [self abortAnimation];
#endif ///__IPHONE_4_0
    
}

- (void)drawRect:(CGRect)rect {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl view] setNeedsDisplay];
    }
}

- (void)layoutSubviews {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl view] setFrame:[self bounds]];
        [[ctrl view] setNeedsDisplay];
    }
    [self setChartTitle:[self chartTitle]];
    [self setSubTitle:[self subTitle]];
}

- (void)initTitleLabels {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[self frame]];
    [titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleBottomMargin)];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setFont:[self chartTitleFont]];
    [titleLabel setTextColor:[self chartTitleColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self setTitleLabel:titleLabel];
    [self addSubview:[self titleLabel]];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:[self frame]];
    [subTitleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin)];
    [subTitleLabel setTextAlignment:UITextAlignmentCenter];
    [subTitleLabel setFont:[self subTitleFont]];
    [subTitleLabel setTextColor:[self subTitleColor]];
    [subTitleLabel setBackgroundColor:[UIColor clearColor]];
    [self setSubtitleLabel:subTitleLabel];
    [self addSubview:[self subtitleLabel]];
    
}


#pragma mark - Chart title handling

- (void)setChartTitle:(NSString *)newTitle {
    if (newTitle == nil) {
        _chartTitleText = @"";
    } else {
       
        _chartTitleText = [newTitle copy];
    }
    CGRect newFrame = [[self titleLabel] frame];
    CGSize labelSize = [_chartTitleText sizeWithFont:[[self titleLabel] font]
                                   constrainedToSize:CGSizeMake(CANVAS_HUGE_SIZE,
                                                                CANVAS_HUGE_SIZE)
                                       lineBreakMode:[[self titleLabel] lineBreakMode]];
    newFrame.size.height = labelSize.height;
    newFrame.origin.y = 0.0;
    [[self titleLabel] setFrame:newFrame];
    [[self titleLabel] setText:_chartTitleText];
}

- (void)setSubTitle:(NSString *)newTitle {
    if (newTitle == nil) {
        _subTitleText = @"";
    } else {
       
        _subTitleText = [newTitle copy];        
    }
    CGRect newFrame = [[self subtitleLabel] frame];
    CGSize labelSize = [_subTitleText sizeWithFont:[[self subtitleLabel] font]
                                 constrainedToSize:CGSizeMake(CANVAS_HUGE_SIZE,
                                                              CANVAS_HUGE_SIZE)
                                     lineBreakMode:[[self subtitleLabel] lineBreakMode]];
    newFrame.origin.y = newFrame.size.height - labelSize.height;
    newFrame.size.height = labelSize.height;
    [[self subtitleLabel] setFrame:newFrame];
    [[self subtitleLabel] setText:_subTitleText];
}


#pragma mark - Plot array handling

- (void)addPlotsFromChart:(WSChart *)chart {
    for (WSPlotController *ctl in [chart plotSet]) {
        [self addPlot:ctl];
    }
    [self viewHierarchyDidChange];
}

- (void)generateControllerWithData:(WSData *)dataD
                         plotClass:(Class<NSObject>)aClass
                             frame:(CGRect)frame {
    
    WSPlotController *aController = [[WSPlotController alloc] init];
    id aPlot = [[((id)aClass) alloc] initWithFrame:frame];
    [aController setView:aPlot];
    [aController setDataD:dataD];
    if ([self count] > 0) {
        WSPlotController *firstPlot = [self plotAtIndex:0];
        [aController setCoordX:[firstPlot coordX]];
        [aController setCoordY:[firstPlot coordY]];
        [aController setAxisLocationX:[firstPlot axisLocationX]];
        [aController setAxisLocationY:[firstPlot axisLocationY]];
        [[firstPlot axisLocationX] setCoordDelegate:firstPlot];
        [[firstPlot axisLocationY] setCoordDelegate:firstPlot];
    }
    [self addPlot:aController];
  
}

- (void)addPlot:(WSPlotController *)aPlot {
    [[aPlot view] setFrame:[self bounds]];
    [[self plotSet] addObject:aPlot];
    [self viewHierarchyDidChange];
}

- (void)insertPlot:(WSPlotController *)aPlot
           atIndex:(NSUInteger)index {
    [[aPlot view] setFrame:[self bounds]];
    [[self plotSet] insertObject:aPlot atIndex:index];
    [self viewHierarchyDidChange];
}

- (void)replacePlotAtIndex:(NSUInteger)index
                  withPlot:(WSPlotController *)aPlot {
    [[aPlot view] setFrame:[self bounds]];
    [[self plotSet] replaceObjectAtIndex:index withObject:aPlot];
    [self viewHierarchyDidChange];
}

- (void)removeAllPlots {
    [[self plotSet] removeAllObjects];
    for (id viewObject in [self plotSet]) {
        [viewObject removeFromSuperview];
    }
    [self viewHierarchyDidChange];
}

- (void)removePlotAtIndex:(NSUInteger)index {
    [[self plotSet] removeObjectAtIndex:index];
    [self viewHierarchyDidChange];
}

- (void)exchangePlotAtIndex:(NSUInteger)idx1
            withPlotAtIndex:(NSUInteger)idx2 {
    [[self plotSet] exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    [self viewHierarchyDidChange];
}

- (WSPlotController *)plotAtIndex:(NSUInteger)index {
    return [[self plotSet] objectAtIndex:index];
}

- (WSPlotController *)lastPlot {
    return [[self plotSet] lastObject];
}

- (NSUInteger)count {
    return [[self plotSet] count];
}

- (id)firstPlotOfClass:(Class)aClass {
    for (WSPlotController *aPlot in [self plotSet]) {
        if ([[aPlot view] isKindOfClass:aClass]) {
            return [aPlot view];
        }
    }
    return [NSNull null];
}

- (WSPlotAxis *)firstPlotAxis {
    return [self firstPlotOfClass:[WSPlotAxis class]];
}


#pragma mark - Coordinate system handling

- (BOOL)isAxisConsistentX {
    NARange aRangeD, tmpRangeD;

    // Only need to work if there is data there.
    if ([self count] > 0) {
        aRangeD = NARANGE_INVALID;
        SEL getRangeXD = @selector(rangeXD);
        for (WSPlotController *item in [self plotSet]) {
            if ([item respondsToSelector:getRangeXD]) {
                aRangeD = [item rangeXD];
                if ((!isnan(aRangeD.rMin)) && !(isnan(aRangeD.rMax)))
                    break;
            }
        }
        // Is there any useful data in the first plot that responds?
        if (isnan(aRangeD.rMin) || isnan(aRangeD.rMax))
            return NO;
        
        // Check all ranges.
        for (WSPlotController *item in [self plotSet]) {
            if ([item respondsToSelector:getRangeXD]) {
                tmpRangeD = [item rangeXD];
                if ((tmpRangeD.rMin != aRangeD.rMin) ||
                    (tmpRangeD.rMax != aRangeD.rMax))
                    return NO;
            }
        }
    }
    return YES;
}

/** Return if all plots have identical Y-axis scales. */
- (BOOL)isAxisConsistentY {
    NARange aRangeD, tmpRangeD;
    
    // Only need to work if there is data there.
    if ([self count] > 0) {
        aRangeD = NARANGE_INVALID;
        SEL getRangeYD = @selector(rangeYD);
        for (WSPlotController *item in [self plotSet]) {
            if ([item respondsToSelector:getRangeYD]) {
                aRangeD = [item rangeYD];
                if ((!isnan(aRangeD.rMin)) && (!isnan(aRangeD.rMax)))
                    break;
            }
        }
        // Is there useful data in the first plot that responds?
        if (isnan(aRangeD.rMin) || isnan(aRangeD.rMax))
            return NO;
        
        // Check all ranges.
        for (WSPlotController *item in [self plotSet]) {
            if ([item respondsToSelector:getRangeYD]) {
                tmpRangeD = [item rangeYD];
                if ((tmpRangeD.rMin != aRangeD.rMin) ||
                    (tmpRangeD.rMax != aRangeD.rMax))
                    return NO;
            }
        }
    }
    return YES;
}

- (void)scaleAllAxisXD:(NARange)aRangeD {
    NSParameterAssert(NARangeLen(aRangeD) > 0.0);
    // Set the coordinate axis scale in all plots.
    for (WSPlotController *item in [self plotSet]) {
        [item setRangeXD:aRangeD];
    }    
}

- (void)scaleAllAxisYD:(NARange)aRangeD {
    NSParameterAssert(NARangeLen(aRangeD) > 0.0);
    // Set the coordinate axis scale in all plots.
    for (WSPlotController *item in [self plotSet]) {
        [item setRangeYD:aRangeD];
    }
}

- (void)autoscaleAllAxisX {
    NARange aRangeD = NARangeStretchGoldenRatio([self dataRangeXD]);
    if (!NARange_isValid(aRangeD)) {
        aRangeD = NARangeMake(0., 1.);
    } else if (NARange_hasZeroLen(aRangeD)) {
        aRangeD = NARangeMake(aRangeD.rMin - 1., aRangeD.rMax + 1.);
    }
    [self scaleAllAxisXD:aRangeD];
}

- (void)autoscaleAllAxisY {
    NARange aRangeD = NARangeStretchGoldenRatio([self dataRangeYD]);
    if (!NARange_isValid(aRangeD)) {
        aRangeD = NARangeMake(0., 1.);
    } else if (NARange_hasZeroLen(aRangeD)) {
        aRangeD = NARangeMake(aRangeD.rMin - 1., aRangeD.rMax + 1.);
    }
    [self scaleAllAxisYD:aRangeD];
}

- (void)setAllAxisLocationX:(NAFloat)aLocation {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationX] setBounds:aLocation];
    }
}

- (void)setAllAxisLocationY:(NAFloat)aLocation {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationY] setBounds:aLocation];
    }
}

- (void)setAllAxisLocationXD:(NAFloat)aLocationD {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationX] setDataD:aLocationD];
    }
}

- (void)setAllAxisLocationYD:(NAFloat)aLocationD {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationY] setDataD:aLocationD];
    }
}

- (void)setAllAxisLocationToOriginXD {
    [self setAllAxisLocationXD:0.];
}

- (void)setAllAxisLocationToOriginYD {
    [self setAllAxisLocationYD:0.];
}

- (void)setAllAxisLocationXRelative:(CGFloat)aLocation {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationX] setRelative:aLocation];
    }
}

- (void)setAllAxisLocationYRelative:(CGFloat)aLocation {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationY] setRelative:aLocation];
    }
}

- (void)setAllAxisPreserveOnChangeX:(WSAxisLocationPreservationStyle)aStyle {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationX] setPreserveOnChange:aStyle];
    }
}

- (void)setAllAxisPreserveOnChangeY:(WSAxisLocationPreservationStyle)aStyle {
    for (WSPlotController *ctrl in [self plotSet]) {
        [[ctrl axisLocationY] setPreserveOnChange:aStyle];
    }
}


#pragma mark - Data handling

- (NARange)dataRangeD:(SEL)dataExtract {
    NARange aRangeD, tmpRangeD;
    
    // This only works with at least one plot.
    aRangeD = NARANGE_INVALID;
    if ([self count] > 0) {
        
        // Start with any given range (if possible).
        for (WSPlotController *item in [self plotSet]) {
            if ([item respondsToSelector:dataExtract]) {
                NSInvocation *inv = [NSInvocation
                                     invocationWithMethodSignature:[item
                                                                    methodSignatureForSelector:dataExtract]];
                [inv setTarget:item];
                [inv setSelector:dataExtract];
                [inv invoke];
                [inv getReturnValue:&aRangeD];
                if ((!isnan(aRangeD.rMin)) && (!isnan(aRangeD.rMax)))
                    break;
            }
        }
        if (isnan(aRangeD.rMin) || isnan(aRangeD.rMax)) {
            return NARANGE_INVALID;
        }
        
        // Then find the maximum range possible.
        for (WSPlotController *item in [self plotSet]) {
            if ([item respondsToSelector:dataExtract]) {
                NSInvocation *inv = [NSInvocation
                                     invocationWithMethodSignature:[item
                                                                    methodSignatureForSelector:dataExtract]];
                [inv setTarget:item];
                [inv setSelector:dataExtract];
                [inv invoke];
                [inv getReturnValue:&tmpRangeD];
                aRangeD = NARangeMax(aRangeD, tmpRangeD);
            }
        }
    }

    return aRangeD;
}

- (NARange)dataRangeXD {
    return [self dataRangeD:@selector(dataRangeXD)];
}
- (NARange)dataRangeYD {
    return [self dataRangeD:@selector(dataRangeYD)];
}


#pragma mark -

- (void)viewHierarchyDidChange {
    [self setChartTitle:[self chartTitle]];
    [self setSubTitle:[self subTitle]];

    for (UIView *item in [self subviews]) {
        if ([item isKindOfClass:[WSPlot class]]) {
            [(WSPlot *)item removeFromSuperview];
        }
    }
    for (WSPlotController *item in [self plotSet]) {
        [self addSubview:[item view]];
    }
}


#ifdef __IPHONE_4_0

#pragma mark - Animation support section.

@synthesize animationTimer = _animationTimer;

- (void)abortAnimation {
    if ([self animationTimer] != nil) {
        // Recover the active handlers (if present).
        NSMutableDictionary *userInfo = (NSMutableDictionary *)[[self animationTimer]
                                                                userInfo];
        void (^updateHandlerCopy)(NAFloat, id);
        updateHandlerCopy = [userInfo objectForKey:WSUI_CONTEXT_CUSTOM];
        void (^completionHandlerCopy)(BOOL);
        completionHandlerCopy = [userInfo objectForKey:WSUI_COMPLETION];
        
        // Call completion handler and clean everything up.
        [[self animationTimer] invalidate];
        [self setAnimationTimer:nil];

        if (completionHandlerCopy != nil) {
            completionHandlerCopy(NO);
            //Block_release(completionHandlerCopy);
        }
        if (updateHandlerCopy != nil) {
            //Block_release(updateHandlerCopy);
        }
    }
}

#endif ///__IPHONE_4_0


#pragma mark -

- (NSString *)description {
    NSMutableString *prtCont = [NSMutableString
                                stringWithFormat:@"WSChart with %d plots: [",
                                [self count]];
    for (WSPlotController *item in [self plotSet]) {
        [prtCont appendString:[item description]];
        [prtCont appendString:@","];
    }
    [prtCont appendString:@"nil]."];
    
    return [NSString stringWithString:prtCont];
}



@end
