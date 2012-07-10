///
///  @file
///  WSNodeProperties.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 19.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSNodeProperties.h"
#import "WSNodeProperties.h"
#import "WSColor.h"
#import "WSFont.h"


@implementation WSNodeProperties

@synthesize size = _size;
@synthesize outlineStroke = _outlineStroke;
@synthesize shadowScale = _shadowScale;
@synthesize labelPadding = _labelPadding;
@synthesize shadowEnabled = _shadowEnabled;
@synthesize outlineColor = _outlineColor;
@synthesize nodeColor = _nodeColor;
@synthesize shadowColor = _shadowColor;
@synthesize labelColor = _labelColor;
@synthesize labelFont = _labelFont;


- (id)init {
    self = [super init];
    if (self) {
        _size = CGSizeMake(kNodeWidth, kNodeHeight);
        _outlineStroke = kOutlineStroke;
        _shadowScale = kShadowScale;
        _labelPadding = kLabelPadding;
        _shadowEnabled = YES;
        _outlineColor = [UIColor colorWithRed:0.1
                                         green:0.1
                                          blue:0.4
                                         alpha:1.0];
        _nodeColor = [UIColor colorWithRed:0.3
                                      green:0.3
                                       blue:1.0
                                      alpha:1.0];
        _shadowColor = [UIColor blackColor];
        _labelColor = [_shadowColor copy];
        _labelFont = [UIFont systemFontOfSize:12];
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeFloat:[self size].width forKey:@"width"];
    [encoder encodeFloat:[self size].height forKey:@"height"];
    [encoder encodeFloat:[self outlineStroke] forKey:@"stroke"];
    [encoder encodeFloat:[self shadowScale] forKey:@"shadowscale"];
    [encoder encodeFloat:[self labelPadding] forKey:@"labelpadding"];
    [encoder encodeBool:[self isShadowEnabled] forKey:@"shadow"];
    [encoder encodeObject:[self outlineColor] forKey:@"outlinecolor"];
    [encoder encodeObject:[self nodeColor] forKey:@"nodecolor"];
    [encoder encodeObject:[self shadowColor] forKey:@"shadowcolor"];
    [encoder encodeObject:[self labelColor] forKey:@"labelcolor"];
    [encoder encodeObject:[[self labelFont] fontName] forKey:@"labelfontname"];
    [encoder encodeFloat:[[self labelFont] pointSize] forKey:@"labelfontsize"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _size = CGSizeMake([decoder decodeFloatForKey:@"width"], 
                           [decoder decodeFloatForKey:@"height"]);
        _outlineStroke = [decoder decodeFloatForKey:@"stroke"];
        _shadowScale = [decoder decodeFloatForKey:@"shadowscale"];
        _labelPadding = [decoder decodeFloatForKey:@"labelpadding"];
        _shadowEnabled = [decoder decodeBoolForKey:@"shadow"];
        _outlineColor = [decoder decodeObjectForKey:@"outlinecolor"];
        _nodeColor = [decoder decodeObjectForKey:@"nodecolor"];
        _shadowColor = [decoder decodeObjectForKey:@"shadowcolor"];
        _labelColor = [decoder decodeObjectForKey:@"labelcolor"];
        _labelFont = [UIFont fontWithName:[decoder decodeObjectForKey:@"labelfontname"]
                                      size:[decoder decodeFloatForKey:@"labelfontsize"]];
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSNodeProperties *copy = [[[self class] allocWithZone:zone] init];
    [copy setSize:CGSizeMake([self size].width, [self size].height)];
    [copy setOutlineStroke:[self outlineStroke]];
    [copy setShadowScale:[self shadowScale]];
    [copy setLabelPadding:[self labelPadding]];
    [copy setShadowEnabled:[self isShadowEnabled]];
    [copy setOutlineColor:[[self outlineColor] copyWithZone:zone] ];
    [copy setNodeColor:[[self nodeColor] copyWithZone:zone] ];
    [copy setShadowColor:[[self shadowColor] copyWithZone:zone] ];
    [copy setLabelColor:[[self labelColor] copyWithZone:zone] ];
    [copy setLabelFont:[[self labelFont] copyWithZone:zone] ];
    return copy;
}



@end
