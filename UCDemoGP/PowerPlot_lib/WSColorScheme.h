///
///  WSColorScheme.h
///  PowerPlot
///
///  Defines and returns appropriate colors based on a given color
///  scheme constant as defined in WSPlotFactoryDefaults.h.
///
///
///  Created by Wolfram Schroers on 02.11.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSObject.h"
#import "WSPlotFactoryDefaults.h"


@interface WSColorScheme : WSObject <NSCoding, NSCopying> {

@protected
    LPColorScheme _colors;
}

@property (nonatomic) LPColorScheme colors; ///< Current color scheme constant.

/** Return an autoreleased color scheme (factory method).
 
    @param cs The color scheme constant.
    @return An instance of a color scheme. */
+ (id)colorScheme:(LPColorScheme)cs;

/** Initialize a color scheme.
 
    @param cs The color scheme constant.
    @return An initialized color scheme. */
- (id)initWithScheme:(LPColorScheme)cs;

/** Initialize a color scheme with default white color. */
- (id)init;

/** Return the foreground color for the current color scheme. */
- (UIColor *)foreground;

/** Return the background color for the current color scheme. */
- (UIColor *)background;

/** Return the receded color for the current color scheme. */
- (UIColor *)receded;

/** Return the highlight color for the current color scheme. */
- (UIColor *)highlight;

/** Return the spotlight color for the current color scheme. */
- (UIColor *)spotlight;

/** Return the shadow color for the current color scheme. */
- (UIColor *)shadow;

/** Return an array of alternative highlight colors. */
- (NSArray *)highlightArray;

/** Return the primary alert color. */
- (UIColor *)alert;

/** Return the secondary alert color. */
- (UIColor *)alertSecondary;

@end
