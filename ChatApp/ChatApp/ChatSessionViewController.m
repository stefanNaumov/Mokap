//
//  ChatSessionViewController.m
//  ChatApp
//
//  Created by admin on 11/4/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ChatSessionViewController.h"
// TODO: Add refresh location on every N for loggedUser
@interface ChatSessionViewController (){
    NSMutableArray *testData;
    PictureUITableViewCell *_stubCell;
    NSDate *dateBeforeNewMessages;
    ChatAppNavigationController *navController;
    CLLocation *userLocation;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageToSend;

@end

//static NSString *CellIdentifier1 = @"MessageBalloonUITableViewCell";
static NSString *CellIdentifier = @"PictureUITableViewCell";

@implementation ChatSessionViewController

- (IBAction)sendMessage:(id)sender {
    // FIXME: validate if empty -> return AND* disable button
    // TODO: trim message before send
    // TODO: just ONE, TextMessage OR picture OR audio!!!
    NSString *textToSend = self.messageToSend.text;
    PFObject *pfMessage = [PFObject objectWithClassName:@"Message"];
    pfMessage[@"TextMessage"] = textToSend;
    pfMessage[@"User1"] = self.loggedUser.username;
    pfMessage[@"User2"] = self.otherUser.username;
    [pfMessage saveInBackground];
    
    [self.messageToSend setText:@""];
    [self.messageToSend resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dateBeforeNewMessages = [[NSDate alloc] init];
    testData = [[NSMutableArray alloc] init];
    navController = [ChatAppNavigationController sharedSingleton];
    
    // Register Nib Cell
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
    // _subCell so we can autoresize cell
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    [self loadLatestMessageHistory];
    
    // Refresh messages every 1.0 sec.
    SEL refreshForNewMessagesSelector = @selector(refreshForNewMessages);
    [self callSelector:refreshForNewMessagesSelector Every:1.0];
    
    SEL refreshUserLocationSelector = @selector(refreshUserLocation);
    [self callSelector:refreshUserLocationSelector Every:5.0];
}

-(void)refreshUserLocation{
    userLocation = navController.locationManager.location;
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:userLocation];
    
    self.loggedUser[@"location"] = geoPoint;
    [self.loggedUser saveEventually];
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
    [NSTimer scheduledTimerWithTimeInterval:second target:self selector:selector userInfo:nil repeats:YES];
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
    BOOL hasPicture = [message[@"HasPicture"] boolValue];
    BOOL hasAudio = [message[@"HasAudio"] boolValue];
    NSString *text = message[@"TextMessage"];
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
    BOOL hasPicture = [message[@"HasPicture"] boolValue];
    BOOL hasAudio = [message[@"HasAudio"] boolValue];
    if (hasPicture || hasAudio) {
        return [UIImage imageNamed:@"image"].size.width;
    }
    return height + 1;
}

- (void)configureCell:(PictureUITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *textMessage = testData[indexPath.row][@"TextMessage"];
    if (textMessage.length > 0){
        cell.messageText.text = textMessage;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *message = testData[indexPath.row];
    NSString *text = message[@"TextMessage"];
    BOOL hasPic = [message[@"HasPicture"] boolValue];
    BOOL hasAudio = [message[@"HasAudio"] boolValue];

    if (hasPic) {
        NSLog(@"Pic");
        [self performSegueWithIdentifier:@"ShowPictureViewController" sender:nil];
    }
    else if (hasAudio){
        NSLog(@"Audio");
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
    
    // Should not be executed everytime you got more than 51 messages
    // this 51 constant should be more than loadLatestMessageHistory LimitTo number or it will be executed on start (useless execution)
//    if (testData.count > 51) {
//        NSMutableArray *last51MessagesOnly = [[NSMutableArray alloc] init];
//        // change to forIn when testData no longer text only but Objects
//        for (int i = 0; i < 51; i++) {
//            PFObject *item = [testData objectAtIndex: testData.count - 51 + i];
//            [last51MessagesOnly addObject:item];
//        }
//        NSLog(@"%d", last51MessagesOnly.count);
//        testData = last51MessagesOnly;
//        [self.tableView reloadData];
//        NSLog(@"===================================\n=======================");
//    }
    
    // Scroll down after inserting new Rows
    // FIXME: scroll ako COUNT > 0 demek ako nqma novi da ne skrolva
    // demek ako scrollna nagore da vidq stari postove da ne scrollva osven ako nqma novo suob6tenie
    // moej bi celiq method da se izvikva ako e > 0
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:testData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    
    // Get all (just 6) messages after my birthday. Dunno how to say: Any date.
    [self getMessagesAfter:birthDay AndLimitTo:66];
}

- (void)getMessagesAfter:(NSDate *)Date AndLimitTo:(int)limit {
    NSString *user1 =self.loggedUser.username;
    NSString *user2 =self.otherUser.username;
    NSString *format = [NSString stringWithFormat:@"(User1 = '%@' OR User1 = '%@') AND (User2 = '%@' OR User2 = '%@')",user1,user2,user1,user2];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message" predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"createdAt" greaterThan:Date];
    query.limit = limit;
    [query selectKeys:@[@"TextMessage", @"User1", @"User2", @"HasPicture", @"HasAudio", @"Picture", @"Audio"]];
    __weak id weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d scores. %d", objects.count, testData.count);
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

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"ShowLocationViewController"])
     {
         ShowLocationViewController *slvc = [segue destinationViewController];
         slvc.otherUser = self.otherUser;
     }
     else if ([[segue identifier] isEqualToString:@"ShowPictureViewController"]){
         ShowPictureViewController *spvc = [segue destinationViewController];
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         Message *msg = [[Message alloc] init];
         msg[@"Picture"] = testData[path.row][@"Picture"];
         spvc.message = msg;
     }
 }

-(IBAction)returnToChatSession:(UIStoryboardSegue *)segue {
    NSLog(@"returnToChatSession unwind");
}
@end
