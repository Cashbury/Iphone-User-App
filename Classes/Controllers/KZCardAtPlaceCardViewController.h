//
//  KZCardAtPlaceCardViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/28/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZBusiness.h"

@interface KZCardAtPlaceCardViewController : UIViewController {
	KZBusiness* biz;
}

@property (nonatomic, retain) IBOutlet UIImageView* img_logo;
@property (nonatomic, retain) IBOutlet UILabel* lbl_brand_name;
@property (nonatomic, retain) IBOutlet UIButton* btn_info;

- (id)initWithBusiness:(KZBusiness *)_biz;
- (IBAction) didTapInfo;
- (IBAction) didTapCard;

@end
