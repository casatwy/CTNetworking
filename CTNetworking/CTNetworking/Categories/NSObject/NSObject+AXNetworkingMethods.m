//
//  NSObject+AXNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSObject+AXNetworkingMethods.h"

@implementation NSObject (AXNetworkingMethods)

- (id)CT_defaultValue:(id)defaultData
{
    BOOL shouldContinue = NO;
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [self isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
        if ([defaultData isKindOfClass:[NSString class]] || [defaultData isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [defaultData isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            shouldContinue = YES;
        }
    } else if (![defaultData isMemberOfClass:[self class]]) {
        return defaultData;
    }
    
    if (shouldContinue == NO) {
        return [NSString stringWithFormat:@"%@", defaultData];
    }
    
    if ([self CT_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)CT_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
