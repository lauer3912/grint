//
//  TDDatePickerController.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDDatePickerController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TDDatePickerController
@synthesize datePicker, delegate;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    datePicker.date = [NSDate date];
    
  //  datePicker.minimumDate = [[NSDate alloc]init];
    datePicker.maximumDate = [NSDate date];
    
    for (UIView* subview in datePicker.subviews) {
        subview.frame = datePicker.bounds;
    }
    
    //circle label
//    [labelAvgScoreToday.layer setCornerRadius: labelAvgScoreToday.bounds.size.width/2];

//    [labelGPS.layer setCornerRadius: labelGPS.bounds.size.width/2];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Actions

-(IBAction)saveDateEdit:(id)sender {
    if([self.delegate respondsToSelector:@selector(datePickerSetDate:)]) {
        [self.delegate datePickerSetDate:self];
        [self.delegate dismissModalViewControllerAnimated:YES];
    }
    else{
        
        [self.delegate dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)clearDateEdit:(id)sender {
    if([self.delegate respondsToSelector:@selector(datePickerClearDate:)]) {
        [self.delegate datePickerClearDate:self];
    }
}

-(IBAction)cancelDateEdit:(id)sender {
    if([self.delegate respondsToSelector:@selector(datePickerCancel:)]) {
        [self.delegate datePickerCancel:self];
        
        [self.delegate dismissModalViewControllerAnimated:YES];
    } else {
        // just dismiss the view automatically?
        
        [self.delegate dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.datePicker = nil;
    self.delegate = nil;
    
}

- (void)dealloc {
    self.datePicker = nil;
    self.delegate = nil;
    
}


@end