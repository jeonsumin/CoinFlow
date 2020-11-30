//
//  Request.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/24.
//

import Foundation

enum HTTPMethod :String {
    case get = "GET"
    case post  = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
    
    var name : String {
        return self.rawValue
    }
}

enum RequestParam {
    case url([String:String])
    case body([String:String])
}


protocol Request {
    var path   : String{ get }
    var method : HTTPMethod{ get }
    var params : RequestParam{ get }
    var format : String? { get }
    var headers: [String]? { get }
}

extension Request {
    var method: HTTPMethod { return .get}
    var format: String? { return "application/json" }
    var headers: [String]? { return ["Content-Type","Accept"] }
    
    //Request 해야하는 목표 : URL 생성 , URLRequest 생성
    func urlRequest() -> URLRequest {
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        
        //http method
        request.httpMethod = method.name
        
        // header
        headers?.forEach { headerField  in
            request.setValue(format, forHTTPHeaderField: headerField)
        }
        
        // config param
        switch params {
        case .body(let param):
            let bodyData = try? JSONSerialization.data(withJSONObject: param, options: [])
            if let data = bodyData {
                request.httpBody = data
            }
        case .url(let param):
            let queryParam = param.map { URLQueryItem(name: $0.key, value: $0.value)}
            var components = URLComponents(string: path)
            components?.queryItems = queryParam
            request.url = components?.url
        }
        
        return request
    }
}
