//
//  APIsCredits.swift
//  AnimeGen
//
//  Created by cranci on 06/05/24.
//

import UIKit

class APIsCredits: UITableViewController {
        
    // URLs
    let picre = "https://pic.re"
    let waifuim = "https://waifu.im"
    let waifupics = "https://waifu.pics"
    let waifuit = "https://waifu.it/"
    let nekosbest = "https://nekos.best"
    let nekosapi = "https://nekosapi.com"
    let nekosmoe = "https://nekos.moe"
    let NekoBot = "https://nekobot.xyz"
    let Hmtai = "https://hmtai.hatsunia.cfd/endpoints"
    let kyoko = "https://api.rei.my.id/docs/ANIME/WAIFU-Generator/"
    let purrbot = "https://purrbot.site/"
    let nsfw = "https://n-sfw.com/"
    let nekoslife = "https://nekos.life"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func picre(_ sender: UITapGestureRecognizer) {
        openURL(picre)
    }
    
    @IBAction func waifuim(_ sender: UITapGestureRecognizer) {
        openURL(waifuim)
    }
    
    @IBAction func waifupics(_ sender: UITapGestureRecognizer) {
        openURL(waifupics)
    }
    
    @IBAction func waifuit(_ sender: UITapGestureRecognizer) {
        openURL(waifuit)
    }
    
    @IBAction func nekosbest(_ sender: UITapGestureRecognizer) {
        openURL(nekosbest)
    }
    
    @IBAction func nekosapi(_ sender: UITapGestureRecognizer) {
        openURL(nekosapi)
    }
    
    @IBAction func nekosmoe(_ sender: UITapGestureRecognizer) {
        openURL(nekosmoe)
    }
    
    @IBAction func nekobot(_ sender: UITapGestureRecognizer) {
        openURL(NekoBot)
    }
    
    @IBAction func Hmtai(_ sender: UITapGestureRecognizer) {
        openURL(Hmtai)
    }
    
    @IBAction func kyoko(_ sender: UITapGestureRecognizer) {
        openURL(kyoko)
    }
    
    @IBAction func purrbot(_ sender: UITapGestureRecognizer) {
        openURL(purrbot)
    }
    
    @IBAction func nsfwa(_ sender: UITapGestureRecognizer) {
        openURL(nsfw)
    }
    
    @IBAction func nekoslife(_ sender: UITapGestureRecognizer) {
        openURL(nekoslife)
    }
}

