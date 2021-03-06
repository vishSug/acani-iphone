@interface ChatViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
	NSString *channel;

    NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;

	UITableView *chatContent;

	UIImageView *chatBar;
		UITextView *chatInput;
			CGFloat lastContentHeight;
			Boolean chatInputHadText;
		UIButton *sendButton;
}

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) UITableView *chatContent;

@property (nonatomic, retain) UIImageView *chatBar;
@property (nonatomic, retain) UITextView *chatInput;
@property (nonatomic, assign) CGFloat lastContentHeight;
@property (nonatomic, assign) Boolean chatInputHadText;
@property (nonatomic, retain) UIButton *sendButton;

- (void)sendMessage;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)slideFrame:(BOOL)up;
- (void)slideFrameUp;
- (void)slideFrameDown;

@end
