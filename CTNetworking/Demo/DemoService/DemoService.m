//
//  DemoService.m
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "DemoService.h"
#import <AFNetworking/AFNetworking.h>
#import "CTNetworking.h"

@interface DemoService ()

@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *privateKey;
@property (nonatomic, strong) NSString *baseURL;

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation DemoService

#pragma mark - public methods
- (NSURLRequest *)requestWithParams:(NSDictionary *)params methodName:(NSString *)methodName requestType:(CTAPIManagerRequestType)requestType
{
    if (requestType == CTAPIManagerRequestTypeGet) {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseURL, methodName];
        NSString *tsString = [NSUUID UUID].UUIDString;
        NSString *md5Hash = [[NSString stringWithFormat:@"%@%@%@", tsString, self.privateKey, self.publicKey] CT_MD5];
        NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET"
                                                                           URLString:urlString
                                                                          parameters:@{
                                                                                       @"apikey":self.publicKey,
                                                                                       @"ts":tsString,
                                                                                       @"hash":md5Hash
                                                                                       }
                                                                               error:nil];
        return request;
    }

    return nil;
}

- (NSDictionary *)resultWithResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError **)error
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[kCTApiProxyValidateResultKeyResponseData] = responseData;
    result[kCTApiProxyValidateResultKeyResponseJSONString] = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    result[kCTApiProxyValidateResultKeyResponseJSONObject] = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    return result;
}

- (BOOL)handleCommonErrorWithResponse:(CTURLResponse *)response manager:(CTAPIBaseManager *)manager errorType:(CTAPIManagerErrorType)errorType
{
    // 业务上这些错误码表示需要重新登录
    NSString *resCode = [NSString stringWithFormat:@"%@", response.content[@"resCode"]];
    if ([resCode isEqualToString:@"00100009"]
        || [resCode isEqualToString:@"05111001"]
        || [resCode isEqualToString:@"05111002"]
        || [resCode isEqualToString:@"1080002"]
        ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCTUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kCTUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return NO;
    }
    
    // 业务上这些错误码表示需要刷新token
    NSString *errorCode = [NSString stringWithFormat:@"%@", response.content[@"errorCode"]];
    if ([response.content[@"errorMsg"] isEqualToString:@"invalid token"]
        || [response.content[@"errorMsg"] isEqualToString:@"access_token is required"]
        || [errorCode isEqualToString:@"BL10015"]
        ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCTUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kCTUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return NO;
    }
    
    return YES;
}

#pragma mark - getters and setters
- (NSString *)publicKey
{
    return @"d97bab99fa506c7cdf209261ffd06652";
}

- (NSString *)privateKey
{
    return @"31bb736a11cbc10271517816540e626c4ff2279a";
}

- (NSString *)baseURL
{
    if (self.apiEnvironment == CTServiceAPIEnvironmentRelease) {
        return @"https://gateway.marvel.com:443/v1";
    }
    if (self.apiEnvironment == CTServiceAPIEnvironmentDevelop) {
        return @"https://gateway.marvel.com:443/v1";
    }
    if (self.apiEnvironment == CTServiceAPIEnvironmentReleaseCandidate) {
        return @"https://gateway.marvel.com:443/v1";
    }
    return @"https://gateway.marvel.com:443/v1";
}

- (CTServiceAPIEnvironment)apiEnvironment
{
    return CTServiceAPIEnvironmentRelease;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}

@end
