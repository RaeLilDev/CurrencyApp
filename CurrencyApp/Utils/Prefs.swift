//
//  Prefs.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/10/22.
//

import Foundation

class Prefs {
    
    static let shared = Prefs()
    
    let defaults = UserDefaults.standard
    
    func saveUpdatedTime() {
        defaults.setValue(Date().timeIntervalSince1970, forKey: AppConstants.updatedTime)
    }
    
    func getUpdatedTime() -> Double {
        
        defaults.double(forKey: AppConstants.updatedTime)
        
    }
    
}
