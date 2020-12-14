//
//  NewsViewController.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/11/07.
//

import UIKit
import Kingfisher
import SafariServices


class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    var viewModel : NewsListViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsListViewModel(changeHandler: { article in
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        })
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
}
//MARK:- TableView
extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.cell(for: indexPath, at: tableView)
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = viewModel.article(at: indexPath)

        guard let articleURL = URL(string: article.link) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable =  true
        
        let safari = SFSafariViewController(url: articleURL, configuration: config)
        
        
        safari.preferredBarTintColor = UIColor.white
        safari.preferredControlTintColor = UIColor.systemBlue
        present(safari, animated: true, completion: nil)
    }
}

