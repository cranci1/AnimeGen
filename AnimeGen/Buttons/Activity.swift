//
//  Activity.swift
//  AnimeGen
//
//  Created by cranci on 30/03/24.
//

import UIKit

extension ViewController {
    
    @objc func updateTimeLabel() {
        guard let startTime = startTime else { return }
        
        let currentTime = Date()
        let timeInterval = Int(currentTime.timeIntervalSince(startTime))
        
        let seconds = timeInterval % 60
        let minutes = (timeInterval / 60) % 60
        let hours = (timeInterval / 3600) % 24
        let days = timeInterval / 86400
        
        var timeText = ""
        
        let clockIconAttachment = NSTextAttachment()
        clockIconAttachment.image = UIImage(systemName: "clock")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let clockIconString = NSAttributedString(attachment: clockIconAttachment)
        
        if days > 0 {
            timeText += "\(days)d "
        }
        
        if hours > 0 || days > 0 {
            timeText += "\(hours)h "
        }
        
        if minutes > 0 || hours > 0 || days > 0 {
            timeText += "\(minutes)m "
        }
        
        timeText += "\(seconds)s"
        
        let imageIconAttachment = NSTextAttachment()
        imageIconAttachment.image = UIImage(systemName: "photo.on.rectangle")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let imageIconString = NSAttributedString(attachment: imageIconAttachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(clockIconString)
        mutableAttributedString.append(NSAttributedString(string: " \(timeText) - "))
        mutableAttributedString.append(imageIconString)
        mutableAttributedString.append(NSAttributedString(string: " \(counter)"))
        
        timeLabel.attributedText = mutableAttributedString
    }
    
    func incrementCounter() {
        counter += 1
        updateTimeLabel()
    }

}
