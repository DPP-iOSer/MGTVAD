//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MGTVREDylib.m
//  MGTVREDylib
//
//  Created by DPP on 2019/9/18.
//  Copyright (c) 2019 meitu. All rights reserved.
//

#import "MGTVREDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import "SkipAdManager.h"

@interface MGADHarlfScreenControlView

- (void)clickSkipView;

@end

CHDeclareClass(MGADView)
CHDeclareClass(MGADBaseControlView)

CHDeclareClass(SettingsViewController)

@interface SettingsViewController

- (long)tableView:(id)arg1 numberOfRowsInSection:(long)arg2;

@end

CHDeclareClass(SkipHeadAndEndCell);

@interface BaseSwitchCell

@property(retain, nonatomic) UILabel *titleLabel;
@property(retain, nonatomic) UISwitch *switchView;
- (id)initWithStyle:(long)arg1 reuseIdentifier:(id)arg2;
- (void)switchAction:(id)arg1;

@end

CHDeclareClass(MGVODView);

CHConstructor{
    printf(INSERT_SUCCESS_WELCOME);
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

CHOptimizedMethod2(self, void, MGADView, showSkipView, BOOL, arg1, canSkipTime, int, arg2) {
//    if ([SkipAdManager skipAdStatus]) {
//        UIView *selfView = (UIView *)self;
//
//        for (UIView *subViews in selfView.subviews) {
//            if ([subViews isKindOfClass:NSClassFromString(@"MGADHarlfScreenControlView")]) {
//                MGADHarlfScreenControlView *controlView = (MGADHarlfScreenControlView *)subViews;
//                [controlView clickSkipView];
//
//                break;
//            }
//        }
//    } else {
        CHSuper2(MGADView, showSkipView, arg1, canSkipTime, arg2);
//    }
}

CHOptimizedMethod1(self, void, MGADBaseControlView, clickButtonType, long, arg1) {
    CHSuper1(MGADBaseControlView, clickButtonType, arg1);
}

CHOptimizedMethod2(self, void, MGADView, ADControlViewButtonCallback, long, arg1, adInfo, id, arg2) {
    CHSuper2(MGADView, ADControlViewButtonCallback, arg1, adInfo, arg2);
}

// 跳过广告开关
CHOptimizedMethod2(self, long, SettingsViewController, tableView, id, arg1, numberOfRowsInSection, long, arg2) {
    long count = CHSuper2(SettingsViewController, tableView, arg1, numberOfRowsInSection, arg2);
    if (arg2 == 1) {
        count += 1;
    }

    return count;
}

CHOptimizedMethod2(self, id, SettingsViewController, tableView, UITableView *, arg1, cellForRowAtIndexPath, id, arg2) {
    NSIndexPath *indexPath = nil;
    if ([arg2 isKindOfClass:[NSIndexPath class]]) {
        indexPath = (NSIndexPath *)arg2;
    }

    if (indexPath.section == 1 && indexPath.item == ([self tableView:self numberOfRowsInSection:indexPath.section] - 1)) {
        BaseSwitchCell *cell = (BaseSwitchCell *)[arg1 dequeueReusableCellWithIdentifier:@"SkipHeadAndEndCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSClassFromString(@"BaseSwitchCell") alloc] initWithStyle:0 reuseIdentifier:@"SkipHeadAndEndCell"];
        }
        cell.titleLabel.text = @"DPP要跳过广告！！！";
        cell.switchView.on = [SkipAdManager skipAdStatus];
        cell.switchView.tag = 999;
        
        return cell;
    }


    return CHSuper2(SettingsViewController, tableView, arg1, cellForRowAtIndexPath, arg2);
}

CHOptimizedMethod1(self, void, SkipHeadAndEndCell, switchAction, id, arg1) {
    UISwitch *switchView = (UISwitch *)arg1;
    if (switchView.tag == 999) {
        [SkipAdManager updateSkipAdStatus:switchView.isOn];
    } else {
        CHSuper1(SkipHeadAndEndCell, switchAction, arg1);
    }
}

// 去广告接口
CHOptimizedMethod4(self, void, MGVODView, requestADsWithVideoId, id, arg1, pcUrl, id, arg2, clipId, id, arg3, params, NSString *, arg4) {
    NSData *jsonData = [arg4 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    if ([SkipAdManager skipAdStatus]) {
        [dict[@"v"] setValue:@(1) forKey:@"vip"];
    }

    NSData *newJsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:newJsonData encoding:NSUTF8StringEncoding];
    CHSuper4(MGVODView, requestADsWithVideoId, arg1, pcUrl, arg2, clipId, arg3, params, jsonString);
}

#pragma clang diagnostic pop


CHConstructor{
    CHLoadLateClass(MGADView);
    CHHook2(MGADView, showSkipView, canSkipTime);
    CHHook2(MGADView, ADControlViewButtonCallback, adInfo);
    
    CHLoadLateClass(MGADBaseControlView);
    CHHook1(MGADBaseControlView, clickButtonType);
    
    CHLoadLateClass(SettingsViewController);
    CHHook2(SettingsViewController, tableView, numberOfRowsInSection);
    CHHook2(SettingsViewController, tableView, cellForRowAtIndexPath);
    
    CHLoadLateClass(SkipHeadAndEndCell);
    CHHook1(SkipHeadAndEndCell, switchAction);
    

    CHLoadLateClass(MGVODView);
    CHHook4(MGVODView, requestADsWithVideoId, pcUrl, clipId, params);
}
