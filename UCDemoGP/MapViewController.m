//
//  ViewController.m
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

#import "MapViewController.h"
#import "applicationDefines.h"

@interface MapViewController ()<UIGestureRecognizerDelegate> {
    UIViewContentMode _origMode;
    CGRect _topViewFrame;
    CGAffineTransform _tvTransform;
}

@end

@implementation MapViewController

@synthesize mainMapView = _mainMapView;
@synthesize topView = _topView;
@synthesize baseView = _baseView;
@synthesize editableFeatureLayer = _editableFeatureLayer;
@synthesize dynamicLayer = _dynamicLayer;
@synthesize sketch = _sketch;
@synthesize geoprocess = _geoprocess;
@synthesize resultDynamicLayer = _resultDynamicLayer;
@synthesize geoprocessWaterShed = _geoprocessWaterShed;
@synthesize lastWaterShedPolygon = _lastWaterShedPolygon;
@synthesize graphicsLayer = _graphicsLayer;
@synthesize geoprocessDetails = _geoprocessDetails;
@synthesize sliderIV = _sliderIV;
@synthesize originalTransform = _originalTransform;
@synthesize popup = _popup;
@synthesize lastScreen = _lastScreen;
@synthesize addedFeaturesArray = _addedFeaturesArray;
@synthesize activityImageView = _activityImageView;
@synthesize dSetMapScale = _dSetMapScale;
@synthesize bZoomingToPolygon = _bZoomingToPolygon;
@synthesize delegate = _delegate;
@synthesize originalWidth = _originalWidth;
@synthesize buttonStates = _buttonStates;
@synthesize buttonCollect = _buttonCollect;
@synthesize buttonSurface = _buttonSurface;
@synthesize buttonWaterShed = _buttonWaterShed;
@synthesize imageView = _imageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dSetMapScale = 0;
    self.bZoomingToPolygon = NO;
    
    // Set all buttons to no state
    self.buttonStates = kState_None;
    
    // init object states
    self.sliderIV.hidden = YES;
    
    [self registerDefaultsFromSettingsBundle];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    self.mainMapView.layerDelegate = self;    
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:[[defaults objectForKey:@"xmin_preference"] doubleValue]
                                                    ymin:[[defaults objectForKey:@"ymin_preference"] doubleValue]
                                                    xmax:[[defaults objectForKey:@"xmax_preference"] doubleValue]
                                                    ymax:[[defaults objectForKey:@"ymax_preference"] doubleValue]
                                        spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    [self.mainMapView zoomToEnvelope:env animated:YES];
    
    NSURL *url = [NSURL URLWithString:[defaults objectForKey:@"basemap_preference"]];
    AGSTiledMapServiceLayer *tiled = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    [self.mainMapView addMapLayer:tiled withName:@"basemap"];
    
    // Real base map
    self.dynamicLayer = [AGSDynamicMapServiceLayer  dynamicMapServiceLayerWithURL:[NSURL URLWithString:[defaults objectForKey:@"dynamic_preference"]]];     
    self.baseView = [self.mainMapView addMapLayer:self.dynamicLayer withName:@"dynamic"];
    
    //add the tile with transperancy on top
    AGSTiledMapServiceLayer *tiled2 = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    UIView *transparentView = [self.mainMapView addMapLayer:tiled2 withName:@"basemap transparent"];
    transparentView.alpha = [[defaults objectForKey:@"slider_preference"] doubleValue];
    
    AGSDynamicMapServiceLayer *dynamicRivers = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:[NSURL URLWithString:[defaults objectForKey:@"rivermapservice_preference"]]]; 
    UIView *dynamicRiverView = [self.mainMapView addMapLayer:dynamicRivers withName:@"dynamic rivers"];
    dynamicRiverView.alpha = [[defaults objectForKey:@"slider_preference"] doubleValue];
    
    // editable layer
    self.editableFeatureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:[defaults objectForKey:@"featureservice_preference"]] mode:AGSFeatureLayerModeOnDemand];
    [self.mainMapView addMapLayer:self.editableFeatureLayer withName:@"Edit Layer"];    
    
    self.mainMapView.touchDelegate = self;
    
    // Setting up the gesture in the Image View
    [self.sliderIV setUserInteractionEnabled:YES];    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panGR.minimumNumberOfTouches = 1;
    panGR.maximumNumberOfTouches = 1;
    panGR.delegate = self;    
    [self.sliderIV addGestureRecognizer:panGR];
    
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipeGR.numberOfTouchesRequired = 2;
    swipeGR.direction =  UISwipeGestureRecognizerDirectionUp;
    swipeGR.delegate = self;
    [self.sliderIV addGestureRecognizer:swipeGR];
}

