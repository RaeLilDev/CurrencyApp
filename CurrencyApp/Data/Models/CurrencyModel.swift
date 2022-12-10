//
//  CurrencyModel.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation

protocol CurrencyModel {
    
    func getCurrencyList(completion: @escaping(CRYResult<[CurrencyVO]>) -> Void)
    
    func getCurrencyConvertData(from: String, to: String, amount: Int, completion: @escaping(CRYResult<CurrencyConvertVO>) -> Void)
    
    func getLiveExchangeRateList(getState: String, completion: @escaping(CRYResult<[LiveExchangeRateVO]>) -> Void)
}

class CurrencyModelImpl: BaseModel, CurrencyModel {
    
    private let currencyRepository: CurrencyRepository = CurrencyRepositoryImpl.shared
    
    static let shared = CurrencyModelImpl()
    
    private override init() { }
    
    func getCurrencyList(completion: @escaping (CRYResult<[CurrencyVO]>) -> Void) {
        networkAgent.getCurrencyList { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(.success(data.toCurrencyVOArray().sorted(by: {$0.key ?? "" < $1.key ?? ""})))
                
            case .failure(let message):
                completion(.failure(message))
            }
        }
    }
    
    func getCurrencyConvertData(from: String, to: String, amount: Int, completion: @escaping (CRYResult<CurrencyConvertVO>) -> Void) {
        networkAgent.getCurrencyConvertData(from: from, to: to, amount: amount) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let message):
                completion(.failure(message))
            }
        }
    }
    
    func getLiveExchangeRateList(getState: String, completion: @escaping(CRYResult<[LiveExchangeRateVO]>) -> Void) {
        
        if getState == "network" {
            networkAgent.getLiveExchangeRateList { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    let exchangeRateArray = data.toLiveExchangeRateArray()
                    self.currencyRepository.saveLiveExchangeList(data: exchangeRateArray)
                    completion(.success(exchangeRateArray.sorted(by: {$0.to < $1.to })))
                    
                case .failure(let message):
                    completion(.failure(message))
                }
            }
        } else {
            currencyRepository.getLiveExchangeRateList { completion(.success($0)) }
        }
        
        
        
    }
    
    
    
    
}
