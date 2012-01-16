//
//  CBCitySelectorController.h
//  Cashbury
//
//  Created by Rami on 17/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZCity.h"
#import "KZApplication.h"
#import "CBDropDownLabel.h"

@interface CBCitySelectorCell : UITableViewCell

+ (CBCitySelectorCell *) citySelectorCellWithName:(NSString *)theCityName flagURL:(NSURL *)theFlagURL;

@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UIImageView *cityFlag;

@end

@interface CBCitySelectorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CitiesDelegate>
{
    @private
    NSDictionary *cities;
	NSDictionary *flags_urls;
    KZCity *cityBank;
}

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UITableView *tbl_cities;
@property (nonatomic, retain) IBOutlet CBDropDownLabel *currentCityLabel;

- (IBAction) close:(id)theSender;

@end
