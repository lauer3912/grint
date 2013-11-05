//
//  GrintActivityFeedViewController.h
//  grint
//
//  Created by Peter Rocker on 05/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface GrintActivityFeedViewController : UIViewController{
    IBOutlet UILabel* label1;
    IBOutlet UITableView* tableView1;
    
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* nameString;

@property (nonatomic, retain) NSString* currentID;
@property (nonatomic, retain) NSString* currentUser;

@property (nonatomic, retain) NSMutableArray* tableData;

@property (nonatomic, retain) NSMutableData* receivedData;

@property (nonatomic, retain) NSURLConnection * connection;

@property (nonatomic, retain)SpinnerView* spinnerView1;

- (void) reloadTableData;

@end
