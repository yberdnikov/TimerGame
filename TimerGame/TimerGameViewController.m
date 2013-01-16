//
//  TimerGameViewController.m
//  TimerGame
//
//  Created by Matthew Palmer on 16/01/13.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "TimerGameViewController.h"

@interface TimerGameViewController ()

@end

@implementation TimerGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_timeLabel setText:@"Press Start"];
    
    totalScore = 1.00;
    totalStreak = 0;
    running=false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTime
{
    if (running == false) {
        return;
    }
    float f = -3.04299553323;
    
    float r = roundf (f * 100) / 100.0;
    NSLog(@"%f",r);
    printf ("%.2f, %.10f\n", r, r);
    
    
    NSDate *currentTime = [NSDate date];
    
    dateToBeDisplayed = [currentTime timeIntervalSinceDate:timeWhenStartPushed]+accumulativeTimeElapsed;
    
    dateRounded = round(dateToBeDisplayed*100)/100;
    dateToTheSecond = round(dateToBeDisplayed);
    dateDifference = round((dateRounded-dateToTheSecond)*100)/100;
    NSLog(@"dateround is %f",dateRounded);
    NSLog(@"datetothe second is %f",dateToTheSecond);
    NSLog(@"datdifference is %f",dateDifference);
    
    NSLog(@"datetobedislayed is %f",dateToBeDisplayed);
    [_timeLabel setText:[NSString stringWithFormat:@"%.2f",dateRounded]];
   
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.01];
    
}

- (IBAction)startTimer:(UIButton *)sender {
    if (running==false) {
        running=true;
        timeWhenStartPushed = [NSDate date];
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        [self updateTime];
        [_scoreLabel setText:[NSString stringWithFormat:@"%.2fs",totalScore]];
    } else {
        [sender setTitle:@"START" forState:UIControlStateNormal];
        timeWhenStopPushed = [NSDate date];
        accumulativeTimeElapsed += [timeWhenStopPushed timeIntervalSinceDate:timeWhenStartPushed];
        NSLog(@"cumulativetimeelapsed is %f",accumulativeTimeElapsed);
        totalStreak += 1;
        [_streakLabel setText:[NSString stringWithFormat:@"%d",totalStreak]];
        if (dateDifference>0) {
            totalScore -= dateDifference;
        } else if (dateDifference<0) {
            totalScore += dateDifference;
        } else {
            NSLog(@"EXACTLY on!");
            superStreak = superStreak+1;
        }
        
        [_scoreLabel setText:[NSString stringWithFormat:@"%.2fs",totalScore]];
        
        if (totalScore<=0) {
            [sender setTitle:@"RESTART" forState:UIControlStateNormal];
            NSLog(@"ran out of score");
            accumulativeTimeElapsed = 0;
            totalScore = 1.00;
            totalStreak = 0;
            
        }
        
        running = false;
    }
}
@end
