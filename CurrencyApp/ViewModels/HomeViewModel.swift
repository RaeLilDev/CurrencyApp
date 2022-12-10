//
//  HomeViewModel.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import RxSwift
import RxCocoa

enum HomeViewState {
    
    case successCurrencyConvert
    
    case successFetchingLiveExchangeRate
    
    case invalidInput(message: String)
    
    case failure(message: String)
    
}

class HomeViewModel {
    
    var viewState = BehaviorRelay<HomeViewState?>(value: nil)
    
    private var currencyModel: CurrencyModel!
    
    private var currencyConvert: CurrencyConvertVO!
    private var liveExchangeRateList = [LiveExchangeRateVO]()
    
    init(currencyModel: CurrencyModel) {
        self.currencyModel = currencyModel
    }
    
    func fetchCurrencyConvertData(from: String, to: String, amount: Int) {
        
        currencyModel.getCurrencyConvertData(from: from, to: to, amount: amount) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.currencyConvert = data
                self.viewState.accept(.successCurrencyConvert)
                
            case .failure(let message):
                self.viewState.accept(.failure(message: message))
            }
        }
    }
    
    
    func fetchLiveExchangeRateList(getState: String) {
        currencyModel.getLiveExchangeRateList(getState: getState) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.liveExchangeRateList = data
                self.viewState.accept(.successFetchingLiveExchangeRate)
                
            case .failure(let message):
                self.viewState.accept(.failure(message: message))
            }
            
        }
    }
    
    func fetchExchangeRateWithTime() {
        
        let current = Date().timeIntervalSince1970
        let stored  = Prefs.shared.getUpdatedTime()
        
        if stored == 0 || current - stored >= 1800 {
            Prefs.shared.saveUpdatedTime()
            self.fetchLiveExchangeRateList(getState: "network")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
                self.fetchExchangeRateWithTime()
            }
            
        } else {
            
            self.fetchLiveExchangeRateList(getState: "realm")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
                self.fetchExchangeRateWithTime()
            }
        }
    }
    
    
    func validateInputAndConvertCurrency(from: String, to: String, amount: String) {
        
        if amount.isEmpty {
            self.viewState.accept(.invalidInput(message: "Please fill amount to convert currency."))
        } else if Int(amount) ?? 0 < 1 {
            self.viewState.accept(.invalidInput(message: "Please fill amount greater than zero."))
        } else {
            fetchCurrencyConvertData(from: from, to: to, amount: Int(amount) ?? 1)
        }
    }
    
    func getConvertResult() -> Double {
        currencyConvert.result ?? 0.0
    }
    
    func getLiveExchangeRate(by index: Int) -> LiveExchangeRateVO {
        return liveExchangeRateList[index]
    }
    
    
    func getLiveExchangeRateListCount() -> Int {
        return liveExchangeRateList.count
    }
    
 }
