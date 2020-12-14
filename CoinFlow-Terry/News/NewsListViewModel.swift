//
//  NewsListViewModel.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/12/06.
//

import UIKit


class NewsListViewModel {
    
    typealias Handler = ([Article]) -> Void
    
    var changeHandler: Handler
    var articles: [Article] = [] {
        didSet{
            changeHandler(articles)
            
        }
    }
    
    init(changeHandler: @escaping Handler){
        self.changeHandler = changeHandler
    }
}

extension NewsListViewModel {
    func fetchData(){
        NetworkManager.requestNewsList { result in
            switch result {
            case .success(let article):
                self.articles = article
            case .failure(let err):
                print("-->requestNewsList err ::: \(err.localizedDescription)")
            }
        }
    }
    
    var numberOfRowsInSection: Int {
        return articles.count
    }
    
    func cell(for indexPath : IndexPath, at tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell", for: indexPath) as? newsListCell else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        cell.configCell(article: article)
        
        return cell
    }
    
    func article(at indexPath: IndexPath) -> Article{
        let article = articles[indexPath.row]
        return article
    }
    
}
