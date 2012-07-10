///
///  WSView.h
///  PowerPlot
///
///  Basic view class which uses the simple versioning mechanism
///  (optional).
///
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <UIKit/UIKit.h>
#import "WSVersion.h"
#import "WSVersionDelegate.h"
#import "NAAmethyst.h"


@interface WSView : UIView <WSVersionDelegate>

@end
