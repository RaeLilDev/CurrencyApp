//
//  NetworkingAgent.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import Alamofire

protocol NetworkingAgent {
    func getCurrencyList(completion: @escaping(CRYResult<CurrencyListVO>) -> Void)
    
    func getCurrencyConvertData(from: String, to: String, amount: Int, completion: @escaping(CRYResult<CurrencyConvertVO>) -> Void)
    
    func getLiveExchangeRateList(completion: @escaping(CRYResult<LiveExchangeRateListVO>) -> Void)
}

class NetworkingAgentImpl: NetworkingAgent {
    
    static let shared = NetworkingAgentImpl()
    
    private init() {}
    
    func getCurrencyList(completion: @escaping (CRYResult<CurrencyListVO>) -> Void) {
        
        AF.request(CRYEndpoint.currencyList)
            .responseDecodable(of: CurrencyListVO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    completion(.failure(error.localizedDescription))
                }
            }
    }
    
    func getCurrencyConvertData(from: String, to: String, amount: Int, completion: @escaping(CRYResult<CurrencyConvertVO>) -> Void) {
        
        AF.request(CRYEndpoint.currencyConvert(from, to, amount))
            .responseDecodable(of: CurrencyConvertVO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure(error.localizedDescription))
                }
            }
    }
    
    func getLiveExchangeRateList(completion: @escaping(CRYResult<LiveExchangeRateListVO>) -> Void) {
        AF.request(CRYEndpoint.liveExchangeRate)
            .responseDecodable(of: LiveExchangeRateListVO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure(error.localizedDescription))
                }
            }
    }
    
    
    
}
