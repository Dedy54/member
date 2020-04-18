//
//  ProductCoreService+Extensions.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CoreService {
    
//    func getImages(params: [String : String], page: Int = 1, perPage: Int = 10, success: @escaping (Pagination<[Award]>) -> (Void), failure: @escaping (NSError) -> (Void)) {
//        var parameters: [String: AnyObject] = [:]
//        var headers: [String: String] = [:]
//        if let token = PreferenceManager.instance.token {
//            headers = ["Authorization": token]
//        }
//        for (key, value) in params {
//            parameters[key] = value as AnyObject?
//        }
//        parameters["page"] = page as AnyObject?
//        parameters["per_page"] = perPage as AnyObject?
//        let request = manager.request(home + path + "/search/photos", method: .get, parameters: parameters, headers: headers)
//        request.responseJSON { response in
//            switch response.result {
//            case let .success(value):
//                let json = JSON(value)
//                print("JSON \(json)")
//                let dataJson = json["results"]
//                let totalPages = json["total_pages"].intValue
//                let lastPage = json["total_pages"].intValue
//
//                var items = [Award]()
//
//                for itemJson in dataJson.arrayValue {
//                    if let item = Award.with(json: itemJson) {
//                        items.append(item)
//                    }
//                }
//
//                let when = DispatchTime.now() + 5.0
//                DispatchQueue.main.asyncAfter(deadline: when, execute: {
//                    let pagination = Pagination<[Award]>(total: totalPages, currentPage: page, lastPage: lastPage, data: items)
//                    success(pagination)
//                })
//
//            case .failure(_):
//                var error: NSError?
//
//                if !Reachability.isConnectedToNetwork() {
//                    error = NSError(domain: "App", code: 404, userInfo: nil)
//                } else {
//                    error = NSError(domain: "App", code: 500, userInfo: nil)
//                }
//
//                if let error = error {
//                    failure(error as NSError)
//                }
//            }
//        }
//    }
    
    func getImages(params: [String : String], page: Int = 1, perPage: Int = 10, success: @escaping (Pagination<[Award]>) -> (Void), failure: @escaping (NSError) -> (Void)) {
        var awards = [Award]()
        for _ in 1...10 {
            let award = Award()
            let awardtype = AwardsType.random()
            award.identifier = "".randomString(length: 10)
            award.title = "Card \(awardtype)".capitalized
            award.images = "https://images.unsplash.com/photo-1497366754035-f200968a6e72?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjc2MTU4fQ"
            award.awardsType = awardtype
            awards.append(award)
        }
        
        let when = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            let pagination = Pagination<[Award]>(total: 1000, currentPage: page, lastPage: 1000, data: awards)
            success(pagination)
        })
    }
    
}
