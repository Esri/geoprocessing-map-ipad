///
///  WSContour.h
///  PowerPlot
///
///  Category for WSData which provides a method to create contours
///  based on two data sets - the current one and another one which
///  describe the upper and lower envelopes, respectively.
///
///
///  Created by Wolfram Schroers on 01.11.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSData.h"


@interface WSData (WSContour)

/** @brief Return an autoreleased contour (factory method).
 
    This method returns a WSData object that describes a contour based
    on the current data set (upper envelope) and the provided second
    data set (lower envelope). The data is appropriately sorted by
    x-values and can thus be used as the data source in a WSPlotRegion
    view object.
 
    @param lowerEnvelope The lower enveloping data.
    @return The data set which combines both data, properly sorted.
 */
- (WSData *)contourWithData:(WSData *)lowerEnvelope;

/** Return a contour enveloping the data based on uncertainties. */
- (WSData *)contourWithError;

@end
