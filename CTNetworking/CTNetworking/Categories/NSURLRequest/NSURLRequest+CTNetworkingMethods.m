//
//  NSURLRequest+CTNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-26.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSURLRequest+CTNetworkingMethods.h"
#import <objc/runtime.h>

static void *CTNetworkingActualRequestParams = &CTNetworkingActualRequestParams;
static void *CTNetworkingOriginRequestParams = &CTNetworkingOriginRequestParams;
static void *CTNetworkingRequestService = &CTNetworkingRequestService;

@implementation NSURLRequest (CTNetworkingMethods)

- (void)setActualRequestParams:(NSDictionary *)actualRequestParams
{
    objc_setAssociatedObject(self, CTNetworkingActualRequestParams, actualRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)actualRequestParams
{
    return objc_getAssociatedObject(self, CTNetworkingActualRequestParams);
}

- (void)setOriginRequestParams:(NSDictionary *)originRequestParams
{
    objc_setAssociatedObject(self, CTNetworkingOriginRequestParams, originRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)originRequestParams
{
    return objc_getAssociatedObject(self, CTNetworkingOriginRequestParams);
}

- (void)setService:(id<CTServiceProtocol>)service
{
    objc_setAssociatedObject(self, CTNetworkingRequestService, service, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<CTServiceProtocol>)service
{
    return objc_getAssociatedObject(self, CTNetworkingRequestService);
}

@end
