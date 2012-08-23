//
//  EditGraphicViewController.m

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

#import "EditGraphicViewController.h"

@interface EditGraphicViewController ()

@end

@implementation EditGraphicViewController

@synthesize editableFeatureLayer = _editableFeatureLayer;
@synthesize graphic = _graphic;
@synthesize attributeToEdit = _attributeToEdit;
@synthesize textField = _textField;
@synthesize delegate = _delegate;
@synthesize addedFeaturesArray = _addedFeaturesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.editableFeatureLayer.editingDelegate = self;
    
    // the cursor to the textbox 
    [self.textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)donePressed:(id)sender {
    
    [self.graphic.attributes setObject:self.textField.text forKey:self.attributeToEdit];
    
    AGSSimpleMarkerSymbol *myMarkerSymbol =
    [AGSSimpleMarkerSymbol simpleMarkerSymbol];
    myMarkerSymbol.color = [UIColor blueColor];
    self.graphic.symbol = myMarkerSymbol;
    
    NSArray *features = [[NSArray alloc] initWithObjects:self.graphic, nil];
    [self.editableFeatureLayer addFeatures:features];
    [self.editableFeatureLayer refresh];
    
    [self.delegate finishedEditing:self.graphic];    
    
}

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFeatureEditsWithResults:(AGSFeatureLayerEditResults *)editResults
{
    
    if([editResults.addResults count]>0){
        //we were adding a new feature
        AGSEditResult* result = (AGSEditResult*)[editResults.addResults objectAtIndex:0];
        if(!result.success){
            NSLog(@"Could not add feature. Please try again");
        }
        
        else {
            // Add the feature to keep track and delete when the app finish
            [self.addedFeaturesArray addObject:[NSNumber numberWithInteger:result.objectId]];
        }
    }
}

@end
