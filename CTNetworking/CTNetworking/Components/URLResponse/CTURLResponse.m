//
//  AXURLResponse.m
//  RTNetworking
//
//  Created by casa on 14-5-18.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTURLResponse.h"
#import "NSObject+AXNetworkingMethods.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface CTURLResponse ()

@property (nonatomic, assign, readwrite) CTURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;
@property (nonatomic, strong, readwrite) NSString *errorMessage;

@end

@implementation CTURLResponse

#pragma mark - life cycle
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseObject:(NSDictionary *)responseObject error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.contentString = [responseString CT_defaultValue:@""];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.acturlRequestParams = request.actualRequestParams;
        self.originRequestParams = request.originRequestParams;
        self.isCache = NO;
        self.status = [self responseStatusWithError:error];
        self.content = responseObject ? responseObject : @{};
        self.errorMessage = [NSString stringWithFormat:@"%@", error];
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = data;
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

#pragma mark - private methods
- (CTURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        CTURLResponseStatus result = CTURLResponseStatusErrorNoNetwork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = CTURLResponseStatusErrorTimeout;
        }
        if (error.code == NSURLErrorCancelled) {
            result = CTURLResponseStatusErrorCancel;
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            result = CTURLResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return CTURLResponseStatusSuccess;
    }
}

#pragma mark - getters and setters
- (NSData *)responseData
{
    if (_responseData == nil) {
        NSError *error = nil;
        _responseData = [NSJSONSerialization dataWithJSONObject:self.content options:0 error:&error];
        if (error) {
            _responseData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return _responseData;
}

@end
