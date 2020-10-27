//
//  StringExtension.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import Foundation

extension String {
    
    func stringToPublishedAt() -> String {
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "d MMM | HH:mm" ; //"dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here
        let dateString = dateFormatter.string(from: date)
        return "\(dateString)"
    }
}
