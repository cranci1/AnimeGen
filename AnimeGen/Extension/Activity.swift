//
//  Activity.swift
//  AnimeGen
//
//  Created by cranci on 05/05/24.
//

import UIKit

extension ViewController {
    
    @objc func updateTimeLabel() {
        guard let startTime = startTime else { return }
        
        let currentTime = Date()
        let timeInterval = Int(currentTime.timeIntervalSince(startTime))
        
        let timeText = formatTimeInterval(timeInterval)
        let attributedText = createAttributedText(timeText: timeText, counter: counter)
        
        timeLabel.attributedText = attributedText
    }
    
    private func formatTimeInterval(_ timeInterval: Int) -> String {
        let seconds = timeInterval % 60
        let minutes = (timeInterval / 60) % 60
        let hours = (timeInterval / 3600) % 24
        let days = timeInterval / 86400
        
        var timeText = ""
        
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
        
        return timeText
    }
    
    private func createAttributedText(timeText: String, counter: Int) -> NSAttributedString {
        let clockIconAttachment = NSTextAttachment()
        clockIconAttachment.image = UIImage(systemName: "clock")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let clockIconString = NSAttributedString(attachment: clockIconAttachment)
        
        let imageIconAttachment = NSTextAttachment()
        imageIconAttachment.image = UIImage(systemName: "photo.on.rectangle")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let imageIconString = NSAttributedString(attachment: imageIconAttachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(clockIconString)
        mutableAttributedString.append(NSAttributedString(string: " \(timeText) - "))
        mutableAttributedString.append(imageIconString)
        mutableAttributedString.append(NSAttributedString(string: " \(counter)"))
        
        return mutableAttributedString
    }
    
    @objc func incrementCounter() {
        counter += 1
        updateTimeLabel()
    }
}
