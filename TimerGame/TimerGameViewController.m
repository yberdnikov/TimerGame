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
    
 /*   PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    */
    [_timeLabel setText:@"0.00"];
    [_shareButton setAlpha:0.0];
    [_highScoreButton setAlpha:0.0];
    query = [PFQuery queryWithClassName:@"GameScore"];
    query.limit = 20;
    [query whereKey:@"score" greaterThan:[NSNumber numberWithInt:0]];
    [query orderByDescending:@"score"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            NSLog(@"something is %@",[objects valueForKey:@"score"]);
            NSLog(@"the object is %@",objects);
            _arrayOfScores = [[NSMutableArray alloc]init];
            _arrayOfNames = [[NSMutableArray alloc]init];
           // [_arrayOfScores addObject:[objects valueForKey:@"playerName"]];
            NSLog(@"array of scores is %@",_arrayOfScores);
            for (PFObject *player in objects) {
                PFObject *name = [player objectForKey:@"playerName"];
                PFObject *score = [player objectForKey:@"score"];
                NSLog(@"this is the test for %@",name);
                [_arrayOfNames addObject:name];
                [_arrayOfScores addObject:score];
                NSLog(@"this is the array test %@",_arrayOfNames);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

    
    
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
    [_highScoreButton setAlpha:0.0];
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
            [UIView commitAnimations];
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
    [highScoreView setBackgroundColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0]];

    [highScoreView setAlpha:0.0];
    
    firstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 340, 320, 210) style:UITableViewStylePlain];
    [firstTableView setDelegate:self];
    [firstTableView setDataSource:self];
    [firstTableView setBackgroundColor:[UIColor colorWithRed:33.0/255.0 green:55.0/255.0 blue:101.0/255.0 alpha:1.0]];
    [firstTableView setSeparatorColor:[UIColor clearColor]];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10.0, 10.0, 50.0, 30.0)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:74.0/255.0 green:142.0/255.0 blue:120.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeMyView:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *globalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 270, 320, 70)];
    [globalLabel setText:@"Global High Scores"];
    [globalLabel setBackgroundColor:[UIColor colorWithRed:33.0/255.0 green:55.0/255.0 blue:101.0/255.0 alpha:1.0]];
    [globalLabel setTextColor:[UIColor colorWithRed:94.0/255.0 green:151.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [globalLabel setFont:[UIFont systemFontOfSize:22.0]];
    
    
    UILabel *highScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 170)];
    [highScoreLabel setText:[NSString stringWithFormat:@"%d",totalAfterStreak]];
    [highScoreLabel setTextColor:[UIColor colorWithRed:74.0/255.0 green:142.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [highScoreLabel setBackgroundColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0]];
    [highScoreLabel setFont:[UIFont systemFontOfSize:136.0]];
    [highScoreLabel setTextAlignment:NSTextAlignmentCenter];
    
    addScoreTextField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 190.0, 320.0, 80.0)];
    [addScoreTextField setText:@"Your Name"];
    [addScoreTextField setBackgroundColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0]];
    [addScoreTextField setTextColor:[UIColor colorWithRed:74.0/255.0 green:142.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [addScoreTextField setTextAlignment:NSTextAlignmentCenter];
    
    [addScoreTextField setDelegate:self];
    [addScoreTextField setFont:[UIFont systemFontOfSize:38.0]];
    [addScoreTextField setReturnKeyType:UIReturnKeyGo];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    addScoreTextField.leftView = paddingView;
    addScoreTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    //[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0]];
    //[UIColor colorWithRed:74.0/255.0 green:142.0/255.0 blue:120.0/255.0 alpha:1.0]
    /*
    UIButton *saveMyScoreButton = [[UIButton alloc]initWithFrame:CGRectMake(80.0, 230.0, 240.0, 40.0)];
    [saveMyScoreButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveMyScoreButton setBackgroundColor:[UIColor colorWithRed:74.0/255.0 green:142.0/255.0 blue:120.0/255.0 alpha:1.0]];
    [saveMyScoreButton setTitleColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [saveMyScoreButton addTarget:self action:@selector(saveScore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeHighScoresButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 230.0, 80.0, 40.0)];
    [removeHighScoresButton setTitle:@"Close" forState:UIControlStateNormal];
    
    [removeHighScoresButton setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:105.0/255.0 blue:127.0/255.0 alpha:1.0]];
    [removeHighScoresButton setTitleColor:[UIColor colorWithRed:160.0/255.0 green:23.0/255.0 blue:26.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [removeHighScoresButton setUserInteractionEnabled:YES];
    [removeHighScoresButton addTarget:self action:@selector(closeMyView:) forControlEvents:UIControlEventTouchUpInside];
    */
    [highScoreView addSubview:backButton];
    [highScoreView addSubview:globalLabel];
    [highScoreView addSubview:highScoreLabel];
  //  [highScoreView addSubview:saveMyScoreButton];
  //  [highScoreView addSubview:removeHighScoresButton];
    [highScoreView addSubview:addScoreTextField];
    [highScoreView addSubview:firstTableView];
    //setBackgroundColor:[UIColor colorWithRed:160.0/255.0 green:218.0/255.0 blue:169.0/255.0 alpha:1.0]];
    //setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:105.0/255.0 blue:127.0/255.0 alpha:1.0]];
    [highScoreView addSubview:backButton];
    [[self view]addSubview:highScoreView];
    [UIView animateWithDuration:0.5
                     animations:^ {
                         [highScoreView setAlpha:1.0];
                     }
     ];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self saveScore:textField];
    NSLog(@"players name is %@",playersName);
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setText:@""];
    return YES;
}
-(IBAction)closeMyView:(id)sender
{
    NSLog(@"%@",[sender superview]);
    [addScoreTextField resignFirstResponder];
    [UIView animateWithDuration:0.3
                     animations:^ {
                         [[sender superview] setAlpha:0.0];
                         //[[sender superview]removeFromSuperview];
                     }
     ];
    
    
}
-(IBAction)saveScore:(id)sender
{
    NSLog(@"PRESESEDED");
    playersName = [addScoreTextField text];
    if (playersName) {
    
    PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
    [gameScore setObject:[NSNumber numberWithInt:totalAfterStreak] forKey:@"score"];
    [gameScore setObject:playersName forKey:@"playerName"];
    [gameScore save];
        [self closeMyView:sender];
    } else {
        NSLog(@"enter a name idiot");
    }
    
    
    
    
}

#pragma mark - TableView DataSource Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayOfScores count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    
    // Configure the cell...
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[_arrayOfScores objectAtIndex:indexPath.row]];
    [[cell detailTextLabel]setTextColor:[UIColor colorWithRed:94.0/255.0 green:151.0/255.0 blue:255.0/255.0 alpha:0.8]];
    NSLog(@"array of names from tvc is %@", [_arrayOfNames objectAtIndex:[indexPath row]]);
    [[cell textLabel]setText:[_arrayOfNames objectAtIndex:[indexPath row]]];
    [[cell textLabel]setTextColor:[UIColor colorWithRed:94.0/255.0 green:151.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    return cell;
    
} 


@end
