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

@synthesize parentController, place_btn, btn_close;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //////////////////////////////////////////////////////

	
	[self.place_btn setTitle:[NSString stringWithFormat:@"%@ \\ Hours", place.business.name] forState:UIControlStateNormal];
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
	
	
	self.btn_close.layer.masksToBounds = YES;
	self.btn_close.layer.cornerRadius = 5.0;
	self.btn_close.layer.borderColor = [UIColor grayColor].CGColor;
	self.btn_close.layer.borderWidth = 1.0;

	self.place_btn.titleLabel.text = place.business.name;
	
}

- (void) viewDidUnload
{
    self.parentController = nil;
    
    [super viewDidUnload];
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
    return [place.open_hours count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		KZOpenHours *hour = (KZOpenHours*)[place.open_hours objectAtIndex:[indexPath row]];
		cell.text = hour.day;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"From %@ to %@", hour.from_time, hour.to_time];
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
    [parentController release];
    [place_btn release];
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

