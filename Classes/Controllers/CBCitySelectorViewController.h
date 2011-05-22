//
//  CBCitySelectorController.h
//  Cashbery
//
//  Created by Rami on 17/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBCitySelectorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
   
}

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UITableView *tbl_cities;


- (IBAction) didTapCancelButton:(id)theSender;

@end
