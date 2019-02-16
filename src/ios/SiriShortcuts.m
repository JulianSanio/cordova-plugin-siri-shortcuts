//
//  SiriShortcuts.m
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

#import "SiriShortcuts.h"
#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>
#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>
#import "AppDelegate+SiriShortcuts.h"
#import "SiriShortcutOptions.h"
#import "SiriShortcutResponseCode.h"
#import "SiriShortcutUserInfoHelper.h"

@interface SiriShortcuts ()

/*!
 @brief The invoked Url command.
 */
@property(strong, nonatomic) CDVInvokedUrlCommand *command;

/*!
 @brief User activity for Siri shortcut.
 */
@property(strong, nonatomic) NSUserActivity *userActivity;

@end

@implementation SiriShortcuts

+ (NSString *)getActivityType {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *activityName = [bundleIdentifier stringByAppendingString:@".shortcut"];
    return activityName;
}

- (void)donate:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        // Check if Siri shortcuts is available (iOS 12+)
        if (@available(iOS 12.0, *)) {
            // Validate shortcut options
            SiriShortcutOptions *options = [[SiriShortcutOptions alloc] initWithArguments:command.arguments];
            if (![options isValid]) {
                // Error: Invalid shortcut options
                [self sendStatusError:command responseCode:SiriShortcutResponseCodeInvalidArguments];
                return;
            }
            // Donate shortcut to Siri
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userActivity = [self createUserActivityWithOptions:options makeActive:true];
                // Ok: Shortcut donated successfully
                [self sendStatusOk:command responseCode:SiriShortcutResponseCodeDonated];
            });
        } else {
            // Error: Siri shortcuts is not available
            [self sendStatusError:command responseCode:SiriShortcutResponseCodeNoSiriShortcuts];
        }
    }];
}

- (void)present:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        // Check if Siri shortcuts is available (iOS 12+)
        if (@available(iOS 12.0, *)) {
            // Validate shortcut options
            SiriShortcutOptions *options = [[SiriShortcutOptions alloc] initWithArguments:command.arguments];
            if (![options isValid]) {
                // Error: Invalid shortcut options
                [self sendStatusError:command responseCode:SiriShortcutResponseCodeInvalidArguments];
                return;
            }
            // Fetch shortcut by persistent identifier to check if it was already added
            [self getVoiceShortcutByPersistentIdentifier:[options persistentIdentifier] completionHandler:^(INVoiceShortcut *voiceShortcut, NSError *error) {
                // Check if an error occurred
                if (error != nil) {
                    // Error: Internal error
                    [self sendStatusError:command responseCode:SiriShortcutResponseCodeInternalError message:[error description]];
                    return;
                }
                // No shortcut with the given persistent identifier was fetched
                if (voiceShortcut != nil) {
                    self.command = command;
                    INUIEditVoiceShortcutViewController *viewController = [[INUIEditVoiceShortcutViewController alloc] initWithVoiceShortcut:voiceShortcut];
                    viewController.delegate = self;
                    // Present view controller to edit shortcut
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.viewController presentViewController:viewController animated:true completion:nil];
                    });
                }
                // Shortcut with the given persistent identifier was fetched successfully
                else {
                    self.command = command;
                    self.userActivity = [self createUserActivityWithOptions:options makeActive:false];
                    INShortcut *shortcut = [[INShortcut alloc] initWithUserActivity:self.userActivity];
                    INUIAddVoiceShortcutViewController *viewController = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortcut];
                    viewController.delegate = self;
                    // Present view controller to add shortcut
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.viewController presentViewController:viewController animated:true completion:nil];
                    });
                }
            }];
        } else {
            // Error: Siri shortcuts is not available
            [self sendStatusError:command responseCode:SiriShortcutResponseCodeNoSiriShortcuts];
        }
    }];
}

- (void)remove:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        // Check if Siri shortcuts is available (iOS 12+)
        if (@available(iOS 12.0, *)) {
            // Get array of persistent identifiers to be deleted
            NSArray *stringIdentifiers = [command.arguments objectAtIndex:0];
            if (stringIdentifiers != nil) {
                // Prepare typed array of persistent identifiers to be deleted
                NSMutableArray<NSUserActivityPersistentIdentifier> *persistentIdentifiers = [[NSMutableArray alloc] init];
                for (NSString *stringIdentifier in stringIdentifiers) {
                    [persistentIdentifiers addObject:stringIdentifier];
                }
                // Delete shortcuts based on persistent identifiers
                [NSUserActivity deleteSavedUserActivitiesWithPersistentIdentifiers:persistentIdentifiers completionHandler:^{
                    // Ok: Shortcuts deleted successfully
                    [self sendStatusOk:command responseCode:SiriShortcutResponseCodeDeleted];
                }];
            } else {
                // Error: Invalid arguments, no persistent identifiers given
                [self sendStatusError:command responseCode:SiriShortcutResponseCodeInvalidArguments];
            }
        } else {
            // Error: Siri shortcuts is not available
            [self sendStatusError:command responseCode:SiriShortcutResponseCodeNoSiriShortcuts];
        }
    }];
}

