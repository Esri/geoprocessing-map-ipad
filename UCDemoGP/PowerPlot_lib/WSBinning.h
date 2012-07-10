///
///  WSBinning.h
///  PowerPlot
///
///  This class provides a means of binning data. The points are
///  sorted in a number of bins whose number is provided by the
///  user. Each resulting bin is of the same size and the range to be
///  used is provided by the user.
///
///  Binning is based on a data set of type WSData. The particular
///  type of data is chosen by a selector (acting on WSDatum objects)
///  passed to the binning method. The return type is another data set
///  of type WSData whose Y-values correspond to the number of entries
///  in each bin and whose X-values correspond to the central values
///  of each data bin.
///
///  The returned WSData instance is autoreleased and thus needs to be
///  retained by the user if needed.
///
///
///  Created by Wolfram Schroers on 15.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSObject.h"
#import "NARange.h"


@class WSData;

@interface WSBinning : WSObject

/** @brief Return the binned data.

    @param input Input data set of type WSData.
    @param number Target number of bins. Must be > 0.
    @param extract Selector to extract the information from the input set.
    @param range NARange of the resulting binned data.
                 |rMax-rMin| must be greater than 0.
 
    @return WSData containing information on binned data.
 */
+ (WSData *)binWithData:(WSData *)input
              binNumber:(NSUInteger)number
               selector:(SEL)extract
                  range:(NARange)range;

@end
