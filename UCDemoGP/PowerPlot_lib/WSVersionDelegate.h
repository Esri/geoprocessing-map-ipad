///
///  WSVersionDelegate.h
///  PowerPlot
///
///  Protocol implemented by all classes that use the versioning and
///  identification mechanism.
///
///
///  Created by Wolfram Schroers on 1/19/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>


@class WSVersion;

@protocol WSVersionDelegate <NSObject>

@property (copy) WSVersion *aVersion;    ///< Version information of this class.
@property (readonly) NSString *UIID;     ///< Unique instance identifier for this instance.
@property (readonly) NSString *version;  ///< Version info from aVersion object.
@property (readonly) NSString *licenseStyle; ///< License condition of the current class.

@end
