//
//  CleanUpProcess.h
//  UCDemoGP
//
//  Created by Al Pascual on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface CleanUpProcess : NSObject <AGSFeatureLayerEditingDelegate, AGSQueryTaskDelegate>

@property (nonatomic, strong) NSMutableArray *addedFeaturesArray;
@property (nonatomic, strong) AGSFeatureLayer *editableFeatureLayer;
@property (nonatomic) BOOL bFinished;
@property (nonatomic, strong) AGSQueryTask *task;


- (void) cleanUp:(NSMutableArray*)featuresArray;

@end
