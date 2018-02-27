//
//  Target_CTAppContext.m
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "Target_CTAppContext.h"

@implementation Target_CTAppContext

- (BOOL)Action_isReachable:(NSDictionary *)params
{
    return YES;
}

- (BOOL)Action_shouldPrintNetworkingLog:(NSDictionary *)params
{
    return YES;
}

- (NSInteger)Action_cacheResponseCountLimit:(NSDictionary *)params
{
    return 2;
}

@end
