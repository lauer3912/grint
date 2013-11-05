//
//  LeaderboardCentralViewController.m
//  grint
//
//  Created by Peter Rocker on 14/05/2013.
//
//

#import "LeaderboardCentralViewController.h"
#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintActivityFeedItem.h"
#import "LeaderboardScore.h"
#import "GrintScore.h"
#import "GrintBReviewScore.h"
#import "GrintBNewReviewScore.h"
#import "Flurry.h"

#import "Communication.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "GPSUseGuideController.h"

#define STR_PURCHASE_MESSAGE_PREFIX @"PURCHASE_SINGLE"

@interface LeaderboardCentralViewController ()

@property (nonatomic, retain) IBOutlet UIView* rankingView;
@property (nonatomic, retain) IBOutlet UIView* commentsView;
@property (nonatomic, retain) IBOutlet UIView* detailsView;
@property (nonatomic, retain) IBOutlet UIView* scoreView;

@property (nonatomic, retain) IBOutlet UILabel* labelLeaderboardName;
@property (nonatomic, retain) IBOutlet UILabel* labelGolfCourse;
@property (nonatomic, retain) IBOutlet UILabel* labelTeeBox;
@property (nonatomic, retain) IBOutlet UILabel* labelDate;
@property (nonatomic, retain) IBOutlet UILabel* labelPlayers;
@property (nonatomic, retain) IBOutlet UILabel* labelPasscode;
@property (nonatomic, retain) IBOutlet UILabel* labelOrganiser;
@property (nonatomic, retain) IBOutlet UIView* bgView;
@property (nonatomic, retain) IBOutlet UILabel* label1;
@property (nonatomic, retain) IBOutlet UILabel* label2;
@property (nonatomic, retain) IBOutlet UILabel* label3;
@property (nonatomic, retain) IBOutlet UILabel* label4;
@property (nonatomic, retain) IBOutlet UILabel* label5;
@property (nonatomic, retain) IBOutlet UILabel* label6;
@property (nonatomic, retain) IBOutlet UILabel* label7;
@property (nonatomic, retain) IBOutlet UILabel* label8;
@property (nonatomic, retain) IBOutlet UITextField* textFieldComment;
@property (nonatomic, retain) IBOutlet UITableView* tableViewComment;
@property (nonatomic, retain) IBOutlet UITableView* tableViewScore;
@property (nonatomic, retain) IBOutlet UILabel* labelHoleNo;
@property (nonatomic, retain) IBOutlet UILabel* labelHoleParYds;
@property (nonatomic, retain) IBOutlet UILabel* labelScore;
@property (nonatomic, retain) IBOutlet UILabel* labelPutts;
@property (nonatomic, retain) IBOutlet UILabel* labelPenalty;
@property (nonatomic, retain) IBOutlet UILabel* labelFairway;
@property (nonatomic, retain) IBOutlet UILabel* labelAvgScore;
@property (nonatomic, retain) IBOutlet UILabel* labelAvgPutts;
@property (nonatomic, retain) IBOutlet UILabel* labelAvgPenalty;
@property (nonatomic, retain) IBOutlet UILabel* labelTeeAccuracy;
@property (nonatomic, retain) IBOutlet UILabel* labelAvgGir;
@property (nonatomic, retain) IBOutlet UILabel* labelGrints;
@property (nonatomic, retain) IBOutlet UIPickerView* picker1;
@property (nonatomic, retain) IBOutlet UILabel* labelStrokesSoFar;
@property (nonatomic, retain) IBOutlet UILabel* labelScoreSoFar;
@property (nonatomic, retain) IBOutlet UIView* highlightView;
@property (nonatomic, retain) IBOutlet UIButton* buttonEnterScore;
@property (nonatomic, retain) IBOutlet UIButton* buttonEnterRanking;
@property (nonatomic, retain) IBOutlet UIButton* buttonEnterComments;
@property (nonatomic, retain) IBOutlet UIButton* buttonEnterDetails;
@property (nonatomic, retain) IBOutlet UIButton* buttonEnter;
@property (nonatomic, retain) IBOutlet UILabel* deetsTitle;
@property (nonatomic, retain) IBOutlet UILabel* labelRankedTitle;
@property (nonatomic, retain) IBOutlet UIButton* buttonRankGross;
@property (nonatomic, retain) IBOutlet UIButton* buttonRankNet;
@property (nonatomic, retain) IBOutlet UIButton* buttonRankOver;

@property (nonatomic, retain) NSArray* pickerData;
@property (nonatomic, retain) NSArray* scores;
@property NSInteger currentHole;
@property NSInteger holeToMoveTo;

@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSMutableData* data;

@property (nonatomic, retain) NSMutableArray* commentRows;
@property (nonatomic, retain) NSMutableArray* scoreRows;

@property (nonatomic, retain) NSString* scoreID;

@property (nonatomic, retain) NSDateFormatter* dateFormatter;
@property (nonatomic, retain) NSDateFormatter* friendlyDateFormatter;

@property BOOL isShowingScore;
@property BOOL isShowingSortSelector;

@end

@implementation LeaderboardCentralViewController

@synthesize holeID, m_strHoleYards;
@synthesize scores, pickerData, labelScore, labelPutts, labelPenalty, labelPlayers, currentHole, holeOffset, labelFairway, putts, penalties, accuracy, score, holeToMoveTo;

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end forString:(NSString*) string {
    NSRange startRange = [string rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [string length] - targetRange.location;
        NSRange endRange = [string rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [string substringWithRange:targetRange];
        }
    }
    return nil;
}


- (void)emboldenTitle:(UILabel*)theTitle{
    
    [_label5 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label6 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label7 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label8 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    
    [theTitle setFont:[UIFont fontWithName:@"Oswald" size:16.0]];
    
}


- (IBAction)rankOver:(UIButton*)sender{
    
    if(!_isShowingSortSelector){
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             CGRect dest = _buttonRankGross.frame;
                             dest.origin.y += dest.size.height + 5;
                             _buttonRankGross.frame = dest;
                             
                             
                             CGRect dest2 = _buttonRankNet.frame;
                             dest2.origin.y += dest2.size.height * 2 + 10;
                             _buttonRankNet.frame = dest2;
                         }
                         completion:^(BOOL finished){
                             
                         }];
        _isShowingSortSelector = YES;
        
    }
    else{
    
    NSArray *sortedArray;
    sortedArray = [_scoreRows sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber* first = [NSNumber numberWithInt:[(LeaderboardScore*)a over]];
        NSNumber *second = [NSNumber numberWithInt:[(LeaderboardScore*)b over]];
        if([(LeaderboardScore*)b thru] == 0){
            return NSOrderedAscending;
        }
        else if([(LeaderboardScore*)a thru] == 0){
            return NSOrderedDescending;
        }
        return [first compare:second];
    }];
    [_scoreRows removeAllObjects];
    _scoreRows = nil;
    _scoreRows = [[NSMutableArray alloc]initWithArray:sortedArray];
    [_tableViewScore reloadData];
    
    [self emboldenTitle:_label5];
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationCurveEaseOut
                             animations:^{
                                 CGRect dest = _buttonRankGross.frame;
                                 dest.origin.y -= dest.size.height+5;
                                 _buttonRankGross.frame = dest;
                                 
                                 
                                 CGRect dest2 = _buttonRankNet.frame;
                                 dest2.origin.y -= dest2.size.height * 2 + 10;
                                 _buttonRankNet.frame = dest2;

                             }
                             completion:^(BOOL finished){
                                 
                             }];

        _isShowingSortSelector = NO;
    [self.rankingView bringSubviewToFront:sender];
        
    }
}

