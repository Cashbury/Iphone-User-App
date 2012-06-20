//
//  PlayViewController.m
//  Cashbury
//
//  Created by Quintet Solutions on 4/26/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlayViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface PlayViewController ()

@end

@implementation PlayViewController
@synthesize scrollThree;
@synthesize scrollTwo;
@synthesize scrollOne;
@synthesize spinContainerView;
@synthesize fullScrollView;
@synthesize tag;

static const int numberOfPages      =   6;
static const int slotHeight         =   80;
SystemSoundID soundID;
NSURL *soundURL;
SystemSoundID spinningSoundId;
NSURL * spinningSoundURL;
CGFloat yValue      =   0.0;
CGFloat yValue2     =   0.0;
CGFloat yValue3     =   0.0;
CGFloat speed       =   0.07;
bool stopFirst      =   FALSE;
bool stopSecond     =   FALSE;
bool stopThird      =   FALSE;
float jerkSpeed     =   0.05;
float stopTime      =   4.0;
BOOL isPlaying      =   FALSE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)playSpinningSound{
    AudioServicesPlaySystemSound(spinningSoundId);
}

#pragma mark - Timers & Animations
-(void)moveScrollView1:(NSTimer*)timer{
	yValue								+=	1.0;
    
	if (yValue >= 326.0) {
		yValue							=	0.0;
	}
	[scrollOne setContentOffset:CGPointMake(0.0, yValue) animated:NO];
}

-(void)moveScrollView2:(NSTimer*)timer{
	yValue2								+=	1.0;
    
	if (yValue2 >= 326.0) {
		yValue2							=	0.0;
	}
	[scrollTwo setContentOffset:CGPointMake(0.0, yValue2) animated:NO];
}

-(void)moveScrollView3:(NSTimer*)timer{
	yValue3								+=	1.0;
    
	if (yValue3 >= 326.0) {//378.0
		yValue3							=	0.0;
	}
	[scrollThree setContentOffset:CGPointMake(0.0, yValue3) animated:NO];
}


-(void)startAutoScrolling1{
    stopFirst   =   FALSE;
    
	if (!scrollTimer) 
		scrollTimer						=	[NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveScrollView1:) userInfo:nil repeats:YES];
}
-(void)stopAutoScrolling1{
    stopFirst   =   TRUE;
    [self playSound];
}

-(void)startAutoScrolling2{
    
    stopSecond  =   FALSE;
    
	if (!scrollTimer2) 
		scrollTimer2						=	[NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveScrollView2:) userInfo:nil repeats:YES];
}
-(void)stopAutoScrolling2{
    stopSecond   =   TRUE;
    [self playSound];
}


-(void)startAutoScrolling3{
    stopThird   =   FALSE;
    
	if (!scrollTimer3) 
		scrollTimer3						=	[NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveScrollView3:) userInfo:nil repeats:YES];
}
-(void)stopAutoScrolling3{
    stopThird   =   TRUE;
    [self playSound];
    isPlaying   =   FALSE;
}

-(void)stopScrolling{
    
    [self performSelector:@selector(stopAutoScrolling1) withObject:nil afterDelay:0.05];
    [self performSelector:@selector(stopAutoScrolling2) withObject:nil afterDelay:1.7];
    [self performSelector:@selector(stopAutoScrolling3) withObject:nil afterDelay:2.8];
}

