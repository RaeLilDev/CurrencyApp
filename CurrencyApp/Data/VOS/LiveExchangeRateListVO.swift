//
//  LiveExchangeRateListVO.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation

struct LiveExchangeRateListVO: Codable {
    
    let success: Bool?
    let timestamp: Int?
    let source: String?
    let quotes: [String: Double]?
    
    func toLiveExchangeRateArray() -> [LiveExchangeRateVO] {
        
        var liveExchangeRateArray = [LiveExchangeRateVO]()
        quotes?.forEach{
            let object = LiveExchangeRateVO()
            object.id = $0.key
            object.from = String($0.key.prefix(3))
            object.to = String($0.key.suffix(3))
            object.rate = $0.value
            liveExchangeRateArray.append(object)
        }
        return liveExchangeRateArray
        
    }
    
}
