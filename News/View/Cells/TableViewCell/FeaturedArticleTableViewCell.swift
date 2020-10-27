//
//  FeaturedArticleTableViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit
import SDWebImage

class FeaturedArticleTableViewCell: UITableViewCell {
    
    
    static let identifier = "FeaturedArticleTableViewCell"
    
    
    private let featuredArticleView: UIView = {
        let articleView = UIView()
        articleView.clipsToBounds = true
        articleView.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        articleView.layer.cornerRadius = 50.0
        return articleView
    }()
    
    private let featuredArticleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Article")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.50
        return imageView
    }()
    
    private let featuredArticleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Medium", size: 22)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let featuredArticlePublishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        contentView.addSubview(featuredArticleView)
        
        
        featuredArticleView.addSubview(featuredArticleImageView)
        featuredArticleView.addSubview(featuredArticleTitleLabel)
        featuredArticleView.addSubview(featuredArticlePublishedAtLabel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        featuredArticleView.frame = CGRect(x: 0,
                                           y: 20,
                                           width: contentView.width - 25,
                                           height: 273)
        
        featuredArticleTitleLabel.frame = CGRect(x: 25,
                                                 y: 32,
                                                 width: featuredArticleView.width - 50,
                                                 height: 53)
        
        featuredArticlePublishedAtLabel.frame = CGRect(x: 25,
                                                       y: featuredArticleTitleLabel.top + 63,
                                                       width: featuredArticleView.width - 25,
                                                       height: 20)
        
        featuredArticleImageView.frame = CGRect(x: 0,
                                                y: 0,
                                                width: featuredArticleView.width,
                                                height: featuredArticleView.height)
        
    }
    
    func configure(article: Article) {
        self.featuredArticleTitleLabel.text = article.title
        self.featuredArticleImageView.sd_setImage(with: URL(string: article.urlToImage ?? "nil"), completed: nil)
        self.featuredArticlePublishedAtLabel.text = article.publishedAt?.stringToPublishedAt()
        
    }
    
    
}
