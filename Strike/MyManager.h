//
//  MyManager.h
//  Strike
//
//  Created by Jason Wang on 2/21/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface MyManager : NSObject

@property (nonatomic) NSMutableDictionary *userInfo;
+ (instancetype)sharedManager;
@property (nonatomic) dispatch_queue_t singletonQueue;

- (void)getDataWithCompletion:(void(^)(NSDictionary *data))onCompletion;
- (void)removeData;
- (void)addData:(NSDictionary *)userData;
@end
