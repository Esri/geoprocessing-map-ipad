//
//  ViewController.m
//  UCDemoGP
//
//  Created by Al Pascual on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "applicationDefines.h"

@interface MapViewController ()<UIGestureRecognizerDelegate> {
}

@end




@implementation MapViewController

@synthesize mainMapView = _mainMapView;
@synthesize topView = _topView;
@synthesize editableFeatureLayer = _editableFeatureLayer;
@synthesize dynamicLayer = _dynamicLayer;
@synthesize sketch = _sketch;
@synthesize geoprocess = _geoprocess;
@synthesize resultDynamicLayer = _resultDynamicLayer;
@synthesize geoprocessWaterShed = _geoprocessWaterShed;
@synthesize lastWaterShedPolygon = _lastWaterShedPolygon;
@synthesize graphicsLayer = _graphicsLayer;
@synthesize geoprocessDetails = _geoprocessDetails;
@synthesize imageView = _imageView;
@synthesize originalTransform = _originalTransform;
@synthesize popup = _popup;
@synthesize lastScreen = _lastScreen;
@synthesize addedFeaturesArray = _addedFeaturesArray;
@synthesize activityImageView = _activityImageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init object states
    self.imageView.hidden = YES;
    
    self.mainMapView.layerDelegate = self;
    //xmin: -10979558.400620 ymin: 3521601.137391 xmax: -10815627.093085 ymax: 3632408.393633
    
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-10979558.4006204
                                                    ymin:3521601.137391
                                                    xmax:-10815627.093085
                                                    ymax:3632408.393633
                                        spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    [self.mainMapView zoomToEnvelope:env animated:YES];
    
    NSURL *url = [NSURL URLWithString:kBaseMapTiled];
    AGSTiledMapServiceLayer *tiled = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    [self.mainMapView addMapLayer:tiled withName:@"basemap"];
    
    // Real base map
    self.dynamicLayer = 
    [AGSDynamicMapServiceLayer  
    dynamicMapServiceLayerWithURL:[NSURL URLWithString:kBaseMapDynamicMapService]]; 
    self.dynamicLayer.visibleLayers = [[NSArray alloc] initWithObjects:@"1", nil];
    self.topView = [self.mainMapView addMapLayer:self.dynamicLayer withName:@"dynamic"];
    self.topView.alpha = kDynamicMapAlpha;
    
    // editable layer
    self.editableFeatureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:kSoilSampleFeatureService] mode:AGSFeatureLayerModeOnDemand];
    [self.mainMapView addMapLayer:self.editableFeatureLayer withName:@"Edit Layer"];
    
    
    self.mainMapView.touchDelegate = self;
    
    // Setting up the gesture
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panGR.minimumNumberOfTouches = 2;
    panGR.maximumNumberOfTouches = 3;
    panGR.delegate = self;
    [self.view addGestureRecognizer:panGR];
}

- (void)mapViewDidLoad:(AGSMapView *)mapView  {
       
    // register for "MapDidEndPanning" notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnvChange:)
                                                 name:@"MapDidEndPanning" object:nil];
    
    // register for "MapDidEndZooming" notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnvChange:) 
                                                 name:@"MapDidEndZooming" object:nil];
    
}

- (void)respondToEnvChange: (NSNotification*) notification {
    AGSEnvelope *env = [self.mainMapView.visibleArea envelope];
    if ( env != nil ) { 
        NSLog(@"xmin: %f ymin: %f xmax: %f ymax: %f", env.xmin, env.ymin, env.xmax, env.ymax);
        
        //self.topView = [self.mainMapView.mapLayerViews objectForKey:@"results"];
        
        
    }
}

