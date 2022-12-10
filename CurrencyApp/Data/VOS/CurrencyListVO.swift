//
//  CurrencyVO.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation

// MARK: - CurrencyVO
struct CurrencyListVO: Codable {
    
    let success: Bool?
    let currencies: [String: String]?
    
    func toCurrencyVOArray() -> [CurrencyVO] {
        var currencyArray = [CurrencyVO]()
        currencies?.forEach{
            currencyArray.append(CurrencyVO(key: $0.key, fullName: $0.value))
        }
        return currencyArray
    }
}

struct CurrencyVO {
    let key: String?
    let fullName: String?
}

