//
//  ChooseCurrencyDelegate.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation

protocol ChooseCurrencyDelegate: AnyObject {
    
    func didChooseFromCurrency(currency: String)
    
    func didChooseToCurrency(currency: String)
}
