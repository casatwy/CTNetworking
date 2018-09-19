//
//  BLBaseAPITarget.m
//  BLNetworking
//
//  Created by casa on 2017/1/18.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "Target_H5API.h"
#import "CTApiProxy.h"

typedef void (^CTH5APICallback)(NSDictionary *result);

NSString * const kCTBaseAPITargetAPIContextDataKeyParamsForAPI = @"kCTBaseAPITargetAPIContextDataKeyParamsForAPI";
NSString * const kCTBaseAPITargetAPIContextDataKeyParamsAPIManager = @"kCTBaseAPITargetAPIContextDataKeyParamsAPIManager";
NSString * const kCTBaseAPITargetAPIContextDataKeyOriginActionParams = @"kCTBaseAPITargetAPIContextDataKeyOriginActionParams";

NSString * const kCTOriginActionCallbackKeySuccess = @"success";
NSString * const kCTOriginActionCallbackKeyFail = @"fail";
NSString * const kCTOriginActionCallbackKeyProgress = @"progress";

@interface Target_H5API ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *APIContextDictionary;

@end

@implementation Target_H5API

- (id)Action_loadAPI:(NSDictionary *)params
{
    NSDictionary *paramsForAPI = params[@"data"];
    
    if (paramsForAPI == nil) {
        paramsForAPI = @{};
    }
    
    if ([paramsForAPI isKindOfClass:[NSDictionary class]] == NO) {
        return nil;
    }

    Class APIManagerClass = NSClassFromString(params[@"apiName"]);
    CTAPIBaseManager *apiManager = [[APIManagerClass alloc] init];
    if ([apiManager isKindOfClass:[CTAPIBaseManager class]]) {
        self.APIContextDictionary[apiManager] = @{
                                                  kCTBaseAPITargetAPIContextDataKeyParamsForAPI:paramsForAPI,
                                                  kCTBaseAPITargetAPIContextDataKeyOriginActionParams:params,
                                                  kCTBaseAPITargetAPIContextDataKeyParamsAPIManager:apiManager
                                                  };
        
        apiManager.delegate = self;
        apiManager.paramSource = self;
        apiManager.interceptor = self;
        [apiManager loadData];
    }
    return nil;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    CTH5APICallback successCallback = self.APIContextDictionary[manager][kCTBaseAPITargetAPIContextDataKeyOriginActionParams][kCTOriginActionCallbackKeySuccess];
    if (successCallback) {
        NSMutableDictionary *fetchedData = [manager fetchDataWithReformer:nil];
        if ([fetchedData isKindOfClass:[NSMutableDictionary class]]) {
            [fetchedData removeObjectForKey:kCTApiProxyValidateResultKeyResponseString];
//            [fetchedData removeObjectForKey:kCTApiProxyValidateResultKeyResponseData];
        }
        successCallback(fetchedData);
    }
    [self.APIContextDictionary removeObjectForKey:manager];
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    CTH5APICallback failCallback = self.APIContextDictionary[manager][kCTBaseAPITargetAPIContextDataKeyOriginActionParams][kCTOriginActionCallbackKeyFail];
    if (failCallback) {
        failCallback([manager fetchDataWithReformer:nil]);
    }
    [self.APIContextDictionary removeObjectForKey:manager];
}

#pragma mark - CTAPIManagerInterceptor
- (void)manager:(CTAPIBaseManager *)manager didReceiveResponse:(CTURLResponse *)response
{
    CTH5APICallback progressCallback = self.APIContextDictionary[manager][kCTBaseAPITargetAPIContextDataKeyOriginActionParams][kCTOriginActionCallbackKeyProgress];
    if (progressCallback) {
        progressCallback(@{
                           @"result":@"progress",
                           @"status":@"request finished"
                           });
    }
}

- (BOOL)manager:(CTAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params
{
    CTH5APICallback progressCallback = self.APIContextDictionary[manager][kCTBaseAPITargetAPIContextDataKeyOriginActionParams][kCTOriginActionCallbackKeyProgress];
    if (progressCallback) {
        progressCallback(@{
                           @"result":@"progress",
                           @"status":@"request started"
                           });
    }
    return YES;
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager
{
    NSDictionary *result = self.APIContextDictionary[manager][kCTBaseAPITargetAPIContextDataKeyParamsForAPI];
    return  result;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)APIContextDictionary
{
    if (_APIContextDictionary == nil) {
        _APIContextDictionary = [[NSMutableDictionary alloc] init];
    }
    return _APIContextDictionary;
}

@end
