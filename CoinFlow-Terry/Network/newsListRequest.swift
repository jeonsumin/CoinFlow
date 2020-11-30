//
//  newsListRequest.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/24.
//

import Foundation

struct newsListRequest : Request {
    
    var method: HTTPMethod = .get
    var path: String { return EndPoint.newsList}
    var params: RequestParam

    init(param: RequestParam = .url([:])) {
        self.params = param
    }
}
