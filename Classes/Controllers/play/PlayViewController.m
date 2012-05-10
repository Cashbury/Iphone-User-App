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

static const int numberOfPages   =   6;
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
            if (scrollPosition == 1.0 || scrollPosition == 55.0 || scrollPosition == 109.0 || scrollPosition == 163.0 || scrollPosition == 217.0 || scrollPosition == 271.0 || scrollPosition == 325.0) {
                
                scrollPosition  =   scrollPosition + 10;
                
                
                //stop scroller
                if (scrollTimer) {
                    [scrollTimer invalidate];
                    scrollTimer						=	nil;
                }
                
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
            
            if (scrollPosition == 0.0 || scrollPosition == 54.0 || scrollPosition == 108.0 || scrollPosition == 162.0 || scrollPosition == 216.0 || scrollPosition == 270.0 || scrollPosition == 324.0) {
                if (scrollTimer2) {
                    [scrollTimer2 invalidate];
                    scrollTimer2						=	nil;
                }
                 scrollPosition  =   scrollPosition + 10;
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
            
            if (scrollPosition == 0.0 || scrollPosition == 54.0 || scrollPosition == 108.0 || scrollPosition == 162.0 || scrollPosition == 216.0 || scrollPosition == 270.0 || scrollPosition == 324.0) {
                if (scrollTimer3) {
                    [scrollTimer3 invalidate];
                    scrollTimer3						=	nil;
                }
                 scrollPosition  =   scrollPosition + 10;
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



-(void)setImagesToSpin:(UIScrollView*)nowScrollView{
    NSMutableArray *numArray    =   [[NSMutableArray alloc] init];
    
    int random  =   0;
    
    for (int i = 0; i < numberOfPages; i++) {
        
        random  =   (arc4random() % numberOfPages);
        if ([numArray count] > 0) {
            
            while ([numArray containsObject:[NSNumber numberWithInt:random]]) {
                random  =   (arc4random() % numberOfPages) + 1;
            }
            
        }
        [numArray addObject:[NSNumber numberWithInt:random]];
        UIImageView *imgView    =   [[UIImageView alloc]initWithImage:[spinImagesArray objectAtIndex:random]];
        imgView.frame           =   CGRectMake(2, 54*i, 54.0, 54.0);
        imgView.tag             =   i+1;
        [nowScrollView addSubview:imgView];
        [imgView release];

    }  
    
}

#pragma mark - Spin View
-(void)createSpinViews{
    
    spinImagesArray     =   [[NSMutableArray alloc] init];
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
    
    //adding the 6 images to imagesArray
    for (int i=1; i<=numberOfPages; i++) {
        [spinImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i]]];
    }
    for (float i = 1.0; i <= 9; i ++) {
        [positionArray addObject:[NSNumber numberWithFloat:(i-1) * 54.0 + 1]];
    }
    self.scrollOne.delegate     =   self;
    self.scrollTwo.delegate     =   self;
    self.scrollThree.delegate   =   self;
    self.scrollOne.scrollEnabled    =   NO;
    self.scrollTwo.scrollEnabled    =   NO;
    self.scrollThree.scrollEnabled  =   NO;
    self.scrollOne.scrollsToTop                     =   YES;
    self.scrollTwo.scrollsToTop                     =   YES;
    self.scrollThree.scrollsToTop                     =   YES;
    [scrollOne setContentSize:CGSizeMake(scrollOne.frame.size.width, scrollOne.frame.size.height*numberOfPages)];
    [scrollTwo setContentSize:CGSizeMake(scrollTwo.frame.size.width, scrollTwo.frame.size.height*numberOfPages)];
    [scrollThree setContentSize:CGSizeMake(scrollThree.frame.size.width, scrollThree.frame.size.height*numberOfPages)];
//    
//    [self setImagesToSpin:scrollOne];
//    [self setImagesToSpin:scrollTwo];
    //[self setImagesToSpin:scrollThree];
    
    
    //1st scroller imageviews
    
    for (int i=0; i<9; i++) {
        NSNumber *position  =   [positionArray objectAtIndex:i];
        UIImageView *imageView1 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, [position floatValue], scrollOne.frame.size.width, 54.0)];
        if(i<6)
            [imageView1 setImage:[spinImagesArray objectAtIndex:i]];
        else
            [imageView1 setImage:[spinImagesArray objectAtIndex:i-6]];
        [scrollOne addSubview:imageView1];
    }    
    
    //2nd scroller imageviews
    UIImageView *imageView2_1 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, scrollOne.frame.size.width, 54.0)];
    [imageView2_1 setImage:[UIImage imageNamed:@"image_4"]];
    [scrollTwo addSubview:imageView2_1];
    
    UIImageView *imageView2_2 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 54.0, scrollOne.frame.size.width, 54.0)];
    [imageView2_2 setImage:[UIImage imageNamed:@"image_6"]];
    [scrollTwo addSubview:imageView2_2];
    
    UIImageView *imageView2_3 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 108.0, scrollOne.frame.size.width, 54.0)];
    [imageView2_3 setImage:[UIImage imageNamed:@"image_2"]];
    [scrollTwo addSubview:imageView2_3];
    
    UIImageView *imageView2_4 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 162.0, scrollOne.frame.size.width, 54.0)];
    [imageView2_4 setImage:[UIImage imageNamed:@"image_5"]];
    [scrollTwo addSubview:imageView2_4];
    
    UIImageView *imageView2_5 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 216.0, scrollOne.frame.size.width, 54.0)];
    [imageView2_5 setImage:[UIImage imageNamed:@"image_1"]];
    [scrollTwo addSubview:imageView2_5];
    
    UIImageView *imageView2_6 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 270.0, scrollOne.frame.size.width, 54.0)];
    [imageView2_6 setImage:[UIImage imageNamed:@"image_3"]];
    [scrollTwo addSubview:imageView2_6];
    
    UIImageView *imageView2_11 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 324.0, scrollOne.frame.size.width, 54.0)];
    [imageView2_11 setImage:[UIImage imageNamed:@"image_4"]];
    [scrollTwo addSubview:imageView2_11];
    
    UIImageView *imageView2_22 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 378.0, scrollTwo.frame.size.width, 54.0)];
    [imageView2_22 setImage:[UIImage imageNamed:@"image_6"]];
    [scrollTwo addSubview:imageView2_22];
    
    UIImageView *imageView2_33 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 432.0, scrollTwo.frame.size.width, 54.0)];
    [imageView2_33 setImage:[UIImage imageNamed:@"image_2"]];
    [scrollTwo addSubview:imageView2_33];
    
    
    //3rd scroller imageviews
    UIImageView *imageView3_1 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, scrollTwo.frame.size.width, 54.0)];
    [imageView3_1 setImage:[UIImage imageNamed:@"image_2"]];
    [scrollThree addSubview:imageView3_1];
    
    UIImageView *imageView3_2 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 54.0, scrollTwo.frame.size.width, 54.0)];
    [imageView3_2 setImage:[UIImage imageNamed:@"image_4"]];
    [scrollThree addSubview:imageView3_2];
    
    UIImageView *imageView3_3 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 108.0, scrollTwo.frame.size.width, 54.0)];
    [imageView3_3 setImage:[UIImage imageNamed:@"image_6"]];
    [scrollThree addSubview:imageView3_3];
    
    UIImageView *imageView3_4 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 162.0, scrollThree.frame.size.width, 54.0)];
    [imageView3_4 setImage:[UIImage imageNamed:@"image_1"]];
    [scrollThree addSubview:imageView3_4];
    
    UIImageView *imageView3_5 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 216.0, scrollThree.frame.size.width, 54.0)];
    [imageView3_5 setImage:[UIImage imageNamed:@"image_3"]];
    [scrollThree addSubview:imageView3_5];
    
    UIImageView *imageView3_6 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 270.0, scrollThree.frame.size.width, 54.0)];
    [imageView3_6 setImage:[UIImage imageNamed:@"image_5"]];
    [scrollThree addSubview:imageView3_6];
    
    UIImageView *imageView3_11 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 324.0, scrollThree.frame.size.width, 54.0)];
    [imageView3_11 setImage:[UIImage imageNamed:@"image_2"]];
    [scrollThree addSubview:imageView3_11];
    
    UIImageView *imageView3_22 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 378.0, scrollThree.frame.size.width, 54.0)];
    [imageView3_22 setImage:[UIImage imageNamed:@"image_4"]];
    [scrollThree addSubview:imageView3_22];
    
    UIImageView *imageView3_33 =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 432.0, scrollThree.frame.size.width, 54.0)];
    [imageView3_33 setImage:[UIImage imageNamed:@"image_6"]];
    [scrollThree addSubview:imageView3_33];
    
    [scrollOne setContentOffset:CGPointMake(0.0, 65) animated:NO];
    [scrollTwo setContentOffset:CGPointMake(0.0, 65) animated:NO];
    [scrollThree setContentOffset:CGPointMake(0.0, 65) animated:NO];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fullScrollView setContentSize:CGSizeMake(320.0, 935.0)];
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
