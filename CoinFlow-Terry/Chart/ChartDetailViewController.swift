//
//  ChartDetailViewController.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/07.
//

import UIKit

class ChartDetailViewController: UIViewController {
    
    var coinInfo : CoinInfo!
    
    @IBOutlet weak var coinTypeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var highlightBar: UIView!
    @IBOutlet weak var heighlightBarLeading: NSLayoutConstraint!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCoinInfo(coinInfo)
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("넘어온 데이터 ::: \(coinInfo.key)")
    }
    
    @IBAction func dailyButtonTapped(_ sender: UIButton) {
        moveHightlightBar(to: sender)
    }
    @IBAction func weeklyButtonTapped(_ sender: UIButton) {
        moveHightlightBar(to: sender)
    }
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        moveHightlightBar(to: sender)
    }
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        moveHightlightBar(to: sender)
    }
    
    
}

//MARK: private Method
extension ChartDetailViewController {
    
    private func fetchData(){
        NetworkManager.requestCoinChartData { result in
            switch result {
            case .success(let coinChart):
                print("--> coin Chart data Count ::: \(coinChart.count)")
            case .failure(let err):
                print("--> err::: \(err.localizedDescription)")
            }
        }
    }
    
    private func updateCoinInfo(_ coinInfo: CoinInfo) {
        coinTypeLabel.text = "\(coinInfo.key)"
        currentPriceLabel.text = String(format: "%.1f", coinInfo.value.usd.price)
    }
    
    private func moveHightlightBar(to button: UIButton){
        heighlightBarLeading.constant = button.frame.minX
    }
}
