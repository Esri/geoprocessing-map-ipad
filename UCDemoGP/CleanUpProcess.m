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

- (void) cleanUp:(NSMutableArray*)featuresArray
{
    self.addedFeaturesArray = featuresArray;
    
    if ( self.addedFeaturesArray.count > 0 ) {
        self.editableFeatureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:kSoilSampleFeatureService] mode:AGSFeatureLayerModeOnDemand];
        self.editableFeatureLayer.editingDelegate = self;
        
        [self.editableFeatureLayer deleteFeaturesWithObjectIds:self.addedFeaturesArray];
    }
}

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFeatureEditsWithResults:(AGSFeatureLayerEditResults *)editResults
{
    if([editResults.deleteResults count]>0)
        [self.addedFeaturesArray removeAllObjects];
}

@end