-(void)reduceSpeed1:(NSNumber*)speed2{
    [scrollTimer invalidate];  
    scrollTimer =   nil;
    speed       =   [speed2 floatValue];
    [self startAutoScrolling1];
    
    
    //    if ([speed2 floatValue] > 0.0055 && [speed2 floatValue] < 0.0065) 
    //        [self playSound];
    
}
-(void)reduceSpeed2:(NSNumber*)speed2{
    [scrollTimer2 invalidate];  
    scrollTimer2    =   nil;
    speed           =   [speed2 floatValue];
    [self startAutoScrolling2];
    
    //    if ([speed2 floatValue] > 0.0055 && [speed2 floatValue] < 0.006) 
    //        [self playSound];
    
}
-(void)reduceSpeed3:(NSNumber*)speed2{
    [scrollTimer3 invalidate];  
    scrollTimer3    =   nil;
    speed           =   [speed2 floatValue];
    [self startAutoScrolling3];
    
    //    if ([speed2 floatValue] > 0.0055 && [speed2 floatValue] < 0.006) 
    //        [self playSound];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender{	
    if (sender.tag == 1) {
        if (stopFirst) {
            float scrollPosition    =   scrollOne.contentOffset.y;
            
            //to stop scroller at an exact middle imageview
            if (scrollPosition == 0.0 || scrollPosition == 80.0 || scrollPosition == 160.0 || scrollPosition == 240.0 || scrollPosition == 320.0 || scrollPosition == 400.0 || scrollPosition == 480.0) {
                
                
                
                //stop scroller
                if (scrollTimer) {
                    [scrollTimer invalidate];
                    scrollTimer						=	nil;
                }
                scrollPosition  =   scrollPosition - 30;
                //animation block after stop to feel a jerk
                [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                    [scrollOne setContentOffset:CGPointMake(0.0, scrollPosition + 3.0) animated:NO];
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                        [scrollOne setContentOffset:CGPointMake(0.0, scrollPosition - 3.0) animated:NO];
                    }completion:^(BOOL finished){
                        [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                            [scrollOne setContentOffset:CGPointMake(0.0, scrollPosition-1.0) animated:NO];
                        }completion:^(BOOL finished){
                            
                        }];
                    }];
                }];
            }
        }
    }else if(sender.tag == 2){
        if (stopSecond) {
            float scrollPosition    =   scrollTwo.contentOffset.y;
            
            if (scrollPosition == 0.0 || scrollPosition == 80.0 || scrollPosition == 160.0 || scrollPosition == 240.0 || scrollPosition == 320.0 || scrollPosition == 400.0 || scrollPosition == 480.0) {
                if (scrollTimer2) {
                    [scrollTimer2 invalidate];
                    scrollTimer2						=	nil;
                }
                scrollPosition  =   scrollPosition - 30;
                [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                    [scrollTwo setContentOffset:CGPointMake(0.0, scrollPosition + 3.0) animated:NO];
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                        [scrollTwo setContentOffset:CGPointMake(0.0, scrollPosition - 3.0) animated:NO];
                    }completion:^(BOOL finished){
                        [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                            [scrollTwo setContentOffset:CGPointMake(0.0, scrollPosition-1.0) animated:NO];
                        }completion:^(BOOL finished){
                            
                        }];
                    }];
                }];
                
            }
        }
    }else if(sender.tag == 3){
        if (stopThird) {
            float scrollPosition    =   scrollThree.contentOffset.y;
            
            if (scrollPosition == 0.0 || scrollPosition == 80.0 || scrollPosition == 160.0 || scrollPosition == 240.0 || scrollPosition == 320.0 || scrollPosition == 400.0 || scrollPosition == 480.0) {
                if (scrollTimer3) {
                    [scrollTimer3 invalidate];
                    scrollTimer3						=	nil;
                }
                 scrollPosition  =   scrollPosition - 30;
                [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                    [scrollThree setContentOffset:CGPointMake(0.0, scrollPosition + 3.0) animated:NO];
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                        [scrollThree setContentOffset:CGPointMake(0.0, scrollPosition - 3.0) animated:NO];
                    }completion:^(BOOL finished){
                        [UIView animateWithDuration:jerkSpeed delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
                            [scrollThree setContentOffset:CGPointMake(0.0, scrollPosition-1.0) animated:NO];
                        }completion:^(BOOL finished){
                            
                        }];
                    }];
                }];
                
            }
        }
    }
    
}



#pragma mark - Play sound
-(void)playSound{
    AudioServicesPlaySystemSound(soundID);
    
}

-(void)shuffleArray:(NSMutableArray*)array scroll:(UIScrollView*)mScroll{
    int randomIndex;
    for( int index = 0; index < [array count]; index++ )
    {
        randomIndex = arc4random() % [array count];
        
        [array exchangeObjectAtIndex:index withObjectAtIndex:randomIndex];
    }
    
    NSInteger xValue    =   0;
    for (int i = 0; i < numberOfPages+3;i++ ) {
        
        UIImageView *imageView      =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, xValue, mScroll.frame.size.width, slotHeight)];
        if(i<6)
            [imageView setImage:[array objectAtIndex:i]];
        else
            [imageView setImage:[array objectAtIndex:i-6]];

        [mScroll addSubview:imageView];
        [imageView release];
        xValue  =   xValue + slotHeight;
    }
}






