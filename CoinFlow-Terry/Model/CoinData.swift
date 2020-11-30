//
//  CoinData.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/21.
//

import Foundation

// CaseInterble은 allcase를 뽑을 수 있는 프로토콜 제공 
enum CoinType: String, CaseIterable {
   case BTC
   case ETH
   case DASH
   case LTC
   case ETC
   case XRP
   case BCH
   case XMR
   case QTUM
   case ZEC
   case BTG
    
}


struct CoinListResponse: Codable {
    let raw : RawData
    
    enum CodingKeys: String,CodingKey {
        case raw = "RAW"
    }
}

struct RawData : Codable {
    let btc : Coin
    let eth : Coin
    let dash: Coin
    let ltc : Coin
    let etc : Coin
    let xrp : Coin
    let bch : Coin
    let xmr : Coin
    let qtum : Coin
    let zec : Coin
    let btg : Coin
    
    enum CodingKeys: String,CodingKey {
        case btc  = "BTC"
        case eth  = "ETH"
        case dash = "DASH"
        case ltc  = "LTC"
        case etc  = "ETC"
        case xrp  = "XRP"
        case bch  = "BCH"
        case xmr  = "XMR"
        case qtum = "QTUM"
        case zec  = "ZEC"
        case btg  = "BTG"
    }
}
extension RawData {
    // 전체 데이터 한번에 넘겨주도록 메소드 생성 
    func allCoins() -> [Coin] {
        return [btc,eth,dash,ltc,etc,xrp,bch,xmr,qtum,zec,btg]
    }
}
struct Coin :Codable {
    let usd: CurrencyInfo
    
    enum CodingKeys: String,CodingKey {
        case usd = "USD"
    }
}

struct CurrencyInfo: Codable {
    let price                   : Double
    let changeLast24H           : Double
    let changePercentLast24H    : Double
    let market                  : String
    
    enum CodingKeys: String,CodingKey {
        case price = "PRICE"
        case changeLast24H = "CHANGE24HOUR"
        case changePercentLast24H = "CHANGEPCT24HOUR"
        case market = "LASTMARKET"
    }
}
