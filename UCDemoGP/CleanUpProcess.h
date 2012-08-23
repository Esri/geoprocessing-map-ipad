//
//  CleanUpProcess.h

/*
 
 UC Geoprocessing Demo -- Esri 2012 User Conference
 Copyright © 2012 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface CleanUpProcess : NSObject <AGSFeatureLayerEditingDelegate, AGSQueryTaskDelegate>

@property (nonatomic, strong) NSMutableArray *addedFeaturesArray;
@property (nonatomic, strong) AGSFeatureLayer *editableFeatureLayer;
@property (nonatomic) BOOL bFinished;
@property (nonatomic, strong) AGSQueryTask *task;


- (void) cleanUp:(NSMutableArray*)featuresArray;

@end
