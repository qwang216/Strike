//
//  User.m
//  Strike
//
//  Created by Jason Wang on 2/16/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "User.h"
#import "Email.h"

@implementation User

- (instancetype)initWithFireBaseAccount {
    if (self = [super init]) {
        self.acctRef = [[Firebase alloc]initWithUrl:@"https://strike7.firebaseio.com"];
        return self;
    }
    return nil;
}

- (void)loginFireBaseWithEmail:(NSString *)email andPW:(NSString *)password completionHandler: (void (^)(NSError *error, FAuthData *authData))onCompletion {
    [self.acctRef authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (!error) {
            self.userEmail = email;
            self.userPassword = password;
        }
        onCompletion(error,authData);
    }];
}

- (void)registerFireBaseWithEmail:(NSString *)email andPW:(NSString *)password completionHandler: (void (^)(NSError *error))onCompletion {
    [self.acctRef createUser:email password:password withCompletionBlock:^(NSError *error) {
        if (!error) {
            self.userEmail = email;
            self.userPassword = password;
        }
        onCompletion(error);
    }];
}

@end
