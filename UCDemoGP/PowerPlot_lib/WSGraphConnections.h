///
///  WSGraphConnections.h
///  PowerPlot
///
///  This class describes the connections of data in a graph as
///  plotted by the WSPlotGraph plot. The data itself must correspond
///  to the connection indices collected in a WSData object.
///
///
///  Created by Wolfram Schroers on 18.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"
#import "WSDataDelegate.h"


@class WSConnection;

@interface WSGraphConnections : WSObject
    <NSCopying,
     NSCoding,
     NSFastEnumeration> {

@protected
    NSMutableSet *_connections;
   
}

@property (retain) NSMutableSet *connections;                   ///< Connections of objects in a WSData object.
@property (strong,nonatomic) id <WSDataDelegate>  dataDelegate; ///< Data delegate for nodes.

/** Return the total number of connections. */
- (NSUInteger)count;

/** Return the dataD name tag (if the delegate has been setup and there is any). */
- (NSString *)nameTag;

/** Return a random connection (or nil if there is none). */
- (WSConnection *)anyConnection;

/** Add a new connection. */
- (void)addConnection:(WSConnection *)connection;

/** Remove a single connection. */
- (void)removeConnection:(WSConnection *)connection;

/** Remove all connections. */
- (void)removeAllConnections;

/** Set all node connections to be undirected. */
- (void)removeAllDirections;

/** Set all connections to a given color. */
- (void)colorAllConnections:(UIColor *)color;

/** Set all connections to a given strength. */
- (void)strengthAllConnections:(NAFloat)strength;

/** Get the minimum connection strength. */
- (NAFloat)minimumStrength;

/** Get the maximum connection strength. */
- (NAFloat)maximumStrength;

/** @brief Return the connection between two nodes (or nil for none).
 
    In case of several connections, a random connection is returned.
 */
- (WSConnection *)connectionBetweenNode:(NSUInteger)a
                                andNode:(NSUInteger)b;

/** @brief Return a set of all connections between two nodes.

    Return a WSGraphConnections object containing all connections
    between two nodes (or nil if there is none). This method can be
    used to normalize a graph (combining similar connections into a
    single one) or to do specific analysis on the graph.

    @param a One graph node in a data set.
    @param b Another graph node in a data set.
    @return A WSGraphConnections object containing all connecting links.
 */
- (WSGraphConnections *)connectionsBetweenNode:(NSUInteger)a
                                       andNode:(NSUInteger)b;

/** @brief Return the total number of connections a given node has.
 
    A circular connection is counted as one. The direction is
    irrelevant.

    @note In case of multiple connections to a single node connections
          are counted separately.
 */
- (NSUInteger)connectionsOfNode:(NSUInteger)a;

/** @brief Return the total number of directed incoming connections.
 
    The total number of links a given node receives. An incoming
    connection is a connection whose direction property is either
    kGDirection with the given node a as the "to" link,
    kGDirectionInverse with the given node as the "from" link or a
    KGDirectionBoth with the given node as either the "to" or the
    "from" link.

    @note In case of multiple connections to a single node connections
          are counted separately.
 */
- (NSUInteger)incomingToNode:(NSUInteger)a;

/** @brief Return the total number of directed outgoing connections.
 
    The total number of links a given node originates. The conventions
    regarding directions are as in "incomingToNode" with the meaning
    of "from" and "to" reversed.
 */
- (NSUInteger)outgoingFromNode:(NSUInteger)a;

/** @brief Return the total incoming connection strength.

    All directed incoming connections a given node receives are
    counted and their respective strength is summed up. The
    conventions regarding directions are as in "incomingToNode".
 */
- (NAFloat)incomingToNodeStrength:(NSUInteger)a;

/** @brief Return the total outgoing connection strength.

    All directed outgoing connections a given node has are counted and
    their respectives strength is summed up. The conventions regarding
    directions are as in "incomingToNode" with the meaning of "from"
    and "to" reversed.
 */
- (NAFloat)outgoingFromNodeStrength:(NSUInteger)a;

/** @brief Return the total node connection strength.
 
    Sum of strengths of all directed incoming and outgoing
    connections.
 */
- (NAFloat)nodeActivity:(NSUInteger)a;

@end
