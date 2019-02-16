//
//  SiriShortcutOptions.h
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

@interface SiriShortcutOptions : NSObject

/*!
 @brief A unique value used to identify the user activity. It is also used to update or remove the shortcut.
 */
@property(nonatomic, copy) NSString *persistentIdentifier;

/*!
 @brief An user-visible title for this activity, such as a document name or web page title. It is displayed to the user as the name of the shortcut.
 */
@property(nonatomic, copy) NSString *title;

/*!
 @brief The phrase the user speaks to invoke the shortcut.
 */
@property(nonatomic, copy) NSString *invocationPhrase;

/*!
 @brief A key-value object that contains information about the shortcut.
 */
@property(nonatomic, strong) NSMutableDictionary *userInfo;

/*!
 @brief A Boolean value that indicates whether the activity should be added to the on-device index to make it searchable via Siri. Default value is true.
 */
@property(atomic, assign) bool isEligibleForSearch;

/*!
 @brief A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. Default value is true.
 */
@property(atomic, assign) bool isEligibleForPrediction;

/*!
 @brief Creates instance initialized with values of given array.
 @return Will return initialized instance.
 */
- (instancetype)initWithArguments:(NSArray *)arguments;

/*!
 @brief Checks whether shortcut options were initialized proper or not.
 @return Will return validity result.
 */
- (bool)isValid;

@end
