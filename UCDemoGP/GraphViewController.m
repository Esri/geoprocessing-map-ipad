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

#define BAR_POSITION @"POSITION"
#define BAR_HEIGHT @"HEIGHT"
#define COLOR @"COLOR"
#define CATEGORY @"CATEGORY"

#define AXIS_START 0
#define AXIS_END 30

@implementation GraphViewController

@synthesize valueForGraph = _valueForGraph;
@synthesize delegate = _delegate;
@synthesize graph = _graph;
@synthesize graphHost = _graphHost;
@synthesize chartValuesArray = _chartValuesArray;
@synthesize chartLabelArray = _chartLabelArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)generateBarPlot
{
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];	
	self.graph.frame						  = self.view.bounds;    
    self.graphHost.hostedGraph			= self.graph;
    
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = 20.0f;
    self.graph.plotAreaFrame.paddingRight = 20.0f;
    self.graph.plotAreaFrame.paddingBottom = 70.0f;
    self.graph.plotAreaFrame.paddingLeft = 55.0f;
    
    //set axes ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat((AXIS_END - AXIS_START)+5)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat((AXIS_END - AXIS_START)+5)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    //set axes' title, labels and their text styles
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 14;
    textStyle.color = [CPTColor blackColor];
    
    axisSet.xAxis.title = @"";
    axisSet.yAxis.title = @"PPM";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = 1.0f;
    axisSet.yAxis.titleOffset = 35.0f;
    /*axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 3.0f;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 3.0f;*/
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 3.0f;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(135.0f);
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(17.0f);
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = -5.0f;
    axisSet.yAxis.minorTickLength = 5.0f;
    
    // Create bar plot and add it to the graph
    CPTBarPlot *plot = [[CPTBarPlot alloc] init] ;
    
    plot.dataSource = self;
    plot.delegate = self;
    plot.barWidth = [[NSDecimalNumber decimalNumberWithString:@"8.5"]
                     decimalValue];
    plot.barOffset = [[NSDecimalNumber decimalNumberWithString:@"10.0"]
                      decimalValue];
    plot.barCornerRadius = 5.0;
    // Remove bar outlines
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor clearColor];
    plot.lineStyle = borderLineStyle;
    // Identifiers are handy if you want multiple plots in one graph
    plot.identifier = @"chocoplot";
    [self.graph addPlot:plot];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Texas Average: 10.34
    //US Average: 23.97
    self.chartValuesArray = [NSMutableArray array];
    
    int bar_heights[] = {[self.valueForGraph intValue],10.34,23.97};
    UIColor *colors[] = {
        [UIColor blueColor],
        [UIColor colorWithRed:1/255.0
                        green:1/255.0
                         blue:50/255.0
                        alpha:1.0],
        [UIColor colorWithRed:1/255.0
                        green:1/255.0
                         blue:50/255.0
                        alpha:1.0]};
    
    NSString *categories[] = {@"Actual", @"Texas", @"US"};
    
    for (int i = 0; i < 3 ; i++){
        double position = i*10; //Bars will be 10 pts away from each other
        double height = bar_heights[i];
        
        NSDictionary *bar = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithDouble:position],BAR_POSITION,
                             [NSNumber numberWithDouble:height],BAR_HEIGHT,
                             colors[i],COLOR,
                             categories[i],CATEGORY,
                             nil];
        [self.chartValuesArray addObject:bar];
        
    }

    [self generateBarPlot];

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

- (IBAction)donePressed:(id)sender
{
    [self.delegate finished];
}

// Delegate

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot.identifier isEqual:@"chocoplot"] )
        return self.chartValuesArray.count;
    
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSLog(@"Requesting fieldNumber %d for index %d", fieldEnum, index);
    
    if ( [plot.identifier isEqual:@"chocoplot"] )
    {
        NSDictionary *bar = [self.chartValuesArray objectAtIndex:index];
        
        if(fieldEnum == CPTBarPlotFieldBarLocation)
            return [bar valueForKey:BAR_POSITION];
        else if(fieldEnum ==CPTBarPlotFieldBarTip)
            return [bar valueForKey:BAR_HEIGHT];
       
    }
    return [NSNumber numberWithFloat:0];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual: @"chocoplot"] )
    {
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontName = @"Helvetica";
        textStyle.fontSize = 14;
        textStyle.color = [CPTColor blackColor];
        
        NSDictionary *bar = [self.chartValuesArray objectAtIndex:index];
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@", [bar valueForKey:@"CATEGORY"]]];
        label.textStyle =textStyle;
        
        return label;
    }
    
    CPTTextLayer *defaultLabel = [[CPTTextLayer alloc] initWithText:[NSString stringWithString:@"Label"]];
    return defaultLabel;
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    if ( [barPlot.identifier isEqual:@"chocoplot"] )
    {
        NSDictionary *bar = [self.chartValuesArray objectAtIndex:index];
        CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor]
                                                            endingColor:[bar valueForKey:@"COLOR"]
                                                      beginningPosition:0.0 endingPosition:0.3 ];
        [gradient setGradientType:CPTGradientTypeAxial];
        [gradient setAngle:320.0]; 
        
        CPTFill *fill = [CPTFill fillWithGradient:gradient];
        
        return fill;
        
    }
    return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
}



@end