- (IBAction)rankGross:(UIButton*)sender{
    
    if(!_isShowingSortSelector){
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             CGRect dest = _buttonRankGross.frame;
                             dest.origin.y += dest.size.height + 5;
                             _buttonRankGross.frame = dest;
                             
                             
                             CGRect dest2 = _buttonRankNet.frame;
                             dest2.origin.y += dest2.size.height * 2 + 10;
                             _buttonRankNet.frame = dest2;


                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        _isShowingSortSelector = YES;
    }
    else{
    NSArray *sortedArray;
    sortedArray = [_scoreRows sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber* first = [NSNumber numberWithInt:[(LeaderboardScore*)a gross]];
        NSNumber *second = [NSNumber numberWithInt:[(LeaderboardScore*)b gross]];
        if([(LeaderboardScore*)b thru] == 0){
            return NSOrderedAscending;
        }
        else if([(LeaderboardScore*)a thru] == 0){
            return NSOrderedDescending;
        }
        return [first compare:second];
    }];
    [_scoreRows removeAllObjects];
    _scoreRows = nil;
    _scoreRows = [[NSMutableArray alloc]initWithArray:sortedArray];
    [_tableViewScore reloadData];
    [_tableViewScore reloadData];
    
    [self emboldenTitle:_label6];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             CGRect dest = _buttonRankGross.frame;
                             dest.origin.y -= dest.size.height + 5;
                             _buttonRankGross.frame = dest;
                             
                             
                             CGRect dest2 = _buttonRankNet.frame;
                             dest2.origin.y -= dest2.size.height * 2 + 10;
                             _buttonRankNet.frame = dest2;


                         }
                         completion:^(BOOL finished){
                             
                         }];
        _isShowingSortSelector = NO;
    [self.rankingView bringSubviewToFront:sender];
        
    }
}

- (IBAction)rankNet:(UIButton*)sender{
    
    if(!_isShowingSortSelector){
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             CGRect dest = _buttonRankGross.frame;
                             dest.origin.y += dest.size.height + 5;
                             _buttonRankGross.frame = dest;
                             
                             
                             CGRect dest2 = _buttonRankNet.frame;
                             dest2.origin.y += dest2.size.height * 2 + 10;
                             _buttonRankNet.frame = dest2;
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
        _isShowingSortSelector = YES;
    }
    else{
    NSArray *sortedArray;
    sortedArray = [_scoreRows sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber* first = [NSNumber numberWithInt:[(LeaderboardScore*)a net]];
        NSNumber *second = [NSNumber numberWithInt:[(LeaderboardScore*)b net]];
        if([(LeaderboardScore*)b thru] == 0){
            return NSOrderedAscending;
        }
        else if([(LeaderboardScore*)a thru] == 0){
            return NSOrderedDescending;
        }

        return [first compare:second];
    }];
    [_scoreRows removeAllObjects];
    _scoreRows = nil;
    _scoreRows = [[NSMutableArray alloc]initWithArray:sortedArray];
    [_tableViewScore reloadData];
    [_tableViewScore reloadData];

        [self emboldenTitle:_label7];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             CGRect dest = _buttonRankGross.frame;
                             dest.origin.y -= dest.size.height + 5;
                             _buttonRankGross.frame = dest;
                             
                             
                             CGRect dest2 = _buttonRankNet.frame;
                             dest2.origin.y -= dest2.size.height * 2 + 10;
                             _buttonRankNet.frame = dest2;
                         }
                         completion:^(BOOL finished){
                             
                         }];
        _isShowingSortSelector = NO;
    [self.rankingView bringSubviewToFront:sender];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return NO;
    
}


- (CGFloat)tableView:(UITableView*) tableView  heightForRowAtIndexPath:(NSIndexPath*)indexPath{

    if(tableView == _tableViewComment){
        return 85.0f;
    }
    else{
        return 45.0f;
    }
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == _tableViewComment){
        [[[UIAlertView alloc]initWithTitle:((GrintActivityFeedItem*)[_commentRows objectAtIndex:indexPath.row]).title message:((GrintActivityFeedItem*)[_commentRows objectAtIndex:indexPath.row]).subTitle delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _tableViewComment){
    if([_commentRows count] < 1){
        return 0;
    }
    
    return [_commentRows count];
    }
    else if (tableView == _tableViewScore){
        return [_scoreRows count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _tableViewComment){
    
    static NSString *CellIdentifier = @"Cell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            UIImage* dummyImage = [UIImage imageNamed:@"grint_logo_114"];
            cell.imageView.image = dummyImage;
            cell.imageView.hidden = YES;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 75.0,75.0)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = 1;
            imageView.image = dummyImage;
            [cell addSubview:imageView];
            
            cell.detailTextLabel.numberOfLines = 3;
            
            UILabel* labelDate = [[UILabel alloc]initWithFrame:CGRectMake(235, 0, 85, 30)];
            labelDate.font = [UIFont systemFontOfSize:10];
            labelDate.tag = 2;
            labelDate.numberOfLines = 2;
            labelDate.textAlignment = NSTextAlignmentRight;
            [cell addSubview:labelDate];
            
            UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(94, 10, 150, 20)];
            labelTitle.font = [UIFont boldSystemFontOfSize:16];
            labelTitle.tag = 3;
            [cell addSubview:labelTitle];
            
            [cell bringSubviewToFront:labelDate];
            
        }
        
        cell.textLabel.text = @" ";
        
        if([_commentRows count] > 0){
        
        ((UILabel*)[cell viewWithTag:3]).text = ((GrintActivityFeedItem*)[_commentRows objectAtIndex:indexPath.row]).title;
        ((UILabel*)[cell viewWithTag:2]).text = [self.friendlyDateFormatter stringFromDate:[self.dateFormatter dateFromString:((GrintActivityFeedItem*)[_commentRows objectAtIndex:indexPath.row]).date]];
        cell.detailTextLabel.text = ((GrintActivityFeedItem*)[_commentRows objectAtIndex:indexPath.row]).subTitle;
        ((UIImageView*)[cell viewWithTag:1]).image = ((GrintActivityFeedItem*)[_commentRows objectAtIndex:indexPath.row]).thumbnail;
        }
        else{
            ((UIImageView*)[cell viewWithTag:1]).image = nil;

        }
        return cell;
        
    }
    
    else if (tableView == _tableViewScore){
        static NSString *CellIdentifier = @"Cell2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            
            UIImage* dummyImage = [UIImage imageNamed:@"grint_logo_114"];
            cell.imageView.image = dummyImage;
            cell.imageView.hidden = YES;
            
            UILabel* rankTextView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
            rankTextView.tag = 1;
            rankTextView.textAlignment = UITextAlignmentCenter;
            rankTextView.font = [UIFont fontWithName:@"Oswald" size:16];
            rankTextView.backgroundColor = [UIColor clearColor];
            [cell addSubview:rankTextView];
            
            cell.textLabel.textColor = [UIColor colorWithRed:0.16 green:0.35 blue:0.41 alpha:1.0];
            cell.textLabel.font = [UIFont fontWithName:@"Oswald" size:14];
            cell.textLabel.backgroundColor = [UIColor clearColor];

            UILabel* textView1 = [[UILabel alloc]initWithFrame:CGRectMake(_label5.frame.origin.x, 0, _label5.frame.size.width, cell.frame.size.height)];
            textView1.font = [UIFont fontWithName:@"Oswald" size:20];
            textView1.tag = 2;
            textView1.textAlignment = NSTextAlignmentCenter;
            textView1.backgroundColor = [UIColor clearColor];
            [cell addSubview:textView1];
            UILabel* textView2 = [[UILabel alloc]initWithFrame:CGRectMake(_label6.frame.origin.x, 0, _label6.frame.size.width, cell.frame.size.height)];
            textView2.font = [UIFont fontWithName:@"Oswald" size:14];
            textView2.tag = 3;
            textView2.textAlignment = NSTextAlignmentCenter;
            textView2.backgroundColor = [UIColor clearColor];
            [cell addSubview:textView2];
            UILabel* textView3 = [[UILabel alloc]initWithFrame:CGRectMake(_label7.frame.origin.x, 0, _label7.frame.size.width, cell.frame.size.height)];
            textView3.font = [UIFont fontWithName:@"Oswald" size:14];
            textView3.tag = 4;
            textView3.textAlignment = NSTextAlignmentCenter;
            textView3.backgroundColor = [UIColor clearColor];
            [cell addSubview:textView3];
            UILabel* textView4 = [[UILabel alloc]initWithFrame:CGRectMake(_label8.frame.origin.x, 0, _label8.frame.size.width, cell.frame.size.height)];
            textView4.font = [UIFont fontWithName:@"Oswald" size:14];
            textView4.tag = 5;
            textView4.textAlignment = NSTextAlignmentCenter;
            textView4.backgroundColor = [UIColor clearColor];
            [cell addSubview:textView4];
            
            
            
        }
        
        cell.textLabel.text = ((LeaderboardScore*)[_scoreRows objectAtIndex:indexPath.row]).player;
        
        ((UITextView*)[cell viewWithTag:1]).text = [self.class buildRankString: [NSNumber numberWithInt:indexPath.row + 1]];
        
        int over = ((LeaderboardScore*)[_scoreRows objectAtIndex:indexPath.row]).over;
        ((UITextView*)[cell viewWithTag:2]).text = (over < 0) ? [NSString stringWithFormat:@"%d", over] : [NSString stringWithFormat:@"+%d", over];
        ((UITextView*)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%d", ((LeaderboardScore*)[_scoreRows objectAtIndex:indexPath.row]).gross];
        int net =  ((LeaderboardScore*)[_scoreRows objectAtIndex:indexPath.row]).net;
        ((UITextView*)[cell viewWithTag:4]).text = (net < 0) ? [NSString stringWithFormat:@"%d", net] : [NSString stringWithFormat:@"+%d", net];
        ((UITextView*)[cell viewWithTag:5]).text = [NSString stringWithFormat:@"%d", ((LeaderboardScore*)[_scoreRows objectAtIndex:indexPath.row]).thru];
        
        if(indexPath.row % 2){
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        else{
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        }

        
        return cell;

    }
    
    return nil;
}

