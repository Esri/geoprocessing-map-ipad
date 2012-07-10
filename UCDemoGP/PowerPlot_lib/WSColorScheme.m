///
///  @file
///  WSColorScheme.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 02.11.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSColorScheme.h"
#import "WSColor.h"
#import "NAAmethyst.h"


@implementation WSColorScheme

@synthesize colors = _colors;


+ (id)colorScheme:(LPColorScheme)cs {
    return [[self alloc] initWithScheme:cs] ;
}

- (id)init {
    return [self initWithScheme:kColorWhite];
}

- (id)initWithScheme:(LPColorScheme)cs {
    self = [super init];
    if (self) {
        _colors = cs;
    }
    return self;
}


#pragma mark -

- (UIColor *)foreground {
    UIColor *result = [UIColor blackColor];

    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
            break;
        case kColorGray:
            result = [UIColor blackColor];
            break;
        case kColorDark:
            result = [UIColor whiteColor];
            break;
        case kColorDarkGreen:
            result = [UIColor greenColor];
            break;
        case kColorDarkBlue:
            result = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
            break;
        default:
            break;
    }
    
    return result;
}

- (UIColor *)background {
    UIColor *result = nil;

    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
            result = [UIColor whiteColor];
            break;
        case kColorGray:
            result = [UIColor lightGrayColor];
            break;
        case kColorDark:
            result = [UIColor blackColor];
            break;
        case kColorDarkGreen:
            result = [UIColor blackColor];
            break;
        case kColorDarkBlue:
            result = [UIColor blackColor];
            break;
        default:
            result = [UIColor clearColor];
            break;
    }

    return result;
}

- (UIColor *)receded {
    UIColor *result = [UIColor grayColor];

    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
            break;
        case kColorGray:
            result = [UIColor darkGrayColor];
            break;
        case kColorDark:
            result = [UIColor darkGrayColor];
            break;
        case kColorDarkGreen:
            result = [UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:1.0];
            break;
        case kColorDarkBlue:
            result = [UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1.0];
            break;
        default:
            break;
    }
    
    return result;
}

- (UIColor *)highlight {
    UIColor *result = [UIColor orangeColor];

    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
        case kColorGray:
            break;
        case kColorDark:
            result = [UIColor orangeColor];
            break;
        case kColorDarkGreen:
            result = [UIColor colorWithRed:0.5 green:0.9 blue:0.5 alpha:1.0];
            break;
        case kColorDarkBlue:
            result = [UIColor colorWithRed:0.5 green:0.5 blue:0.9 alpha:1.0];
            break;
        default:
            break;
    }
    
    return result;
}

- (UIColor *)spotlight {
    UIColor *result = [UIColor redColor];

    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
        case kColorGray:
            break;
        case kColorDark:
            result =[UIColor redColor];
            break;
        case kColorDarkGreen:
            result = [UIColor whiteColor];
            break;
        case kColorDarkBlue:
            result = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return result;
}

- (UIColor *)shadow {
    UIColor *result = [UIColor blackColor];

    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
        case kColorGray:
            break;
        case kColorDark:
            result = [UIColor lightGrayColor];
            break;
        case kColorDarkGreen:
            result = [UIColor CSSColorOlive];
            break;
        case kColorDarkBlue:
            result = [UIColor CSSColorTeal];
            break;
        default:
            break;
    }
    
    return result;
}

- (NSArray *)highlightArray {
    const NAFloat* comp = CGColorGetComponents([[self highlight] CGColor]);
    NSArray *result = [NSArray arrayWithObjects:
                       [UIColor colorWithRed:comp[0]
                                       green:comp[1]
                                        blue:comp[2]
                                       alpha:comp[3]],
                       [UIColor colorWithRed:(comp[0] * 3.0/4.0)
                                       green:(comp[1] * 3.0/4.0)
                                        blue:(comp[2] * 3.0/4.0)
                                       alpha:comp[3]],
                       [UIColor colorWithRed:(comp[0] * 2.0/4.0)
                                       green:(comp[1] * 2.0/4.0)
                                        blue:(comp[2] * 2.0/4.0)
                                       alpha:comp[3]],
                       [UIColor colorWithRed:(comp[0] * 1.0/4.0)
                                       green:(comp[1] * 1.0/4.0)
                                        blue:(comp[2] * 1.0/4.0)
                                       alpha:comp[3]],
                       nil];
    
    return result;
}

- (UIColor *)alert {
    UIColor *result = [UIColor redColor];
    
    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
        case kColorGray:
            break;
        case kColorDark:
            result = [UIColor CSSColorYellow];
            break;
        case kColorDarkBlue:
            result = UICOLORRGB(100, 75, 75);
            break;
        case kColorDarkGreen:
            result = UICOLORRGB(100, 100, 75);
            break;
        default:
            break;
    }
    
    return result;
}

- (UIColor *)alertSecondary {
    UIColor *result = [UIColor blackColor];
    
    switch ([self colors]) {
        case kColorWhite:
        case kColorLight:
        case kColorGray:
            break;
        case kColorDark:
        case kColorDarkBlue:
        case kColorDarkGreen:
            result = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return result;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:[self colors] forKey:@"colorscheme"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _colors = [decoder decodeIntForKey:@"colorscheme"];
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSColorScheme *copy = [[[self class] allocWithZone:zone] init];
    [copy setColors:[self colors]];
    return copy;
}




@end
