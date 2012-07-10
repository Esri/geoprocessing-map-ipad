///
///  @file
///  WSPlotGraph.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 19.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotGraph.h"
#import "WSConnection.h"
#import "WSConnectionDelegate.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSGraph.h"
#import "WSGraphConnections.h"
#import "WSNode.h"
#import "WSNodeProperties.h"


@implementation WSPlotGraph

@synthesize style = _style;
@synthesize propDefault = _propDefault;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _style = kCustomStyleUnified;
        _propDefault = [[WSNodeProperties alloc] init];
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
    if ([[self dataDelegate] respondsToSelector:@selector(connections)]) {
        [[[self dataDelegate] connections] removeAllConnections];
    }
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
    WSNodeProperties *current = [self propDefault];
    CGRect nodeRect;
    
    if ([self style] == kCustomStyleNone) {
        return;
    }
    
    // Remove previous labels (if any).
    for (UIView* label in [self subviews]) {
        [label removeFromSuperview];
    }
    
    // Loop over all connections.
    for (WSConnection *item in [(WSGraph *)[[self dataDelegate] dataD] connections]) {
        
        // Get the involved node properties.
        WSDatum *datumTo = [[[self dataDelegate] dataD] datumAtIndex:[item to]];
        WSDatum *datumFrom = [[[self dataDelegate] dataD] datumAtIndex:[item from]];
        WSNodeProperties *nodeTo = (WSNodeProperties *)[datumTo customDatum];
        WSNodeProperties *nodeFrom = (WSNodeProperties *)[datumFrom customDatum];
        switch ([self style]) {
            case kCustomStyleNone:
            case kCustomStyleIndividual:
                break;
            case kCustomStyleUnified:
                nodeTo = [self propDefault];
                nodeFrom = nodeTo;
                break;
            default:
                break;
        }
        
        // Get the center points for the arrows.
        CGPoint start = CGPointMake([[self coordDelegate] boundsWithDataXD:[datumFrom valueX]], 
                                    [[self coordDelegate] boundsWithDataYD:[datumFrom valueY]]);
        CGPoint end = CGPointMake([[self coordDelegate] boundsWithDataXD:[datumTo valueX]], 
                                  [[self coordDelegate] boundsWithDataYD:[datumTo valueY]]);
        
        // Get the actual starting- and end-points clipped by the rectangles.
        CGRect startRect = CGRectMake(([[self coordDelegate] boundsWithDataXD:[datumFrom valueX]] -
                                       ([nodeFrom size].width/2.0)), 
                                      ([[self coordDelegate] boundsWithDataYD:[datumFrom valueY]] -
                                       ([nodeFrom size].height/2.0)),
                                      [nodeFrom size].width,
                                      [nodeFrom size].height);
        CGRect endRect = CGRectMake(([[self coordDelegate] boundsWithDataXD:[datumTo valueX]] -
                                     ([nodeTo size].width/2.0)), 
                                    ([[self coordDelegate] boundsWithDataYD:[datumTo valueY]] -
                                     ([nodeTo size].height/2.0)),
                                    [nodeTo size].width,
                                    [nodeTo size].height);
        CGPoint startCrd = NALineInternalRectangleIntersection(start,
                                                               end,
                                                               startRect);
        CGPoint endCrd = NALineInternalRectangleIntersection(start,
                                                             end,
                                                             endRect);
        
        // Finally, draw the connecting arrow.
        [[item color] set];
        switch ([item direction]) {
            case kGConnectionNone:
                break;
            case kGDirectionNone:
                CGContextSetLineWidth(myContext, [item strength]);
                CGContextSetStrokeColorWithColor(myContext,
                                                 [[item color] CGColor]);
                CGContextMoveToPoint(myContext, startCrd.x, startCrd.y);
                CGContextAddLineToPoint(myContext, endCrd.x, endCrd.y);
                CGContextStrokePath(myContext);
                break;
            case kGDirection:
                NAContextAddLineArrow(myContext, kArrowLineFilledHead,
                                      startCrd, endCrd, kCArrowLength,
                                      [item strength]);
                break;
            case kGDirectionBoth:
                NAContextAddLineDoubleArrow(myContext, kArrowLineFilledHead,
                                            startCrd, endCrd, kCArrowLength,
                                            [item strength]);
                break;
            case kGDirectionInverse:
                NAContextAddLineArrow(myContext, kArrowLineFilledHead,
                                      endCrd, startCrd, kCArrowLength,
                                      [item strength]);
                break;
            default:
                break;
        }
    }
    
    // Loop over all data points for plotting the nodes.
    for (WSDatum *item in [[self dataDelegate] dataD]) {
        switch ([self style]) {
            case kCustomStyleNone:
            case kCustomStyleUnified:
                break;
            case kCustomStyleIndividual:
                if ([[item customDatum] isKindOfClass:[WSNodeProperties class]]) {
                    current = (WSNodeProperties *)[item customDatum];
                } else {
                    current = [self propDefault];
                }
                break;
            default:
                break;
        }

        // Setup the node rectangle.
        nodeRect = [self nodeRect:item
                             size:[current size]];

        // Draw the node solid fill, with shadow if necessary.
        if ([current isShadowEnabled]) {
            NAFloat scale = [current shadowScale];
            CGContextSetShadowWithColor(myContext,
                                        CGSizeMake(scale, scale),
                                        scale,
                                        [[current shadowColor] CGColor]);
        }
        CGContextSetFillColorWithColor(myContext,
                                       [[current nodeColor] CGColor]);
        CGContextFillRect(myContext, nodeRect);
        if ([current isShadowEnabled]) {
            CGContextSetShadowWithColor(myContext, CGSizeMake(1, 1), 1, NULL);
        }
        
        // Draw the box node outline.
        CGContextSetLineWidth(myContext, [current outlineStroke]);
        CGContextSetStrokeColorWithColor(myContext,
                                         [[current outlineColor] CGColor]);
        CGContextAddRect(myContext, nodeRect);
        CGContextStrokePath(myContext);

        // Draw a label (if the data has annotations).
        NSString *anno = [item annotation];
        if (anno) {
            NAFloat padding = [current labelPadding];
            UILabel *label = [[UILabel alloc]
                              initWithFrame:CGRectMake((nodeRect.origin.x +
                                                        padding), 
                                                       (nodeRect.origin.y +
                                                        padding), 
                                                       (nodeRect.size.width -
                                                        2.0*padding),
                                                       (nodeRect.size.height -
                                                        2.0*padding))];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setFont:[current labelFont]];
            [label setTextColor:[current labelColor]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:anno];
            [self addSubview:label];
            
           
        }
    }
}

- (void)distributeDefaultPropertiesToAllCustomDatum {
    [(WSGraph *)[[self dataDelegate] dataD] setAllNodesTo:[self propDefault]];
}

- (CGRect)nodeRect:(WSDatum *)node
              size:(CGSize)size {
    return CGRectMake(([[self coordDelegate] boundsWithDataXD:[node valueX]] - (size.width/2.0)),
                      ([[self coordDelegate] boundsWithDataYD:[node valueY]] - (size.height/2.0)),
                      size.width,
                      size.height);
}

- (NSInteger)nodeForPoint:(CGPoint)location {
    for (WSDatum *node in [[self dataDelegate] dataD]) {
        if (CGRectContainsPoint([self nodeRect:node
                                          size:[node size]],
                                location) ) {
            return [(WSGraph *)[[self dataDelegate] dataD] indexOfNode:node];
        }
    }
    return -1;
}


#pragma mark -



@end
