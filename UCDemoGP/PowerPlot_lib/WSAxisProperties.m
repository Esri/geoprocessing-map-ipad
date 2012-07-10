///
///  @file
///  WSAxisProperties.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 1/22/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSAxisProperties.h"
#import "WSFont.h"
#import "WSColor.h"


@implementation WSAxisProperties

@synthesize axisStyle = _axisStyle;
@synthesize axisOverhang = _axisOverhang;
@synthesize axisPadding = _axisPadding;
@synthesize gridStyle = _gridStyle;
@synthesize labelStyle = _labelStyle;
@synthesize labelOffset = _labelOffset;
@synthesize axisLabel = _axisLabel;
@synthesize labelFont = _labelFont;
@synthesize labelColor = _labelColor;


- (id)init {
    self = [super init];
    if (self) {
        _axisLabel = @"";
        _labelFont = [UIFont systemFontOfSize:12];
        _labelColor = [UIColor blackColor];
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:[self axisStyle] forKey:@"axisstyle"];
    [encoder encodeFloat:[self axisOverhang] forKey:@"axisoverhang"];
    [encoder encodeFloat:[self axisPadding] forKey:@"axispadding"];
    [encoder encodeInt:[self gridStyle] forKey:@"gridstyle"];
    [encoder encodeInt:[self labelStyle] forKey:@"labelStyle"];
    [encoder encodeFloat:[self labelOffset] forKey:@"labelOffset"];
    [encoder encodeObject:[self axisLabel] forKey:@"axisLabel"];
    [encoder encodeObject:[self labelColor] forKey:@"labelcolor"];
    [encoder encodeObject:[[self labelFont] fontName] forKey:@"labelfontname"];
    [encoder encodeFloat:[[self labelFont] pointSize] forKey:@"labelfontsize"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _axisStyle = [decoder decodeIntForKey:@"axisstyle"];
        _axisOverhang = [decoder decodeFloatForKey:@"axisoverhang"];
        _axisPadding = [decoder decodeFloatForKey:@"axispadding"];
        _gridStyle = [decoder decodeIntForKey:@"gridstyle"];
        _labelStyle = [decoder decodeIntForKey:@"labelStyle"];
        _labelOffset = [decoder decodeFloatForKey:@"labelOffset"];
        _axisLabel = [decoder decodeObjectForKey:@"axisLabel"];
        _labelColor = [decoder decodeObjectForKey:@"labelcolor"];
        _labelFont = [UIFont fontWithName:[decoder decodeObjectForKey:@"labelfontname"]
                                      size:[decoder decodeFloatForKey:@"labelfontsize"]]
                      ;
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSAxisProperties *copy = [[[self class] allocWithZone:zone] init];
    [copy setAxisStyle:[self axisStyle]];
    [copy setAxisOverhang:[self axisOverhang]];
    [copy setAxisPadding:[self axisPadding]];
    [copy setGridStyle:[self gridStyle]];
    [copy setLabelStyle:[self labelStyle]];
    [copy setLabelOffset:[self labelOffset]];
    [copy setAxisLabel:[[self axisLabel] copyWithZone:zone]];
    [copy setLabelColor:[[self labelColor] copyWithZone:zone]];
    [copy setLabelFont:[[self labelFont] copyWithZone:zone]];
    return copy;
}

@end
