//
//  SkipAdManager.m
//  MGTVREDylib
//
//  Created by DPP on 2019/9/19.
//  Copyright © 2019 meitu. All rights reserved.
//

#import "SkipAdManager.h"

@implementation SkipAdManager

+ (void)updateSkipAdStatus:(BOOL)isOn {
    [NSUserDefaults.standardUserDefaults setBool:isOn forKey:@"SkipAdKey"];
    [NSUserDefaults.standardUserDefaults synchronize];
}
+ (BOOL)skipAdStatus {
    return [NSUserDefaults.standardUserDefaults boolForKey:@"SkipAdKey"];
}

@end
