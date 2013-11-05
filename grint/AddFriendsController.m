//
//  AddFriendsController.m
//  grint
//
//  Created by Passioner on 9/19/13.
//
//

#import "AddFriendsController.h"

#import "SpinnerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Communication.h"

#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>
#import <AddressBook/ABMultiValue.h>

//CFArrayRef ABAddressBookCopyArrayOfAllPeople (ABAddressBookRef addressBook);

#define CELL_IDENTIFIER @"CELL_FRIEND"


@interface AddFriendsController ()

@end

@implementation AddFriendsController
{
    NSMutableArray* m_arrayList;
    
    SpinnerView* m_spinner;
    
    NSURLConnection* connection;
    NSMutableData* data;
    
    int m_nViewType; // 0 - get friends, 1 - search
    
    Communication* m_comm;
    
    int m_nIndex;
}

@synthesize m_strUserName, m_labelSearch, m_labelCaption, m_textName, m_friendTable, m_nType;

- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end forString:(NSString*) string {
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_arrayList = [[NSMutableArray alloc] init];
        m_comm = [[Communication alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [m_comm release];
    if ([m_arrayList count] > 0)
        [m_arrayList removeAllObjects];
    [m_arrayList release];
    
//    [m_labelCaption release];
//    [m_labelSearch release];
//    [m_textName release];
//    [m_friendTable release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    [[self navigationItem] setLeftBarButtonItem:backButton];
    
    [self.m_friendTable registerNib: [UINib nibWithNibName: @"cellFriend" bundle: nil] forCellReuseIdentifier: CELL_IDENTIFIER];
    
//    m_spinner = [SpinnerView loadSpinnerIntoView: self.view];
    
    [self.m_labelCaption setFont: [UIFont fontWithName: @"Oswald" size: 24]];
    [self.m_labelSearch setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    
    [NSThread detachNewThreadSelector: @selector(loadFriendList) toTarget: self withObject: nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void) goBack: (id) sender
{
    if (m_nType == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"refresh_friend_info" object:nil];
    }
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - send sms to my phone contact list
- (IBAction)searchFriend:(id)sender {
    [self textFieldShouldReturn: m_textName];
}

- (IBAction)actionFromContacts:(id)sender {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                NSLog(@"Access granted!");
                [self inviteFriends: addressBookRef];
            } else {
                NSLog(@"Access denied!");
            }
        });
    } else {
        [self inviteFriends: addressBookRef];
    }
    
}

- (void) inviteFriends: (ABAddressBookRef) addressBookRef
{
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
    
    NSMutableArray* arrayContacts = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName = (NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"Name:%@ %@", firstName, lastName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            [arrayContacts addObject: phoneNumber];
            if (arrayContacts.count > 20)
                break;
            NSLog(@"phone:%@", phoneNumber);
        }
    }
    
//    [arrayContacts addObject: @""];
//    for (int nIdx = 0; nIdx < 500; nIdx ++) {
//        int n = rand();
//        [arrayContacts addObject: [NSString stringWithFormat: @"%d", n]];
//    }
    
    if ([arrayContacts count] > 0) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"Hey! Check out TheGrint Golf App. I use it to get GPS and a USGA Compliant Handicap. Join so we can befriend each other. iOS download: https://itunes.apple.com/gb/app/thegrint-golf-handicap-tracker/id532085262?mt=8";
