//
//  SearchLeaderboardViewController.h
//  grint
//
//  Created by Peter Rocker on 08/05/2013.
//
//

#import <UIKit/UIKit.h>

@interface SearchLeaderboardViewController : UIViewController{
    IBOutlet UITableView* tableView1;
    IBOutlet UISearchBar* searchBar1;
}

@property(nonatomic, retain) NSString* nameString;
@property(nonatomic, retain) NSString* lastName;

@end
