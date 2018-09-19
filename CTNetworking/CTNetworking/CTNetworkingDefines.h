//
//  CTNetworkingDefines.h
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#ifndef CTNetworkingDefines_h
#define CTNetworkingDefines_h

#import <UIKit/UIKit.h>

@class CTAPIBaseManager;
@class CTURLResponse;

typedef NS_ENUM (NSUInteger, CTServiceAPIEnvironment){
    CTServiceAPIEnvironmentDevelop,
    CTServiceAPIEnvironmentReleaseCandidate,
    CTServiceAPIEnvironmentRelease
};

typedef NS_ENUM (NSUInteger, CTAPIManagerRequestType){
    CTAPIManagerRequestTypePost,
    CTAPIManagerRequestTypeGet,
    CTAPIManagerRequestTypePut,
    CTAPIManagerRequestTypeDelete,
};

typedef NS_ENUM (NSUInteger, CTAPIManagerErrorType){
    CTAPIManagerErrorTypeNeedAccessToken, // 需要重新刷新accessToken
    CTAPIManagerErrorTypeNeedLogin,       // 需要登陆
    CTAPIManagerErrorTypeDefault,         // 没有产生过API请求，这个是manager的默认状态。
    CTAPIManagerErrorTypeLoginCanceled,   // 调用API需要登陆态，弹出登陆页面之后用户取消登陆了
    CTAPIManagerErrorTypeSuccess,         // API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    CTAPIManagerErrorTypeNoContent,       // API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    CTAPIManagerErrorTypeParamsError,     // 参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    CTAPIManagerErrorTypeTimeout,         // 请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    CTAPIManagerErrorTypeNoNetWork,       // 网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    CTAPIManagerErrorTypeCanceled,        // 取消请求
    CTAPIManagerErrorTypeNoError,         // 无错误
    CTAPIManagerErrorTypeDownGrade,       // APIManager被降级了
};

typedef NS_OPTIONS(NSUInteger, CTAPIManagerCachePolicy) {
    CTAPIManagerCachePolicyNoCache = 0,
    CTAPIManagerCachePolicyMemory = 1 << 0,
    CTAPIManagerCachePolicyDisk = 1 << 1,
};

extern NSString * _Nonnull const kCTAPIBaseManagerRequestID;

// notification name
extern NSString * _Nonnull const kCTUserTokenInvalidNotification;
extern NSString * _Nonnull const kCTUserTokenIllegalNotification;
extern NSString * _Nonnull const kCTUserTokenNotificationUserInfoKeyManagerToContinue;

// result
extern NSString * _Nonnull const kCTApiProxyValidateResultKeyResponseObject;
extern NSString * _Nonnull const kCTApiProxyValidateResultKeyResponseString;
//extern NSString * _Nonnull const kCTApiProxyValidateResultKeyResponseData;

/*************************************************************************************/
@protocol CTAPIManager <NSObject>

@required
- (NSString *_Nonnull)methodName;
- (NSString *_Nonnull)serviceIdentifier;
- (CTAPIManagerRequestType)requestType;

@optional
- (void)cleanData;
- (NSDictionary *_Nullable)reformParams:(NSDictionary *_Nullable)params;
- (NSInteger)loadDataWithParams:(NSDictionary *_Nullable)params;

@end

/*************************************************************************************/
@protocol CTAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(CTAPIBaseManager *_Nonnull)manager beforePerformSuccessWithResponse:(CTURLResponse *_Nonnull)response;
- (void)manager:(CTAPIBaseManager *_Nonnull)manager afterPerformSuccessWithResponse:(CTURLResponse *_Nonnull)response;

- (BOOL)manager:(CTAPIBaseManager *_Nonnull)manager beforePerformFailWithResponse:(CTURLResponse *_Nonnull)response;
- (void)manager:(CTAPIBaseManager *_Nonnull)manager afterPerformFailWithResponse:(CTURLResponse *_Nonnull)response;

- (BOOL)manager:(CTAPIBaseManager *_Nonnull)manager shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(CTAPIBaseManager *_Nonnull)manager afterCallingAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(CTAPIBaseManager *_Nonnull)manager didReceiveResponse:(CTURLResponse *_Nullable)response;

@end

/*************************************************************************************/

@protocol CTAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager * _Nonnull)manager;
- (void)managerCallAPIDidFailed:(CTAPIBaseManager * _Nonnull)manager;
@end

@protocol CTPagableAPIManager <NSObject>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign, readonly) NSUInteger currentPageNumber;
@property (nonatomic, assign, readonly) BOOL isFirstPage;
@property (nonatomic, assign, readonly) BOOL isLastPage;

- (void)loadNextPage;

@end

/*************************************************************************************/

@protocol CTAPIManagerDataReformer <NSObject>
@required
- (id _Nullable)manager:(CTAPIBaseManager * _Nonnull)manager reformData:(NSDictionary * _Nullable)data;
@end

/*************************************************************************************/

@protocol CTAPIManagerValidator <NSObject>
@required
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *_Nonnull)manager isCorrectWithCallBackData:(NSDictionary *_Nullable)data;
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *_Nonnull)manager isCorrectWithParamsData:(NSDictionary *_Nullable)data;
@end

/*************************************************************************************/

@protocol CTAPIManagerParamSource <NSObject>
@required
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager;
@end

#endif /* CTNetworkingDefines_h */