//            controller.body = @"Hey! Check out TheGrint Golf App(http://www.thegrint.com). I use it to get GPS and a USGA Compliant Handicap. Join so we can befriend each other.";

            controller.recipients = arrayContacts;
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
        {

            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrayList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void) setPhoto: (NSDictionary*) dict
{
    NSString* strUrl = [dict objectForKey: @"url"];
    UIImageView* imgView = [dict objectForKey: @"imageview"];
    [imgView setImage: [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: strUrl]]]];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.m_friendTable dequeueReusableCellWithIdentifier: CELL_IDENTIFIER];
    
    cell.tag = indexPath.row + 10000;
    
    NSDictionary* dict = [m_arrayList objectAtIndex: indexPath.row];
    
    NSString* strImageURL = [NSString stringWithFormat: @"http://www.thegrint.com/user_pic_new/%@", [dict valueForKey: @"image"]];
    UIImageView* imagePhoto = (UIImageView*)[cell viewWithTag: 1];
    [imagePhoto setImageWithURL: [NSURL URLWithString: strImageURL]];
    
    UILabel* labelName = (UILabel*)[cell viewWithTag: 2];
    [labelName setFont: [UIFont fontWithName: @"Oswald" size: 19]];
    labelName.text = [NSString stringWithFormat: @"%@ %@", [dict valueForKey: @"fname"], [dict valueForKey: @"lname"]];

    UILabel* labelExtra = (UILabel*)[cell viewWithTag: 3];
    
    if ([[dict valueForKey: @"city"] isEqualToString: @" "]) {
        labelExtra.text = [NSString stringWithFormat: @"Handicap : %@", [dict valueForKey: @"handicap"]];
    } else {
        labelExtra.text = [NSString stringWithFormat: @"Handicap : %@ \n%@, %@", [dict valueForKey: @"handicap"], [dict valueForKey: @"city"], [dict valueForKey: @"state"]];
    }
    
    UILabel* labelStatus = (UILabel*)[cell viewWithTag: 4];
    [labelStatus setFont: [UIFont fontWithName: @"Oswald" size: 14]];
    
    UIButton* btnAction = (UIButton*)[cell viewWithTag: 5];
    btnAction.hidden = NO;
    [btnAction removeTarget: self action: @selector(actionAccept:) forControlEvents: UIControlEventTouchUpInside];
    [btnAction removeTarget: self action: @selector(actionDelete:) forControlEvents: UIControlEventTouchUpInside];
    [btnAction removeTarget: self action: @selector(actionAdd:) forControlEvents: UIControlEventTouchUpInside];
    
    CGRect rect = labelStatus.frame;
    rect.origin.y = 23;

    int nStatus = [[dict valueForKey: @"status"] integerValue];
    if (nStatus >= 0) {
        if (nStatus == 0) { //pending state
            labelStatus.text = @"pending";
            [btnAction setImage: [UIImage imageNamed: @"btn_accept.png"] forState: UIControlStateNormal];
            [btnAction addTarget: self action: @selector(actionAccept:) forControlEvents: UIControlEventTouchUpInside];
        } else if (nStatus == 1) { // friend state
            labelStatus.text = @"friend";
            [btnAction setImage: [UIImage imageNamed: @"btn_delete.png"] forState: UIControlStateNormal];
            [btnAction addTarget: self action: @selector(actionDelete:) forControlEvents: UIControlEventTouchUpInside];
        } else {//if (nStatus == 100) {
            rect.origin.y = 33;
            labelStatus.text = @"pending";
            btnAction.hidden = YES;
        }
    } else {
        labelStatus.text = @"";
        [btnAction setImage: [UIImage imageNamed: @"btn_addfriend.png"] forState: UIControlStateNormal];
        [btnAction addTarget: self action: @selector(actionAdd:) forControlEvents: UIControlEventTouchUpInside];
    }
    [labelStatus setFrame: rect];
    
    return cell;
}

#pragma mark - actions for accept, delete, add friend

- (void) actionAccept: (UIButton*) sender
{
    UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
    m_nIndex = cell.tag - 10000;
    
    m_spinner = [SpinnerView loadSpinnerIntoView: self.view];
    
    [NSThread detachNewThreadSelector: @selector(accept) toTarget: self withObject: nil];
}

- (void) accept
{
    NSDictionary* dict = [m_arrayList objectAtIndex: m_nIndex];
    NSString *params = [[NSString alloc] initWithFormat:@"type=accept&username=%@&rq_from=%@&rq_to=%@", m_strUserName, [dict objectForKey: @"rq_from"], [dict objectForKey: @"rq_to"]];
//    [m_comm sendRequest:@"http://192.168.1.177/grintsite2/friend_request/" PARAM: params];
    [m_comm sendRequest:@"https://www.thegrint.com/friend_request/" PARAM: params];
    
    [dict setValue: @"1" forKey: @"status"];
    
    [self.m_friendTable reloadData];
    
    if (m_spinner) {
        [m_spinner removeSpinner];
        m_spinner = nil;
    }
}

- (void) actionDelete: (UIButton*) sender
{
    UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
    m_nIndex = cell.tag - 10000;

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"" message:@"Are you sure you want to unfriend this golfer?" delegate: self cancelButtonTitle:@"Unfriend" otherButtonTitles: @"Cancel", nil];
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        m_spinner = [SpinnerView loadSpinnerIntoView: self.view];
        
        [NSThread detachNewThreadSelector: @selector(unfriend) toTarget: self withObject: nil];
    }
}

