//
//  TimerGameViewController.h
//  TimerGame
//
//  Created by Matthew Palmer on 16/01/13.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <Social/Social.h>
#import <Parse/Parse.h>

@interface TimerGameViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    bool running;
    double accumulativeTimeElapsed;
    double dateRounded;
    double dateToTheSecond;
    double dateDifference;
    NSDate *timeWhenStartPushed;
    NSDate *timeWhenStopPushed;
    NSTimeInterval dateToBeDisplayed;
    NSString *playersName;
    float totalScore;
    int totalStreak;
    int superStreak;
    int totalAfterStreak;
    UITableView *firstTableView;
    PFQuery *query;
    UITextField *addScoreTextField;
   
}
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)startTimer:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
- (IBAction)shareScore:(id)sender;
-(void)highScores;
- (IBAction)goHighScores:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *highScoreButton;

@property (strong, nonatomic) NSMutableArray *arrayOfScores;
@property (strong, nonatomic) NSMutableArray *arrayOfNames;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
@end
