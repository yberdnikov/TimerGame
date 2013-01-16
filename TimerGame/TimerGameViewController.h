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
    double accumulativeTimeElapsed;
    double dateRounded;
    double dateToTheSecond;
    double dateDifference;
    NSDate *timeWhenStartPushed;
    NSDate *timeWhenStopPushed;
    NSTimeInterval dateToBeDisplayed;
    float totalScore;
    int totalStreak;
    int superStreak;
}
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)startTimer:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
- (IBAction)shareScore:(id)sender;
@end
