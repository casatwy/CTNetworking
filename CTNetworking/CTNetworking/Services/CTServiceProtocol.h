//
//  CTServiceProtocol.h
//  BLNetworking
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTNetworkingDefines.h"
#import <AFNetworking/AFNetworking.h>

@protocol CTServiceProtocol <NSObject>

@property (nonatomic, assign)CTServiceAPIEnvironment apiEnvironment;

- (NSURLRequest *)requestWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        requestType:(CTAPIManagerRequestType)requestType;

- (NSDictionary *)resultWithResponseObject:(id)responseObject
                                response:(NSURLResponse *)response
                                 request:(NSURLRequest *)request
                                   error:(NSError **)error;

/*
 return true means should continue the error handling process in CTAPIBaseManager
 return false means stop the error handling process
 
 如果检查错误之后，需要继续走fail路径上报到业务层的，return YES。（例如网络错误等，需要业务层弹框）
 如果检查错误之后，不需要继续走fail路径上报到业务层的，return NO。（例如用户token失效，此时挂起API，调用刷新token的API，成功之后再重新调用原来的API。那么这种情况就不需要继续走fail路径上报到业务。）
 */
- (BOOL)handleCommonErrorWithResponse:(CTURLResponse *)response
                              manager:(CTAPIBaseManager *)manager
                            errorType:(CTAPIManagerErrorType)errorType;

@optional
- (AFHTTPSessionManager *)sessionManager;

@end
