//
//  ChatSessionViewController.m
//  ChatApp
//
//  Created by admin on 11/4/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ChatSessionViewController.h"

@interface ChatSessionViewController (){
    NSMutableArray *testData;
    MessageBalloonUITableViewCell *_stubCell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *CellIdentifier = @"MessageBalloonUITableViewCell";

@implementation ChatSessionViewController

//  FIXME: Test Method
// Pass the downloaded array with objects and refresh
- (IBAction)addRowTest:(id)sender {
    if (testData.count > 18) {
            [testData addObject: [NSString stringWithFormat:@"Check Resizing. Oh Yeah! %d", testData.count]];
    }else{
        [testData addObject: [NSString stringWithFormat:@"I Got Resized %@", testData[testData.count - 1]]];
    }
    
    // Insert new Row
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:testData.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    // Scroll down after inserting new Row
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:testData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    testData = [[NSMutableArray alloc] init];
    [testData addObject:@"initial "];
    
    // Register Nib Cell
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    NSLog(@"LoggedUser %@",[self.loggedUser username]);
    NSLog(@"OtherUser %@",[self.otherUser username]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(MessageBalloonUITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willdeplaycell");
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
