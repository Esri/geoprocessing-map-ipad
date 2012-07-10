//
//  GraphViewController.h
//  UCDemoGP
//
//  Created by Al Pascual on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PowerPlot.h"

@protocol GraphDelegate <NSObject>

- (void) finished;

@end

@interface GraphViewController : UIViewController <WSControllerGestureDelegate>

@property (nonatomic,strong) NSString *valueForGraph;
@property (nonatomic,strong) id <GraphDelegate> delegate;

@property (nonatomic, retain) WSData *barData;
@property (nonatomic, retain) IBOutlet WSChart *electionChart;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;

@end
