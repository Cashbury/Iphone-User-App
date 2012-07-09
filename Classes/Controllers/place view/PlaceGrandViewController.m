//
//  PlaceGrandViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 7/6/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlaceGrandViewController.h"
#import "KZCustomerReceiptHistoryViewController.h"
#import "OpenHoursViewController.h"
#import "PlacePrizesViewController.h"
#import "AddressAnnotation.h"
#import "CashburySummaryView.h"

#define TAG_PHONE_ACTIONSHEET   20
#define TAG_DIRECTION_ACTIONSHEET   21

@interface PlaceGrandViewController ()

@end

@implementation PlaceGrandViewController
@synthesize placeImageBg;
@synthesize placeIconImage;
@synthesize placeInfoLabel;
@synthesize phoneNumberLabel;
@synthesize cashboxAmtLabel;
@synthesize credictsSavedLabel;
@synthesize placeMapView;
@synthesize placeImagesView;
@synthesize aboutLabel;
@synthesize titleLabel;
@synthesize placeObject;
@synthesize placeScrollView;
@synthesize summaryScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 0) { 
		if ([actionSheet tag] == TAG_PHONE_ACTIONSHEET) {		// phone
			NSLog(@"Calling %@ ...", self.placeObject.phone);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.placeObject.phone]]];
		} else if ([actionSheet tag] == TAG_DIRECTION_ACTIONSHEET) {		// map
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/?q=%lf,%lf&spn=0.005139,0.009645&z=16", self.placeObject.latitude, self.placeObject.longitude]]];
		}
	}
}

