//
//  CoreService.swift
//  MemberIdTestApp
//
//  Created by Dedy Yuristiawan on 17/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import Alamofire

open class CoreService: NSObject {
    
    public static let instance = CoreService()
    
    public var manager = AppSessionManager()
    
    public var home = ""
    
    public var path: String {
        return ""
    }
    public func setup(home: String) {
        self.home = home
    }
    
}

open class AppSessionManager: SessionManager {
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.urlCache?.removeAllCachedResponses()
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.urlCache = nil
        self.init(configuration:configuration)
    }
    
    override open func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        do {
            let urlRequest = URLRequest(url: try url.asURL())
            let request = try! encoding.encode(urlRequest, with: parameters)
            URLCache.shared.removeCachedResponse(for: urlRequest)
            print("\n➡️[\(method.rawValue)]\(request)")
        } catch {
            print("❌ Error URL Request")
        }
        return super.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    override open func download(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequest {
        do {
            let urlRequest = URLRequest(url: try url.asURL())
            let request = try! encoding.encode(urlRequest, with: parameters)
            URLCache.shared.removeCachedResponse(for: urlRequest)
            print("[\(method.rawValue)] \(request)")
        } catch {
            print("Error URL Request")
        }
        return super.download(url, method: method, parameters: parameters, encoding: encoding, headers: headers, to: destination)
    }
}

public struct Pagination<T> {
    public let total: Int
    public let currentPage: Int
    public let lastPage: Int
    public let data: T
    
    public init(total: Int, currentPage: Int, lastPage: Int, data: T) {
        self.total = total
        self.currentPage = currentPage
        self.lastPage = lastPage
        self.data = data
    }
}

public enum APIResult<T> {
    case success(T)
    case failure(NSError)
}

public class SessionManagerApp: AppSessionManager {
    
    override public func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        var overidedParameters = [String: AnyObject]()
        if let parameters = parameters {
            for (key, value) in parameters {
                overidedParameters[key] = value as AnyObject?
            }
        }
        URLCache.shared.removeAllCachedResponses()
        return super.request(url, method: method, parameters: overidedParameters, encoding: encoding, headers: headers)
    }
    
    public override func download(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequest {
        var overidedParameters = [String: AnyObject]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                overidedParameters[key] = value as AnyObject?
            }
        }
        URLCache.shared.removeAllCachedResponses()
        return super.download(url, method: method, parameters: overidedParameters, to: destination)
    }
}
