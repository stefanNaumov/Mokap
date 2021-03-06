//
//  UsersTableViewController.m
//  ChatApp
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "UsersTableViewController.h"

@interface UsersTableViewController ()

@end

static NSString *DefaultControllerTitle = @"Chat People List";

@implementation UsersTableViewController{
    PFUser *loggedUser;
    PFUser *otherUser;
    CoreDataHelper *dataHelper;
    NSArray *allUsersBackup;
    UISwipeGestureRecognizer *gestureRecLeft;
    UISwipeGestureRecognizer *gestRecRight;
    UIBarButtonItem *barItem;
    UIBarButtonItem *historyBackBarItem;
    ChatUser *logged;
    NSArray *pfUsersFiltered;
    UIBarButtonItem *defaultNavBarBackBtn;
    UIButton *historyBackBtn;
    UIButton *deleteHistoryBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DefaultControllerTitle;
    
    UIAlertView *swipeAlert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Swipe for history" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [swipeAlert show];
    
    dataHelper = [[CoreDataHelper alloc] init];
    [dataHelper setupCoreData];
    
    loggedUser = [PFUser currentUser];
    logged = [NSEntityDescription insertNewObjectForEntityForName:@"ChatUser" inManagedObjectContext:dataHelper.context];
    logged.username = loggedUser.username;
    
    [dataHelper.context insertObject:logged];
   
    //save the default back button so we can swap it with our custom one
    defaultNavBarBackBtn = self.navigationItem.backBarButtonItem;
    [defaultNavBarBackBtn setTitle:@"LogOut"];
    
    //custom back button for returning from swipe right
    historyBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //custom button for deleting user's history
    deleteHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self loadCustomNavBarButtons];
    
    gestureRecLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFilterUsers:)];
    gestureRecLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    gestRecRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFilterUsers:)];
    gestRecRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.tableView addGestureRecognizer:gestureRecLeft];
    [self.tableView addGestureRecognizer:gestRecRight];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadCustomNavBarButtons{
    
    historyBackBtn.showsTouchWhenHighlighted = YES;
    [historyBackBtn setTitle:@"Back" forState:UIControlStateNormal];
    historyBackBtn.frame = CGRectMake(0.0, 0.0, 50, 30);
    [historyBackBtn setTitleColor:[UIColor colorWithRed:220.0/255 green:140.0/255 blue:85.0/255 alpha:1.0] forState:UIControlStateNormal];
    [historyBackBtn addTarget:self action:@selector(historyBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *deleteBtnImage = [UIImage imageNamed:@"clear_history"];
    
    
    [deleteHistoryBtn setImage:deleteBtnImage forState:UIControlStateNormal];
    deleteHistoryBtn.showsTouchWhenHighlighted = YES;
    deleteHistoryBtn.frame = CGRectMake(0.0, 0.0, deleteBtnImage.size.width / 2,
                                        deleteBtnImage.size.height / 2);
    [deleteHistoryBtn addTarget:self action:@selector(deleteHistory) forControlEvents:UIControlEventTouchUpInside];
    
    historyBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:historyBackBtn];
    
    barItem = [[UIBarButtonItem alloc] initWithCustomView:deleteHistoryBtn];
}

-(void)historyBackAction{
    self.title = DefaultControllerTitle;
    [self loadAllUsers];
}

-(void) deleteHistory{
    
    for (ChatUsers *userChatConnection in logged.chatUsers) {
        [dataHelper.context deleteObject:userChatConnection];
    }
    self.users = nil;
    [self.tableView reloadData];
    
    [dataHelper saveContext];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(void) saveUsersToDataBase{
    
    ChatUsers *otherUserModel = [NSEntityDescription insertNewObjectForEntityForName:@"ChatUsers" inManagedObjectContext:dataHelper.context];
    otherUserModel.username = otherUser.username;
    
    [logged addChatUsersObject:otherUserModel];
    
    
    [dataHelper.context insertObject:otherUserModel];
    
    [dataHelper saveContext];
    
    
}

-(NSArray *) fetchUsers{
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"ChatUsers"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user.username LIKE %@",loggedUser.username];
    
    [req setPredicate:predicate];
    [req setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    //TODO pass the fetched array to tableview and reload it
    NSArray *fetched = [dataHelper.context executeFetchRequest:req error:nil];
    
    //    for (ChatUser *user in fetched) {
    //        NSLog(@"%@",user.username);
    //
    //        for (ChatUser *chatter in user.chatters) {
    //            NSLog(@"Chatters: %@",chatter.username);
    //        }
    //    }
    
    return fetched;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.users count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    PFObject *user = [self.users objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [user objectForKey:@"username"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //add checking for particular segue
    
    NSIndexPath *pathForOtherUser = [self.tableView indexPathForSelectedRow];
    
    otherUser = [self.users objectAtIndex:pathForOtherUser.row];
    
    //we have the two users - save them to database
    [self saveUsersToDataBase];
    
    ChatSessionViewController *controller = [segue destinationViewController];
    [controller setLoggedUser:loggedUser];
    [controller setOtherUser:otherUser];
    
}

- (IBAction)swipeFilterUsers:(UIGestureRecognizer *)sender {
    
    NSArray *fetched = [self fetchUsers];
    pfUsersFiltered = [self getPfUsers:fetched];
    static NSString *historyTitle = @"History";
    
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction ];
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            if ([self.title isEqualToString:DefaultControllerTitle]) {
                return;
            }
            
            // Reset Title
            self.title = DefaultControllerTitle;
            
            //resetBackButton
            self.navigationItem.leftBarButtonItem = defaultNavBarBackBtn;
            self.navigationItem.hidesBackButton = NO;
            
            //remove delete history button
            self.navigationItem.rightBarButtonItem = nil;
            
            //reload all users
            [self loadAllUsers];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if ([self.title isEqualToString:historyTitle]) {
                return;
            }
            
            // Set Title
            self.title = historyTitle;
            
            //backup all users
            allUsersBackup = self.users;
            
            //put remove history button
            self.navigationItem.rightBarButtonItem = barItem;
           
            self.navigationItem.leftBarButtonItem = historyBackBarItem;
            
            self.users = pfUsersFiltered;
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

-(void) loadAllUsers{
    self.users = allUsersBackup;
    [self.tableView reloadData];
}

-(NSArray *) getPfUsers:(NSArray *) fetchedUsersFromDatabase{
    NSMutableArray *usersArr = [[NSMutableArray alloc] init];
    
    for (PFUser *pfUser in self.users) {
        for (ChatUser *modelUser in fetchedUsersFromDatabase) {
            if ([pfUser.username isEqualToString:modelUser.username]) {
                [usersArr addObject:pfUser];
                break;
            }
        }
    }
    
    NSArray *filtered = [[NSArray alloc] initWithArray:usersArr];
    
    return filtered;
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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end