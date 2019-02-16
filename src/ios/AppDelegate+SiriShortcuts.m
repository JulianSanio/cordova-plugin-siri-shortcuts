//
//  AppDelegate+SiriShortcuts.m
//  Cordova Plugin Siri Shortcuts
//
//  ISC License (ISC)
//  Copyright 2019 Julian Sanio
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
//  OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
//  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

#import "AppDelegate+SiriShortcuts.h"
#import "SiriShortcuts.h"
#import <objc/runtime.h>

static void *UserActivityPropertyKey = &UserActivityPropertyKey;

@implementation AppDelegate (siriShortcuts)

- (NSUserActivity *)userActivity {
    return objc_getAssociatedObject(self, UserActivityPropertyKey);
}

- (void)setUserActivity:(NSUserActivity *)activity {
    objc_setAssociatedObject(self, UserActivityPropertyKey, activity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    NSString *activityType = [SiriShortcuts getActivityType];
    if ([userActivity.activityType isEqualToString:activityType]) {
        self.userActivity = userActivity;
        return YES;
    }
    return NO;
}

@end
