//
//  AppDelegate.h

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
#import "CleanUpProcess.h"
#import "MapViewController.h"


@class MapViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MapViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MapViewController *viewController;
@property (nonatomic, strong) NSMutableArray *addedFeaturesArray;
@property (nonatomic, strong) CleanUpProcess *cleanUpProcess;
@property (nonatomic) BOOL bMotionStarted;
@property (nonatomic, strong) NSTimer *shakeTimer;

- (void) startView;

@end
