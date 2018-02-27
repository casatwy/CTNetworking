//
//  AXApiProxy.m
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CTApiProxy.h"
#import "CTServiceFactory.h"
#import "CTLogger.h"
#import "NSURLRequest+CTNetworkingMethods.h"
#import "NSString+AXNetworkingMethods.h"
#import "NSObject+AXNetworkingMethods.h"

static NSString * const kAXApiProxyDispatchItemKeyCallbackSuccess = @"kAXApiProxyDispatchItemCallbackSuccess";
static NSString * const kAXApiProxyDispatchItemKeyCallbackFail = @"kAXApiProxyDispatchItemCallbackFail";

NSString * const kCTApiProxyValidateResultKeyResponseJSONObject = @"kCTApiProxyValidateResultKeyResponseJSONObject";
NSString * const kCTApiProxyValidateResultKeyResponseJSONString = @"kCTApiProxyValidateResultKeyResponseJSONString";
NSString * const kCTApiProxyValidateResultKeyResponseData = @"kCTApiProxyValidateResultKeyResponseData";

@interface CTApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation CTApiProxy
#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(CTCallback)success fail:(CTCallback)fail
{
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                         uploadProgress:nil
                                       downloadProgress:nil
                                      completionHandler:^(NSURLResponse * _Nonnull response, NSData * _Nullable responseData, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        
        NSDictionary *result = [request.service resultWithResponseData:responseData response:response request:request error:&error];
        // 输出返回数据
        CTURLResponse *CTResponse = [[CTURLResponse alloc] initWithResponseString:result[kCTApiProxyValidateResultKeyResponseJSONString]
                                                                        requestId:requestID
                                                                          request:request
                                                                  responseContent:result[kCTApiProxyValidateResultKeyResponseJSONObject]
                                                                            error:error];

        CTResponse.logString = [CTLogger logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                                                  rawResponseData:responseData
                                                   responseString:result[kCTApiProxyValidateResultKeyResponseJSONString]
                                                          request:request
                                                            error:error];

        if (error) {
            fail?fail(CTResponse):nil;
        } else {
            success?success(CTResponse):nil;
        }
    }];

    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

@end
