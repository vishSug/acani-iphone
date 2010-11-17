#import "ThumbView.h"
#import "User.h"
#import "Picture.h"
#import "Constants.h"

#define	SET_BACKGROUND_IMAGE_WITH_DATA(DATA)\
	self.backgroundColor = [UIColor colorWithPatternImage:\
							[UIImage imageWithData:DATA]]


@implementation ThumbView

@synthesize user;
@synthesize urlData;

- (id)initWithFrame:(CGRect)frame user:(User *)theUser {
	if (self = [super initWithFrame:frame]) {
		self.clearsContextBeforeDrawing = NO;
		self.user = theUser;
		if ([theUser picture]) {
//		if ((Thumb *thumb = [theUser thumb]) && [thumb oid] == 1) {
			NSLog(@"picture: %@", [theUser picture]);
			SET_BACKGROUND_IMAGE_WITH_DATA([[theUser picture] thumb]); // use thumb2 for iPhone4
		} else {
			NSLog(@"user: %@", theUser);
			[self downloadThumb];
		}
	}
    return self;
}

- (void)downloadThumb {
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/%@/picture", SINATRA, [user oid]];
	NSLog(@"thumb urlString: %@", urlString);
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString	release];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
													 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData // using core data
												 timeoutInterval:60.0]; // default
	[url release];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	if (connection) {
		urlData = [[NSMutableData data] retain];
	} else {
		// Inform the user that the connection failed.
		NSLog(@"Failure to create URL connection.");
	}
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [urlData setLength:0]; // reset data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [urlData appendData:data]; // append incoming data
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release]; [urlData release];
	// TODO: Inform the user that the connection failed.
	NSLog(@"Connection did fail with error: %@", [error localizedDescription]);
}
	
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
	NSLog(@"got here");
	// Store urlData to user's thumb, and set view's background image.
	[user setPicture:[NSEntityDescription
					  insertNewObjectForEntityForName:@"Picture"
					  inManagedObjectContext:[user managedObjectContext]]];
	[[user picture] setThumb:urlData];
	SET_BACKGROUND_IMAGE_WITH_DATA(urlData);

	[[user managedObjectContext] save:nil]; // TODO: do this once at the end.

//    [self setNeedsLayout];
//	[self.superview setNeedsLayout];
    [urlData release];
}

- (void)dealloc {
	[user release];
	[urlData release];
    [super dealloc];
}

@end
