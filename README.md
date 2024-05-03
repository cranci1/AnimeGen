![AnimeGen Banner](Images/banner.jpeg)

<div align="center">

[![Build and Release IPA](https://github.com/cranci1/AnimeGen/actions/workflows/build.yml/badge.svg)](https://github.com/cranci1/AnimeGen/actions/workflows/build.yml) [![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20iPadOS-blue)](https://img.shields.io/badge/Platforms-iOS%20%7C%20iPadOS-blue) [![Testflight](https://img.shields.io/badge/Nightly-Testflight-008080)](https://testflight.apple.com/join/Qx5saHll)

</div>

# AnimeGen

AnimeGen is a mobile app made in Swift, developed using public APIs. The app's purpose is to save, generate, and share images.

## Compatibility

AnimeGen is designed to seamlessly operate on any iOS/iPadOS device with a minimum operating system version of **iOS 13** or above.

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

Here, you can access the IPA file for installation via TrollStore, AltStore, or Sideloadly. Alternatively, you can install the app via TestFlight

> [!Note]
> The nightly-IPA may be unstable and also does not support the Hmtai API. (also does testflight)

- [Testflight beta](https://testflight.apple.com/join/Qx5saHll)
- [Download stable-IPA](https://github.com/cranci1/AnimeGen/releases/download/v1.5/AnimeGen.ipa)
- [Download nightly-IPA](https://nightly.link/cranci1/AnimeGen/workflows/build/main/AnimeGen-IPA.zip)

## APIs

### Working APIs

| APIs                                                         | Type     | Format  | Status |
| ------------------------------------------------------------ | -------- | ------- | :----: |
| [pic.re](https://doc.pic.re/)                                | SFW/NSFW | IMG     |   ✅   |
| [waifu.im](https://docs.waifu.im/)                           | SFW/NSFW | IMG     |   ✅   |
| [nekos.best](https://docs.nekos.best/)                       | SFW      | IMG     |   ✅   |
| [waifu.pics](https://waifu.pics/docs)                        | SFW/NSFW | IMG/GIF |   ✅   |
| [Hmtai](https://hmtai.hatsunia.cfd/endpoints)                | SFW/NSFW | IMG/GIF |   ⚠️   |
| [Nekos api](https://nekosapi.com/docs)                       | SFW/NSFW | IMG     |   ✅   |
| [Nekos.moe](https://docs.nekos.moe)                          | SFW/NSFW | IMG     |   ✅   |
| [Kyoko](https://api.rei.my.id/docs/ANIME/WAIFU-Generator/)   | SFW/NSFW | IMG/GIF |   :x:  |
| [Purr Bot](https://purrbot.site/)                            | SFW/NSFW | IMG/GIF |   ✅   |
| [Waifu.it](https://waifu.it/)                                | SFW/NSFW | IMG/GIF |   ✅   |
| [NekoBot](https://nekobot.xyz/)                              | SFW/NSFW | IMG/GIF |   ✅   |

> [!Note]
> The Hmtai api is pretty slow, [why?](https://github.com/cranci1/AnimeGen/blob/main/Privacy/Hmtai.md)

## Third Party Software

- [SDWebImage](https://github.com/SDWebImage/SDWebImage) (Handles .gif images for the gallery)

## Help

- [NineAnimator](https://github.com/SuperMarcus/NineAnimator) (Launch screen idea and base)
- [Nekidev](https://github.com/Nekidev/anime-api) (Anime-api list)

## Build

Want to build the app yourself? No problem, by cloning this repo and running the `ipadbuild.sh` file, you can build your own IPA of the app! You can also modify the app as you like!

> [!IMPORTANT]
> You need to have Xcode installed!

Clone the repo:

```
git clone https://github.com/cranci1/AnimeGen
```

Navige to the directory:

```bash
cd AnimeGen
```

You need to update the Secrets.swift file with your specific values: the Discord Bot Token, a Discord webhook, and your Discord channel ID:

```swift
import Foundation

struct Secrets {
    static let apiToken = "Bot TokenHEREHEREHERE" // Replace TokenHEREHEREHERE with the token of the discord bot. DONT REMOVE "Bot"

    static let discordWebhookURL = URL(string: "YourWebhookUrl")!

    static let discordChannelId = "YourChannelIdHere"
}
```

Run the script:

```
./ipabuild.sh
```

If the build was successful, you should see a "build" folder with a subfolder "DerivedDataApp" and the AnimeGen.ipa file in the AnimeGen/build directory. You are now done! Just use any IPA installer like TrollStore, AlStore, Scarlet, ESign or sideloadly to install the IPA on the desired device.
