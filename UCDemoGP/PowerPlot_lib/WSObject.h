///
///  WSObject.h
///  PowerPlot
///
///  Basic, generic base class for objects that are not views. Also
///  included is a definition for the synthesize-setter auxilliary
///  function.
///
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSVersion.h"
#import "WSVersionDelegate.h"


@interface WSObject : NSObject <WSVersionDelegate>

@end
