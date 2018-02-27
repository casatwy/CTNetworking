//
//  AJKBaseManager.h
//  casatwy2
//
//  Created by casa on 13-12-2.
//  Copyright (c) 2013年 casatwy inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTURLResponse.h"
#import "CTNetworkingDefines.h"

@interface CTAPIBaseManager : NSObject <NSCopying>

// outter functions
@property (nonatomic, weak) id <CTAPIManagerCallBackDelegate> _Nullable delegate;
@property (nonatomic, weak) id <CTAPIManagerParamSource> _Nullable paramSource;
@property (nonatomic, weak) id <CTAPIManagerValidator> _Nullable validator;
@property (nonatomic, weak) NSObject<CTAPIManager> * _Nullable child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id <CTAPIManagerInterceptor> _Nullable interceptor;

// cache
@property (nonatomic, assign) CTAPIManagerCachePolicy cachePolicy;
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond; // 默认 3 * 60
@property (nonatomic, assign) NSTimeInterval diskCacheSecond; // 默认 3 * 60
@property (nonatomic, assign) BOOL shouldIgnoreCache;  //默认NO

// response
@property (nonatomic, strong) CTURLResponse * _Nonnull response;
@property (nonatomic, readonly) CTAPIManagerErrorType errorType;
@property (nonatomic, copy, readonly) NSString * _Nullable errorMessage;

// before loading
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

// start
- (NSInteger)loadData;
+ (NSInteger)loadDataWithParams:(NSDictionary * _Nullable)params success:(void (^ _Nullable)(CTAPIBaseManager * _Nonnull apiManager))successCallback fail:(void (^ _Nullable)(CTAPIBaseManager * _Nonnull apiManager))failCallback;

// cancel
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// finish
- (id _Nullable )fetchDataWithReformer:(id <CTAPIManagerDataReformer> _Nullable)reformer;
- (void)cleanData;

@end

@interface CTAPIBaseManager (InnerInterceptor)

- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *_Nullable)response;
- (void)afterPerformSuccessWithResponse:(CTURLResponse *_Nullable)response;

- (BOOL)beforePerformFailWithResponse:(CTURLResponse *_Nullable)response;
- (void)afterPerformFailWithResponse:(CTURLResponse *_Nullable)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)afterCallingAPIWithParams:(NSDictionary *_Nullable)params;

@end

