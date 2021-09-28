//
//  DateConverter.swift
//  weecare-ios-challenge
//
//  Created by Richard on 9/28/21.
//

import Foundation

class DateConverter {

    let dateFormatter = DateFormatter()

    func convertDatesWithUniqueFormatter(dateString: String) -> Date? {
        let isoDate = dateString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from:isoDate) {
            return date
        } else {
            return nil
        }
    }
}
