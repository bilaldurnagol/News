//
//  WelcomeOnBoarding.swift
//  News
//
//  Created by Bilal Durnagöl on 29.10.2020.
//

import Foundation

class WelcomeOnBoarding {
    static let shared = WelcomeOnBoarding()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    
    func isNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
