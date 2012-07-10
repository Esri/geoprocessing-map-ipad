///
///  @file
///  WSBarProperties.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSBarProperties.h"
#import "WSColor.h"


@implementation WSBarProperties

@synthesize barWidth = _barWidth;
@synthesize outlineStroke = _outlineStroke;
@synthesize shadowScale = _shadowScale;
@synthesize style = _style;
@synthesize shadowEnabled = _shadowEnabled;
@synthesize outlineColor = _outlineColor;
@synthesize barColor = _barColor;
@synthesize barColor2 = _barColor2;
@synthesize shadowColor = _shadowColor;


- (id)init {
    self = [super init];
    if (self) {
        _barWidth = kBarWidth;
        _outlineStroke = kOutlineStroke;
        _shadowScale = kShadowScale;
        _style = kBarOutline;
        _shadowEnabled = NO;
        _outlineColor = [UIColor colorWithRed:0.1
                                         green:0.1
                                          blue:0.4
                                         alpha:1.0];
        _barColor = [UIColor colorWithRed:0.3
                                     green:0.3
                                      blue:1.0
                                     alpha:1.0];
        _barColor2 = [UIColor whiteColor];
        _shadowColor = [UIColor blackColor];
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeFloat:[self barWidth] forKey:@"width"];
    [encoder encodeFloat:[self outlineStroke] forKey:@"outlinestroke"];
    [encoder encodeFloat:[self shadowScale] forKey:@"shadowscale"];
    [encoder encodeInt:[self style] forKey:@"style"];
    [encoder encodeBool:[self isShadowEnabled] forKey:@"shadow"];
    [encoder encodeObject:[self outlineColor] forKey:@"outlinecolor"];
    [encoder encodeObject:[self barColor] forKey:@"barcolor"];
    [encoder encodeObject:[self barColor2] forKey:@"barcolor2"];
    [encoder encodeObject:[self shadowColor] forKey:@"shadowcolor"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _barWidth = [decoder decodeFloatForKey:@"width"];
        _outlineStroke = [decoder decodeFloatForKey:@"outlinestroke"];
        _shadowScale = [decoder decodeFloatForKey:@"shadowscale"];
        _style = [decoder decodeIntForKey:@"style"];
        _shadowEnabled = [decoder decodeBoolForKey:@"shadow"];
        _outlineColor = [decoder decodeObjectForKey:@"outlinecolor"];
        _barColor = [decoder decodeObjectForKey:@"barcolor"];
        _barColor2 = [decoder decodeObjectForKey:@"barcolor2"];
        _shadowColor = [decoder decodeObjectForKey:@"shadowcolor"];
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSBarProperties *copy = [[[self class] allocWithZone:zone] init];
    [copy setBarWidth:[self barWidth]];
    [copy setOutlineStroke:[self outlineStroke]];
    [copy setShadowScale:[self shadowScale]];
    [copy setStyle:[self style]];
    [copy setShadowEnabled:[self isShadowEnabled]];
    [copy setOutlineColor:[[self outlineColor] copyWithZone:zone]];
    [copy setBarColor:[[self barColor] copyWithZone:zone]];
    [copy setBarColor2:[[self barColor2] copyWithZone:zone]];
    [copy setShadowColor:[[self shadowColor] copyWithZone:zone]];
    return copy;
}



@end
