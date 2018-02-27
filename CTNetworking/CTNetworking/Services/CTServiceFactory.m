//
//  AXServiceFactory.m
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTServiceFactory.h"

#import "BLHTTPSService.h"
#import "BLOpenAPIService.h"
#import "RisoService.h"
#import "AmapService.h"
#import <BLMediator/BLMediator.h>

/*************************************************************************/

@interface CTServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation CTServiceFactory

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

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

#pragma mark - public methods
- (id <CTServiceProtocol>)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (id <CTServiceProtocol>)newServiceWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kCTServiceBLHTTPSService]) {
        return [[BLHTTPSService alloc] init];
    }
    
    if ([identifier isEqualToString:kCTServiceBLOpenAPIService]) {
        return [[BLOpenAPIService alloc] init];
    }
    
    if ([identifier isEqualToString:kCTServiceRisoService]) {
        return [[RisoService alloc] init];
    }

    if ([identifier isEqualToString:kCTServiceAmapService]) {
        return [[AmapService alloc] init];
    }
    
    return [[BLMediator sharedInstance] performTarget:identifier action:identifier params:nil shouldCacheTarget:NO];
}

@end
