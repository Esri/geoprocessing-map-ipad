//
//  EditGraphicViewController.m
//  UCDemoGP
//
//  Created by Al Pascual on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditGraphicViewController.h"

@interface EditGraphicViewController ()

@end

@implementation EditGraphicViewController

@synthesize editableFeatureLayer = _editableFeatureLayer;
@synthesize graphic = _graphic;
@synthesize attributeToEdit = _attributeToEdit;
@synthesize textField = _textField;
@synthesize delegate = _delegate;

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
    
    // Is it ready to edit?
    //[self.mainMapView showCalloutAtPoint:(AGSPoint*)copiedGraphic.geometry forGraphic:copiedGraphic animated:YES];
    
    /*
     
     newGraphic = [[AGSGraphic alloc] initWithGeometry:mappoint symbol:myMarkerSymbol attributes:nil infoTemplateDelegate:nil];*/
}

@end
