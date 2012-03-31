//
//  CBReceiptTableCell.h
//  Cashbury
//
//  Created by ramikhawandi on 31/3/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBReceiptTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *placeLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *amountLabel;

@end
