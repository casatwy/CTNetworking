//
//  Target_DemoService.m
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "Target_DemoService.h"

NSString * const CTNetworkingDemoServiceIdentifier = @"DemoService";

@implementation Target_DemoService

- (DemoService *)Action_DemoService:(NSDictionary *)params
{
    return [[DemoService alloc] init];
}

@end
