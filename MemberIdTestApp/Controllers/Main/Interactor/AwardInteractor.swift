//
//  ImageInteractor?.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import SwiftyJSON

class AwardInteractor: BaseInteractor {
    
    var currentPage = 0
    
    open var hasNext: Bool {
        return currentPage != -1
    }
    
    var items: [Award] = [Award]()
    var totalData: Int = 0
    
    func load(withCompletion completion: (() -> Void)? = nil) {
        items.removeAll()
        if let key = storeKey,
            let keyedValue = realm.object(ofType: KeyedValue.self, forPrimaryKey: key as AnyObject),
            let value = keyedValue.value {
            let json = JSON.parse(value)
            for child in json.arrayValue {
                if let item = realm.object(ofType: (Award.self), forPrimaryKey: child.rawValue as AnyObject) {
                    items.append(Award(value: item))
                }
            }
        }
    }
    
    func refresh(success: @escaping () -> (Void), failure: @escaping (NSError) -> (Void)) {
        currentPage = 1
        nextWith(success: success, failure: failure)
    }
    
    func nextWith(success: @escaping () -> (Void), failure: @escaping (NSError) -> (Void)) {
        service.getImages(params: params, page: currentPage, perPage: perPage, success: { pagination  in
            
            if pagination.currentPage == 1 {
                self.items.removeAll()
            }
            if pagination.currentPage >= pagination.lastPage {
                self.currentPage = -1
            } else {
                self.currentPage = pagination.currentPage + 1
            }
            
            self.items.append(contentsOf: pagination.data)
            self.totalData = pagination.total
            print("itemsitemsitems : \(self.items.count)")
            success()
        }, failure: { error in
            failure(error)
        })
        
    }

}
