//
//  SiriShortcutOptions.m
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

#import "SiriShortcutOptions.h"

@implementation SiriShortcutOptions

- (instancetype)initWithArguments:(NSArray *)arguments {
    if (self = [super init]) {
        self.persistentIdentifier = [arguments objectAtIndex:0];
        self.title = [arguments objectAtIndex:1];
        self.invocationPhrase = [arguments objectAtIndex:2];
        self.userInfo = [arguments objectAtIndex:3];
        self.isEligibleForSearch = true;
        if ([arguments objectAtIndex:4] != nil) {
            self.isEligibleForSearch = [[arguments objectAtIndex:4] boolValue];
        }
        self.isEligibleForPrediction = true;
        if ([arguments objectAtIndex:5] != nil) {
            self.isEligibleForPrediction = [[arguments objectAtIndex:5] boolValue];
        }
    }
    return self;
}

- (bool)isValid {
    return (self.persistentIdentifier != nil) && (self.title != nil) &&
           (self.invocationPhrase != nil) && (self.userInfo != nil);
}

@end
