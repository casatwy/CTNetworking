//
//  CTCacheCenter.h
//  BLNetworking
//
//  Created by casa on 2016/11/21.
//  Copyright © 2016年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTURLResponse.h"

@interface CTCacheCenter : NSObject

+ (instancetype)sharedInstance;

- (CTURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;
- (CTURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;

- (void)saveDiskCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime;
- (void)saveMemoryCacheWithResponse:(CTURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime;

- (void)cleanAllMemoryCache;
- (void)cleanAllDiskCache;

@end
