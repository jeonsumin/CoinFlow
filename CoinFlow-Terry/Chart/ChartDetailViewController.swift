//
//  ChartDetailViewController.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/07.
//

import UIKit
import Charts

typealias coinChartInfo = (key: Period, value: [ChartData])
class ChartDetailViewController: UIViewController {
    
    var coinInfo : CoinInfo!
    
    //period, chart data
    var chartDatas: [coinChartInfo] = [] {
        didSet {
            
        }
    }
    
    var selectedPeriod: Period = .day
    
    @IBOutlet weak var coinTypeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var highlightBar: UIView!
    @IBOutlet weak var heighlightBarLeading: NSLayoutConstraint!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCoinInfo(coinInfo)
        fetchData() // chart Data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("넘어온 데이터 ::: \(coinInfo.key)")
    }
    
    @IBAction func dailyButtonTapped(_ sender: UIButton) {
        renderChart(with: .day)
        moveHightlightBar(to: sender)
    }
    @IBAction func weeklyButtonTapped(_ sender: UIButton) {
        renderChart(with: .week)
        moveHightlightBar(to: sender)
    }
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        renderChart(with: .month)
        moveHightlightBar(to: sender)
    }
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        renderChart(with: .year)
        moveHightlightBar(to: sender)
    }
    
    
}

//MARK: private Method
extension ChartDetailViewController {
    
    private func fetchData(){
        // TODO: 정보는 일단 다 가져와야 하고 어느 데이터가 먼저 오는지는 알 수 없어 4가지 데이터가 들어온 후에 차트에 렌더링 하기
        
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
            // -> chart randering
            print("render chart... \(self.chartDatas.count)")
            self.renderChart(with: self.selectedPeriod)
        }
    }
    
    private func updateCoinInfo(_ coinInfo: CoinInfo) {
        coinTypeLabel.text = "\(coinInfo.key)"
        currentPriceLabel.text = String(format: "%.1f", coinInfo.value.usd.price)
    }
    
    private func moveHightlightBar(to button: UIButton){
        heighlightBarLeading.constant = button.frame.minX
    }
    
    private func renderChart(with period: Period){
        //TODO: 선택된 Period로 차트 그리기
        print("rendering....\(period)")
    }
}
