//
//  CTCacheCenter.m
//  BLNetworking
//
//  Created by casa on 2016/11/21.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTCacheCenter.h"
#import "CTMemoryCacheDataCenter.h"
#import "CTMemoryCachedRecord.h"
#import "CTLogger.h"
#import "CTServiceFactory.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "CTDiskCacheCenter.h"
#import "CTMemoryCacheDataCenter.h"

@interface CTCacheCenter ()

@property (nonatomic, strong) CTMemoryCacheDataCenter *memoryCacheCenter;
@property (nonatomic, strong) CTDiskCacheCenter *diskCacheCenter;

@end

@implementation CTCacheCenter

+ (instancetype)sharedInstance
{
    static CTCacheCenter *cacheCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheCenter = [[CTCacheCenter alloc] init];
    });
    return cacheCenter;
}

- (CTURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params
{
    CTURLResponse *response = [self.diskCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params]];
    if (response) {
        response.logString = [CTLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (CTURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params
{
    CTURLResponse *response = [self.memoryCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params]];
    if (response) {
        response.logString = [CTLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (void)saveDiskCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime
{
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.diskCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams] cacheTime:cacheTime];
    }
}

- (void)saveMemoryCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime
{
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.memoryCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams] cacheTime:cacheTime];
    }
}

- (void)cleanAllDiskCache
{
    [self.diskCacheCenter cleanAll];
}

- (void)cleanAllMemoryCache
{
    [self.memoryCacheCenter cleanAll];
}

#pragma mark - private methods
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams
{
    NSString *key = [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams CT_transformToUrlParamString]];
    return key;
}

#pragma mark - getters and setters
- (CTDiskCacheCenter *)diskCacheCenter
{
    if (_diskCacheCenter == nil) {
        _diskCacheCenter = [[CTDiskCacheCenter alloc] init];
    }
    return _diskCacheCenter;
}

- (CTMemoryCacheDataCenter *)memoryCacheCenter
{
    if (_memoryCacheCenter == nil) {
        _memoryCacheCenter = [[CTMemoryCacheDataCenter alloc] init];
    }
    return _memoryCacheCenter;
}


@end
