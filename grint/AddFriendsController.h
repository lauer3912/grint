//
//  AddFriendsController.h
//  grint
//
//  Created by Passioner on 9/19/13.
//
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface AddFriendsController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *m_labelCaption;
@property (retain, nonatomic) IBOutlet UILabel *m_labelSearch;
@property (retain, nonatomic) IBOutlet UITextField *m_textName;
@property (retain, nonatomic) IBOutlet UITableView *m_friendTable;

@property int m_nType;


- (IBAction)searchFriend:(id)sender;

- (IBAction)actionFromContacts:(id)sender;

//variables setting out of this class
@property (nonatomic, retain) NSString* m_strUserName;

@end
