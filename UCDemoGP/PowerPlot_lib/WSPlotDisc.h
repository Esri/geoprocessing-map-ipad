///
///  WSPlotDisc.h
///  PowerPlot
///
///  This class draws ellipses at the data points with sizes and tilt
///  based on the uncertainty entries of the data points. The ellipses
///  can be filled with a color and optionally have a line around
///  them.  If a data point has no uncertainty or if it is zero in one
///  direction, no symbol is drawn for that point. If a non-zero value
///  for "errorCorr" is specified, the disc for that point will be
///  tilted; the tilt corresponds to 45 degrees * errorCorr - thus,
///  meaningful values for "errorCorr" are from the interval [-1, 1].
///
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSPlot.h"
#import "WSDatumCustomization.h"


@class WSDiscProperties;

@interface WSPlotDisc : WSPlot <WSDatumCustomization>

/** Disc customization. */
@property (retain, nonatomic) WSDiscProperties *propDefault;

@end
