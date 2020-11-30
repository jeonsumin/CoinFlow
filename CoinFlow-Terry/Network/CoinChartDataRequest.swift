//
//  CoinChartDataRequest.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/24.
//

import Foundation

struct CoinChartDataRequest : Request {
    
    var method: HTTPMethod = .get
    var params: RequestParam
    var path: String

    init(period:Period, param: RequestParam) {
        self.path = EndPoint.coinChartData + period.urlPath
        self.params = param
    }
}
