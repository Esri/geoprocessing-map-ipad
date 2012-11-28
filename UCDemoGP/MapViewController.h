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
#import <AudioToolbox/AudioToolbox.h>

#import "EditGraphicViewController.h"
#import "GraphViewController.h"


typedef enum {
    kState_None,
    kState_CollectEnabled,
    kState_SurfaceEnabled,
    kState_WatershedEnabled,
} ButtonStates;


@protocol MapViewDelegate <NSObject>

- (void) killed;

@end

@interface MapViewController : UIViewController <AGSMapViewLayerDelegate,AGSMapViewTouchDelegate,EditGraphicDelegate,AGSGeoprocessorDelegate,GraphDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) IBOutlet AGSMapView *mainMapView;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) AGSDynamicLayerView *topView;
@property (nonatomic,strong) AGSFeatureLayer *editableFeatureLayer;
@property (nonatomic,strong) AGSDynamicMapServiceLayer *dynamicLayer;
@property (nonatomic,strong) AGSSketchGraphicsLayer * sketch;
@property (nonatomic,strong) AGSGeoprocessor *geoprocess;
@property (nonatomic,strong) AGSGeoprocessor *geoprocessWaterShed;
@property (nonatomic,strong) AGSGeoprocessor *geoprocessDetails;
@property (nonatomic,strong) AGSDynamicMapServiceLayer *resultDynamicLayer;
@property (nonatomic,strong) AGSPolygon *lastWaterShedPolygon;
@property (nonatomic,strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic,strong) IBOutlet UIImageView *sliderIV;
@property (nonatomic) CGAffineTransform originalTransform; 
@property (nonatomic,strong) UIPopoverController *popup;
@property (nonatomic) CGPoint lastScreen;
@property (nonatomic, strong) NSMutableArray *addedFeaturesArray;
@property (nonatomic, strong) UIImageView *activityImageView;
@property (nonatomic) double dSetMapScale;
@property (nonatomic) BOOL bZoomingToPolygon;
@property (nonatomic,strong) id <MapViewDelegate> delegate;
@property (nonatomic) CGFloat originalWidth;
@property (nonatomic) ButtonStates buttonStates;
@property (nonatomic,strong) IBOutlet UIButton *buttonCollect;
@property (nonatomic,strong) IBOutlet UIButton *buttonSurface;
@property (nonatomic,strong) IBOutlet UIButton *buttonWaterShed;
@property (nonatomic,strong) UIImageView *imageView;


- (void) showSwirlyProcess;
- (void) hideSwirlyProcess;
- (void) resetMaps;
- (void) showChartWithGraphic:(AGSGraphic *)polyGraphic;
- (void) waterShedTap:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics;
- (void) changeImages:(ButtonStates)state;
- (void)registerDefaultsFromSettingsBundle;

@end
