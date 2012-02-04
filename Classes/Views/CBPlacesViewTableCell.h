//
//  CBPlacesViewTableCell.h
//  Cashbury
//
//  Created by Rami on 4/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAsyncImageView.h"

@interface CBPlacesViewTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet CBAsyncImageView *placeImage;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;

@end
