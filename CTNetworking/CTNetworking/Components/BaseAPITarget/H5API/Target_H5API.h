//
//  BLBaseAPITarget.h
//  BLNetworking
//
//  Created by casa on 2017/1/18.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTAPIBaseManager.h"

extern NSString * const kCTBaseAPITargetAPIContextDataKeyParamsForAPI;
extern NSString * const kCTBaseAPITargetAPIContextDataKeyParamsAPIManager;
extern NSString * const kCTBaseAPITargetAPIContextDataKeyOriginActionParams;

@interface Target_H5API : NSObject <CTAPIManagerCallBackDelegate, CTAPIManagerParamSource, CTAPIManagerInterceptor>

- (id)Action_loadAPI:(NSDictionary *)params;

@end
