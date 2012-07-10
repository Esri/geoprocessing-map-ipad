///
///  @file
///  WSAxisLocation.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 12/19/11.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSAxisLocation.h"


@interface WSAxisLocation () {
    
@private
    NAFloat _bounds;
    NAFloat _dataD;
    NAFloat _relative;
}

@end

@implementation WSAxisLocation

@synthesize coordDelegate = _coordDelegate;
@synthesize direct = _direct;
@synthesize preserveOnChange = _preserveOnChange;


- (NAFloat)bounds {
    switch ([self preserveOnChange]) {
        case kPreserveBounds:
            return _bounds;
            break;
        case kPreserveData:
            return [[self coordDelegate] boundsWithDataD:_dataD
                                               direction:[self direct]];
            break;
        case kPreserveRelative:
            return ([[self coordDelegate] boundsSizeForDirection:[self direct]]*_relative +
                    [[self coordDelegate] boundsOffsetForDirection:[self direct]]);
            break;
            
        default:
            return _bounds;
            break;
    }
}

- (void)setBounds:(NAFloat)bounds {
    [self setPreserveOnChange:kPreserveBounds];
    _bounds = bounds;
    _dataD = [[self coordDelegate] dataWithBounds:bounds
                                        direction:[self direct]];
    _relative = ((bounds - [[self coordDelegate] boundsOffsetForDirection:[self direct]])/
                 [[self coordDelegate] boundsSizeForDirection:[self bounds]]);
}

- (NAFloat)dataD {
    switch ([self preserveOnChange]) {
        case kPreserveBounds:
            return [[self coordDelegate] dataWithBounds:_bounds
                                              direction:[self direct]];
            break;
            
        case kPreserveData:
            return _dataD;
            break;
            
        case kPreserveRelative:
        {
            NAFloat bounds = ([[self coordDelegate] boundsSizeForDirection:[self direct]]*_relative +
                              [[self coordDelegate] boundsOffsetForDirection:[self direct]]);
            return [[self coordDelegate] dataWithBounds:bounds
                                              direction:[self direct]];
        }
            break;
            
        default:
            return _dataD;
            break;
    }
}

- (void)setDataD:(NAFloat)dataD {
    [self setPreserveOnChange:kPreserveData];
    _bounds = [[self coordDelegate] boundsWithDataD:dataD
                                          direction:[self direct]];
    _dataD = dataD;
    _relative = ((_bounds - [[self coordDelegate] boundsOffsetForDirection:[self direct]])/
                 [[self coordDelegate] boundsSizeForDirection:[self direct]]);
}

- (NAFloat)relative {
    switch ([self preserveOnChange]) {
        case kPreserveBounds:
            return ((_bounds - [[self coordDelegate] boundsOffsetForDirection:[self direct]])/
                    [[self coordDelegate] boundsSizeForDirection:[self direct]]);
            break;
            
        case kPreserveData:
            return (([[self coordDelegate] boundsWithDataD:_dataD
                                                 direction:[self direct]] -
                     [[self coordDelegate] boundsOffsetForDirection:[self direct]])/
                    [[self coordDelegate] boundsSizeForDirection:[self direct]]);
            break;
            
        case kPreserveRelative:
            return _relative;
            break;
            
        default:
            return _relative;
            break;
    }
}

- (void)setRelative:(NAFloat)relative {
    [self setPreserveOnChange:kPreserveRelative];
    _bounds = (([[self coordDelegate] boundsSizeForDirection:[self direct]] * relative) -
               [[self coordDelegate] boundsOffsetForDirection:[self direct]]);
    _dataD = [[self coordDelegate] dataWithBounds:_bounds
                                        direction:[self direct]];
    _relative = relative;
}



@end
