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
#import "CTMediator+CTAppContext.h"
#import <pthread/pthread.h>

static NSString * const kAXApiProxyDispatchItemKeyCallbackSuccess = @"kAXApiProxyDispatchItemCallbackSuccess";
static NSString * const kAXApiProxyDispatchItemKeyCallbackFail = @"kAXApiProxyDispatchItemCallbackFail";

NSString * const kCTApiProxyValidateResultKeyResponseObject = @"kCTApiProxyValidateResultKeyResponseObject";
NSString * const kCTApiProxyValidateResultKeyResponseString = @"kCTApiProxyValidateResultKeyResponseString";
//NSString * const kCTApiProxyValidateResultKeyResponseData = @"kCTApiProxyValidateResultKeyResponseData";

@interface CTApiProxy ()
{
    pthread_rwlock_t _dispatchTableLock;
}

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
//@property (nonatomic, strong) NSNumber *recordedRequestId;

@end

@implementation CTApiProxy

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_rwlock_init(&_dispatchTableLock, NULL);
    }
    return self;
}

- (void)dealloc {
    pthread_rwlock_destroy(&_dispatchTableLock);
}

#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManagerWithService:(id<CTServiceProtocol>)service
{
    AFHTTPSessionManager *sessionManager = nil;
    if ([service respondsToSelector:@selector(sessionManager)]) {
        sessionManager = service.sessionManager;
    }
    if (sessionManager == nil) {
        sessionManager = [AFHTTPSessionManager manager];
    }
    return sessionManager;
}

- (NSString *)requestIDWithService:(id<CTServiceProtocol>)service dataTask:(NSURLSessionDataTask *)dataTask {
    NSString *requestId = [NSString stringWithFormat:@"%@-%ld", NSStringFromClass(service.class), [dataTask taskIdentifier]];
    
    return requestId;
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

- (void)cancelAllRequests
{
    pthread_rwlock_wrlock(&_dispatchTableLock);
    
    [self.dispatchTable enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                            NSURLSessionDataTask * _Nonnull obj,
                                                            BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self.dispatchTable removeAllObjects];
    
    pthread_rwlock_unlock(&_dispatchTableLock);
}

- (void)cancelRequestWithRequestID:(NSString *)requestID
{
    pthread_rwlock_wrlock(&_dispatchTableLock);
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
    pthread_rwlock_unlock(&_dispatchTableLock);
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSString *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSString *)callApiWithRequest:(NSURLRequest *)request success:(CTCallback)success fail:(CTCallback)fail
{
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [[self sessionManagerWithService:request.service] dataTaskWithRequest:request
                                                                      uploadProgress:nil
                                                                    downloadProgress:nil
                                                                   completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        NSString *requestID = [self requestIDWithService:request.service dataTask:dataTask];
        pthread_rwlock_wrlock(&_dispatchTableLock);
        [self.dispatchTable removeObjectForKey:requestID];
        pthread_rwlock_unlock(&_dispatchTableLock);
        
        NSDictionary *result = [request.service resultWithResponseObject:responseObject response:response request:request error:&error];
        // 输出返回数据
        CTURLResponse *CTResponse = [[CTURLResponse alloc] initWithResponseString:result[kCTApiProxyValidateResultKeyResponseString]
                                                                        requestId:requestID
                                                                          request:request
                                                                  responseObject:result[kCTApiProxyValidateResultKeyResponseObject]
                                                                            error:error];

        CTResponse.logString = [CTLogger logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                                                   responseObject:responseObject
                                                   responseString:result[kCTApiProxyValidateResultKeyResponseString]
                                                          request:request
                                                            error:error];

        if (error) {
            fail?fail(CTResponse):nil;
        } else {
            success?success(CTResponse):nil;
        }
    }];

    NSString *requestId = [self requestIDWithService:request.service dataTask:dataTask];
    
    pthread_rwlock_wrlock(&_dispatchTableLock);
    self.dispatchTable[requestId] = dataTask;
    pthread_rwlock_unlock(&_dispatchTableLock);

    [dataTask resume];
    
    return requestId;
}

@end
