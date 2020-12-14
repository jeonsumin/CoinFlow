//
//  NewsListCell.swift
//  CoinFlow-Terry
//
//  Created by Terry on 2020/12/06.
//

import UIKit

class newsListCell :UITableViewCell {
    @IBOutlet weak var thumbnail : UIImageView!
    @IBOutlet weak var newsTitle : UILabel!
    @IBOutlet weak var newsDate  : UILabel!
    
    func configCell(article: Article){
        let url = URL(string: article.imageURL)
        thumbnail.kf.setImage(with: url)
        
        newsTitle.text = article.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        newsDate.text = formatter.string(from: Date(timeIntervalSince1970: article.timestamp))
    }
}
