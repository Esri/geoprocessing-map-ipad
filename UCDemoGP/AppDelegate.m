//
//  AppDelegate.m
//  UCDemoGP
//
//  Created by Al Pascual on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MapViewController.h"
#import "applicationDefines.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize addedFeaturesArray = _addedFeaturesArray;
@synthesize cleanUpProcess = cleanUpProcess;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self becomeFirstResponder];
    
    // To keep track of the features
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.addedFeaturesArray forKey:@"featuresToDelete"];
    
    if ( [defaults objectForKey:@"featuresToDelete"] != nil ) {
        self.addedFeaturesArray  = [defaults objectForKey:@"featuresToDelete"];
    }
    else
    {    
        self.addedFeaturesArray = [[NSMutableArray alloc] init];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    
    // Passing the array to keep track
    self.viewController.addedFeaturesArray = self.addedFeaturesArray;
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // delete all the graphics in the array using a feature     
    if ( self.addedFeaturesArray.count > 0 ) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.addedFeaturesArray forKey:@"featuresToDelete"];
        [defaults synchronize];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.type == UIEventSubtypeMotionShake)
    {   
        self.cleanUpProcess = [[CleanUpProcess alloc] init];
        self.cleanUpProcess.editableFeatureLayer = self.viewController.editableFeatureLayer;
        
        if ( self.addedFeaturesArray.count > 0 ) {
            [self.cleanUpProcess cleanUp:self.addedFeaturesArray]; 
        }
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
