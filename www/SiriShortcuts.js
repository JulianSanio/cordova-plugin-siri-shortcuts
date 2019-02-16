//
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

var exec = require('cordova/exec');

/**
 * Donate shortcut associated with this app to Siri.
 * @param {object} options Siri shortcut options.
 * @param {string} options.persistentIdentifier A unique value used to identify the user activity. It is also used to update or remove the shortcut.
 * @param {string} options.title An user-visible title for this activity, such as a document name or web page title. It is displayed to the user as the name of the shortcut.
 * @param {string} options.invocationPhrase The phrase the user speaks to invoke the shortcut. The user can change the phrase during setup of a shortcut.
 * @param {object} options.userInfo A key-value object that contains information about the shortcut, this will be returned in the getActivatedShortcut method.
 * @param {boolean} options.isEligibleForSearch A Boolean value that indicates whether the activity should be added to the on-device index to make it searchable via Siri. Default value is true.
 * @param {boolean} options.isEligibleForPrediction A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. Default value is true.
 * @param {function(data): void} success Function called on successful donation.
 * @param {function(error): void} error Function called on unsuccessful donation.
 * @return Promise
 */
exports.donate = function (options, success, error) {
    return new Promise(function(resolve, reject) {
        exec(success, error, "SiriShortcuts", "donate", [options.persistentIdentifier, options.title, options.invocationPhrase, options.userInfo, options.isEligibleForSearch, options.isEligibleForPrediction]);
    });
};

/**
 * Present view controller that will take the user through the setup flow to add a shortcut to Siri. If the shortcut already exists, a view controller to update or to delete is  presented.
 * @param {object} options Siri shortcut options.
 * @param {string} options.persistentIdentifier A unique value used to identify the user activity. It is also used to update or remove the shortcut.
 * @param {string} options.title An user-visible title for this activity, such as a document name or web page title. It is displayed to the user as the name of the shortcut.
 * @param {string} options.invocationPhrase The phrase the user speaks to invoke the shortcut. The user can change the phrase during setup of a shortcut.
 * @param {object} options.userInfo A key-value object that contains information about the shortcut, this will be returned in the getActivatedShortcut method.
 * @param {boolean} options.isEligibleForSearch A Boolean value that indicates whether the activity should be added to the on-device index to make it searchable via Siri. Default value is true.
 * @param {boolean} options.isEligibleForPrediction A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. Default value is true.
 * @param {function(data): void} success Function called on successful presentation.
 * @param {function(error): void} error Function called on unsuccessful presentation.
 * @return Promise
 */
exports.present = function (options, success, error) {
    return new Promise(function(resolve, reject) {
        exec(success, error, "SiriShortcuts", "present", [options.persistentIdentifier, options.title, options.invocationPhrase, options.userInfo, options.isEligibleForSearch, options.isEligibleForPrediction]);
    });
};

/**
 * Remove shortcuts from this app based on identifiers.
 * @param {string|string[]} persistentIdentifiers Persistent identifier(s) of the shortcut(s) to be deleted.
 * @param {function(data): void} success Function called on successful removal.
 * @param {function(error): void} error Function called on unsuccessful removal.
 * @return Promise
 */
exports.remove = function (persistentIdentifiers, success, error) {
    if (typeof persistentIdentifiers === "string") {
        persistentIdentifiers = [persistentIdentifiers];
    }
    return new Promise(function(resolve, reject) {
        exec(success, error, "SiriShortcuts", "remove", [persistentIdentifiers]);
    });
};

/**
 * Remove all shortcuts from this app.
 * @param {function(data): void} success Function called on successful removal.
 * @param {function(error): void} error Function called on unsuccessful removal.
 * @return Promise
 */
exports.removeAll = function(success, error) {
    return new Promise(function(resolve, reject) {
        exec(success, error, "SiriShortcuts", "removeAll");
    });
};

/**
 * Get the shortcut associated with this app that has been activated by Siri.
 * @param {object} options Options to fetch activated shortcut.
 * @param {string} options.clear Clear the currently activated shortcut. Default value is true.
 * @param {function(data): void} success Function called on succesful fetch.
 * @param {function(error): void} error Function called on unsuccessful fetch.
 * @return Promise
 */
exports.getActivatedShortcut = function(options, success, error) {
    if (typeof options === typeof undefined || typeof options === typeof {}) {
        options = {};
    }
    if (typeof options.clear === typeof undefined) {
        options.clear = true;
    }
    return new Promise(function(resolve, reject) {
        exec(success, error, "SiriShortcuts", "getActivatedShortcut", [options.clear]);
    });
};

/**
 * Get all of the shortcuts associated with this app that have been added to Siri.
 * @param {function(data): void} success Function called on successful fetch.
 * @param {function(error): void} error Function called on unsuccessful fetch. 
 * @return Promise
 */
exports.getAllShortcuts = function(success, error) {
    return new Promise(function(resolve, reject) {
        exec(success, error, "SiriShortcuts", "getAllShortcuts");
    });
};