+ (NSString *)buildRankString:(NSNumber *)rank
{
    NSString *suffix = nil;
    int rankInt = [rank intValue];
    int ones = rankInt % 10;
    int tens = floor(rankInt / 10);
    tens = tens % 10;
    if (tens == 1) {
        suffix = @"th";
    } else {
        switch (ones) {
            case 1 : suffix = @"st"; break;
            case 2 : suffix = @"nd"; break;
            case 3 : suffix = @"rd"; break;
            default : suffix = @"th";
        }
    }
    NSString *rankString = [NSString stringWithFormat:@"%@%@", rank, suffix];
    return rankString;
}


- (IBAction)postComment:(id)sender{
    
    if(_textFieldComment.text.length > 0){
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/post_leaderboard_comment_iphone/"]];
    [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&leaderboard=%@&text=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardID, _textFieldComment.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        _data = [NSMutableData data];
    }
    
    _textFieldComment.text = @"";
    }
    [_textFieldComment resignFirstResponder];

    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            labelScore.text = [[pickerData objectAtIndex:0] objectAtIndex:row];
            ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:row];
            break;
        case 1:
            if(!labelPutts.hidden){
                labelPutts.text = [[pickerData objectAtIndex:1] objectAtIndex:row];
                ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:row];
            }
            break;
        case 2:
            if(!labelPenalty.hidden){
                if(row == 0){
                    labelPenalty.text = @"";
                    ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).penalty = @"";
                }
                else{
                    labelPenalty.text = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                    ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                }
            }
            break;
        case 3:
            if(!labelFairway.hidden){
                if([[[pickerData objectAtIndex:3] objectAtIndex:row] isEqualToString:@"Hit"]){
                    labelFairway.text = [[pickerData objectAtIndex:3] objectAtIndex:row];
                    ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:row];
                    
                }
                else{
                    labelFairway.text = [[[[pickerData objectAtIndex:3] objectAtIndex:row] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                    ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:row]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                }
            }
            break;
            
        default:
            break;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    CGRect frame = view.frame;
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    [pickerLabel setTextAlignment:UITextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    if(component == 0){
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    }
    else if(component == 1){
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        if(labelPutts.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }
    }
    else if(component == 2){
        
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        
        if(labelPenalty.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }
        
    }
    else{
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        if(labelFairway.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }
        
    }
    [pickerLabel setNumberOfLines:2];
    [pickerLabel setText:[[pickerData objectAtIndex:component] objectAtIndex:row]];
    
    
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [[pickerData objectAtIndex:component] count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [[pickerData objectAtIndex:component] objectAtIndex:row];
    
}


- (IBAction)showPicker:(id)sender{
    
    if(_picker1.isHidden){
        [_picker1 setHidden:NO];
        [self.view bringSubviewToFront:_picker1];
        [_buttonEnter setHidden:NO];
        [self.view bringSubviewToFront:_buttonEnter];
                
        labelScore.text = [[pickerData objectAtIndex:0] objectAtIndex:[_picker1 selectedRowInComponent:0]];
        ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:[_picker1 selectedRowInComponent:0]];
        
//        if(!labelPutts.hidden){
            labelPutts.text = [[pickerData objectAtIndex:1] objectAtIndex:[_picker1 selectedRowInComponent:1]];
            ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:[_picker1 selectedRowInComponent:1]];
//        }
        
        if(!labelPenalty.hidden){
            if([_picker1 selectedRowInComponent:2] == 0){
                labelPenalty.text = @"";
                ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).penalty = @"";
            }
            else{
                labelPenalty.text = [[[pickerData objectAtIndex:2] objectAtIndex:[_picker1 selectedRowInComponent:2]] substringToIndex:2];
                ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:[_picker1 selectedRowInComponent:2]] substringToIndex:2];
            }
        }
        
        if(!labelFairway.hidden){
            if([[[pickerData objectAtIndex:3] objectAtIndex:[_picker1 selectedRowInComponent:3]] isEqualToString:@"Hit"]){
                labelFairway.text = [[pickerData objectAtIndex:3] objectAtIndex:[_picker1 selectedRowInComponent:3]];
                ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:[_picker1 selectedRowInComponent:3]];
                
            }
            else{
                labelFairway.text = [[[[pickerData objectAtIndex:3] objectAtIndex:[_picker1 selectedRowInComponent:3]] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:[_picker1 selectedRowInComponent:3]]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
            }
        }
        
        
    }
    else{
        [_picker1 setHidden:YES];
        [_buttonEnter setHidden:YES];
    }
    
}


- (void)swipeRightDetected:(id)sender{
    
    if(currentHole > 0){
//        self.navigationController.navigationBar.hidden = NO;
            [self prevHole:sender];
    } else {
        //added code
//        self.navigationController.navigationBar.hidden = NO;
        [m_LocationManager stopUpdatingLocation];
        [self backIfPossible: nil];
    }
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in [event allTouches]) {
        int n = 1;
    }
}

- (IBAction)updateClick:(id)sender{

    self.navigationController.navigationBar.hidden = YES; //added code
    
    [self.view bringSubviewToFront:_scoreView];

    _isShowingRank = NO;
    [self updateHole];
    
    _isShowingScore = YES;
//    self.navigationItem.leftBarButtonItem.title = @"Back";
    [self fitView];

    _highlightView.frame = ((UIView*)sender).frame;
    [self.view bringSubviewToFront:_highlightView];
}

- (IBAction)rankingClick:(id)sender{
    self.navigationController.navigationBar.hidden = NO; //added code
    
    [self.view bringSubviewToFront:_rankingView];
    _isShowingRank = YES;
    
    if(_isShowingScore){
        [self pushCurrentScoreToLb];
        _isShowingScore = NO;
    }
    else{
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/get_full_leaderboard_iphone/"]];
        [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&leaderboard=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardID] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            _data = [NSMutableData data];
        }

    }
    self.navigationItem.leftBarButtonItem.title = @"Exit";
    [self fitView];
    
    _highlightView.frame = ((UIView*)sender).frame;
    [self.view bringSubviewToFront:_highlightView];
}

- (IBAction)commentsClick:(id)sender{
    self.navigationController.navigationBar.hidden = NO; //added code
    
    [self.view bringSubviewToFront:_commentsView];
    _isShowingRank = NO;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/get_leaderboard_comments_iphone/"]];
     [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&leaderboard=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardID] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        _data = [NSMutableData data];
    }
    
    
    if(_isShowingScore){
        [self pushCurrentScoreToLb];
        _isShowingScore = NO;
    }
    
    self.navigationItem.leftBarButtonItem.title = @"Back";
    [self fitView];

    _highlightView.frame = ((UIView*)sender).frame;
    [self.view bringSubviewToFront:_highlightView];
}