/// Register the settings bundle
- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            NSLog(@"Bundle Key %@", key);
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    
}

- (void)mapView:(AGSMapView *)mapView failedLoadingLayerForLayerView:(UIView<AGSLayerView> *)layerView baseLayer:(BOOL)baseLayer withError:(NSError *)error
{
    NSLog(@"Layer %@ failed with error %@", layerView.name, error);
}

- (void)mapViewDidLoad:(AGSMapView *)mapView  {
       
    // register for "MapDidEndPanning" notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnvChange:)
                                                 name:@"MapDidEndPanning" object:nil];
    
    // register for "MapDidEndZooming" notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnvChange:) 
                                                 name:@"MapDidEndZooming" object:nil];
    
    self.dSetMapScale = self.mainMapView.mapScale;
    
}

- (void)respondToEnvChange: (NSNotification*) notification {
    
    NSLog(@"Envelope: %@", self.mainMapView.visibleArea.envelope);
    NSLog(@"scale %f", self.mainMapView.mapScale);    
    if ( self.dSetMapScale > 0  ) {
        
        // Do not allow to zoom
        if ( self.dSetMapScale != self.mainMapView.mapScale ) {

            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:[[defaults objectForKey:@"xmin_preference"] doubleValue]
                                                        ymin:[[defaults objectForKey:@"ymin_preference"] doubleValue]
                                                        xmax:[[defaults objectForKey:@"xmax_preference"] doubleValue]
                                                        ymax:[[defaults objectForKey:@"ymax_preference"] doubleValue]
                                            spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
            
            [self.mainMapView zoomToEnvelope:env animated:YES];
            
            //[self resetMaps];
        }
    }
}

- (void)swiped:(id)sender {
    NSLog(@"gesture found");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restart" message:@"Do you want to restart?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.delegate = self;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button index %d", buttonIndex);
    if ( buttonIndex == 1 ) {
        [self.delegate killed];
    }
}

- (void)panned:(id)sender {
    
    // No results no need to let the user compare
    if ( self.resultDynamicLayer == nil )
        return;
    
    UIPanGestureRecognizer *panGr = (UIPanGestureRecognizer*)sender;
    if (panGr.state == UIGestureRecognizerStateEnded) {
        // unhide layer
        self.topView.hidden = NO;
       
        // clean up image
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        
        // animate slider back
        [UIView animateWithDuration:0.25f animations:^{
            self.sliderIV.transform = CGAffineTransformIdentity;
        }];
        return;
    }
    else if ( panGr.state == UIGestureRecognizerStateBegan) {        
        // create image view from dynamicLayerView's image contents
        self.imageView = [[UIImageView alloc] initWithImage:self.topView.image];
        
        // set content mode
        self.imageView.contentMode = UIViewContentModeLeft | UIViewContentModeScaleAspectFill | UIViewContentModeRedraw;
        self.imageView.clipsToBounds = YES;
        [self.baseView addSubview:self.imageView];
        
        // hide our actual layer
        self.topView.hidden = YES;
        
        return;
    }    
    
    CGPoint pt = [panGr translationInView:self.baseView];
    CGFloat dx = pt.x;
    CGFloat viewWidth = CGRectGetWidth(self.baseView.frame);
    if (dx < 0) {
        CGFloat newWidth = viewWidth + dx;
        viewWidth = newWidth < 0 ? 0 : newWidth;
    }
    else if (dx > 0) {
        CGFloat newWidth = viewWidth - dx;
        viewWidth = newWidth > viewWidth ? viewWidth : newWidth;
    }    
    
    self.sliderIV.transform = CGAffineTransformMakeTranslation(dx, 0);
    
    // calculate size of frame based on slider location
    CGRect topRect = self.baseView.bounds;    
    topRect.size.width =  viewWidth;
    self.imageView.frame = topRect;      
}

