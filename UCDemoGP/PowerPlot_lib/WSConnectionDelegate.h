#import <UIKit/UIKit.h>


///
///  WSConnectionDelegate.h
///  PowerPlot
///
///  This protocol defines methods that must be implemented by a class
///  that provides access to node connections inside a graph as
///  provided by the WSGraphConnections class. The methods cover the
///  minimum access methods any class that can handle this type of
///  data is required to implement. Typically, the WSGraph class
///  implements all methods in this class and thus a custom
///  implementation is rarely needed.
///
///  @note Although several methods are marked optional in this
///        protocol, failure to implement them may lead to some
///        features of nodes not working properly. In principle the
///        required method is sufficient to reproduce the missing
///        functionality, the current implementation of the WSNode
///        category of WSDatum needs the optional methods as defined
///        here to provide all functionality.
///
///
///  Created by Wolfram Schroers on 09.11.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@class WSDatum;
@class WSConnection;
@class WSGraphConnections;


@protocol WSConnectionDelegate <NSObject>

@required

/** Return the index of a given node in the graph.
 
    @param node The node object of class WSNode.
    @return The index of the node in the graph.
 */
- (NSUInteger)indexOfNode:(WSDatum *)node;


@optional

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