- (void) unfriend
{
    NSDictionary* dict = [m_arrayList objectAtIndex: m_nIndex];
    NSString *params = [[NSString alloc] initWithFormat:@"type=delete&username=%@&rq_from=%@&rq_to=%@", m_strUserName, [dict objectForKey: @"rq_from"], [dict objectForKey: @"rq_to"]];
    
//    [m_comm sendRequest:@"http://192.168.1.177/grintsite2/friend_request/" PARAM: params];
    [m_comm sendRequest:@"https://www.thegrint.com/friend_request/" PARAM: params];
    
    [m_arrayList removeObjectAtIndex: m_nIndex];
    
    [self.m_friendTable reloadData];
    
    if (m_spinner) {
        [m_spinner removeSpinner];
        m_spinner = nil;
    }
}

- (void) actionAdd: (UIButton*) sender
{
    m_spinner = [SpinnerView loadSpinnerIntoView: self.view];
    [NSThread detachNewThreadSelector: @selector(addFriendRequest:) toTarget: self withObject: sender];
}

- (void) addFriendRequest: (UIButton*) sender
{
    UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
    m_nIndex = cell.tag - 10000;
    
    NSDictionary* dict = [m_arrayList objectAtIndex: m_nIndex];
    NSString *params = [[NSString alloc] initWithFormat:@"type=add&username=%@&rq_to=%@", m_strUserName, [dict objectForKey: @"userid"]];
//   [m_comm sendRequest:@"http://192.168.1.177/grintsite2/friend_request/" PARAM: params];
    [m_comm sendRequest:@"https://www.thegrint.com/friend_request/" PARAM: params];
    
//    [m_arrayList removeObjectAtIndex: m_nIndex];
    [dict setValue: @"100" forKey: @"status"];
    
    [self performSelectorOnMainThread:@selector(finishRequest) withObject:nil waitUntilDone: YES];
}

- (void) finishRequest
{
    [self.m_friendTable reloadData];
    
    if (m_spinner) {
        [m_spinner removeSpinner];
        m_spinner = nil;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"" message:@"Friend Request Sent!" delegate: nil cancelButtonTitle:@"Continue" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - textfield delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text && ![textField.text isEqualToString: @""]) {
        m_spinner = [SpinnerView loadSpinnerIntoView: self.view];
        [NSThread detachNewThreadSelector: @selector(searchFriends:) toTarget:self withObject: textField.text];
//        [self searchFriends: textField.text];
    } else {
        [self loadFriendList];
    }
    
    return YES;
}

#pragma mark - loading data

- (void) loadFriendList
{
//    NSMutableURLRequest *request = [NSMutableURLRequest
//									requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/friend_request/"]];
//    NSMutableURLRequest *request = [NSMutableURLRequest
//									requestWithURL:[NSURL URLWithString:@"http://192.168.1.177/grintsite2/friend_request/"]];
//    
//    NSString *params = [[NSString alloc] initWithFormat:@"type=get&username=%@", m_strUserName];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if (connection) {
//        data = [NSMutableData data];
//    }
//    NSString* downloadTemp = [m_comm sendRequest:@"https://www.thegrint.com/friend_request/" PARAM: params];
    
    m_spinner = [SpinnerView loadSpinnerIntoView: self.view];
    
    [NSThread detachNewThreadSelector:@selector(getFriendList) toTarget:self withObject:nil];
}

- (void) getFriendList
{
    m_nViewType = 0;

    NSString *params = [[NSString alloc] initWithFormat:@"type=get&username=%@", m_strUserName];
//    NSString* downloadTemp = [m_comm sendRequest:@"http://192.168.1.177/grintsite2/friend_request/" PARAM: params];
    NSString* downloadTemp = [m_comm sendRequest:@"https://www.thegrint.com/friend_request/" PARAM: params];
    
    if (m_spinner) {
        [m_spinner removeSpinner];
        m_spinner = nil;
    }
    [self parseFriendList: downloadTemp];
}