- (void) resetMaps
{
    self.topView = nil;
    self.baseView = nil;
    
    [self.mainMapView removeMapLayerWithName:@"dynamic"];
    [self.mainMapView removeMapLayerWithName:@"results"];
    [self.mainMapView removeMapLayerWithName:@"Edit Layer"];
    [self.mainMapView removeMapLayerWithName:@"basemap transparent"];
    [self.mainMapView removeMapLayerWithName:@"dynamic rivers"];
    [self.mainMapView removeMapLayerWithName:@"My Graphics Layer"];    
    
    self.baseView = [self.mainMapView addMapLayer:self.dynamicLayer withName:@"dynamic"];
    
    if ( self.resultDynamicLayer != nil)
        self.topView = (AGSDynamicLayerView*)[self.mainMapView addMapLayer:self.resultDynamicLayer withName:@"results"];
    
    //
    // For debugging adds a border to see where the map bounds are
    //self.topView.layer.borderColor = [[UIColor blackColor] CGColor];
    //self.topView.layer.borderWidth = 5.0f;
    
    [self.mainMapView addMapLayer:self.editableFeatureLayer  withName:@"Edit Layer"];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //add the tile with transperancy on top
    NSURL *urlTiled = [NSURL URLWithString:[defaults objectForKey:@"basemap_preference"]];
    AGSTiledMapServiceLayer *tiled2 = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:urlTiled];
    UIView *transparentView = [self.mainMapView addMapLayer:tiled2 withName:@"basemap transparent"];
    transparentView.alpha = [[defaults objectForKey:@"slider_preference"] doubleValue];
    
    AGSDynamicMapServiceLayer *dynamicRivers = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:[NSURL URLWithString:[defaults objectForKey:@"rivermapservice_preference"]]]; 
    UIView *dynamicRiverView = [self.mainMapView addMapLayer:dynamicRivers withName:@"dynamic rivers"];
    dynamicRiverView.alpha = [[defaults objectForKey:@"slider_preference"] doubleValue];    
    
    if ( self.graphicsLayer != nil )
        [self.mainMapView addMapLayer:self.graphicsLayer withName:@"My Graphics Layer"];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);  
}