- (void)panned:(id)sender {
    
    // No results no need to let the user compare
    if ( self.resultDynamicLayer == nil )
        return;
    
    UIPanGestureRecognizer *panGr = (UIPanGestureRecognizer*)sender;
    if (panGr.state == UIGestureRecognizerStateEnded) {

        // @todo - save some state here in regards to dynamic layer's current width
        // requirement, reset the map
        [self.mainMapView removeMapLayerWithName:@"results"];
        [self.mainMapView removeMapLayerWithName:@"Edit Layer"];
        
        self.topView = [self.mainMapView addMapLayer:self.resultDynamicLayer withName:@"results"];
        self.topView.alpha = kDynamicMapAlpha;
        [self.mainMapView addMapLayer:self.editableFeatureLayer  withName:@"Edit Layer"];
        self.imageView.transform = self.originalTransform;
        return;
    }
    else if ( panGr.state == UIGestureRecognizerStateBegan) {
        self.originalTransform = self.imageView.transform;
    }    
    
    CGPoint newPoint = [panGr translationInView:self.view];
    
    CGFloat dx = newPoint.x ;
    // Add x the movement on the image
    self.imageView.transform = CGAffineTransformMakeTranslation(dx, 0);
    
    CGFloat width = 0;
    if (dx < 0) {
        CGFloat newWidth = CGRectGetWidth(self.mainMapView.frame) + dx;
        width = newWidth < 0 ? 0 : newWidth;
        
    }
    else if (dx > 0) {
        CGFloat newWidth = CGRectGetWidth(self.mainMapView.frame) - dx;
        width = newWidth > CGRectGetWidth(self.mainMapView.frame) ? CGRectGetWidth(self.mainMapView.frame) : newWidth;
    }
    NSLog(@"width: %f dx: %f", width, dx);
    [self toggleShowingBasemaps:width];
    
    
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

- (void)toggleShowingBasemaps:(CGFloat)width
{   
    CGRect mapRect = self.topView.frame;
    
    [self.topView setContentMode:UIViewContentModeLeft | UIViewContentModeScaleAspectFill];
    [self.topView setClipsToBounds:YES];
    
    mapRect.size.width =  width;
    
    self.topView.frame = mapRect;
    
    
}

#pragma Sketch
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    AGSGraphic* newGraphic = nil;
    self.lastScreen = screen;
    
    // TODO add feature and edit the properties
    if ( self.editableFeatureLayer.types.count > 0 ) {
        AGSFeatureType* featureType = [self.editableFeatureLayer.types objectAtIndex:0];  
        newGraphic = [self.editableFeatureLayer featureWithType:featureType];
    }
    else {
        
        //PB_ICP40
        AGSGraphic *first = [self.editableFeatureLayer.graphics objectAtIndex:0];
        // TODO, copy the feature
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
        
        self.popup.popoverContentSize = CGSizeMake(320, 140);
        
        [self.popup presentPopoverFromRect:CGRectMake(self.lastScreen.x, self.lastScreen.y, 100, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    
       
}

- (void) finishedEditing:(AGSGraphic*)returnGraphic
{
    [self.popup dismissPopoverAnimated:YES];
}

- (IBAction)callGP:(id)sender
{
    // Start the UI for processing
    [self showSwirlyProcess];
    
    NSURL* url = [NSURL URLWithString: kGPUrlForMapService];
    self.geoprocess = [AGSGeoprocessor geoprocessorWithURL:url];
    self.geoprocess.delegate = self;
    // Input parameter
    
    AGSPolygon *polygon = self.mainMapView.visibleArea ;
    
    AGSGraphic *graphic = [[AGSGraphic alloc] init];
    graphic.geometry = polygon;
    
    NSArray *features = [NSArray arrayWithObjects:graphic, nil ];
    
    AGSFeatureSet *featureSet = [[AGSFeatureSet alloc] init];
    featureSet.features = features;
         
    AGSGPParameterValue *extent = [AGSGPParameterValue parameterWithName:@"aoi" type:AGSGPParameterTypeFeatureRecordSetLayer value:featureSet]; 
    
    NSArray *params = [NSArray arrayWithObjects:extent,nil];
    
    [self.geoprocess submitJobWithParameters:params];
    [self.geoprocess submitJobWithParameters:nil];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op jobDidSucceed:(AGSGPJobInfo*)jobInfo {
    [geoprocessor queryResultData:jobInfo.jobId paramName:@"Lead_Concentrations"];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didQueryWithResult:(AGSGPParameterValue*)result forJob:(NSString*)jobId {
    NSLog(@"Parameter: %@, Value: %@",result.name, result.value);
    
    NSString *urlForResults = [[NSString alloc] initWithFormat:@"%@%@", kGPUrlForMapService,kGPUrlForMapServiceJobs];
    
    NSMutableString *createURL = [[NSMutableString alloc] init];
    [createURL appendFormat:urlForResults];
    [createURL appendFormat:jobId];
    [createURL appendFormat:kGPUrlForMapServiceResults];
    NSURL *url = [[NSURL alloc] initWithString:createURL];
    
    AGSGPRasterData *raster = result.value;
    [self.mainMapView removeMapLayerWithName:@"results"];
    [self.mainMapView removeMapLayerWithName:@"Edit Layer"];
    self.resultDynamicLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:url]; 
    NSLog(@"URL %@",raster.URL);
    self.topView = [self.mainMapView addMapLayer:self.resultDynamicLayer withName:@"results"];
    self.topView.alpha = kDynamicMapAlpha;
    
    [self.mainMapView addMapLayer:self.editableFeatureLayer  withName:@"Edit Layer"];
    
    self.imageView.hidden = NO;
    [self hideSwirlyProcess];
}


- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op jobDidFail:(AGSGPJobInfo*)jobInfo { 
    NSLog(@"Error: %@",jobInfo.messages);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GP Failed" message:@"The GP returned failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma Tap and Hold
- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    self.lastScreen = screen;
    [self showSwirlyProcess];
    
    // @todo get the map point and call the other gp to do the watershed    
    NSURL* url = [NSURL URLWithString: kWaterShedGP];
    self.geoprocessWaterShed = [AGSGeoprocessor geoprocessorWithURL:url];
    self.geoprocessWaterShed.delegate = self;
    
    AGSGraphic *graphic = [[AGSGraphic alloc] init];
    graphic.geometry = mappoint;
    
    NSArray *features = [NSArray arrayWithObjects:graphic, nil ];
    
    AGSFeatureSet *featureSet = [[AGSFeatureSet alloc] init];
    featureSet.features = features;
    
    AGSGPParameterValue *initPoint = [AGSGPParameterValue parameterWithName:@"Watersehd_Point" type:AGSGPParameterTypeFeatureRecordSetLayer value:featureSet]; 
    
    NSArray *params = [NSArray arrayWithObjects:initPoint,nil];
    self.geoprocessWaterShed.outputSpatialReference = self.mainMapView.spatialReference;
    
    [self.geoprocessWaterShed executeWithParameters:params];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didExecuteWithResults:(NSArray *)results messages:(NSArray *)messages
{
    NSLog(@"How many results are coming back? %d", results.count);
    
    for (AGSGPParameterValue* param in results) { 
        // Use the Polygon for the next GP to get the graphic
        if ( [param.name isEqualToString:@"Watershed_Output"] == YES )
        {
            AGSFeatureSet *featureSetResults = param.value;
            if ( featureSetResults.features.count > 0 ) {
                self.lastWaterShedPolygon = [featureSetResults.features objectAtIndex:0];
                
                NSURL* url = [NSURL URLWithString: kSoilStatsGP];           
                self.geoprocessDetails = [AGSGeoprocessor geoprocessorWithURL:url];
                self.geoprocessDetails.delegate = self;
                               
                AGSGPParameterValue *initPoly = [AGSGPParameterValue parameterWithName:@"Area_of_Interest" type:AGSGPParameterTypeFeatureRecordSetLayer value:featureSetResults]; 
                
                NSArray *params = [NSArray arrayWithObjects:initPoly,nil];
                
                self.geoprocessDetails.outputSpatialReference = self.mainMapView.spatialReference;
                [self.geoprocessDetails executeWithParameters:params];
                return;
            }
        }
        
        if ( [param.name isEqualToString:@"Lead_Stats"] == YES )
        {
            AGSFeatureSet *featureSetResults = param.value;
            if ( featureSetResults.features.count > 0 )
            {
                AGSGraphic *polyGraphic = [featureSetResults.features objectAtIndex:0];
                
                NSString *mean = [polyGraphic.attributes objectForKey:@"MEAN"];
                
                [self.mainMapView removeMapLayerWithName:@"My Graphics Layer"];
                self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
                [self.mainMapView addMapLayer:self.graphicsLayer withName:@"My Graphics Layer"];
                
                // display the polygon     
                AGSSimpleFillSymbol *fillSymbol =
                [AGSSimpleFillSymbol simpleFillSymbol];
                fillSymbol.color = [[UIColor purpleColor] colorWithAlphaComponent:0.25];
                fillSymbol.outline.color = [UIColor darkGrayColor];
                // Add symbology
                polyGraphic.symbol = fillSymbol;
                
                [self.graphicsLayer addGraphic:polyGraphic];
                [self.graphicsLayer dataChanged];
                
                // plot it in a graphic                
                GraphViewController *graph = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];
                graph.delegate = self;
                graph.valueForGraph = mean;
                               
                [self hideSwirlyProcess];
                                
                self.popup = [[UIPopoverController alloc] 
                                            initWithContentViewController:graph];     
                
                self.popup.popoverContentSize = CGSizeMake(320, 340);
                
                [self.popup presentPopoverFromRect:CGRectMake(self.lastScreen.x, self.lastScreen.y, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                
                
            }            
        }
	}
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didFailExecuteWithError:(NSError*)error
{
    NSLog(@"Execute with Errors %@", error);
    [self hideSwirlyProcess];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GP Failed" message:@"No data to process here" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
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
    [self.activityImageView stopAnimating];
    [self.activityImageView removeFromSuperview];
}

@end
