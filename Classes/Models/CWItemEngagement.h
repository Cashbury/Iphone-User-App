//
//  CWItem.h
//  Cashbery
//
//  Created by Basayel Said on 7/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWItemFetchDelegate.h"
#import "KZURLRequest.h"

@interface CWItemEngagement : UITableViewCell <KZURLRequestDelegate> {


}
@property (nonatomic) NSUInteger business_id;
@property (nonatomic) NSUInteger engagement_id;
@property (nonatomic) NSUInteger item_id;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* image_url;
@property (nonatomic, assign) id<CWItemFetchDelegate> delegate;

+ (void) getItemsHavingEngagementsForBusiness:(NSUInteger)_biz_id andDelegate:(id<CWItemFetchDelegate>)_delegate;

+ (CWItemEngagement*) getItemByEngagementId:(NSUInteger)_engagement_id;

@end
