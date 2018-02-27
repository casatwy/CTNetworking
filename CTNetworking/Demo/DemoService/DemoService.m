//
//  DemoService.m
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "DemoService.h"

@interface DemoService ()
@end

@implementation DemoService

- (NSURLRequest *)requestWithParams:(NSDictionary *)params methodName:(NSString *)methodName requestType:(CTAPIManagerRequestType)requestType
{
    return nil;
}

- (NSDictionary *)resultWithResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError **)error
{
    return nil;
}

- (CTServiceAPIEnvironment)apiEnvironment
{
    return CTServiceAPIEnvironmentRelease;
}

@end
