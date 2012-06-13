//
//  PlacesViewCell.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/8/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesViewCell : UITableViewCell<UIScrollViewDelegate>{
    
    NSTimer *moveTimer;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) NSMutableArray *placesArray;

@end
