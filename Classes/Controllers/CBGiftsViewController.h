//
//  CBGiftsViewController.h
//  Cashbury
//
//  Created by Rami on 14/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMagnifiableViewController.h"
#import "CBLockViewController.h"

@protocol CBGiftsViewControllerDelegate <NSObject>

-(void)changeLockButtonState;

@end

@interface CBGiftsViewController : CBMagnifiableViewController<CBLockViewControllerDelegate>{
    NSString *firstPIN;
    NSString *secondPIN;
}

@property (retain, nonatomic) IBOutlet UISwitch *codeSwitch;
@property (retain, nonatomic) id<CBGiftsViewControllerDelegate>buttonDelegate;
- (IBAction)switchChanged:(id)sender;
- (IBAction)goBack:(id)sender;
@end
