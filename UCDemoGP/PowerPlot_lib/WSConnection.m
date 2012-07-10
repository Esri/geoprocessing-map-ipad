///
///  @file
///  WSConnection.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 18.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSConnection.h"


@implementation WSConnection

@synthesize from = _from;
@synthesize to = _to;
@synthesize direction = _direction;
@synthesize strength = _strength;
@synthesize label = _label;
@synthesize color = _color;


+ (id)connection {
    return [[self alloc] init] ;
}

+ (id)connectionFrom:(NSUInteger)a
                  to:(NSUInteger)b {
    return [[self alloc] initFrom:a to:b]
            ;
}

+ (id)connectionFrom:(NSUInteger)a
                  to:(NSUInteger)b
            strength:(NAFloat)s {
    return [[self alloc] initFrom:a to:b strength:s]
            ;
}

- (id)init {
    return [self initFrom:0 to:0];
}

- (id)initFrom:(NSUInteger)a
            to:(NSUInteger)b {
    return [self initFrom:a to:b strength:kStrengthDefault];
}

- (id)initFrom:(NSUInteger)a
            to:(NSUInteger)b
      strength:(NAFloat)s {
    
    self = [super init];
    if (self) {
        _to = b;
        _from = a;
        _direction = kGDirection;
        _strength = s;
        _label = @"";
        
        _color = [UIColor grayColor] ;
    }
    return self;    
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:[self to] forKey:@"to"];
    [encoder encodeInt:[self from] forKey:@"from"];
    [encoder encodeInt:[self direction] forKey:@"direction"];
    [encoder encodeFloat:[self strength] forKey:@"strength"];
    [encoder encodeObject:[self label] forKey:@"label"];
    [encoder encodeObject:[self color] forKey:@"color"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _to = [decoder decodeIntForKey:@"to"];
        _from = [decoder decodeIntForKey:@"from"];
        _direction = [decoder decodeBoolForKey:@"direction"];
        _strength = [decoder decodeFloatForKey:@"strength"];
        _label = [decoder decodeObjectForKey:@"label"] ;
        _color = [decoder decodeObjectForKey:@"color"] ;
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSConnection *copy = [[[self class] allocWithZone:zone] init];
    [copy setTo:[self to]];
    [copy setFrom:[self from]];
    [copy setDirection:[self direction]];
    [copy setStrength:[self strength]];
    [copy setLabel:[NSString stringWithString:[self label]]];
    [copy setColor:[self color]];
    return copy;
}




@end

