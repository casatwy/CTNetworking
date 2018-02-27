//
//  Target_CTAppContext.m
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "Target_CTAppContext.h"

@implementation Target_CTAppContext

- (BOOL)Action_isReachable
{
    return YES;
}

- (BOOL)Action_shouldPrintNetworkingLog
{
    return YES;
}

- (NSInteger)Action_cacheResponseCountLimit
{
    return 2;
}

@end
