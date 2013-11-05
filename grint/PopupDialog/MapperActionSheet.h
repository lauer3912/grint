//
//  MapperActionSheet.h
//  grint
//
//  Created by Mountain on 10/8/13.
//
//

#import <UIKit/UIKit.h>

#import "UIXOverlayController.h"

@protocol MyActionSheetDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void) acceptMakeMap;

@end

@interface MapperActionSheet : UIXOverlayContentViewController

@property(nonatomic, assign) id<MyActionSheetDelegate> delegate;

- (IBAction)actionMakeMap:(id)sender;
- (IBAction)actionCancel:(id)sender;
@end