#pragma Sketch
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    if ( self.buttonStates == kState_None) 
        return;
    
    else if (self.buttonStates == kState_WatershedEnabled ) {
        // Check the user didn't click on top of a watershed first
        NSLog(@"graphics layers %@", graphics);
        if ( [graphics objectForKey:@"My Graphics Layer"] != nil ) 
        {
            NSArray *myGraphicsLayerGraphics = [graphics objectForKey:@"My Graphics Layer"];
            NSLog(@"graphics %@", myGraphicsLayerGraphics);
            if ( myGraphicsLayerGraphics.count > 0 )
            {
                AGSGraphic *waterShedPolygon = [myGraphicsLayerGraphics objectAtIndex:0];
                // Show the popup again
                [self showChartWithGraphic:waterShedPolygon];
                return;
            }
            else
                [self waterShedTap:screen mapPoint:mappoint graphics:graphics];
        }
        else {
            // run the watershed
            [self waterShedTap:screen mapPoint:mappoint graphics:graphics];
        }
    }    
    else if ( self.buttonStates == kState_CollectEnabled ) {
        AGSGraphic* newGraphic = nil;
        self.lastScreen = screen;        
        // add feature and edit the properties
        if ( self.editableFeatureLayer.types.count > 0 ) {
            AGSFeatureType* featureType = [self.editableFeatureLayer.types objectAtIndex:0];  
            newGraphic = [self.editableFeatureLayer featureWithType:featureType];
        }
        else {            
            //PB_ICP40
            AGSGraphic *first = [self.editableFeatureLayer.graphics objectAtIndex:0];
            // copy the feature
            NSDictionary *jsonDic = [first encodeToJSON];
            AGSGraphic *copiedGraphic = [[AGSGraphic alloc] initWithJSON:jsonDic];
            copiedGraphic.geometry = mappoint;
            
            [copiedGraphic.attributes removeObjectForKey:@"OBJECTID"];
            
            EditGraphicViewController *edit = [[EditGraphicViewController alloc] initWithNibName:@"EditGraphicViewController" bundle:nil];
            edit.delegate = self;
            
            edit.graphic = copiedGraphic;
            edit.editableFeatureLayer = self.editableFeatureLayer;
            edit.attributeToEdit = @"PB_ICP40";
            edit.addedFeaturesArray = self.addedFeaturesArray;
            
            self.popup = [[UIPopoverController alloc] 
                          initWithContentViewController:edit]; 
            
            self.popup.popoverContentSize = CGSizeMake(300, 140);
            
            [self.popup presentPopoverFromRect:CGRectMake(self.lastScreen.x, self.lastScreen.y, 100, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }    
    }    
       
}

#pragma Tap and Hold

- (void) waterShedTap:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    self.lastScreen = screen;
    [self showSwirlyProcess];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    // get the map point and call the other gp to do the watershed    
    NSURL* url = [NSURL URLWithString: [defaults objectForKey:@"watershed_preference"]];
    self.geoprocessWaterShed = [AGSGeoprocessor geoprocessorWithURL:url];
    self.geoprocessWaterShed.delegate = self;
    
    AGSGraphic *graphic = [[AGSGraphic alloc] init];
    graphic.geometry = mappoint;
    NSLog(@"Watershed mappoint %@", mappoint);
    
    NSArray *features = [NSArray arrayWithObjects:graphic, nil ];
    
    AGSFeatureSet *featureSet = [[AGSFeatureSet alloc] init];
    featureSet.features = features;
    
    AGSGPParameterValue *initPoint = [AGSGPParameterValue parameterWithName:@"Watersehd_Point" type:AGSGPParameterTypeFeatureRecordSetLayer value:featureSet]; 
    
    NSArray *params = [NSArray arrayWithObjects:initPoint,nil];
    self.geoprocessWaterShed.outputSpatialReference = self.mainMapView.spatialReference;
    
    [self.geoprocessWaterShed executeWithParameters:params];
}


- (void) finishedEditing:(AGSGraphic*)returnGraphic
{
    [self.popup dismissPopoverAnimated:YES];
}


//First button pressed
-(IBAction)callCollect:(id)sender
{
    [self changeImages:kState_CollectEnabled];
}

//Second button pressed
-(IBAction)callWatershedCollect:(id)sender
{
    [self changeImages:kState_WatershedEnabled];
}

//Third button pressed
- (IBAction)callGPSurface:(id)sender
{
    [self changeImages:kState_SurfaceEnabled];    
    
    // Start the UI for processing
    [self showSwirlyProcess];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL* url = [NSURL URLWithString: [defaults objectForKey:@"gp_preference"]];
    self.geoprocess = [AGSGeoprocessor geoprocessorWithURL:url];
    self.geoprocess.delegate = self;
    
//  Just passing the extent can fail.
//    AGSPolygon *polygon = self.mainMapView.visibleArea ;
//    
//    AGSGraphic *graphic = [[AGSGraphic alloc] init];
//    graphic.geometry = polygon;
//    
//    NSArray *features = [NSArray arrayWithObjects:graphic, nil ];
//    
//    AGSFeatureSet *featureSet = [[AGSFeatureSet alloc] init];
//    featureSet.features = features;
//         
//    AGSGPParameterValue *extent = [AGSGPParameterValue parameterWithName:@"aoi" type:AGSGPParameterTypeFeatureRecordSetLayer value:featureSet]; 
//    
//    NSArray *params = [NSArray arrayWithObjects:extent,nil];
    //[self.geoprocess submitJobWithParameters:params];
    
    //
    // this will return the whole extent, is slower.
    [self.geoprocess submitJobWithParameters:nil];
}

