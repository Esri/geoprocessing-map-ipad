///
///  @file
///  WSCoordinate.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSCoordinate.h"
#import "WSCoordinateTransform.h"


@implementation WSCoordinate

@synthesize direct = _direct;
@synthesize coordScale = _coordScale;
@synthesize coordRangeD = _coordRangeD;
@synthesize coordOrigin = _coordOrigin;
@synthesize inverted = _inverted;
//@synthesize customCoord = _customCoord;
@synthesize scrollRangeD = _scrollRangeD;
@synthesize zoomRangeD = _zoomRangeD;


+ (id)coordinate {
    return [[self alloc] init];
}

+ (id)coordinateWithScale:(WSCoordinateScale)cdScale
                 axisMinD:(NAFloat)axMinD
                 axisMaxD:(NAFloat)axMaxD
                 inverted:(BOOL)invert {
    return [[self alloc] initWithScale:cdScale
                                       axisMinD:axMinD
                                       axisMaxD:axMaxD
                                       inverted:invert]
            ;
}

- (id)init {
    return [self initWithScale:kCoordinateScaleLinear
                      axisMinD:0.0
                      axisMaxD:1.0
                      inverted:NO];
}

- (id)initWithScale:(WSCoordinateScale)cdScale
           axisMinD:(NAFloat)axMinD
           axisMaxD:(NAFloat)axMaxD
           inverted:(BOOL)invert {

    self = [super init];
    if (self) {
        _coordScale = cdScale;
        _coordRangeD = NARangeMake(axMinD, axMaxD);
        _coordOrigin = 0.0;
        _inverted = invert;
        _customCoord = nil;
        _scrollRangeD = NARANGE_INVALID;
        _zoomRangeD = NARANGE_INVALID;
    }
    return self;
}


#pragma mark -

- (NAFloat)transformData:(NAFloat)dataD
                    size:(NAFloat)size {
    
    NAFloat retVal;

    switch ([self coordScale]) {
        case kCoordinateScaleLinear:
            retVal = ((dataD-[self coordRangeD].rMin) /
                      ([self coordRangeD].rMax-[self coordRangeD].rMin) * size);
            break;
        case kCoordinateScaleLogarithmic:
            retVal = log((dataD-[self coordRangeD].rMin) /
                         ([self coordRangeD].rMax-[self coordRangeD].rMin)) * size;
            break;
        case kCoordinateScaleCustom:
            if ([[self customCoord]
                 respondsToSelector:@selector(transform:)]) {
                retVal = ([[self customCoord]
                           transform:(dataD-[self coordRangeD].rMin)] /
                          ([self coordRangeD].rMax-[self coordRangeD].rMin) * size);
            } else {
                retVal = NAN;                
            }
            break;
        default:
            retVal = NAN;
            break;
    }
    if (!isnan(retVal)) {
        if ([self inverted]) {
            retVal = size - retVal;
        }
        retVal += [self coordOrigin];
    }
    return retVal;
}

- (NAFloat)transformBounds:(NAFloat)bound
                      size:(NAFloat)size {
    
    NAFloat retVal;
    
    bound -= [self coordOrigin];

    if ([self inverted]) {
        bound = size - bound;
    }

    switch ([self coordScale]) {
        case kCoordinateScaleLinear:
            retVal = (bound / size *
                      ([self coordRangeD].rMax-[self coordRangeD].rMin)
                      + [self coordRangeD].rMin);
            break;
        case kCoordinateScaleLogarithmic:
            retVal = (exp(bound / size) *
                      ([self coordRangeD].rMax-[self coordRangeD].rMin)
                      + [self coordRangeD].rMin);
            break;
        case kCoordinateScaleCustom:
            if ([[self customCoord] respondsToSelector:@selector(inverseTransform:)]) {
                retVal = ([[self customCoord] inverseTransform:(bound / size)] *
                          ([self coordRangeD].rMax-[self coordRangeD].rMin)
                          + [self coordRangeD].rMin);
            } else {
                retVal = NAN;                
            }
            break;
        default:
            retVal = NAN;
            break;
    }

    return retVal;    
}


#pragma mark -

- (NSString *)description {
    NSMutableString *prtCont = [NSMutableString
                                stringWithFormat:@"%@ with scale %d, range "
                                    @"[%f,%f], origin offset %f, ",
                                [self class],
                                [self coordScale],
                                [self coordRangeD].rMin,
                                [self coordRangeD].rMax,
                                [self coordOrigin]];
    if (![self inverted]) {
        [prtCont appendString:@" not "];
    }
    [prtCont appendString:@"inverted."];

    return [NSString stringWithString:prtCont];
}



@end