- (IBAction)detailsClick:(id)sender{
    self.navigationController.navigationBar.hidden = NO; //added code
    
    [self.view bringSubviewToFront:_detailsView];
    _isShowingRank = NO;
    if(_isShowingScore){
        [self pushCurrentScoreToLb];
        _isShowingScore = NO;
    }
    self.navigationItem.leftBarButtonItem.title = @"Back";
    [self fitView];

    _highlightView.frame = ((UIView*)sender).frame;
    [self.view bringSubviewToFront:_highlightView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
        
    if(_spinnerView){
        [_spinnerView removeSpinner];
        _spinnerView = nil;
    }
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(_spinnerView){
        [_spinnerView removeSpinner];
        _spinnerView = nil;
    }
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        
    if([connection.originalRequest.URL.absoluteString rangeOfString:@"get_full_leaderboard"].location != NSNotFound){
            
        
    if([responseText rangeOfString:@"auth failure"].location != NSNotFound){
        [[[UIAlertView alloc]initWithTitle:@"Auth error" message:@"Sorry, your password seems to be incorrect. Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        
        _labelLeaderboardName.text = [self stringBetweenString:@"<name>" andString:@"</name>" forString:responseText];
        _labelGolfCourse.text = [self stringBetweenString:@"<coursename>" andString:@"</coursename>" forString:responseText];
        self.title = [[self stringBetweenString:@"<name>" andString:@"</name>" forString:responseText] uppercaseString];
        self.navigationItem.title = [[self stringBetweenString:@"<name>" andString:@"</name>" forString:responseText] uppercaseString];
        _labelTeeBox.text = [NSString stringWithFormat:@"Tee Box: %@", [self stringBetweenString:@"<teebox_name>" andString:@"</teebox_name>" forString:responseText]];
        _labelDate.text = [NSString stringWithFormat:@"Date: %@", [self stringBetweenString:@"<date>" andString:@"</date>" forString:responseText]];
        labelPlayers.text = [NSString stringWithFormat:@"Players joined: %@", [self stringBetweenString:@"<players_count>" andString:@"</players_count>" forString:responseText]];
        _labelPasscode.text = [NSString stringWithFormat:@"Passcode: %@", self.leaderboardPass];
        _labelOrganiser.text = [NSString stringWithFormat:@"Leaderboard organizer: %@ %@", [self stringBetweenString:@"<user_fname>" andString:@"</user_fname>" forString:responseText], [self stringBetweenString:@"<user_lname>" andString:@"</user_lname>" forString:responseText ]];
     
        self.scoreID = [self stringBetweenString:@"<owner_scoreid>" andString:@"</owner_scoreid>" forString:responseText];
        
        if(!_scoreRows){
            _scoreRows = [[NSMutableArray alloc]init];
        }
        [_scoreRows removeAllObjects];
        
        NSArray* rowsXml = [responseText componentsSeparatedByString:@"</score>"];
        
        for(NSString* rowXml in rowsXml){
            
            LeaderboardScore* item = [[LeaderboardScore alloc]init];
            
            if([self stringBetweenString:@"<player>" andString:@"</player>" forString:rowXml] != nil){
              
                item.player = [self stringBetweenString:@"<player>" andString:@"</player>" forString:rowXml];
                item.over = [[self stringBetweenString:@"<over>" andString:@"</over>" forString:rowXml] intValue];
                item.gross = [[self stringBetweenString:@"<gross>" andString:@"</gross>" forString:rowXml] intValue];
                item.net = [[self stringBetweenString:@"<net>" andString:@"</net>" forString:rowXml] intValue];
                item.thru = [[self stringBetweenString:@"<thru>" andString:@"</thru>" forString:rowXml] intValue];
                
                [_scoreRows insertObject:item atIndex:0];
            }
        }
        
        for(int i = 1; i <= 18; i++){
            if([[self stringBetweenString:[NSString stringWithFormat:@"<scH%d>", i] andString:[NSString stringWithFormat:@"</scH%d>", i] forString:responseText]intValue ]  > 0){
            ((GrintScore*)[scores objectAtIndex:i-1]).score = [self stringBetweenString:[NSString stringWithFormat:@"<scH%d>", i] andString:[NSString stringWithFormat:@"</scH%d>", i] forString:responseText];
            ((GrintScore*)[scores objectAtIndex:i-1]).putts = [self stringBetweenString:[NSString stringWithFormat:@"<ptH%d>", i] andString:[NSString stringWithFormat:@"</ptH%d>", i] forString:responseText];
            ((GrintScore*)[scores objectAtIndex:i-1]).penalty = [self stringBetweenString:[NSString stringWithFormat:@"<pH%d>", i] andString:[NSString stringWithFormat:@"</pH%d>", i] forString:responseText];
            ((GrintScore*)[scores objectAtIndex:i-1]).fairway = [self stringBetweenString:[NSString stringWithFormat:@"<fH%d>", i] andString:[NSString stringWithFormat:@"</fH%d>", i] forString:responseText];
            }
        }
        
        [self rankOver:_buttonRankOver];
        [self rankOver:_buttonRankOver];
        
    }
        
    }
    else if([connection.originalRequest.URL.absoluteString rangeOfString:@"post_leaderboard_comment_iphone"].location != NSNotFound){
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/get_leaderboard_comments_iphone/"]];
        [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&leaderboard=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardID] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            _data = [NSMutableData data];
        }

    
    }
    else if ([connection.originalRequest.URL.absoluteString rangeOfString:@"get_leaderboard_comments_iphone"].location != NSNotFound){
    
        if(!_commentRows){
            _commentRows = [[NSMutableArray alloc]init];
        }
        
        [_commentRows removeAllObjects];
        
        NSArray* rowsXml = [responseText componentsSeparatedByString:@"</comment>"];
        
        for(NSString* rowXml in rowsXml){
            
            GrintActivityFeedItem* item = [[GrintActivityFeedItem alloc]init];
            
            if([self stringBetweenString:@"<user_fname>" andString:@"</user_fname>" forString:rowXml] != nil){
            
            item.title = [NSString stringWithFormat:@"%@ %@", [self stringBetweenString:@"<user_fname>" andString:@"</user_fname>" forString:rowXml], [self stringBetweenString:@"<user_lname>" andString:@"</user_lname>" forString:rowXml] ];
            item.subTitle = [self stringBetweenString:@"<text>" andString:@"</text>" forString:rowXml];
            item.image_loc = [@"http://www.thegrint.com/user_pic_new/" stringByAppendingString:[self stringBetweenString:@"<image>" andString:@"</image>" forString:rowXml]];
            item.scorecardId = [self stringBetweenString:@"<id>" andString:@"</id>" forString:rowXml];
            item.date = [self stringBetweenString:@"<timestamp>" andString:@"</timestamp>" forString:rowXml];
            item.delegate = self;
            [item downloadThumbnail];
            
            [_commentRows insertObject:item atIndex:0];
            }
        }

        [_tableViewComment reloadData];
        
    }
    else   if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/holedata_iphone_new"]){
                
        // if([[self stringBetweenString:@"<hole>" andString:@"</hole>" forString:responseText] intValue] == currentHole +1){
        
        for(int i = 1; i < 19; i++){
            
            NSString* tempString = [self stringBetweenString:[NSString stringWithFormat:@"<hole%d>", i] andString:[NSString stringWithFormat:@"</hole%d>", i] forString:responseText];
            
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).par = [self stringBetweenString:@"<par>" andString:@"</par>" forString:tempString];
            
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsHoleParYds = [NSString stringWithFormat:@"Par %d / %d yards", [[self stringBetweenString:@"<par>" andString:@"</par>" forString:tempString] intValue],[[self stringBetweenString:@"<yards>" andString:@"</yards>" forString:tempString] intValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgScore = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore>" andString:@"</avgscore>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgPutts = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts>" andString:@"</avgputts>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgPenalty = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty>" andString:@"</avgpenalty>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsTeeAccuracy = [NSString stringWithFormat:@"%d", [[self stringBetweenString:@"<teeaccuracy>" andString:@"</teeaccuracy>" forString:tempString] intValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgGir = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avggir>" andString:@"</avggir>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsGrints = [NSString stringWithFormat:@"%d", [[self stringBetweenString:@"<grints>" andString:@"</grints>" forString:tempString] intValue]];
            
            //THIS IS UI UPDATING STUFF
            /*
             if([labelScore.text isEqualToString:@""]){
             [picker1 selectRow:[[self stringBetweenString:@"<par>" andString:@"</par>" forString:responseText] intValue] - 1 inComponent:0 animated:NO];
             }
             
             if([[self stringBetweenString:@"<par>" andString:@"</par>" forString:responseText] intValue] == 3){
             [labelTeeAccuracy setHidden:YES]; //TODO: disable fairway
             [labelFairway setHidden:YES];
             }
             else {
             [labelTeeAccuracy setHidden: NO];
             if([accuracy isEqualToString:@"YES"]){
             [labelFairway setHidden:NO];
             }
             }*/
            
        }
        
        [self updateHole];
        
        [NSThread detachNewThreadSelector: @selector(loadPurchaseCourse) toTarget: self withObject: nil];
        
        if(!_spinnerView){
            _spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
        }
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/get_full_leaderboard_iphone/"]];
        [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&leaderboard=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardID] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            _data = [NSMutableData data];
        }

    }
    else if ([connection.originalRequest.URL.absoluteString rangeOfString:@"update_score_component_iphone"].location != NSNotFound){
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/get_full_leaderboard_iphone/"]];
        [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&leaderboard=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardID] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            _data = [NSMutableData data];
        }
        
        if([responseText rangeOfString:@"success"].location == NSNotFound){
            [[[UIAlertView alloc]initWithTitle:@"Upload failed" message:@"sorry, there was a problem processing this hole. Please try updating your score again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
        else{
            
        if (holeToMoveTo < 0){
            holeToMoveTo = 0;
        }

            else if(holeToMoveTo <= 17){
                currentHole = holeToMoveTo;
                [self updateHole];
            }
             else{
                
                
                [Flurry logEvent:@"leaderboard_complete_score"];
                
//                GrintBReviewScore* controller = [[GrintBReviewScore alloc] initWithNibName:@"GrintBReviewScore" bundle:nil];
                
                 GrintBNewReviewScore* controller;
                 if ([UIScreen mainScreen].bounds.size.height > 490 || [UIScreen mainScreen].bounds.size.width > 490) {
                     controller = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore5" bundle:nil];
                 } else
                     controller = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore" bundle:nil];
                 
                 controller.m_strCourseName = _labelGolfCourse.text;;
                 controller.m_strUserName = [[NSString stringWithFormat: @"%@ %@", self.nameString, self.lastName] uppercaseString];
                 controller.m_scores = self.scores;
                 
                 int nCount = 0;
                 for (int nIdx = 0; nIdx < 18; nIdx ++) {
                     GrintScore* curscore = [self.scores objectAtIndex: nIdx];
                     if ([curscore.score integerValue] > 0)
                         nCount ++;
                 }
                 
                 controller.FComplete = YES;
                 
//                 controller.isNine = self.numberHoles > 8 ? NO : YES;
//                 controller.nineType = self.maxHole > 8 ? @"back" : @"front";
                 
                controller.teeID = self.teeID;
                
                
                controller.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
                controller.courseName= _labelGolfCourse.text;
                controller.courseAddress= @"";
                controller.teeboxColor= @"";
                
                controller.date = self.date;
                controller.score = self.score;
                controller.putts = self.putts;
                controller.penalties = self.penalties;
                controller.accuracy = self.accuracy;
                controller.courseID = [NSNumber numberWithInt:[self.courseID intValue]];
                controller.scores = self.scores;
                controller.holeOffset = self.holeOffset;
                 controller.leaderboardID = self.leaderboardID;
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        }
    }
    
}

- (void) loadPurchaseCourse
{
    m_FEnableGPS = [self getPurchaseStatus];
    
    if (_spinnerView) {
        [_spinnerView removeSpinner];
        _spinnerView = nil;
    }
}


- (void) reloadTableData{
    [_tableViewComment reloadData];
    [_tableViewScore reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    if (_isShowingScore == YES) {
        self.navigationController.navigationBar.hidden = YES; //added code
    }
    else {
        self.navigationController.navigationBar.hidden = NO; //added code
    }
    
    [self fitView];
    
    if (m_FBackMap) { //back from map
        NSLog(@"Height = %f", self.view.frame.size.height);
        NSLog(@"Height = %f", _scoreView.frame.size.height);
    } else { // first show
        NSLog(@"Height = %f", self.view.frame.size.height);
        NSLog(@"Height = %f", _scoreView.frame.size.height);
    }
    
    if(self.disableInput){
        _buttonEnterScore.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else{
        _buttonEnterScore.hidden = NO;
    }
    
}

// added code
- (void) fitView
{
    if (_isShowingScore == YES) {
        CGRect rect = self.view.frame;
        rect.size.height = m_rFirstHeight + 44;
        if (m_FBackMap) {
            rect.origin.y = 0;
            m_FBackMap = NO;
        }
        else
            rect.origin.y = -44;
        
        [self.view setFrame: rect];
        
        rect.size.height -= _buttonEnterScore.frame.size.height;
        rect.origin.y = 0;
        [_scoreView setFrame: rect];
        
        [self.navigationController.navigationBar setFrame: CGRectMake(0, 0, 320, 0)];
    }
    else {
        CGRect rect = self.view.frame;
        rect.size.height = m_rFirstHeight;
        
        if (!m_FBackMap)
            rect.origin.y = 0;
        else {
            rect.origin.y = 44;
            m_FBackMap = NO;
        }
        [self.view setFrame: rect];

        rect.size.height -= _buttonEnterScore.frame.size.height;
        rect.origin.y = -44;
        [_scoreView setFrame: rect];

        [self.navigationController.navigationBar setFrame: CGRectMake(0, 20, 320, 44)];
    }
}
//////

- (void)backIfPossible:(id)sender{
    
    if(_isShowingScore){
        if(currentHole > 0){
            [self prevHole:_buttonEnterScore];
        }
        else{
            [self rankingClick:self.buttonEnterRanking];
        }
    }
    else if(_isShowingRank){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self rankingClick:self.buttonEnterRanking];

    }
    
    
    
}

- (void)nextIfPossible:(id)sender{
    
    if(_isShowingScore){
        [self nextScreen:_buttonEnterScore];
    }
    else{
        [self updateClick:_buttonEnterScore];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /// updated code
    m_rFirstHeight = [UIScreen mainScreen].bounds.size.height - 64;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResult:) name:STR_PURCHASE_MESSAGE_PREFIX object:nil];
    /////////////

    // Do any additional setup after loading the view from its nib.
    
    [_label1 setFont:[UIFont fontWithName:@"Oswald" size:18.0]];
    [_label2 setFont:[UIFont fontWithName:@"Oswald" size:14.0]];
    [_label3 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label4 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label5 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label6 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label7 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_label8 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [labelFairway setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPenalty setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPutts setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelScore setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_labelAvgPutts setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_labelAvgGir setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_labelAvgPenalty setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_labelAvgScore setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_labelGrints setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_labelTeeAccuracy setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_buttonEnter.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [_buttonEnter.layer setCornerRadius:5.0f];
   
    
    [_deetsTitle setFont:[UIFont fontWithName:@"Oswald" size:18.0]];
    [_labelRankedTitle setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    
    [_labelHoleNo setFont:[UIFont fontWithName:@"Oswald" size:24]];
    [labelScore.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelPutts.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelPenalty.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelFairway.layer setCornerRadius: labelScore.bounds.size.width/2];
    [_labelAvgScore.layer setCornerRadius: labelScore.bounds.size.width/2];
    [_labelAvgPutts.layer setCornerRadius: labelScore.bounds.size.width/2];
    [_labelAvgPenalty.layer setCornerRadius: labelScore.bounds.size.width/2];
    [_labelTeeAccuracy.layer setCornerRadius: labelScore.bounds.size.width/2];
    [_labelAvgGir.layer setCornerRadius: labelScore.bounds.size.width/2];
    [_labelGrints.layer setCornerRadius: labelScore.bounds.size.width/2];
    [_labelStrokesSoFar setFont:[UIFont fontWithName:@"Oswald" size:30.0]];
    [_labelScoreSoFar setFont:[UIFont fontWithName:@"Oswald" size:15.0]];
    
    //update code//
    [labelGPS.layer setCornerRadius: labelGPS.bounds.size.width/2];
    [btnGPS.layer setCornerRadius: btnGPS.bounds.size.width/2];
    
    [btnGPS.layer setShadowColor:[UIColor blackColor].CGColor];
    [btnGPS.layer setShadowOpacity:0.7];
    [btnGPS.layer setShadowRadius:2];
    [btnGPS.layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
    
    [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
    [labelExtra setText: @"Tap for"];
    labelExtra.hidden = NO;
    labelGPS.text = @"";
    
    CGPoint ptCenter = labelGPS.center;
    ptCenter.y += 7;
    labelGreenCenter.center = ptCenter;
    [labelGreenCenter setText: @"GPS"];
    [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
    [labelGrint setFont: [UIFont fontWithName:@"Oswald" size: 28]];
    
    m_LocationManager = [[CLLocationManager alloc] init];
    m_LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    m_LocationManager.delegate = self;
    
    gpsMapController = [[ShowHoleMapController alloc] initWithNibName:@"ShowHoleMapController" bundle:nil];
    
    ///////////////

    
    [[_buttonRankOver titleLabel]setFont:[UIFont fontWithName:@"Oswald" size:15.0]];
    _buttonRankOver.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buttonRankOver.layer.borderWidth = 1.0f;

    [[_buttonRankNet titleLabel]setFont:[UIFont fontWithName:@"Oswald" size:15.0]];
    _buttonRankNet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buttonRankNet.layer.borderWidth = 1.0f;
    
    [[_buttonRankGross titleLabel]setFont:[UIFont fontWithName:@"Oswald" size:15.0]];
    _buttonRankGross.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buttonRankGross.layer.borderWidth = 1.0f;
    
    
    _buttonEnterComments.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buttonEnterComments.layer.borderWidth = 1.0f;
    _buttonEnterDetails.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buttonEnterDetails.layer.borderWidth = 1.0f;
    _buttonEnterRanking.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buttonEnterRanking.layer.borderWidth = 1.0f;
    _buttonEnterScore.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _buttonEnterScore.layer.borderWidth = 1.0f;
    
    _bgView.layer.cornerRadius = 15.0f;
    _bgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _bgView.layer.borderWidth = 1.0f;
    [_labelLeaderboardName setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_labelGolfCourse setFont:[UIFont fontWithName:@"Oswald" size:20]];
    [_labelOrganiser setFont:[UIFont fontWithName:@"Oswald" size:12]];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_scoreView addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_scoreView addGestureRecognizer:swipeRecognizer];
    
    [self.view bringSubviewToFront:_rankingView];

    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextIfPossible:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(backIfPossible:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    currentHole = 0;
    
    NSArray* temp1 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", @"11", @"12", nil];
    NSArray* temp2 = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5", nil];
    NSArray* temp3 = [NSArray arrayWithObjects: @"None",
                      @"S Greenside Sand",
                      @"F Fairway Sand",
                      @"W Water Hazard",
                      @"O Out of Bounds",
                      @"D Drop shot",
                      @"SS",
                      @"FF",
                      @"WW",
                      @"OO",
                      @"DD",
                      @"FS",
                      @"WS",
                      @"OS",
                      @"DS", @"OF", @"OW", nil];
    NSArray* temp4 = [NSArray arrayWithObjects:@"Hit",@"Missed Left",@"Missed Right", @"Missed Short", @"Missed Long", @" Shank", nil];
    
    self.pickerData = [NSArray arrayWithObjects:temp1, temp2, temp3, temp4, nil];

    
    self.scores = [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.friendlyDateFormatter = [[NSDateFormatter alloc]init];
    [self.friendlyDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [self.friendlyDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.friendlyDateFormatter setLocale:[NSLocale currentLocale]];
    [self.friendlyDateFormatter setDoesRelativeDateFormatting:YES];
    [self.friendlyDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSLog(@"setting time zone to %@", [[NSTimeZone systemTimeZone] name]);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/holedata_iphone_new"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d&teeid=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username"], [self.courseID intValue], self.teeID];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        _data = [NSMutableData data];
        if(_spinnerView == nil)
        _spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    }
    
    
}


- (void) updateHole{
    
    if([putts isEqualToString:@"YES"]){
        [labelPutts setHidden:NO];
    }
    else{
        [labelPutts setHidden:YES];
    }
    if([penalties isEqualToString:@"YES"]){
        [labelPenalty setHidden:NO];
    }
    else{
        [labelPenalty setHidden:YES];
    }
    if([accuracy isEqualToString:@"YES"]){
        [labelFairway setHidden:NO];
    }
    else{
        [labelFairway setHidden:YES];
    }
    
    holeID = ((currentHole +1 + [holeOffset intValue]) > 18? (currentHole +1 + [holeOffset intValue] - 18) : (currentHole +1 + [holeOffset intValue]));
    
    _labelHoleNo.text = [NSString stringWithFormat:@"HOLE %d", holeID];
    
    GrintScore* currentScore = [scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])];
    
    //  if([currentScore.par intValue] == 3){
    if(NO){
        //[labelTeeAccuracy setHidden:YES]; //TODO: disable fairway
        [labelFairway setHidden:YES];
    }
    else if([accuracy isEqualToString:@"YES"]){
        [labelFairway setHidden:NO];
    }
    
    
    if(currentScore.score && currentScore.score.length > 0){
        labelScore.text = currentScore.score;
        if([[pickerData objectAtIndex:0]containsObject:currentScore.score]){
            [_picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.score] inComponent:0 animated:NO];
        }
    }
    else{
        labelScore.text = @"";
        if([[pickerData objectAtIndex:0]containsObject:currentScore.par]){
            [_picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.par] inComponent:0 animated:NO];
        }
    }
    if(currentScore.putts && currentScore.putts.length > 0){
        labelPutts.text = currentScore.putts;
        if([[pickerData objectAtIndex:1]containsObject:currentScore.putts]){
            [_picker1 selectRow:[[pickerData objectAtIndex:1]indexOfObject:currentScore.putts] inComponent:1 animated:NO];
        }
    }
    else{
        labelPutts.text = @"";
        [_picker1 selectRow:2 inComponent:1 animated:NO];
    }
    if(currentScore.penalty && currentScore.penalty.length > 0){
        labelPenalty.text = currentScore.penalty;
        if([[pickerData objectAtIndex:2] containsObject:currentScore.penalty]){
            [_picker1 selectRow:[[pickerData objectAtIndex:2]indexOfObject:currentScore.penalty] inComponent:2 animated:NO];
        }
    }
    else{
        labelPenalty.text = @"";
        [_picker1 selectRow:0 inComponent:2 animated:NO];
    }
    if(currentScore.fairway && currentScore.fairway.length > 0){
        labelFairway.text = currentScore.fairway;
        if([[pickerData objectAtIndex:3]containsObject:currentScore.fairway]){
            [_picker1 selectRow:[[pickerData objectAtIndex:3]indexOfObject:currentScore.fairway] inComponent:3 animated:NO];
        }
    }
    else{
        labelFairway.text = @"";
        [_picker1 selectRow:0 inComponent:3 animated:NO];
    }
    
    m_strHoleYards = [currentScore.statsHoleParYds copy];
    
    _labelHoleParYds.text = currentScore.statsHoleParYds;
    _labelAvgScore.text = currentScore.statsAvgScore;
    _labelAvgPutts.text = currentScore.statsAvgPutts;
    _labelAvgPenalty.text = currentScore.statsAvgPenalty;
    _labelTeeAccuracy.text = currentScore.statsTeeAccuracy;
    _labelAvgGir.text = currentScore.statsAvgGir;
    _labelGrints.text = currentScore.statsGrints;
    
    
    
    [_picker1 reloadAllComponents];
    
    int totalPar= 0;
    int totalScore = 0;
    
    for(GrintScore* tempscore in scores){
        
        if(tempscore.score && tempscore.score.length > 0){
            
            totalPar += [tempscore.par intValue];
            totalScore += [tempscore.score intValue];
        }
        
    }
    
    _labelScoreSoFar.text = [NSString stringWithFormat:@"(%d)", totalScore];
    _labelStrokesSoFar.text = [NSString stringWithFormat:@"%@%d", (totalScore - totalPar) >= 0 ? @"+" : @"",totalScore - totalPar];
    
    m_bIsMap = [self getMapState];
}



- (IBAction)prevHole:(id)sender{
    if(_picker1.isHidden){
        holeToMoveTo = currentHole - 1;
        [self pushCurrentScoreToLb];
        
        //added code
        [m_LocationManager stopUpdatingLocation];
        CGPoint ptCenter = labelGPS.center;
        ptCenter.y += 7;
        labelGreenCenter.center = ptCenter;
        
        [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
        [labelExtra setText: @"Tap for"];
        labelExtra.hidden = NO;
        labelGPS.text = @"";
        [labelGreenCenter setText: @"GPS"];
        [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
        
        gpsMapController.m_nFirstDraw = 1;
        /////////////////
    }
}

- (void)pushCurrentScoreToLb{
    
    if(labelScore.text.length > 0){
    
    if(!_spinnerView){
        _spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/update_score_component_iphone/"]];
    
    NSMutableString* requestBody = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"username=%@&password=%@&score_id=%@&hole=%d", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.scoreID, ((currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])) + 1]];
    
    [requestBody appendFormat:@"&scH%d=%@", ((currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])) + 1, labelScore.text];
    [requestBody appendFormat:@"&ptH%d=%@", ((currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])) + 1, labelPutts.text];
    [requestBody appendFormat:@"&pH%d=%@", ((currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])) + 1, labelPenalty.text];
    [requestBody appendFormat:@"&fH%d=%@", ((currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])) + 1, labelFairway.text.length > 0 ?labelFairway.text : @""];
    
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        _data = [NSMutableData data];
    }
    }
    else if(holeToMoveTo < currentHole && holeToMoveTo >= 0){
        currentHole = holeToMoveTo;
        [self updateHole];
    }
}

-(IBAction)nextScreen:(id)sender{
    
    if(_picker1.isHidden){
        
        if(labelScore.text.length < 1){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Missing data" message:@"Please enter a score for this hole" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if (labelPutts.text.length < 1 && !labelPutts.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Missing data" message:@"You have selected to track putts data - please enter a figure in this field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        else if (labelFairway.text.length < 1 && !labelFairway.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Missing data" message:@"You have selected to track accuracy data - please enter a hit or missed fairway" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([labelPutts.text intValue] >= [[[pickerData objectAtIndex:0]objectAtIndex:[_picker1 selectedRowInComponent:0]] intValue]){
            if (labelPutts.hidden) {
                GrintScore* curScore = ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > 17? (currentHole + [holeOffset intValue] - 18) : (currentHole + [holeOffset intValue])]);
                curScore.putts = [NSString stringWithFormat: @"%d", (curScore.score.integerValue - 1)];
                labelPutts.text = curScore.putts;
                [self nextScreen: sender];
            } else {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Putts too high" message:@"Putts can never be same or higher than the score" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else{

        
            holeToMoveTo = currentHole + 1;
            [self pushCurrentScoreToLb];
            //added code
            [m_LocationManager stopUpdatingLocation];
            CGPoint ptCenter = labelGPS.center;
            ptCenter.y += 7;
            labelGreenCenter.center = ptCenter;
            
            [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
            [labelExtra setText: @"Tap for"];
            labelExtra.hidden = NO;
            labelGPS.text = @"";
            [labelGreenCenter setText: @"GPS"];
            [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
            
            gpsMapController.m_nFirstDraw = 1;
            /////////////////
        }
    
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//added code


- (BOOL) getPurchaseStatus
{
    Communication* comm = [[Communication alloc] init];
    NSString* strData = [NSString stringWithFormat:@"check_purchase?user_name=%@&course=%d", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ], [self.courseID integerValue]];
    BOOL FPurchase = [comm getPurchaseState: strData];
    
    return FPurchase;
}

- (BOOL) getMapState
{
    Communication* comm = [[Communication alloc] init];
    NSString* strData = [NSString stringWithFormat:@"index?course=%d&hole=%d", [self.courseID integerValue], holeID];
    
    m_dictMap = [[NSMutableDictionary alloc] init];
    BOOL FIsMap = [comm isMapped: strData MAP: m_dictMap];
    
    return FIsMap;
}

- (void) loadActivity
{
    [self.view bringSubviewToFront: _scoreView];
    self.spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
}

- (IBAction)showGPSInfo:(id)sender {
    [m_LocationManager startUpdatingLocation];
    [self performSelector:@selector(loadActivity)];
    [self performSelector: @selector(mapProcess) withObject:nil afterDelay: 0.01];
}

- (void) showAlertView
{
    TSAlertView* av = [[TSAlertView alloc] init];
	av.title = @"";
	av.message = @"Get accurate GPS Maps and distances \n for this golf course";
	
    [av addButtonWithTitle: @"$0.99 Unlimited access to this Map"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey: @"glance"] == nil || [[defaults objectForKey: @"glance"] integerValue] == 0)
        [av addButtonWithTitle: @"One Hole Sneak Peek!"];
    
	[av addButtonWithTitle: @"Not now, thanks!"];
	
	av.style = TSAlertViewStyleNormal;//_hasInputFieldSwitch.on ? TSAlertViewStyleInput : TSAlertViewStyleNormal;
	av.buttonLayout = TSAlertViewButtonLayoutStacked;//_stackedSwitch.on ? TSAlertViewButtonLayoutStacked : TSAlertViewButtonLayoutNormal;
	av.usesMessageTextView = NO;//_usesTextViewSwitch.on;
	
	av.width = 0;//[_widthTextField.text floatValue];
	av.maxHeight = 0;//[_maxHeightTextField.text floatValue];
    av.delegate = self;
    
	[av show];
    
    //    NSString* strTitle = @"Get accurate GPS Maps and distances for this golf course";
    //
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:strTitle delegate:self cancelButtonTitle: nil otherButtonTitles: @"$0.99 Unlimited access to this Map", @"Not now, thanks!", nil];
    //    alertView.cancelButtonIndex = -1;
    
    //    [[alertView viewWithTag: 3] removeFromSuperview];
    //    CGRect rect = alertView.bounds;
    //    rect.size.height -= 30;
    //    [alertView setBounds: rect];
    //    [alertView show];
}



- (void) mapProcess
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"username" ] isEqualToString:@"Guest"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Guest is allowed to show the GPS Data." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (m_bIsMap == YES) {
        if (m_FEnableGPS == NO) {
            [self showAlertView];
        } else {
            [self showHoleMap];
        }
    } else {
//        NSString* strTitle = @"This Golf Course is not mapped. \n Map it yourself with our tools \n and get free access to it.";
//        
//        UIActionSheet *alertView = [[UIActionSheet alloc] initWithTitle:strTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle: @"Sure!  Email me the instructions" otherButtonTitles: @"Not now, thanks!", nil];
//        [alertView showInView: self.view];
//        alertView.center = self.view.center;
        UIXOverlayController* overlay = [[UIXOverlayController alloc] init];
        MapperActionSheet* mapperController = [[MapperActionSheet alloc] initWithNibName: @"MapperActionSheet" bundle:nil];
        mapperController.delegate = self;
        overlay.dismissUponTouchMask = NO;
        
        [overlay presentOverlayOnView:self.view withContent:mapperController animated: YES];
    }
    
    if (self.spinnerView) {
        [self.spinnerView removeSpinner];
        self.spinnerView = nil;
    }
}

//- (void) willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView* view in [actionSheet subviews]) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton* button = (UIButton*)view;
//            [button.titleLabel setFont: [UIFont fontWithName: @"Oswald" size: 18]];
//            if ([button.titleLabel.text rangeOfString: @"Email"].length > 0) {
//                NSString *version = [[UIDevice currentDevice] systemVersion];
//
//                BOOL isAtLeast7 = [version floatValue] >= 7.0;
//                if (!isAtLeast7)
//                    [button setBackgroundImage:[UIImage imageNamed: @"button_green.png"] forState: UIControlStateNormal];
//            }
//        }
//    }
//}

- (void) acceptMakeMap
{
    [self sendMail];
}

- (void) sendMail
{
    Communication* comm = [[Communication alloc] init];
    NSString* strData = [NSString stringWithFormat: @"make_map?user_name=%@&course=%d", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ], [self.courseID integerValue]];
    BOOL FRequest = [comm requestMakeMap: strData];
    
    if (FRequest) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"We just sent you the instructions via email. Thanks for your help!" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        [alertView show];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"Unfortunately your request has failed." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        [alertView show];
    }
}

