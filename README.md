# AnimeGen

AnimeGen is an app made in Swift. This app is developed using public APIs. The app purpose is to save, generate, and share images.

## Compatibility

AnimeGen is designed to seamlessly operate on any iOS/iPadOS device with a minimum operating system version of **_iOS 13_** or above. It also extends its compatibility to macOS, catering to both Intel-based and Silicon-based Mac systems running **_macOS 10.15_** or later.

## Compatibility

- [Download ipa](https://github.com/cranci1/AnimeGen/releases/download/v1.5/AnimeGen.ipa)
- [Download arm.deb](https://raw.githubusercontent.com/cranci1/AnimeGen/main/debs/me.cranci.animegen_1.5_iphoneos-arm.deb)
- [Download arm64.deb](https://raw.githubusercontent.com/cranci1/AnimeGen/main/debs/me.cranci.animegen_1.5_iphoneos-arm64.deb)

## APIs

<table>
<tr>
        <th>Working APIs</th>
</tr>
<tr><td>
        
| APIs                | Type     | Format    | Working                  |
| ------------------- | -----    | ----      | :--------:               |
| Pic.re              | SFW/NSFW | IMG       | :white_check_mark:       |
| Waifu.im            | SFW/NSFW | IMG       | :white_check_mark:       |
| Nekos.best          | SFW      | IMG       | :white_check_mark:       |
| Waifu.pics          | SFW/NSFW | IMG/GIF   | :white_check_mark:       |
| Hmtai               | SFW/NSFW | IMG/GIF   | :white_check_mark:       |
| Nekos api           | SFW/NSFW | IMG       | :white_check_mark:       |
| Nekos.moe           | SFW/NSFW | IMG       | :white_check_mark:       |
| Kyoko               | SFW/NSFW | IMG/GIF   | :white_check_mark:       |
| Purr                | SFW/NSFW | IMG/GIF   | :white_check_mark:       |

</table>

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

## Third Party Softwares

- [SDWebImage](https://github.com/SDWebImage/SDWebImage) (.gif images saves for the gallery)

## Help

- [NineAnimator](https://github.com/SuperMarcus/NineAnimator) (Launchscreen Idea/Base)
- [Nekidev](https://github.com/Nekidev/anime-api) (Anime-api list)
- [Jared Davidson](https://www.youtube.com/@Archetapp) (AppIcon change option)

## Build

Want to build the app yourself? No problem, by cloning this repo and running the ipadbuild.sh file, you can build your own IPA of the app! You can also modify the app as you like!

> [!IMPORTANT]
> You need to have Xcode installed!

Clone the repo:

```
git clone https://github.com/cranci1/AnimeGen
```

Navige to the directory:

```
cd AnimeGen
```

Now you need to create a new file called: Secrets.swift, in this file you need to place this code:

```swift
import Foundation

struct Secrets {
    static let apiToken = "Bot TokenHEREHEREHERE" // Replace TokenHEREHEREHERE with the token of the discord bot

    static let discordWebhookURL = URL(string: "YourWebhookUrl")!

    static let discordChannelId = "YourChannelIdHere"
}
```

Run the script:

```
./ipabuild.sh
```

If the build was successful, you should see a "build" folder with a subfolder "DerivedDataApp" and the AnimeGen.ipa file in the AnimeGen/build directory. You are now done! Just use any IPA installer like TrollStore, AlStore, Scarlet, ESign or sideloadly to install the IPA on the desired device.

## Code Structure

    |
    ├── Extensions             # Folder with the Image/UI Extensions
    ├── APIs                   # Folder containing all the APIs function
    │   └── Hmtai              # Folder containing the Hmtai function to make it fully works
    ├── Settings               # The Settings page
    │   └── Iconss             # Folder with the icons images
    ├── Buttons                # Folder with the buttons code
    └── ViewController.swift   # The main file app
