//
//  CTMediator+CTAppContext.h
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <AFNetworking/AFNetworking.h>

@interface CTMediator (CTAppContext)

- (BOOL)CTNetworking_shouldPrintNetworkingLog;
- (BOOL)CTNetworking_isReachable;
- (NSInteger)CTNetworking_cacheResponseCountLimit;

@end
