//
//  CBMagnifiableViewController.h
//  Cashbury
//
//  Created by Rami Khawandi on 5/1/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CBMaginfyViewController.h"

@class CBMagnifiableViewController;

@protocol CBMagnifiableViewControllerDelegate <NSObject>
- (void) dismissViewController:(CBMagnifiableViewController *)theController;
@end

@interface CBMagnifiableViewController : UIViewController

@property (nonatomic, assign) id<CBMagnifiableViewControllerDelegate> delegate;

- (IBAction) didTapToCloseView:(id)theSender;

@end
