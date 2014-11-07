//
//  ChangeView.m
//  AnimationsTests
//
//  Created by admin on 11/6/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "HomeScreenAnimationsGenerator.h"

static const int RECT_SIZE = 45.0;
static const int CAPITALS_HEIGHT = 60;

@implementation HomeScreenAnimationsGenerator{
    UIDynamicAnimator *_animator;
    UIViewController *_controller;
    UILabel *cChatLabel;
    UILabel *hChatLabel;
    UILabel *aChatLabel;
    UILabel *tChatLabel;
    UILabel *aAppLabel;
    UILabel *pAppLabel;
    UILabel *secPappLabel;
    
    UIColor *orangeColor;
    UIColor *lightGreenColor;
    UIColor *brownred;
    
}

-(id) initWithViewController:(UIViewController *)controller{
    self = [super self];
    if (self) {
        _controller = controller;
        
        orangeColor = [UIColor colorWithRed:240.0/255 green:180.0/255 blue:70.0/255 alpha:1.0];
        lightGreenColor = [UIColor colorWithRed:150.0/255 green:182.0/255 blue:90.0/255 alpha:1.0];
        brownred = [UIColor colorWithRed:200.0/255 green:160.0/255 blue:110.0/255 alpha:1.0];
        
        //default start width value
        CGFloat size = 10;
        
        cChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size, 0, RECT_SIZE, CAPITALS_HEIGHT)];
        [cChatLabel setBackgroundColor:brownred];
        [cChatLabel setText:@"C"];
        [self setFontProperties:cChatLabel];
        
        [_controller.view addSubview:cChatLabel];
        
        hChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
        [hChatLabel setBackgroundColor:lightGreenColor];
        [hChatLabel setText:@"h"];
        [self setFontProperties:hChatLabel];
        
        [controller.view addSubview:hChatLabel];
        
        size = size + RECT_SIZE;
        
        aChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
        [aChatLabel setBackgroundColor:orangeColor];
        [aChatLabel setText:@"a"];
        [self setFontProperties:aChatLabel];
        
        [controller.view addSubview:aChatLabel];
        
        size = size + RECT_SIZE;
        
        tChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
        [tChatLabel setBackgroundColor:lightGreenColor];
        [tChatLabel setText:@"t"];
        [self setFontProperties:tChatLabel];
        
        [controller.view addSubview:tChatLabel];
        
        size = size + RECT_SIZE;
        
        aAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE,
                                                              CAPITALS_HEIGHT)];
        [aAppLabel setBackgroundColor:brownred];
        [aAppLabel setText:@"A"];
        [self setFontProperties:aAppLabel];
        
        [controller.view addSubview:aAppLabel];
        
        size = size + RECT_SIZE;
        
        pAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
        [pAppLabel setBackgroundColor:lightGreenColor];
        [pAppLabel setText:@"p"];
        [self setFontProperties:pAppLabel];
        
        [controller.view addSubview:pAppLabel];
        
        size = size + RECT_SIZE;
        
        secPappLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
        [secPappLabel setBackgroundColor:orangeColor];
        [secPappLabel setText:@"p"];
        [self setFontProperties:secPappLabel];
        
        [controller.view addSubview:secPappLabel];
    }
    
    return self;
}

-(void) generateAnimations{
    
    //same for both halfs of the elements
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_controller.view];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[cChatLabel,hChatLabel,aChatLabel,tChatLabel,aAppLabel,pAppLabel,secPappLabel]];
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [_animator addBehavior:collision];
    
    UIGravityBehavior *firstHalfGravity = [[UIGravityBehavior alloc] initWithItems:@[cChatLabel,aChatLabel,aAppLabel,secPappLabel]];
    [firstHalfGravity setMagnitude:[self generateRandom:2.5 and:3.0]];
    [_animator addBehavior:firstHalfGravity];
    
    //first elements half
    UIDynamicItemBehavior *firstHalfDynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[cChatLabel,aChatLabel,aAppLabel,secPappLabel]];
    [firstHalfDynamic setElasticity:[self generateRandom:0.5 and:0.8]];
    [_animator addBehavior:firstHalfDynamic];
    
    //second elements half
    UIGravityBehavior *secondHalfGravity = [[UIGravityBehavior alloc] initWithItems:@[hChatLabel,tChatLabel,pAppLabel]];
    [secondHalfGravity setMagnitude:[self generateRandom:0.5 and:2.0]];
    [_animator addBehavior:secondHalfGravity];
    
    UIDynamicItemBehavior *secondHalfDynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[hChatLabel,tChatLabel,pAppLabel]];
    [secondHalfDynamic setElasticity:[self generateRandom:0.6 and:0.9]];
    [_animator addBehavior:secondHalfDynamic];
    
}

-(void) setFontProperties:(UILabel *)label{
    
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Trebuchet MS" size:30]];
}

-(float) generateRandom:(float) lower and: (float)upper{
    float diff = upper - lower;
    
    return (((float) rand() / RAND_MAX) * diff) + lower;
}

@end