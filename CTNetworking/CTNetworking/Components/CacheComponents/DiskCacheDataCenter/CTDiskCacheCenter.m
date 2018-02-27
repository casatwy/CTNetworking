//
//  CTDiskCacheCenter.m
//  BLNetworking
//
//  Created by casa on 2016/11/21.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTDiskCacheCenter.h"

NSString * const kCTDiskCacheCenterCachedObjectKeyPrefix = @"kCTDiskCacheCenterCachedObjectKeyPrefix";

@implementation CTDiskCacheCenter

- (CTURLResponse *)fetchCachedRecordWithKey:(NSString *)key
{
    NSString *actualKey = [NSString stringWithFormat:@"%@%@",kCTDiskCacheCenterCachedObjectKeyPrefix, key];
    CTURLResponse *response = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:actualKey];
    if (data) {
        NSDictionary *fetchedContent = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSNumber *lastUpdateTimeNumber = fetchedContent[@"lastUpdateTime"];
        NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:lastUpdateTimeNumber.doubleValue];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        if (timeInterval < [fetchedContent[@"cacheTime"] doubleValue]) {
            response = [[CTURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:fetchedContent[@"content"] options:0 error:NULL]];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:actualKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return response;
}

- (void)saveCacheWithResponse:(CTURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime
{
    if (response.content) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                 @"content":response.content,
                                                                 @"lastUpdateTime":@([NSDate date].timeIntervalSince1970),
                                                                 @"cacheTime":@(cacheTime)
                                                                 }
                                                       options:0
                                                         error:NULL];
        if (data) {
            NSString *actualKey = [NSString stringWithFormat:@"%@%@",kCTDiskCacheCenterCachedObjectKeyPrefix, key];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:actualKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)cleanAll
{
    NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSArray *keys = [[defaultsDict allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", kCTDiskCacheCenterCachedObjectKeyPrefix]];
    for(NSString *key in keys) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
