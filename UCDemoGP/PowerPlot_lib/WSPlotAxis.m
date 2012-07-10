///
///  @file
///  WSPlotAxis.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 25.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotAxis.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSTicks.h"
#import "WSAxisProperties.h"
#import "WSAuxiliary.h"
#import <math.h>


@interface WSPlotAxis ()

/** Tick labels and the axis labels. */
@property (nonatomic, retain) NSMutableArray *tickUILabelsX;
@property (nonatomic, retain) NSMutableArray *tickUILabelsY;
@property (nonatomic, retain) UILabel *axisUILabelX;
@property (nonatomic, retain) UILabel *axisUILabelY;

@end

@implementation WSPlotAxis

@synthesize axisX = _axisX;
@synthesize axisY = _axisY;
@synthesize axisColor = _axisColor;
@synthesize axisArrowLength = _axisArrowLength;
@synthesize axisStrokeWidth = _axisStrokeWidth;
@synthesize drawBoxed = _drawBoxed;
@synthesize ticksX = _ticksX;
@synthesize ticksY = _ticksY;
@synthesize gridStrokeWidth = _gridStrokeWidth;
@synthesize gridColor = _gridColor;

@synthesize tickUILabelsX = _tickUILabelsX;
@synthesize tickUILabelsY = _tickUILabelsY;
@synthesize axisUILabelX = _axisUILabelX;
@synthesize axisUILabelY = _axisUILabelY;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Reset the axis to default values.
        _axisX = [[WSAxisProperties alloc] init];
        _axisY = [[WSAxisProperties alloc] init];
        [_axisX setAxisStyle:kAxisArrow];
        [_axisY setAxisStyle:kAxisArrow];
        _axisColor = [UIColor blackColor] ;
        _ticksX = [[WSTicks alloc] init];
        _ticksY = [[WSTicks alloc] init];
        _drawBoxed = NO;
        [_axisX setAxisOverhang:kAOverhangX];
        [_axisY setAxisOverhang:kAOverhangY];
        [_axisX setAxisPadding:kAPaddingX];
        [_axisY setAxisPadding:kAPaddingY];
        _axisArrowLength = kAArrowLength;
        _axisStrokeWidth = kAStrokeWidth;
        [_axisX setGridStyle:kGridNone];
        [_axisY setGridStyle:kGridNone];
        _gridStrokeWidth = kAStrokeWidth;
        _gridColor = [UIColor grayColor] ;
        _tickUILabelsX = [[NSMutableArray alloc] initWithCapacity:10];
        _tickUILabelsY = [[NSMutableArray alloc] initWithCapacity:10];
        _axisUILabelX = [[UILabel alloc] initWithFrame:CGRectNull];
        _axisUILabelY = [[UILabel alloc] initWithFrame:CGRectNull];
        [self addSubview:_axisUILabelX];
        [self addSubview:_axisUILabelY];
    }
    return self;
}


#pragma mark - Plot handling

- (BOOL)hasData {
    return NO;
}

