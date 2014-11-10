//
//  ChatSessionViewController.m
//  ChatApp
//
//  Created by admin on 11/4/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ChatSessionViewController.h"

#define trimAll(object)[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface ChatSessionViewController (){
    NSMutableArray *testData;
    PictureUITableViewCell *_stubCell;
    NSDate *dateBeforeNewMessages;
    ChatAppNavigationController *navController;
    CLLocation *userLocation;
    NSMutableArray *timerRefreshWithSelector;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageToSend;
@property (weak, nonatomic) IBOutlet UIButton *openCamera;
@property (weak, nonatomic) IBOutlet UIButton *openRecord;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

-(UIColor *) weakGreenColor;
-(UIColor *) weakRedColor;

@end

static NSString *CellIdentifier = @"PictureUITableViewCell";

@implementation ChatSessionViewController

-(UIColor *) weakGreenColor {return [UIColor colorWithRed:232.0f/255.0f
                                                    green:245.0f/255.0f
                                                     blue:232.0f/255.0f
                                                    alpha:1.0f];
}
-(UIColor *) weakRedColor {return [UIColor colorWithRed:247.0f/255.0f
                                                  green:220.0f/255.0f
                                                   blue:220.0f/255.0f
                                                  alpha:1.0f];
}

- (void)userTextInputChanged {
    NSString *textMessage = self.messageToSend.text;
    if ([trimAll(textMessage) length] == 0) {
        self.sendMessageButton.hidden = YES;
        self.openCamera.hidden = NO;
        self.openRecord.hidden = NO;
    }
    else{
        self.sendMessageButton.hidden = NO;
        self.openCamera.hidden = YES;
        self.openRecord.hidden = YES;
    }
}

