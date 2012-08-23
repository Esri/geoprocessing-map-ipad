//
//  EditGraphicViewController.h

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