- (void)setAllDisplaysOff {
    // Override this method if a plots presents something on the canvas.
    // Reset the plot to use only no-display parameters in all customizable values.
    [[self axisX] setAxisStyle:kAxisNone];
    [[self axisY] setAxisStyle:kAxisNone];
    [[self ticksX] setTicksStyle:kTicksNone];
    [[self ticksY] setTicksStyle:kTicksNone];
    [[self ticksX] setTicksDir:kTDirectionNone];
    [[self ticksY] setTicksDir:kTDirectionNone];
    [self setDrawBoxed:NO];
    [[self axisX] setGridStyle:kGridNone];
    [[self axisY] setGridStyle:kGridNone];
    [[self axisX] setAxisLabel:@""];
    [[self axisY] setAxisLabel:@""];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    NSUInteger i;
    NAFloat pos;
    NAFloat aLocX, aLocY;
    
    
    // Set the axis location.
    aLocX = [[self axisDelegate] axisBoundsX];
    aLocY = [[self axisDelegate] axisBoundsY];
    
    // First, plot the grid bars (if any). These are always below the
    // other objects and thus are drawn first.

    // First, do the X-grid.
    if ([[self axisX] gridStyle] != kGridNone) {
        CGContextBeginPath(myContext);
        [[self gridColor] set];
        CGContextSetLineWidth(myContext, [self gridStrokeWidth]);
        if ([[self axisX] gridStyle] == kGridPlain) {
            NAContextSetLineDash(myContext, kDashingSolid);
        } else if ([[self axisX] gridStyle] == kGridDotted) {
            NAContextSetLineDash(myContext, kDashingDotted);
        }
        for (i=0; i<[[self ticksX] count]; i++) {
            pos = [[self coordDelegate] boundsWithDataXD:[[self ticksX] tickAtIndex:i]];
            if ((pos > ([[self axisX] axisPadding] - [[self axisX] axisOverhang])) &&
                (pos < ([self bounds].size.width - [[self axisX] axisPadding]))) {
                // Place a grid bar at the current location.
                CGContextMoveToPoint(myContext,
                                     pos, 
                                     ([self bounds].size.height - 
                                      [[self axisY] axisPadding]));
                CGContextAddLineToPoint(myContext, 
                                        pos, 
                                        [[self axisY] axisPadding]);                
            }
        }
        CGContextDrawPath(myContext, kCGPathStroke);
    }
    
    // Then, draw the Y-grid.
    if ([[self axisY] gridStyle] != kGridNone) {
        CGContextBeginPath(myContext);
        [[self gridColor] set];
        CGContextSetLineWidth(myContext, [self gridStrokeWidth]);
        if ([[self axisY] gridStyle] == kGridPlain) {
            NAContextSetLineDash(myContext, kDashingSolid);
        } else if ([[self axisY] gridStyle] == kGridDotted) {
            NAContextSetLineDash(myContext, kDashingDotted);
        }
        for (i=0; i<[[self ticksY] count]; i++) {
            pos = [[self coordDelegate] boundsWithDataYD:[[self ticksY] tickAtIndex:i]];
            if ((pos > [[self axisY] axisPadding]) &&
                (pos < ([self bounds].size.height - [[self axisY] axisPadding]))) {
                // Place a grid bar at the current location.
                CGContextMoveToPoint(myContext,
                                     ([self bounds].size.width -
                                      [[self axisX] axisPadding]),
                                     pos);
                CGContextAddLineToPoint(myContext, 
                                        [[self axisX] axisPadding],
                                        pos);
            }
        }
        CGContextDrawPath(myContext, kCGPathStroke);
    }

    // Plot the coordinate axis.

    // First, plot the X-axis.
    [[self axisColor] set];
    NAContextSetLineDash(myContext, kDashingSolid);
    NAArrowStyle aStyle = kArrowLineNone;
    NAFloat startX = [[self axisX] axisPadding] - [[self axisX] axisOverhang];
    NAFloat endX = [self bounds].size.width - [[self axisX] axisPadding];
    NAFloat startY = aLocY;
    NAFloat endY = startY;
    BOOL xPointsRight = YES;
    if ([[self coordDelegate] invertedX]) {
        NAFloat tmp = startX;
        startX = endX;
        endX = tmp;
        xPointsRight = !xPointsRight;
    }
    if (([[self axisX] axisStyle] == kAxisArrowInverse) ||
        ([[self axisX] axisStyle] == kAxisArrowFilledHeadInverse)) {
        NAFloat tmp = startX;
        startX = endX;
        endX = tmp;
        xPointsRight = !xPointsRight;
    }
    switch ([[self axisX] axisStyle]) {
        case kAxisArrowFilledHead:
        case kAxisArrowFilledHeadInverse:
            aStyle = kArrowLineFilledHead;
            break;
        case kAxisArrow:
        case kAxisArrowInverse:
            aStyle = kArrowLineArrow;
            break;
        case kAxisPlain:
            aStyle = kArrowLinePlain;
            break;
        case kAxisNone:
        default:
            aStyle = kArrowLineNone;
            break;
    }
    NAContextAddLineArrow(myContext,
                          aStyle,
                          CGPointMake(startX, startY),
                          CGPointMake(endX, endY),
                          [self axisArrowLength],
                          [self axisStrokeWidth]);
    
    // Then plot the Y-axis.
    startX = aLocX;
    endX = startX;
    startY = [[self axisY] axisPadding];
    endY = ([self bounds].size.height -
            [[self axisY] axisPadding] +
            [[self axisY] axisOverhang]);
    BOOL yPointsUp = YES;
    if ([[self coordDelegate] invertedY]) {
        NAFloat tmp = startY;
        startY = endY;
        endY = tmp;
        yPointsUp = !yPointsUp;
    }        
    if (([[self axisY] axisStyle] == kAxisArrowInverse) ||
        ([[self axisY] axisStyle] == kAxisArrowFilledHeadInverse)) {
        NAFloat tmp = startY;
        startY = endY;
        endY = tmp;
        yPointsUp = !yPointsUp;
    }
    switch ([[self axisY] axisStyle]) {
        case kAxisArrowFilledHead:
        case kAxisArrowFilledHeadInverse:
            aStyle = kArrowLineFilledHead;            
            break;
        case kAxisArrow:
        case kAxisArrowInverse:
            aStyle = kArrowLineArrow;            
            break;
        case kAxisPlain:
            aStyle = kArrowLinePlain;
            break;
        case kAxisNone:
        default:
            aStyle = kArrowLineNone;
            break;
    }
    NAContextAddLineArrow(myContext,
                          aStyle,
                          CGPointMake(startX, startY),
                          CGPointMake(endX, endY),
                          [self axisArrowLength],
                          [self axisStrokeWidth]);    

    // Now plot the box.
    if ([self drawBoxed]) {
        [[self axisColor] set];
        CGContextMoveToPoint(myContext,
                             [[self axisX] axisPadding],
                             [self bounds].size.height -
                             [[self axisY] axisPadding]);
        CGContextAddLineToPoint(myContext,
                                [self bounds].size.width -
                                [[self axisX] axisPadding],
                                [self bounds].size.height -
                                [[self axisY] axisPadding]);
        CGContextAddLineToPoint(myContext, 
                                [self bounds].size.width -
                                [[self axisX] axisPadding], 
                                [[self axisY] axisPadding]);
        CGContextAddLineToPoint(myContext, 
                                [[self axisX] axisPadding], 
                                [[self axisY] axisPadding]);
        CGContextAddLineToPoint(myContext, 
                                [[self axisX] axisPadding], 
                                [self bounds].size.height -
                                [[self axisY] axisPadding]);
    }
    
    // First, do the X-axis.
    CGContextSetLineWidth(myContext, [self axisStrokeWidth]);
        
    // Move along the X-axis until the end.
    startX = [[self axisX] axisPadding] - [[self axisX] axisOverhang];
    endX = [self bounds].size.width - [[self axisX] axisPadding];
    if (xPointsRight) {
        endX -= [self axisArrowLength];
    } else {
        startX += [self axisArrowLength];
    }
    if ([[self ticksX] count] > [_tickUILabelsX count]) {
        for (i=0; i<([_tickUILabelsX count] - [[self ticksX] count]); i++) {
            UILabel *aLabel = [[UILabel alloc] init];
            [_tickUILabelsX addObject:aLabel];
            [self addSubview:aLabel];
            
        }
    }
    if ([[self ticksX] count] < [_tickUILabelsX count]) {
        [_tickUILabelsX
         removeObjectsAtIndexes:[NSIndexSet
                                 indexSetWithIndexesInRange:NSMakeRange([[self ticksX] count],
                                                                        ([_tickUILabelsX count]-[[self ticksX] count]))]];
    }
    for (i=0; i<[[self ticksX] count]; i++) {
        pos = [[self coordDelegate] boundsWithDataXD:[[self ticksX] tickAtIndex:i]];
        if ((pos > startX) && (pos < endX)) {
            
            // Place a major tick mark at the current location.
            switch ([[self ticksX] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         pos, 
                                         (aLocY +
                                          [[self ticksX] majorTicksLen]));
                    CGContextAddLineToPoint(myContext, 
                                            pos, 
                                            (aLocY -
                                             [[self ticksX] majorTicksLen]));
                    break;
                case kTDirectionIn:
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY -
                                             [[self ticksX] majorTicksLen]));
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));
                    CGContextAddLineToPoint(myContext, 
                                            pos, 
                                            (aLocY +
                                             [[self ticksX] majorTicksLen]));
                    break;
                default:
                    break;
            }

            // Add a label to the tick mark.
            if ([[self ticksX] ticksStyle] != kTicksNone) {
                NAFloat angle = 0.25*M_PI;
                NSString *labelString = [[self ticksX] labelAtIndex:i];
                UILabel *cLabel = [_tickUILabelsX objectAtIndex:i];
                CGSize labelSize = [labelString
                                    sizeWithFont:[[self axisX] labelFont]
                                    constrainedToSize:CGSizeMake(CANVAS_HUGE_SIZE,
                                                                 CANVAS_HUGE_SIZE)
                                    lineBreakMode:[cLabel lineBreakMode]];            
                [cLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
                                             UIViewAutoresizingFlexibleHeight)];
                [cLabel setTextAlignment:UITextAlignmentCenter];
                [cLabel setFont:[[self axisX] labelFont]];
                [cLabel setTextColor:[[self axisX] labelColor]];
                [cLabel setBackgroundColor:[UIColor clearColor]];
                [cLabel setText:labelString];
                CGRect newFrame = CGRectNull;
                newFrame.size = labelSize;
                [cLabel setTransform:CGAffineTransformIdentity];
                
                switch ([[self ticksX] ticksStyle]) {
                    case kTicksNone:
                        break;
                    case kTicksLabels:
                        newFrame.origin.x = pos - (labelSize.width / 2.0);
                        newFrame.origin.y = (aLocY +
                                             [[self ticksX] majorTicksLen] +
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsInverse:
                        newFrame.origin.x = pos - (labelSize.width / 2.0);
                        newFrame.origin.y = (aLocY -
                                             labelSize.height -
                                             [[self ticksX] majorTicksLen] -
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsSlanted:
                        newFrame.origin.x = pos;
                        newFrame.origin.y = (aLocY +
                                             [[self ticksX] majorTicksLen] +
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(angle)];
                        break;
                    case kTicksLabelsSlantedInverse:
                        newFrame.origin.x = pos;
                        newFrame.origin.y = (aLocY -
                                             newFrame.size.height -
                                             [[self ticksX] majorTicksLen] -
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(-angle)];                    
                        break;                    
                    default:
                        break;
                }
            }
        } else {
            UILabel *cLabel = [_tickUILabelsX objectAtIndex:i];
            [cLabel setTransform:CGAffineTransformIdentity];
            [cLabel setFrame:CGRectNull];
        }
    }
    
    // Next, do the Y-axis.
    CGContextSetLineWidth(myContext, [self axisStrokeWidth]);
    
    // Move along the Y-axis until the end.
    startY = [[self axisY] axisPadding] - [[self axisY] axisOverhang];
    endY = [self bounds].size.height - [[self axisY] axisPadding];
    if (yPointsUp) {
        endY -= [self axisArrowLength];
    } else {
        startY += [self axisArrowLength];
    }
    if ([[self ticksY] count] > [_tickUILabelsY count]) {
        for (i=0; i<([_tickUILabelsY count] - [[self ticksY] count]); i++) {
            UILabel *aLabel = [[UILabel alloc] init];
            [_tickUILabelsY addObject:aLabel];
            [self addSubview:aLabel];
        
        }
    }
    if ([[self ticksY] count] < [_tickUILabelsY count]) {
        [_tickUILabelsY
         removeObjectsAtIndexes:[NSIndexSet
                                 indexSetWithIndexesInRange:NSMakeRange([[self ticksY] count],
                                                                        ([_tickUILabelsY count]-[[self ticksY] count]))]];
    }
    for (i=0; i<[[self ticksY] count]; i++) {
        pos = [[self coordDelegate] boundsWithDataYD:[[self ticksY] tickAtIndex:i]];
        if ((pos > startY) && (pos < endY)) {
        
            // Place a major tick mark at the current location.
            switch ([[self ticksY] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         (aLocX +
                                          [[self ticksY] majorTicksLen]),
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] majorTicksLen]),
                                            pos);
                    break;
                case kTDirectionIn:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext,
                                            (aLocX +
                                             [[self ticksY] majorTicksLen]),
                                            pos);
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] majorTicksLen]),
                                            pos);
                    break;
                default:
                    break;
            }

            // Add a label to the tick mark.
            if ([[self ticksY] ticksStyle] != kTicksNone) {
                NAFloat angle = 0.25*M_PI;
                NSString *labelString = [[self ticksY] labelAtIndex:i];
                UILabel *cLabel = [_tickUILabelsY objectAtIndex:i];
                [cLabel setTextAlignment:UITextAlignmentCenter];
                [cLabel setFont:[[self axisY] labelFont]];
                [cLabel setTextColor:[[self axisY] labelColor]];
                [cLabel setBackgroundColor:[UIColor clearColor]];
                [cLabel setText:labelString];
                [cLabel setTransform:CGAffineTransformIdentity];
                CGRect newFrame = CGRectNull;
                CGSize labelSize = [labelString
                                    sizeWithFont:[cLabel font]
                                    constrainedToSize:CGSizeMake(CANVAS_HUGE_SIZE,
                                                                 CANVAS_HUGE_SIZE)
                                    lineBreakMode:[cLabel lineBreakMode]];
                newFrame.size = labelSize;
                
                switch ([[self ticksY] ticksStyle]) {
                    case kTicksNone:
                        break;
                    case kTicksLabels:
                        newFrame.origin.x = (aLocX -
                                             labelSize.width -
                                             [[self ticksY] majorTicksLen] -
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsInverse:
                        newFrame.origin.x = (aLocX +
                                             [[self ticksY] majorTicksLen] +
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsSlanted:
                        newFrame.origin.x = (aLocX -
                                             labelSize.width -
                                             [[self ticksY] majorTicksLen] -
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(angle)];
                        break;
                    case kTicksLabelsSlantedInverse:
                        newFrame.origin.x = (aLocX +
                                             [[self ticksY] majorTicksLen] +
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(-angle)];                        
                    default:
                        break;
                }
            }                
        } else {
            UILabel *cLabel = [_tickUILabelsY objectAtIndex:i];
            [cLabel setTransform:CGAffineTransformIdentity];
            [cLabel setFrame:CGRectNull];
        }
    }
    
    // Commit the path so far.
    CGContextDrawPath(myContext, kCGPathStroke);
    
    // Fill in minor tick marks between the major ones on the X-axis.
    CGContextBeginPath(myContext);
    CGContextSetLineWidth(myContext, [self axisStrokeWidth]/2.0);
    for (i=0; i<[[self ticksX] countMinor]; i++) {
        pos = [[self coordDelegate] boundsWithDataXD:[[self ticksX]
                                                     minorTickAtIndex:i]];
        if ((pos > startX) && (pos < endX)) {

            // Place a minor tick mark at the current location.
            switch ([[self ticksX] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         pos,
                                         (aLocY +
                                          [[self ticksX] minorTicksLen]));                        
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY -
                                             [[self ticksX] minorTicksLen]));                                                   
                    break;
                case kTDirectionIn:
                    break;
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY -
                                             [[self ticksX] minorTicksLen]));
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));                           
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY +
                                             [[self ticksX] minorTicksLen]));
                    break;
                default:
                    break;
            }
        }
    }
    
    // Fill in minor tick marks between the major ones on the Y-axis.
    for (i=0; i<[[self ticksY] countMinor]; i++) {
        pos = [[self coordDelegate] boundsWithDataYD:[[self ticksY]
                                                     minorTickAtIndex:i]];
        if ((pos > startY) && (pos < endY)) {
            
            // Place a minor tick mark at the current location.
            switch ([[self ticksY] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         (aLocX +
                                          [[self ticksY] minorTicksLen]),
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] minorTicksLen]),
                                            pos);
                    break;
                case kTDirectionIn:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext,
                                            (aLocX +
                                             [[self ticksY] minorTicksLen]),
                                            pos);
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] minorTicksLen]),
                                            pos);
                    break;
                default:
                    break;
            }
        }
    }

    // Commit the path so far.
    CGContextDrawPath(myContext, kCGPathStroke);

    // Finally, add the axis labels.
    
    // First, the X-axis label.
    if ([[self axisX] labelStyle] != kLabelNone) {
        
        // Configure the label, compute its size and position it as
        // requested.
        [_axisUILabelX setTextAlignment:UITextAlignmentCenter];
        [_axisUILabelX setFont:[[self axisX] labelFont]];
        [_axisUILabelX setTextColor:[[self axisX] labelColor]];
        [_axisUILabelX setBackgroundColor:[UIColor clearColor]];
        [_axisUILabelX setText:[[self axisX] axisLabel]];
        CGRect newFrame = CGRectNull;
        CGSize labelSize = [[[self axisX] axisLabel]
                            sizeWithFont:[_axisUILabelX font]
                            constrainedToSize:CGSizeMake(CANVAS_HUGE_SIZE,
                                                         CANVAS_HUGE_SIZE)
                            lineBreakMode:[_axisUILabelX lineBreakMode]];
        newFrame.size = labelSize;
        switch ([[self axisX] labelStyle]) {
            case kLabelNone:
                break;
            case kLabelCenter:
                newFrame.origin.x = 0.5*([self bounds].size.width -
                                         newFrame.size.width);
                newFrame.origin.y = (aLocY +
                                     [[self axisX] labelOffset] +
                                     [[self axisY] axisOverhang]);
                break;
            case kLabelEnd:
                newFrame.origin.x = ([self bounds].size.width -
                                     [[self axisX] axisPadding] -
                                     labelSize.width);
                newFrame.origin.y = (aLocY +
                                     [[self axisX] labelOffset] +
                                     [[self axisY] axisOverhang]);
                break;
            case kLabelInside:
                newFrame.origin.x = ([self bounds].size.width -
                                     [[self axisX] axisPadding] -
                                     labelSize.width);
                newFrame.origin.y = (aLocY -
                                     [[self axisX] labelOffset] -
                                     [[self axisY] axisOverhang] -
                                     labelSize.height);
                break;
            default:
                break;
        }
        [_axisUILabelX setFrame:newFrame];
    } else {
        [_axisUILabelX setTransform:CGAffineTransformIdentity];
        [_axisUILabelX setFrame:CGRectNull];
    }

    // Next, the Y-axis label.
    if ([[self axisY] labelStyle] != kLabelNone) {
        
        // Configure the label, compute its size and position it as
        // requested.
        [_axisUILabelY setTextAlignment:UITextAlignmentCenter];
        [_axisUILabelY setFont:[[self axisY] labelFont]];
        [_axisUILabelY setTextColor:[[self axisY] labelColor]];
        [_axisUILabelY setBackgroundColor:[UIColor clearColor]];
        [_axisUILabelY setText:[[self axisY] axisLabel]];
        [_axisUILabelY setTransform:CGAffineTransformIdentity];
        CGRect newFrame = CGRectNull;
        CGSize labelSize = [[[self axisY] axisLabel]
                            sizeWithFont:[_axisUILabelY font]
                            constrainedToSize:CGSizeMake(CANVAS_HUGE_SIZE,
                                                         CANVAS_HUGE_SIZE)
                            lineBreakMode:[_axisUILabelY lineBreakMode]];        
        newFrame.size = labelSize;
        switch ([[self axisY] labelStyle]) {
            case kLabelCenter:
                labelSize = [[[self axisY] axisLabel]
                             sizeWithFont:[_axisUILabelY font]
                             constrainedToSize:CGSizeMake(CANVAS_HUGE_SIZE,
                                                          CANVAS_HUGE_SIZE)
                             lineBreakMode:[_axisUILabelY lineBreakMode]];
                newFrame.origin.x = (aLocX -
                                     [[self ticksY] majorTicksLen] -
                                     [[self axisY] labelOffset] -
                                     [[self axisX] axisOverhang] -
                                     labelSize.height);
                newFrame.origin.y = 0.5*([self bounds].size.height -
                                         labelSize.width);
                newFrame.size.width = labelSize.height;
                newFrame.size.height = labelSize.width;
                [_axisUILabelY setFrame:newFrame];
                [_axisUILabelY setTransform:CGAffineTransformMakeRotation(1.5*M_PI)];
                break;
            case kLabelEnd:
                newFrame.origin.x = (aLocX -
                                     [[self axisY] labelOffset] -
                                     0.5*labelSize.width);
                newFrame.origin.y = ([[self axisY] axisPadding] -
                                     [[self axisY] axisOverhang] -
                                     labelSize.height);
                [_axisUILabelY setFrame:newFrame];
                break;
            case kLabelInside:
                newFrame.origin.x = (aLocX +
                                     [[self axisY] labelOffset] +
                                     [[self axisX] axisOverhang]);
                newFrame.origin.y = ([[self axisY] axisPadding] -
                                     0.5*labelSize.height);
                [_axisUILabelY setFrame:newFrame];
                break;
            default:
                break;
        }
    } else {
        [_axisUILabelY setTransform:CGAffineTransformIdentity];
        [_axisUILabelY setFrame:CGRectNull];
    }
}


