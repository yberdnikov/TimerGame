//
//  TimerGameViewController.h
//  TimerGame
//
//  Created by Matthew Palmer on 16/01/13.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerGameViewController : UIViewController
{
    bool running;
    NSDate *timeWhenStartPushed;
    NSDate *timeWhenStopPushed;
    double accumulativeTimeElapsed;
    
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)startTimer:(UIButton *)sender;

@end