- (void) showHoleMap
{
    NSMutableDictionary* dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:self.courseID forKey:@"courseid"];
    [dictParam setObject:[NSNumber numberWithInt: holeID] forKey:@"holeno"];
    [dictParam setObject:self.m_strHoleYards forKey:@"holepar"];
    
    gpsMapController.m_dictCourseInfo = [dictParam copy];
    gpsMapController.m_dictMapInfo = [[NSDictionary alloc] initWithDictionary: m_dictMap copyItems: YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGreenInfo:) name:STR_SHOW_GREEN_INFO object: gpsMapController];
    
    //        [self presentModalViewController: gpsMapController animated: YES];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:gpsMapController animated: YES];
    
    m_FBackMap = YES;
}

- (void) showGreenInfo: (NSNotification*) aNotification
{
    ShowHoleMapController* gpsInfoController = (ShowHoleMapController*)aNotification.object;
    [labelGPS setFont: [UIFont fontWithName: @"Oswald" size: 11]];
    labelGPS.text = @"Yards to pin \n \n \n Tap for Map";//[NSString stringWithFormat:@"Yards to pin \n \n Tap for Map", gpsInfoController.m_nDistBack, gpsInfoController.m_nDistFront];
    labelExtra.hidden = YES;
    
    CGPoint ptCenter = labelGPS.center;
    labelGreenCenter.center = ptCenter;
    [labelGreenCenter setFont: [UIFont fontWithName: @"Oswald" size: 32]];
    labelGreenCenter.text = [NSString stringWithFormat: @"%d", gpsInfoController.m_nDistCenter];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //no thanks
            return;
            break;
        case 1: //$1.29
            m_nPurchaseKind = 0;
            [self buyPurchase: 1];
            break;
        case 2: //$14.99
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey: @"glance"] == nil || [[defaults objectForKey: @"glance"] integerValue] == 0) {
                [self getGlance];
            }
        }
            break;
        default:
            break;
    }
    
    //test code
    //    NSString* strParam;
    //    if (m_nPurchaseKind == 0)
    //        strParam = [NSString stringWithFormat:@"purchase?user_name=%@&course=%d", username, [courseID integerValue]];
    //    else
    //        strParam = [NSString stringWithFormat:@"purchase?user_name=%@&course=%@", username, @"all"];
    //
    //    Communication* comm = [[Communication alloc] init];
    //    [comm setPurchaseState: strParam];
    //    [self showHoleMap];
    
}


