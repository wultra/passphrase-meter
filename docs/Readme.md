# Passphrase Meter

Wultra Passphrase Meter is a multi-platform library implementing offline passphrase strength validation. The validation code itself is based on a slightly modified version of [zxcvbn-c](https://github.com/tsyrogit/zxcvbn-c).

## Introduction

Choosing a weak passphrase in applications with high-security demands can be potentially dangerous. The primary purpose of this library is to **warn the user** when he tries to use such passphrase in your mobile application. We believe that security in the mobile world should always be in balance with good UX.

### UX versus security

Imagine, that in your, otherwise very nice and polished application, you'll force users to type the password, which is at least 12 characters long, must contain at least one uppercase character, one digit, and two special symbols for each authentication or authorization attempt. If yes, then cool, you can be pretty sure that your users use strong passwords, but everybody hates that. So, you can expect bad ratings at the official stores or people does not use your application at all.

Before you use this library, you should consider our recommendations and tips:

1. Your application's security should not depend on this library only. For example, if you're storing passwords in plaintext on the device, then a proper password strength validation doesn't solve your security flaws. 

1. You should always consider what kind of attacks are feasible against your application. For example:
   - If passphrase protects user's data stored locally on the device, then you should enforce a strong password, as possible. The reason for that is that if an attacker has the mobile device in the possession, then he can perform an off-line brute force attack against the data.
   - On opposite to that, if password or PIN is used to authenticate against an online service, with a limited number of failed attempts, then you can lower your requirements for a password.

1. Your application should allow the user to set a weak password if he insists on it. It's a good UX practice unless you protect locally stored data.

1. Let the user decide the password complexity he wants to use.  

### PIN versus password

Wultra Passphrase Meter provides two different algorithms for validating passwords and PINs:

- The password validation is based on [zxcvbn-c](https://github.com/tsyrogit/zxcvbn-c) library. 
  - You can use our library as a simple, easy to use "zxcvbn" implementation for iOS or Android projects.
  - You can also validate PINs with this routine, but that more likely will always lead to treating such passwords as weak.
  
- PIN validation implementation is highly inspired by findings from [PIN analysis](http://www.datagenetics.com/blog/september32012/) blog post. 
  - We designed this validation to achieve our own purposes, and we use it for applications that are already using our [PowerAuth stack](https://github.com/wultra/powerauth-crypto).
  - The validation routine returns a list of findings which may have a different meaning for a PIN with different length. For example, if you're pretty sure that 4-digits long PINs are OK for your purposes, then you can ignore several findings. We discuss this in detail in the per-platform integration tutorials.


## Integration Tutorials

The library currently supports following platforms:

- [iOS or macOS applications](./Platform-iOS.md)
- [Android applications](./Platform-Android.md)


## License

The library is licensed using Apache 2.0 license with a small portion of code licensed under MIT. In detail:

- Apache 2.0 licensed files:
  - All wrapper code sources written in Swift, Java.
  - All C sources written by Wultra developers.
  - All future source codes will be licensed under Apache 2.0.
  
- MIT licensed files:
  - [Source/src_native/zxcvbn.h](../Source/src_native/zxcvbn.h)
  - [Source/src_native/zxcvbn.c](../Source/src_native/zxcvbn.c)
  - [dict_generator/src/dict-generate.cpp](../dict_generator/src/dict-generate.cpp) 

You can use them with no restriction. If you are using this library, please let us know. We will be happy to share and promote your project.


### Attributions

- C implementation of password strength evaluation is based on slightly modified version of [zxcvbn-c](https://github.com/tsyrogit/zxcvbn-c).
- Implementation of passcode evaluation is inspired by [this DataGenetics post](http://www.datagenetics.com/blog/september32012/).


## Contact

If you need any assistance, do not hesitate to drop us a line at [hello@wultra.com](mailto:hello@wultra.com) or our official [gitter.im/wultra](https://gitter.im/wultra) channel.


### Security Disclosure

If you believe you have identified a security vulnerability with Wultra Passphrase Meter, you should report it as soon as possible via email to [support@wultra.com](mailto:support@wultra.com). Please do not post it to a public issue tracker.