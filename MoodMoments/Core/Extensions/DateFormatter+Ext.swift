//  DateFormatter+Ext.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import Foundation

extension DateFormatter {
    
    static let shortWeekday: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EE" // e.g., Mon, Tue
        return df
    }()
    
    static let monthAndYear: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "LLLL yyyy" // e.g., June 2025
        return df
    }()
    
    static let longDate: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long // e.g., June 24, 2025
        df.timeStyle = .none
        return df
    }()
}
