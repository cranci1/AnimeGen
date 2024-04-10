![AnimeGen Banner](Images/banner.jpeg)

<div align="center">

[![Build and Release IPA](https://github.com/cranci1/AnimeGen/actions/workflows/build.yml/badge.svg)](https://github.com/cranci1/AnimeGen/actions/workflows/build.yml) [![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20iPadOS-blue)](https://img.shields.io/badge/Platforms-iOS%20%7C%20iPadOS-blue) [![Testflight](https://img.shields.io/badge/Nightly-Testflight-008080)](testflight.apple.com/join/Qx5saHll)

</div>

# AnimeGen

AnimeGen is a mobile app made in Swift, developed using public APIs. The app's purpose is to save, generate, and share images.

## Compatibility

AnimeGen is designed to seamlessly operate on any iOS/iPadOS device with a minimum operating system version of **iOS 13** or above.

## Download
Here, you can access the IPA file for installation via TrollStore, AltStore, or Sideloadly. Alternatively, if your device is jailbroken, you can opt to install the .deb file.

> [!Note]
> The nightly-IPA may be unstable and also does not support the Hmtai API.

- [Testflight beta](https://testflight.apple.com/join/Qx5saHll)
- [Download IPA](https://github.com/cranci1/AnimeGen/releases/download/v1.5/AnimeGen.ipa)
- [Download nightly-IPA](https://nightly.link/cranci1/AnimeGen/workflows/build/main/AnimeGen-IPA.zip)
- [Download rootfull .deb](https://raw.githubusercontent.com/cranci1/AnimeGen/main/debs/me.cranci.animegen_1.5_iphoneos-arm.deb)
- [Download rootless .deb](https://raw.githubusercontent.com/cranci1/AnimeGen/main/debs/me.cranci.animegen_1.5_iphoneos-arm64.deb)

## APIs

### Working APIs

| APIs                | Type     | Format    | Working                  |
| ------------------- | -----    | ----      | :--------:               |
| Pic.re              | SFW/NSFW | IMG       | ✅                        |
| Waifu.im            | SFW/NSFW | IMG       | ✅                        |
| Nekos.best          | SFW      | IMG       | ✅                        |
| Waifu.pics          | SFW/NSFW | IMG/GIF   | ✅                        |
| Hmtai               | SFW/NSFW | IMG/GIF   | ✅                        |
| Nekos api           | SFW/NSFW | IMG       | ✅                        |
| Nekos.moe           | SFW/NSFW | IMG       | ✅                        |
| Kyoko               | SFW/NSFW | IMG/GIF   | ✅                        |
| Purr                | SFW/NSFW | IMG/GIF   | ✅                        |

> [!Note]
> Kyoko and the waifu.pics API likely share a common image database.

## APIs Credits

- [pic.re api](https://doc.pic.re/)
- [waifu.im api](https://docs.waifu.im/)
- [nekos.best api](https://docs.nekos.best/)
- [waifu.pics api](https://waifu.pics/docs)
- [Hmtai api](https://hmtai.hatsunia.cfd/endpoints)
- [Nekos api](https://nekosapi.com/docs)
- [Nekos.moe](https://docs.nekos.moe)
- [Kyoko](https://api.rei.my.id/docs/ANIME/WAIFU-Generator/)
- [Purr](https://purrbot.site/)

## Third Party Software

- [SDWebImage](https://github.com/SDWebImage/SDWebImage) (Handles .gif images for the gallery)

## Help

- [NineAnimator](https://github.com/SuperMarcus/NineAnimator) (Launch screen idea and base)
- [Nekidev](https://github.com/Nekidev/anime-api) (Anime-api list)
- [Jared Davidson](https://www.youtube.com/@Archetapp) (AppIcon change option)

## Build

Want to build the app yourself? No problem, by cloning this repo and running the `ipadbuild.sh` file, you can build your own IPA of the app! You can also modify the app as you like!

> [!IMPORTANT]
> You need to have Xcode installed!

Clone the repo:

```bash
git clone https://github.com/cranci1/AnimeGen
```

Navige to the directory:

```
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
