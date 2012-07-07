//
//  ViewController.m
//  UCDemoGP
//
//  Created by Al Pascual on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<UIGestureRecognizerDelegate> {
}

@end


// Map Services used
#define kBaseMapDynamicMapService @"http://ne2k864:6080/arcgis/rest/services/lead/MapServer"
#define kSoilSampleFeatureService @"http://ne2k864:6080/arcgis/rest/services/SoilSamplePoints/FeatureServer/0"
#define kGPUrlForMapService @"http://ne2k864:6080/arcgis/rest/services/InterpolateLead/GPServer/InterpolateLead"

#define kWaterShedGP @"http://ne2k864:6080/arcgis/rest/services/Watershed/GPServer/Watershed"

@implementation MapViewController

@synthesize mainMapView = _mainMapView;
@synthesize topView = _topView;
@synthesize editableFeatureLayer = _editableFeatureLayer;
@synthesize dynamicLayer = _dynamicLayer;
@synthesize sketch = _sketch;
@synthesize geoprocess = _geoprocess;
@synthesize resultDynamicLayer = _resultDynamicLayer;
@synthesize geoprocessWaterShed = _geoprocessWaterShed;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainMapView.layerDelegate = self;
    //xmin: -10979558.400620 ymin: 3521601.137391 xmax: -10815627.093085 ymax: 3632408.393633
    
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-10979558.4006204
                                                    ymin:3521601.137391
                                                    xmax:-10815627.093085
                                                    ymax:3632408.393633
                                        spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    [self.mainMapView zoomToEnvelope:env animated:YES];
    
    AGSOpenStreetMapLayer *osm = [[AGSOpenStreetMapLayer alloc] init];
    [self.mainMapView addMapLayer:osm withName:@"basemap"];
    
    // Real base map
    self.dynamicLayer = 
    [AGSDynamicMapServiceLayer  
    dynamicMapServiceLayerWithURL:[NSURL URLWithString:kBaseMapDynamicMapService]]; 
    self.dynamicLayer.visibleLayers = [[NSArray alloc] initWithObjects:@"1", nil];
    self.topView = [self.mainMapView addMapLayer:self.dynamicLayer withName:@"dynamic"];
    
    // editable layer
    self.editableFeatureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:kSoilSampleFeatureService] mode:AGSFeatureLayerModeOnDemand];
    [self.mainMapView addMapLayer:self.editableFeatureLayer withName:@"Edit Layer"];
    
    
    self.mainMapView.touchDelegate = self;
    
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panGR.minimumNumberOfTouches = 3;
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
        [self.mainMapView addMapLayer:self.editableFeatureLayer  withName:@"Edit Layer"];
        return;
    }
    
    CGPoint newPoint = [panGr translationInView:self.view];
    
    CGFloat dx = newPoint.x ;
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
        
        edit.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:edit animated:YES];        
        
    }
    
       
}

- (void) finishedEditing:(AGSGraphic*)returnGraphic
{
    //@todo Add it into sketch layer if you have to
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)callGP:(id)sender
{
    NSURL* url = [NSURL URLWithString: kGPUrlForMapService];
    self.geoprocess = [AGSGeoprocessor geoprocessorWithURL:url];
    self.geoprocess.delegate = self;
    // Input parameter
    
    AGSPolygon *polygon = self.mainMapView.visibleArea ;
    /*AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
    AGSPolygon *projectedPolygon = (AGSPolygon*)[engine projectGeometry:polygon toSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4267]];*/
    
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
    
    NSMutableString *createURL = [[NSMutableString alloc] init];
    [createURL appendFormat:@"http://ne2k864:6080/arcgis/rest/services/InterpolateLead/GPServer/InterpolateLead/jobs/"];
    [createURL appendFormat:jobId];
    [createURL appendFormat:@"/results/Lead_Concentrations"];
    NSURL *url = [[NSURL alloc] initWithString:createURL];
    
    AGSGPRasterData *raster = result.value;
    [self.mainMapView removeMapLayerWithName:@"results"];
    [self.mainMapView removeMapLayerWithName:@"Edit Layer"];
    self.resultDynamicLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:url]; 
    NSLog(@"URL %@",raster.URL);
    self.topView = [self.mainMapView addMapLayer:self.resultDynamicLayer withName:@"results"];
    
    [self.mainMapView addMapLayer:self.editableFeatureLayer  withName:@"Edit Layer"];
}


- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op jobDidFail:(AGSGPJobInfo*)jobInfo { 
    NSLog(@"Error: %@",jobInfo.messages);
}

#pragma Tap and Hold
- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
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
    
    [self.geoprocessWaterShed executeWithParameters:params];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didExecuteWithResults:(NSArray *)results messages:(NSArray *)messages
{
    // @todo grab the polygon and use it for the 
    //http://ne2k864:6080/arcgis/rest/services/SoilStats/GPServer/SoilStats

}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation*)op didFailExecuteWithError:(NSError*)error
{
    NSLog(@"Execute with Errors %@", error);
}

@end
