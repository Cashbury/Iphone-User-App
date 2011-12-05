//
//  CWItem.m
//  Cashbery
//
//  Created by Basayel Said on 7/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CWItemEngagement.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZURLRequest.h"
#import "KZApplication.h"
#import "KZUserInfo.h"


@implementation CWItemEngagement

@synthesize business_id, engagement_id, item_id, name, image_url, delegate;

- (void)dealloc {
	self.name = nil;
	self.image_url = nil;
	
    [super dealloc];
}


static CWItemEngagement* shared = nil;
static NSMutableArray* items = nil;

+ (void) getItemsHavingEngagementsForBusiness:(NSUInteger)_biz_id andDelegate:(id<CWItemFetchDelegate>)_delegate {
	if (shared == nil) {
		shared = [[CWItemEngagement alloc] init];
		items = [[NSMutableArray alloc] init];
	}
	shared.delegate = _delegate;
	if (shared.business_id == _biz_id) {
		[shared.delegate gotItems:(NSArray*)items];
	} else {
		shared.business_id = _biz_id;
		//[shared KZURLRequest:nil didSucceedWithData:nil];
		
		NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
		[_headers setValue:@"application/xml" forKey:@"Accept"];
		[[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/cashiers/business/%d/items.xml?auth_token=%@", 
																		 API_URL, shared.business_id, [KZUserInfo shared].auth_token]
															  andParams:nil 
															   delegate:shared 
																headers:_headers 
													  andLoadingMessage:nil];
		[_headers release];
	}	
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	[self.delegate itemsFetchError:[theError description]];
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	*/
	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {

	//NSString* xml = @"<hash><items type=\"array\">	<item><engagement-id>14</engagement-id><item-id>6</item-id><item-name>Coffee Drink</item-name><item-image-url>http://s3.amazonaws.com/cashbury-dev/items/101/thumb/1161508579.jpg</item-image-url></item>	<item><engagement-id>15</engagement-id><item-id>7</item-id><item-name>Cocoa</item-name><item-image-url>http://s3.amazonaws.com/cashbury-dev/items/101/thumb/1161508579.jpg</item-image-url></item>	<item><engagement-id>16</engagement-id><item-id>8</item-id><item-name>Ice Cream</item-name><item-image-url>http://s3.amazonaws.com/cashbury-dev/items/101/thumb/1161508579.jpg</item-image-url></item>	<item><engagement-id>17</engagement-id><item-id>9</item-id><item-name>Fraputchino</item-name><item-image-url>http://s3.amazonaws.com/cashbury-dev/items/101/thumb/1161508579.jpg</item-image-url></item>	<item><engagement-id>18</engagement-id><item-id>10</item-id><item-name>Milk Shake</item-name><item-image-url>http://s3.amazonaws.com/cashbury-dev/items/101/thumb/1161508579.jpg</item-image-url></item>	<item><engagement-id>19</engagement-id><item-id>11</item-id><item-name>Lemon Juice</item-name><item-image-url>http://s3.amazonaws.com/cashbury-dev/items/101/thumb/1161508579.jpg</item-image-url></item>	<item><engagement-id>20</engagement-id><item-id>12</item-id><item-name>Coffee Drink</item-name><item-image-url>http://s3.amazonaws.com/cashbury-dev/items/101/thumb/1161508579.jpg</item-image-url></item>		</items></hash>";
	//theData = [xml dataUsingEncoding:NSUTF8StringEncoding];
	[items removeAllObjects];
	// parse the XML then populate the array of items
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSArray *_nodes = [_document nodesForXPath:@"//items/item" error:nil];
	for (CXMLElement *_node in _nodes) {
		NSLog([_node description]);
		CWItemEngagement* item = [[CWItemEngagement alloc] init];
		item.business_id = self.business_id;
		item.engagement_id = [[_node stringFromChildNamed:@"engagement-id"] intValue];
		item.item_id = [[_node stringFromChildNamed:@"item-id"] intValue];
		item.name = [_node stringFromChildNamed:@"item-name"];
		item.image_url = [_node stringFromChildNamed:@"item-image-url"];
		[items addObject:item];
		[item release];
	} 
	[self.delegate gotItems:(NSArray*)items];
	[theRequest release];
}

+ (CWItemEngagement*) getItemByEngagementId:(NSUInteger)_engagement_id {
	if ([items count] < 1) return nil;
	for (CWItemEngagement *item in items) {
		if (item.engagement_id == _engagement_id) {
			return item;
		}
	}
	return nil;
}

@end
