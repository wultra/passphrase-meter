# Wultra Passphrase Strength Meter

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

To be added

## iOS integration (via Cocoapods)

##### 1. Add following pod to your `Podfile`.

```
pod 'WultraPassMeter'
```

##### 2. You can add dictionaries for more precise password testing
```
pod 'WultraPassMeter/Dictionary_en'
pod 'WultraPassMeter/Dictionary_czsk'
```

##### 3. import WultraPassMeter module in your code
```
import WultraPassMeter
```
##### 4. Test that things work
```
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