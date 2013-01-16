//
//  TimerGameAppDelegate.h
//  TimerGame
//
//  Created by Matthew Palmer on 16/01/13.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerGameViewController;

@interface TimerGameAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TimerGameViewController *viewController;

@end
