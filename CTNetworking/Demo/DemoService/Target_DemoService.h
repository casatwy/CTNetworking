//
//  Target_DemoService.h
//  CTNetworking
//
//  Created by casa on 2018/2/27.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoService.h"

extern NSString * const CTNetworkingDemoServiceIdentifier;

@interface Target_DemoService : NSObject

- (DemoService *)Action_DemoService:(NSDictionary *)params;

@end
