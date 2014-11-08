//
//  ChatSessionViewController.m
//  ChatApp
//
//  Created by admin on 11/4/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ChatSessionViewController.h"
// TODO: Add refresh location on every ... for loggedUser
@interface ChatSessionViewController (){
    NSMutableArray *testData;
    MessageBalloonUITableViewCell *_stubCell;
    NSDate *dateBeforeNewMessages;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageToSend;

@end

static NSString *CellIdentifier = @"MessageBalloonUITableViewCell";

@implementation ChatSessionViewController

- (IBAction)sendMessage:(id)sender {
    // FIXME: validate if empty -> return or disable button
    // TODO: trim message before send
    NSString *textToSend = self.messageToSend.text;
    PFObject *pfMessage = [PFObject objectWithClassName:@"Message"];
    pfMessage[@"TextMessage"] = textToSend;
    // FIXME: Merge Author and User1 Maybe?
    pfMessage[@"Author"] = self.loggedUser.username;
    pfMessage[@"User1"] = self.loggedUser.username;
    pfMessage[@"User2"] = self.otherUser.username;
    [pfMessage saveInBackground];
    
    [self.messageToSend setText:@""];
    [self.messageToSend resignFirstResponder];
}

//  FIXME: Test Method
- (IBAction)addRowTest:(id)sender {
    if (testData.count > 18) {
            [testData addObject: [NSString stringWithFormat:@"Check Resizing. Oh Yeah! %d", testData.count]];
    }else{
        [testData addObject: [NSString stringWithFormat:@"I Got Resized %@", testData[testData.count - 1]]];
    }
    
    int count = testData.count-1;
    
    // Insert new Row
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:count inSection:0]]  withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    
    // Scroll down after inserting new Row
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:testData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dateBeforeNewMessages = [[NSDate alloc] init];
    // Do any additional setup after loading the view.
    testData = [[NSMutableArray alloc] init];
    
    // Register Nib Cell
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
    // _subCell so we can autoresize cell
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    [self loadLatestMessageHistory];
    
    // Refresh messages every 1.0 sec.
    [self refreshMessagesEvery:1.0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)refreshForNewMessages{
    // Limit messages to 1337. Dunno how to say: do not limit
    [self getMessagesAfter:dateBeforeNewMessages AndLimitTo:1337];
}

-(void)refreshMessagesEvery: (double) second{
    [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(refreshForNewMessages) userInfo:nil repeats:YES];
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
 
    MessageBalloonUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set cell Properties Here
    cell.messageText.text = testData[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat result;
//    result = 65;
//    return result;
    
    [self configureCell:_stubCell atIndexPath:indexPath];
    [_stubCell layoutSubviews];
    
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

- (void)configureCell:(MessageBalloonUITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.messageText.text = testData[indexPath.row % testData.count];
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
    
    // Scroll down after inserting new Rows
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
    [self getMessagesAfter:birthDay AndLimitTo:6];

}

- (void)getMessagesAfter:(NSDate *)Date AndLimitTo:(int)limit {
    NSString *user1 =self.loggedUser.username;
    NSString *user2 =self.otherUser.username;
    NSString *format = [NSString stringWithFormat:@"(User1 = '%@' OR User1 = '%@') AND (User2 = '%@' OR User2 = '%@')",user1,user2,user1,user2];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message" predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"createdAt" greaterThan:Date];
    // TODO: Sort Messages proper. Check them out!!!
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            
            NSMutableArray *newMessages = [[NSMutableArray alloc] init];
            // Do something with the found objects
            NSMutableArray *dates = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                // TODO: Add all object instead of just text.
                // Then in cellForRowAtIndexPath can use it as testData[indexPath.row].TextMessage
                // Maybe Make Model?
                [newMessages addObject:object[@"TextMessage"]];
                [dates addObject:object.createdAt];
            }
            NSLog(@" 1-------WTF------ %@", dateBeforeNewMessages);
            if ([dates objectAtIndex:0]) {
                NSLog(@" -------IN------ ");
                dateBeforeNewMessages = [dates objectAtIndex:0];
            }
            NSLog(@" does NOT get print 2-------WTF------ %@", dateBeforeNewMessages);
            [testData addObjectsFromArray:[[newMessages reverseObjectEnumerator] allObjects]];
            [self addLastCells:newMessages.count];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
     ShowLocationViewController *slvc = [segue destinationViewController];
 // Pass the selected object to the new view controller.
     slvc.otherUser = self.otherUser;
 }

@end
