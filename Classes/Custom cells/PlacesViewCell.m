//
//  PlacesViewCell.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/8/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlacesViewCell.h"
#import "PlaceView.h"

@implementation PlacesViewCell
@synthesize scrollView;
@synthesize placesArray;

-(void)addPlacesToArray{
    for (int i = 0; i < 4; i ++) {
        PlaceView *place    =   [[PlaceView alloc]init];
        switch (i) {
            case 0:
                place.name      =   @"Coupa Cafe";
                place.discount  =   @"$ 10 OFF . Open . 50m away";
                place.icon      =   [UIImage imageNamed:@"coupaIcon"];
                place.shopImage =   [UIImage imageNamed:@"coupaimg"];
                break;
            case 1:
                place.name      =   @"Samovar";
                place.discount  =   @"$ 10 OFF . 100m away";
                place.icon      =   [UIImage imageNamed:@"icon_3"];
                place.shopImage =   [UIImage imageNamed:@"bg_3"];
                
                break;
            case 2:
                place.name      =   @"La Bounlange";
                place.discount  =   @"$ 10 OFF . 100m away";
                place.icon      =   [UIImage imageNamed:@"icon_2"];
                place.shopImage =   [UIImage imageNamed:@"bg_2"];
                
                break;
            case 3:
                place.name      =   @"Al Falamanki";
                place.discount  =   @"$ 10 OFF . 100m away";
                place.icon      =   [UIImage imageNamed:@"icon_1"];
                place.shopImage =   [UIImage imageNamed:@"bg_1"];
                
                break;
                
            default:
                break;
        }
        [placesArray addObject:place];
        [place release];
        
    }
}

-(void)movePlaces{

    
    [scrollView scrollRectToVisible:CGRectMake(scrollView.contentOffset.x+320,self.scrollView.frame.origin.y,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:TRUE]; 
    
    if (scrollView.contentOffset.x == placesArray.count * 320) {         
        [scrollView scrollRectToVisible:CGRectMake(0.0,self.scrollView.frame.origin.y,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];         
    }
    
    
}

- (void)addPlace:(PlaceView*)place atPosition:(NSInteger)position withTag:(NSInteger)cTag {

    
    UIView *containerView           =   [[UIView alloc] initWithFrame:CGRectMake(position, 0, 320, 135)];
    [containerView setUserInteractionEnabled:TRUE];
    containerView.tag               =   cTag;
    
    UIImageView *shopImage          =   [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
    shopImage.image                 =   place.shopImage;
    [containerView addSubview:shopImage];
    [shopImage release];
    
    UIImageView *iconImage          =   [[UIImageView alloc] initWithFrame:CGRectMake(6, 77, 42, 42)];
    iconImage.image                 =   place.icon;
    [containerView addSubview:iconImage];
    [iconImage release];
    
    UILabel *shopName               =   [[UILabel alloc]initWithFrame:CGRectMake(56.0, 78.0, 249.0, 20.0)];
    shopName.backgroundColor        =   [UIColor clearColor];
    shopName.font                   =   [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    shopName.textColor              =   [UIColor whiteColor];
    shopName.text                   =   place.name;
    shopName.textAlignment          =   UITextAlignmentLeft;
    [containerView addSubview:shopName];
    [shopName release];
    
    UILabel *discountLabel          =   [[UILabel alloc]initWithFrame:CGRectMake(56.0, 99, 249.0, 15.0)];
    discountLabel.backgroundColor   =   [UIColor clearColor];
    discountLabel.font              =   [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    discountLabel.textColor         =   [UIColor whiteColor];
    discountLabel.text              =   place.discount;
    discountLabel.textAlignment     =   UITextAlignmentLeft;
    [containerView addSubview:discountLabel];
    [discountLabel release];
    
    [self.scrollView addSubview:containerView];
    [containerView release];
    
    
    
}



-(void)setPlacesToScrollView{
    
    CGFloat xValue   =   320;
    self.scrollView.delegate    =   self;
    scrollView.contentSize = CGSizeMake(([placesArray count] +2) * 320, self.scrollView.frame.size.height);    
	[scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width,self.scrollView.frame.origin.y,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO]; 
    
    PlaceView *lastPlace       =   [placesArray lastObject];
    [self addPlace:lastPlace atPosition:0 withTag:[placesArray count]];
    
    for (int i = 0; i < [placesArray count]; i ++) {
        PlaceView *place        =   [placesArray objectAtIndex:i];
        [self addPlace:place atPosition:xValue withTag:i+1];
        xValue                  =   xValue + 320;   
    }
    
    PlaceView *firstPlace       =   [placesArray objectAtIndex:0];
    [self addPlace:firstPlace atPosition:xValue withTag:1];
    [self validateTimer];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender 
{
	if (scrollView.contentOffset.x == 0) {         
		[scrollView scrollRectToVisible:CGRectMake(placesArray.count * 320,self.scrollView.frame.origin.y,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];     
	}    
	else if (scrollView.contentOffset.x == (placesArray.count +1) * 320) {         
		[scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width,self.scrollView.frame.origin.y,self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO];         
	}
}

-(void)invalidateTimer{
    if (moveTimer) {
        [moveTimer invalidate];
        moveTimer   =   nil;
    }
}

-(void)validateTimer{
    if (moveTimer == nil) {
        moveTimer   =   [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(movePlaces) userInfo:nil repeats:YES];
    }
     
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nib    =   [[NSBundle mainBundle] loadNibNamed:@"PlacesViewCell" owner:self options:nil];
        self            =   [nib objectAtIndex:0];
        placesArray     =   [[NSMutableArray alloc] init];
        [self addPlacesToArray];
        [self setPlacesToScrollView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateTimer) name:@"InvalidatePlaceTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateTimer) name:@"ValidatePlaceTimer" object:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [scrollView release];
    if (moveTimer) {
        [moveTimer invalidate];
        moveTimer   =   nil;
    }
    //[placesArray release];
    [super dealloc];
}
@end
