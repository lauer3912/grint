//
//  GrintImageView.m
//  grint
//
//  Created by Peter Rocker on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintImageView.h"
#import "GrintImageDetail.h"

@implementation GrintImageView

@synthesize delegate, rows, images;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
            [cell.textLabel setText:[rows objectAtIndex:indexPath.row]];
    NSLog([[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingString: @"/"] stringByAppendingString:[rows objectAtIndex:indexPath.row]]);
    cell.imageView.image = [UIImage imageWithContentsOfFile:[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingString: @"/"] stringByAppendingString:[rows objectAtIndex:indexPath.row]]];                                                                       
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GrintImageDetail* gid = [[GrintImageDetail alloc]init ];
    gid.filePath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingString: @"/"] stringByAppendingString:[rows objectAtIndex:indexPath.row]];
    gid.delegate = self;
    [self presentModalViewController:gid animated:YES];
}



-(IBAction)backClick:(id)sender{
    [delegate dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    rows = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] error:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