#pragma mark - Ticks configuration

- (void)setTicksXDWithData:(WSData *)data {
    NSMutableArray *positions = [NSMutableArray arrayWithCapacity:[data count]];
    
    for (WSDatum *item in data) {
        NAFloat valX = [item valueX];
        if (isnan(valX)) {
            NSException *dataEx = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"USER ERROR <%@>",
                                                      [self class]]
                                   reason:@"setTicksXDWithData::X-value error"
                                   userInfo:nil];
            @throw dataEx;
        }
        [positions addObject:[NSNumber numberWithFloat:valX]];
    }
    [[self ticksX] ticksWithNumbers:positions];    
}

- (void)setTicksXDAndLabelsWithData:(WSData *)data {
    NSMutableArray *positions = [NSMutableArray arrayWithCapacity:[data count]];
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:[data count]];
    
    for (WSDatum *item in data) {
        NAFloat valX = [item valueX];
        if (isnan(valX)) {
            NSException *dataEx = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"USER ERROR <%@>",
                                                      [self class]]
                                   reason:@"setTicksXDAndLabelsWithData::X-value error"
                                   userInfo:nil];
            @throw dataEx;
        }
        [positions addObject:[NSNumber
                              numberWithFloat:valX]];
        NSString *anno = [item annotation];
        if (!anno) {
            anno = @"";
        }
        [labels addObject:anno];
    }
    [[self ticksX] ticksWithNumbers:positions labels:labels];    
}

