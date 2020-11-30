//
//  CoinListRequest.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/24.
//

import Foundation


struct CoinListRequest : Request {
    
    var method: HTTPMethod = .get
    var params: RequestParam
    var path: String { return EndPoint.coinList + "pricemultifull" }

    init(param: RequestParam) {
        self.params = param
    }
}
let request = CoinListRequest(param: .url(["fsym":"BTC"]))
