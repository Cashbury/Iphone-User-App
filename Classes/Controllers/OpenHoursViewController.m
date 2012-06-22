//
//  OpenHoursViewController.m
//  Cashbury
//
//  Created by Basayel Said on 5/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "OpenHoursViewController.h"
#import "KZOpenHours.h"
#import "QuartzCore/QuartzCore.h"

@implementation OpenHoursViewController

@synthesize place_btn, btn_close, lbl_title;

#pragma mark -
#pragma mark View lifecycle




- (id) initWithPlace:(PlaceView *) _place {
	if ((self = [super initWithNibName:@"OpenHoursView" bundle:nil])) {
		place = _place;
		[place retain];
    }
    
	return self;
}

- (IBAction)goBack:(id)sender {
    
    [self diminishViewController:self duration:0.35];
}

NSUInteger number_of_extra_fields;
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.lbl_title.text = [NSString stringWithFormat:@"Open Hours : %@", (place.isOpen ? @"Open now" : @"Closed now")];

	[self.place_btn setTitle:place.name forState:UIControlStateNormal];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [place.hoursArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        OpenHour *hour          =   [place.hoursArray objectAtIndex:indexPath.row];
        cell.textLabel.text     =   hour.day;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"From %@ to %@", hour.fromTime, hour.toTime];

    }
	return cell;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

/*
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
 */


- (void)dealloc {
	[place release];
    [place_btn release];
    [super dealloc];
}



@end

