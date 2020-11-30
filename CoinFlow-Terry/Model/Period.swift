//
//  Period.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/24.
//

import Foundation

enum Period: String, CaseIterable {
    case day
    case week
    case month
    case year
    
    var urlPath : String {
        switch self {
        case .day, .week:
            return "histohour"
        default:
            return "histoday"
        }
    }
    
    var limitParameter: Int {
        switch self {
        case .day:
            //hour
            return 24
        case .week:
            //weak 도 시간단위로 가져오기 때문에 계산 하여 주단위 데이터 가져오기
            // hour 24 * 7 (> 24 * 7 / (aggregate factor))
            return 7 * 24 / 2
        case .month:
            //day
            return 30 / 1
        case .year:
            // day /arggregate factor
            return 365 / 10
        
        }
    }
    //aggregate :: 집합, 통계량
    var aggregateParameter: Int {
        switch self {
        case .day:
            return 1
        case .week:
            return 2 //1
        case .month:
            return 1
        case .year:
            return 10
        }
    }
}
