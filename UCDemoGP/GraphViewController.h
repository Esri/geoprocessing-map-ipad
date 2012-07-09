//
//  GraphViewController.h
//  UCDemoGP
//
//  Created by Al Pascual on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphDelegate <NSObject>

- (void) finished;

@end

@interface GraphViewController : UIViewController

@property (nonatomic,strong) NSString *valueForGraph;
@property (nonatomic,strong) id <GraphDelegate> delegate;

@end
