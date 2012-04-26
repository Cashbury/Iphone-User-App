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

@interface CBGiftsViewController : CBMagnifiableViewController<CBLockViewControllerDelegate>{
    NSString *firstPIN;
    NSString *secondPIN;
}

@property (retain, nonatomic) IBOutlet UISwitch *codeSwitch;
- (IBAction)switchChanged:(id)sender;
@end
