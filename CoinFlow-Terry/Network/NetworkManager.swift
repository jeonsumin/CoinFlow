//
//  NetworkManager.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/21.
//

import Foundation

// NetworkManager 책임
//  - URLSession
//  - dataTask
//  - 리퀘스트에 대한 메소드 제공
//      - 코인 리스트
//      - 차트
//      - 뉴스

class NetworkManager {
    
    static let session = URLSession.shared
//
//    static func requestChartList(compeltion: @escaping ([Coin]) -> Void) {
//
//        let coinListUrl = URL(string: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG&tsyms=USD")!
//
//        let taskWithCoinListURL = session.dataTask(with: coinListUrl, completionHandler: { (data, response, error) in
//            let successRang = 200..<300
//
//            guard error == nil,
//                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successRang.contains(statusCode)
//            else {
//                return
//            }
//
//            guard let responseData = data else { return }
//
//            let decoder = JSONDecoder()
//            do{
//                let response = try decoder.decode(CoinListResponse.self, from: responseData)
//                print("success ::: \(response.raw.btc)")
//                let coinList = response.raw.allCoins()
//                compeltion(coinList)
//            }catch{
//                print("requestChartList err::: \(error.localizedDescription)")
//            }
//
//
//        })
//
//        taskWithCoinListURL.resume()
//    }
//
//    static func requestCoinChartData (compeltion:@escaping ([ChartData]) -> Void) {
//
//        let coinChartDataURL = URL(string: "https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=24")!
//
//        let taskWithCoinChartURL = session.dataTask(with: coinChartDataURL, completionHandler: { (data, response, error) in
//            let successRang = 200..<300
//
//            guard error == nil,
//                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successRang.contains(statusCode)
//            else {
//                return
//            }
//
//            guard let responseData = data else { return }
//
//            let decoder = JSONDecoder()
//
//            do{
//                let response = try decoder.decode(ChartDataResponse.self, from: responseData)
//                let chartDatas = response.chartDatas
//                compeltion(chartDatas)
//            }catch{
//                print("requestCoinChartData err::: \(error.localizedDescription)")
//            }
//
//
//        })
//
//        taskWithCoinChartURL.resume()
//    }
//
//    static func requestNewsList(compeltion: @escaping ([Article]) -> Void){
//
//        let newsUrl = URL(string: "http://coinbelly.com/api/get_rss")!
//
//        let urlSession = session.dataTask(with: newsUrl, completionHandler: { (data, response, error) in
//            let successRang = 200..<300
//
//            guard error == nil,
//                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successRang.contains(statusCode)
//            else { return }
//
//            guard let responseData = data else { return }
//
//            let decoder = JSONDecoder()
//            do{
//                let response = try decoder.decode([NewsResponse].self, from: responseData)
//                let articles = response.flatMap { $0.articleArray }
//                compeltion(articles)
//            }catch{
//                print("requestNewsList err::: \(error.localizedDescription)")
//            }
//
//
//        })
//        urlSession.resume()
//
//    }
//
}


extension NetworkManager {
    
    static func requestChartList(compeltion: @escaping (Result<[Coin], Error>) -> Void) {

        let param: RequestParam = .url(["fsyms" : "BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG", "tsyms":"USD"])
        guard let coinListUrl = CoinListRequest(param: param).urlRequest().url else { return }
        
        let taskWithCoinListURL = session.dataTask(with: coinListUrl) { (data, response, error) in
            
            if let error = error {
                compeltion(.failure(error))
                return
            }
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(CoinListResponse.self, from: responseData)
                let coinList = response.raw.allCoins()
                compeltion(.success(coinList))
            }catch{
                print("requestChartList err::: \(error.localizedDescription)")
                compeltion(.failure(error))
            }
        }

        taskWithCoinListURL.resume()
    }
    
    static func requestCoinChartData (coinType: CoinType, period: Period, compeltion:@escaping (Result<[ChartData], Error>) -> Void) {
        
        let param: RequestParam =
//            .url(["fsym" : "BTC", "tsym":"USD","limit":"24"])
            .url(["fsym" : "\(coinType.rawValue)",
                  "tsym" : "USD",
                  "limit": "\(period.limitParameter)",
                  "aggregate" : "\(period.aggregateParameter)"
                    ])
        
        
        guard let CoinChartURL = CoinChartDataRequest(period: .day, param: param).urlRequest().url else { return }

        let taskWithCoinChartURL = session.dataTask(with: CoinChartURL){ (data, response, error) in
            
            if let error = error {
                compeltion(.failure(error))
                return
            }
            
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            
            do{
                let response = try decoder.decode(ChartDataResponse.self, from: responseData)
                let chartDatas = response.chartDatas
                compeltion(.success(chartDatas))
            }catch{
                print("requestCoinChartData err::: \(error.localizedDescription)")
                compeltion(.failure(error))
            }
        }

        taskWithCoinChartURL.resume()
    }
    
    static func requestNewsList(compeltion: @escaping (Result<[Article],Error>) -> Void){
        
        guard let newsUrl = newsListRequest().urlRequest().url else { return }

        let taskWithNewsURL = session.dataTask(with: newsUrl, completionHandler: { (data, response, error) in
            
            if let error = error {
                compeltion(.failure(error))
                return
            }
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode([NewsResponse].self, from: responseData)
                let articles = response.flatMap { $0.articleArray }
                compeltion(.success(articles))
            }catch{
                print("requestNewsList err::: \(error.localizedDescription)")
                compeltion(.failure(error))
            }
        })
        taskWithNewsURL.resume()
    }
}
