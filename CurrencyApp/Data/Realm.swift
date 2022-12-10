//
//  Realm.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import RealmSwift

class CurrencyRealm: NSObject {
    
    static let shared = CurrencyRealm()
    
    let db = try! Realm()
    
    override init() {
        
        super.init()
        
        print("Default Realm is at \(db.configuration.fileURL?.absoluteString ?? "undefined")")
    }
}
