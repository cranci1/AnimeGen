//
//  Developer.swift
//  AnimeGen
//
//  Created by cranci on 18/04/24.
//

import SwiftUI

struct DeveloperView: View {
    @State private var apiToken: String
    @State private var discordWebhookURL: String
    @State private var discordChannelId: String
    
    init() {
        _apiToken = State(initialValue: UserDefaults.standard.string(forKey: "apiToken") ?? Secrets.apiToken)
        _discordWebhookURL = State(initialValue: UserDefaults.standard.string(forKey: "discordWebhookURL") ?? Secrets.discordWebhookURL.absoluteString)
        _discordChannelId = State(initialValue: UserDefaults.standard.string(forKey: "discordChannelId") ?? Secrets.discordChannelId)
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Hmtai Preferences")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Bot DiscordTokenHere", text: $apiToken)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                Text("On this value you need to remove 'DiscordTokenHere' and replace it with your discord bot token. Dont remove the 'Bot' prefix and also leave the space.")
                    .font(.caption)
                    .padding(.top, -10)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Discord Webhook URL", text: $discordWebhookURL)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                Text("On this value make sure to put your discord webhook with the https://")
                    .font(.caption)
                    .padding(.top, -10)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Discord Channel ID", text: $discordChannelId)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                Text("On this value you need to past your discord channel ID.")
                    .font(.caption)
                    .padding(.top, -10)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button(action: {
                saveValues()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                            .shadow(radius: 5)
                    )
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Developer Settings", displayMode: .inline)
    }
    
    private func saveValues() {
        UserDefaults.standard.set(apiToken, forKey: "apiToken")
        UserDefaults.standard.set(discordWebhookURL, forKey: "discordWebhookURL")
        UserDefaults.standard.set(discordChannelId, forKey: "discordChannelId")
        
        Secrets.apiToken = apiToken
        if let url = URL(string: discordWebhookURL) {
            Secrets.discordWebhookURL = url
        }
        Secrets.discordChannelId = discordChannelId
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}
