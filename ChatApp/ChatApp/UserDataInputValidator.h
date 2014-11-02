//
//  UserDataInputValidator.h
//  ChatApp
//
//  Created by admin on 11/1/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataInputValidator : NSObject

-(BOOL) validateUserName: (NSString *) username;

-(BOOL) validatePassword: (NSString *) password;

-(BOOL) verifyPassword:(NSString *)password withPassword:(NSString *)passwordForVerification;

@end
