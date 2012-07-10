///
///  WSNode.h
///  PowerPlot
///
///  Category for a WSDatum with WSNodeProperties in the customData
///  slot. It offers convenience methods to access information
///  specific to nodes.
///
///
///  Created by Wolfram Schroers on 01.11.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSDatum.h"
#import "WSConnectionDelegate.h"


@class WSNodeProperties;

@interface WSDatum (WSNode)

/** Return an autoreleased empty node (factory method). */
+ (id)node;

/** @brief Return an autoreleased node at a point (factory method).
 
    @param point A point on the canvas in data coordinates.
 */
+ (id)nodeAtPoint:(CGPoint)point;

/** Return an autoreleased node at a point with label text (factory method).
 
    @param point A point on the canvas in data coordinates.
    @param label A string with the node label text.
 */
+ (id)nodeAtPoint:(CGPoint)point
            label:(NSString *)label;

/** Return an autoreleased node at a point with text and properties (factory method).
 
    @param point A point on the canvas in data coordinates.
    @param label A string with the node label text.
    @param properties A WSNodeProperties structure with style information.
 */
+ (id)nodeAtPoint:(CGPoint)point
            label:(NSString *)label
       properties:(WSNodeProperties *)properties;

/** Set the connection delegate for this node.
 
    @param delegate Delegate satisfying the WSConnectionDelegate protocol.
 */
- (void)setConnectionDelegate:(id <WSConnectionDelegate>)delegate;

/** Return the connection delegate for this node.
 
    @return Delegate satisfying the WSConnectionDelegate protocol.
 */
- (id <WSConnectionDelegate>)connectionDelegate;

/** Return the WSNodeProperty style information of this node.

    @return The style information.
 */
- (WSNodeProperties *)nodeStyle;

/** Set the WSNodeProperty style information on this node.
 
    @param nodeStyle The WSNodeProperty style information of this node.
 */
- (void)setNodeStyle:(WSNodeProperties *)nodeStyle;

/** Return the label of this node (the annotation of WSDatum). */
- (NSString *)nodeLabel;

/** Set the label of this node (the annotation of WSDatum). */
- (void)setNodeLabel:(NSString *)label;

/** Return the color of this node (style property). */
- (UIColor *)nodeColor;

/** Set the color of this node (style property). */
- (void)setNodeColor:(UIColor *)color;

/** Get the size property of this node (style property). */
- (CGSize)size;

/** @brief Return the total number of connections of this node.
 
    A circular connection is counted as one. The direction is
    irrelevant.
 
    @note Multiple connections to another node are counted separately.
 */
- (NSUInteger)connectionNumber;

/** @brief Return the total number of directed incoming connections.
 
    The total number of links this node receives. An incoming
    connection is a connection whose direction property is either
    kGDirection with this node a as the "to" link, kGDirectionInverse
    with this node as the "from" link or a KGDirectionBoth with this
    node as either the "to" or the "from" link.
 
    @note Multiple connections to another node are counted separately.
 */
- (NSUInteger)incomingNumber;

/** @brief Return the total number of directed outgoing connections.
 
    The total number of links originating from this node. The
    conventions regarding directions are as in "incomingNumber" with
    the meaning of "from" and "to" reversed.
 */
- (NSUInteger)outgoingNumber;

/** @brief Return the total incoming connection strength.
 
    All directed incoming connections this node receives are counted
    and their respective strength is summed up. The conventions
    regarding directions are as in "incomingNumber".
 */
- (NAFloat)incomingStrength;

/** @brief Return the total outgoing connection strength.
 
    All directed outgoing connections this node has are counted and
    their respectives strength is summed up. The conventions regarding
    directions are as in "incomingNumber" with the meaning of "from"
    and "to" reversed.
 */
- (NAFloat)outgoingStrength;

/** @brief Return the total node connection strength.
 
    Sum of strengths of all directed incoming and outgoing
    connections.
 */
- (NAFloat)nodeActivity;

@end
