//
//  SiriShortcutResponseCode.h
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

#import <Foundation/Foundation.h>

/*!
 @typedef SiriShortcutResponseCode
 @brief A list of response codes.
 @constant SiriShortcutResponseCodeDonated Siri shortcut was donated.
 @constant SiriShortcutResponseCodeAdded Siri shortcut was added.
 @constant SiriShortcutResponseCodeUpdated Siri shortcut was updated.
 @constant SiriShortcutResponseCodeDeleted Siri shortcut was deleted.
 @constant SiriShortcutResponseCodeActivatedShortcut Activated Siri shortcut was fetched.
 @constant SiriShortcutResponseCodeAllShortcuts All Siri shortcuts were fetched.
 @constant SiriShortcutResponseCodeCanceled Siri shortcut activity was canceled.
 @constant SiriShortcutResponseCodeInvalidArguments Invalid arguments.
 @constant SiriShortcutResponseCodeNoSiriShortcuts Siri shortcuts is not available, user might not run iOS 12+.
 @constant SiriShortcutResponseCodeInternalError An Internal error occurred.
 @constant SiriShortcutResponseCodeNoShortcutActivated No Siri shortcut was activated.
 */
typedef NS_ENUM(NSInteger, SiriShortcutResponseCode) {
    // Success
    SiriShortcutResponseCodeDonated = 0,
    SiriShortcutResponseCodeAdded = 1,
    SiriShortcutResponseCodeUpdated = 2,
    SiriShortcutResponseCodeDeleted = 3,
    SiriShortcutResponseCodeActivatedShortcut = 4,
    SiriShortcutResponseCodeAllShortcuts = 5,
    // Error
    SiriShortcutResponseCodeCanceled = 6,
    SiriShortcutResponseCodeInvalidArguments = 7,
    SiriShortcutResponseCodeNoSiriShortcuts = 8,
    SiriShortcutResponseCodeInternalError = 9,
    SiriShortcutResponseCodeNoShortcutActivated = 10
};

/*!
 @brief Returns the description of given response code.
 @param responseCode The response code.
 @return Will return the description.
 */
NSString * SiriShortcutResponseCodeDescription(SiriShortcutResponseCode responseCode);
