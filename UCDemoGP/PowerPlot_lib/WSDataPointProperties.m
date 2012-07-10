///
///  @file
///  WSDataPointProperties.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 1/19/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSDataPointProperties.h"
#import "WSColor.h"


@implementation WSDataPointProperties

@synthesize symbolStyle = _symbolStyle;
@synthesize symbolSize = _symbolSize;
@synthesize symbolColor = _symbolColor;
@synthesize errorBarLen = _errorBarLen;
@synthesize errorBarWidth = _errorBarWidth;
@synthesize errorBarColor = _errorBarColor;
@synthesize errorStyle = _errorStyle;


- (id)init {
    self = [super init];
    if (self) {
        _symbolStyle = kSymbolDisk;
        _symbolSize = kSymbolSize;
        _symbolColor = [UIColor blackColor] ;
        _errorStyle = kErrorNone;
        _errorBarColor = [UIColor blackColor] ;
        _errorBarLen = kErrorBarLen;
        _errorBarWidth = kErrorBarWdith;
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:[self symbolStyle] forKey:@"style"];
    [encoder encodeFloat:[self symbolSize] forKey:@"size"];
    [encoder encodeObject:[self symbolColor] forKey:@"color"];
    [encoder encodeFloat:[self errorBarLen] forKey:@"eblen"];
    [encoder encodeFloat:[self errorBarWidth] forKey:@"ebwidth"];
    [encoder encodeObject:[self errorBarColor] forKey:@"ebcolor"];
    [encoder encodeInt:[self errorStyle] forKey:@"ebstyle"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _symbolStyle = [decoder decodeIntForKey:@"style"];
        _symbolSize = [decoder decodeFloatForKey:@"size"];
        _symbolColor = [decoder decodeObjectForKey:@"color"] ;
        _errorBarLen = [decoder decodeFloatForKey:@"eblen"];
        _errorBarWidth = [decoder decodeFloatForKey:@"ebwidth"];
        _errorBarColor = [decoder decodeObjectForKey:@"ebcolor"] ;
        _errorStyle = [decoder decodeIntForKey:@"ebstyle"];
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSDataPointProperties *copy = [[[self class] allocWithZone:zone] init];
    [copy setSymbolStyle:[self symbolStyle]];
    [copy setSymbolSize:[self symbolSize]];
    [copy setSymbolColor:[[self symbolColor] copyWithZone:zone] ];
    [copy setErrorBarLen:[self errorBarLen]];
    [copy setErrorBarWidth:[self errorBarWidth]];
    [copy setErrorBarColor:[[self errorBarColor] copyWithZone:zone] ];
    [copy setErrorStyle:[self errorStyle]];
    return copy;
}




@end
