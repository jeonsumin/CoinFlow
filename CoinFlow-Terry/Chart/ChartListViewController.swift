//
//  ChartListViewController.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/07.
//

import UIKit

typealias CoinInfo = (key: CoinType, value: Coin)

class ChartListViewController: UIViewController {
    
    @IBOutlet weak var chartCollectionView: UICollectionView!
    @IBOutlet weak var chartTableView: UITableView!
    @IBOutlet weak var chartTableViewHeight: NSLayoutConstraint!
    
    //    var coinInfoList: [(key:CoinType, value: Coin)] = [] 이렇게도 사용할 수 있지만 Typealias를 사용하여 타입을 지정 하여 사용
    var coinInfoList: [CoinInfo] = [] {
        didSet{
            // coinInfoList 가 세팅이 되었을때 -> tableView reload()
            DispatchQueue.main.async {
                self.chartTableView.reloadData()
                self.adjustTableViewHeight() // 데이터가 들어왔으므로 height 재정의
            }
        }
    }
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.requestChartList { (result: Result<[Coin], Error>) in
            switch result {
            case .success(let coins):
                // cell, -> coin + coin 정보
                // ㄴ> coinType+ coins -> [(BTC,coin),(ETH,coin)] 배열로 조합위해 zip 메소드 사용
                
                let tuples = zip(CoinType.allCases, coins).map{ (key: $0, value: $1)}
                self.coinInfoList = tuples
                
            case .failure(let err):
                print("error ::: \(err.localizedDescription)")
                
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustTableViewHeight()
    }
}

//MARK:- Priavte Method
extension ChartListViewController {
    
    //scrollView에 tableView올려 높이를 지정하니 필요없는 여백이 생겼음 이 시점에 테이블 뷰 contentsize 파악 후 , tableView 높이를 조정
    private func adjustTableViewHeight(){
        chartTableViewHeight.constant = chartTableView.contentSize.height
    }
    
    private func showDetail(coinInfo : CoinInfo){
        //TODO:- Detail view로 푸쉬하자
        // - Detail VC 인스턴스
        // - NavigationVC 푸쉬 시키기

        //스토리보드를 나눠놨기 때문에 해당 스토리보드를 지정해줘야한다.
        let storyboard = UIStoryboard(name: "Chart", bundle: .main)
        if let chartDetailVC = storyboard.instantiateViewController(identifier: "ChartDetailViewController") as? ChartDetailViewController {
//            chartDetailVC.coinInfo = coinInfo
            
            chartDetailVC.viewModel = ChartDetailViewModel(coinInfo: coinInfo, chartDatas: [], selectedPeriod: .day, changeHandler: { _ ,_ in
            })
            navigationController?.pushViewController(chartDetailVC, animated: true)
        }
    }
}

// MARK:- CollectionView
extension ChartListViewController: UICollectionViewDataSource {
    
    //TODO: 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //TODO: 셀의 데이터 표시
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCardCell", for: indexPath) as? ChartCardCell else{ return UICollectionViewCell() }
        
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

extension ChartListViewController: UICollectionViewDelegateFlowLayout{
    //MARK: cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = collectionView.bounds.width - 20 * 2 - 15
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}

class ChartCardCell : UICollectionViewCell{
    
}

//MARK:- TableView
extension ChartListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartListCell", for: indexPath) as? ChartListCell else{ return UITableViewCell()}
        let coinInfo = coinInfoList[indexPath.row]
        cell.configCell(coinInfo)
        return cell
    }
}

extension ChartListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // detail view data 전달 하고 viewdetail 이동
        let coinInfo = coinInfoList[indexPath.row]
        showDetail(coinInfo: coinInfo)
    }
}

