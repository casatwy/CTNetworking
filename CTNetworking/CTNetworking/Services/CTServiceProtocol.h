//
//  CTServiceProtocol.h
//  BLNetworking
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CTServiceProtocol <NSObject>

- (NSURLRequest *)GETRequestWithRequestParams:(NSDictionary *)params methodName:(NSString *)methodName shouldAppendCommonParams:(BOOL)shouldAppendCommonParams;
- (NSURLRequest *)POSTRequestWithRequestParams:(NSDictionary *)params methodName:(NSString *)methodName shouldAppendCommonParams:(BOOL)shouldAppendCommonParams;
- (NSDictionary *)resultAfterParseWithResponseData:(NSData *)responseData desKey:(NSString *)desKey error:(NSError **)error;

@end
