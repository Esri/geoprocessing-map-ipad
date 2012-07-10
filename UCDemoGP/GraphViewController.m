//
//  GraphViewController.m
//  UCDemoGP
//
//  Created by Al Pascual on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

@synthesize valueForGraph = _valueForGraph;
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

    // Replicate the starting chart from the "ElectionBars" example.
    //self.barData = [[DemoData electionResults2009] indexedData];
    WSChart *aChart = [WSChart barPlotWithFrame:[self.view bounds]
                                           data:self.barData
                                      barColors:[NSArray
                                                 arrayWithObjects:[UIColor CSSColorBlack],
                                                 [UIColor CSSColorYellow],
                                                 [UIColor CSSColorRed],
                                                 [UIColor CSSColorGreen],
                                                 [UIColor CSSColorTeal],
                                                 [UIColor CSSColorGray], nil]
                                          style:kChartBarPlain
                                    colorScheme:kColorWhite];
    [self.electionChart addPlotsFromChart:aChart];
    [self.electionChart scaleAllAxisYD:NARangeMake(-10, 45)];
    [self.electionChart setAllAxisLocationXD:-0.5];
    [self.electionChart setAllAxisLocationYD:0];
    WSPlotBar *bar = (WSPlotBar *)[[self.electionChart plotAtIndex:0] view];
    [bar setValue:[UIColor blackColor]
       forKeyPath:@"dataDelegate.dataD.values.customDatum.outlineColor"];
    WSPlotAxis *axis = [self.electionChart firstPlotAxis];
    [[axis ticksX] setTicksStyle:kTicksLabels];
    [[axis ticksY] setTicksStyle:kTicksLabels];
    [[axis ticksY] ticksWithNumbers:[NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0],
                                     [NSNumber numberWithFloat:10],
                                     [NSNumber numberWithFloat:20],
                                     [NSNumber numberWithFloat:30],
                                     nil]
                             labels:[NSArray arrayWithObjects:@"",
                                     @"10%", @"20%", @"30%", nil]];
    [self.electionChart setChartTitle:NSLocalizedString(@"Bundestagselection 2009", @"")];
    
    // Configure the single tap feature.
    WSPlotController *aCtrl = [self.electionChart plotAtIndex:0];
    aCtrl.tapEnabled = YES;
    aCtrl.delegate = self;
    aCtrl.hitTestMethod = kHitTestX;
    aCtrl.hitResponseMethod = kHitResponseDatum;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)donePressed:(id)sender
{
    [self.delegate finished];
}

@end
