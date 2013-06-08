//
//  TimerGameAppDelegate.m
//  TimerGame
//
//  Created by Matthew Palmer on 16/01/13.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "TimerGameAppDelegate.h"
#import <Parse/Parse.h>
#import "TimerGameViewController.h"
//#import <Crashlytics/Crashlytics.h>
@implementation TimerGameAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"eEJugQdj0uXCKJ0ar3YEnK5VLOPkqqquVDAvWgkZ"
                  clientKey:@"n0kUP35DkjJXxs8lQSNCkNp6BWmUFqqB8gIuLOQs"];
    //[Crashlytics startWithAPIKey:@"fa7be0281dd292bb1ebe46cd38f473b465aaaf62"];
    
    if(result.height == 1136){
        NSLog(@"iPhone5");
        //storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
        //UIViewController *initViewController = [storyBoard instantiateInitialViewController];
        //[self.window setRootViewController:initViewController];
        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        self.viewController = [[TimerGameViewController alloc] initWithNibName:@"TimerGameViewController-iPhone5" bundle:nil];
        [self.window setRootViewController:self.viewController];
        [self.window makeKeyAndVisible];
        return YES;
    }
    else {
        NSLog(@"iPhone with 3.5 inch");
        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        self.viewController = [[TimerGameViewController alloc] initWithNibName:@"TimerGameViewController-iPhone4" bundle:nil];
        [self.window setRootViewController:self.viewController];
        [self.window makeKeyAndVisible];
        return YES;
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
