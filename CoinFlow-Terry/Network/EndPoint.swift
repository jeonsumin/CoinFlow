//
//  EndPoint.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/24.
//

import Foundation

// 3가지 네트워크 요청 URL


// basic Path 를 EndPoint로 지정
enum EndPoint {
    static let coinList     : String        = "https://min-api.cryptocompare.com/data/"
    static let coinChartData: String        = "https://min-api.cryptocompare.com/data/"
    static let newsList     : String        = "http://coinbelly.com/api/get_rss"
}
