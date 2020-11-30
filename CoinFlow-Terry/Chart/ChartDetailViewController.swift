//
//  ChartDetailViewController.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/07.
//

import UIKit

class ChartDetailViewController: UIViewController {

    var coinInfo : CoinInfo!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.requestCoinChartData { result in
            switch result {
            case .success(let coinChart):
                print("--> coin Chart data Count ::: \(coinChart.count)")
            case .failure(let err):
                print("--> err::: \(err.localizedDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("넘어온 데이터 ::: \(coinInfo.key)")
    }
}
