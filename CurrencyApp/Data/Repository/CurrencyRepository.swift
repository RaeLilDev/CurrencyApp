//
//  CurrencyRepository.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import Foundation
import RealmSwift

protocol CurrencyRepository {
    
    func saveLiveExchangeList(data: [LiveExchangeRateVO])
    
    func getLiveExchangeRateList(completion: @escaping([LiveExchangeRateVO]) -> Void)
    
}

class CurrencyRepositoryImpl: BaseRepository, CurrencyRepository {
    
    static let shared: CurrencyRepository = CurrencyRepositoryImpl()
    
    private override init() {}
    
    func saveLiveExchangeList(data: [LiveExchangeRateVO]) {
        let objects = List<LiveExchangeRateVO>()
        
        objects.append(objectsIn: data)
        
        try! realmInstance.db.write {
            realmInstance.db.add(objects, update: .modified)
        }
    }
    
    func getLiveExchangeRateList(completion: ([LiveExchangeRateVO]) -> Void) {
        let liveExhangeRateObjects = realmInstance.db.objects(LiveExchangeRateVO.self)
        completion(Array(liveExhangeRateObjects).sorted(by: {$0.to < $1.to} ))
    }
    
}