- (void) searchFriends : (NSString*) strName
{
    NSString* downloadTemp;
    
//    if (m_nType == 0) {
//        m_nViewType = 0;
    
        NSString *params = [[NSString alloc] initWithFormat:@"type=get&username=%@&key=%@", m_strUserName, strName];
//        downloadTemp = [m_comm sendRequest:@"http://192.168.1.177/grintsite2/friend_request/" PARAM: params];
        downloadTemp = [m_comm sendRequest:@"https://www.thegrint.com/friend_request/" PARAM: params];
    
//    } else {
//        m_nViewType = 1;
//        
//        NSString *params = [[NSString alloc] initWithFormat:@"type=search&username=%@&key=%@", m_strUserName, strName];
//    //    NSString* downloadTemp = [m_comm sendRequest:@"http://192.168.1.177/grintsite2/friend_request/" PARAM: params];
//        downloadTemp = [m_comm sendRequest:@"https://www.thegrint.com/friend_request/" PARAM: params];
//    }
    
    if (m_spinner) {
        [m_spinner removeSpinner];
        m_spinner = nil;
    }
    [self parseFriendList: downloadTemp];
}

- (void) parseFriendList: (NSString*) responseText
{
    if ([m_arrayList count] > 0) {
        [m_arrayList removeAllObjects];
    }
    NSMutableArray* arrayForAccept = [[NSMutableArray alloc] init];
    NSMutableArray* arrayForDelete = [[NSMutableArray alloc] init];
    NSMutableArray* arrayForNew = [[NSMutableArray alloc] init];
    
    NSString* friends = [self stringBetweenString:@"<friends>" andString:@"</friends>" forString: responseText];
    
    if(friends){
        for(NSString* friendString in [friends componentsSeparatedByString:@"</friend>"]) {
            if (friendString == nil || [friendString length] < 20)
                break;
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            NSString* strStatus = [self stringBetweenString:@"<status>" andString:@"</status>" forString: friendString];
            [dict setObject: strStatus forKey:@"status"];
            if (strStatus.integerValue >= 0) { // get friend list
                [dict setObject:[self stringBetweenString:@"<rq_from>" andString:@"</rq_from>" forString: friendString] forKey:@"rq_from"];
                [dict setObject:[self stringBetweenString:@"<rq_to>" andString:@"</rq_to>" forString: friendString] forKey:@"rq_to"];
            } else { // search result
                [dict setObject:[self stringBetweenString:@"<userid>" andString:@"</userid>" forString: friendString] forKey:@"userid"];
            }
            [dict setObject:[self stringBetweenString:@"<fname>" andString:@"</fname>" forString: friendString] forKey:@"fname"];
            [dict setObject:[self stringBetweenString:@"<lname>" andString:@"</lname>" forString: friendString] forKey:@"lname"];
            [dict setObject:[self stringBetweenString:@"<image>" andString:@"</image>" forString: friendString] forKey:@"image"];
            [dict setObject:[self stringBetweenString:@"<handicap>" andString:@"</handicap>" forString: friendString] forKey:@"handicap"];
            [dict setObject:[self stringBetweenString:@"<city>" andString:@"</city>" forString: friendString] forKey:@"city"];
            [dict setObject:[self stringBetweenString:@"<state>" andString:@"</state>" forString: friendString] forKey:@"state"];
            
            if ([self fullData: dict]) {
                if (strStatus.integerValue >= 0) {
                    if ([[dict objectForKey: @"status"] integerValue] == 0)
                        [arrayForAccept addObject: dict];
                    else if (strStatus.integerValue == 1 || strStatus.integerValue == 100)
                        [arrayForDelete addObject: dict];
                } else
                    [arrayForNew addObject: dict];
            }
        }
//        if (m_nViewType == 0) {
            [m_arrayList addObjectsFromArray: arrayForAccept];
            [m_arrayList addObjectsFromArray: arrayForDelete];
            [m_arrayList addObjectsFromArray: arrayForNew];
//        }
    }
    
    [self.m_friendTable reloadData];
}

- (BOOL) fullData: (NSDictionary*) dict
{
    if ([dict objectForKey: @"fname"] == nil || [[dict objectForKey: @"fname"] isEqualToString: @""] || [[dict objectForKey: @"fname"] isEqualToString: @"(null)"])
        return NO;
    if ([dict objectForKey: @"handicap"] == nil || [[dict objectForKey: @"handicap"] isEqualToString: @""] || [[dict objectForKey: @"handicap"] isEqualToString: @"(null)"])
        return NO;
    if ([dict objectForKey: @"city"] == nil || [[dict objectForKey: @"city"] isEqualToString: @""] || [[dict objectForKey: @"city"] isEqualToString: @"(null)"])
        return NO;
    return YES;
}


@end