- (void) getGlance
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: @"1" forKey: @"glance"];
    [defaults synchronize];
    
    m_FOnByGlance = YES;
    
    if ([defaults objectForKey: @"first_gps_state"] == nil || [[defaults objectForKey: @"first_gps_state"] integerValue] <= 0)
    {
        UIXOverlayController* overlay = [[UIXOverlayController alloc] init];
        GPSUseGuideController* guideController = [[GPSUseGuideController alloc] initWithNibName:@"GPSUseGuideController" bundle:nil];
        guideController.m_parentController = self;
        overlay.dismissUponTouchMask = NO;
        
        [overlay presentOverlayOnView:self.view withContent:guideController animated: YES];
    } else {
        [self gpsOnProcess];
    }
}

- (void) gpsOnProcess
{
//    [self showGPSDistance: m_astHoleMap[holeID - 1].s_dictInfo CURPOS: m_LocationManager.location.coordinate];
//    
    [self showHoleMap];
}


- (void) buyPurchase: (int) nIdx {
    _products = [RageIAPHelper sharedInstance]._products;
    if (_products == nil || [_products count] < 1) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: nil message: @"Not ready now, please try again in a few seconds." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        [alertView show];
        return;
    }

    SKProduct *product = [_products objectAtIndex: nIdx];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[RageIAPHelper sharedInstance] buyProduct:product NOTIFICATION: STR_PURCHASE_MESSAGE_PREFIX];
    
    [self.view bringSubviewToFront: _scoreView];
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            *stop = YES;
        }
    }];
    
}