#pragma mark - MapView
-(void)setUpMapView{
    
    self.placeMapView.showsUserLocation =   YES;
    self.placeMapView.delegate          =   self;
	CLLocationCoordinate2D location;
	location.latitude       =   self.placeObject.latitude;
    location.longitude      =   self.placeObject.longitude;
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta      =   0.003139;
	span.longitudeDelta     =   0.003645;
	
	region.span             =   span;
	region.center           =   location;	
    [self.placeMapView setRegion:region animated:TRUE];
	AddressAnnotation *addAnnotation    =   [[AddressAnnotation alloc] initWithCoordinate:location];
	[addAnnotation setTitle:placeObject.name andSubtitle:self.placeObject.name];
	[self.placeMapView addAnnotation:addAnnotation];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(AddressAnnotation*)annotation{
    if ([annotation isKindOfClass:[AddressAnnotation class]]) {
        static NSString *AnnotationViewID       =   @"AddAnnotationView";
        MKPinAnnotationView *annotationView    =   (MKPinAnnotationView*)[map dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        
        if (annotationView == nil){
            annotationView                  =   [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
        }
        annotationView.pinColor             =   MKPinAnnotationColorRed;
        annotationView.canShowCallout       =   YES;
        annotationView.annotation           =   annotation;
        return annotationView;
    }
    return nil;
}

-(void)setupSummaryView{
    CGFloat xValue  =   0;
    for (int i = 0; i < [self.placeObject.rewardsArray count]; i++) {
        PlaceReward *rewardObj          =   (PlaceReward*)[self.placeObject.rewardsArray objectAtIndex:i];
        NSArray* nibViews               =   [[NSBundle mainBundle] loadNibNamed:@"CashburySummaryView" owner:self options:nil];
        CashburySummaryView *cashView   =   [nibViews objectAtIndex:0];
        cashView.frame                  =   CGRectMake(xValue, 0, 310, 137);
        cashView.placeView              =   self.placeObject;
        cashView.reward                 =   rewardObj;
        PlaceAccount *getAcc            =   [placeObject.accountsDict objectForKey:[NSString stringWithFormat:@"%d",rewardObj.campaignID]];
        if ([getAcc.amount intValue] >= [rewardObj.neededAmount intValue]) {
            cashView.type                       =   CASHBURY_SUMMARY_TAPTOENJOY;
        }else {
            if (rewardObj.isSpend) {
                //cash back
                cashView.type                   =   CASHBURY_SUMMARY_CASHBACK;
            }else {
                cashView.type                   =   CASHBURY_SUMMARY_STARVIEW;
                
            }
        }
        [self.summaryScroll addSubview:cashView];
        
        xValue  =   xValue + 310;
    }
    [self.summaryScroll setContentSize:CGSizeMake([self.placeObject.rewardsArray count] * 310, 137)];
    
}

-(void)setupAllLabels{
    [self.placeScrollView setContentSize:CGSizeMake(self.placeScrollView.frame.size.width, 1086)];//1236
    self.titleLabel.text        =   self.placeObject.name;
    if (self.placeObject.shopImage != nil) {
        self.placeImageBg.image     =   self.placeObject.shopImage;
    }
    
    [self.placeIconImage loadImageWithAsyncUrl:[NSURL URLWithString:self.placeObject.smallImgURL]];
    
    //place info
    self.placeInfoLabel.text    =   [NSString stringWithFormat:@"%@. Open till 11 pm. %@m away @ %@",self.placeObject.about,placeObject.distance,self.placeObject.address];
    self.phoneNumberLabel.text  =   self.placeObject.phone;
    self.cashboxAmtLabel.text   =   @"$ 0.00";
    self.credictsSavedLabel.text    =   @"$10.00 saved here.";
    self.aboutLabel.text        =   self.placeObject.about;
    
    //Place images
    for (int i = 0; i <[self.placeObject.imagesArray count]; i ++) {
        CBAsyncImageView *imgView   =   (CBAsyncImageView*)[placeImagesView viewWithTag:i+10];
        [imgView loadImageWithAsyncUrl:[NSURL URLWithString:((PlaceImages*)[self.placeObject.imagesArray objectAtIndex:i]).thumbURL]];
        
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAllLabels];
    [self setupSummaryView];
    [self setUpMapView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPlaceImageBg:nil];
    [self setPlaceIconImage:nil];
    [self setPlaceInfoLabel:nil];
    [self setPhoneNumberLabel:nil];
    [self setCashboxAmtLabel:nil];
    [self setCredictsSavedLabel:nil];
    [self setPlaceMapView:nil];
    [self setPlaceImagesView:nil];
    [self setAboutLabel:nil];
    [self setTitleLabel:nil];
    [self setPlaceScrollView:nil];
    [self setSummaryScroll:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)hoursClicked:(id)sender {
    
    OpenHoursViewController *_controller    =   [[OpenHoursViewController alloc] initWithPlace:placeObject];
    [self magnifyViewController:_controller duration:0.35];
}

- (IBAction)cashburiesClicked:(id)sender {
    if ([[self.placeObject rewardsArray] count] < 1) return;
    PlacePrizesViewController *rewardController =  [[PlacePrizesViewController alloc]init];
    rewardController.placeObject                =   self.placeObject;
    [self magnifyViewController:rewardController duration:0.35];
}

- (IBAction)receiptsClicked:(id)sender {
    
    KZCustomerReceiptHistoryViewController *_controller = [[KZCustomerReceiptHistoryViewController alloc] initWithNibName:@"KZCustomerReceiptHistoryView" bundle:nil];
    _controller.place           =   self.placeObject;
    
    [self magnifyViewController:_controller duration:0.35];
    
    _controller.titleLabel.text = self.placeObject.name;
}

- (IBAction)directionClicked:(id)sender {
    
    if (self.placeObject.latitude > 0.0 || self.placeObject.longitude > 0.0) { 
		UIActionSheet *menu     =   [[UIActionSheet alloc] initWithTitle:@"This will quit Cashbury and open Google maps." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        menu.tag                =   TAG_DIRECTION_ACTIONSHEET;
		[menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[menu addButtonWithTitle:@"Get Directions"];
		[menu addButtonWithTitle:@"Cancel"];
		menu.cancelButtonIndex  =   1;
		
		[menu showInView:self.view];
		[menu release];
	}
}

- (IBAction)calButtonClicked:(id)sender {
    
    if ([self.placeObject.phone length] >0) { 
		UIActionSheet *menu     =   [[UIActionSheet alloc] initWithTitle:@"This will quit Cashbury and call the store." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		menu.tag                =   TAG_PHONE_ACTIONSHEET;
		[menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[menu addButtonWithTitle:@"Call"];
		[menu addButtonWithTitle:@"Cancel"];
		menu.cancelButtonIndex  =   1;
		[menu showInView:self.view];
		[menu release];
	}
}

- (IBAction)goBack:(id)sender {
    [self diminishViewController:self duration:0.35];
}
- (void)dealloc {
    [placeImageBg release];
    [placeIconImage release];
    [placeInfoLabel release];
    [phoneNumberLabel release];
    [cashboxAmtLabel release];
    [credictsSavedLabel release];
    [placeMapView release];
    [placeImagesView release];
    [aboutLabel release];
    [titleLabel release];
    [placeObject release];
    [placeScrollView release];
    [summaryScroll release];
    [super dealloc];
}
@end
