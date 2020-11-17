//
//  StringExtension.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import Foundation

extension String {
    
    func safeURL() -> String {
        let safeURL = self.replacingOccurrences(of: "/", with: "_")
        return safeURL
    }
    
    func safeURLImage() -> String {
       let parts = self.split(separator: ";")
        let safeURL = parts[0]
        return String(safeURL)
    }
    
//    func stringToPublishedAt() -> String {
//        let dateFormatter = DateFormatter()
//        let tempLocale = dateFormatter.locale
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"
//        let date = dateFormatter.date(from: self)!
//        dateFormatter.dateFormat = "d MMM | HH:mm"
//        dateFormatter.locale = tempLocale
//        let dateString = dateFormatter.string(from: date)
//        return "\(dateString)"
//    }
}
