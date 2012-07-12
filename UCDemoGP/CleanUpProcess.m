//
//  CleanUpProcess.m
//  UCDemoGP
//
//  Created by Al Pascual on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CleanUpProcess.h"
#import "applicationDefines.h"

@implementation CleanUpProcess

@synthesize addedFeaturesArray = _addedFeaturesArray;
@synthesize editableFeatureLayer = _editableFeatureLayer;
@synthesize bFinished = _bFinished;


- (void) cleanUp:(NSMutableArray*)featuresArray
{
    self.bFinished = NO;
    self.addedFeaturesArray = featuresArray;
   
    if ( self.addedFeaturesArray.count > 0 ) {
        
        self.editableFeatureLayer.editingDelegate = self;
        
        [self.editableFeatureLayer deleteFeaturesWithObjectIds:self.addedFeaturesArray];
        [self.editableFeatureLayer dataChanged];
        [self.editableFeatureLayer refresh];
    }
}

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFeatureEditsWithResults:(AGSFeatureLayerEditResults *)editResults
{
    if([editResults.deleteResults count]>0)
        [self.addedFeaturesArray removeAllObjects];
    
    self.bFinished = YES;
}

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFailFeatureEditsWithError:(NSError *)error
{
    self.bFinished = YES;
}

@end
