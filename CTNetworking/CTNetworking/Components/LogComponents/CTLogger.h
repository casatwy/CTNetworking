//
//  AXLogger.h
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTServiceProtocol.h"
#import "CTURLResponse.h"


@interface CTLogger : NSObject

+ (NSString *)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(id <CTServiceProtocol>)service;
+ (NSString *)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (NSString *)logDebugInfoWithCachedResponse:(CTURLResponse *)response methodName:(NSString *)methodName service:(id <CTServiceProtocol>)service params:(NSDictionary *)params;

@end