- (void)setTicksXDAndLabelsWithData:(WSData *)data
                        minDistance:(NAFloat)distance {
    
    WSData *tmp = [data sortedDataUsingValueX];
    WSData *result = [WSData data];
    [result addDatum:[tmp datumAtIndex:0]];
    
    NAFloat pos = [[self coordDelegate] boundsWithDataXD:[[result datumAtIndex:0]
                                                         valueX]];
    NAFloat newPos;
    
    for (WSDatum *datum in tmp) {
        newPos = [[self coordDelegate] boundsWithDataXD:[datum valueX]];
        if (newPos == pos) {
            continue;
        }
        if (fabs(newPos - pos) >= distance) {
            [result addDatum:datum];
        }
    }
    
    [self setTicksXDAndLabelsWithData:result];
}

- (void)autoTicksXD {
    [[self ticksX] autoTicksWithRange:[[self coordDelegate] rangeXD]
                               number:([self bounds].size.width/kDefaultTicksDistance)];
}

- (void)autoTicksYD {
    [[self ticksY] autoTicksWithRange:[[self coordDelegate] rangeYD]
                               number:([self bounds].size.height/kDefaultTicksDistance)];
}

- (void)autoNiceTicksXD {
    [[self ticksX] autoNiceTicksWithRange:[[self coordDelegate] rangeXD]
                                   number:([self bounds].size.width/kDefaultTicksDistance)];
}

- (void)autoNiceTicksYD {
    [[self ticksY] autoNiceTicksWithRange:[[self coordDelegate] rangeYD]
                                   number:([self bounds].size.width/kDefaultTicksDistance)];
}

- (void)setTickLabelsX {
    [[self ticksX] setTickLabels];
}

- (void)setTickLabelsY {
    [[self ticksY] setTickLabels];
}

- (void)setTickLabelsXWithStyle:(NSNumberFormatterStyle)style {
    [[self ticksX] setTickLabelsWithStyle:style];
}

- (void)setTickLabelsYWithStyle:(NSNumberFormatterStyle)style {
    [[self ticksY] setTickLabelsWithStyle:style];
}

- (void)setTickLabelsXWithFormatter:(NSNumberFormatter *)formatter {
    [[self ticksX] setTickLabelsWithFormatter:formatter];
}

- (void)setTickLabelsYWithFormatter:(NSNumberFormatter *)formatter {
    [[self ticksY] setTickLabelsWithFormatter:formatter];
}



@end
