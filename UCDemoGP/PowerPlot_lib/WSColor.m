///
///  @file
///  WSColor.m
///  WSColor
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSColor.h"


@implementation UIColor (WSColor)


#pragma mark - CSSColor<name>

+ (UIColor *)CSSColorWhite {
    return UICOLORRGB(100.0, 100.0, 100.0);
}

+ (UIColor *)CSSColorSilver {
    return UICOLORRGB(75.0, 75.0, 75.0);
}

+ (UIColor *)CSSColorGray {
    return UICOLORRGB(50.0, 50.0, 50.0);
}

+ (UIColor *)CSSColorBlack {
    return UICOLORRGB(0.0, 0.0, 0.0);
}

+ (UIColor *)CSSColorRed {
    return UICOLORRGB(100.0, 0.0, 0.0);
}

+ (UIColor *)CSSColorMaroon {
    return UICOLORRGB(50.0, 0.0, 0.0);
}

+ (UIColor *)CSSColorYellow {
    return UICOLORRGB(100.0, 100.0, 0.0);
}

+ (UIColor *)CSSColorOlive {
    return UICOLORRGB(50.0, 50.0, 0.0);
}

+ (UIColor *)CSSColorLime {
    return UICOLORRGB(0.0, 100.0, 0.0);
}

+ (UIColor *)CSSColorGreen {
    return UICOLORRGB(0.0, 50.0, 0.0);
}

+ (UIColor *)CSSColorAqua {
    return UICOLORRGB(0.0, 100.0, 100.0);
}

+ (UIColor *)CSSColorTeal {
    return UICOLORRGB(0.0, 50.0, 50.0);
}

+ (UIColor *)CSSColorBlue {
    return UICOLORRGB(0.0, 0.0, 100.0);
}

+ (UIColor *)CSSColorNavy {
    return UICOLORRGB(0.0, 0.0, 50.0);
}

+ (UIColor *)CSSColorFuchsia {
    return UICOLORRGB(100.0, 0.0, 100.0);
}

+ (UIColor *)CSSColorPurple {
    return UICOLORRGB(50.0, 0.0, 50.0);
}

+ (UIColor *)CSSColorOrange {
    return UICOLORRGB(100.0, 65.0, 0.0);
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    CGColorRef quartzColor = CGColorCreateCopy([self CGColor]);
    UIColor *copy = [(UIColor *)[[self class] allocWithZone:zone] initWithCGColor:quartzColor];
    CGColorRelease(quartzColor);
    
    return copy;
}

@end
