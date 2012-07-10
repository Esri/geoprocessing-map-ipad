///
///  WSConnection.h
///  PowerPlot
///
///  This class describes the properties of a single connection in
///  instances of WSGraphConnections.
///
///
///  Created by Wolfram Schroers on 18.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"


/** Default connection strength. */
#define kStrengthDefault 1.0

/** Direction of a connection. */
typedef enum _WSGDirection {
    kGConnectionNone = -1, ///< No connection.
    kGDirectionNone,       ///< No direction.
    kGDirection,           ///< Direction from -> to.
    kGDirectionInverse,    ///< Direction to -> from.
    kGDirectionBoth        ///< Bidirectional.
} WSGDirection;

@interface WSConnection : WSObject <NSCopying, NSCoding> {

@protected
    NSUInteger _from, _to;
    WSGDirection _direction;
    NAFloat _strength;       
    NSString *_label;        
    UIColor *_color;
}

@property NSUInteger from;                   ///< Starting location index in a WSData object.
@property NSUInteger to;                     ///< Ending location index in a WSData object.
@property WSGDirection direction;            ///< Direction of connection.
@property NAFloat strength;                  ///< Strength of a connection (abstract concept).
@property (copy, nonatomic) NSString *label; ///< Connection label.
@property (copy, nonatomic) UIColor *color;  ///< Connection color.

/** Return an autoreleased connection from 0 to 0 (factory method). */
+ (id)connection;

/** Return an autoreleased connection from a to b (factory method). */
+ (id)connectionFrom:(NSUInteger)a
                  to:(NSUInteger)b;

/** Return an autoreleased connection from a to b with a given strength (factory method). */
+ (id)connectionFrom:(NSUInteger)a
                  to:(NSUInteger)b
            strength:(NAFloat)s;

/** Sets a connection from node 0 to 0 with default configuration. */
- (id)init;

/** Initialize a connection from a to b. */
- (id)initFrom:(NSUInteger)a
            to:(NSUInteger)b;

/** Initializer with connection from a to b with a given strength. */
- (id)initFrom:(NSUInteger)a
            to:(NSUInteger)b
      strength:(NAFloat)s;

@end