- (IBAction)sendMessage:(id)sender {
    NSString *textToSend = trimAll(self.messageToSend.text);
    if ([textToSend length] <= 0) {
        NSLog(@"Did not send message!");
        return;
    }
    Message *pfMessage = [Message objectWithClassName:[Message parseClassName]];
    pfMessage.TextMessage = textToSend;
    pfMessage.User1 = self.loggedUser.username;
    pfMessage.User2 = self.otherUser.username;
    [pfMessage saveInBackground];
    
    [self.messageToSend setText:@""];
    [self.messageToSend resignFirstResponder];
    [self userTextInputChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hide send button if no message in the textField
    self.title = [NSString stringWithFormat:@"Chat with: '%@'", self.otherUser.username];
    self.sendMessageButton.hidden = YES;
    [self.view setBackgroundColor: self.weakGreenColor];
    [self.tableView setBackgroundColor:self.weakGreenColor];
    [self.messageToSend addTarget:self action:@selector(userTextInputChanged)forControlEvents:UIControlEventEditingChanged];
    
    // Initialize
    timerRefreshWithSelector =[[NSMutableArray alloc] init];
    dateBeforeNewMessages = [[NSDate alloc] init];
    testData = [[NSMutableArray alloc] init];
    navController = [ChatAppNavigationController sharedSingleton];
    
    // Register Nib Cell
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
    // _subCell so we can autoresize cell
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    [self loadLatestMessageHistory];
}

-(void)refreshUserLocation{
    [navController uploadUserLocation:self.loggedUser];
    NSLog(@"ChatSession - refreshUserLocation");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshForNewMessages{
    // Limit messages to 1337. Dunno how to say: do not limit
    [self getMessagesAfter:dateBeforeNewMessages AndLimitTo:1337];
}

-(void)callSelector:(SEL)selector Every: (double) second{
    [timerRefreshWithSelector addObject:[NSTimer scheduledTimerWithTimeInterval:second target:self selector:selector userInfo:nil repeats:YES]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return testData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PictureUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set cell Properties Here
    Message *message = testData[indexPath.row];
    NSString *author = message.User1;
    if ([author isEqualToString:self.loggedUser.username]) {
        [cell setBackgroundColor:self.weakGreenColor];
    }
    else{
        [cell setBackgroundColor:self.weakRedColor];
    }
    
    BOOL hasPicture = message.HasPicture;
    BOOL hasAudio = message.HasAudio;
    NSString *text = message.TextMessage;
    if (hasPicture || hasAudio) {
        cell.image.hidden = NO;
        cell.messageText.hidden = YES;
        cell.image.contentMode = UIViewContentModeScaleAspectFit;
        [cell.image setImage:[UIImage imageNamed:hasPicture ? @"image" : @"audio"]];
    }
    else //if (text.length > 0)
    {
        cell.image.hidden = YES;
        cell.messageText.hidden = NO;
        cell.messageText.text = text;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:_stubCell atIndexPath:indexPath];
    [_stubCell layoutSubviews];
    
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    Message *message = testData[indexPath.row];
    BOOL hasPicture = message.HasPicture;
    BOOL hasAudio = message.HasAudio;
    if (hasPicture || hasAudio) {
        return [UIImage imageNamed:@"image"].size.width;
    }
    return height + 1;
}

- (void)configureCell:(PictureUITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Message *message = testData[indexPath.row];
    if (message.TextMessage > 0){
        cell.messageText.text = message.TextMessage;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *message = testData[indexPath.row];
    NSString *text = message.TextMessage;
    BOOL hasPic = message.HasPicture;
    BOOL hasAudio = message.HasAudio;

    if (hasPic) {
        NSLog(@"Pic");
        [self performSegueWithIdentifier:@"ShowPictureViewController" sender:nil];
    }
    else if (hasAudio){
        NSLog(@"Audio");
        [self performSegueWithIdentifier:@"ShowAudioViewController" sender:nil];
    }
    else if (text.length > 0){
        NSLog(@"Text");
    }
}

- (void)addLastCells:(int)count {
    
    // Insert New Rows
    [self.tableView beginUpdates];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [arr addObject:[NSIndexPath indexPathForRow: testData.count - count + i inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths: arr withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    // Shrink
    static int shrinkSize = 40;
    if (testData.count > shrinkSize * 2) {
        [self cutOldMessagesFromTableView:shrinkSize];
    }
    
    // Scroll to latest message
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:testData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)cutOldMessagesFromTableView:(int)shrinkSize {
    NSMutableArray *lastMessagesOnly = [[NSMutableArray alloc] init];
    for (int i = 0; i < shrinkSize; i++) {
        Message *item = [testData objectAtIndex: testData.count - shrinkSize + i];
        [lastMessagesOnly addObject:item];
    }
    testData = lastMessagesOnly;
    [self.tableView reloadData];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(MessageBalloonUITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willdeplaycell");
}
*/

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage:self];
    [textField resignFirstResponder];
    return YES;
}

- (void)loadLatestMessageHistory {
    NSCalendar *cal = [NSCalendar currentCalendar];
    //[cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    //[cal setLocale:[NSLocale currentLocale]];
    NSDateComponents *oct31th1989 = [[NSDateComponents alloc] init];
    [oct31th1989 setYear:1989];
    [oct31th1989 setMonth:10];
    [oct31th1989 setDay:31];
    [oct31th1989 setHour:13];
    [oct31th1989 setMinute:33];
    [oct31th1989 setSecond:37];
    NSDate *birthDay = [cal dateFromComponents:oct31th1989];
    
    // Get all (just 15) messages after my birthday. Dunno how to say: Any date.
    [self getMessagesAfter:birthDay AndLimitTo:15];
}

- (void)getMessagesAfter:(NSDate *)Date AndLimitTo:(int)limit {
    NSString *user1 =self.loggedUser.username;
    NSString *user2 =self.otherUser.username;
    NSString *format = [NSString stringWithFormat:@"(User1 = '%@' OR User1 = '%@') AND (User2 = '%@' OR User2 = '%@')",user1,user2,user1,user2];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    
    PFQuery *query = [PFQuery queryWithClassName:[Message parseClassName] predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"createdAt" greaterThan:Date];
    query.limit = limit;
    [query selectKeys:@[@"TextMessage", @"User1", @"User2", @"HasPicture", @"HasAudio", @"Picture", @"Audio"]];
    __weak id weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d messages. %d", objects.count, testData.count);
            if (objects.count > 0) {
                dateBeforeNewMessages = ((PFObject*)[objects objectAtIndex:0]).createdAt;
                [testData addObjectsFromArray:[[objects reverseObjectEnumerator] allObjects]];
                [weakSelf addLastCells:objects.count];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Move keyboard up with animation
#define kOFFSET_FOR_KEYBOARD 220.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Refresh messages every 1.0 sec.
    SEL refreshForNewMessagesSelector = @selector(refreshForNewMessages);
    [self callSelector:refreshForNewMessagesSelector Every:1.0];
    
    SEL refreshUserLocationSelector = @selector(refreshUserLocation);
    [self callSelector:refreshUserLocationSelector Every:5.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    for (NSTimer *timer in timerRefreshWithSelector) {
        [timer invalidate];
    }
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"ShowLocationViewController"])
     {
         ShowLocationViewController *slvc = [segue destinationViewController];
         slvc.otherUser = self.otherUser;
         slvc.loggedUser = self.loggedUser;
     }
     else if ([[segue identifier] isEqualToString:@"ShowPictureViewController"]){
         ShowPictureViewController *spvc = [segue destinationViewController];
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         Message *msg = [[Message alloc] init];
         msg.Picture = testData[path.row][@"Picture"];
         spvc.message = msg;
     }
     else if ([[segue identifier] isEqualToString:@"ShowAudioViewController"]){
         ShowAudioViewController *savc = [segue destinationViewController];
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         Message *msg = [[Message alloc] init];
         msg.Audio = testData[path.row][@"Audio"];
         savc.message = msg;
     }
 }

-(IBAction)returnToChatSession:(UIStoryboardSegue *)segue {
    NSLog(@"returnToChatSession unwind");
}
@end
