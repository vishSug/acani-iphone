#import "BubblesViewController.h"

@implementation BubblesViewController

@synthesize tbl, messages, choosePhotoBtn, textfield, imageView, toolBar;

CGPoint offset;

//[messages addObject: textfield.text]

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	messages = [[NSMutableArray alloc] initWithObjects: @"Hey, How are you today?", 
				@"I'm fine, thank you and you?" , 
				@"I'm pretty well." , 
				@"Cool.", 
				nil];
	tbl.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [messages count];
}

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	[self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
}

-(IBAction) push:(id)sender {
	if (textfield.text.length != 0) {
		NSLog(@"push function");
		[messages addObject: textfield.text];
		[tbl reloadData]; 
		textfield.text = @""; // clear textfield after send

		// Scroll up tableView
		NSInteger nSections = [tbl numberOfSections];
		NSInteger nRows = [tbl numberOfRowsInSection:nSections - 1];
		NSIndexPath * indexPath = [NSIndexPath indexPathForRow:nRows - 1 inSection:nSections - 1];
		[tbl scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

-(IBAction) slideFrameUp {
	[self slideFrame:YES];
}

-(IBAction) slideFrameDown {
	[self slideFrame:NO];
}

// Shrink tableView when keyboard pops up
-(void) slideFrame:(BOOL) up
{
	const int movementDistance = 210; // tweak as needed
	const float movementDuration = 0.3f; // tweak as needed
	
	int movement = (up ? -movementDistance : movementDistance);
	
	[UIView beginAnimations: @"anim" context: nil];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration: movementDuration];
	offset = tbl.contentOffset;
	CGRect viewFrame = tbl.frame;
	viewFrame.size.height += movement;
	tbl.frame = viewFrame;
	toolBar.frame = CGRectOffset(toolBar.frame, 0, movement);
	NSInteger nSections = [tbl numberOfSections];
	NSInteger nRows = [tbl numberOfRowsInSection:nSections - 1];
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:nRows - 1 inSection:nSections - 1];
	[tbl scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	//self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	[UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#define kBalloonView 1
#define kLabel 2
#define kMessage 3

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
	UIImageView *balloonView;
	UILabel *label;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		balloonView = [[UIImageView alloc] init];
		balloonView.tag = kBalloonView;
		
		label = [[UILabel alloc] init];
		label.tag = kLabel;
		label.backgroundColor = [UIColor clearColor];
		label.numberOfLines = 0;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.font = [UIFont systemFontOfSize:14.0];
		
		UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
	    message.tag = kMessage;
		
		[message addSubview:balloonView];
		[message addSubview:label];
		
		message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
		[cell.contentView addSubview:message];
		
		[balloonView release];
		[label release];
		[message release];
	}

	else {
		balloonView = (UIImageView *)[[cell.contentView viewWithTag:kMessage] viewWithTag: kBalloonView];
		label = (UILabel *)[[cell.contentView viewWithTag:kMessage] viewWithTag:kLabel];
	}

	NSString *text = [messages objectAtIndex:indexPath.row];
	CGSize size = [text sizeWithFont: [UIFont systemFontOfSize:14.0]constrainedToSize: CGSizeMake(240.0f, 480.0f)lineBreakMode: UILineBreakModeWordWrap];
	UIImage *balloon;
	if (indexPath.row%2 == 0) {
		balloonView.frame = CGRectMake(320.0f - (size.width + 28.0f), 2.0f, size.width +28.0f, size.height + 15.0f);
	    balloonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		balloon = [[UIImage imageNamed:@"green.png"]stretchableImageWithLeftCapWidth:15 topCapHeight:13];
	
		label.frame = CGRectMake(307.0f - (size.width + 5.0f), 8.0f, size.width + 5.0f, size.height);
	    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	
	}
	else {
		balloonView.frame = CGRectMake(0.0, 2.0f, size.width +28.0f, size.height + 15.0f);
	    balloonView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		balloon = [[UIImage imageNamed:@"grey.png"]stretchableImageWithLeftCapWidth:23 topCapHeight:15];
		
		label.frame = CGRectMake(16.0f, 8.0f, size.width + 5.0f, size.height);
	    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		
	}

	balloonView.image = balloon;
	label.text = text;
	
	return cell;
}

-(CGFloat)tableView: (UITableView*) tableView hightForRowAtIndexPath :(NSIndexPath *)indexPath{
	
	NSString *text = [messages objectAtIndex:indexPath.row];
	CGSize size = [text sizeWithFont: [UIFont systemFontOfSize:14.0] constrainedToSize: CGSizeMake(240.0f, 480.0f)lineBreakMode: UILineBreakModeWordWrap];

	return size.height + 15;
}
	//----------------------------------------------------------



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tbl  = nil;
	self.messages = nil;
}


- (void)dealloc {
	[tbl release];
	[messages release];
    [super dealloc];
}

@end