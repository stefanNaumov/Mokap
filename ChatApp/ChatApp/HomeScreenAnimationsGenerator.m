//
//  ChangeView.m
//  AnimationsTests
//
//  Created by admin on 11/6/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "HomeScreenAnimationsGenerator.h"

static const int RECT_SIZE = 45;

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
    
}

-(id) initWithViewController:(UIViewController *)controller{
    self = [super self];
    if (self) {
        _controller = controller;
        
        //default start width value
        CGFloat size = 10;
        
<<<<<<< HEAD
        cChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size, 0, RECT_SIZE, RECT_SIZE)];
        [cChatLabel setBackgroundColor:[UIColor blueColor]];
=======
        cChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size, 0, RECT_SIZE, CAPITALS_HEIGHT)];
        [self setConstraints:cChatLabel];
        
        [cChatLabel setBackgroundColor:brownred];
>>>>>>> FETCH_HEAD
        [cChatLabel setText:@"C"];
        [self setFontProperties:cChatLabel];
        
        [_controller.view addSubview:cChatLabel];
        
        hChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
<<<<<<< HEAD
        [hChatLabel setBackgroundColor:[UIColor orangeColor]];
=======
        [self setConstraints:hChatLabel];
        
        [hChatLabel setBackgroundColor:lightGreenColor];
>>>>>>> FETCH_HEAD
        [hChatLabel setText:@"h"];
        [self setFontProperties:hChatLabel];
        
        [controller.view addSubview:hChatLabel];
        
        size = size + RECT_SIZE;
        
        aChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
<<<<<<< HEAD
        [aChatLabel setBackgroundColor:[UIColor greenColor]];
=======
        [self setConstraints:aChatLabel];
        
        [aChatLabel setBackgroundColor:orangeColor];
>>>>>>> FETCH_HEAD
        [aChatLabel setText:@"a"];
        [self setFontProperties:aChatLabel];
        
        [controller.view addSubview:aChatLabel];
        
        size = size + RECT_SIZE;
        
        tChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
<<<<<<< HEAD
        [tChatLabel setBackgroundColor:[UIColor redColor]];
=======
        [self setConstraints:tChatLabel];
        
        [tChatLabel setBackgroundColor:lightGreenColor];
>>>>>>> FETCH_HEAD
        [tChatLabel setText:@"t"];
        [self setFontProperties:tChatLabel];
        
        [controller.view addSubview:tChatLabel];
        
        size = size + RECT_SIZE;
        
<<<<<<< HEAD
        aAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
        [aAppLabel setBackgroundColor:[UIColor yellowColor]];
=======
        aAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE,
                                                              CAPITALS_HEIGHT)];
        [self setConstraints:aChatLabel];
        
        [aAppLabel setBackgroundColor:brownred];
>>>>>>> FETCH_HEAD
        [aAppLabel setText:@"A"];
        [self setFontProperties:aAppLabel];
        
        [controller.view addSubview:aAppLabel];
        
        size = size + RECT_SIZE;
        
        pAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
<<<<<<< HEAD
        [pAppLabel setBackgroundColor:[UIColor grayColor]];
=======
        [self setConstraints:pAppLabel];
        
        [pAppLabel setBackgroundColor:lightGreenColor];
>>>>>>> FETCH_HEAD
        [pAppLabel setText:@"p"];
        [self setFontProperties:pAppLabel];
        
        [controller.view addSubview:pAppLabel];
        
        size = size + RECT_SIZE;
        
        secPappLabel = [[UILabel alloc] initWithFrame:CGRectMake(size + RECT_SIZE, 0, RECT_SIZE, RECT_SIZE)];
<<<<<<< HEAD
        [secPappLabel setBackgroundColor:[UIColor purpleColor]];
=======
        [self setConstraints:secPappLabel];
        
        [secPappLabel setBackgroundColor:orangeColor];
>>>>>>> FETCH_HEAD
        [secPappLabel setText:@"p"];
        [self setFontProperties:secPappLabel];
        
        [controller.view addSubview:secPappLabel];
        
    }
    
    return self;
}

-(void) setConstraints:(UILabel *) view{
    
    view.translatesAutoresizingMaskIntoConstraints = YES;
}

-(void) generateAnimations{
    
    //same for both halfs of the elements
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_controller.view];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[cChatLabel,hChatLabel,aChatLabel,tChatLabel,aAppLabel,pAppLabel,secPappLabel]];
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [_animator addBehavior:collision];
    
    //first elements half
    UIGravityBehavior *firstHalfGravity = [[UIGravityBehavior alloc] initWithItems:@[cChatLabel,aChatLabel,aAppLabel,secPappLabel]];
    [firstHalfGravity setMagnitude:[self generateRandom:3.0 and:4.5]];
    [_animator addBehavior:firstHalfGravity];
    
    UIDynamicItemBehavior *firstHalfDynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[cChatLabel,aChatLabel,aAppLabel,secPappLabel]];
    [firstHalfDynamic setElasticity:[self generateRandom:0.5 and:0.8]];
    [_animator addBehavior:firstHalfDynamic];
    
    //second elements half
    UIGravityBehavior *secondHalfGravity = [[UIGravityBehavior alloc] initWithItems:@[hChatLabel,tChatLabel,pAppLabel]];
    [secondHalfGravity setMagnitude:[self generateRandom:2.8 and:3.5]];
    [_animator addBehavior:secondHalfGravity];
    
    UIDynamicItemBehavior *secondHalfDynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[hChatLabel,tChatLabel,pAppLabel]];
    [secondHalfDynamic setElasticity:[self generateRandom:0.6 and:0.9]];
    [_animator addBehavior:secondHalfDynamic];
    
}

-(void) setFontProperties:(UILabel *)label{
    
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Trebuchet MS" size:25]];
}

-(float) generateRandom:(float) lower and: (float)upper{
    float diff = upper - lower;
    
    return (((float) rand() / RAND_MAX) * diff) + lower;
}

@end