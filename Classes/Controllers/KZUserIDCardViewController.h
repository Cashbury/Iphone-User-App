//
//  KZUserIDCardViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/10/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZReceiptsDelegate.h"
#import "KZURLRequest.h"
#import "KZPlace.h"

@interface KZUserIDCardViewController : UIViewController <KZReceiptsDelegate, KZURLRequestDelegate> {

}

@property (nonatomic, retain) KZPlace* place;
@property (nonatomic, retain) IBOutlet UIImageView* img_user_id_card;

- (IBAction) doneAction;

@end
