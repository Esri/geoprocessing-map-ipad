///
///  @file
///  WSCustomProperties.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 1/18/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSCustomProperties.h"


@implementation WSCustomProperties


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        // Nothing to be done here.
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSCustomProperties *copy = [[[self class] allocWithZone:zone] init];
    return copy;
}

@end