#pragma mark - Spin View
-(void)createSpinViews{
    
    imagesArrayOne      =   [[NSMutableArray alloc] init];
    imagesArrayTwo      =   [[NSMutableArray alloc] init];
    imagesArrayThree    =   [[NSMutableArray alloc] init];
    spingFloatArray     =   [[NSMutableArray alloc] init];
    positionArray       =   [[NSMutableArray alloc] init];
    
    NSString *soundFilePath                     =	[[NSBundle mainBundle] pathForResource:@"jackpot_cling" ofType:@"wav"];
    soundURL                                    =	[NSURL fileURLWithPath:soundFilePath isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &soundID);
    
    
    NSString *spinFilePath                      =	[[NSBundle mainBundle] pathForResource:@"wheelsTurning" ofType:@"wav"];
    spinningSoundURL                            =	[NSURL fileURLWithPath:spinFilePath isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)spinningSoundURL, &spinningSoundId);
    //played because initial play takes a delay, so playing it initially but it wont be heard.
    
    //floatArray values for reducing speeds.
    for (float i = 1.0; i > 0.0; i-=0.1) {
        [spingFloatArray addObject:[NSNumber numberWithFloat:i]];
    }
    for (float i = 1.0; i <= 9; i ++) {
        [positionArray addObject:[NSNumber numberWithFloat:(i-1) * slotHeight + 1]];
    }
    
    for (int i = 0; i < numberOfPages; i ++) {
        NSString *imgName   =   [NSString stringWithFormat:@"slot_%d",i+1];
        UIImage *slotImage  =   [UIImage imageNamed:imgName];
        [imagesArrayOne addObject:slotImage];
        [imagesArrayTwo addObject:slotImage];
        [imagesArrayThree addObject:slotImage];
    }
    [self shuffleArray:imagesArrayOne scroll:scrollOne];
    [self shuffleArray:imagesArrayTwo scroll:scrollTwo];
    [self shuffleArray:imagesArrayThree scroll:scrollThree];

    
    
    
    self.scrollOne.delegate     =   self;
    self.scrollTwo.delegate     =   self;
    self.scrollThree.delegate   =   self;
    self.scrollOne.scrollEnabled    =   NO;
    self.scrollTwo.scrollEnabled    =   NO;
    self.scrollThree.scrollEnabled  =   NO;
    self.scrollOne.scrollsToTop                     =   YES;
    self.scrollTwo.scrollsToTop                     =   YES;
    self.scrollThree.scrollsToTop                     =   YES;
    [scrollOne setContentSize:CGSizeMake(scrollOne.frame.size.width, slotHeight*numberOfPages)];
    [scrollTwo setContentSize:CGSizeMake(scrollTwo.frame.size.width, slotHeight*numberOfPages)];
    [scrollThree setContentSize:CGSizeMake(scrollThree.frame.size.width, slotHeight*numberOfPages)];

    
    [scrollOne setContentOffset:CGPointMake(0.0, 50) animated:NO];
    [scrollTwo setContentOffset:CGPointMake(0.0, 50) animated:NO];
    [scrollThree setContentOffset:CGPointMake(0.0,50) animated:NO];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fullScrollView setContentSize:CGSizeMake(320.0, 940.0)];
    [self createSpinViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSpinContainerView:nil];
    [self setFullScrollView:nil];
    [self setScrollOne:nil];
    [self setScrollTwo:nil];
    [self setScrollThree:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButtonClicked:(id)sender {
    
//    if (self.tag == FROM_CARDVIEW) {
//        [self diminishViewController:self duration:0.35f];
//    }    
    
    [self diminishViewController:self duration:0.35f];
    
    
}

- (IBAction)spinButtonClicked:(id)sender {
    
    
    if (isPlaying)
        return;
    
    //'speed' control the speed of spinning, lowest 'speed' value is the highest speed
    speed       =   0.00001;
    isPlaying   =   TRUE;
    [self playSpinningSound];
    [self startAutoScrolling1];
    [self startAutoScrolling2];
    [self startAutoScrolling3];
    
    //to slow down the scroller, we are changing the speeds after certain intervals by changing the time duration, for that initially performSelectors are calledwhen spin clicked
    int arrayIncr   =   0;
    for (float i=0.0015; i < 0.0065 ; i+=0.0005) {
        [self performSelector:@selector(reduceSpeed1:) withObject:[NSNumber numberWithFloat:i] afterDelay:stopTime-[[spingFloatArray objectAtIndex:arrayIncr] floatValue]];
        [self performSelector:@selector(reduceSpeed2:) withObject:[NSNumber numberWithFloat:i] afterDelay:stopTime+0.9-[[spingFloatArray objectAtIndex:arrayIncr] floatValue]];
        [self performSelector:@selector(reduceSpeed3:) withObject:[NSNumber numberWithFloat:i] afterDelay:stopTime+1.8-[[spingFloatArray objectAtIndex:arrayIncr] floatValue]];
        
        arrayIncr++;
    }
    
    [self performSelector:@selector(stopScrolling) withObject:nil afterDelay:stopTime];
}

- (IBAction)myPrizesClicked:(id)sender {
    [fullScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:TRUE];
}

- (IBAction)prizeBoardClicked:(id)sender {
     [fullScrollView setContentOffset:CGPointMake(0.0, 345.0) animated:TRUE];
}

- (IBAction)winnersBoardClicked:(id)sender {
    [fullScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:TRUE];
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(spinningSoundId);
    AudioServicesDisposeSystemSoundID(soundID);
    [spinContainerView release];
    [fullScrollView release];
    [scrollOne release];
    [scrollTwo release];
    [scrollThree release];
    [super dealloc];
}
@end
