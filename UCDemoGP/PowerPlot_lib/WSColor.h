///
///  WSColor.h
///  WSColor
///
///  This category adds the implementation of factory methods for
///  colors defined by the CSS-standard and the method required by the
///  NSCopying protocol to UIColor. Thus, any UIColor object can now
///  be copied and defined via "@property (copy)" without causing
///  crashes. Furthermore, a convenience macro is defined that allows
///  to specify an RGB color using percent-values (from 0.0 to 100.0).
///
///  The names of the factory methods for the CSS colors are
///  "CSSColor<name>" where "<name>" is of the colors (starting with a
///  capital letter) defined here:
///  http://www.w3.org/TR/CSS21/syndata.html#color-units
///
///  Note that this category accesses C-functions from Quartz 2D. In
///  order to use it make sure that CoreGraphics.framework is added to
///  your project!
///
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>


/// Convenience macro for defining RGB colors with percent-values.
#define UICOLORRGB(a, b, c) [UIColor colorWithRed:a/100.0 green:b/100.0 blue:c/100.0 alpha:1.0]

@interface UIColor (WSColor) <NSCopying>

+ (UIColor *)CSSColorWhite;
+ (UIColor *)CSSColorSilver;
+ (UIColor *)CSSColorGray;
+ (UIColor *)CSSColorBlack;
+ (UIColor *)CSSColorRed;
+ (UIColor *)CSSColorMaroon;
+ (UIColor *)CSSColorYellow;
+ (UIColor *)CSSColorOlive;
+ (UIColor *)CSSColorLime;
+ (UIColor *)CSSColorGreen;
+ (UIColor *)CSSColorAqua;
+ (UIColor *)CSSColorTeal;
+ (UIColor *)CSSColorBlue;
+ (UIColor *)CSSColorNavy;
+ (UIColor *)CSSColorFuchsia;
+ (UIColor *)CSSColorPurple;
+ (UIColor *)CSSColorOrange;

@end