- (void)removeAll:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        // Check if Siri shortcuts is available (iOS 12+)
        if (@available(iOS 12.0, *)) {
            // Remove all shortcuts
            [NSUserActivity deleteAllSavedUserActivitiesWithCompletionHandler:^{
                // Ok: All shortcuts deleted successfully
                [self sendStatusOk:command responseCode:SiriShortcutResponseCodeDeleted];
            }];
        } else {
            // Error: Siri shortcuts is not available
            [self sendStatusError:command responseCode:SiriShortcutResponseCodeNoSiriShortcuts];
        }
    }];
}

- (void)getActivatedShortcut:(CDVInvokedUrlCommand *)command {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.commandDelegate runInBackground:^{
        // Check if Siri shortcuts is available (iOS 12+)
        if (@available(iOS 12.0, *)) {
            // Fetch shortcut that has been activated by Siri via user activity
            NSUserActivity *userActivity = [appDelegate userActivity];
            if (userActivity != nil) {
                // Prepare shortcut data to return
                NSDictionary *shortcutData = [self prepareShortcutData:userActivity invocationPhrase:nil];
                bool clear = true;
                if ([command.arguments count] > 0) {
                    clear = [[command.arguments objectAtIndex:0] boolValue];
                }
                if (clear) {
                    appDelegate.userActivity = nil;
                }
                // Ok: Activated shortcut was fetched successfully, return activated shortcut
                [self sendStatusOk:command responseCode:SiriShortcutResponseCodeActivatedShortcut data:shortcutData];
            } else {
                // Error: No Siri shortcut was activated.
                [self sendStatusError:command responseCode:SiriShortcutResponseCodeNoShortcutActivated];
            }
        } else {
            // Error: Siri shortcuts is not available
            [self sendStatusError:command responseCode:SiriShortcutResponseCodeNoSiriShortcuts];
        }
    }];
}

- (void)getAllShortcuts:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        // Check if Siri shortcuts is available (iOS 12+)
        if (@available(iOS 12.0, *)) {
            // Fetch all shortcuts associated with this app
            [[INVoiceShortcutCenter sharedCenter] getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> *voiceShortcuts, NSError *error) {
                // Check if an error occurred
                if (error != nil) {
                    // Error: Internal error
                    [self sendStatusError:command responseCode:SiriShortcutResponseCodeInternalError message:[error description]];
                    return;
                }
                // Shortcuts were fetched successfully
                if (voiceShortcuts != nil) {
                    // Prepare list of shortcuts to return
                    NSMutableArray *voiceShortcutList = [[NSMutableArray alloc] initWithCapacity:voiceShortcuts.count];
                    for (INVoiceShortcut *voiceShortcut in voiceShortcuts) {
                        NSDictionary *shortcutData = [self prepareShortcutData:voiceShortcut.shortcut.userActivity invocationPhrase:[voiceShortcut invocationPhrase]];
                        [voiceShortcutList addObject:shortcutData];
                    }
                    // Ok: All shortcuts were fetched successfully, return list of shortcuts
                    [self sendStatusOk:command responseCode:SiriShortcutResponseCodeAllShortcuts data:voiceShortcutList];
                }
                // No shortcut was fetched
                else {
                    // Error: Internal error
                    [self sendStatusError:command responseCode:SiriShortcutResponseCodeInternalError];
                }
            }];
        } else {
            // Error: Siri shortcuts is not available
            [self sendStatusError:command responseCode:SiriShortcutResponseCodeNoSiriShortcuts];
        }
    }];
}

#pragma Helper methods

/*!
 @brief Query Siri shortcuts by persistent identifier.
 @param persistentIdentifier The persistent identifier of the shortcut to be queried.
 @param completionHandler A completion block that is called when querying shortcuts is completed.
 */
