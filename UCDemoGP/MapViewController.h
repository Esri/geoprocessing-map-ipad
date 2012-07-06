//
//  ViewController.h
//  UCDemoGP
//
//  Created by Al Pascual on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

#import "EditGraphicViewController.h"

@interface MapViewController : UIViewController <AGSMapViewLayerDelegate,AGSMapViewTouchDelegate,EditGraphicDelegate,AGSGeoprocessorDelegate>

@property (nonatomic,strong) IBOutlet AGSMapView *mainMapView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) AGSFeatureLayer *editableFeatureLayer;
@property (nonatomic,strong) AGSDynamicMapServiceLayer *dynamicLayer;
@property (nonatomic,strong) AGSSketchGraphicsLayer * sketch;
@property (nonatomic,strong) AGSGeoprocessor *geoprocess;
@property (nonatomic,strong) AGSDynamicMapServiceLayer *resultDynamicLayer;

- (void)toggleShowingBasemaps:(CGFloat)width;

@end
