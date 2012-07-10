///
///  @file
///  WSContour.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 24.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSContour.h"
#import "WSDatum.h"


@implementation WSData (WSContour)

- (WSData *)contourWithData:(WSData *)lowerEnvelope {
    
    WSData *result = [self sortedDataUsingValueX];
    for (WSDatum *datum in [[[lowerEnvelope sortedDataUsingValueX]
                             values] reverseObjectEnumerator]) {
        [result addDatum:datum];
    }
    
    return result;
}

- (WSData *)contourWithError {
    WSData *upper = [WSData data];
    WSData *lower = [WSData data];
    
    for (WSDatum *datum in [self values]) {
        [upper addDatum:[WSDatum datumWithValue:([datum valueY] + [datum errorMaxY])
                                     valueX:[datum valueX]]];
        [lower addDatum:[WSDatum datumWithValue:([datum valueY] - [datum errorMinY])
                                     valueX:[datum valueX]]];
    }
    
    return [upper contourWithData:lower];
}

@end