- (void)getVoiceShortcutByPersistentIdentifier:(NSString *)persistentIdentifier completionHandler:(void (^)(INVoiceShortcut *voiceShortcut, NSError *error))completionHandler API_AVAILABLE(ios(12.0)) {
    // Fetch all shortcuts associated with this app
    [[INVoiceShortcutCenter sharedCenter] getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> *voiceShortcuts, NSError *error) {
        INVoiceShortcut *voiceShortcut = nil;
        if (voiceShortcuts != nil) {
            // Iterate all shortcuts
            for (INVoiceShortcut *vShortcut in voiceShortcuts) {
                NSUserActivity *userActivity = vShortcut.shortcut.userActivity;
                NSDictionary *userInfo = [userActivity userInfo];
                NSString *pIdentifier = [userInfo valueForKey:@"persistentIdentifier"];
                // Find shortcut by persistent identifier
                if ([persistentIdentifier isEqualToString:pIdentifier]) {
                    voiceShortcut = vShortcut;
                    break;
                }
            }
        }
        // Call completion handler
        completionHandler(voiceShortcut, error);
    }];
}

/*!
 @brief Creates NSUserActivity with given options.
 @param options The Siri shortcut options.
 @param makeActive A flag to make user activity active.
 @return Will return the user activity.
 */
- (NSUserActivity *)createUserActivityWithOptions:(SiriShortcutOptions *)options makeActive:(BOOL)makeActive API_AVAILABLE(ios(12.0)) {
    NSString *activityType = [SiriShortcuts getActivityType];
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:activityType];
    userActivity.title = [options title];
    [userActivity setSuggestedInvocationPhrase:[options invocationPhrase]];
    userActivity.persistentIdentifier = [options persistentIdentifier];
    userActivity.eligibleForSearch = [options isEligibleForSearch];
    userActivity.eligibleForPrediction = [options isEligibleForPrediction];
    userActivity.eligibleForHandoff = true;
    userActivity.eligibleForPublicIndexing = true;
    NSDictionary *userInfo = @{
        @"persistentIdentifier" : [options persistentIdentifier],
        @"invocationPhrase" : [options invocationPhrase],
        @"userInfo" : [options userInfo]
    };
    if (makeActive) {
        [SiriShortcutUserInfoHelper sharedInstance].userInfo = userInfo;
        self.viewController.userActivity = userActivity;
    } else {
        userActivity.userInfo = userInfo;
    }
    return userActivity;
}

/*!
 @brief Prepares shortcut data for plugin result message.
 @param userActivity The user activity of the shotscut.
 @param invocationPhrase The phrase the user speaks to invoke the shortcut.
 @return Will return dictionary with shortcut data.
 */
- (NSDictionary *)prepareShortcutData:(NSUserActivity *)userActivity invocationPhrase:(NSString *)invocationPhrase {
    NSString *title = userActivity.title;
    NSDictionary *userInfo = [userActivity userInfo];
    NSString *persistentIdentifier = [userInfo valueForKey:@"persistentIdentifier"];
    NSString *invocPhrase = [userInfo valueForKey:@"invocationPhrase"];
    if (invocationPhrase != nil) {
        invocPhrase = invocationPhrase;
    }
    NSDictionary *shortcutData = @{
        @"title" : title,
        @"persistentIdentifier" : persistentIdentifier,
        @"invocationPhrase" : invocPhrase,
        @"userInfo" : [userInfo valueForKey:@"userInfo"]
    };
    return shortcutData;
}

/*!
 @brief Prepares message to be sent as lugin result.
 @param responseCode The response code.
 @param message The response code.
 @param data The data.
 @return Will return prepared message as dictionary.
 */
- (NSDictionary *)prepareResultMessage:(SiriShortcutResponseCode)responseCode message:(NSString *)message data:(id)data {
    NSMutableDictionary *resultMessage = [[NSMutableDictionary alloc] init];
    [resultMessage setValue:@(responseCode) forKey:@"code"];
    [resultMessage setValue:message forKey:@"message"];
    if (data != nil) {
        [resultMessage setValue:data forKey:@"data"];
    }
    return resultMessage;
}

/*!
 @brief Sends a plugin result with command status ok.
 @param command The invoked Url command.
 @param responseCode The response code to be sent.
 */
- (void)sendStatusOk:(CDVInvokedUrlCommand *)command responseCode:(SiriShortcutResponseCode)responseCode {
    [self sendStatusOk:command responseCode:responseCode data:nil];
}

/*!
 @brief Sends a plugin result with command status ok.
 @param command The invoked Url command.
 @param responseCode The response code to be sent.
 @param data The data to be sent.
 */
