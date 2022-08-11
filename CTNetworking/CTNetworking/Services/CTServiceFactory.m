//
//  AXServiceFactory.m
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTServiceFactory.h"
#import <CTMediator/CTMediator.h>

/*************************************************************************/

@interface CTServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation CTServiceFactory

#pragma mark - getters and setters
//- (NSMutableDictionary *)serviceStorage
//{
//    if (_serviceStorage == nil) {
//        _serviceStorage = [[NSMutableDictionary alloc] init];
//    }
//    return _serviceStorage;
//}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 防止出现并发问题，不再使用懒加载方式初始化
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - public methods
- (id <CTServiceProtocol>)serviceWithIdentifier:(NSString *)identifier
{
    @synchronized (self.serviceStorage) {
        if (self.serviceStorage[identifier] == nil) {
            self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
        }
    }
    
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (id <CTServiceProtocol>)newServiceWithIdentifier:(NSString *)identifier
{
    return [[CTMediator sharedInstance] performTarget:identifier action:identifier params:nil shouldCacheTarget:NO];
}

@end
