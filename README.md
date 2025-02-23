![AnimeGen Banner](Images/banner.jpeg)

<div align="center">

[![Build and Release IPA](https://github.com/cranci1/AnimeGen/actions/workflows/build%20copy.yml/badge.svg)](https://github.com/cranci1/AnimeGen/actions/workflows/build%20copy.yml)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20iPadOS%2013.0%2B-orange?logo=apple&logoColor=white)](https://img.shields.io/badge/Platform-iOS%20%7C%20iPadOS%2014.0%2B-red?logo=apple&logoColor=white)
[![Commit](https://custom-icon-badges.demolab.com/github/last-commit/cranci1/AnimeGen)](https://custom-icon-badges.demolab.com/github/last-commit/cranci1/AnimeGen) 
[![Version](https://custom-icon-badges.demolab.com/github/v/release/cranci1/AnimeGen)](https://custom-icon-badges.demolab.com/github/v/release/cranci1/AnimeGen)
[![Testflight](https://img.shields.io/badge/Join-Testflight-008080)](https://testflight.apple.com/join/Qx5saHll)

</div>

# AnimeGen
AnimeGen, an iOS/iPadOS app to **generate** and **save** anime images, using public APIs. GPLv3 Licensed.

```
Copyright © 2023-2025 cranci. All rights reserved.

AnimeGen is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AnimeGen is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AnimeGen. If not, see <https://www.gnu.org/licenses/>.
```

## Index

- [Screenshots](#screenshots)
- [Download](#download)
- [APIs](#apis)
- [Third Party Software](#third-party-software)
- [Build](#build)

## Screenshots

<div align="center">
<table>
  <tbody>
  <tr>
    <td><img src="https://raw.githubusercontent.com/cranci1/AnimeGen/main/Images/screenshots/apis.png" width=200px></td>
    <td><img src="https://raw.githubusercontent.com/cranci1/AnimeGen/main/Images/screenshots/history.png" width=200px></td>
    <td><img src="https://raw.githubusercontent.com/cranci1/AnimeGen/main/Images/screenshots/tags.png" width=200px></td>
  </tr>
  </tbody>
</table>
</div>

## Download

You can download the IPA file for installation via TrollStore, AltStore, or Sideloadly. Alternatively, you can install the app via TestFlight. Please note that the nightly-IPA may be unstable. *The Testflight beta build is recommended*.

- [Testflight beta](https://testflight.apple.com/join/Qx5saHll)
- [Download stable-IPA](https://github.com/cranci1/AnimeGen/releases/download/v2.0.0/AnimeGen.ipa)
- [Download nightly-IPA](https://nightly.link/cranci1/AnimeGen/workflows/build/main/AnimeGen-IPA.zip)

## APIs

Thanks to all the Developer that are providing this apis for public use! By cliccking the name of each API, you will be able to see the API website.
Without them this project wouldn't exist, so thanks very much to all of them!

| APIs                                                       | Type     | Format  | Status |
| ---------------------------------------------------------- | -------- | ------- | :----: |
| [pic.re](https://doc.pic.re/)                               | SFW      | IMG     |   ✅   |
| [waifu.im](https://docs.waifu.im/)                           | SFW     | IMG     |   ✅   |

## Third Party Software

- [KingFisher](https://github.com/onevcat/Kingfisher): This software is used to handle image caching and gif images rendering, licensed under the [MIT License](https://github.com/onevcat/Kingfisher/blob/master/LICENSE)

## Build

If you want to build the app yourself, follow these steps:

1. Ensure you have Xcode installed on your machine.

2. Clone the repo:

```
git clone https://github.com/cranci1/AnimeGen
```

3. Navigate to the directory:

```bash
cd AnimeGen
```

4. Run the script:

```
chmod +x ./ipabuild.sh & ./ipabuild.sh
```

If the build was successful, you should see a "build" folder with a subfolder "DerivedDataApp" and the AnimeGen.ipa file in the AnimeGen/build directory. You can now use any IPA installer like xCode, TrollStore, AlStore/SideStore, Scarlet, LiveContainer, Feather, ESign or sideloadly to install the IPA on the desired device.

> Note: If you encounter any issues during the build, please create an issue I will try my best to help!
