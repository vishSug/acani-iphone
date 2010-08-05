@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
	NSMutableArray *messages;
		time_t	latestTimestamp;

	UITableView *chatContent;
		UILabel *msgTimestamp;
		UIImageView *msgBackground;
		UILabel *msgText;

	UIImageView *chatBar;
		UITextView *chatInput;
			CGFloat lastContentHeight;
			Boolean chatInputHadText;
		UIButton *sendButton;
}

@end