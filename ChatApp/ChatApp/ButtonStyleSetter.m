//
//  ButtonStyleSetter.m
//  ChatApp
//
//  Created by admin on 11/10/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ButtonStyleSetter.h"

@implementation ButtonStyleSetter


+(ButtonStyleSetter *)sharedSingleton{
    static ButtonStyleSetter *sharedSingleton;
    if (!sharedSingleton) {
        @synchronized(sharedSingleton){
            sharedSingleton = [ButtonStyleSetter new];
        }
    }
    
    return sharedSingleton;
}

-(void) setBackgroundColor:(UIButton *)button withColorRed:(float)red
                colorGreen:(float)green
                 colorBLue:(float)blue
                     alpha:(float)alpha{
    button.layer.backgroundColor = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha].CGColor;
}

-(void)setBorderWidth:(UIButton *)button withBorderWith:(float)borderWith{
    button.layer.borderWidth = borderWith;
}

-(void)setCornerRadius:(UIButton *)button withRadius :(float)radius{
    button.layer.cornerRadius = radius;
}
@end
