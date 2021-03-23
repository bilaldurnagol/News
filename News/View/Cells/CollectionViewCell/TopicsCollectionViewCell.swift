//
//  TopicsCollectionViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit

protocol TopicsCollectionViewCellDelegate {
    func chooseTopic(articles: [Article])
}

class TopicsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopicsCollectionViewCell"
    var topicArticleList: [Article]?
    var delegate: TopicsCollectionViewCellDelegate?
    var articles: [Article]?
    private let regionCode = UserDefaults.standard.value(forKey: "regionCode")
    
    let topicButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SFCompactDisplay-Medium", size: 17)
        button.layer.masksToBounds = true
        return button
    }()
    
    private let localhost = "host"
    
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
        var safeTopic = ""
        guard let topic = topicButton.titleLabel?.text else {
            return
        }
        switch topic {
        case "Genel":
            safeTopic = "General"
        case "İş":
            safeTopic = "Business"
        case "Sağlık":
            safeTopic = "Health"
        case "Bilim":
            safeTopic = "Science"
        case "Spor":
            safeTopic = "Sports"
        case "Teknoloji":
            safeTopic = "Technology"
        case "Eğlence":
            safeTopic = "Entertainment"
        default:
            print("Empty")
        }
        guard let regionCode = regionCode else {return}
        getArticles(url: "\(localhost)/articles/\(regionCode)/\(safeTopic.lowercased())")
    }
    
    
    //get all articles
    private func getArticles(url: String) {
        DatabaseManager.shared.getArticles(url: url, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let articles):
                guard let articles = articles else {return}
                strongSelf.articles = articles
                if let delegate = strongSelf.delegate {
                    delegate.chooseTopic(articles: strongSelf.articles!)
                }
            }
        })
    }
}
