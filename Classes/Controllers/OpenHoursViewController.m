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

NSUInteger number_of_extra_fields;
- (void)viewDidLoad {
    [super viewDidLoad];
	/*
	NSMutableArray *all_days = [[NSMutableArray alloc] initWithObjects:
							@"Monday", 
							@"Tuesday", 
							@"Wednesday", 
							@"Thursday", 
							@"Friday", 
							@"Saturday", 
							@"Sunday"];
	NSMutableArray *open_days = [[NSMutableArray alloc] init];
	//NSLog(@"DAY: %@", [place.open_hours valueForKey:@"@hour.day=Monday"]);
	
    number_of_extra_fields = 0;
	for (KZOpenHours *hour in place.open_hours) {
		if ([open_days ) {
			
		}
	}
	 */
    //////////////////////////////////////////////////////

	
//	[self.place_btn setTitle:[NSString stringWithFormat:@"%@ \\ Hours", place.business.name] forState:UIControlStateNormal];
	
	/*
	 
	 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	 
	 UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
	 CGSize size = [place.business.name sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
	 
	[self.place_btn setTitle:place.business.name forState:UIControlStateNormal];
	 
	CGRect other_frame = self.other_btn.frame;
	other_frame.origin.x = 50 + size.width;
	CGRect place_frame = self.place_btn.frame;
	place_frame.size.width = size.width;
	self.other_btn.frame = other_frame;
	self.place_btn.frame = place_frame;
	*/
	//////////////////////////////////////////////////////
	self.lbl_title.text = [NSString stringWithFormat:@"Open Hours : %@", (place.is_open ? @"Open now" : @"Closed now")];

	[self.place_btn setTitle:place.business.name forState:UIControlStateNormal];
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [all_hours count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		id obj = [all_hours objectAtIndex:indexPath.row];//(KZOpenHours*)[place.open_hours objectAtIndex:[indexPath row]];
		
		if ([obj class] == [KZOpenHours class]) { 
			KZOpenHours* hour = (KZOpenHours*)obj;
			cell.textLabel.text = hour.day;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"From %@ to %@", hour.from_time, hour.to_time];
		} else {
			cell.textLabel.text = (NSString*)obj;
			cell.detailTextLabel.text = @"is off";
		}
    }
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

- (id) initWithPlace:(KZPlace *) _place {
	if ((self = [super initWithNibName:@"OpenHoursView" bundle:nil])) {
		place = _place;
		[place retain];
		
		/// Check hours of operation
		NSMutableArray *days_names = [NSMutableArray arrayWithObjects:
					  @"Monday", 
					  @"Tuesday", 
					  @"Wednesday", 
					  @"Thursday", 
					  @"Friday", 
					  @"Saturday", 
					  @"Sunday", nil];
		rows_count = 7;
		days_hours = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					  nil, @"Monday", 
					  nil, @"Tuesday", 
					  nil, @"Wednesday", 
					  nil, @"Thursday", 
					  nil, @"Friday", 
					  nil, @"Saturday", 
					  nil, @"Sunday"];
		NSMutableArray* hours_in_day = nil;
		NSUInteger current_day_number = 0;
		NSUInteger index_in_day = 0;
		for (KZOpenHours* hour in place.open_hours) {
			hours_in_day = (NSMutableArray*)[days_hours objectForKey:hour.day];
			if (hours_in_day == nil) {	// first hour entry in this day
				hours_in_day = [[[NSMutableArray alloc] init] autorelease];
				[hours_in_day addObject:hour];
			} else {	// not the first hour entry in this day
				rows_count++;
				[hours_in_day addObject:hour];
			}
			[days_hours setValue:hours_in_day forKey:hour.day];
		}
		all_hours = [[NSMutableArray alloc] initWithCapacity:rows_count];

		while (YES) {
			NSString* current_day_name = (NSString*)[days_names objectAtIndex:current_day_number];
			NSMutableArray* hours = (NSMutableArray*)[days_hours valueForKey:current_day_name];
			if (hours == nil) {
				[all_hours addObject:current_day_name];
				// get next day name and set index to 0
				current_day_number++;
				index_in_day = 0;
			} else {
				if (index_in_day >= [hours count]) {
					current_day_number++;
					index_in_day = 0;
					
				} else {
					KZOpenHours* open_hour = [hours objectAtIndex:index_in_day];
					[all_hours addObject:open_hour];
					index_in_day++;
				}
			}
			if (current_day_number > 6) break;
			
		}
		NSLog(@"%@", [all_hours description]);
		//////////////////////////
	}
	return self;
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
	[all_hours release];
    [super dealloc];
}

- (IBAction)goBackToPlace:(id)theSender {
	[self dismissModalViewControllerAnimated:YES];
    //[parentController didTapBackButton:nil];
}

- (IBAction)goBacktoPlaces:(id)theSender {
	[self dismissModalViewControllerAnimated:YES];
    //[parentController goBacktoPlaces:nil];
}

@end

