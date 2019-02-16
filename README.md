# Cordova Plugin Siri Shortcuts (Pure Objective-C)

by Julian Sanio

## Description
This plugin adds support for Siri Shortcuts to Cordova apps on iOS platform and is written in pure Objective-C. The project is inspired by the [cordova-plugin-siri-shortcuts](https://github.com/bartwesselink/cordova-plugin-siri-shortcuts) by bartwesselink and implements a similar api. Additional suggestions by [levieu's fork](https://github.com/levieu/cordova-plugin-siri-shortcuts) were implemented as well.

## Installation

```
$ cordova plugin add https://github.com/JulianSanio/cordova-plugin-siri-shortcuts.git
```
This plugin requires XCode 10+, iOS 12+ and Cordova 6.0+ to work properly. However, there is no restriction for installing the plugin to projects targetting lower iOS versions. The code includes annotations on the relevant methods, so it will compile and will run, but calling plugin methods will result in error callbacks.

This plugin creates the object `cordova.plugins.SiriShortcuts` and is usable after the deviceready event has been fired.

## API Documentation

### Overview

| Operation | Description |
| --- | --- |
| [donate(options, success, error)](#user-content-donateoptions-success-error) | Donate shortcut associated with this app to Siri. |
| [present(options, success, error)](#user-content-presentoptions-success-error) | Present view controller that will take the user through the setup flow to add a shortcut to Siri. If the shortcut already exists, a view controller to update or to delete is  presented. |
| [remove(persistentIdentifiers, success, error)](#user-content-removepersistentidentifiers-success-error) | Remove shortcuts from this app based on identifiers. |
| [removeAll(success, error)](#user-content-removeallsuccess-error) | Remove all shortcuts from this app. |
| [getActivatedShortcut(success, error)](#user-content-getactivatedshortcutoptions-success-error) | Get the shortcut associated with this app that has been activated by Siri. |
| [getAllShortcuts(success, error)](#user-content-getallshortcutssuccess-error) | Get all of the shortcuts associated with this app that have been added to Siri. |

### Response Codes

| Code | Type | Description |
| --- | --- | --- |
| 0 | Success | Siri shortcut was donated. |
| 1 | Success | Siri shortcut was added. |
| 2 | Success | Siri shortcut was updated. |
| 3 | Success | Siri shortcut was deleted. |
| 4 | Success | Activated Siri shortcut was fetched. |
| 5 | Success | All Siri shortcuts were fetched. |
| 6 | Error | Siri shortcut activity was canceled. |
| 7 | Error | Invalid arguments. |
| 8 | Error | Siri shortcuts is not available, user might not run iOS 12+. |
| 9 | Error | An Internal error occurred. |
| 10 | Error | No Siri shortcut was activated. |

### Methods

#### donate(options, success, error)
Donate shortcut associated with this app to Siri.

| Param | Type | Description |
| --- | --- | --- |
| options | `object` | Siri shortcut options. |
| options.persistentIdentifier | `string` | A unique value used to identify the user activity. It is also used to update or remove the shortcut. |
| options.title | `string` | An user-visible title for this activity, such as a document name or web page title. It is displayed to the user as the name of the shortcut. |
| options.invocationPhrase | `string` | The phrase the user speaks to invoke the shortcut. The user can change the phrase during setup of a shortcut. |
| options.userInfo | `object` | A key-value object that contains information about the shortcut, this will be returned in the getActivatedShortcut method. |
| options.isEligibleForSearch | `boolean` | Optional. A Boolean value that indicates whether the activity should be added to the on-device index to make it searchable via Siri. Default value is true. |
| options.isEligibleForPrediction | `boolean` | Optional. A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. Default value is true. |
| success | `function` | Function called on successful donation. It returns a key-value object with the following structure: `{ code: int; message: string; }`<br>Possible codes: 0 |
| error | `function` | Function called on unsuccessful donation. It returns a key-value object with the following structure: `{ code: int; message: string; }`<br>Possible codes: 7, 8 |

Example query:

```javascript
let options = {
    persistentIdentifier: 'my-identifier',
    title: "My title",
    invocationPhrase: "My phrase",
    userInfo: {
        key1: "value1"
    },
    isEligibleForSearch: true,
    isEligibleForPrediction: true
};

cordova.plugins.SiriShortcuts.donate(options);
```

Example response on success:

```javascript
{
    code = 0;
    message = "Siri shortcut was donated.";
}
```

Example response on error:

```javascript
{
    code = 8;
    message = "Siri shortcuts is not available, user might not run iOS 12+.";
}
```

#### present(options, success, error)
Present view controller that will take the user through the setup flow to add a shortcut to Siri. If the shortcut already exists, a view controller to update or to delete is  presented.

| Param | Type | Description |
| --- | --- | --- |
| options | `object` | Siri shortcut options. |
| options.persistentIdentifier | `string` | A unique value used to identify the user activity. It is also used to update or remove the shortcut. |
| options.title | `string` | An user-visible title for this activity, such as a document name or web page title. It is displayed to the user as the name of the shortcut. |
| options.invocationPhrase | `string` | The phrase the user speaks to invoke the shortcut. The user can change the phrase during setup of a shortcut. |
| options.userInfo | `object` | A key-value object that contains information about the shortcut, this will be returned in the getActivatedShortcut method. |
| options.isEligibleForSearch | `boolean` | Optional. A Boolean value that indicates whether the activity should be added to the on-device index to make it searchable via Siri. Default value is true. |
| options.isEligibleForPrediction | `boolean` | Optional. A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. Default value is true. |
| success | `function` | Function called on successful presentation. It returns a key-value object with the following structure: `{ code: int; data: object; message: string; }` Possible codes: 1, 2, 3 |
| error | `function` | Function called on unsuccessful presentation. It returns a key-value object with the following structure: `{ code: int; message: string; }`<br>Possible codes: 6, 7, 8, 9 |

Example query:

```javascript
let options = {
    persistentIdentifier: 'my-identifier',
    title: "My title",
    invocationPhrase: "My phrase",
    userInfo: {
        key1: "value1"
    },
    isEligibleForSearch: true,
    isEligibleForPrediction: true
};

cordova.plugins.SiriShortcuts.present(options);
```

Example response on success:

```javascript
{
    code = 1;
    data = {
        invocationPhrase = "My phrase";
        persistentIdentifier = "my-identifier";
        title = "My title";
        userInfo = {
            key1 = "value1";
        };
    };
    message = "Siri shortcut was added.";
}
```

Example response on error:

```javascript
{
    code = 6;
    message = "Siri shortcut activity was canceled.";
}
```

#### remove(persistentIdentifiers, success, error)
Remove shortcuts from this app based on identifiers.

| Param | Type | Description |
| --- | --- | --- |
| persistentIdentifiers | `string` \| `Array<string>` | Persistent identifier(s) of the shortcut(s) to be deleted. |
| success | `function` | Function called on successful removal. It returns a key-value object with the following structure: `{ code: int; message: string; }` Possible codes: 3 |
| error | `function` | Function called on unsuccessful removal. It returns a key-value object with the following structure: `{ code: int; message: string; }`<br>Possible codes: 7, 8 |

Example query:

```javascript
cordova.plugins.SiriShortcuts.remove("my-identifier");
```

Example response on success:

```javascript
{
    code = 3;
    message = "Siri shortcut was deleted.";
}
```

Example response on error:

```javascript
{
    code = 7;
    message = "Invalid arguments.";
}
```

#### removeAll(success, error)
Remove all shortcuts from this app.

| Param | Type | Description |
| --- | --- | --- |
| success | `function` | Function called on successful removal. It returns a key-value object with the following structure: `{ code: int; message: string; }` Possible codes: 3 |
| error | `function` | Function called on unsuccessful removal. It returns a key-value object with the following structure: `{ code: int; message: string; }`<br>Possible codes: 8 |

Example query:

```javascript
cordova.plugins.SiriShortcuts.removeAll();
```

Example response on success:

```javascript
{
    code = 3;
    message = "Siri shortcut was deleted.";
}
```

Example response on error:

```javascript
{
    code = 8;
    message = "Siri shortcuts is not available, user might not run iOS 12+.";
}
```

#### getActivatedShortcut(options, success, error)
Get the shortcut associated with this app that has been activated by Siri.

| Param | Type | Description |
| --- | --- | --- |
| options | `object` | Options to fetch activated shortcut. |
| options.clear | `boolean` | Clear the currently activated shortcut. Default value is true. |
| success | `function` | Function called on successful fetch. It returns a key-value object with the following structure: `{ code: int; message: string; }` Possible codes: 4 |
| error | `function` | Function called on unsuccessful fetch. It returns a key-value object with the following structure: `{ code: int; message: string; }`<br>Possible codes: 8, 10 |

Example query:

```javascript
cordova.plugins.SiriShortcuts.getActivatedShortcut({ clear: true });
```

Example response on success:

```javascript
{
    code = 4;
    data =     {
        invocationPhrase = "My phrase";
        persistentIdentifier = "my-identifier";
        title = "My title";
        userInfo = {
            key1 = "value1";
        };
    };
    message = "Activated Siri shortcut was fetched.";
}
```

Example response on error:

```javascript
{
    code = 10;
    message = "No Siri shortcut was activated.";
}
```

#### getAllShortcuts(success, error)
Get all of the shortcuts associated with this app that have been added to Siri.

| Param | Type | Description |
| --- | --- | --- |
| success | `function` | Function called on successful fetch. Data returns an array shortcuts with the following structure: `[{ persistentIdentifier: string; invocationPhrase: string; title: string; userInfo: object; }]` |
| error | `function` | Function called on unsuccessful fetch. It returns a key-value object with the following structure: `{ code: int; message: string; }`<br>Possible codes: 8, 9 |

Example query:

```javascript
cordova.plugins.SiriShortcuts.getAllShortcuts();
```

Example response on success:

```javascript
[{
    invocationPhrase = "My phrase";
    persistentIdentifier = "my-identifier";
    title = "My title";
    userInfo = {
        key1 = "value1";
    };
},
    {
    invocationPhrase = "My phrase 2";
    persistentIdentifier = "my-identifier-2";
    title = "My title 2";
    userInfo = {
        key2 = "value2";
    };
}]
```

Example response on error:

```javascript
{
    code = 9;
    message = "An Internal error occurred.";
}
```

## License

ISC License (ISC)
Copyright 2019 Julian Sanio

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
