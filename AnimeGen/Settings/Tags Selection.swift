//
//  Tags Selection.swift
//  AnimeGen
//
//  Created by cranci on 17/06/24.
//

import UIKit

class TagSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [String] = []
    var selectedTags: [String] = []
    
    var selectedAPI: String = "waifu.pics"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Tags"
        
        configureCategoriesAndTags()
    }
    
    func configureCategoriesAndTags() {
        if selectedAPI == "waifu.pics" {
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["waifu", "neko", "trap", "blowjob"]
            } else {
                categories = ["waifu", "neko", "shinobu", "cuddle", "hug", "kiss", "lick", "pat", "bonk", "blush", "smile", "nom", "bite", "glomp", "slap", "kick", "happy", "poke", "dance"]
            }
        } else if selectedAPI == "nekos.best" {
            categories = ["neko", "waifu", "kitsune"]
        } else if selectedAPI == "nekosBot" {
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["hentai", "hkitsune", "hanal", "hthigh", "hboobs", "yaoi"]
            } else {
                categories = ["neko", "coffee", "food", "kemonomimi"]
            }
        } else if selectedAPI == "n-sfw.com" {
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["anal","ass", "blowjob", "breeding", "buttplug", "cages", "ecchi", "feet", "fo", "furry", "gif", "hentai", "legs", "masturbation", "milf", "muscle", "neko", "paizuri", "petgirls", "pierced", "selfie", "smothering", "socks", "trap", "vagina", "yaoi", "yuri"]
            } else {
                categories = ["bunny-girl", "charlotte", "date-a-live", "death-note", "demon-slayer", "haikyu", "hxh", "kakegurui", "konosuba", "komi", "memes", "naruto", "noragami", "one-piece", "rag", "sakurasou", "sao", "sds", "spy-x-family", "takagi-san", "toradora", "your-name"]
            }
        } else if selectedAPI == "Purr" {
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["anal/gif", "blowjob/gif", "cum/gif", "fuck/gif", "neko/gif", "pussylick/gif", "solo/gif", "solo_male/gif", "threesome_fff/gif", "threesome_ffm/gif", "threesome_mmf/gif", "yuri/gif", "neko/img"]
            } else {
                categories = ["angry/gif", "bite/gif", "blush/gif", "comfy/gif", "cry/gif", "cuddle/gif", "dance/gif", "eevee/gif", "fluff/gif", "holo/gif", "hug/gif", "kiss/gif", "lay/gif", "lick/gif", "neko/gif", "pat/gif", "poke/gif", "pout/gif", "slap/gif", "smile/gif", "tail/gif", "tickle/gif", "background/img", "eevee/img", "holo/img", "icon/img", "kitsune/img", "neko/img", "okami/img", "senko/img", "shiro/img"]
            }
        } else if selectedAPI == "nekos.life" {
            categories = ["tickle", "slap", "pat", "neko", "kiss", "hug", "fox_girl", "feed", "cuddle", "ngif", "smug", "wallpaper", "gecg", "avatar", "waifu"]
        } else if selectedAPI == "waifu.it" {
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["angry", "baka", "bite", "blush", "bonk", "bored", "bully", "bye", "chase", "cheer", "cringe", "cry", "dab", "dance", "die", "disgust", "facepalm", "feed", "glomp", "happy", "hi", "highfive", "hold", "hug", "kick", "kill", "kiss", "laugh", "lick", "love", "lurk", "midfing", "nervous", "nom", "nope", "nuzzle", "panic", "pat", "peck", "poke", "pout", "punch", "run", "sad", "shoot", "shrug", "sip", "slap", "sleepy", "smile", "smug", "stab", "stare", "suicide", "tease", "think", "thumbsup", "tickle", "triggered", "wag", "wave", "wink", "yes"]
            } else {
                categories = ["angry", "baka", "bite", "blush", "bonk", "bored", "bye", "chase", "cheer", "cringe", "cry", "cuddle", "dab", "dance", "disgust", "facepalm", "feed", "glomp", "happy", "hi", "highfive", "hold", "hug", "kick", "kiss", "laugh", "lurk", "nervous", "nom", "nope", "nuzzle", "panic", "pat", "peck", "poke", "pout", "run", "sad", "shrug", "sip", "slap", "sleepy", "smile", "smug", "stare", "tease", "think", "thumbsup", "tickle", "wag", "wave", "wink", "yes"]
            }
        } else if selectedAPI == "Kyoko" {
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["waifu", "neko", "trap", "blowjob"]
            } else {
                categories = ["waifu", "neko", "shinobu", "megumin", "bully", "cuddle", "cry", "hug", "awoo", "kiss", "lick", "pat", "smug", "bonk", "blush", "smile", "nom", "bite", "glomp", "slap", "kick", "happy", "poke", "dance"]
            }
        } else if selectedAPI == "Hmtai" {
            if UserDefaults.standard.bool(forKey: "explicitContents") {
                categories = ["ass", "anal", "bdsm", "classic", "cum", "creampie", "manga", "femdom", "hentai", "incest", "masturbation", "public", "ero", "orgy", "elves", "yuri", "pantsu", "pussy", "glasses", "cuckold", "blowjob", "boobjob", "handjob", "footjob", "boobs", "thighs", "ahegao", "uniform", "gangbang", "tentacles", "gif", "nsfwNeko", "nsfwMobileWallpaper", "zettaiRyouiki"]
            } else {
                categories = ["wave", "wink", "tea", "bonk", "punch", "poke", "bully", "pat", "kiss", "kick", "blush", "feed", "smug", "hug", "cuddle", "cry", "cringe", "slap", "five", "glomp", "happy", "hold", "nom", "smile", "throw", "lick", "bite", "dance", "boop", "sleep", "like", "kill", "tickle", "nosebleed", "threaten", "depression", "wolf_arts", "jahy_arts", "neko_arts", "coffee_arts", "wallpaper", "mobileWallpaper"]
            }
        }
        
        
        let userDefaultsKey = "SelectedTags\(selectedAPI.capitalized)"
        print ("SelectedTags\(selectedAPI.capitalized)")
        if let savedTags = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            selectedTags = savedTags
        }
    }
}

extension TagSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        
        if selectedTags.contains(categories[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTag = categories[indexPath.row]
        
        if let index = selectedTags.firstIndex(of: selectedTag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(selectedTag)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        saveSelectedTags()
    }
    
    func saveSelectedTags() {
        let userDefaultsKey = "SelectedTags\(selectedAPI.capitalized)"
        UserDefaults.standard.set(selectedTags, forKey: userDefaultsKey)
    }
}
