//
//  CTMediator+CTAppContext.m
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTMediator+CTAppContext.h"

@implementation CTMediator (CTAppContext)

- (BOOL)CTNetworking_shouldPrintNetworkingLog
{
    return [[[CTMediator sharedInstance] performTarget:@"CTAppContext" action:@"shouldPrintNetworkingLog" params:nil shouldCacheTarget:YES] boolValue];
}

- (BOOL)CTNetworking_isReachable
{
    return [[[CTMediator sharedInstance] performTarget:@"CTAppContext" action:@"isReachable" params:nil shouldCacheTarget:YES] boolValue];
}

- (NSInteger)CTNetworking_cacheResponseCountLimit
{
    return [[[CTMediator sharedInstance] performTarget:@"CTAppContext" action:@"cacheResponseCountLimit" params:nil shouldCacheTarget:YES] integerValue];
}

@end
