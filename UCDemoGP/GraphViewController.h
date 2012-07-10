//
//  GraphViewController.h
//  UCDemoGP
//
//  Created by Al Pascual on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "CorePlot-CocoaTouch.h"
#import "ColoredBarChart.h"

@protocol GraphDelegate <NSObject>

- (void) finished;

@end

@interface GraphViewController : UIViewController <CPTPlotDataSource>

@property (nonatomic,strong) NSString *valueForGraph;
@property (nonatomic,strong) id <GraphDelegate> delegate;
@property (nonatomic,strong) CPTGraph *graph;
@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphHost;
@property (nonatomic,strong) NSMutableArray *chartValuesArray;
@property (nonatomic,strong) NSMutableArray *chartLabelArray;

- (void)generateBarPlot;

@end