- (void) changeImages:(ButtonStates)state
{
    self.buttonCollect.selected = NO;
    self.buttonSurface.selected = NO;
    self.buttonWaterShed.selected = NO;
    
    if ( state == kState_CollectEnabled)
        self.buttonCollect.selected = YES;
    else if ( state == kState_SurfaceEnabled)
        self.buttonSurface.selected = YES;
    else if ( state == kState_WatershedEnabled)
        self.buttonWaterShed.selected = YES;
    
    self.buttonStates = state;
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op jobDidSucceed:(AGSGPJobInfo*)jobInfo {
    [geoprocessor queryResultData:jobInfo.jobId paramName:@"Lead_Concentrations"];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didQueryWithResult:(AGSGPParameterValue*)result forJob:(NSString*)jobId {
    NSLog(@"Parameter: %@, Value: %@",result.name, result.value);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *urlForResults = [[NSString alloc] initWithFormat:@"%@%@", [defaults objectForKey:@"gp_preference"],[defaults objectForKey:@"gpjobs_preference"]];
    
    NSMutableString *createURL = [[NSMutableString alloc] init];
    [createURL appendString:urlForResults];
    [createURL appendString:jobId];
    [createURL appendString:[defaults objectForKey:@"serviceresults_preference"]];
    NSURL *url = [[NSURL alloc] initWithString:createURL];
   
    self.resultDynamicLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:url]; 
    [self resetMaps];
    
    self.imageView.hidden = NO;
    [self hideSwirlyProcess];
}


- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op jobDidFail:(AGSGPJobInfo*)jobInfo { 
    [self hideSwirlyProcess];
    NSLog(@"Error: %@",jobInfo.messages);

    //
    // Announce to the user the GP failed. Requires the user to dismiss the alert
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GP Failed" message:@"The GP returned failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //    [alert show];
}


- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didExecuteWithResults:(NSArray *)results messages:(NSArray *)messages
{
    NSLog(@"How many results are coming back? %d", results.count);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    for (AGSGPParameterValue* param in results) { 
        NSLog(@"DEBUG: param name %@ and value %@", param.name, param.value);
        // Use the Polygon for the next GP to get the graphic
        if ( [param.name isEqualToString:@"Watershed_Output"] == YES )
        {
            AGSFeatureSet *featureSetResults = param.value;
            if ( featureSetResults.features.count > 0 ) {
                self.lastWaterShedPolygon = [featureSetResults.features objectAtIndex:0];
                
                NSURL* url = [NSURL URLWithString:[defaults objectForKey:@"soilstats_preference"]];           
                self.geoprocessDetails = [AGSGeoprocessor geoprocessorWithURL:url];
                self.geoprocessDetails.delegate = self;
                               
                AGSGPParameterValue *initPoly = [AGSGPParameterValue parameterWithName:@"Area_of_Interest" type:AGSGPParameterTypeFeatureRecordSetLayer value:featureSetResults]; 
                
                NSArray *params = [NSArray arrayWithObjects:initPoly,nil];
                
                self.geoprocessDetails.outputSpatialReference = self.mainMapView.spatialReference;
                [self.geoprocessDetails executeWithParameters:params];
                return;
            }
        }
        
        else if ( [param.name isEqualToString:@"Lead_Stats"] == YES )
        {
            AGSFeatureSet *featureSetResults = param.value;
            if ( featureSetResults.features.count > 0 )
            {
                AGSGraphic *polyGraphic = [featureSetResults.features objectAtIndex:0];
                
                // Show the chart
                [self showChartWithGraphic:polyGraphic];  
                
                self.bZoomingToPolygon = YES;
                [self.mainMapView zoomToGeometry:polyGraphic.geometry withPadding:0.5 animated:YES];
                
                [self hideSwirlyProcess];
            }            
        }
        else {
            // Stop the animation
            NSLog(@"No values return in params %@", param);
            [self hideSwirlyProcess];            
        }
	}
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didFailExecuteWithError:(NSError*)error
{
    // @todo Here call a point that we know will work all the time
    
    NSLog(@"Execute with Errors %@", error);
    [self hideSwirlyProcess];
    
    // This is only when it fails, there are other times the polygon isn't coming back
    
    // Force to call it again
    // Only for debugging
//    AGSPoint *mappoint = [[AGSPoint alloc] initWithX:-10936227.813805 y:3569014.14398 spatialReference:self.mainMapView.spatialReference];
//    
//    CGPoint newPoint;
//    
//    [self waterShedTap:newPoint mapPoint:mappoint graphics:nil];
//    
}

- (void) showChartWithGraphic:(AGSGraphic *)polyGraphic
{
    if ( self.popup != nil ) {
        [self.popup dismissPopoverAnimated:YES];
    }
    
    NSString *mean = [polyGraphic.attributes objectForKey:@"MEAN"];
    
    [self.mainMapView removeMapLayerWithName:@"My Graphics Layer"];
    self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mainMapView addMapLayer:self.graphicsLayer withName:@"My Graphics Layer"];
    
    // display the polygon     
    AGSSimpleFillSymbol *fillSymbol =
    [AGSSimpleFillSymbol simpleFillSymbol];
    fillSymbol.color = [[UIColor blueColor] colorWithAlphaComponent:0.45];
    fillSymbol.outline.color = [UIColor blueColor];
    fillSymbol.outline.width = 4;
    // Add symbology
    polyGraphic.symbol = fillSymbol;
    
    [self.graphicsLayer addGraphic:polyGraphic];
    [self.graphicsLayer dataChanged];
    
    // plot it in a graphic                
    GraphViewController *graph = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
    graph.delegate = self;
    graph.valueForGraph = mean;
    
    self.popup = [[UIPopoverController alloc] 
                      initWithContentViewController:graph];  
    
    self.popup.popoverContentSize = CGSizeMake(320, 340);
    
    [self.popup presentPopoverFromRect:CGRectMake(self.lastScreen.x, self.lastScreen.y, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}



- (void) finished
{
    [self.popup dismissPopoverAnimated:YES];
}

- (void) showSwirlyProcess
{
    
    //Create the first status image and the indicator view
    UIImage *statusImage = [UIImage imageNamed:@"loading1.png"];
    self.activityImageView = [[UIImageView alloc] 
                                      initWithImage:statusImage];
    
    
    //Add more images which will be used for the animation
    self.activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"loading1.png"],
                                         [UIImage imageNamed:@"loading2.png"],
                                         [UIImage imageNamed:@"loading3.png"],
                                         [UIImage imageNamed:@"loading4.png"],
                                         [UIImage imageNamed:@"loading5.png"],
                                         [UIImage imageNamed:@"loading6.png"],
                                         [UIImage imageNamed:@"loading7.png"],
                                         [UIImage imageNamed:@"loading8.png"],
                                         nil];
    
    
    //Set the duration of the animation (play with it
    //until it looks nice for you)
    self.activityImageView.animationDuration = 0.8;
    
    
    //Position the activity image view somewhere in 
    //the middle of your current view
    self.activityImageView.frame = CGRectMake(
                                         (self.view.frame.size.width/2
                                         -statusImage.size.width/2) + 110, 
                                         (self.view.frame.size.height/2
                                         -statusImage.size.height/2) + 120, 
                                         statusImage.size.width, 
                                         statusImage.size.height);
    
    //Start the animation
    [self.activityImageView startAnimating];
    
    [self.view addSubview:self.activityImageView];    
    
}
- (void) hideSwirlyProcess
{
    [self changeImages:kState_None];
    [self.activityImageView stopAnimating];
    [self.activityImageView removeFromSuperview];
}

@end
