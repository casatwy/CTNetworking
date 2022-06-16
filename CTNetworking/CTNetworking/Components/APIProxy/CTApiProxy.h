//
//  AXApiProxy.h
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTURLResponse.h"


typedef void(^CTCallback)(CTURLResponse *response);

@interface CTApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSString *)callApiWithRequest:(NSURLRequest *)request success:(CTCallback)success fail:(CTCallback)fail;
- (void)cancelRequestWithRequestID:(NSString *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
