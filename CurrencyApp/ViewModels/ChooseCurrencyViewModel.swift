//
//  ChooseCurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import RxSwift
import RxCocoa

enum ChooseCurrencyViewState {
    case successFetchingCurrencyList
    
    case failure(message: String)
}

class ChooseCurrencyViewModel {
    
    var viewState = BehaviorRelay<ChooseCurrencyViewState?>(value: nil)
    
    private var currencyModel: CurrencyModel!
    private var selectedCurrency: String!
    private var isFromCurrency: Bool!
    private var currencyList = [CurrencyVO]()
    
    init(currencyModel: CurrencyModel, selectedCurrency: String, isFromCurrency: Bool) {
        self.currencyModel = currencyModel
        self.selectedCurrency = selectedCurrency
        self.isFromCurrency = isFromCurrency
    }
    
    func fetchCurrencyList() {
        
        currencyModel.getCurrencyList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.currencyList = data
                self.viewState.accept(.successFetchingCurrencyList)
                
            case .failure(let message):
                self.viewState.accept(.failure(message: message))
            }
        }
    }
    
    func getCurrency(by index: Int) -> CurrencyVO {
        return currencyList[index]
    }
    
    func getCurrencyCount() -> Int {
        return currencyList.count
    }
    
    func isSelectedCurrency(by index: Int) -> Bool {
        return selectedCurrency == currencyList[index].key ?? ""
    }
    
    func setSelectedCurrency(by index: Int) {
        selectedCurrency = currencyList[index].key ?? ""
    }
    
    func isCurrencyStateFrom() -> Bool {
        return isFromCurrency
    }
    
    func getSelectedCurrency() -> String {
        return selectedCurrency
    }
    
}
