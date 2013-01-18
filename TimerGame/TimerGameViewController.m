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
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    
    [_timeLabel setText:@"0.00"];
    [_shareButton setAlpha:0.0];
    //[_highScoreButton setAlpha:0.0];
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [sender setTitle:@"GO" forState:UIControlStateNormal];
    [_shareButton setAlpha:0.0];
    [UIView commitAnimations];
    [_scoreLabel setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:105.0/255.0 blue:127.0/255.0 alpha:1.0]];
    
    if (running==false) {
        running=true;
        timeWhenStartPushed = [NSDate date];
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        [self updateTime];
        [_scoreLabel setText:[NSString stringWithFormat:@"%.2fs",totalScore]];
        [_streakLabel setText:[NSString stringWithFormat:@"%d",totalStreak]];
    } else {
        
        timeWhenStopPushed = [NSDate date];
        accumulativeTimeElapsed += [timeWhenStopPushed timeIntervalSinceDate:timeWhenStartPushed];
        NSLog(@"cumulativetimeelapsed is %f",accumulativeTimeElapsed);
        totalStreak += 1;
        [_streakLabel setText:[NSString stringWithFormat:@"%d",totalStreak]];
        UILabel *scoreDrop = [[UILabel alloc]initWithFrame:CGRectMake(180.0, 80.0, 120.0, 120.0)];
        [scoreDrop setBackgroundColor:[UIColor clearColor]];
        [scoreDrop setTextColor:[UIColor redColor]];
        
        [[self view]addSubview:scoreDrop];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [scoreDrop setFrame:CGRectMake(180.0, 240.0, 120.0, 120.0)];
        [scoreDrop setAlpha:0.0];
        if (dateDifference<0) {
            totalScore += dateDifference;
            [scoreDrop setText:[NSString stringWithFormat:@"%.2f",dateDifference]];
            [UIView commitAnimations];
            
            
        }  else if (dateDifference>0) {
            [scoreDrop setText:[NSString stringWithFormat:@"-%.2f",dateDifference]];
            totalScore -= dateDifference;
            [UIView commitAnimations];
        } else {
            NSLog(@"EXACTLY on!");
            superStreak = superStreak+1;
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [scoreDrop setText:@"+1.0"];
            [scoreDrop setFont:[UIFont boldSystemFontOfSize:34.0]];
            [scoreDrop setTextColor:[UIColor greenColor]];
            
            [_scoreLabel setBackgroundColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0]];
            totalScore += 1.0;
          }
        
        [_scoreLabel setText:[NSString stringWithFormat:@"%.2fs",totalScore]];
        
        if (totalScore<=0) {
            [sender setTitle:@"Play Again" forState:UIControlStateNormal];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.02];
            [UIView setAnimationDelay:0.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [sender setTitle:@"PLAY AGAIN" forState:UIControlStateNormal];
            //[_shareButton setAlpha:1.0];
            
            [UIView commitAnimations];
            
            
            
            [UIView animateWithDuration:1.0
                             animations:^ {
                                 [_shareButton setAlpha:1.0];
                                 [_highScoreButton setAlpha:1.0];
                             }
             ];
            
            
            NSLog(@"ran out of score");
            accumulativeTimeElapsed = 0;
            totalScore = 1.00;
            totalAfterStreak = totalStreak;
            totalStreak = 0;
            
        }
        
        running = false;
    }
}
- (IBAction)shareScore:(id)sender {
    NSLog(@"SHARE BUTTON TAPPED");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    [_shareButton setAlpha:0.0];
    [UIView commitAnimations];
    
    NSString *someText = [NSString stringWithFormat:@"I got a score of %d on <<NAME>>. Get it on the app store <<LINK>>",totalAfterStreak];
    
    
    
    NSArray *dataToShare = @[someText];
    
    NSLog(@"send post called");
    
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
    totalStreak = 0;
    
}
-(void)highScores
{
    
}

- (IBAction)goHighScores:(id)sender {
    NSLog(@"HIGH scORE Tapped");
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    UIView *highScoreView = [[UIView alloc]initWithFrame:screenBounds];
    [highScoreView setBackgroundColor:[UIColor blackColor]];
    [highScoreView setAlpha:0.0];
    
    UILabel *highScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 80, 30)];
    [highScoreLabel setText:[NSString stringWithFormat:@"%d",totalAfterStreak]];
    [highScoreLabel setTextColor:[UIColor greenColor]];
    [highScoreLabel setBackgroundColor:[UIColor clearColor]];
    
    UITextField *addScoreTextField = [[UITextField alloc]initWithFrame:CGRectMake(20.0, 20.0, 220.0, 30.0)];
    [addScoreTextField setPlaceholder:@"Your Name"];
    [addScoreTextField setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:218.0/255.0 blue:219.0/255.0 alpha:1.0]];
    [addScoreTextField setTextColor:[UIColor blueColor]];
    [addScoreTextField setDelegate:self];
    
    UIButton *saveMyScoreButton = [[UIButton alloc]initWithFrame:CGRectMake(120.0, 120.0, 60.0, 40.0)];
    [saveMyScoreButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveMyScoreButton addTarget:self action:@selector(saveScore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeHighScoresButton = [[UIButton alloc]initWithFrame:CGRectMake(200.0, 200.0, 140.0, 59.0)];
    [removeHighScoresButton setTitle:@"Close" forState:UIControlStateNormal];
    [removeHighScoresButton setBackgroundColor:[UIColor whiteColor]];
    [removeHighScoresButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [removeHighScoresButton setUserInteractionEnabled:YES];
    [removeHighScoresButton addTarget:self action:@selector(closeMyView:) forControlEvents:UIControlEventTouchUpInside];
    
    [highScoreView addSubview:highScoreLabel];
    [highScoreView addSubview:saveMyScoreButton];
    [highScoreView addSubview:removeHighScoresButton];
    [highScoreView addSubview:addScoreTextField];
    //setBackgroundColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0]];
    //setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:105.0/255.0 blue:127.0/255.0 alpha:1.0]];
    
    [[self view]addSubview:highScoreView];
    [UIView animateWithDuration:1.0
                     animations:^ {
                         [highScoreView setAlpha:1.0];
                     }
     ];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)closeMyView:(id)sender
{
    NSLog(@"%@",[sender superview]);
    
    [UIView animateWithDuration:1.0
                     animations:^ {
                         [[sender superview] setAlpha:0.0];
                         //[[sender superview]removeFromSuperview];
                     }
     ];
    
    
}
-(IBAction)saveScore:(id)sender
{
    NSLog(@"PRESESEDED");
    [self closeMyView:sender];
}

@end
