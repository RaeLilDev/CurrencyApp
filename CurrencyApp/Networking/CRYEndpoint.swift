//
//  CRYEndpoint.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import Alamofire

enum CRYEndpoint: URLConvertible {
    
    case currencyList
    
    case currencyConvert(_ from: String, _ to: String, _ amount: Int)
    
    case liveExchangeRate
    
    private var baseURL: String {
        return AppConstants.baseURL
    }
    
    func asURL() throws -> URL {
        return url
    }
    
    var url: URL {
        let urlComponents = NSURLComponents(string: baseURL.appending(apiPath))
        
        if (urlComponents?.queryItems == nil) {
            urlComponents!.queryItems = []
        }
        urlComponents!.queryItems!.append(contentsOf: [URLQueryItem(name: "apikey", value: AppConstants.apiKey)])
        
        return urlComponents!.url!
    }
//
//    var url: URL {
//        let urlComponents = NSURLComponents(string: baseURL.appending(apiPath))
//
//
//
//        return urlComponents!.url!
//    }
    
    private var apiPath: String {
        switch self {
        case .currencyList:
            return "list"
            
        case .currencyConvert(let from, let to, let amount):
            return "convert?from=\(from)&to=\(to)&amount=\(amount)"
            
        case .liveExchangeRate:
            return "live"
            
        }
    }
}


