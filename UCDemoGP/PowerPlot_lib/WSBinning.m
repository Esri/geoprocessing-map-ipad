///
///  @file
///  WSBinning.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 15.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSBinning.h"
#import "WSData.h"
#import "WSDatum.h"


@implementation WSBinning


+ (WSData *)binWithData:(WSData *)input
              binNumber:(NSUInteger)number
               selector:(SEL)extract
                  range:(NARange)range {
    
    // Verify input parameters
    NSParameterAssert(number > 0);
    NSParameterAssert(NARangeLen(range) > 0.0);

    // Setup resulting and auxilliary data structures
    NSUInteger i;
    WSData *result = [[WSData alloc] init];
    NAFloat halfWidth = (NARangeLen(range)/(NAFloat)number) / 2.0;
    NAFloat pos = range.rMin + halfWidth;
    
    for (i=0; i<number; i++) {
        // @todo Optimize this part, we only need to loop once!
        NSUInteger binNum = 0;
        for (WSDatum *entry in input) {
            NAFloat entVal = NAN;
            if ([entry respondsToSelector:extract]) {
                NSInvocation *inv = [NSInvocation
                                     invocationWithMethodSignature:[entry
                                                                    methodSignatureForSelector:extract]];
                [inv setTarget:entry];
                [inv setSelector:extract];
                [inv invoke];
                [inv getReturnValue:&entVal];
            }
            if ((entVal < (pos + halfWidth)) &&
                (entVal >= (pos - halfWidth))) {
                binNum++;
            }
        }
        [result addDatum:[WSDatum datumWithValue:pos
                                      valueX:(NAFloat)binNum]];
        pos += 2.0 * halfWidth;
    }
    
    return result;
}

@end
