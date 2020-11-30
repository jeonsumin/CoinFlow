//
//  NewsViewController.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/07.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.requestNewsList { result in
            switch result {
            case .success(let article):
                print("--> article data count::: \(article.count)")
            case .failure(let err):
                print("--> err ::: \(err.localizedDescription)")
            }
            
        }
    }
}
//MARK:- TableView
extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell", for: indexPath) as? newsListCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}

class newsListCell :UITableViewCell {
    
}
