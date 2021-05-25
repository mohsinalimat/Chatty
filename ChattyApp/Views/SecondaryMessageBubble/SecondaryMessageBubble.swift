//
//  SecondaryMessageBubble.swift
//  ChattyApp
//
//  Created by Kristopher Jackson on 5/23/21.
//

import UIKit

class SecondaryMessageBubble: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak private var textView: RoundedTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(text: String?) {
        self.textView.text = text
    }
    
    public func set(date: Date?) {
        
        guard let date = date else {
            self.dateLabel.text = ""
            return
        }
        
        if Calendar.current.isDateInToday(date) {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            self.dateLabel.text = "Today \(formatter.string(from: date))"
            
        } else if Calendar.current.isDateInYesterday(date) {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            self.dateLabel.text = "Yesterday \(formatter.string(from: date))"
            
        } else {
            
            let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())
            
            if let day = interval.day, day < 7 {
                
                let index = Calendar.current.component(.weekday, from: date)
                let dayOfWeek = Calendar.current.weekdaySymbols[index - 1]
                
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                self.dateLabel.text = "\(dayOfWeek) \(formatter.string(from: date))"
                
            } else {
        
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                self.dateLabel.text = formatter.string(from: date)
                
            }
            
        }
    }
}
