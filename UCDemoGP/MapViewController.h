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
#import "GraphViewController.h"

@interface MapViewController : UIViewController <AGSMapViewLayerDelegate,AGSMapViewTouchDelegate,EditGraphicDelegate,AGSGeoprocessorDelegate,GraphDelegate>

@property (nonatomic,strong) IBOutlet AGSMapView *mainMapView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) AGSFeatureLayer *editableFeatureLayer;
@property (nonatomic,strong) AGSDynamicMapServiceLayer *dynamicLayer;
@property (nonatomic,strong) AGSSketchGraphicsLayer * sketch;
@property (nonatomic,strong) AGSGeoprocessor *geoprocess;
@property (nonatomic,strong) AGSGeoprocessor *geoprocessWaterShed;
@property (nonatomic,strong) AGSGeoprocessor *geoprocessDetails;
@property (nonatomic,strong) AGSDynamicMapServiceLayer *resultDynamicLayer;
@property (nonatomic,strong) AGSPolygon *lastWaterShedPolygon;
@property (nonatomic,strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic) CGRect originalImageFrame; 
@property (nonatomic) CGRect imageFrame;  

- (void)toggleShowingBasemaps:(CGFloat)width;

@end