- (void)sendStatusOk:(CDVInvokedUrlCommand *)command responseCode:(SiriShortcutResponseCode)responseCode data:(id)data {
    CDVPluginResult *result = nil;
    if ([data isKindOfClass:[NSArray class]]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:data];
        NSLog(@"[SiriShortcutsPlugin] sendStatusOk: %@", data);
    } else {
        NSDictionary *resultMessage = [self prepareResultMessage:responseCode message:SiriShortcutResponseCodeDescription(responseCode) data:data];
        NSLog(@"[SiriShortcutsPlugin] sendStatusOk: %@", resultMessage);
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultMessage];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

/*!
 @brief Sends a plugin result with command status error.
 @param command The invoked Url command.
 @param responseCode The response code to be sent.
 */
- (void)sendStatusError:(CDVInvokedUrlCommand *)command responseCode:(SiriShortcutResponseCode)responseCode {
    [self sendStatusError:command responseCode:responseCode message:SiriShortcutResponseCodeDescription(responseCode)];
}

/*!
 @brief Sends a plugin result with command status error.
 @param command The invoked Url command.
 @param responseCode The response code to be sent.
 @param message The message to be sent.
 */
- (void)sendStatusError:(CDVInvokedUrlCommand *)command responseCode:(SiriShortcutResponseCode)responseCode message:(NSString *)message {
    NSDictionary *resultMessage = [self prepareResultMessage:responseCode message:message data:nil];
    NSLog(@"[SiriShortcutsPlugin] sendStatusError: %@", resultMessage);
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultMessage];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

#pragma INUIAddVoiceShortcutViewControllerDelegate

- (void)addVoiceShortcutViewController:(INUIAddVoiceShortcutViewController *)controller didFinishWithVoiceShortcut:(INVoiceShortcut *)voiceShortcut error:(NSError *)error API_AVAILABLE(ios(12.0)) {
    // Check if an error occurred
    if (error != nil) {
        // Error: Internal error
        [self sendStatusError:self.command responseCode:SiriShortcutResponseCodeInternalError message:[error description]];
        return;
    }
    NSDictionary *shortcutData = [self prepareShortcutData:voiceShortcut.shortcut.userActivity invocationPhrase:[voiceShortcut invocationPhrase]];
    // Ok: Shortcut was added successfully
    [self sendStatusOk:self.command responseCode:SiriShortcutResponseCodeAdded data:shortcutData];
    [controller dismissViewControllerAnimated:true completion:nil];
}

- (void)addVoiceShortcutViewControllerDidCancel:(INUIAddVoiceShortcutViewController *)controller API_AVAILABLE(ios(12.0)) {
    // Error: View controller to add shortcut was canceled
    [self sendStatusError:self.command responseCode:SiriShortcutResponseCodeCanceled];
    [controller dismissViewControllerAnimated:true completion:nil];
}

#pragma INUIEditVoiceShortcutViewControllerDelegate

- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didUpdateVoiceShortcut:(INVoiceShortcut *)voiceShortcut error:(NSError *)error API_AVAILABLE(ios(12.0)) {
    // Check if an error occurred
    if (error != nil) {
        // Error: Internal error
        [self sendStatusError:self.command responseCode:SiriShortcutResponseCodeInternalError message:[error description]];
        return;
    }
    NSDictionary *shortcutData = [self prepareShortcutData:voiceShortcut.shortcut.userActivity invocationPhrase:[voiceShortcut invocationPhrase]];
    // Ok: Shortcut was updated successfully
    [self sendStatusOk:self.command responseCode:SiriShortcutResponseCodeUpdated data:shortcutData];
    [controller dismissViewControllerAnimated:true completion:nil];
}

- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didDeleteVoiceShortcutWithIdentifier:(NSUUID *)deletedVoiceShortcutIdentifier API_AVAILABLE(ios(12.0)) {
    // Ok: Shortcut was deleted successfully
    [self sendStatusOk:self.command responseCode:SiriShortcutResponseCodeDeleted];
    [controller dismissViewControllerAnimated:true completion:nil];
}

- (void)editVoiceShortcutViewControllerDidCancel:(INUIEditVoiceShortcutViewController *)controller API_AVAILABLE(ios(12.0)) {
    // Error: View controller to edit shortcut was canceled
    [self sendStatusError:self.command responseCode:SiriShortcutResponseCodeCanceled];
    [controller dismissViewControllerAnimated:true completion:nil];
}

@end
