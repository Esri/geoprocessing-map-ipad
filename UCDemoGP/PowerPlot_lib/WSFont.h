///
///  WSFont.h
///  PowerPlot
///
///  This category adds the implementation of the method required by
///  the NSCopying protocol to UIFont. Thus, any UIFont object can now
///  be copied and defined via "@property (copy)" without causing
///  crashes.
///
///
///  Created by Wolfram Schroers on 28.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>


@interface UIFont (WSFont) <NSCopying>

@end
