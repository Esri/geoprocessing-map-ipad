//
//  EditGraphicViewController.h
//  UCDemoGP
//
//  Created by Al Pascual on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@protocol EditGraphicDelegate <NSObject>

- (void) finishedEditing:(AGSGraphic*)returnGraphic;

@end

@interface EditGraphicViewController : UIViewController <AGSFeatureLayerEditingDelegate>

@property (nonatomic,strong) AGSFeatureLayer *editableFeatureLayer;
@property (nonatomic,strong) AGSGraphic *graphic;
@property (nonatomic,strong) NSString *attributeToEdit;
@property (nonatomic,strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *addedFeaturesArray;

@property (nonatomic,strong) id <EditGraphicDelegate> delegate;

@end
