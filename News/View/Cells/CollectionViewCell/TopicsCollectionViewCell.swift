//
//  TopicsCollectionViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit

protocol TopicsCollectionViewCellDelegate {
    func chooseTopic(articles: ArticleListViewModel)
}

class TopicsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopicsCollectionViewCell"
    var topicArticleList: [Article]?
    var delegate: TopicsCollectionViewCellDelegate?
    var topicArticleListVM: ArticleListViewModel!
    private let regionCode = UserDefaults.standard.value(forKey: "regionCode")
    
    let topicButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SFCompactDisplay-Medium", size: 17)
        button.layer.masksToBounds = true
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(topicButton)
        contentView.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        topicButton.addTarget(self, action: #selector(didTapTopicButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topicButton.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
        
        topicButton.layer.cornerRadius = topicButton.height/2
    }
    
    public func configure(topic: String, row: Int) {
        
        if row % 3 == 1 {
            self.topicButton.backgroundColor = UIColor(red: 255/255,
                                                       green: 162/255,
                                                       blue: 0/255,
                                                       alpha: 1)
        }else if row % 3 == 2 {
            self.topicButton.backgroundColor = UIColor(red: 255/255,
                                                       green: 85/255,
                                                       blue: 0/255,
                                                       alpha: 1)
        } else if row % 3 == 0 {
            self.topicButton.backgroundColor = UIColor(red: 45/255,
                                                       green: 95/255,
                                                       blue: 255/255,
                                                       alpha: 1)
        }
        self.topicButton.setTitle(topic, for: .normal)
        
    }
    @objc func didTapTopicButton() {
        guard let topic = topicButton.titleLabel?.text else {
            return
        }
        
        guard let safeRegionCode = regionCode else {
            return
        }
        guard let url = URL(string: "http://127.0.0.1:5000/articles/\(safeRegionCode)/\(topic.lowercased())") else {
            return
        }
        
        WebService.shared.getArticles(url: url, completion: {result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let articles):
                if let articles = articles {
                    self.topicArticleListVM = ArticleListViewModel(articles: articles)
                    if let delegate = self.delegate {
                        delegate.chooseTopic(articles: self.topicArticleListVM!)
                    }
                }
            }
        })
    }
}
