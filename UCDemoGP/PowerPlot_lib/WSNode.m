///
///  @file
///  WSNode.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 01.11.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSNode.h"
#import "WSDatum.h"
#import "WSNodeProperties.h"


@implementation WSDatum (WSNode)

+ (id)node {
    WSDatum *result = [self datum];
    WSNodeProperties *defaultProperties = [[self alloc] init];

    [result setCustomDatum:defaultProperties];
   
    
    return result;
}

+ (id)nodeAtPoint:(CGPoint)point {
    WSNodeProperties *defaultProperties = [[self alloc] init];
    WSDatum *result = [self nodeAtPoint:point
                                  label:@""
                             properties:defaultProperties];
   
    
    return result;
}

+ (id)nodeAtPoint:(CGPoint)point
            label:(NSString *)label {
    WSNodeProperties *defaultProperties = [[self alloc] init];
    WSDatum *result = [self nodeAtPoint:point
                                  label:label
                             properties:defaultProperties];
   
    
    return result;    
}

+ (id)nodeAtPoint:(CGPoint)point
            label:(NSString *)label
       properties:(WSNodeProperties *)properties {
    WSDatum *result = [self datum];
    
    [result setValueX:point.x];
    [result setValueY:point.y];
    [result setAnnotation:label];
    [result setCustomDatum:properties];
    
    return result;
}

- (void)setConnectionDelegate:(id <WSConnectionDelegate>)delegate {
    [self setDelegate:delegate];
}

- (id <WSConnectionDelegate>)connectionDelegate {
    return (id <WSConnectionDelegate>)[self delegate];
}

- (WSNodeProperties *)nodeStyle {
    return (WSNodeProperties *)[self customDatum];
}

- (void)setNodeStyle:(WSNodeProperties *)nodeStyle {
    [self setCustomDatum:nodeStyle];
}

- (NSString *)nodeLabel {
    return [self annotation];
}

- (void)setNodeLabel:(NSString *)label {
    [self setAnnotation:label];
}

- (UIColor *)nodeColor {
    return [[self nodeStyle] nodeColor];
}

- (void)setNodeColor:(UIColor *)color {
    [[self nodeStyle] setNodeColor:color];
}

- (CGSize)size {
    return [(WSNodeProperties *)[self customDatum] size];
}

- (NSUInteger)connectionNumber {
    NSInteger index = [[self connectionDelegate] indexOfNode:self];
    return [[self connectionDelegate] connectionsOfNode:index];
}

- (NSUInteger)incomingNumber {
    NSInteger index = [[self connectionDelegate] indexOfNode:self];
    return [[self connectionDelegate] incomingToNode:index];    
}

- (NSUInteger)outgoingNumber {
    NSInteger index = [[self connectionDelegate] indexOfNode:self];
    return [[self connectionDelegate] outgoingFromNode:index];
}

- (NAFloat)incomingStrength {
    NSInteger index = [[self connectionDelegate] indexOfNode:self];
    return [[self connectionDelegate] incomingToNodeStrength:index];
}

- (NAFloat)outgoingStrength {
    NSInteger index = [[self connectionDelegate] indexOfNode:self];
    return [[self connectionDelegate] outgoingFromNodeStrength:index];
}

- (NAFloat)nodeActivity {
    NSInteger index = [[self connectionDelegate] indexOfNode:self];
    return [[self connectionDelegate] nodeActivity:index];
}

@end
