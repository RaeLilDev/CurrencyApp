//
//  CurrencyConvertVO.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation

struct CurrencyConvertVO: Codable {
    let success: Bool?
    let query: Query?
    let info: Info?
    let result: Double?
}

struct Info: Codable {
    let timestamp: Int?
    let quote: Double?
}


struct Query: Codable {
    let from, to: String?
    let amount: Int?
}
