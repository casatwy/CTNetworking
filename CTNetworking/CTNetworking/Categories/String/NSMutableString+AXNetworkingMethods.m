//
//  NSMutableString+AXNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-17.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSMutableString+AXNetworkingMethods.h"
#import "NSObject+AXNetworkingMethods.h"
#import "NSURLRequest+CTNetworkingMethods.h"
#import "NSDictionary+AXNetworkingMethods.h"

@implementation NSMutableString (AXNetworkingMethods)

- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Origin Params:\n\t%@", request.originRequestParams.CT_jsonString];
    [self appendFormat:@"\n\nHTTP Actual Params:\n\t%@", request.actualRequestParams.CT_jsonString];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] CT_defaultValue:@"\t\t\t\tN/A"]];

    NSMutableString *headerString = [[NSMutableString alloc] init];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *header = [NSString stringWithFormat:@" -H \"%@: %@\"", key, obj];
        [headerString appendString:header];
    }];

    [self appendString:@"\n\nCURL:\n\t curl"];
    [self appendFormat:@" -X %@", request.HTTPMethod];
    
    if (headerString.length > 0) {
        [self appendString:headerString];
    }
    if (request.HTTPBody.length > 0) {
        [self appendFormat:@" -d '%@'", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] CT_defaultValue:@"\t\t\t\tN/A"]];
    }
    
    [self appendFormat:@" %@", request.URL];
}

@end
