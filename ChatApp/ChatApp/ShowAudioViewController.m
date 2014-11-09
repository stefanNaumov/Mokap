//
//  ShowAudioViewController.m
//  ChatApp
//
//  Created by RadvachTsvetkov on 11/9/14.
//  Copyright (c) 2014 RadvachTsvetkov. All rights reserved.
//

#import "ShowAudioViewController.h"

@interface ShowAudioViewController (){
    AVAudioPlayer *audioPlayer;
}

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ShowAudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    __weak id weakSelf = self;
    [self.message.Audio getDataInBackgroundWithBlock:^(NSData *audioData, NSError *error) {
        if (!error) {
            audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
            
            [audioPlayer play];
            _progressView.hidden = YES;
        }
        
    } progressBlock:^(int percentDone) {
        float percent = percentDone * 0.01f;
        [[weakSelf progressView] setProgress:percent animated:YES];
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.progressView.progress = 0.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
