//
//  Extension+Date.swift
//  PTS Dictate
//
//  Created by Mohit Soni on 07/11/22.
//

import Foundation

extension Date {
    
    func getFormattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
}

extension String {
    
    func getDateFromFormattedString() -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.date(from: self) ?? Date()
    }
    
}
