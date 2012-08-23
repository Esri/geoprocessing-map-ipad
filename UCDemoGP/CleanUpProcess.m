//
//  CleanUpProcess.m

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

#import "CleanUpProcess.h"
#import "applicationDefines.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation CleanUpProcess

@synthesize addedFeaturesArray = _addedFeaturesArray;
@synthesize editableFeatureLayer = _editableFeatureLayer;
@synthesize bFinished = _bFinished;
@synthesize task = _task;


- (void) cleanUp:(NSMutableArray*)featuresArray
{
    self.bFinished = NO;
    self.addedFeaturesArray = featuresArray;
   
    if ( self.addedFeaturesArray.count > 0 ) {
        
        self.editableFeatureLayer.editingDelegate = self;
        
        [self.editableFeatureLayer deleteFeaturesWithObjectIds:self.addedFeaturesArray];
    }
    
    // Delete all the points bigger than 3000
    self.task = [[AGSQueryTask alloc] initWithURL:[NSURL URLWithString:kSoilSampleFeatureService]];
    self.task.delegate = self;
    AGSQuery *query = [[AGSQuery alloc] init];
    query.where = @"OBJECTID > 6422";
    [self.task executeForIdsWithQuery:query];
}

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation*)op didExecuteWithObjectIds:(NSArray *)objectIds {
    
    if ( objectIds != nil ) {
        @try {
            [self.editableFeatureLayer deleteFeaturesWithObjectIds:objectIds];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception deleting %@", exception);
        }
        @finally {
            
        }
        
        
        
        SystemSoundID mySSID;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emptytrash" ofType:@"aif"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: path], &mySSID); 
        
        AudioServicesPlaySystemSound(mySSID);
    }
}

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFeatureEditsWithResults:(AGSFeatureLayerEditResults *)editResults
{
    if([editResults.deleteResults count]>0)
        [self.addedFeaturesArray removeAllObjects];
    
    self.bFinished = YES;
    [self.editableFeatureLayer dataChanged];
    [self.editableFeatureLayer refresh];
}

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFailFeatureEditsWithError:(NSError *)error
{
    self.bFinished = YES;
}

@end
