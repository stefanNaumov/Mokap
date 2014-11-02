//
//  UserDataInputValidator.m
//  ChatApp
//
//  Created by admin on 11/1/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "UserDataInputValidator.h"

#define trimAll(object)[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@implementation UserDataInputValidator

-(BOOL) validateUserName: (NSString*) username{
    if ([trimAll(username) length] == 0 || [trimAll(username) length] > 40) {
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL) validatePassword:(NSString *)password{
    if ([trimAll(password) length] < 5 || [trimAll(password) length] > 30) {
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL) verifyPassword:(NSString *)password withPassword:(NSString *)passwordForVerification{
    if (![password isEqualToString:passwordForVerification]) {
        return FALSE;
    }
    
    return TRUE;
}

@end
