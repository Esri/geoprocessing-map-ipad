///
///  @file
///  WSGraph.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 28.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSGraph.h"
#import "WSConnection.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSGraphConnections.h"
#import "WSNodeProperties.h"


@implementation WSGraph

@synthesize connections = _connections;


+ (id)graph {
    return [[self alloc] init] ;
}

+ (id)graphWithNodes:(WSData *)nodes
         connections:(WSGraphConnections *)connections {
    return [[self alloc] initWithNodes:nodes
                            connections:connections]
            ;
}

- (id)init {
    return [self initWithNodes:[WSData data]
                   connections:[WSGraphConnections new]
                                ];
}

- (id)initWithNodes:(WSData *)nodes
        connections:(WSGraphConnections *)connections {
    
    self = [super init];
    if (self) {
        _values = [nodes values] ;
        _connections = connections ;
        [self setAllNodesTo:[[WSNodeProperties alloc] init]
                             ];
        [self setValue:self forKeyPath:@"values.connectionDelegate"];
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self nameTag] forKey:@"name"];
    [encoder encodeObject:[self values] forKey:@"values"];
    [encoder encodeObject:[self connections] forKey:@"connections"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _connections = [decoder decodeObjectForKey:@"connections"] ;
        [self setValue:self forKeyPath:@"values.connectionDelegate"];
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSGraph *copy = [[[self class] allocWithZone:zone] init];
    [copy setNameTag:[self nameTag]];
    [copy setValues:[NSMutableArray arrayWithArray:[self values]]];
    [copy setConnections:[[self connections] copy] ];
    return copy;
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len {
    return [self values];
//    return [[self values] countByEnumeratingWithState:state 
//                                              objects:(__strong)stackbuf
//                                                count:len];
}


#pragma mark - WSConnectionDelegate

- (NSUInteger)indexOfNode:(WSDatum *)node {
    return [self indexOfDatum:node];
}

- (WSConnection *)connectionBetweenNode:(NSUInteger)a
                                andNode:(NSUInteger)b {
    return [[self connections] connectionBetweenNode:a andNode:b];
}

- (WSGraphConnections *)connectionsBetweenNode:(NSUInteger)a
                                       andNode:(NSUInteger)b {
    return [[self connections] connectionsBetweenNode:a andNode:b];
}

- (NSUInteger)connectionsOfNode:(NSUInteger)a {
    return [[self connections] connectionsOfNode:a];
}

- (NSUInteger)incomingToNode:(NSUInteger)a {
    return [[self connections] incomingToNode:a];
}

- (NSUInteger)outgoingFromNode:(NSUInteger)a {
    return [[self connections] outgoingFromNode:a];
}

- (NAFloat)incomingToNodeStrength:(NSUInteger)a {
    return [[self connections] incomingToNodeStrength:a];
}

- (NAFloat)outgoingFromNodeStrength:(NSUInteger)a {
    return [[self connections] outgoingFromNodeStrength:a];
}

- (NAFloat)nodeActivity:(NSUInteger)a {
    return [[self connections] nodeActivity:a];
}


#pragma mark -

- (void)setAllNodesTo:(WSNodeProperties *)custom {
    for (WSDatum *item in [self values]) {
        [item setCustomDatum:[custom copy] ];
    }    
}

- (void)addNode:(WSDatum *)node {
    [super addDatum:node];
}

- (void)insertNode:(WSDatum *)node
           atIndex:(NSUInteger)index {
    [super insertDatum:node
               atIndex:index];
}

- (void)replaceNodeAtIndex:(NSUInteger)index
                  withNode:(WSDatum *)node {
    [super replaceDatumAtIndex:index
                      withDatum:node];
}

- (void)removeAllNodes {
    [super removeAllData];
}

- (void)removeNodeAtIndex:(NSUInteger)index {
    [super removeDatumAtIndex:index];
}

- (WSDatum *)nodeAtIndex:(NSUInteger)index {
    return (WSDatum *)[super datumAtIndex:index];
}

- (NSUInteger)connectionCount {
    return [[self connections] count];
}

- (void)addConnection:(WSConnection *)connection {
    [[self connections] addConnection:connection];
}

- (void)addConnectionFrom:(NSUInteger)a
                       to:(NSUInteger)b {
    [self addConnection:[WSConnection connectionFrom:a to:b]];
}

- (void)addConnectionFrom:(NSUInteger)a
                       to:(NSUInteger)b
                 strength:(NAFloat)s {
    [self addConnection:[WSConnection connectionFrom:a
                                                  to:b
                                            strength:s]];
}

- (void)addConnectionFrom:(NSUInteger)a
                       to:(NSUInteger)b
                 strength:(NAFloat)s
                direction:(WSGDirection)dir {
    WSConnection *c = [WSConnection connectionFrom:a to:b strength:s];
    [c setDirection:dir];
    [self addConnection:c];
}

- (void)removeConnection:(WSConnection *)connection {
    [[self connections] removeConnection:connection];
}

- (void)removeConnectionsBetweenNode:(NSUInteger)a
                             andNode:(NSUInteger)b {
    WSGraphConnections *c = [[self connections] connectionsBetweenNode:a
                                                               andNode:b];
    for (WSConnection *item in c) {
        [self removeConnection:item];
    }
}

- (void)removeAllConnections {
    [[self connections] removeAllConnections];
}

- (void)removeAllDirections {
    [[self connections] removeAllDirections];
}

- (void)colorAllConnections:(UIColor *)color {
    [[self connections] colorAllConnections:color];
}

- (void)strengthAllConnections:(NAFloat)strength {
    [[self connections] strengthAllConnections:strength];
}

- (NAFloat)minimumStrength {
    return [[self connections] minimumStrength];
}

- (NAFloat)maximumStrength {
    return [[self connections] maximumStrength];
}


#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ with nodes: (%@) and connections: (%@).",
            [self class], [super description], [[self connections] description]];
}


@end
