//
//  CashierTxReceiptHistoryCell.h
//  Cashbery
//
//  Created by Rami Khawandi on 5/12/11.
//  Copyright (c) 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashierTxReceiptHistoryCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *amount;
@property (nonatomic, retain) IBOutlet UIButton *refundButton;
@property (nonatomic, retain) IBOutlet UIImageView *icon;

@property (nonatomic, retain) NSDictionary *receipt;

@end
