///
///  WSPlotGraph.h
///  PowerPlot
///
///  This class plots a data set as a graph with nodes and
///  annotations.  It also maintains an instance of WSGraphConnections
///  describing the connections of the objects. The appearance of the
///  nodes is either unified, i.e., every node looks the same, or
///  customized, i.e., every node has individually different
///  properties which are stored in the custom slot of each WSDatum in
///  the dataD property. In either case the appearance of nodes is
///  described by instances of the WSNodeProperties class.
///
///  @note Initially, the individual nodes may not have individual
///        styles. The best way to initialize individual node styles
///        is to use the "setAllNodesToDefault" method which copies
///        the current default style to all nodes. As a next step, the
///        node properties can then be configured.
///
///
///  Created by Wolfram Schroers on 19.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSPlot.h"
#import "WSDatumCustomization.h"


@class WSDatum;
@class WSNodeProperties;

@interface WSPlotGraph : WSPlot <WSDatumCustomization>

/** Node customization. */
@property (retain, nonatomic) WSNodeProperties *propDefault;

/** Return the node rectangle for a given node and size.
 
    @param node The node itself.
    @param size The CGSize of either the current node or a different, default size.
    @return The resulting CGReect.
 */
- (CGRect)nodeRect:(WSDatum *)node
              size:(CGSize)size;

/** Return the node index that contains a point in bounds coordinates.
 
    @return The node index or -1 if there is none overlapping with that point.
 */
- (NSInteger)nodeForPoint:(CGPoint)location;

@end