- (void)purchaseResult:(NSNotification *)notification {
    NSString* strParam;
    IAPHelper* helper = notification.object;
    if (helper.m_nState == 0) { //success
        if (m_nPurchaseKind == 0)
            strParam = [NSString stringWithFormat:@"purchase?user_name=%@&course=%d", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ], [self.courseID integerValue]];
        else
            strParam = [NSString stringWithFormat:@"purchase?user_name=%@&course=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ], @"all"];
        
        Communication* comm = [[Communication alloc] init];
        [comm setPurchaseState: strParam];
        
        [self showHoleMap];
    } else { //restore or failure
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Purchase Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    if (self.spinnerView) {
        [self.spinnerView removeSpinner];
        self.spinnerView = nil;
    }
}

- (double) getDistanceFromLatLonInM: (CLLocationCoordinate2D) firstLoc SECOND: (CLLocationCoordinate2D) secondLoc {
    double R = 6371000 * YARDS_PER_METER; // Radius of the earth in km
    double dLat = (PI / 180) * (secondLoc.latitude - firstLoc.latitude);  // deg2rad below
    double dLon = (PI / 180) * (secondLoc.longitude - firstLoc.longitude);
    double a = sin(dLat/2) * sin(dLat/2) + cos((PI / 180) * firstLoc.latitude) * cos((PI / 180) * (secondLoc.latitude)) * sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c; // Distance in km
    return d;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (m_FEnableGPS && locations && [locations count] > 0) {
        CLLocation* loc = locations.lastObject;
        CLLocationCoordinate2D currentPos = loc.coordinate;
        
        if ([m_dictMap objectForKey: STR_KEY_GREEN_CENTER]) {
            NSDictionary* dictCenter = [m_dictMap objectForKey: STR_KEY_GREEN_CENTER];
            CLLocationCoordinate2D centerPos = CLLocationCoordinate2DMake([[dictCenter objectForKey: @"lat"] doubleValue], [[dictCenter objectForKey: @"lng"] doubleValue]);
            int nDist = [self getDistanceFromLatLonInM: currentPos SECOND: centerPos];
            if (nDist < 2000) {
                [labelGPS setFont: [UIFont fontWithName: @"Oswald" size: 11]];
                labelGPS.text = @"Yards to pin \n \n \n Tap for Map";//[NSString stringWithFormat:@"Yards to pin \n \n Tap for Map", gpsInfoController.m_nDistBack, gpsInfoController.m_nDistFront];
                labelExtra.hidden = YES;
                
                CGPoint ptCenter = labelGPS.center;
                labelGreenCenter.center = ptCenter;
                [labelGreenCenter setFont: [UIFont fontWithName: @"Oswald" size: 32]];
                labelGreenCenter.text = [NSString stringWithFormat: @"%d", nDist];
            } else {
                NSDictionary* dictTee = [m_dictMap objectForKey: STR_KEY_TEEBOX];
                CLLocationCoordinate2D centerPos = CLLocationCoordinate2DMake([[dictCenter objectForKey: @"lat"] doubleValue], [[dictCenter objectForKey: @"lng"] doubleValue]);
                CLLocationCoordinate2D teePos = CLLocationCoordinate2DMake([[dictTee objectForKey: @"lat"] doubleValue], [[dictTee objectForKey: @"lng"] doubleValue]);
                
                nDist = [self getDistanceFromLatLonInM: teePos SECOND: centerPos];
                
                [labelGPS setFont: [UIFont fontWithName: @"Oswald" size: 11]];
                labelGPS.text = @"Yards to pin \n \n \n Tap for Map";//[NSString stringWithFormat:@"Yards to pin \n \n Tap for Map", gpsInfoController.m_nDistBack, gpsInfoController.m_nDistFront];
                labelExtra.hidden = YES;
                
                
                CGPoint ptCenter = labelGPS.center;
                labelGreenCenter.center = ptCenter;
                [labelGreenCenter setFont: [UIFont fontWithName: @"Oswald" size: 32]];
                labelGreenCenter.text = [NSString stringWithFormat: @"%d", nDist];
            }
        }
    }
}


////


@end
