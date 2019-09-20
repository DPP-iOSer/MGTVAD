//
//  SkipAdManager.h
//  MGTVREDylib
//
//  Created by DPP on 2019/9/19.
//  Copyright © 2019 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SkipAdManager : NSObject

+ (void)updateSkipAdStatus:(BOOL)isOn;
+ (BOOL)skipAdStatus;

@end

NS_ASSUME_NONNULL_END
