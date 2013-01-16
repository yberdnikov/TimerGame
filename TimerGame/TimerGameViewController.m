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
    [_timeLabel setText:@"0:00.00"];
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
    
    NSDate *currentTime = [NSDate date];
    
    NSTimeInterval dateToBeDisplayed = [currentTime timeIntervalSinceDate:timeWhenStartPushed]+accumulativeTimeElapsed;
    
    NSLog(@"datetobedislayed is %f",dateToBeDisplayed);
    [_timeLabel setText:[NSString stringWithFormat:@"%f",dateToBeDisplayed]];
   
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.01];
}

- (IBAction)startTimer:(UIButton *)sender {
    if (running==false) {
        running=true;
        timeWhenStartPushed = [NSDate date];
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        [self updateTime];
    } else {
        [sender setTitle:@"START" forState:UIControlStateNormal];
        timeWhenStopPushed = [NSDate date];
        accumulativeTimeElapsed += [timeWhenStopPushed timeIntervalSinceDate:timeWhenStartPushed];
        NSLog(@"cumulativetimeelapsed is %f",accumulativeTimeElapsed);
        running = false;
    }
}
@end
