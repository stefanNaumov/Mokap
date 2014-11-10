//
//  ButtonStyleSetter.h
//  ChatApp
//
//  Created by admin on 11/10/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonStyleSetter : NSObject

+(ButtonStyleSetter *) sharedSingleton;

-(void) setBackgroundColor:(UIButton *) button withColorRed:(float) red colorGreen:(float) green colorBLue:(float) blue alpha:(float) alpha;

-(void) setCornerRadius:(UIButton *) button withRadius:(float) radius;

-(void) setBorderWidth:(UIButton *) button withBorderWith:(float) borderWith;

@end
