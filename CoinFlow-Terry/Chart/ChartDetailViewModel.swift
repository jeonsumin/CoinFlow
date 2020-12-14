//
//  ChartDetailViewModel.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/12/06.
//

import UIKit

class ChartDetailViewModel {
    typealias Handler = ([coinChartInfo], Period) -> Void
    var changeHandler: Handler
    
    
    var coinInfo : CoinInfo!
    var chartDatas: [coinChartInfo] = []
    var selectedPeriod: Period = .day
    
    
    init(coinInfo: CoinInfo, chartDatas: [coinChartInfo], selectedPeriod: Period, changeHandler: @escaping Handler) {
        self.coinInfo = coinInfo
        self.chartDatas = chartDatas
        self.selectedPeriod = selectedPeriod
        self.changeHandler = changeHandler
    }
}

extension ChartDetailViewModel {
    func fatchDate(){
        let dispatchGroup = DispatchGroup()
        // Period 의 CaseIterable 프로퍼티를 통해서 allCases를 사용할 수 있는데 이를 통해 forEach로 day, week, month, year의 필요한 데이터를 호출 할 수 있다.
        Period.allCases.forEach { period in
            dispatchGroup.enter()
            NetworkManager.requestCoinChartData(coinType: coinInfo.key, period: period) { (result) in
                dispatchGroup.leave()
                switch result {
                case .success(let coinChartDatas):
                    //                    print("--> coin Chart data Count ::: \(coinChartDatas.count)")
                    self.chartDatas.append(coinChartInfo(key: period, value: coinChartDatas))
                case .failure(let err):
                    print("--> err::: \(err.localizedDescription)")
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.changeHandler(self.chartDatas, self.selectedPeriod)
        }
    }
    
    func updateNotify(handler: @escaping Handler){
        self.changeHandler = handler
    }
}
