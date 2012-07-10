///
///  @file
///  WSGraphConnections.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 18.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSGraphConnections.h"
#import "NAAmethyst.h"
#import "WSConnection.h"


@implementation WSGraphConnections

@synthesize connections = _connections;
@synthesize dataDelegate = _dataDelegate;


- (id)init {
    self = [super init];
    if (self) {
        _connections = [[NSMutableSet alloc] initWithCapacity:0];
        _dataDelegate = nil;
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self connections] forKey:@"connections"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _connections = [decoder decodeObjectForKey:@"connections"] ;
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSGraphConnections *copy = [[[self class] allocWithZone:zone] init];
    [copy setConnections:[NSMutableSet setWithSet:[self connections]]];
    return copy;
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len {
    return [self connections];
//    return [[self connections] countByEnumeratingWithState:state 
//                                                   objects:stackbuf
//                                                     count:len];
}


#pragma mark -

- (NSUInteger)count {
    return [[self connections] count];
}

- (NSString *)nameTag {
//    if ([self.dataDelegate respondsToSelector:@selector(dataD)]) {
//        
//        if ([[self.dataDelegate dataD] respondsToSelector:@selector(nameTag)]) {
//            return [[self.dataDelegate dataD] nameTag];
//        }
//    }
    return nil;
}

- (WSConnection *)anyConnection {
    return (WSConnection *)[[self connections] anyObject];
}

- (void)addConnection:(WSConnection *)connection {
    [[self connections] addObject:connection];
}

- (void)removeConnection:(WSConnection *)connection {
    [[self connections] removeObject:connection];
}

- (void)removeAllConnections {
    [[self connections] removeAllObjects];
}

- (void)removeAllDirections {
    for (WSConnection *item in [self connections]) {
        [item setDirection:kGDirectionNone];
    }
}

- (void)colorAllConnections:(UIColor *)color {
    for (WSConnection *item in [self connections]) {
        [item setColor:color];
    }
}

- (void)strengthAllConnections:(NAFloat)strength {
    for (WSConnection *item in [self connections]) {
        [item setStrength:strength];
    }
}

- (NAFloat)minimumStrength {
    NAFloat result = NAN;
    
    if ([self count] > 0) {
        result = [[[self connections] anyObject] strength];
        for (WSConnection *item in [self connections]) {
            if ([item strength] < result) {
                result = [item strength];
            }
        }
    }
    
    return result;
}

- (NAFloat)maximumStrength {
    NAFloat result = NAN;
    
    if ([self count] > 0) {
        result = [[[self connections] anyObject] strength];
        for (WSConnection *item in [self connections]) {
            if ([item strength] > result) {
                result = [item strength];
            }
        }
    }
    
    return result;    
}

- (WSConnection *)connectionBetweenNode:(NSUInteger)a
                                andNode:(NSUInteger)b {
    WSConnection *result = nil;
    
    for (WSConnection *item in [self connections]) {
        if ((([item to] == a) && ([item from] == b)) ||
            (([item from] == a) && ([item to] == b))) {
            result = item;
        }
    }
    
    return result;
}

- (WSGraphConnections *)connectionsBetweenNode:(NSUInteger)a
                                       andNode:(NSUInteger)b; {
    WSGraphConnections *result = [[WSGraphConnections alloc] init];
    
    for (WSConnection *item in [self connections]) {
        if ((([item to] == a) && ([item from] == b)) ||
            (([item from] == a) && ([item to] == b))) {
            [result addConnection:item];
        }
    }
        
    return result ;
}

- (NSUInteger)connectionsOfNode:(NSUInteger)a {
    NSUInteger result = 0;
    
    for (WSConnection *item in [self connections]) {
        if (([item to] == a) || ([item from] == a)) {
            result++;
        }
    }
    
    return result;
}

- (NSUInteger)incomingToNode:(NSUInteger)a {
    NSUInteger result = 0;
    
    for (WSConnection *item in [self connections]) {
        if ((([item to] == a) && ([item direction] == kGDirection)) ||
            (([item from] == a) && ([item direction] == kGDirectionInverse)) ||
            ((([item to] == a) || ([item from] == a)) &&
             ([item direction] == kGDirectionBoth))) {
                result++;
            }
    }
    
    return result;
}

- (NSUInteger)outgoingFromNode:(NSUInteger)a {
    NSUInteger result = 0;
    
    for (WSConnection *item in [self connections]) {
        if ((([item from] == a) && ([item direction] == kGDirection)) ||
            (([item to] == a) && ([item direction] == kGDirectionInverse)) ||
            ((([item to] == a) || ([item from] == a)) &&
             ([item direction] == kGDirectionBoth))) {
                result++;
            }
    }
    
    return result;    
}

- (NAFloat)incomingToNodeStrength:(NSUInteger)a {
    NAFloat result = 0.0;
    
    for (WSConnection *item in [self connections]) {
        if ((([item to] == a) && ([item direction] == kGDirection)) ||
            (([item from] == a) && ([item direction] == kGDirectionInverse)) ||
            ((([item to] == a) || ([item from] == a)) &&
             ([item direction] == kGDirectionBoth))) {
                result += [item strength];
            }
    }
    
    return result;    
}

- (NAFloat)outgoingFromNodeStrength:(NSUInteger)a {
    NAFloat result = 0.0;
    
    for (WSConnection *item in [self connections]) {
        if ((([item from] == a) && ([item direction] == kGDirection)) ||
            (([item to] == a) && ([item direction] == kGDirectionInverse)) ||
            ((([item to] == a) || ([item from] == a)) &&
             ([item direction] == kGDirectionBoth))) {
                result += [item strength];
            }
    }
    
    return result;        
}

- (NAFloat)nodeActivity:(NSUInteger)a {
    return ([self incomingToNodeStrength:a] + [self outgoingFromNodeStrength:a]);
}


#pragma mark -

- (NSString *)description {
    const NSUInteger descLen = 5;
    NSUInteger num = [self count];
    NSMutableString *prtCont = [NSMutableString stringWithString:@"["];
    
    
    // Iterate over all connections.
    NSUInteger i = 0;
    for (WSConnection *item in [self connections]) {
        // Print the contents of the first "descLen" points.
        if (i < descLen) {
            [prtCont appendFormat:@"(%d,%d,", [item from], [item to]];
            switch ([item direction]) {
                case kGDirectionNone:
                    [prtCont appendString:@"-"];
                    break;
                case kGDirection:
                    [prtCont appendString:@"->"];
                    break;
                case kGDirectionInverse:
                    [prtCont appendString:@"<-"];
                    break;
                case kGDirectionBoth:
                    [prtCont appendString:@"<->"];
                    break;
                default:
                    break;
            }
            [prtCont appendFormat:@",%f", [item strength]];
            if ([item label] != nil) {
                [prtCont appendFormat:@",%@", [item label]];
            }
            [prtCont appendString:@"],"];
            i++;
        }
    }
    if (num > descLen) {
        [prtCont appendString:@"...,nil]"];
    } else
        [prtCont appendString:@"nil]"];
   
    return [NSString stringWithFormat:@"%@ of length %i, content: %@.",
            [self class], [self count], prtCont];
}



@end
