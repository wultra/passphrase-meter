# Wultra Passphrase Meter

Choosing weak passphrase in security apps (like mobile banking) can be potentially dangerous. In mobile apps, it is **good UX** to warn the user, when he chooses such passphrase.

## Use Case and UX

The main idea of this library is to **warn the user** when he tries to use a weak passphrase in your mobile application. This warning should be seen as a tool against phishing attacks, not a protection against brute-force attacks.  

**Your passphrase security should never depend only on this check.** You can for example invalidate users data after several failed attempts.  

Any limitation to the users passphrase choice should be seen as bad UX. For example: you shouldn't forbid the user to pick a weak PIN, but just inform him about the potential consequences.

## Supported Platforms
- **Android**
- **iOS**
- **macOS**
  
_Whole logic is written in C so it is possible to use it almost everywhere (pull request for wrappers for other platforms are welcomed 😉)_.

## PIN _(passcode)_ testing

You can evaluate any PIN. The result of the testing is a collection of issues that were found in this pin. This issues can be:

- **Not Unique** _(Passcode doesn't have enough unique digits)_
- **Repeating Digits** _(There is a significant amount of repeating digits in the passcode)_
- **Has Pattern** _(Repeating pattern was found in the passcode - 1357 for example)_
- **Possibly Date** _(This passcode can be a date (and possibly birthday of the user))_
- **Frequently Used** _(Passcode is in most used passcodes)_
- **Wrong Input** _(Wrong input - passcode must be digits only)_

> **NOTE:** You should implement your own logic (based on the sensitivity of the data you're protecting with this passcode and other security measures) on top of this evaluation to decide when is a good time to warn the user. Sample logic could be:

--
> Custom alert logic in `swift`: 

```swift
let passcode = "1456"
let result = PasswordTester.shared.testPin(passcode)
            
// We want different classification for different pin length
// to not eliminate too much pins (too keep good pins around 95%)
    
if passcode.count <= 4 {
    if result.contains(.frequentlyUsed) || result.contains(.notUnique) {
        // warn the user
    }
} else if passcode.count <= 6 {
    if result.contains(.frequentlyUsed) || result.contains(.notUnique) || result.contains(.repeatingCharacters) {
        // warn the user
    } 
} else {
    if result.contains(.frequentlyUsed) || result.contains(.notUnique) || result.contains(.repeatingCharacters) || result.contains(.patternFound) {
        // warn the user
    }
}

```

## Password testing

You can evaluate any password. The result of such operation is a strength of the password. Strength levels are:

- **Very Weak**
- **Weak**
- **Moderate**
- **Good**
- **Strong**

Password testing takes several things into account (keyboard patterns, alphabetical order, repetition etc...). You can also add a dictionary of words to get rid of passwords that looks strong to algorithms, but are common spoken words.

Available dictionaries

- english
- czech and slovak (as one dictionary)

## Android integration (via Maven Central)

##### 1. Add dependencies to your `build.gradle`
```kotlin
implementation "com.wultra.android.passphrasemeter:passphrasemeter-core:1.0.0"
```

##### 2. _(OPTIONAL)_ You can add dictionaries for more precise password testing

```kotlin
implementation "com.wultra.android.passphrasemeter:passphrasemeter-dictionary-en:1.0.0"
implementation "com.wultra.android.passphrasemeter:passphrasemeter-dictionary-czsk:1.0.0"
```

##### 3. import passphrasemeter in your code
```kotlin
import com.wultra.android.passphrasemeter.*;
```
##### 4. Test that things work _(kotlin)_
``` kotlin
PasswordTester.getInstance().loadDictionary(assets, "en.dct") // if english dependency added
val result = PasswordTester.getInstance().testPassword("test")
```

## iOS integration (via Cocoapods)

##### 1. Add following pod to your `Podfile`.

```ruby
pod 'WultraPassphraseMeter'
```

##### 2. _(OPTIONAL)_ You can add dictionaries for more precise password testing
```ruby
pod 'WultraPassphraseMeter/Dictionary_en'
pod 'WultraPassphraseMeter/Dictionary_czsk'
```
##### 3. Run `pod install`

##### 4. import WultraPassphraseMeter module in your code
```swift
import WultraPassphraseMeter
```
##### 5. Test that things work _(swift)_
```swift
PasswordTester.shared.loadDictionary(.en) // if en dictionary dependency was added
let strength = PasswordTester.shared.testPassword("test")
print(strength)
```

## Examples

You can check iOS and Android example integration projects in [Source/examples](Source/examples) folder.

## Contact

If you need any assistance, do not hesitate to drop us a line at hello@wultra.com or create an issue here on GitHub.

## Attributions

C implementation of password strength evaluation is based on slightly modified version of [zxcvbn-c](https://github.com/tsyrogit/zxcvbn-c).

Implementation of passcode evaluation is inspired by [this DataGenetics post](http://www.datagenetics.com/blog/september32012/).