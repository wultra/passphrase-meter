# Passphrase Meter

[![tests](https://github.com/wultra/passphrase-meter/actions/workflows/tests.yml/badge.svg)](https://github.com/wultra/passphrase-meter/actions/workflows/tests.yml)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/wultra/passphrase-meter)
![date](https://img.shields.io/github/release-date/wultra/passphrase-meter)
![platforms](https://img.shields.io/static/v1?label=platforms&message=Android,iOS&color=blue)
[![GitHub license](https://img.shields.io/github/license/wultra/passphrase-meter)](https://github.com/wultra/passphrase-meter/blob/develop/LICENSE)

Wultra Passphrase Meter is a multi-platform library implementing offline passphrase strength validation. Choosing a weak passphrase in applications with high-security demands can be potentially dangerous, so the primary purpose of this library is to let you **warn the user** when he tries to use such passphrase in your mobile application. The validation code itself is based on a slightly modified version of [zxcvbn-c](https://github.com/tsyrogit/zxcvbn-c).

## Table of Content

- [Introduction](docs/Readme.md)
  - [UX versus security](docs/Readme.md#ux-versus-security)
  - [PIN versus password](docs/Readme.md#pin-versus-password)
- [Integration Tutorials](docs/Readme.md#integration-tutorials)
  - [iOS or macOS applications](docs/Platform-iOS.md)
  - [Android applications](docs/Platform-Android.md)
- [License](docs/Readme.md#license)
- [Attributions](docs/Readme.md#attributions)  

## Contact

If you need any assistance, do not hesitate to drop us a line at [hello@wultra.com](mailto:hello@wultra.com) or our official [wultra.com/discord](https://wultra.com/discord) channel.


### Security Disclosure

If you believe you have identified a security vulnerability with Wultra Passphrase Meter, you should report it as soon as possible via email to [support@wultra.com](mailto:support@wultra.com). Please do not post it to a public issue tracker.