//
//  CRYResult.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation

enum CRYResult<T> {
    case success(T)
    case failure(String)
}
