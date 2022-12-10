//
//  LiveExchangeRateVO.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import RealmSwift

class LiveExchangeRateVO: Object, Codable {
    
    @Persisted(primaryKey: true)
    var id: String
    
    @Persisted
    var from: String
    
    @Persisted
    var to: String
    
    @Persisted
    var rate: Double
    
}
