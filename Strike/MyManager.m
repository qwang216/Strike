//
//  MyManager.m
//  Strike
//
//  Created by Jason Wang on 2/21/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager

+ (instancetype)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc]init];
        sharedMyManager.userInfo = [NSMutableDictionary new];
        sharedMyManager.singletonQueue = dispatch_queue_create("com.singleton.data", DISPATCH_QUEUE_SERIAL);
    });
    return sharedMyManager;
}

- (void)getDataWithCompletion:(void (^)(NSDictionary *))onCompletion{
    dispatch_async(self.singletonQueue, ^{
        NSUserDefaults *userDefRef = [NSUserDefaults standardUserDefaults] ;
        NSDictionary *dictData = [userDefRef objectForKey:@"userData"];
        onCompletion(dictData);
    });
}

- (void)addData:(NSDictionary *)userData{
    dispatch_barrier_async(self.singletonQueue, ^{
        NSUserDefaults *userDefRef = [NSUserDefaults standardUserDefaults];
        [userDefRef setObject:userData forKey:@"userData"];
    });
}

- (void)removeData {
    dispatch_barrier_async(self.singletonQueue, ^{
        NSUserDefaults *userDefRef = [NSUserDefaults standardUserDefaults];
        [userDefRef removeObjectForKey:@"userData"];
    });
}
@end
